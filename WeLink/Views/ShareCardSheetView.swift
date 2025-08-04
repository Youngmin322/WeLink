//
//  ShareCardSheetView.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI

struct ShareCardSheetView: View {
    @StateObject var mpc = MultipeerManager()
    let myCard: CardModel

    var body: some View {
        VStack(spacing: 20) {
            Text("카드 공유")
                .font(.title)
                .bold()

            Button("연결 시작") {
                mpc.startHosting()
                mpc.startBrowsing()
            }

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
    }
}

//#Preview {
//    ShareCardSheetView(, myCard: CardModel())
//}
