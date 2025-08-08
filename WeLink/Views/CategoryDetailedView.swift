//
//  CategoryDetailedView.swift
//  WeLink
//
//  Created by 럭스(양광모) on 8/6/25.
//

import SwiftUI

struct CategoryDetailedView: View {
    var progress: CGFloat
    @State var selectedTopics: [mainTopic]
    @State private var currentIndex: Int = 0
    // selectedDetailedTopicsDict["스포츠"].append(~~)
    @State private var selectedDetailedTopicsList: [[detailedTopic]] = [[], [], []]
    @ObservedObject var categories: Category
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
                        .font(.system(size:22, weight: .bold))
                        .padding(.bottom, 2)
                    
                    Text("최소 1개에서 최대 10개까지 선택해주세요.")
                        .frame(width: textWidth, alignment: .leading)
                        .foregroundColor(Color("MainColor"))
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.bottom)
                
                
                // 상단 대주제 버튼
                HStack(spacing: 10){
                    ForEach(Array($selectedTopics.enumerated()), id: \.element.id){index, topic in
                        CategoryButton(topic: topic, selectedTopics: $selectedTopics, currentIndex: $currentIndex, sectionTotalHeights: $sectionTotalHeights, index: index)
                    }
                }
                
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
                    Button(action: {
                        sectionTotalHeights = [0, 0, 0]
                        goNext = true
                        
                        //TODO: 선택한 카테고리 저장하는 로직
                        
                    }) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: nextButtonWidth, height: nextButtonHeight)
                            .padding()
                            .background(isReady ? Color("MainColor") : Color.gray)
                            .clipShape(Capsule())
                    }
                    .disabled(!isReady)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goNext) {
                SettingCompleteView(
                    progress: 5.0 / 5.0,
                )
            }
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
                            .font(.headline)
                            .foregroundColor(topic.isSelected ? .black : .white)
                    }
                    .frame(maxWidth: boxSize, maxHeight: boxSize)
                }
            }
        }
    }
    
    struct SectionView: View {
        let subTopic: subTopic
        let width: CGFloat
        @Binding var totalHeight: CGFloat
        @Binding var selectedTopics: [detailedTopic]
        
        let buttonWidth: CGFloat = 110
        let buttonHeight: CGFloat = 45

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
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 25, weight: .bold))
                            .font(.headline)
                    }
                    .padding(.top, 10)
                    
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
                            .font(.headline)
                            .foregroundColor(topic.isSelected ? Color("MainColor") : .white)
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
