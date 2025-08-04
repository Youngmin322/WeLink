import SwiftUI
import SwiftData

struct FriendsTabView: View {
    @State private var showShareSheet = false
    @Environment(\.modelContext) private var context
    @Query private var cards: [CardModel]
    @State private var didInsertSample = false
    @State private var flippedCards: Set<UUID> = []
    @State private var selectedIndex: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                                FlipCardView(card: card, isFlipped: flippedCards.contains(card.id))
                                    .frame(width: 300, height: 400)
                                    .id(index)
                                    .onTapGesture {
                                        toggleFlip(card)
                                        selectedIndex = index
                                    }
                            }
                        }
                        .padding()
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(cards.enumerated()), id: \.element.id) { index, _ in
                                Circle()
                                    .fill(index == selectedIndex ? Color.blue : Color.gray.opacity(0.5))
                                    .frame(width: 20, height: 20)
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(index, anchor: .center)
                                            selectedIndex = index
                                        }
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)  // ← 여기
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }

                }
                
                
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
                .padding(.top, 20)

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

#Preview {
    FriendsTabView()
}
