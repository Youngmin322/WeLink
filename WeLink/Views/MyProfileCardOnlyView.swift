import SwiftUI

struct MyProfileCardOnlyView: View {
    let card: CardModel
    @State private var flipped = false

    var body: some View {
        FlipCard {
            ZStack {
                Image("Winter")
                    .resizable()
                    .frame(width: 302, height: 500)
                    .scaledToFit()
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
                            .offset(x: -50, y: 100)
                        
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
                        ForEach([card.birthDate, card.mbti, card.tag], id: \.self) { label in
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
                    
                    VStack(alignment: .leading, spacing:9){
                        HStack(spacing:30){
                            Text("🎵 요즘 듣는 노래는?")
                                .font(.system(size: 13))
                            Text("백예린 - Antifreeze")
                                .font(.system(size: 12))
                        }
                        HStack(spacing:30){
                            Text("🧩 요즘 빠진 취미는?")
                                .font(.system(size: 13))
                            Text("과학유튜브 보기")
                                .font(.system(size: 12))
                        }
                        HStack(spacing:30){
                            Text("🏞️ 자주 가는 장소는?")
                                .font(.system(size: 13))
                            Text("포스텍 C5 6층")
                                .font(.system(size: 12))
                        }
                    }
                    .padding()
                    
                    HStack(spacing:182){
                        Text("트렌디")
                            .font(.system(size: 13))
                            .bold()
                            .foregroundColor(.black)
                        Text("클래식")
                            .font(.system(size: 13))
                            .bold()
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                    
                    Slider(value: .constant(0.5))
                        .accentColor(Color("MainColor"))
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.5))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.clear, lineWidth: 2)
                        )
                        .padding()
                    
                    HStack(spacing:130){
                        Text("보장된 만족")
                            .font(.system(size: 13))
                            .bold()
                            .foregroundColor(.black)
                        Text("새로운 설렘")
                            .font(.system(size: 13))
                            .bold()
                            .foregroundColor(.black)
                    }
                    
                    Slider(value: .constant(0.5))
                        .accentColor(Color("MainColor"))
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.5))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.clear, lineWidth: 2)
                        )
                        .padding()
                    
                    HStack(spacing:204){
                        Text("실용")
                            .font(.system(size: 13))
                            .bold()
                            .foregroundColor(.black)
                        Text("감성")
                            .font(.system(size: 13))
                            .bold()
                            .foregroundColor(.black)
                    }
                    
                    Slider(value: .constant(0.5))
                        .accentColor(Color("MainColor"))
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.5))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.clear, lineWidth: 2)
                        )
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
