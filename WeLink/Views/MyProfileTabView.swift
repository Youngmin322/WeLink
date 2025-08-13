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
    @State private var myProfile: CardModel? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background image (static, not rebuilt on flip)
                if let myProfile = myProfile {
                    Image(uiImage: UIImage(data: myProfile.imageData)!)
                        .resizable()
                        .blur(radius: 3)
                        .frame(width: 600, height: 1000)
                        .ignoresSafeArea()
                    
                }

                VStack {
                    // Header (static)
                    HStack(spacing: 160) {
                        Text("나의 카드")
                            .foregroundColor(.white)
                            .font(.system(size: 35))
                            .bold()

                        Button(action: {
                            withAnimation(.easeInOut) {
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

                    // Flipping card ZStack
                    if let myProfile = myProfile {
                        FlippingCardView(
                            isFlipped: $isFlipped,
                            myProfile: myProfile
                        )
                    }
                }
                .padding(.bottom, 110)

                MenuOverlay(showMenu: $showMenu, myProfile: myProfile)
            }
        }
        .onAppear {
            if let lastID = myID.last?.id {
                myProfile = findMyProfile(cards: cards, id: lastID)
            }
        }
    }
}

private struct MenuOverlay: View {
    @Binding var showMenu: Bool
    let myProfile: CardModel?

    var body: some View {
        if showMenu, let myProfile = myProfile {
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showMenu = false
                    }
                }

            VStack(alignment: .leading, spacing: 0) {
                NavigationLink(destination: ProfileCustomView(progress: 1.0 / 4.0, cardModel: myProfile, isEdit: true).onAppear { showMenu = false }) {
                    Text("프로필 수정")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.darkGray))
                        .foregroundColor(.white)
                }

                Divider().background(Color.white)

                NavigationLink(destination: CategoryView(progress: 2.0/4.0, cardModel: myProfile, isEdit: true).onAppear { showMenu = false }) {
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
//            .transition(.opacity)
//            .animation(nil)
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


// MARK: - FlippingCardView
private struct FlippingCardView: View {
    @Binding var isFlipped: Bool
    let myProfile: CardModel

    var body: some View {
        ZStack {
            FrontCardView(myProfile: myProfile)
                .opacity(isFlipped ? 0 : 1)
            BackCardView(myProfile: myProfile)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.spring()) {
                isFlipped.toggle()
            }
        }
    }
}

// MARK: - FrontCardView
private struct FrontCardView: View {
    let myProfile: CardModel

    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: myProfile.imageData)!)
                .resizable()
                .scaledToFill()     // 이미지 비율 유지하며 꽉 채우기
                .frame(width: 302, height: 500)
                .clipped()          // 프레임 바깥 부분 잘라내기
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
                        .offset(x: -50, y: 119)

                    Text("(\(myProfile.age))")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .bold()
                        .offset(x: -50, y: 127)
                }

                Text(myProfile.cardDescription)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .bold()
                    .offset(x: -90, y: 140)

                HStack(spacing: 19) {
                    ForEach([formattedBirthDate(from: myProfile.birthDate), (myProfile.mbti), myProfile.tag], id: \.self) { label in
                        ZStack {
                            RoundedRectangle(cornerRadius: 45)
                                .foregroundColor(Color(hex: 0xFFFFFF).opacity(0.25))
                                .frame(width: 76, height: 29)
                            Text(label)
                                .foregroundColor(.white)
                                .font(.system(size: 13))
                        }
                    }
                }
                .offset(x: 0, y: 160)

                Text("카드를 클릭하면 뒷면이 보입니다.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: 0x6F6F6F))
                    .offset(y: 200)
            }
        }
    }
}

// MARK: - BackCardView
private struct BackCardView: View {
    let myProfile: CardModel

    var body: some View {
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
                                    .font(.custom("Pretendard-Bold", size: 14))
                                    .foregroundColor(.black)
                            }
                            Image("MyProfileTabView_Music")
                                .resizable()
                                .frame(width: 100, height: 100)

                            ZStack {
                                RoundedRectangle(cornerRadius: 7)
                                    .foregroundColor(.gray)
                                    .opacity(0.1)
                                    .frame(width: 121, height: 25)

                                Text("백예린 - Antifreeze")
                                    .font(.custom("Pretendard", size: 12))
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
                                .font(.custom("Pretendard-Bold", size: 14))
                                .foregroundColor(.black)

                            ZStack {
                                RoundedRectangle(cornerRadius: 7)
                                    .foregroundColor(.gray)
                                    .opacity(0.1)
                                    .frame(width: 121, height: 25)

                                Text("# 다이어리 쓰기")
                                    .font(.custom("Pretendard", size: 11))
                                    .foregroundColor(.black)
                            }

                            ZStack {
                                RoundedRectangle(cornerRadius: 7)
                                    .foregroundColor(.gray)
                                    .opacity(0.1)
                                    .frame(width: 121, height: 25)

                                Text("# 키링, 인형 모의기")
                                    .font(.custom("Pretendard", size: 11))
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
                                .font(.custom("Pretendard-Bold", size: 14))
                                .foregroundColor(.black)

                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.gray)
                                    .opacity(0.1)
                                    .frame(width: 121, height: 25)

                                Text("포스텍 C5 6층 마루랩")
                                    .font(.custom("Pretendard", size: 11))
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
                            .font(.custom("Pretendard-Bold", size: 14))
                            .foregroundColor(.black)
                    }
                }
                .offset(y: 200)
            }

            Text("카드를 클릭하면 앞면이 보입니다.")
                .font(.custom("Pretendard", size: 16))
                .foregroundColor(Color(hex: 0x6F6F6F))
                .offset(y: 20)
        }
    }
}
