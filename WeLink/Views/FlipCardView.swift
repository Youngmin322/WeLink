import SwiftUI

struct FlipCardView: View {
    let card: CardModel
    var isFlipped: Bool

    var body: some View {
        ZStack {
            frontView
                .opacity(isFlipped ? 0.0 : 1.0)
            backView
                .opacity(isFlipped ? 1.0 : 0.0)
        }
        .frame(width: 300, height: 400)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.5), value: isFlipped)
    }

    private var frontView: some View {
        VStack(spacing: 10) {
            if let uiImage = UIImage(data: card.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                Color.gray.frame(height: 180)
            }

            Text(card.name)
                .font(.title)
                .bold()
            Text("\(card.age)세")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(card.tag)
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
    }

    private var backView: some View {
        VStack(spacing: 10) {
            Text("설명")
                .font(.headline)
            Text(card.cardDescription)
                .font(.body)
                .padding(.horizontal)
            Spacer()
            HStack {
                Text("생일: \(card.birthDate)")
                Spacer()
                Text("MBTI: \(card.mbti)")
            }
            .font(.footnote)
            .padding(.horizontal)
            Text("D-\(card.dDay)")
                .font(.footnote)
                .padding(.top, 5)
        }
        .padding()
        .rotation3DEffect(
            .degrees(180),
            axis: (x: 0, y: 1, z: 0)
        )
    }
}
