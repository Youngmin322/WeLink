//
//  FriendsTabView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI
import SwiftData

struct FriendsTabView: View {
    @State private var showShareSheet = false
    @Query private var cards: [CardModel]

    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(cards) { card in
                        ProfileCardView(card: card)
                            .frame(width: 300)
                    }
                    Button(action: {
                        showShareSheet = true
                    }) {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                        }

                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareCardSheetView()
                    }
                }
                .padding()
            }
            .navigationTitle("친구")
        }
    }
}

#Preview {
    FriendsTabView()
}
