//
//  MyProfileTabView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI
import SwiftData

struct MyProfileTabView: View {
    @Query private var cards: [CardModel]
    @State private var showMenu = false
    @State private var value1: Double = 0.5
    @State private var value2: Double = 0.5
    @State private var value3: Double = 0.5
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("Winter")
                    .resizable()
                    .blur(radius: 3)
                    .frame(width: 600, height: 1000)
                    .ignoresSafeArea()
                
                VStack {
                    HStack(spacing: 160){
                        Text("나의 카드")
                            .foregroundColor(.white)
                            .font(.system(size: 35))
                            .bold()
                        
                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        })
                        {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color("MainColor"))
                                .font(.system(size: 24))
                                .rotationEffect(Angle(degrees: 90))
                                .bold()
                                .padding()
                        }
                        
                    }
                    
                    .padding(.bottom,50)
                    
                    if showMenu {
                                    VStack{
                                        Button("프로필 수정") {
                                            // 액션
                                            print("프로필 수정")
                                            showMenu = false
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.darkGray))
                                        .foregroundColor(.white)

                                        Divider().background(Color.white)

                                        Button("취향 카테고리 수정") {
                                            // 액션
                                            print("취향 카테고리 수정")
                                            showMenu = false
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.darkGray))
                                        .foregroundColor(.white)
                                    }
                                    .background(Color(.darkGray))
                                    .cornerRadius(12)
                                    .frame(width: 160)
                                    .shadow(radius: 5)
                                    .offset(x: 60, y: -40)
                                    .transition(.opacity)
                                }
                    
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
                                Text("D-98")
                                    .foregroundColor(.white)
                                    .opacity(0.9)
                                    .font(.system(size: 32))
                                    .bold()
                                    .padding([.top, .trailing], 16)
                                    .offset(x: 100, y: -145)
                                
                                HStack {
                                    Text("Winter")
                                        .foregroundColor(.white)
                                        .font(.system(size: 40))
                                        .bold()
                                        .offset(x: -50, y: 100)
                                    
                                    Text("(25)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .bold()
                                        .offset(x: -50, y: 108)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("사실 저는 여름이 더 좋긴 해요.")
                                    Text("겨울에는 생존하느라 기억이 희미해요.")
                                    Text("절전모드로 들어가야하거든요.")
                                }
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .bold()
                                .opacity(0.9)
                                .offset(x: -35, y: 110)
                                
                                
                                HStack(spacing: 19) {
                                    ForEach(["25 July", "ENFJ", "아이돌"], id: \.self) { label in
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
                        Text("카드를 클릭하면 뒷면이 보입니다.")
                            .foregroundColor(Color.gray)
                            .offset(x: 0, y: 300)
                        
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
                                    Text("Winter")
                                        .foregroundColor(.black)
                                        .font(.system(size: 40))
                                        .bold()
                                        .multilineTextAlignment(.center)
                                    //
                                    
                                    
                                    Text("D-98")
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
                                
                                Slider(value: $value1)
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
                                Slider(value: $value2)
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
                                Slider(value: $value3)
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
                        
                        Text("카드를 클릭하면 앞면이 보입니다.")
                            .foregroundColor(Color.gray)
                            .offset(x: 0, y: 340)
                        
                    }
                    .padding(.bottom,60)
                    .padding()
                    
                }
                .padding(.bottom,20)
            }
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
}


#Preview {
    MyProfileTabView()
}
