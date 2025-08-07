//
//  SearchFriendsView.swift
//  WeLink
//
//  Created by weonyee on 8/6/25.
//

import SwiftUI

struct SearchFriendsView: View {
    var allCards: [CardModel]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var filteredCards: [CardModel] {
        if searchText.isEmpty {
            return allCards
        } else {
            return allCards.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCards, id: \.id) { card in
                    HStack {
                        if let image = UIImage(data: card.imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text(card.name)
                                .font(.headline)
                            Text(card.mbti)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("카드 검색")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "이름으로 검색")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
        }
    }
}
