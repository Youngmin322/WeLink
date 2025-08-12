//
//  ShareCardSheetView.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI
import MultipeerConnectivity

struct ShareCardSheetView: View {
    @StateObject var mpc = MultipeerManager()
    @State private var dotCount: Int = 0
    @State private var dotTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var pendingCardSends: Set<String> = []
    @State private var rejectedPeers: Set<String> = []
    
    let myCard: CardModel
    
    private var currentScreenState: ScreenState {
        if let _ = mpc.incomingInvitation {
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
                        mpc.invitePeerAndSendCard(peer, card: myCard)
                    }
                }
            }
            .padding(.top, 16)
        }
    }
    
    // MARK: - 응답 대기 화면
    @ViewBuilder
    private var waitingForResponseView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .padding(.bottom, 8)
            
            if let waitingPeer = mpc.waitingForResponse {
                Text("\(waitingPeer.displayName) 님의 응답을 기다리고 있습니다...")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
            }
            
            Button("취소") {
                print("연결 요청 취소")
                mpc.cancelInvitation()
            }
            .font(.system(size: 16))
            .frame(width: 80, height: 35)
            .background(Color.gray.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(17.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - 들어오는 초대 화면
    @ViewBuilder
    private var incomingInvitationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            if let invitation = mpc.incomingInvitation {
                Text("\(invitation.peer.displayName) 님이 연결을 요청했습니다")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            
            Text("연결하시겠습니까?")
                .font(.body)
                .foregroundColor(.gray)
            
            HStack(spacing: 20) {
                Button("거절") {
                    mpc.respondToInvitation(accept: false)
                }
                .frame(width: 100, height: 40)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(20)
                
                Button("수락") {
                    mpc.respondToInvitation(accept: true)
                }
                .frame(width: 100, height: 40)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ShareCardSheetView(myCard: CardModel(
        id: UUID(),
        name: "테스트",
        age: 25,
        description: "테스트 카드",
        birthDate: "2004-07-25",
        mbti: "ENFJ",
        tag: "개발자",
        dDay: 365,
        imageData: Data()
    ))
}
