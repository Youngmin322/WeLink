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
    
    let myCard: CardModel

    var body: some View {
        ZStack {
            if mpc.incomingInvitation == nil {
                VStack(spacing: 0) {
                    if mpc.discoveredPeers.isEmpty {
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
                            .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(mpc.discoveredPeers, id: \.displayName) { peer in
                                    PeerCardView(
                                        peerName: peer.displayName,
                                        profileImage: "person.circle.fill",
                                        isConnected: mpc.connectedPeers.contains { $0.displayName == peer.displayName },
                                        isConnecting: pendingCardSends.contains(peer.displayName) || mpc.waitingForResponse?.displayName == peer.displayName
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
                }
            }
            
            if let invitation = mpc.incomingInvitation {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("\(invitation.peer.displayName) 님이 연결을 요청했습니다")
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
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding(.bottom, 8)
                    
                    Text("\(waitingPeer.displayName) 님의 응답을 기다리고 있습니다...")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .bold()
                    
                    Button("취소") {
                        print("❌ 연결 요청 취소")
                        mpc.waitingForResponse = nil
                        pendingCardSends.remove(waitingPeer.displayName)
                        mpc.disconnect()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    }
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

#Preview {
    ShareCardSheetView(myCard: CardModel(
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
