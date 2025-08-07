import SwiftUI

struct MyProfileCardOnlyView: View {
    let card: CardModel
    @State private var flipped = false

    var body: some View {
        FlipCard {
            ZStack {
                if let uiImage = UIImage(data: card.imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 302, height: 500)
                                        .clipped() // 이미지가 프레임을 벗어나는 부분을 잘라냅니다.
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
                                    // 이미지 데이터가 없을 경우 기본 뷰를 표시
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.gray)
                                        .frame(width: 302, height: 500)
                                }
                VStack {
                    Text("D-\(card.dDay)")
                        .foregroundColor(.white)
                        .opacity(0.9)
                        .font(.system(size: 32))
                        .bold()
                        .padding([.top, .trailing], 16)
                        .offset(x: 100, y: -145)
                    
                    HStack {
                        Text(card.name)
                            .foregroundColor(.white)
                            .font(.system(size: 40))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        Text("(\(card.age))")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .bold()
                            .offset(x: -50, y: 108)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.cardDescription)
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .bold()
                    .opacity(0.9)
                    .offset(x: -35, y: 110)
                    
                    HStack(spacing: 19) {
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
                    .offset(x: 0, y: 120)
                }
            }
        } back: {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 302, height: 600)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("CategoryColor"), lineWidth: 2)
                    )
                    .opacity(0.6)
                VStack{
                    VStack(spacing:21){
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
                            .frame(width: 250, height: 2)
                            .foregroundColor(.white)
                            .opacity(0.4)
                    }
                    .padding()
                    
                    NavigationLink(destination: MyProfileTabDetailView()) {
                        ZStack{
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
        .frame(width: 302, height: 500)
    }
}

struct FlipCard<Front: View, Back: View>: View {
    @State private var flipped = false
    let front: Front
    let back: Back

    init(@ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back) {
        self.front = front()
        self.back = back()
    }

    var body: some View {
        ZStack {
            front
                .opacity(flipped ? 0 : 1)
                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            back
                .opacity(flipped ? 1 : 0)
                .rotation3DEffect(.degrees(flipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 302, height: 500)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                flipped.toggle()
            }
        }
    }
}

func formattedBirthDate(from dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "d MMM"
    outputFormatter.locale = Locale(identifier: "en_US") // 영어 월 표기

    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
        return dateString // 포맷이 잘못되었을 경우 원본 그대로 반환
    }
}

