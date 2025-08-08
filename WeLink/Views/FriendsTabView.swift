import SwiftUI
import SwiftData

// 카드 위치 저장용 PreferenceKey
struct CardPositionPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct FriendsTabView: View {
    @State private var showShareSheet = false
    @Environment(\.modelContext) private var context
    @Query private var cards: [CardModel]
    @State private var didInsertSample = false
    
    @State private var selectedIndex: Int = 0
    @State private var showSearchBar = false
    @State private var searchText = ""
    
    @State private var scrollViewProxy: ScrollViewProxy?

    // 카드 위로 올리는 애니메이션
    @GestureState private var dragOffset: CGFloat = 0
    @State private var cardOffsetY: CGFloat = 0

    // 삭제 알림 관련 상태
    @State private var showDeleteAlert = false
    @State private var cardToDelete: CardModel? = nil
    
    var filteredCards: [CardModel] {
        let baseCards: [CardModel]
        if searchText.isEmpty {
            baseCards = cards
        } else {
            baseCards = cards.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText) ||
                card.cardDescription.localizedCaseInsensitiveContains(searchText) ||
                card.mbti.localizedCaseInsensitiveContains(searchText) ||
                card.tag.localizedCaseInsensitiveContains(searchText)
            }
        }
        return baseCards.sorted { $0.dDay < $1.dDay }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                // 아래 + 버튼
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showShareSheet = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color("MainColor"))
                                .padding()
                        }
                        .padding(.bottom, 50)
                        .padding(.trailing, 20)
                    }
                }

                VStack(spacing: 0) {
                    HStack {
                        Text("친구")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showSearchBar.toggle()
                                if !showSearchBar {
                                    searchText = ""
                                }
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24))
                                .foregroundColor(Color("MainColor"))
                                .padding()
                        }
                        .contentShape(Rectangle())
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                    .background(Color.white.opacity(0.8))

                    if showSearchBar {
                        TextField("검색어 입력", text: $searchText, onCommit: {
                            if !searchText.isEmpty, let firstFilteredCard = filteredCards.first,
                               let firstIndex = filteredCards.firstIndex(where: { $0.id == firstFilteredCard.id }) {
                                selectedIndex = firstIndex
                                scrollViewProxy?.scrollTo(firstIndex, anchor: .center)
                            }
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.vertical)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut, value: showSearchBar)
                    }

                    if !filteredCards.isEmpty {
                        HStack(spacing: 0) {
                            Text(filteredCards[selectedIndex].name)
                                .foregroundColor(Color("MainColor"))
                            Text(" 님의 카드")
                                .foregroundColor(.black)
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 20)
                        .padding(.bottom, 30)
                        .multilineTextAlignment(.center)
                    }

                    ScrollViewReader { proxy in
                        VStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(filteredCards.enumerated()), id: \.element.id) { index, card in
                                        ZStack {
                                            // 삭제 버튼, 카드가 위로 올라가 있을 때만 보임
                                            if index == selectedIndex && cardOffsetY == -100 {
                                                Button(role: .destructive) {
                                                    // 삭제 버튼 누르면 알림 띄움
                                                    cardToDelete = card
                                                    showDeleteAlert = true
                                                } label: {
                                                    Circle()
                                                        .fill(Color.red)
                                                        .frame(width: 40, height: 40)
                                                        .overlay(
                                                            Image(systemName: "trash")
                                                                .font(.system(size: 20))
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                                .offset(y: 150)
                                            }

                                            // 카드 뷰
                                            MyProfileCardOnlyView(card: card)
                                                .frame(width: 270, height: 450)
                                                .offset(y: index == selectedIndex ? cardOffsetY + dragOffset : 0)
                                                .background(
                                                    GeometryReader { geo in
                                                        Color.clear
                                                            .preference(key: CardPositionPreferenceKey.self, value: [index: geo.frame(in: .global).midX])
                                                    }
                                                )
                                                .onTapGesture {
                                                    withAnimation {
                                                        selectedIndex = index
                                                        cardOffsetY = 0
                                                    }
                                                }
                                                .gesture(
                                                    index == selectedIndex ?
                                                    DragGesture()
                                                        .updating($dragOffset) { value, state, _ in
                                                            if value.translation.height < 0 {
                                                                state = value.translation.height
                                                            }
                                                        }
                                                        .onEnded { value in
                                                            if value.translation.height < -100 {
                                                                withAnimation {
                                                                    cardOffsetY = -100
                                                                }
                                                            } else {
                                                                withAnimation {
                                                                    cardOffsetY = 0
                                                                }
                                                            }
                                                        }
                                                    : nil
                                                )
                                        }
                                    }
                                }
                                .padding()
                            }
                            .onAppear {
                                self.scrollViewProxy = proxy
                            }
                            .onPreferenceChange(CardPositionPreferenceKey.self) { positions in
                                let screenMidX = UIScreen.main.bounds.midX
                                if let closest = positions.min(by: { abs($0.value - screenMidX) < abs($1.value - screenMidX) }) {
                                    if selectedIndex != closest.key {
                                        selectedIndex = closest.key
                                    }
                                }
                            }
                            .onChange(of: selectedIndex) { newIndex in
                                guard newIndex >= 0 && newIndex < filteredCards.count else { return }
                                withAnimation {
                                    proxy.scrollTo(newIndex, anchor: .center)
                                    cardOffsetY = 0 // 카드 바뀌면 offset 초기화
                                }
                            }
                            .onChange(of: searchText) { newSearchText in
                                if newSearchText.isEmpty {
                                    selectedIndex = 0
                                }
                            }

                            HStack(spacing: 8) {
                                ForEach(Array(filteredCards.enumerated()), id: \.element.id) { index, _ in
                                    Capsule()
                                        .fill(index == selectedIndex ? Color("MainColor") : Color.gray.opacity(0.3))
                                        .frame(width: index == selectedIndex ? 24 : 8, height: 8)
                                        .animation(.easeInOut(duration: 0.25), value: selectedIndex)
                                        .onTapGesture {
                                            withAnimation {
                                                selectedIndex = index
                                            }
                                        }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .sheet(isPresented: $showShareSheet) {
                    if filteredCards.indices.contains(selectedIndex) {
                        ShareCardSheetView(myCard: filteredCards[selectedIndex])
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                            .presentationBackgroundInteraction(.enabled)
                    } else {
                        Text("선택된 카드가 없습니다.")
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                    }
                }
            }
            .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert, presenting: cardToDelete) { card in
                Button("삭제", role: .destructive) {
                    deleteCard(card)
                    cardOffsetY = 0
                }
                Button("취소", role: .cancel) { }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                if cards.isEmpty && !didInsertSample {
                    insertDummyCards()
                    didInsertSample = true
                }
            }
        }
    }

    private func insertDummyCards() {
        CardDataProvider.insertDummyCards(into: context)
    }
    
    private func deleteCard(_ card: CardModel) {
        context.delete(card)
        do {
            try context.save()
        } catch {
            print("Failed to delete card: \(error)")
        }
    }
}

