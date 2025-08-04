//
//  FriendsTabView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI
import SwiftData

struct FriendsTabView: View {
    @Query private var cards: [CardModel]

    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(cards) { card in
                        ProfileCardView(card: card)
                            .frame(width: 300)
                    }
                }
                .padding()
            }
            .navigationTitle("친구")
        }
    }
}
