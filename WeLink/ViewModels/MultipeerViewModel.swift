//
//  MultipeerManager.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import Foundation
import MultipeerConnectivity
import Network

class MultipeerManager: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    // 서비스 타입은 1-15자의 ASCII 소문자, 숫자, 하이픈만 허용
    private let serviceType = "welink-share"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)

    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    // 카드 전송을 위한 대기열
    private var pendingCardSends: [MCPeerID: CardModel] = [:]

    @Published var receivedCard: CardModel?
    @Published var isConnected: Bool = false
    @Published var discoveredPeers: [MCPeerID] = []
    @Published var connectedPeers: [MCPeerID] = []
    @Published var cardSentSuccessfully: Bool = false
    @Published var waitingForResponse: MCPeerID? = nil
    @Published var incomingInvitation: (peer: MCPeerID, handler: (Bool) -> Void)? = nil

    override init() {
        super.init()
        setupSession()
        setupAdvertiser()
        setupBrowser()
    }
    
    private func setupSession() {
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        print("Session 설정 완료: \(myPeerID.displayName)")
    }
    
    private func setupAdvertiser() {
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        print("Advertiser 설정 완료")
    }
    
    private func setupBrowser() {
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser.delegate = self
        print("Browser 설정 완료")
    }

    func startHosting() {
        print("광고 시작: \(myPeerID.displayName)")
        advertiser.startAdvertisingPeer()
    }

    func startBrowsing() {
        print("검색 시작")
        browser.startBrowsingForPeers()
    }

    func stopHosting() {
        print("광고 중지")
        advertiser.stopAdvertisingPeer()
    }

    func stopBrowsing() {
        print("검색 중지")
        browser.stopBrowsingForPeers()
    }

    func disconnect() {
        session.disconnect()
        stopHosting()
        stopBrowsing()
        DispatchQueue.main.async {
            self.discoveredPeers.removeAll()
            self.connectedPeers.removeAll()
            self.isConnected = false
        }
    }
    
    func invitePeer(_ peerID: MCPeerID) {
        print("초대 전송: \(peerID.displayName)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func invitePeerAndSendCard(_ peerID: MCPeerID, card: CardModel) {
        pendingCardSends[peerID] = card
        print("카드 대기열 추가: \(peerID.displayName)")
        
        DispatchQueue.main.async {
            self.waitingForResponse = peerID
        }
        
        invitePeer(peerID)
    }
    
    func respondToInvitation(accept: Bool) {
        guard let invitation = incomingInvitation else {
            print("처리할 초대가 없음")
            return
        }
        
        print("초대 응답: \(accept ? "수락" : "거절")")
        invitation.handler(accept)
        
        DispatchQueue.main.async {
            self.incomingInvitation = nil
        }
    }

    func sendCard(_ card: CardModel) {
        guard !session.connectedPeers.isEmpty else {
            print("연결된 피어가 없음")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(card)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            print("카드 전송 성공")
            
            DispatchQueue.main.async {
                self.cardSentSuccessfully = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.cardSentSuccessfully = false
                }
            }
        } catch {
            print("카드 전송 실패: \(error.localizedDescription)")
        }
    }
    
    private func sendCard(_ card: CardModel, to peer: MCPeerID) {
        guard session.connectedPeers.contains(peer) else {
            print("피어가 연결되지 않음: \(peer.displayName)")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(card)
            try session.send(data, toPeers: [peer], with: .reliable)
            print("카드 전송 성공 to \(peer.displayName)")
            
            DispatchQueue.main.async {
                self.cardSentSuccessfully = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.cardSentSuccessfully = false
                }
            }
        } catch {
            print("카드 전송 실패 \(peer.displayName): \(error.localizedDescription)")
        }
    }
    
    // MARK: - MCSessionDelegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("세션 상태 변경 \(peerID.displayName): \(state.description)")
        
        DispatchQueue.main.async {
            self.isConnected = !session.connectedPeers.isEmpty
            self.connectedPeers = session.connectedPeers
            
            switch state {
            case .connected:
                print("연결됨: \(peerID.displayName)")
                
                if self.waitingForResponse == peerID {
                    self.waitingForResponse = nil
                }
                
                if let cardToSend = self.pendingCardSends[peerID] {
                    print("대기 중인 카드 전송: \(peerID.displayName)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.sendCard(cardToSend, to: peerID)
                        self.pendingCardSends.removeValue(forKey: peerID)
                    }
                }
                
            case .connecting:
                print("연결 중: \(peerID.displayName)")
                
            case .notConnected:
                print("연결 해제됨: \(peerID.displayName)")
                
                if self.waitingForResponse == peerID {
                    self.waitingForResponse = nil
                }
                self.pendingCardSends.removeValue(forKey: peerID)
                
            @unknown default:
                print("알 수 없는 상태: \(peerID.displayName)")
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("데이터 수신: \(peerID.displayName)")
        
        DispatchQueue.main.async {
            if let card = try? JSONDecoder().decode(CardModel.self, from: data) {
                self.receivedCard = card
                print("카드 디코딩 성공: \(card.name)")
            } else {
                print("카드 디코딩 실패")
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}

    // MARK: - MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("초대 수신: \(peerID.displayName)")
        
        DispatchQueue.main.async {
            self.incomingInvitation = (peer: peerID, handler: { accept in
                print("초대에 응답: \(accept ? "수락" : "거절")")
                invitationHandler(accept, accept ? self.session : nil)
            })
        }
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("광고 시작 실패: \(error.localizedDescription)")
    }

    // MARK: - MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("피어 발견: \(peerID.displayName)")
        
        DispatchQueue.main.async {
            if !self.discoveredPeers.contains(where: { $0.displayName == peerID.displayName }) {
                self.discoveredPeers.append(peerID)
                print("피어 목록에 추가: \(peerID.displayName)")
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("피어 손실: \(peerID.displayName)")
        
        DispatchQueue.main.async {
            self.discoveredPeers.removeAll { $0.displayName == peerID.displayName }
            self.pendingCardSends.removeValue(forKey: peerID)
            print("피어 목록에서 제거: \(peerID.displayName)")
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("검색 시작 실패: \(error.localizedDescription)")
        
        // 권한 관련 에러인 경우 별도 처리
        if error.localizedDescription.contains("denied") || error.localizedDescription.contains("permission") {
            print("네트워크 권한 거부됨")
        }
    }
}

extension MCSessionState {
    var description: String {
        switch self {
        case .notConnected: return "notConnected"
        case .connecting: return "connecting"
        case .connected: return "connected"
        @unknown default: return "unknown"
        }
    }
}
