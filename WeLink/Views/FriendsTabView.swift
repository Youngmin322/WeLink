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

    var filteredCards: [CardModel] {
        if searchText.isEmpty {
            return cards
        } else {
            return cards.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText) ||
                card.cardDescription.localizedCaseInsensitiveContains(searchText) ||
                card.mbti.localizedCaseInsensitiveContains(searchText) ||
                card.tag.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if showSearchBar {
                    TextField("검색어 입력", text: $searchText, onCommit:  {
                        if !searchText.isEmpty, let firstFilteredCard = filteredCards.first,
                           let firstIndex = cards.firstIndex(where: { $0.id == firstFilteredCard.id }) {
                            selectedIndex = firstIndex
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut, value: showSearchBar)
                }

                ScrollViewReader { proxy in
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                                    MyProfileCardOnlyView(card: card)
                                        .frame(width: 300)
                                        .id(index)
                                        .opacity(filteredCards.contains(where: { $0.id == card.id }) ? 1 : 0.3)
                                        .disabled(!filteredCards.contains(where: { $0.id == card.id }))
                                        .background(
                                            GeometryReader { geo in
                                                Color.clear
                                                    .preference(key: CardPositionPreferenceKey.self, value: [index: geo.frame(in: .global).midX])
                                            }
                                        )
                                        .onTapGesture {
                                            withAnimation {
                                                selectedIndex = index
                                            }
                                        }
                                }
                            }
                            .padding()
                        }
                        // 카드 위치 변화 감지
                        .onPreferenceChange(CardPositionPreferenceKey.self) { positions in
                            let screenMidX = UIScreen.main.bounds.midX
                            // 화면 중앙과 가장 가까운 카드 인덱스 찾기
                            if let closest = positions.min(by: { abs($0.value - screenMidX) < abs($1.value - screenMidX) }) {
                                if selectedIndex != closest.key {
                                    selectedIndex = closest.key
                                }
                            }
                        }
                        // selectedIndex 변경 시 강제 스크롤
                        .onChange(of: selectedIndex) { newIndex in
                            guard newIndex >= 0 && newIndex < cards.count else { return }
                            withAnimation {
                                proxy.scrollTo(newIndex, anchor: .center)
                            }
                        }
                        // 검색어 변경 시 selectedIndex를 초기화하는 로직
                        .onChange(of: searchText) { newSearchText in
                            if newSearchText.isEmpty {
                                selectedIndex = 0
                            }
                        }

                        // 인디케이터
                        HStack(spacing: 8) {
                            ForEach(Array(cards.enumerated()), id: \.element.id) { index, _ in
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
                        .padding(.bottom, 8)
                    }
                }

                HStack {
                    Spacer()
                    Button(action: {
                        showShareSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color("MainColor"))
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal)
                .padding(.top, 20)
                .sheet(isPresented: $showShareSheet) {
                    if selectedIndex >= 0 && selectedIndex < cards.count {
                        ShareCardSheetView(myCard: cards[selectedIndex])
                    } else {
                        Text("선택된 카드가 없습니다.")
                    }
                }
            }
            .navigationTitle("친구")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            showSearchBar.toggle()
                            if !showSearchBar {
                                searchText = ""
                            }
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color("MainColor"))
                    }
                }
            }
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
}


#Preview {
    FriendsTabView()
}
