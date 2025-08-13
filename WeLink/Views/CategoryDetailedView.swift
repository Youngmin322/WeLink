//
//  CategoryDetailedView.swift
//  WeLink
//
//  Created by 럭스(양광모) on 8/6/25.
//

import SwiftUI

struct CategoryDetailedView: View {
    var progress: CGFloat
    var isEdit: Bool
    @State var selectedTopics: [mainTopic]
    @State private var currentIndex: Int = 0
    // selectedDetailedTopicsDict["스포츠"].append(~~)
    @State private var selectedDetailedTopicsList: [[detailedTopic]] = [[], [], []]
    @ObservedObject var categories: Category
    @Binding var cardModel: CardModel
    var keepGoing: Binding<Bool>? = nil // 기본값 nil
    @Environment(\.dismiss) var dismiss
    
    @State var sectionTotalHeights: [CGFloat] = [0, 0, 0]
    
    @State private var goNext:Bool = false
    
    var body: some View {
        
        ZStack{
            Color("BackgroundColor")
                .ignoresSafeArea()
            VStack{
                // 상단바
                ZStack(alignment: .leading) {
                    let barWidth: CGFloat = 324
                    let barHeight: CGFloat = 2
                    
                    // 회색 배경 바
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: barWidth, height: barHeight)
                    
                    // 연두색 프로그레스 바
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("MainColor"))
                        .frame(width: barWidth * progress, height: barHeight)
                }
                .padding(.bottom, 20)
                
                
                //뒤로가기 버튼
                let backButtonWidth: CGFloat = 20
                HStack{
                    Button(action: {
                        for item in selectedDetailedTopicsList {
                            for detailedTopic in item {
                                detailedTopic.isSelected.toggle()
                            }
                        }
                        
                        sectionTotalHeights = [0, 0, 0]
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 28))
                            .frame(width: backButtonWidth, alignment: .leading)
                            .foregroundColor(Color("MainColor"))
                    }
                    Spacer()
                }
                .frame(width: 330)
                .padding(.bottom, 20)
                
                // 상단 텍스트
                VStack(){
                    let textWidth:CGFloat = 324
                    
                    Text("조금 더 구체적으로 알려주세요!")
                        .frame(width: textWidth, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.custom("Pretendard-Bold", size: 22))
                        .padding(.bottom, 1)
                    
                    Text("최소 1개에서 최대 10개까지 선택해주세요.")
                        .frame(width: textWidth, alignment: .leading)
                        .foregroundColor(Color("MainColor"))
                        .font(.custom("Pretendard-Bold", size: 14))
                }
                .padding(.bottom)
                
                .padding()
                
                // 상단 대주제 버튼
                HStack(spacing: 10){
                    ForEach(Array($selectedTopics.enumerated()), id: \.element.id){index, topic in
                        CategoryButton(topic: topic, selectedTopics: $selectedTopics, currentIndex: $currentIndex, sectionTotalHeights: $sectionTotalHeights, index: index)
                    }
                }
                .padding(.bottom, 20)
                
                //하단 중, 소 주제 선택창
                ScrollView {
                    ZStack{
                        let subTopicDict: [String:subTopic] = selectedTopics[currentIndex].children
                        let numSubTopics: Int = (Array(subTopicDict.keys)).count
                        let sectionWidth: CGFloat = 375.0
                        
                        // 중, 소 주제 배경
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("CategoryColor"))
                            .frame(width: sectionWidth, height: sectionTotalHeights[currentIndex])
                        
                        // 각 섹션
                        VStack(spacing: 0) {
                            ForEach(Array(subTopicDict.values.sorted{ $0.title < $1.title }.enumerated()), id:\.1.title){ index, subTopic in
                                SectionView(subTopic: subTopic, width: sectionWidth, totalHeight: $sectionTotalHeights[currentIndex], selectedTopics: $selectedDetailedTopicsList[currentIndex])
                                if index < numSubTopics - 1 {
                                    Divider().background(Color.gray)
                                        .padding(.vertical, 0)
                                }
                            }
                        }
                        .frame(width: sectionWidth, alignment: .topLeading)
                    }
                }
                
                
                let nextButtonWidth: CGFloat = 310
                let nextButtonHeight: CGFloat = 25
                let isReady:Bool = selectedDetailedTopicsList.prefix(selectedTopics.count).allSatisfy { !$0.isEmpty }
                if isReady{
                    let nextView = isEdit ? AnyView(MyProfileTabDetailView(myProfile: cardModel)) : AnyView(SettingCompleteView(
                        progress: 5.0 / 5.0,
                        cardModel: cardModel
                    ))
                    NavigationLink(destination: nextView) {
                        let text = isEdit ? "완료" : "다음"
                        Text(text)
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: nextButtonWidth, height: nextButtonHeight)
                            .padding()
                            .background(isReady ? Color("MainColor") : Color.gray)
                            .clipShape(Capsule())
                    }
                    .disabled(!isReady)
                    .simultaneousGesture(TapGesture().onEnded {
                        sectionTotalHeights = [0, 0, 0]
                        cardModel.topics = []
                        for topic in selectedTopics{
                            cardModel.topics.append(topic)
                        }
                        if isEdit {
                            keepGoing?.wrappedValue = false
                        }
                    })
            
                }
            }
            .padding(.bottom, isEdit ? 55 : 0)
            .navigationBarHidden(true)
            
        }
    }
    struct CategoryButton: View {
        @Binding var topic: mainTopic
        @Binding var selectedTopics: [mainTopic]
        @Binding var currentIndex: Int
        @Binding var sectionTotalHeights: [CGFloat]
        let index: Int
        
        let boxSize: CGFloat = 115
        
        var body: some View {
            Button(action: {
                selectedTopics[currentIndex].isSelected.toggle()
                if currentIndex != index{
                    sectionTotalHeights[currentIndex] = 0
                }
                topic.isSelected.toggle()
                currentIndex = index
            }) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(topic.isSelected ? Color("MainColor") : Color("CategoryColor"))
                        .frame(width: boxSize, height: boxSize)
                    
                    VStack(spacing: 8) {
                        Text(topic.emoji)
                        Text(topic.title)
                            .font(.custom("Pretendard-Medium", size: 16))
                            .foregroundColor(topic.isSelected ? .black : .white)
                    }
                    .frame(maxWidth: boxSize, maxHeight: boxSize)
                }
            }
        }
    }
    
    
    //TODO: 대주제 3개 선택시 배경 section 박스가 제대로 안나오는 경우가 생김!!
    struct SectionView: View {
        let subTopic: subTopic
        let width: CGFloat
        @Binding var totalHeight: CGFloat
        @Binding var selectedTopics: [detailedTopic]
        
        let buttonWidth: CGFloat = 110
        let buttonHeight: CGFloat = 48
        
        var body: some View {
            let numRows: Int = ((subTopic.children.count-1) / 3) + 1
            let height: CGFloat = (buttonHeight + 15.0) * CGFloat(numRows) + 50.0
            
            let detailedTopics: [detailedTopic] = subTopic.children.values.sorted { $0.title < $1.title }
            
            ZStack(alignment: .top){
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("CategoryColor"))
                    .frame(width: width, height: height)
                VStack{
                    HStack(spacing: 0){
                        Text("#")
                            .foregroundColor(Color("MainColor"))
                            .bold()
                            .font(.system(size: 25, weight: .bold))
                            .font(.headline)
                        Text(subTopic.title)
                            .foregroundColor((Color(.white)))
                            .bold()
                            .font(.system(size: 20, weight: .bold))
                            .font(.headline)
                    }
                    .padding(.top, 20)
                    
                    let columns = [GridItem(.fixed(buttonWidth), alignment: .center),
                                   GridItem(.fixed(buttonWidth), alignment: .center),
                                   GridItem(.fixed(buttonWidth), alignment: .center)]
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(detailedTopics, id: \.self.title) { detailedTopic in
                            detailedTopicButton(topic: detailedTopic, width: buttonWidth, height: buttonHeight, selectedTopics: $selectedTopics)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .onAppear {
                totalHeight += height
            }
        }
    }
    
    struct detailedTopicButton: View {
        @ObservedObject var topic: detailedTopic
        let width: CGFloat
        let height: CGFloat
        @Binding var selectedTopics: [detailedTopic]
        
        var body: some View {
            Button(action: {
                if !(selectedTopics.count == 10 && !topic.isSelected) {
                    topic.isSelected.toggle()
                }
                updateSelectedDetailedTopicList(topicList: &selectedTopics, tgt: topic)
            }) {
                ZStack {
                    Capsule()
                        .fill(topic.isSelected ? Color("DetailedCategoryColor") : Color("BackgroundColor"))
                        .stroke(topic.isSelected ? Color("MainColor") : Color.clear, lineWidth: 2)
                        .frame(width: width, height: height)
                    
                    
                    VStack(spacing: 8) {
                        Text(topic.title)
                            .font(.custom("Pretendard-Medium", size: 15))
                            .foregroundColor(topic.isSelected ? Color("MainColor") : Color("CategoryKeyword"))
                    }
                    .frame(width: width, height: height)
                }
            }
            .frame(width: width, height: height)
        }
    }
}




func updateSelectedDetailedTopicList(topicList: inout [detailedTopic], tgt: detailedTopic){
    if tgt.isSelected{
        topicList.append(tgt)
    }
    else{
        topicList.removeAll { $0.title == tgt.title }
    }
}


//#Preview {
//    // 테스트용 detailedTopic 생성
//    let footballTopic = detailedTopic(title: "축구")
//    let basketballTopic = detailedTopic(title: "농구")
//    let baseballTopic = detailedTopic(title: "야구")
//    let tennisTopic = detailedTopic(title: "테니스")
//    let swimmingTopic = detailedTopic(title: "수영")
//    let runningTopic = detailedTopic(title: "러닝")
//    
//    let movieTopic = detailedTopic(title: "영화")
//    let dramaTopic = detailedTopic(title: "드라마")
//    let animeTopic = detailedTopic(title: "애니메이션")
//    let varietyTopic = detailedTopic(title: "예능")
//    let documentaryTopic = detailedTopic(title: "다큐멘터리")
//    let musicTopic = detailedTopic(title: "음악")
//    
//    let gameTopic = detailedTopic(title: "게임")
//    let readingTopic = detailedTopic(title: "독서")
//    let cookingTopic = detailedTopic(title: "요리")
//    let travelTopic = detailedTopic(title: "여행")
//    let photographyTopic = detailedTopic(title: "사진")
//    let drawingTopic = detailedTopic(title: "그림")
//    
//    // 테스트용 subTopic 생성
//    let ballSportsTopic = subTopic(title: "구기 스포츠", children: [
//        "축구": footballTopic,
//        "농구": basketballTopic,
//        "야구": baseballTopic,
//        "테니스": tennisTopic
//    ])
//    
//    let individualSportsTopic = subTopic(title: "개인 스포츠", children: [
//        "수영": swimmingTopic,
//        "러닝": runningTopic
//    ])
//    
//    let visualContentTopic = subTopic(title: "영상 콘텐츠", children: [
//        "영화": movieTopic,
//        "드라마": dramaTopic,
//        "애니메이션": animeTopic,
//        "예능": varietyTopic,
//        "다큐멘터리": documentaryTopic
//    ])
//    
//    let audioContentTopic = subTopic(title: "오디오 콘텐츠", children: [
//        "음악": musicTopic
//    ])
//    
//    let indoorHobbiesTopic = subTopic(title: "실내 취미", children: [
//        "게임": gameTopic,
//        "독서": readingTopic,
//        "요리": cookingTopic
//    ])
//    
//    let outdoorHobbiesTopic = subTopic(title: "실외 취미", children: [
//        "여행": travelTopic,
//        "사진": photographyTopic,
//        "그림": drawingTopic
//    ])
//    
//    // 테스트용 mainTopic 생성
//    let sportsTopic = mainTopic(
//        title: "스포츠",
//        emoji: "⚽️",
//        children: [
//            "구기 스포츠": ballSportsTopic,
//            "개인 스포츠": individualSportsTopic
//        ], isSelected: true
//    )
//    
//    let entertainmentTopic = mainTopic(
//        title: "엔터테인먼트",
//        emoji: "🎬",
//        children: [
//            "영상 콘텐츠": visualContentTopic,
//            "오디오 콘텐츠": audioContentTopic
//        ], isSelected: false
//    )
//    
//    let hobbiesTopic = mainTopic(
//        title: "취미",
//        emoji: "🎨",
//        children: [
//            "실내 취미": indoorHobbiesTopic,
//            "실외 취미": outdoorHobbiesTopic
//        ], isSelected: false
//    )
//    
//    // 테스트용 Category와 CardModel 생성
//    let testCategory = Category()
//    let testCardModel = CardModel(
//        id: UUID(),
//        name: "테스트 사용자",
//        age: 25,
//        description: "테스트 설명",
//        birthDate: "1999-01-01",
//        mbti: "ENFP",
//        tag: "일반",
//        dDay: 100,
//        imageData: Data()
//    )
//    
//    CategoryDetailedView(
//        progress: 0.6,
//        isEdit: false,
//        selectedTopics: [sportsTopic, entertainmentTopic, hobbiesTopic],
//        categories: testCategory,
//        cardModel: testCardModel
//    )
//}
