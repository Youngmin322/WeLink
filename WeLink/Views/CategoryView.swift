//
//  CategoryView.swift
//  WeLink
//
//  Created by 럭스(양광모) on 8/4/25.
//

import SwiftUI

struct CategoryView: View {
    var progress: CGFloat
    
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
                Button(action: {
                    //TODO: View 이동 action 추가하기
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 28))
                        .frame(width: 330, alignment: .leading)
                        .foregroundColor(Color("MainColor"))
                }
                .padding(.bottom, 20)
    
                
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
                
                
            }
        }
    }
}

#Preview{
    CategoryView(progress: 1.0 / 3.0)
}
