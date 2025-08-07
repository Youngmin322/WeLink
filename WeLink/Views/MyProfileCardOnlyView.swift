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
            
            Text("D-\(card.dDay)")
                .foregroundColor(.white)
                .opacity(0.9)
                .font(.system(size: 32))
                .bold()
                .padding(.top, 20)
                .padding(.trailing, 16)
            
            VStack(alignment: .leading) {
                Spacer()
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
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .padding(.bottom, 35)
            }
            .frame(width: 270, height: 450)
            .padding(.bottom, 30)
        }
        .frame(width: 270, height: 450)
    }
}

