import SwiftUI
import SwiftData

struct FriendsTabView: View {
    @Environment(\.modelContext) private var context
    @Query private var cards: [CardModel]
    @State private var didInsertSample = false
    @State private var flippedCards: Set<UUID> = []
    @State private var selectedIndex: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 카드 스와이프
                TabView(selection: $selectedIndex) {
                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                        FlipCardView(card: card, isFlipped: flippedCards.contains(card.id))
                            .frame(width: 300, height: 400)
                            .tag(index)
                            .onTapGesture {
                                toggleFlip(card)
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 420)

                // 글라스모피즘 인디케이터
                HStack(spacing: 10) {
                    ForEach(cards.indices, id: \.self) { index in
                        Circle()
                            .fill(index == selectedIndex ? Color.blue.opacity(0.8) : Color.white.opacity(0.4))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(10)
                .background(
                    BlurView(style: .systemThinMaterial)
                        .clipShape(Capsule())
                        .opacity(0.8)
                )
                .padding(.top, 8)
                .padding(.bottom, 16)

                // 하단 추가 버튼
                HStack {
                    Spacer()
                    Button(action: addDummyCard) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color("MainColor"))
                    }
                }
                .padding(.bottom, 40)
                .padding(.horizontal)
            }
            .navigationTitle("친구")
            .onAppear {
                if cards.isEmpty && !didInsertSample {
                    insertDummyCards()
                    didInsertSample = true
                }
            }
        }
    }

    private func toggleFlip(_ card: CardModel) {
        if flippedCards.contains(card.id) {
            flippedCards.remove(card.id)
        } else {
            flippedCards.insert(card.id)
        }
    }

    private func insertDummyCards() {
        CardDataProvider.insertDummyCards(into: context)
    }

    private func addDummyCard() {
        CardDataProvider.addDummyCard(into: context)
        selectedIndex = cards.count
    }
}
