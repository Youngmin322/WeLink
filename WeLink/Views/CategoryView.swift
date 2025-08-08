//
//  CategoryView.swift
//  WeLink
//
//  Created by 럭스(양광모) on 8/6/25.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    var progress: CGFloat
    @ObservedObject var cardModel: CardModel
    let categories: Category = Category()
    @State var selectedTopics: [mainTopic] = []
    @State var isReady: Bool = false
    @State private var goNext:Bool = false
    
    @Query private var myID: [MyUUID]
    
    var body: some View {
        NavigationStack{
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
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
                    HStack(){
                        Button(action: {
                            //TODO: View 이동 action 추가하기
                            
                                print(myID.first?.id.uuidString ?? "uuid not found")
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28))
                                .frame(width: backButtonWidth, alignment: .leading)
                                .foregroundColor(Color("MainColor"))
                        }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    .frame(width: 330)
                    
                    
                    // 상단 텍스트
                    VStack(){
                        let textWidth:CGFloat = 324
                        
                        Text("요즘 어떤 것에 관심이 있으신가요?\n카테고리를 선택해주세요.")
                            .frame(width: textWidth, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size:22, weight: .bold))
                            .padding(.bottom, 2)
                        
                        Text("최대 3개까지 선택해주세요.")
                            .frame(width: textWidth, alignment: .leading)
                            .foregroundColor(Color("MainColor"))
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .padding(.bottom)
                    
                    ScrollView{
                        let categoryWidth: CGFloat = 360
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(categories.mainTopicsList, id: \.self) { title in
                                if let topic = categories.mainTopics[title] {
                                    CategoryButton(topic: topic, selectedTopics: $selectedTopics, isReady: $isReady)
                                }
                                
                            }
                        }
                        .frame(width: categoryWidth)
                        .padding(.bottom)
                    }
                    let nextButtonWidth: CGFloat = 310
                    let nextButtonHeight: CGFloat = 25
                    if isReady{
                        Button(action: {
                            goNext = true
                        }) {
                            Text("다음")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: nextButtonWidth, height: nextButtonHeight)
                                .padding()
                                .background(isReady ? Color("MainColor") : Color.gray)
                                .clipShape(Capsule())
                        }
                        .disabled(selectedTopics.count==0)
                    }
                }
            }
            .navigationDestination(isPresented: $goNext) {
                CategoryDetailedView(
                    progress: 3.0 / 4.0,
                    selectedTopics: selectedTopics,
                    categories: categories,
                    cardModel: cardModel
                )
            }
        }
        .navigationBarHidden(true)
    }
    
        
        
        struct CategoryButton: View {
            @ObservedObject var topic: mainTopic
            @Binding var selectedTopics: [mainTopic]
            @Binding var isReady: Bool
            
            let boxSize: CGFloat = 155
            
            var body: some View {
                Button(action: {
                    if !(selectedTopics.count == 3 && !topic.isSelected){
                        topic.isSelected.toggle()
                        updateSelectedTopicList(topicList: &selectedTopics, tgt: topic)
                    }
                    isReady = (selectedTopics.count > 0 && selectedTopics.count < 4) ? true : false
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(topic.isSelected ? Color("MainColor") : Color("CategoryColor"))
                            .frame(width: boxSize, height: boxSize)
                        
                        VStack(spacing: 8) {
                            Text(topic.emoji)
                            Text(topic.title)
                                .font(.headline)
                                .foregroundColor(topic.isSelected ? .black : .white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
    }



func updateSelectedTopicList(topicList: inout [mainTopic], tgt: mainTopic){
    if tgt.isSelected{
        topicList.append(mainTopic(title: tgt.title, emoji: tgt.emoji, children: tgt.children, isSelected: false))
    }
    else{
        topicList.removeAll { $0.title == tgt.title }
    }
    
    if topicList.count > 0{
        topicList[0].isSelected = true
    }
}


//#Preview{
//    CategoryView(progress: 3.0 / 5.0)
//}
