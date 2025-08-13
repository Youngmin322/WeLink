import SwiftUI
import SwiftData

struct FriendsTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allCards: [CardModel]
    @Query private var myID: [MyUUID]
    @State private var currentIndex = 0
    @State private var showingShareSheet = false
    @State private var preloadedImages: [Int: UIImage] = [:]
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isTextFieldFocused: Bool
    
    private func printAllCards(cards: [CardModel]){
        for card in cards{
            print(card.name)
        }
    }
    
    private var cards: [CardModel] {
        guard let myUUID = myID.last?.id else {
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return allCards
            } else {
                return allCards.filter { card in
                    card.name.localizedCaseInsensitiveContains(searchText.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }
        
        let filteredCards = allCards.filter { $0.id != myUUID }
        
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return filteredCards
        } else {
            return filteredCards.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    private var safeCurrentIndex: Int {
        cards.safeIndex(currentIndex)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    BackgroundImageView(
                        cards: cards,
                        currentIndex: safeCurrentIndex,
                        preloadedImages: preloadedImages
                    )
                    .ignoresSafeArea(.all)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom,
                        alignment: .center
                    )
                    
                    VStack(spacing: 0) {
                        FriendsHeaderView(
                            searchText: $searchText,
                            isSearching: $isSearching,
                            isTextFieldFocused: $isTextFieldFocused,
                            onToggleSearch: toggleSearchMode
                        )
                        .padding(.top, geometry.safeAreaInsets.top - 40)
                        .padding(.horizontal, 24)
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 0)
                        
                        if cards.isEmpty {
                            FriendsEmptyStateView(searchText: searchText)
                                .frame(maxHeight: .infinity)
                        } else {
                            ScrollView {
                                CardScrollView(cards: cards, currentIndex: $currentIndex)
                                    .padding(.top, 20)
                            }
                            .scrollDisabled(true)
                        }
                        
                        Spacer(minLength: 60)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    floatingButton(geometry: geometry)
                }
            }
            .navigationBarHidden(true)
            .onAppear{
                printAllCards(cards: allCards)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            handleKeyboardShow(notification)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
        .onAppear {
            handleViewAppear()
        }
        .onChange(of: allCards) { oldValue, newValue in
            handleAllCardsChange(oldCards: oldValue, newCards: newValue)
        }
        .onChange(of: allCards.count) { oldCount, newCount in
            handleCardsCountChange(oldCount: oldCount, newCount: newCount)
        }
        .onChange(of: cards) { oldValue, newValue in
            handleFilteredCardsChange(oldCards: oldValue, newCards: newValue)
        }
        .onChange(of: searchText) { _, _ in
            resetCurrentIndex()
        }
        .sheet(isPresented: $showingShareSheet) {
            shareSheetView
        }
    }
    
    // MARK: - Floating Button
    private func floatingButton(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showingShareSheet = true
                }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .dark)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color("MainColor"))
                    }
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 24)
                .padding(.bottom, keyboardHeight > 0 ? 140 : geometry.safeAreaInsets.bottom + 133)
            }
        }
    }
    
    // MARK: - Share Sheet View
    private var shareSheetView: some View {
        NavigationView {
            if let myCard = findMyCard() {
                ShareCardSheetView(myCard: myCard)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                VStack {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("내 카드를 찾을 수 없습니다")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding()
                    
                    Text("먼저 내 카드를 생성해주세요")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func findMyCard() -> CardModel? {
        guard let myUUID = myID.last?.id else { return nil }
        return allCards.first { $0.id == myUUID }
    }
}

// MARK: - Private Methods Extension
extension FriendsTabView {
    private func toggleSearchMode() {
        if isSearching {
            exitSearchMode()
        } else {
            enterSearchMode()
        }
    }
    
    private func enterSearchMode() {
        withAnimation(AnimationConstants.cardTransition) {
            isSearching = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isTextFieldFocused = true
        }
    }
    
    private func exitSearchMode() {
        isTextFieldFocused = false
        searchText = ""
        resetCurrentIndex()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(AnimationConstants.cardTransition) {
                isSearching = false
            }
        }
    }
    
    private func resetCurrentIndex() {
        DispatchQueue.main.async {
            currentIndex = 0
        }
    }
    
    private func handleKeyboardShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
        }
    }
    
    private func handleViewAppear() {
        if cards.isEmpty {
            CardDataProvider.insertDummyCards(into: modelContext)
        } else {
            preloadImages()
        }
    }
    
    private func handleAllCardsChange(oldCards: [CardModel], newCards: [CardModel]) {
        if newCards.count < oldCards.count && currentIndex >= newCards.count && newCards.count > 0 {
            DispatchQueue.main.async {
                currentIndex = max(0, newCards.count - 1)
            }
        }
        
        if !newCards.isEmpty {
            preloadImages()
        }
    }
    
    private func handleCardsCountChange(oldCount: Int, newCount: Int) {
        if newCount > oldCount {
            print("새 카드가 추가되었습니다. 총 \(newCount)개")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if !cards.isEmpty {
                    currentIndex = min(currentIndex, cards.count - 1)
                    preloadImages()
                }
            }
        }
    }
    
    private func handleFilteredCardsChange(oldCards: [CardModel], newCards: [CardModel]) {
        DispatchQueue.main.async {
            if newCards.isEmpty {
                currentIndex = 0
            } else {
                if newCards.count < oldCards.count {
                    currentIndex = min(currentIndex, max(0, newCards.count - 1))
                } else {
                    currentIndex = min(currentIndex, newCards.count - 1)
                }
            }
            preloadImages()
        }
    }
    
    private func preloadImages() {
        let currentCards = cards
        DispatchQueue.global(qos: .userInitiated).async {
            var newPreloadedImages: [Int: UIImage] = [:]
            for (index, card) in currentCards.enumerated() {
                if !card.imageData.isEmpty, let uiImage = UIImage(data: card.imageData) {
                    let resizedImage = self.resizeImageForBackground(uiImage)
                    newPreloadedImages[index] = resizedImage
                }
            }
            DispatchQueue.main.async {
                self.preloadedImages = newPreloadedImages
            }
        }
    }
    
    private func resizeImageForBackground(_ image: UIImage) -> UIImage {
        let screenSize = UIScreen.main.bounds.size
        let maxDimension = max(screenSize.width, screenSize.height) * 1.5
        
        let imageSize = image.size
        let scale = maxDimension / max(imageSize.width, imageSize.height)
        
        let targetSize = CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

#Preview {
    FriendsTabView()
        .modelContainer(for: CardModel.self, inMemory: true)
}
