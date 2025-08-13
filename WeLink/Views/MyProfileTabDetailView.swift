//
//  MyProfileTabViewDetail.swift
//  WeLink
//
//  Created by 남만두 on 8/5/25.
//

import SwiftUI


struct MyProfileTabDetailView: View {
    var myProfile: CardModel
    @State private var currentTopic: mainTopic
    @Environment(\.dismiss) private var dismiss
    
    @State private var showMenu: Bool = false
    
    init(myProfile: CardModel) {
        self.myProfile = myProfile
        self.currentTopic = myProfile.topics[0]
        
        for topic in myProfile.topics {
            topic.isSelected = false
        }
        currentTopic.isSelected = true
    }
    
    var body: some View {
        ZStack(alignment: .top){
            ScrollView{
                VStack{
                    ZStack{
                        backgroundImage(image: UIImage(data: myProfile.imageData)!)
                        
                        VStack{
                            
                            Spacer()
                            
                            DetailedInfo(myProfile: myProfile)
                        }
                    }
                    
                    // 대주제 버튼
                    CustomTabView(topics: myProfile.topics, currentTopic: $currentTopic)
                    
                    entireSubTopicView(currentTopic: $currentTopic)
                   
                }
            }
            .background(Color(hex: 0x000000))
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .onAppear{
                NotificationCenter.default.post(name: .hideTabBar, object: nil)
                
                for topic in myProfile.topics {
                    topic.isSelected = false
                }
                currentTopic = myProfile.topics[0]
                currentTopic.isSelected = true
            }
            .onDisappear {
                NotificationCenter.default.post(name: .showTabBar, object: nil)
            }
            
            upperButtons(dismiss: {
                NotificationCenter.default.post(name: .showTabBar, object: nil)
                dismiss()
            }, showMenu: $showMenu)
                .padding(.top, -30)
            
            if showMenu {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }

                // 메뉴 본체
                VStack(alignment: .leading, spacing: 0) {
                    NavigationLink(destination: ProfileCustomView(progress: 1.0 / 4.0, cardModel: myProfile, isEdit: true).onAppear { showMenu = false }
                                            .navigationBarHidden(true)) {
                        Text("프로필 수정")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.darkGray))
                            .foregroundColor(.white)
                    }

                    Divider().background(Color.white)

                    NavigationLink(destination: CategoryView(progress: 2.0/4.0, cardModel: myProfile, isEdit: true).onAppear { showMenu = false }
                                            .navigationBarHidden(true)) {
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
                .offset(x: 60, y: 50)

            }
        }
    }
}

struct backgroundImage: View{
    let image: UIImage
    var body: some View{
    ZStack{
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .overlay( VStack{
                Spacer()
                
                // 어둡게 그라데이션
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: 0x000000),
                        Color.clear
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 200)
            }
            )
        
    }
}
}

struct upperButtons: View{
    let dismiss: () -> Void
    @Binding var showMenu:Bool
    var body: some View{
        HStack{
            // 뒤로가기 버튼
            Button(action:{
                dismiss()
            }){
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .frame(width: 15, height: 25)
                        .foregroundColor(Color("MainColor"))
                }
            }
            .contentShape(Rectangle())
            
            Spacer()
            
            // 더보기 버튼
            Button(action:{
                withAnimation(.easeInOut(duration: 0.2)) {
                    showMenu.toggle()
                }
            }){
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("MainColor"))
                        .font(.system(size: 24, weight: .bold))
                        .rotationEffect(Angle(degrees: 90))
                }
            }
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
    }
}


struct DetailedInfo: View{
    var myProfile: CardModel
    var body: some View{
        VStack(spacing: 30){
            // 상단 이름 & 한줄소개
            VStack(spacing:10){
                Text(myProfile.name)
                    .font(.system(size: 50))
                    .bold()
                    .foregroundColor(.white)
                
                VStack(spacing:10){
                    Text(myProfile.cardDescription)
                        .font(.system(size: 14))
                        .bold()
                        .foregroundColor(.white)
                }
            }
            
            // 생일, MBTI, 직업
            HStack(spacing: 19) {
                ForEach([formattedBirthDate(from: myProfile.birthDate), myProfile.mbti, myProfile.tag], id: \.self) { label in
                    ZStack {
                        RoundedRectangle(cornerRadius: 45)
                            .stroke(Color("StrokeMyDetail"), lineWidth: 1) // 와 대박 졸리다
                            .frame(width: 76, height: 29)
                        Text(label)
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                    }
                }
            }
            .padding(.bottom, 15)
        }
    }
    
}
struct CustomTabView: View {
    @State var topics: [mainTopic]
    @Binding var currentTopic: mainTopic
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach($topics, id: \.title) { topic in
                    newMainTopicButton(topic: topic, currentTopic: $currentTopic)
                }
            }
            .padding(.vertical, 8)
            .background(Color(hex: 0x000000))
        }
    }
}

struct newMainTopicButton: View{
    @Binding var topic: mainTopic
    @Binding var currentTopic: mainTopic
    
    var body: some View{
        Button(action: {
            currentTopic.isSelected.toggle()
            topic.isSelected.toggle()
            currentTopic = topic
        }) {
            VStack(spacing: 16) {
                Text(topic.title)
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .bold))
                
                // 인디케이터
                Rectangle()
                    .fill(topic.isSelected ? Color("MainColor") : Color.gray.opacity(0.3))
                    .frame(height: 2)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
   
struct mainTopicButton: View{
    @Binding var topic: mainTopic
    @Binding var currentTopic: mainTopic
    
    let width: CGFloat = 100
    let height: CGFloat = 88
    let textSize: CGFloat = 17
    var body: some View {
        Button(action: {
            currentTopic.isSelected.toggle()
            topic.isSelected.toggle()
            currentTopic = topic
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: width, height: height)
                    .foregroundColor(topic.isSelected ? Color("MainColor") : Color("CategoryColor"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.white), lineWidth: 0.3)
                    )
                Text(topic.title)
                    .foregroundColor(.white)
                    .font(.custom("Pretendard-SemiBold", size: 17))
            }
        }
    }
    
}

struct entireSubTopicView: View{
    @Binding var currentTopic: mainTopic
    private let width: CGFloat = 348
    
    var body: some View{
        
        VStack{
            let sortedKeys = currentTopic.children.keys.sorted {
                currentTopic.children[$0]!.title < currentTopic.children[$1]!.title
            }
            
            let lastSubTopicToShow: String = findLastKey(sortedKeys: sortedKeys, currentTopic: currentTopic)
            
            ForEach(Array(sortedKeys.enumerated()), id:  \.offset){ (idx, key) in
                                subTopicWindow(topic: Binding<subTopic>(
                                    get: { currentTopic.children[key]! },
                                    set: { _ in } // set은 아무 동작도 안 함
                                ), width : width, lastKey: lastSubTopicToShow)
                }
        }
        .background(
            GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: 0x191919))
                        .frame(width: width, height: geo.size.height + 20, alignment: .center)
                        .offset(x: (geo.size.width - width) / 2)
                }
            )
        .padding(.bottom, 120)
    }
}

struct subTopicWindow: View{
    @Binding var topic: subTopic
    private let width: CGFloat
    private let lastKey: String
    
    private let buttonWidth: CGFloat = 100
    private let buttonHeight: CGFloat = 45
    
    init (topic: Binding<subTopic>, width: CGFloat, lastKey:String){
        self._topic = topic
        self.width = width
        self.lastKey = lastKey
    }
    var body: some View {
        ZStack{
            if topic.children.values.filter { $0.isSelected }.count > 0 {
                VStack(spacing:22){
                    HStack(spacing: 1){
                        Text("#")
                            .foregroundColor(Color("MainColor"))
                            .font(.system(size: 20))
                            .bold()
                        Text(topic.title)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.top, 15)
                    
                    let columns = [
                        GridItem(.fixed(buttonWidth), alignment: .center),
                        GridItem(.fixed(buttonWidth), alignment: .center),
                        GridItem(.fixed(buttonWidth), alignment: .center)
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach($topic.children.values.filter { $0.isSelected.wrappedValue }.sorted { $0.wrappedValue.title < $1.wrappedValue.title }, id: \.id) { detailedTopic in
                            detailedTopicButton(topic: detailedTopic, width: buttonWidth, height: buttonHeight)
                        }
                    }
                    if topic.title != lastKey{
                        Divider()
                            .frame(width: width - 50 , height: 1) // 두께
                            .background(Color.gray) // 색상
                            .opacity(1)
                            .padding(.top, 15)
                    }
                }
            }
        }
    }
    
    struct detailedTopicButton: View {
        @Binding var topic: detailedTopic
        let width: CGFloat
        let height: CGFloat
        let textSize: CGFloat = 15
        
        var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color("MainColor"), lineWidth: 1)
                    .foregroundColor(Color("DetailedCategoryColor"))
                    .frame(width: width, height: height)
                
                
                Text(topic.title)
                    .font(.custom("Pretendard-Medium", size: 13))
                    .foregroundColor(Color("MainColor"))
            }
        }
    }
}

func findLastKey(sortedKeys: [String], currentTopic: mainTopic) -> String {
    var lastSubTopicToShow = ""
    
    for (_, key) in sortedKeys.enumerated() {
        let detailedTopics = Array(currentTopic.children[key]!.children.values)
        
        for topic in detailedTopics {
            if topic.isSelected {
                lastSubTopicToShow = key
            }
        }
    }
    return lastSubTopicToShow
}

#Preview {
    MyProfileTabDetailView(myProfile: CardModel(id: UUID() , name: "하워드", age: 30, description: "야생의 하워드가 나타났다!", birthDate: "2003-04-24", mbti: "ISTP", tag: "선생님", dDay: 80, imageData: UIImage(named: "Giselle")!.pngData()!))
}
