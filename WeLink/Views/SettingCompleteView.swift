//
//  SettingCompleteView.swift
//  WeLink
//
//  Created by 럭스(양광모) on 8/7/25.
//

//
//  CategoryView.swift
//  WeLink
//
//  Created by 럭스(양광모) on 8/6/25.
//

import SwiftUI

struct SettingCompleteView: View {
    var progress: CGFloat
    @ObservedObject var cardModel: CardModel
    @State private var goNext:Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
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
                //.padding(.bottom, 20)
                
                ZStack{
                    //가운데 오브젝트
                    let objWidth: CGFloat = 350
                    let objHeight: CGFloat = 350
                    Image("Onboarding2")
                        .resizable()               // 이미지 크기 조정 가능
                        .scaledToFit()
                        .frame(width: objWidth, height: objHeight, alignment: .leading)
                        .padding(.top, 75)
                        .offset(x: -40)
                    
                    let numTopics = cardModel.topics.count
                    Text(cardModel.topics[0].title)
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                        .offset(x: 65, y: -33)
                    if numTopics > 1 {
                        Text(cardModel.topics[1].title)
                            .foregroundColor(.white)
                            .font(.system(size: 23, weight: .bold))
                            .offset(x: 50, y: 112)
                        if numTopics > 2 {
                            Text(cardModel.topics[2].title)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                                .offset(x: -87, y: 33)
                        }
                    }
                }
                
                
                
                
                //중하단 텍스트
                VStack(spacing: 10){
                    Text("취향을 파악했어요!")
                        .foregroundColor(Color(.white))
                        .font(.system(size: 33, weight: .bold))
                    Text("나만의 취향카드를 만들어드릴게요!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color("MainColor"))
                }
                .padding(.top)
                
                
                VStack(){
                    let nextButtonWidth: CGFloat = 310
                    let nextButtonHeight: CGFloat = 25
                    
                    Spacer()
                    Button(action: {
                        context.insert(cardModel)
                        try? context.save()
                        
                        goNext = true
                    }) {
                        Text("앱 시작하기")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: nextButtonWidth, height: nextButtonHeight)
                            .padding()
                            .background(Color("MainColor"))
                            .clipShape(Capsule())
                    }
                }
            }
            
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $goNext) {
            ContentView()
        }
        
    }
    
}




//#Preview{
//    SettingCompleteView(progress: 5.0 / 5.0)
//}
