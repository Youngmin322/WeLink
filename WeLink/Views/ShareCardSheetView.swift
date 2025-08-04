//
//  ShareCardSheetView.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI

struct ShareCardSheetView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("카드 공유")
                .font(.title)
                .bold()
            Text("주변 친구들을 찾는 중입니다.")
            ProgressView()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ShareCardSheetView()
}
