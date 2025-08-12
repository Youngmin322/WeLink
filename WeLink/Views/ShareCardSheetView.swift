//
//  ShareCardSheetView.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI
import MultipeerConnectivity
import SwiftData

struct ShareCardSheetView: View {
    @StateObject var mpc = MultipeerManager()
    @State private var dotCount: Int = 0
    @State private var dotTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var pendingCardSends: Set<String> = []
    @State private var rejectedPeers: Set<String> = []
    @State private var showSuccessMessage = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var myID: [MyUUID]
    @Query private var allCards: [CardModel]
    
    let myCard: CardModel
    
    // 내 카드 찾기
    private var actualMyCard: CardModel? {
        guard let myUUID = myID.last?.id else { return nil }
        return allCards.first { $0.id == myUUID }
    }
    
    private var currentScreenState: ScreenState {
        if showSuccessMessage {
            return .exchangeSuccess
        } else if let _ = mpc.incomingInvitation {
            return .incomingInvitation
        } else if let _ = mpc.waitingForResponse {
            return .waitingForResponse
        } else if mpc.discoveredPeers.isEmpty {
            return .searching
        } else {
            return .peerList
        }
    }
    
    enum ScreenState {
        case searching
        case peerList
        case waitingForResponse
        case incomingInvitation
        case exchangeSuccess
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch currentScreenState {
                case .searching:
                    searchingView
                case .peerList:
                    peerListView
                case .waitingForResponse:
                    waitingForResponseView
                case .incomingInvitation:
                    incomingInvitationView
                case .exchangeSuccess:
                    exchangeSuccessView
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .presentationBackground(.ultraThinMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
        .presentationCornerRadius(20)
        .background {
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(.black.opacity(0.4))
                .blur(radius: 20)
                .ignoresSafeArea()
        }
        .onAppear {
            print("ShareCardSheetView appeared")
            mpc.setModelContext(modelContext)
            mpc.startHosting()
            mpc.startBrowsing()
        }
        .onDisappear {
            print("ShareCardSheetView disappeared")
            mpc.disconnect()
        }
        .onReceive(dotTimer) { _ in
            dotCount = (dotCount + 1) % 4
        }
        .onChange(of: mpc.connectedPeers) { oldValue, newValue in
            for peer in newValue {
                pendingCardSends.remove(peer.displayName)
                if mpc.waitingForResponse?.displayName == peer.displayName {
                    mpc.waitingForResponse = nil
                }
            }
        }
        .onChange(of: mpc.cardSentSuccessfully) { oldValue, newValue in
            if newValue {
                pendingCardSends.removeAll()
            }
        }
        .onChange(of: mpc.connectionRejected) { oldValue, newValue in
            if let rejectedPeerName = newValue {
                rejectedPeers.insert(rejectedPeerName)
                pendingCardSends.remove(rejectedPeerName)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    rejectedPeers.remove(rejectedPeerName)
                }
            }
        }
        .onChange(of: mpc.waitingForResponse) { oldValue, newValue in
            if let oldPeer = oldValue, newValue == nil {
                pendingCardSends.remove(oldPeer.displayName)
            }
        }
        .onChange(of: mpc.cardExchangeCompleted) { oldValue, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSuccessMessage = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSuccessMessage = false
                    }
                }
            }
        }
    }
    
    // MARK: - 검색 중 화면
    @ViewBuilder
    private var searchingView: some View {
        VStack(spacing: 16) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 60))
                .foregroundColor(Color("MainColor"))
                .scaleEffect(1.0 + sin(Double(dotCount) * 0.5) * 0.1)
                .animation(.easeInOut(duration: 0.5), value: dotCount)
                .padding()
            
            Text("주변 기기를 검색 중" + String(repeating: ".", count: dotCount))
                .font(.custom("Pretendard-SemiBold", size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("같은 화면에 있는 친구를 찾고 있어요")
                .font(.custom("Pretendard-Regular", size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button("검색 재시작") {
                print("수동으로 검색 재시작")
                mpc.stopBrowsing()
                mpc.stopHosting()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    mpc.startHosting()
                    mpc.startBrowsing()
                }
            }
            .padding(.top, 16)
            .font(.custom("Pretendard-Medium", size: 17))
            .foregroundColor(Color("MainColor"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
    
    // MARK: - 피어 리스트 화면
    @ViewBuilder
    private var peerListView: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("주변 친구들")
                    .font(.custom("Pretendard-Bold", size: 22))
                    .foregroundColor(.white)
                
                Text("카드를 교환할 친구를 선택하세요")
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.top, 8)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(mpc.discoveredPeers, id: \.displayName) { peer in
                        PeerCardView(
                            peerName: peer.displayName,
                            profileImage: "person.circle.fill",
                            isConnected: mpc.connectedPeers.contains { $0.displayName == peer.displayName },
                            isConnecting: pendingCardSends.contains(peer.displayName) || mpc.waitingForResponse?.displayName == peer.displayName,
                            isRejected: rejectedPeers.contains(peer.displayName)
                        ) {
                            print("연결 시도: \(peer.displayName)")
                            pendingCardSends.insert(peer.displayName)
                            
                            // 항상 actualMyCard를 전송 (내 카드가 없으면 기본 카드)
                            let cardToSend = actualMyCard ?? CardModel.defaultMockCard
                            mpc.invitePeerAndSendCard(peer, card: cardToSend)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 응답 대기 화면
    @ViewBuilder
    private var waitingForResponseView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
                .padding(.bottom, 8)
            
            if let waitingPeer = mpc.waitingForResponse {
                VStack(spacing: 12) {
                    Text("\(waitingPeer.displayName) 님에게")
                        .font(.custom("Pretendard-Bold", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("카드 교환을 요청했어요")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    Text("응답을 기다리고 있습니다...")
                        .font(.custom("Pretendard-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
            }
            
            Button("요청 취소") {
                print("연결 요청 취소")
                mpc.cancelInvitation()
            }
            .font(.custom("Pretendard-Medium", size: 16))
            .frame(width: 100, height: 40)
            .background(Color.red.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - 들어오는 초대 화면
    @ViewBuilder
    private var incomingInvitationView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Image(systemName: "person.2.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(Color("MainColor"))
                    .scaleEffect(1.0 + sin(Date().timeIntervalSince1970 * 2) * 0.05)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: UUID())
                
                if let invitation = mpc.incomingInvitation {
                    VStack(spacing: 8) {
                        Text("\(invitation.peer.displayName) 님이")
                            .font(.custom("Pretendard-Bold", size: 20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("카드 교환을 요청했습니다")
                            .font(.custom("Pretendard-Medium", size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                
                Text("서로의 카드를 교환하시겠습니까?")
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 20) {
                Button("거절") {
                    mpc.respondToInvitation(accept: false)
                }
                .font(.custom("Pretendard-SemiBold", size: 16))
                .frame(width: 100, height: 44)
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(22)
                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Button("수락") {
                    let cardToSend = actualMyCard ?? CardModel.defaultMockCard
                    mpc.respondToInvitation(accept: true, myCard: cardToSend)
                }
                .font(.custom("Pretendard-SemiBold", size: 16))
                .frame(width: 100, height: 44)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("MainColor"), Color("MainColor").opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(22)
                .shadow(color: Color("MainColor").opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - 교환 성공 화면
    @ViewBuilder
    private var exchangeSuccessView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .scaleEffect(showSuccessMessage ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSuccessMessage)
                
                VStack(spacing: 12) {
                    Text("카드 교환 완료!")
                        .font(.custom("Pretendard-Bold", size: 24))
                        .foregroundColor(.white)
                        .opacity(showSuccessMessage ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5), value: showSuccessMessage)
                    
                    if let receivedCard = mpc.receivedCard {
                        VStack(spacing: 8) {
                            Text("\(receivedCard.name) 님의 카드를 받았습니다")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .opacity(showSuccessMessage ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.5).delay(0.2), value: showSuccessMessage)
                            
                            Text("친구 목록에서 확인해보세요!")
                                .font(.custom("Pretendard-Regular", size: 14))
                                .foregroundColor(.white.opacity(0.6))
                                .opacity(showSuccessMessage ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.5).delay(0.4), value: showSuccessMessage)
                        }
                    }
                }
            }
            
            // 성공 후 새로운 교환을 위한 버튼 (선택사항)
            if showSuccessMessage {
                Button("새로운 교환") {
                    showSuccessMessage = false
                    mpc.disconnect()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        mpc.startHosting()
                        mpc.startBrowsing()
                    }
                }
                .font(.custom("Pretendard-Medium", size: 16))
                .frame(width: 140, height: 40)
                .background(Color("MainColor").opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(20)
                .opacity(showSuccessMessage ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.5).delay(1.0), value: showSuccessMessage)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - PeerCardView 컴포넌트
struct PeerCardView: View {
    let peerName: String
    let profileImage: String
    let isConnected: Bool
    let isConnecting: Bool
    let isRejected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            if !isConnected && !isConnecting && !isRejected {
                onTap()
            }
        }) {
            HStack(spacing: 16) {
                // 프로필 이미지
                Image(systemName: profileImage)
                    .font(.system(size: 32))
                    .foregroundColor(statusColor)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(statusColor.opacity(0.1)))
                
                // 이름과 상태
                VStack(alignment: .leading, spacing: 4) {
                    Text(peerName)
                        .font(.custom("Pretendard-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(statusText)
                        .font(.custom("Pretendard-Regular", size: 12))
                        .foregroundColor(statusColor.opacity(0.8))
                }
                
                Spacer()
                
                // 상태 아이콘
                statusIcon
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        statusColor.opacity(0.3),
                        lineWidth: isConnected || isConnecting ? 1.5 : 1
                    )
            )
            .scaleEffect(isConnecting ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isConnecting)
        }
        .disabled(isConnected || isConnecting)
    }
    
    private var statusColor: Color {
        if isRejected {
            return .red
        } else if isConnected {
            return .green
        } else if isConnecting {
            return .orange
        } else {
            return Color("MainColor")
        }
    }
    
    private var statusText: String {
        if isRejected {
            return "연결 거절됨"
        } else if isConnected {
            return "연결됨"
        } else if isConnecting {
            return "연결 중..."
        } else {
            return "터치하여 카드 교환"
        }
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        if isRejected {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.red)
        } else if isConnected {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.green)
        } else if isConnecting {
            ProgressView()
                .scaleEffect(0.8)
                .tint(.orange)
        } else {
            Image(systemName: "arrow.right.circle")
                .font(.system(size: 20))
                .foregroundColor(Color("MainColor"))
        }
    }
}
