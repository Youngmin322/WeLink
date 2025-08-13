//
//  MainTabView.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    @State private var hideTabBar = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if selectedTab == 0 {
                    MenuTabView()
                        .onReceive(NotificationCenter.default.publisher(for: .hideTabBar)) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hideTabBar = true
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .showTabBar)) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hideTabBar = false
                            }
                        }
                } else if selectedTab == 1 {
                    FriendsTabView()
                        .onReceive(NotificationCenter.default.publisher(for: .hideTabBar)) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hideTabBar = true
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .showTabBar)) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hideTabBar = false
                            }
                        }
                } else if selectedTab == 2 {
                    MyProfileTabView()
                        .onReceive(NotificationCenter.default.publisher(for: .hideTabBar)) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hideTabBar = true
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .showTabBar)) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hideTabBar = false
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if !hideTabBar {
                GeometryReader { geometry in
                    let screenWidth = geometry.size.width
                    let tabBarWidth = screenWidth * 0.885
                    let tabWidth = tabBarWidth / 3
                    let overlayWidth = tabWidth - 8
                    let selectedTabOffset = (CGFloat(selectedTab) - 1) * tabWidth
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: tabBarWidth, height: 52)
                            .background(Color(red: 0.16, green: 0.16, blue: 0.16).opacity(0.5))
                            .cornerRadius(31)
                            .overlay(
                                RoundedRectangle(cornerRadius: 31)
                                    .inset(by: 0.75)
                                    .stroke(Color(red: 0.28, green: 0.28, blue: 0.28), lineWidth: 1.0)
                            )
                        
                        // 애니메이션 오버레이
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.5),
                                        Color.gray.opacity(0.3)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                            .frame(width: overlayWidth, height: 48)
                            .offset(x: selectedTabOffset)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab)
                        
                        HStack(spacing: 0) {
                            TabBarItem(title: "메뉴", systemImage: "line.3.horizontal", isSelected: selectedTab == 0) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = 0
                                }
                            }
                                
                            TabBarItem(title: "메인", systemImage: "person.3.fill", isSelected: selectedTab == 1) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedTab = 1
                                    }
                                }
                            TabBarItem(title: "마이페이지", systemImage: "person.crop.circle", isSelected: selectedTab == 2) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedTab = 2
                                    }
                                }
                        }
                        .frame(width: tabBarWidth)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 55)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct TabBarItem: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.clear)
                .cornerRadius(25)
            
            Image(systemName: systemImage)
                .foregroundColor(isSelected ? Color("MainColor") : .white)
                .font(.system(size: 24, weight: isSelected ? .medium : .regular))
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}

// Notification 확장
extension Notification.Name {
    static let hideTabBar = Notification.Name("hideTabBar")
    static let showTabBar = Notification.Name("showTabBar")
}

#Preview {
    ContentView()
        .modelContainer(for: CardModel.self, inMemory: true)
}
