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
    @State private var showMockData = true
    @State private var pendingCardSends: Set<String> = [] // 대기 중 피어
    
    let myCard: CardModel

    var body: some View {
        ZStack {
            // 연결 요청이 없을 때만 메인 UI 표시
            if mpc.incomingInvitation == nil {
                VStack(spacing: 0) {
                    // 발견된 사용자가 없을 때만 검색 중 메시지 표시
                    if mpc.discoveredPeers.isEmpty && !showMockData {
                        VStack(spacing: 16) {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.system(size: 50))
                                .foregroundColor(.blue.opacity(0.6))
                                .scaleEffect(1.0 + sin(Double(dotCount) * 0.5) * 0.1)
                                .animation(.easeInOut(duration: 0.5), value: dotCount)
                                .padding()
                            
                            Text("주변 기기를 검색 중" + String(repeating: ".", count: dotCount))
                                .font(.title2)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                    } else {
                        // 발견된 피어들 표시
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                // 실제 발견된 피어들
                                ForEach(mpc.discoveredPeers, id: \.displayName) { peer in
                                    PeerCardView(
                                        peerName: peer.displayName,
                                        profileImage: "person.circle.fill",
                                        isConnected: mpc.connectedPeers.contains { $0.displayName == peer.displayName },
                                        isConnecting: pendingCardSends.contains(peer.displayName) || mpc.waitingForResponse?.displayName == peer.displayName
                                    ) {
                                        // 연결 시작 시 대기 상태로 표시
                                        pendingCardSends.insert(peer.displayName)
                                        mpc.waitingForResponse = peer
                                        mpc.invitePeerAndSendCard(peer, card: myCard)
                                    }
                                }
                                
                                // 테스트용 목업 데이터
                                if showMockData {
                                    PeerCardView(
                                        peerName: "다나",
                                        profileImage: "person.circle.fill",
                                        isConnected: false,
                                        isConnecting: false
                                    ) {
                                        print("다나와 연결 시도")
                                        let mockCard = CardModel(
                                            name: "다나",
                                            age: 25,
                                            description: "안녕하세요!",
                                            birthDate: "2004-07-25",
                                            mbti: "ENFJ",
                                            tag: "디자이너",
                                            dDay: 100,
                                            imageData: Data()
                                        )
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            mpc.receivedCard = mockCard
                                        }
                                    }
                                }
                            }
                            .padding(.top, 16)
                        }
                    }
                    
                    // 테스트용 목업 토글 버튼
                    Button(showMockData ? "목업 데이터 숨기기" : "목업 데이터 보기") {
                        showMockData.toggle()
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding(.top, 16)
                }
            }
            
            if let invitation = mpc.incomingInvitation {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("\(invitation.peer.displayName) 님을 찾았습니다")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
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
            }
            
            if let waitingPeer = mpc.waitingForResponse {
                VStack(spacing: 16) {
                    Text("\(waitingPeer.displayName) 님의 수락을 기다리는 중...")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .bold()
                    
                    Button("취소") {
                        // 대기 상태 해제
                        mpc.waitingForResponse = nil
                        pendingCardSends.remove(waitingPeer.displayName)
                        mpc.stopBrowsing()
                        mpc.stopHosting()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            mpc.startHosting()
                            mpc.startBrowsing()
                        }
                    }
                    .font(.system(size: 16))
                    .frame(width: 80, height: 35)
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.primary)
                    .cornerRadius(17.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BackgroundColor"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundColor"))
        .onAppear {
            mpc.startHosting()
            mpc.startBrowsing()
        }
        .onDisappear {
             mpc.stopHosting()
             mpc.stopBrowsing()
        }
        .onReceive(dotTimer) { _ in
            dotCount = (dotCount + 1) % 4
        }
        .onChange(of: mpc.connectedPeers) { oldValue, newValue in
            // 연결이 완료되면 대기 상태 해제
            for peer in newValue {
                pendingCardSends.remove(peer.displayName)
                if mpc.waitingForResponse?.displayName == peer.displayName {
                    mpc.waitingForResponse = nil
                }
            }
        }
        .onChange(of: mpc.cardSentSuccessfully) { oldValue, newValue in
            if newValue {
                // 카드 전송 성공 시 모든 대기 상태 해제
                pendingCardSends.removeAll()
            }
        }
    }
    
    @State private var rotationAngle: Double = 0
}

struct PeerCardView: View {
    let peerName: String
    let profileImage: String
    let isConnected: Bool
    let isConnecting: Bool
    let onConnect: () -> Void
    
    var buttonText: String {
        if isConnected {
            return "카드 전송됨"
        } else if isConnecting {
            return "요청 중..."
        } else {
            return "연결하기"
        }
    }
    
    var buttonColor: Color {
        if isConnected {
            return Color.green
        } else if isConnecting {
            return Color.orange
        } else {
            return Color(red: 0.75, green: 1, blue: 0)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: profileImage)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text(peerName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color("MainColor"))
                    
                    Text(" 님에게")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                }
                
                if isConnected {
                    Text("전송 완료")
                        .font(.caption)
                        .foregroundColor(.green)
                } else if isConnecting {
                    Text("요청 대기 중...")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            Button(buttonText) {
                if !isConnected && !isConnecting {
                    onConnect()
                }
            }
            .font(.system(size: 14))
            .frame(width: 100, height: 33)
            .background(
                Rectangle()
                    .foregroundColor(.clear)
                    .background(buttonColor)
                    .cornerRadius(19.5)
            )
            .disabled(isConnected || isConnecting)
            .foregroundColor(.black)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
    }
}

struct ConnectionRequestAlert: View {
    let peerName: String
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                
                Text("\(peerName) 님을 찾았습니다")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("연결하시겠습니까?")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    Button("거절") {
                        onDecline()
                    }
                    .frame(width: 100, height: 40)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    
                    Button("수락") {
                        onAccept()
                    }
                    .frame(width: 100, height: 40)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
            }
            .padding(30)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    ShareCardSheetView(myCard: CardModel(
        name: "다나",
        age: 25,
        description: "a",
        birthDate: "2004-07-25",
        mbti: "ENFJ",
        tag: "디자이너",
        dDay: 365,
        imageData: Data()
    ))
}
