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
    @State private var isFlipped = false
    
    var body: some View {
        NavigationView {
            let myProfile = findMyProfile(cards: cards, id: myID.last!.id)
            ZStack {
                Image(uiImage: UIImage(data: myProfile.imageData)!)
                    .resizable()
                    .blur(radius: 3)
                    .frame(width: 600, height: 1000)
                    .ignoresSafeArea()
                
                VStack {
                    HStack(spacing: 160) {
                        Text("나의 카드")
                            .foregroundColor(.white)
                            .font(.system(size: 35))
                            .bold()
                        
                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color("MainColor"))
                                .font(.system(size: 24))
                                .rotationEffect(Angle(degrees: 90))
                                .bold()
                                .padding()
                        }
                    }
                    .padding(.bottom, 30)
                    
                    ZStack {
                        if !isFlipped {
                            // 앞면 뷰
                            Image(uiImage: UIImage(data: myProfile.imageData)!)
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
                                Text("D-\(myProfile.dDay)")
                                    .foregroundColor(.white)
                                    .opacity(0.9)
                                    .font(.system(size: 32))
                                    .bold()
                                    .padding([.top, .trailing], 16)
                                    .offset(x: 90, y: -160)
                                
                                HStack {
                                    Text(myProfile.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 40))
                                        .bold()
                                        .offset(x: -50, y: 100)
                                    
                                    Text("(\(myProfile.age))")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .bold()
                                        .offset(x: -50, y: 108)
                                }
                                
                   
                                    Text(myProfile.cardDescription)
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .bold()
                                        .offset(x: -90, y: 110)

                                
                                
                                HStack(spacing: 19) {
                                    ForEach([formattedBirthDate(from: myProfile.birthDate), (myProfile.mbti), myProfile.tag], id: \.self) { label in
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
                                
                                Text("카드를 클릭하면 뒷면이 보입니다.")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: 0x6F6F6F))
                                    .offset(y: 200)
                            }
                        } else {
                            // 뒷면 뷰
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.white)
                                        .opacity(0.7)
                                        .frame(width: 302, height: 500)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white, lineWidth: 1.5)
                                        )
                                    
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundColor(.white)
                                                .opacity(0.6)
                                                .frame(width: 135, height: 194)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.white, lineWidth: 1)
                                                )
                                            
                                            VStack(spacing: 10) {
                                                ZStack{
                                                    Rectangle()
                                                        .foregroundColor(Color("MainColor"))
                                                        .frame(width: 54, height: 20)
                                                        .offset(x: -22)
                                                    
                                                    Text("김민정 님의 음악")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.black)
                                                }
                                                Image("MyProfileTabView_Music")
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 7)
                                                        .foregroundColor(.gray)
                                                        .opacity(0.2)
                                                        .frame(width: 121, height: 25)
                                                    
                                                    Text("<백예린 - Antifreeze>")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .offset(x: -70, y: -130)
                                    
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundColor(.white)
                                                .opacity(0.6)
                                                .frame(width: 133, height: 107)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.white, lineWidth: 1)
                                                )
                                            
                                            VStack {
                                                Text("요즘 빠진 취미")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.black)
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 7)
                                                        .foregroundColor(.gray)
                                                        .opacity(0.2)
                                                        .frame(width: 121, height: 25)
                                                    
                                                    Text("# 다이어리 쓰기")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(.black)
                                                }
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 7)
                                                        .foregroundColor(.gray)
                                                        .opacity(0.2)
                                                        .frame(width: 121, height: 25)
                                                    
                                                    Text("# 키링, 인형 모의기")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .offset(x: 70, y: -175)
                                    
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundColor(.white)
                                                .opacity(0.6)
                                                .frame(width: 133, height: 79)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.white, lineWidth: 1)
                                                )
                                            
                                            VStack {
                                                Text("자주 가는 장소")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.black)
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .foregroundColor(.gray)
                                                        .opacity(0.2)                                        .frame(width: 121, height: 25)
                                                    
                                                    Text("📍포스텍 C5 6층 마루랩")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .offset(x: 70, y: -75)
                                    
                                    Image("MyProfileTabView_balance")
                                        .resizable()
                                        .frame(width: 274, height: 182)
                                        .offset(y: 70)
                                    
                                    NavigationLink(destination: MyProfileTabDetailView(myProfile: myProfile)) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 35)
                                                .fill(Color("MainColor"))
                                                .frame(width: 221, height: 47)
                                            
                                            Text("취향 더 보러가기")
                                                .font(.system(size: 14))
                                                .bold()
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .offset(y: 200)
                                    
                                }
                                
                                Text("카드를 클릭하면 앞면이 보입니다.")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: 0x6F6F6F))
                                    .offset(y: 20)
                            }
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isFlipped.toggle()
                        }
                    }
                }
                .padding(.bottom, 110)
                
                if showMenu {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        NavigationLink(destination: ProfileCustomView(progress: 1.0 / 4.0).onAppear { showMenu = false }) {
                            Text("프로필 수정")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.darkGray))
                                .foregroundColor(.white)
                        }
                        Divider().background(Color.white)
                        NavigationLink(destination: CategoryView(progress: 2.0/4.0, cardModel: myProfile).onAppear { showMenu = false }) {
                            Text("취향 카테고리 수정")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.darkGray))
                                .foregroundColor(.white)
                        }
                    }
                    .background(Color(.darkGray))
                    .cornerRadius(12)
                    .frame(width: 160)
                    .shadow(radius: 5)
                    .offset(x: 60, y: -250)
                    .transition(.opacity)
                }
            }
        }
    }
}


func findMyProfile(cards: [CardModel], id: UUID)->CardModel{
    var idx:Int = 0
    for (i, card) in cards.enumerated(){
        if card.id == id{
            idx = i
            break
        }
    }
    return cards[idx]
}
