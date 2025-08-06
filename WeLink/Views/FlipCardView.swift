import SwiftUI

struct FlipCardView: View {
    let card: CardModel
    var isFlipped: Bool

    var body: some View {
        ZStack {
            // 카드 배경에 이미지
            if let uiImage = UIImage(data: card.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .clipped()
            } else {
                Color.gray
            }

            // 반투명 어둡게 (텍스트 가독성 ↑)
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .cornerRadius(20)

            // 카드 내용
            ZStack {
                frontView
                    .opacity(isFlipped ? 0.0 : 1.0)
                backView
                    .opacity(isFlipped ? 1.0 : 0.0)
            }
            .padding()
        }
        .frame(width: 300, height: 400)
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
            Spacer()
            Text(card.name)
                .font(.title)
                .foregroundColor(.white)
                .bold()
            Text("\(card.age)세")
                .font(.subheadline)
                .foregroundColor(.white)
            Text(card.cardDescription)
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal)
            Text(card.tag)
                .font(.caption)
                .foregroundColor(.yellow)
            HStack(spacing: 10) {
                Text(card.birthDate)
                    .font(.caption)
                    .foregroundColor(.white)
                Text(card.mbti)
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
    }

    private var backView: some View {
        VStack(spacing: 10) {
            Text("설명")
                .font(.headline)
                .foregroundColor(.white)
            Text(card.cardDescription)
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal)
            Spacer()
            HStack {
                Text("생일: \(card.birthDate)")
                Spacer()
                Text("MBTI: \(card.mbti)")
            }
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.horizontal)
            Text("D-\(card.dDay)")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.top, 5)
        }
        .rotation3DEffect(
            .degrees(180),
            axis: (x: 0, y: 1, z: 0)
        )
    }
}
