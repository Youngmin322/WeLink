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
                    
                    ZStack {
                        Image("Winter")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 302, height: 500)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                Image("Winter")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 302, height: 500)
                                    .blur(radius: 10)
                                    .mask(
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: .clear, location: 0),
                                                .init(color: .white, location: 0.8)
                                            ]),
                                            startPoint: .center,
                                            endPoint: .bottom
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            )
                        
                        // 테두리
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Stroke"), lineWidth: 2)
                            .frame(width: 302, height: 500)
                        
                        VStack{
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
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .bold()
                                    .opacity(0.9)
                                Text("겨울에는 생존하느라 기억이 희미해요.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .bold()
                                    .opacity(0.9)
                                Text("절전모드로 들어가야하거든요.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .bold()
                                    .opacity(0.9)
                            }
                            .offset(x: -35, y: 110)
                            
                            HStack(spacing:19){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 45)
                                        .foregroundColor(.white.opacity(0.25))
                                        .frame(width: 76, height: 29)
                                    
                                    Text("25 July")
                                        .foregroundColor(.white)
                                        .font(.system(size: 13))
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 45)
                                        .foregroundColor(.white.opacity(0.25))
                                        .frame(width: 76, height: 29)
                                    
                                    Text("ENFJ")
                                        .foregroundColor(.white)
                                        .font(.system(size: 13))
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 45)
                                        .foregroundColor(.white.opacity(0.25))
                                        .frame(width: 76, height: 29)
                                    
                                    Text("아이돌")
                                        .foregroundColor(.white)
                                        .font(.system(size: 13))
                                }
                            }
                            .offset(x: 0, y: 120)
                            
                        }
                    }
                    .padding(.bottom,30)
                    
                    Text("카드를 클릭하면 뒷면이 보입니다.")
                        .foregroundColor(Color.gray)
                }
                .padding(.bottom,80)
            }
        }
    }
}

#Preview {
    MyProfileTabView()
}
