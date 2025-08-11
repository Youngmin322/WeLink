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
        cards.safeIndex(currentIndex)
    }
    
    var body: some View {
        VStack(spacing: 1) {
            if !cards.isEmpty {
                Text("\(cards[safeCurrentIndex].name) 님의 카드")
                    .font(.custom("Pretendard-Medium", size: 20))
                    .foregroundColor(Color("MainColor"))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    .animation(AnimationConstants.indexChange, value: safeCurrentIndex)
                    .padding(.bottom, 30)
            }
            
            GeometryReader { geometry in
                let cardWidth: CGFloat = 280
                let cardHeight: CGFloat = 480
                let spacing: CGFloat = 20
                let totalWidth = geometry.size.width
                let centerPadding = (totalWidth - cardWidth) / 2
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: spacing) {
                        ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                            SwipeableCardView(
                                card: card,
                                isSelected: index == safeCurrentIndex,
                                onTap: {
                                    updateIndex(to: index)
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
                    .padding(.horizontal, centerPadding)
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
                            .animation(AnimationConstants.cardTransition, value: safeCurrentIndex)
                            .onTapGesture {
                                updateIndex(to: index)
                            }
                    }
                }
                .padding(.top, 2)
            }
        }
        .onAppear {
            initializeScrollPosition()
        }
        .onChange(of: cards) { _, newCards in
            handleCardsChange(newCards)
        }
        .onChange(of: currentIndex) { _, newIndex in
            handleIndexChange(newIndex)
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
    
    // MARK: - Private Methods
    private func updateIndex(to newIndex: Int) {
        guard newIndex >= 0 && newIndex < cards.count else { return }
        
        withAnimation(AnimationConstants.cardTransition) {
            currentIndex = newIndex
            scrollPosition = cards[newIndex].id
        }
    }
    
    private func initializeScrollPosition() {
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
    
    private func handleCardsChange(_ newCards: [CardModel]) {
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
    
    private func handleIndexChange(_ newIndex: Int) {
        if !cards.isEmpty && newIndex >= 0 && newIndex < cards.count {
            withAnimation(AnimationConstants.cardTransition) {
                scrollPosition = cards[newIndex].id
            }
        }
    }
    
    private func deleteCard(_ card: CardModel) {
        withAnimation(AnimationConstants.cardTransition) {
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
                deleteButtonView
            }
            
            cardView
        }
        .simultaneousGesture(dragGesture)
        .onTapGesture {
            handleTap()
        }
    }
    
    // MARK: - Private Views
    private var deleteButtonView: some View {
        Button(action: onDelete) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                    .environment(\.colorScheme, .dark)
                    .frame(width: 65, height: 65)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                    )
                
                Image(systemName: "trash")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.red)
            }
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
        }
        .offset(y: 100)
        .scaleEffect(showDeleteButton ? 1.0 : 0.0)
        .opacity(showDeleteButton ? 1.0 : 0.0)
        .animation(AnimationConstants.deleteButton, value: showDeleteButton)
    }
    
    private var cardView: some View {
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
            .animation(AnimationConstants.cardTransition, value: isSelected)
            .animation(AnimationConstants.indexChange, value: isDragging)
    }
    
    // MARK: - Private Gestures & Methods
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                handleDragChanged(value)
            }
            .onEnded { value in
                handleDragEnded(value)
            }
    }
    
    private func handleDragChanged(_ value: DragGesture.Value) {
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
            
            withAnimation(AnimationConstants.indexChange) {
                showDeleteButton = value.translation.height < showDeleteButtonThreshold
            }
        }
    }
    
    private func handleDragEnded(_ value: DragGesture.Value) {
        withAnimation(AnimationConstants.dragResponse) {
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
    
    private func handleTap() {
        if !isDragging && verticalOffset == 0 && !showDeleteButton {
            onTap()
        }
    }
}
