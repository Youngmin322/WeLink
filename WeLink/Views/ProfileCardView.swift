//
//  ProfileCardView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI

struct ProfileCardView: View {
    let card: CardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let uiImage = UIImage(data: card.imageData) {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 400)
                        .clipped()
                        .cornerRadius(20)

                    Text("D-\(card.dDay)")
                        .font(.headline)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(10)
                }
            }

            Text("\(card.name) (\(card.age))")
                .font(.title)
                .bold()

            Text(card.cardDescription)
                .font(.body)
                .lineLimit(2)

            HStack(spacing: 10) {
                Text(card.birthDate)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                Text(card.mbti)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                Text(card.tag)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
