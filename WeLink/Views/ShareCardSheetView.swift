//
//  ShareCardSheetView.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI

struct ShareCardSheetView: View {
    @StateObject var mpc = MultipeerManager()
    @State private var dotCount: Int = 0
    @State private var dotTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    let myCard: CardModel

    var body: some View {
        VStack(spacing: 20) {
            Text("카드 공유")
                .font(.title)
                .bold()

            Text("주변 기기를 검색 중" + String(repeating: ".", count: dotCount))
                .foregroundColor(.gray)

            Button("내 카드 전송") {
                mpc.sendCard(myCard)
            }

            if let card = mpc.receivedCard {
                Text("받은 카드: \(card.name)")
                    .padding()
            }

            Spacer()
        }
        .padding()
        .onAppear {
            mpc.startHosting()
            mpc.startBrowsing()
        }
        .onDisappear {
             mpc.stopHosting()
             mpc.stopBrowsing()
        }
        .onReceive(dotTimer) { _ in
            dotCount = (dotCount + 1) % 4
        }
    }
}

//#Preview {
//    ShareCardSheetView(myCard: CardModel())
//}
