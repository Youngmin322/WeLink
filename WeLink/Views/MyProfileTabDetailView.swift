//
//  MyProfileTabViewDetail.swift
//  WeLink
//
//  Created by 남만두 on 8/5/25.
//

import SwiftUI

struct MyProfileTabDetailView: View {
    @ObservedObject var myProfile: CardModel
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
                for topic in myProfile.topics {
                    topic.isSelected = false
                }
                currentTopic = myProfile.topics[0]
                currentTopic.isSelected = true
            }
            
            upperButtons(dismiss: { dismiss() }, showMenu: $showMenu)
                .padding(.top, -30)
            
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
                //TODO: 위치 조절
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
        HStack(spacing: 285){
            Button(action:{
                dismiss()
            }){
                Image(systemName: "chevron.backward")
                    .resizable()
                    .frame(width: 15, height: 25)
                    .foregroundColor(Color("MainColor"))
            }
            
            Button(action:{
                showMenu.toggle()
            }){
                Image(systemName: "ellipsis")
                    .foregroundColor(Color("MainColor"))
                    .font(.system(size: 30))
                    .rotationEffect(Angle(degrees: 90))
                    .bold()
            }
        }
        .padding(.top, 50)
    }
}


struct DetailedInfo: View{
    @ObservedObject var myProfile: CardModel
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
                            .foregroundColor(Color.gray)
                            .frame(width: 76, height: 29)
                            .opacity(0.6)
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
            VStack(spacing: 8) {
                Text(topic.title)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                
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
                    .font(.system(size: textSize))
                    .bold()
            }
        }
    }
    
}

struct entireSubTopicView: View{
    @Binding var currentTopic: mainTopic
    private let width: CGFloat = 348
    @State private var totalHeight: CGFloat = 0
    
    var body: some View{
        
        VStack{
            let sortedKeys = currentTopic.children.keys.sorted {
                currentTopic.children[$0]!.title < currentTopic.children[$1]!.title
            }
            ForEach(Array(sortedKeys.enumerated()), id:  \.offset){ (idx, key) in
                subTopicWindow(topic: Binding<subTopic>(
                    get: { currentTopic.children[key]! },
                    set: { newValue in
                        currentTopic.children[key] = newValue
                    }
                ), width : width, totalHeight: $totalHeight)
                if idx != sortedKeys.count - 1{
                    Divider()
                        .frame(width: width - 50 , height: 1) // 두께
                        .background(Color.gray) // 색상
                        .opacity(0.5)
                        .padding(.top, 15)
                }
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
    }
}

struct subTopicWindow: View{
    @Binding var topic: subTopic
    private let width: CGFloat
    @Binding private var totalHeight: CGFloat
    
    private let buttonWidth: CGFloat = 100
    private let buttonHeight: CGFloat = 45
    
    init (topic: Binding<subTopic>, width: CGFloat, totalHeight: Binding<CGFloat>){
        self._topic = topic
        self.width = width
        self._totalHeight = totalHeight
        
        let selectedDetailedTopics = topic.children.values.filter { $0.isSelected.wrappedValue }
        let numDetailedTopics: Int = selectedDetailedTopics.count
        let numRows = ((numDetailedTopics-1) / 3) + 1
        
        let height: CGFloat = (buttonHeight + 15.0) * CGFloat(numRows) + 50.0
        self._totalHeight.wrappedValue += height
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
                    .stroke(Color("MainColor"), lineWidth: 2)
                    .foregroundColor(Color("DetailedCategoryColor"))
                    .frame(width: width, height: height)
                
                
                Text(topic.title)
                    .foregroundColor(Color("MainColor"))
                    .font(.system(size: textSize))
                    .bold()
            }
        }
    }
}

#Preview {
    MyProfileTabDetailView(myProfile: CardModel(id: UUID() , name: "하워드", age: 30, description: "야생의 하워드가 나타났다!", birthDate: "2003-04-24", mbti: "ISTP", tag: "선생님", dDay: 80, imageData: UIImage(named: "Giselle")!.pngData()!))
}
