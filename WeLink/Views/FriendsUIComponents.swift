//
//  FriendsUIComponents.swift
//  WeLink
//
//  Created by 조영민 on 8/13/25.
//

import SwiftUI

// MARK: - Header View
struct FriendsHeaderView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @FocusState.Binding var isTextFieldFocused: Bool
    let onToggleSearch: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if isSearching {
                searchBarView
            } else {
                titleView
            }
            
            searchToggleButton
        }
    }
    
    private var titleView: some View {
        HStack {
            Text("친구")
                .font(.custom("Pretendard-Bold", size: 35))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    private var searchBarView: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.8))
                .font(.system(size: 18, weight: .medium))
            
            TextField("", text: $searchText)
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
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 16))
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
    }
    
    private var searchToggleButton: some View {
        Button(action: onToggleSearch) {
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
struct FriendsEmptyStateView: View {
    let searchText: String
    
    var body: some View {
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

// MARK: - Background Image View
struct BackgroundImageView: View {
    let cards: [CardModel]
    let currentIndex: Int
    let preloadedImages: [Int: UIImage]
    
    var body: some View {
        Color.black
            .overlay(
                Group {
                    if !cards.isEmpty &&
                        currentIndex >= 0 &&
                        currentIndex < cards.count,
                       let currentImage = preloadedImages[currentIndex] {
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .scaleEffect(1.1)
                            .blur(radius: 4)
                            .overlay(
                                LinearGradient(
                                    colors: [
                                        Color.black.opacity(0.5),
                                        Color.black.opacity(0.3),
                                        Color.black.opacity(0.7)
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

extension Collection {
    func safeIndex(_ index: Int) -> Int {
        guard !isEmpty else { return 0 }
        return Swift.max(0, Swift.min(index, count - 1))
    }
}
