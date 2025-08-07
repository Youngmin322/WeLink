//
//  FlipCard.swift
//  WeLink
//
//  Created by weonyee on 8/7/25.
//

import SwiftUI

struct FlipCard<Front: View, Back: View>: View {
    @State private var flipped = false
    let front: Front
    let back: Back

    init(@ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back) {
        self.front = front()
        self.back = back()
    }

    var body: some View {
        ZStack {
            front
                .opacity(flipped ? 0 : 1)
                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            back
                .opacity(flipped ? 1 : 0)
                .rotation3DEffect(.degrees(flipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 302, height: 500)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                flipped.toggle()
            }
        }
    }
}
