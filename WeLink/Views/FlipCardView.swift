import SwiftUI

struct FlipCardView: View {
    let card: CardModel
    var isFlipped: Bool

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            frontSide
                .opacity(rotation <= 90 ? 1 : 0)
            backSide
                .opacity(rotation > 90 ? 1 : 0)
        }
        .frame(width: 300, height: 400)
        .cornerRadius(20)
        .shadow(radius: 5)
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .onChange(of: isFlipped) { newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                rotation = newValue ? 180 : 0
            }
        }
        .onAppear {
            // 처음 로드 시 상태 일치
            rotation = isFlipped ? 180 : 0
        }
    }

    private var frontSide: some View {
        ZStack {
            backgroundImage
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .cornerRadius(20)

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
                Spacer()
            }
            .padding()
        }
    }

    private var backSide: some View {
        ZStack {
            backgroundImage
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .cornerRadius(20)

            VStack(spacing: 10) {
                Spacer()
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
            .padding()
        }
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }

    private var backgroundImage: some View {
        Group {
            if let uiImage = UIImage(data: card.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .clipped()
            } else {
                Color.gray
            }
        }
    }
}
