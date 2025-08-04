//
//  MyProfileTabView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI
import SwiftData

struct MyProfileTabView: View {
    @Query private var cards: [CardModel]

    var body: some View {
        NavigationView {
            VStack {
                if let myCard = cards.first {
                    ProfileCardView(card: myCard)
                } else {
                    Text("내 카드가 없습니다.")
                }
            }
            .navigationTitle("프로필")
        }
    }
}
