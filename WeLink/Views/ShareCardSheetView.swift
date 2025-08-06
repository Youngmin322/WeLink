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
    
    let myCard: CardModel

    var body: some View {
        VStack {
            
            // 발견된 사용자가 없을 때만 검색 중 메시지를 중앙에 표시
            if mpc.discoveredPeers.isEmpty && !showMockData {
                Spacer()
                
                VStack(spacing: 16) {
                    
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 50))
                        .foregroundColor(.blue.opacity(0.6))
                        .scaleEffect(1.0 + sin(Double(dotCount) * 0.5) * 0.1)
                        .animation(.easeInOut(duration: 0.5), value: dotCount)
                    
                    Text("주변 기기를 검색 중" + String(repeating: ".", count: dotCount))
                        .font(.title2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            } else {
                // 발견된 피어들 표시
                ScrollView {
                    LazyVStack {
                        // 실제 발견된 피어들
                        ForEach(mpc.discoveredPeers, id: \.displayName) { peer in
                            PeerCardView(
                                peerName: peer.displayName,
                                profileImage: "person.circle.fill", // 기본 아이콘
                                isConnected: mpc.connectedPeers.contains { $0.displayName == peer.displayName }
                            ) {
                                mpc.invitePeer(peer)
                            }
                        }
                        
                        // 테스트용 목업 데이터
                        if showMockData {
                            PeerCardView(
                                peerName: "다나",
                                profileImage: "person.circle.fill",
                                isConnected: false
                            ) {
                                print("김철수와 연결 시도")
                                // 목업 카드 데이터 생성
                                let mockCard = CardModel(
                                    name: "다나",
                                    age: 25,
                                    description: "안녕하세요! 개발자 김철수입니다.",
                                    birthDate: "1999-03-15",
                                    mbti: "ENFP",
                                    tag: "개발자",
                                    dDay: 100,
                                    imageData: Data()
                                )
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    mpc.receivedCard = mockCard
                                }
                            }
                        }
                    }
                }
                .frame(maxHeight: 400)
                
                // 연결된 사용자가 있을 때만 전송 버튼 표시
                if !mpc.connectedPeers.isEmpty || showMockData {
                    Button("내 카드 전송") {
                        mpc.sendCard(myCard)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            // 테스트용 목업 토글 버튼
            Button(showMockData ? "목업 데이터 숨기기" : "목업 데이터 보기") {
                showMockData.toggle()
            }
            .foregroundColor(.secondary)
            .font(.caption)
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
    }
}

struct PeerCardView: View {
    let peerName: String
    let profileImage: String
    let isConnected: Bool
    let onConnect: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // 프로필 이미지
            Image(systemName: profileImage)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            // 사용자 이름
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text(peerName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color("MainColor"))
                    
                    Text(" 님의 카드")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                }
                
                if isConnected {
                    Text("연결됨")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            // 연결 버튼
            Button(isConnected ? "연결됨" : "연결하기") {
                if !isConnected {
                    onConnect()
                }
            }
            .font(.system(size: 14))
            .frame(width: 90, height: 33)
            .background(
                Rectangle()
                    .foregroundColor(.clear)
                    .background(Color(red: 0.75, green: 1, blue: 0))
                    .cornerRadius(19.5)
            )
            .disabled(isConnected)
            .foregroundColor(.black)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
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
