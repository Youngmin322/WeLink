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
    @GestureState private var dragOffset: CGFloat = 0
    @State private var cardOffsetY: CGFloat = 0

    @State private var showDeleteAlert = false
    @State private var cardToDelete: CardModel? = nil

    var filteredCards: [CardModel] {
        let baseCards = searchText.isEmpty ? cards : cards.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.cardDescription.localizedCaseInsensitiveContains(searchText) ||
            $0.mbti.localizedCaseInsensitiveContains(searchText) ||
            $0.tag.localizedCaseInsensitiveContains(searchText)
        }
        return baseCards.sorted { $0.dDay < $1.dDay }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundImageView
                mainContent
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

    private var backgroundImageView: some View {
        Group {
            if filteredCards.indices.contains(selectedIndex),
               let uiImage = UIImage(data: filteredCards[selectedIndex].imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 10)
                    .overlay(Color.black.opacity(0.4))
            } else {
                Color.white.edgesIgnoringSafeArea(.all)
            }
        }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            headerView
            if showSearchBar { searchBar }
            if !filteredCards.isEmpty { titleView }
            scrollViewSection
            dotIndicator
        }
        .padding(.top, -90)
        .sheet(isPresented: $showShareSheet) {
            shareSheet
        }
        .overlay(addCardButton, alignment: .bottomTrailing)
    }

    private var headerView: some View {
        HStack {
            Text("친구")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)
            Spacer()
            Button(action: {
                withAnimation {
                    showSearchBar.toggle()
                    if !showSearchBar { searchText = "" }
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 24))
                    .foregroundColor(Color("MainColor"))
                    .padding()
            }
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .background(
            Color.black.opacity(0.25)
                .blur(radius: 10)
                .edgesIgnoringSafeArea(.top)
        )
    }

    private var searchBar: some View {
        TextField("검색어 입력", text: $searchText, onCommit: {
            if !searchText.isEmpty, let first = filteredCards.first,
               let index = filteredCards.firstIndex(where: { $0.id == first.id }) {
                selectedIndex = index
                scrollViewProxy?.scrollTo(index, anchor: .center)
            }
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.horizontal)
        .padding(.vertical)
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeInOut, value: showSearchBar)
    }

    private var titleView: some View {
        HStack(spacing: 0) {
            Text(filteredCards[selectedIndex].name)
                .foregroundColor(Color("MainColor"))
            Text(" 님의 카드")
                .foregroundColor(.white)
        }
        .font(.title2)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.leading, 20)
        .padding(.bottom, 30)
        .multilineTextAlignment(.center)
    }

    private var scrollViewSection: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(filteredCards.enumerated()), id: \.element.id) { index, card in
                            ZStack {
                                if index == selectedIndex && cardOffsetY == -100 {
                                    deleteButton(for: card)
                                }
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
                                                withAnimation {
                                                    cardOffsetY = value.translation.height < -100 ? -100 : 0
                                                }
                                            }
                                        : nil
                                    )
                            }
                        }
                    }
                    .padding()
                }
                .onAppear { scrollViewProxy = proxy }
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
                        cardOffsetY = 0
                    }
                }
                .onChange(of: searchText) { if $0.isEmpty { selectedIndex = 0 } }
            }
        }
    }

    private var dotIndicator: some View {
        HStack(spacing: 8) {
            ForEach(Array(filteredCards.enumerated()), id: \.element.id) { index, _ in
                Capsule()
                    .fill(index == selectedIndex ? Color("MainColor") : Color.gray.opacity(0.3))
                    .frame(width: index == selectedIndex ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.25), value: selectedIndex)
                    .onTapGesture {
                        withAnimation { selectedIndex = index }
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal)
    }

    private var addCardButton: some View {
        Button(action: { showShareSheet = true }) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(Color("MainColor"))
                .padding()
        }
        .padding(.bottom, 60)
        .padding(.trailing, 20)
    }

    private var shareSheet: some View {
        Group {
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

    private func deleteButton(for card: CardModel) -> some View {
        Button(role: .destructive) {
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
