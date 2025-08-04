//
//  MainTabView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MenuTabView()
                .tabItem {
                    Image(systemName: "line.3.horizontal")
                }

            FriendsTabView()
                .tabItem {
                    Image(systemName: "person.3")
                }
            
            MyProfileTabView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CardModel.self, inMemory: true)
}
