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
    @Environment(\.dismiss) var dismiss
    
    init(myProfile: CardModel) {
        self.myProfile = myProfile
        self.currentTopic = myProfile.topics[0]
        for topic in myProfile.topics{
            topic.isSelected = false
        }
        self.currentTopic.isSelected = true
    }
    
    var body: some View {
        ScrollView{
            ZStack{
                VStack{
                    ZStack{
                        ZStack{
                            //TODO: 배경 이미지 바꾸고, 밑에 카테고리는 스크롤로 하기
                            Image(uiImage: UIImage(data: myProfile.imageData)!)
                                .resizable()
                                .scaledToFit()
                                .overlay( VStack{
                                    Spacer()
                                
                                        // 어둡게 그라데이션
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: 0x010101),
                                                Color.clear
                                            ]),
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                        .frame(height: 200)
                                }
                                )
                            
                        }
                        
                        VStack{
                            // 상단 메뉴 버튼들
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
                                    //TODO: 프로필, 카테고리 수정 탭
                                }){
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(Color("MainColor"))
                                        .font(.system(size: 30))
                                        .rotationEffect(Angle(degrees: 90))
                                        .bold()
                                }
                                
                            }
                            .padding(.top, 50)
                            
                            Spacer()
                        
                        
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
                    
                    VStack{
                        // 대주제 버튼
                        HStack(spacing: 21){
                            ForEach($myProfile.topics){topic in
                                mainTopicButton(topic: topic, currentTopic: $currentTopic)
                            }
                            
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        }
                        
                        Group {
                            VStack{
                                ForEach(Array($currentTopic.children.values)
                                    .sorted { $0.wrappedValue.title < $1.wrappedValue.title }, id:  \.id){ $subTopic in
                                        subTopicWindow(topic: $subTopic)
                                    }
                            }
                        }
                        
                    }
                }
            }
        .background(Color(hex: 0x010101))
        .navigationBarHidden(true)
        .ignoresSafeArea()
        
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
    
    struct subTopicWindow: View{
        @Binding var topic: subTopic
        let width: CGFloat = 348
        let color: Color = Color(hex: 0x3C3C3C)
        
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 45
        
        var body: some View {
            ZStack{
                let selectedDetailedTopics = topic.children.values.filter { $0.isSelected }
                let numDetailedTopics: Int = selectedDetailedTopics.count
                let numRows = ((numDetailedTopics-1) / 3) + 1
                
                let height: CGFloat = (buttonHeight + 15.0) * CGFloat(numRows) + 50.0
                
                if numDetailedTopics > 0 {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: width, height: height)
                        .foregroundColor(color)
                        .opacity(0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.clear), lineWidth: 0.3)
                                .opacity(0.5)
                        )
                    
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
