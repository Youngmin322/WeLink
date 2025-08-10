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
    
    @Environment(\.modelContext) private var modelContext
    @State private var showingDeleteAlert = false
    @State private var cardToDelete: CardModel? = nil
    @State private var isAnyCardDragging = false
    
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
                            SwipeableCardView(
                                card: card,
                                isSelected: index == safeCurrentIndex,
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        if index >= 0 && index < cards.count {
                                            currentIndex = index
                                            scrollPosition = card.id
                                        }
                                    }
                                },
                                onDelete: {
                                    cardToDelete = card
                                    showingDeleteAlert = true
                                },
                                onDragStateChanged: { isDragging in
                                    isAnyCardDragging = isDragging
                                }
                            )
                            .frame(width: cardWidth, height: cardHeight)
                        }
                    }
                    .padding(.horizontal, sideSpacing)
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $scrollPosition)
                .scrollDisabled(isAnyCardDragging)
                .clipShape(Rectangle())
                .onChange(of: scrollPosition) { _, newPosition in
                    if let newPosition = newPosition,
                       let index = cards.firstIndex(where: { $0.id == newPosition }) {
                        DispatchQueue.main.async {
                            currentIndex = index
                        }
                    }
                }
            }
            .frame(height: 480)
            
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
            if !cards.isEmpty && newIndex >= 0 && newIndex < cards.count {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scrollPosition = cards[newIndex].id
                }
            }
        }
        .alert("카드 삭제", isPresented: $showingDeleteAlert) {
            Button("취소", role: .cancel) {
                cardToDelete = nil
            }
            Button("삭제", role: .destructive) {
                if let cardToDelete = cardToDelete {
                    deleteCard(cardToDelete)
                }
                self.cardToDelete = nil
            }
        } message: {
            if let cardToDelete = cardToDelete {
                Text("\(cardToDelete.name)님의 카드를 삭제하시겠습니까?")
            }
        }
    }
    
    private func deleteCard(_ card: CardModel) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if let deleteIndex = cards.firstIndex(where: { $0.id == card.id }) {
                modelContext.delete(card)
                
                if deleteIndex <= currentIndex && currentIndex > 0 {
                    currentIndex = currentIndex - 1
                }
                
                if cards.count <= 1 {
                    currentIndex = 0
                }
            }
        }
    }
}

// MARK: - SwipeableCardView
struct SwipeableCardView: View {
    let card: CardModel
    let isSelected: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    let onDragStateChanged: (Bool) -> Void
    
    @State private var verticalOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var showDeleteButton = false
    
    private let deleteThreshold: CGFloat = -200
    private let showDeleteButtonThreshold: CGFloat = -60
    
    var body: some View {
        ZStack {
            if showDeleteButton {
                Button(action: {
                    onDelete()
                }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .dark)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 2)
                            )
                        
                        Image(systemName: "trash")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.red)
                    }
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .offset(y: 100)
                .scaleEffect(showDeleteButton ? 1.0 : 0.0)
                .opacity(showDeleteButton ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showDeleteButton)
            }
            
            MyProfileCardOnlyView(card: card)
                .scaleEffect(isSelected ? 1.0 : 0.85)
                .opacity(isSelected ? 1.0 : 0.7)
                .shadow(
                    color: .black.opacity(0.3),
                    radius: isSelected ? 15 : 8,
                    x: 0,
                    y: isSelected ? 8 : 4
                )
                .offset(x: 0, y: verticalOffset)
                .scaleEffect(isDragging ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
                .animation(.easeInOut(duration: 0.15), value: isDragging)
        }
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    let verticalMovement = abs(value.translation.height)
                    let horizontalMovement = abs(value.translation.width)
                    
                    if verticalMovement > horizontalMovement * 2 &&
                        (value.translation.height < -10 || (showDeleteButton && value.translation.height > -150)) &&
                        verticalMovement > 20 {
                        
                        if !isDragging {
                            isDragging = true
                            onDragStateChanged(true)
                        }
                        verticalOffset = value.translation.height
                        
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showDeleteButton = value.translation.height < showDeleteButtonThreshold
                        }
                    }
                }
                .onEnded { value in
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                        if showDeleteButton {
                            if value.translation.height > 40 {
                                showDeleteButton = false
                                verticalOffset = 0
                            } else {
                                verticalOffset = -250
                            }
                        } else {
                            verticalOffset = 0
                        }
                        isDragging = false
                        onDragStateChanged(false)
                    }
                }
        )
        .onTapGesture {
            if !isDragging && verticalOffset == 0 && !showDeleteButton {
                onTap()
            }
        }
    }
    
    private func resetStates() {
        verticalOffset = 0
        isDragging = false
        showDeleteButton = false
        onDragStateChanged(false)
    }
}
