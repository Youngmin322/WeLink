import SwiftUI
import Foundation

struct MyProfileCardOnlyView: View {
    let card: CardModel
    @State private var flipped = false
    
    var body: some View {
        FlipCard {
            // MARK: - 카드 앞면
            ZStack(alignment: .topTrailing) {
                // 배경 이미지 및 오버레이
                if let uiImage = UIImage(data: card.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 270, height: 450)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("CategoryColor"), lineWidth: 2)
                        )
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, Color.black.opacity(0.4)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .blur(radius: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        )
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray)
                        .frame(width: 270, height: 450)
                }

                // D-day 텍스트
                Text("D-\(card.dDay)")
                    .foregroundColor(.white)
                    .opacity(0.9)
                    .font(.system(size: 32))
                    .bold()
                    .padding(.top, 20)
                    .padding(.trailing, 16)

                // 카드 하단에 위치할 정보들
                VStack(alignment: .leading) {
                    Spacer() // 모든 콘텐츠를 아래로 밀어냄

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .lastTextBaseline) {
                            Text(card.name)
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .bold()
                            
                            Text("(\(card.age))")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .bold()
                        }
                        
                        Text(card.cardDescription)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                            .opacity(0.9)
                    }
                    .padding(.leading, 20)

                    // ✅ 가운데 정렬된 라벨들 (카드 내부에 배치됨)
                    HStack(spacing: 12) {
                        ForEach([formattedBirthDate(from: card.birthDate), card.mbti, card.tag], id: \.self) { label in
                            ZStack {
                                RoundedRectangle(cornerRadius: 45)
                                    .foregroundColor(Color.gray)
                                    .frame(width: 76, height: 29)
                                    .opacity(0.6)
                                Text(label)
                                    .foregroundColor(.white)
                                    .font(.system(size: 13))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity) // 카드 너비 기준으로 중앙 정렬
                    .padding(.top, 16)
                    .padding(.bottom, 35) // ✅ 카드 밖으로 안 나가도록 여백 확보
                }
                .frame(width: 270, height: 450) // ✅ 카드 앞면 이미지 너비와 일치
                .padding(.bottom, 30) // 전체 VStack의 하단 여백

            }
        } back: {
            // MARK: - 카드 뒷면
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 270, height: 450)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("CategoryColor"), lineWidth: 2)
                    )
                    .opacity(0.6)
                
                VStack {
                    VStack(spacing: 21) {
                        Text(card.name)
                            .foregroundColor(.black)
                            .font(.system(size: 40))
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        Text("D-\(card.dDay)")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.white)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 200, height: 2)
                            .foregroundColor(.white)
                            .opacity(0.4)
                    }
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink(destination: MyProfileTabDetailView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 19.5)
                                .frame(width: 118, height: 33)
                                .foregroundColor(Color("MainColor"))
                            Text("> 취향 보러가기")
                                .foregroundColor(.black)
                                .font(.system(size: 13))
                        }
                    }
                }
            }
        }
        .frame(width: 270, height: 450)
    }
}
