//
//  MyProfileTabView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI
import SwiftData

struct MyProfileTabView: View {
    @Query private var myID: [MyUUID]
    @Query private var cards: [CardModel]
    @State private var showMenu = false
    @State private var value1: Double = 0.5
    @State private var value2: Double = 0.5
    @State private var value3: Double = 0.5
    
    var body: some View {
        
        let myProfile = cards.first(where: { $0.id == myID.first!.id })!
        
        NavigationView {
            ZStack{
//                Image("Winter")
                Image(uiImage: UIImage(data: myProfile.imageData)!)
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
                    
                    .padding(.bottom,30)
                    
                    NavigationLink(destination: MyProfileTabDetailView()) {
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
                    }
                    
                }
                .padding(.bottom,50)
                
                // 메뉴를 VStack 바깥, ZStack 안에 위치
                if showMenu {
                    // 배경 클릭 시 메뉴 닫기
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                            }
                        }

                    // 메뉴 본체
                    VStack(alignment: .leading, spacing: 0) {
                        Button("프로필 수정") {
                            print("프로필 수정")
                            showMenu = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.darkGray))
                        .foregroundColor(.white)

                        Divider().background(Color.white)

                        Button("취향 카테고리 수정") {
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
                    .offset(x: 60, y: -250) // 필요에 따라 위치 조정
                    .transition(.opacity)
                }
            }
        }
    }
}


//#Preview {
//    MyProfileTabView()
//}

