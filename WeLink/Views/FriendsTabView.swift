import SwiftUI
import SwiftData

struct FriendsTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allCards: [CardModel]
    @State private var currentIndex = 0
    @State private var showingAddSheet = false
    @State private var showingShareSheet = false
    @State private var preloadedImages: [Int: UIImage] = [:]
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isTextFieldFocused: Bool
    
    // 검색 필터링된 카드들 - 안전한 인덱스 처리
    private var cards: [CardModel] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return allCards
        } else {
            return allCards.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    // 현재 인덱스가 유효한지 확인
    private var safeCurrentIndex: Int {
        guard !cards.isEmpty else { return 0 }
        return min(currentIndex, cards.count - 1)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    // 배경 이미지 (항상 전체 화면을 채움)
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
                    
                    // 콘텐츠 레이어
                    VStack(spacing: 0) {
                        // 상단 헤더 (Safe Area 고려)
                        headerView
                            .padding(.top, geometry.safeAreaInsets.top - 30)
                            .padding(.horizontal, 24)
                        
                        // 헤더와 카드 사이 간격
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 8)
                        
                        // 카드 섹션
                        if cards.isEmpty {
                            emptyStateView
                                .frame(maxHeight: .infinity)
                        } else {
                            CardScrollView(cards: cards, currentIndex: $currentIndex)
                                .padding(.top, 8)
                        }
                        
                        Spacer(minLength: 60) // 하단 여백만 확보
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // + 버튼 (절대 위치 고정) - cards가 비어있을 때는 비활성화
                    floatingButton(geometry: geometry)
                }
            }
            .navigationBarHidden(true)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
        .onAppear {
            if allCards.isEmpty {
                CardDataProvider.insertDummyCards(into: modelContext)
            } else {
                preloadImages()
            }
        }
        .onChange(of: allCards) { _, newCards in
            if !newCards.isEmpty {
                preloadImages()
            }
        }
        .onChange(of: cards) { oldCards, newCards in
            // 검색 결과가 바뀔 때 currentIndex 안전하게 조정
            DispatchQueue.main.async {
                if newCards.isEmpty {
                    currentIndex = 0
                } else {
                    currentIndex = min(currentIndex, newCards.count - 1)
                }
                // 검색 결과에 따라 이미지 다시 로드
                preloadImages()
            }
        }
        .onChange(of: searchText) { _, _ in
            // 검색 텍스트 변경 시 인덱스 리셋
            DispatchQueue.main.async {
                currentIndex = 0
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            // 안전한 카드 접근
            if !cards.isEmpty && safeCurrentIndex < cards.count {
                NavigationView {
                    ShareCardSheetView(myCard: cards[safeCurrentIndex])
                        .navigationBarTitleDisplayMode(.inline)
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    // MARK: - Floating Button
    private func floatingButton(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // 카드가 있을 때만 공유 시트 표시
                    if !cards.isEmpty {
                        showingShareSheet = true
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(cards.isEmpty ? Color.gray.opacity(0.5) : Color("MainColor"))
                            .frame(width: 40, height: 40)
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .medium))
                    }
                }
                .disabled(cards.isEmpty)
                .padding(.trailing, 24)
                .padding(.bottom, keyboardHeight > 0 ? 140 : geometry.safeAreaInsets.bottom + 140)
            }
        }
    }
    
    // MARK: - Image Preloading
    private func preloadImages() {
        let currentCards = cards // 현재 필터된 카드들을 캡처
        DispatchQueue.global(qos: .userInitiated).async {
            var newPreloadedImages: [Int: UIImage] = [:]
            // 현재 필터된 cards 배열을 기준으로 이미지 로드
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
        let targetSize = CGSize(
            width: screenSize.width * UIScreen.main.scale,
            height: screenSize.height * UIScreen.main.scale
        )
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack(spacing: 12) {
            if isSearching {
                // 검색 바
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 18, weight: .medium))
                    
                    TextField("친구 이름으로 검색", text: $searchText)
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                        .tint(.white)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                        .focused($isTextFieldFocused)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .frame(maxWidth: .infinity)
            } else {
                // 타이틀
                Text("친구")
                    .foregroundColor(.white)
                    .font(.system(size: 35, weight: .bold))
                
                Spacer()
            }
            
            // 검색/X 버튼 (개선된 버전)
            Button(action: {
                if isSearching {
                    // 검색 취소
                    isTextFieldFocused = false
                    searchText = ""
                    currentIndex = 0
                    
                    // 키보드 먼저 숨기고 UI 애니메이션
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSearching = false
                        }
                    }
                } else {
                    // 검색 시작
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSearching = true
                    }
                    
                    // TextField 포커스를 약간 지연시켜서 애니메이션과 함께
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isTextFieldFocused = true
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isSearching ? 180 : 0))
                        .scaleEffect(isSearching ? 0.9 : 1.0)
                }
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .contentShape(Circle())
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: searchText.isEmpty ? "person.3" : "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            
            Text(searchText.isEmpty ? "아직 친구가 없어요" : "검색 결과가 없어요")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            
            Text(searchText.isEmpty ? "+ 버튼을 눌러 첫 번째 친구를 추가해보세요!" : "다른 이름으로 검색해보세요")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
        }
    }
}

// MARK: - Background View (안전한 인덱스 처리 추가)
struct BackgroundImageView: View {
    let cards: [CardModel]
    let currentIndex: Int
    let preloadedImages: [Int: UIImage]
    
    var body: some View {
        // 기본 배경색 (항상 표시) - 고정 크기
        Color.black
            .overlay(
                // 배경 이미지 (로드되면 표시)
                Group {
                    if !cards.isEmpty &&
                       currentIndex >= 0 &&
                       currentIndex < cards.count,
                       let currentImage = preloadedImages[currentIndex] {
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 15)
                            .overlay(
                                LinearGradient(
                                    colors: [
                                        Color.black.opacity(0.4),
                                        Color.black.opacity(0.2),
                                        Color.black.opacity(0.6)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .animation(.easeInOut(duration: 0.4), value: currentIndex)
                    }
                }
            )
            .clipped()
    }
}

#Preview {
    FriendsTabView()
        .modelContainer(for: CardModel.self, inMemory: true)
}
