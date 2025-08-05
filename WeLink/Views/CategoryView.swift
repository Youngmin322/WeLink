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
        VStack{
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
                
                .frame(height: 8) // 고정 높이
        }
    }
}

#Preview{
    CategoryView(progress: 1.0 / 3.0)
}
