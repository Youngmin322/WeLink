import SwiftUI
import Foundation

struct MyProfileCardOnlyView: View {
    let card: CardModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(data: card.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 304, height: 483)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Stroke"), lineWidth: 2)
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
                    .frame(width: 324, height: 540) 
            }
            
            Text("D-\(card.dDay)")
                .font(.custom("Pretendard-Bold", size: 32))
                .foregroundColor(.white)
                .opacity(0.9)
                .padding(.top, 15)
                .padding(.trailing, 16)
            
            VStack(alignment: .leading) {
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .lastTextBaseline) {
                        Text(card.name)
                            .font(.custom("Pretendard-Bold", size: 42))
                            .foregroundColor(.white)
                        Text("(\(card.age))")
                            .font(.custom("Pretendard-SemiBold", size: 14))
                            .foregroundColor(.white)
                    }
                    
                    Text(card.cardDescription)
                        .font(.custom("Pretendard-Medium", size: 12.5))
                        .lineSpacing(3)
                        .foregroundColor(.white)
                        .opacity(0.7)
                }
                .padding(.leading, -9)
                
                HStack(spacing: 15) {
                    ForEach([formattedBirthDate(from: card.birthDate), card.mbti, card.tag], id: \.self) { label in
                        ZStack {
                            RoundedRectangle(cornerRadius: 45)
                                .foregroundColor(Color.gray)
                                .frame(width: 76, height: 29)
                                .opacity(0.6)
                            Text(label)
                                .font(.custom("Pretendard-Medium", size: 13))
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, -35)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
            .frame(width: 270, height: 480)
            .padding(.bottom, 20)
        }
        .frame(width: 270, height: 480)
    }
}

