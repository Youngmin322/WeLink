//
//  MainTabView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI

struct ContentView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundEffect = blurEffect
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        let mainColor = UIColor(Color("MainColor"))
        appearance.stackedLayoutAppearance.selected.iconColor = mainColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: mainColor]

        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().layer.cornerRadius = 26
        UITabBar.appearance().layer.masksToBounds = true
        UITabBar.appearance().layer.borderWidth = 0
        UITabBar.appearance().clipsToBounds = true
    }
    
    @State private var selectedTab = 1

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    MenuTabView()
                        .tag(0)
                    FriendsTabView()
                        .tag(1)
                    MyProfileTabView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 364, height: 55)
                        .background(Color(red: 0.16, green: 0.16, blue: 0.16).opacity(0.5))
                        .cornerRadius(31)
                        .overlay(
                            RoundedRectangle(cornerRadius: 31)
                                .inset(by: 0.75)
                                .stroke(Color(red: 0.28, green: 0.28, blue: 0.28), lineWidth: 1.0)
                        )
                    
                    HStack(spacing: 0) {
                        TabBarItem(title: "메뉴", systemImage: "line.3.horizontal", isSelected: selectedTab == 0)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                selectedTab = 0
                            }
                        TabBarItem(title: "메인", systemImage: "person.3.fill", isSelected: selectedTab == 1)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                selectedTab = 1
                            }
                        TabBarItem(title: "마이페이지", systemImage: "person.crop.circle", isSelected: selectedTab == 2)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                selectedTab = 2
                            }
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.bottom, -20)
            }
        }
    }
}

struct TabBarItem: View {
    let title: String
    let systemImage: String
    let isSelected: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.clear)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                colors: isSelected ? [
                                    Color.white.opacity(0.9),
                                    Color.white.opacity(0.5),
                                    Color.gray.opacity(0.3)
                                ] : [Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: isSelected ? 2 : 0
                        )
                )
            
            Image(systemName: systemImage)
                .foregroundColor(isSelected ? Color("MainColor") : .white)
                .font(.system(size: 24, weight: isSelected ? .medium : .regular))
        }
        .padding(.horizontal, 8)
    }
}

struct FloatingTabBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 10)
            .background(
                Color.clear
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -1)
            )
    }
}

extension View {
    func floatingTabBarStyle() -> some View {
        self.modifier(FloatingTabBarModifier())
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CardModel.self, inMemory: true)
}
