//
//  CardScrollView.swift
//  WeLink
//
//  Created by 조영민 on 8/8/25.
//

import SwiftUI

struct CardScrollView: View {
    let cards: [CardModel]
    @Binding var currentIndex: Int
    @State private var scrollPosition: UUID? = nil
    
    private var safeCurrentIndex: Int {
        guard !cards.isEmpty else { return 0 }
        return min(max(currentIndex, 0), cards.count - 1)
    }
    
    var body: some View {
        VStack(spacing: 1) {
            if !cards.isEmpty {
                Text("\(cards[safeCurrentIndex].name) 님의 카드")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("MainColor"))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    .animation(.easeInOut(duration: 0.2), value: safeCurrentIndex)
                    .padding(.bottom, 30)
            }
            
            GeometryReader { geometry in
                let cardWidth: CGFloat = 280
                let cardHeight: CGFloat = 480
                let spacing: CGFloat = 20
                let sideSpacing: CGFloat = 50
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: spacing) {
                        ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                            MyProfileCardOnlyView(card: card)
                                .frame(width: cardWidth, height: cardHeight)
                                .scaleEffect(index == safeCurrentIndex ? 1.0 : 0.85)
                                .opacity(index == safeCurrentIndex ? 1.0 : 0.7)
                                .shadow(
                                    color: .black.opacity(0.3),
                                    radius: index == safeCurrentIndex ? 15 : 8,
                                    x: 0,
                                    y: index == safeCurrentIndex ? 8 : 4
                                )
                                .animation(.easeInOut(duration: 0.3), value: safeCurrentIndex)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        // 유효한 인덱스 범위 내에서만 업데이트
                                        if index >= 0 && index < cards.count {
                                            currentIndex = index
                                            scrollPosition = card.id
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, sideSpacing)  // 고정된 사이드 스페이싱 사용
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $scrollPosition)
                .clipShape(Rectangle())  // scrollClipDisabled 대신 명시적 클리핑 해제
                .onChange(of: scrollPosition) { _, newPosition in
                    // 스크롤 위치가 변경되면 currentIndex 업데이트
                    if let newPosition = newPosition,
                       let index = cards.firstIndex(where: { $0.id == newPosition }) {
                        DispatchQueue.main.async {
                            currentIndex = index
                        }
                    }
                }
            }
            .frame(height: 480)
            
            // 페이지 인디케이터 (2개 이상일 때만 표시)
            if cards.count > 1 {
                HStack(spacing: 6) {
                    ForEach(0..<cards.count, id: \.self) { index in
                        Circle()
                            .fill(index == safeCurrentIndex ? Color.white : Color.white.opacity(0.4))
                            .frame(width: 6, height: 6)
                            .scaleEffect(index == safeCurrentIndex ? 1.1 : 1.0)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                            .animation(.easeInOut(duration: 0.3), value: safeCurrentIndex)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    // 유효한 인덱스 범위 내에서만 업데이트
                                    if index >= 0 && index < cards.count {
                                        currentIndex = index
                                        scrollPosition = cards[index].id
                                    }
                                }
                            }
                    }
                }
                .padding(.top, 2)
            }
        }
        .onAppear {
            // 뷰가 나타날 때 인덱스 안전성 확인 및 스크롤 위치 설정
            if !cards.isEmpty {
                if currentIndex >= cards.count {
                    DispatchQueue.main.async {
                        currentIndex = 0
                        scrollPosition = cards[0].id
                    }
                } else {
                    scrollPosition = cards[safeCurrentIndex].id
                }
            }
        }
        .onChange(of: cards) { _, newCards in
            // 카드 배열이 변경될 때 (검색 등)
            DispatchQueue.main.async {
                if newCards.isEmpty {
                    currentIndex = 0
                    scrollPosition = nil
                } else {
                    let newIndex = min(currentIndex, newCards.count - 1)
                    currentIndex = newIndex
                    scrollPosition = newCards[newIndex].id
                }
            }
        }
        .onChange(of: currentIndex) { _, newIndex in
            // currentIndex가 외부에서 변경될 때 스크롤 위치 동기화
            if !cards.isEmpty && newIndex >= 0 && newIndex < cards.count {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scrollPosition = cards[newIndex].id
                }
            }
        }
    }
}
