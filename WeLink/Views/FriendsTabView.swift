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
        return baseCards.sorted { $0.dDay < $1.dDay } // D-Day 기준 정렬
    }

    var body: some View {
        NavigationStack {
            ZStack {
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
                    .background(Color.white)

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

                    ScrollViewReader { proxy in
                        VStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(filteredCards.enumerated()), id: \.element.id) { index, card in
                                        MyProfileCardOnlyView(card: card)
                                            .frame(width: 300)
                                            .id(index)
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
                .overlay(alignment: .bottomTrailing) {
                    Button(action: {
                        showShareSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color("MainColor"))
                            .padding()
                    }
                    .offset(x: -15, y: -60)
                }
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
}

#Preview {
    FriendsTabView()
}
