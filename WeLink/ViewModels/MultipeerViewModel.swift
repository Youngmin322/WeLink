//
//  MultipeerManager.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import Foundation
import MultipeerConnectivity
import Network
import SwiftData

class MultipeerManager: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    private let serviceType = "welink-share"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    private var pendingCardSends: [MCPeerID: CardModel] = [:]
    private var modelContext: ModelContext?
    
    private var currentInvitationHandler: ((Bool, MCSession?) -> Void)?
    private var currentInvitationPeer: MCPeerID?
    private var invitationTimeoutTimer: Timer?
    
    // 카드 교환 상태 추적
    private var cardsSentTo: Set<String> = []
    private var cardsReceivedFrom: Set<String> = []
    
    @Published var receivedCard: CardModel?
    @Published var isConnected: Bool = false
    @Published var discoveredPeers: [MCPeerID] = []
    @Published var connectedPeers: [MCPeerID] = []
    @Published var cardSentSuccessfully: Bool = false
    @Published var waitingForResponse: MCPeerID? = nil
    @Published var incomingInvitation: (peer: MCPeerID, handler: (Bool) -> Void)? = nil
    @Published var connectionRejected: String? = nil
    @Published var cardExchangeCompleted: Bool = false
    
    // ModelContext 설정 메서드 추가
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
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
        
        // 상태 초기화
        cardsSentTo.removeAll()
        cardsReceivedFrom.removeAll()
        
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
    
    func cancelInvitation() {
        guard let waitingPeer = waitingForResponse else { return }
        
        print("초대 취소: \(waitingPeer.displayName)")
        
        waitingForResponse = nil
        pendingCardSends.removeValue(forKey: waitingPeer)
        
        stopHosting()
        stopBrowsing()
        session.disconnect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setupSession()
            self.setupAdvertiser()
            self.setupBrowser()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.startHosting()
                self.startBrowsing()
            }
        }
    }
    
    func forceCloseInvitation() {
        print("강제로 초대 화면 닫기")
        
        invitationTimeoutTimer?.invalidate()
        invitationTimeoutTimer = nil
        
        DispatchQueue.main.async {
            self.incomingInvitation = nil
        }
        
        if let handler = currentInvitationHandler {
            print("초대 핸들러에 거절 응답 전송")
            handler(false, nil)
        }
        
        currentInvitationHandler = nil
        currentInvitationPeer = nil
    }
    
    func respondToInvitation(accept: Bool, myCard: CardModel? = nil) {
        guard let invitation = incomingInvitation else {
            print("처리할 초대가 없음")
            return
        }
        
        print("초대 응답: \(accept ? "수락" : "거절")")
        invitation.handler(accept)
        
        // 수락했을 때 내 카드를 즉시 전송하도록 예약
        if accept, let card = myCard {
            pendingCardSends[invitation.peer] = card
        }
        
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
            let cardData = CardTransferData(card: card, senderID: myPeerID.displayName)
            let data = try JSONEncoder().encode(cardData)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            print("카드 전송 성공")
            
            // 전송한 피어들을 추적
            for peer in session.connectedPeers {
                cardsSentTo.insert(peer.displayName)
            }
            
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
            let cardData = CardTransferData(card: card, senderID: myPeerID.displayName)
            let data = try JSONEncoder().encode(cardData)
            try session.send(data, toPeers: [peer], with: .reliable)
            print("카드 전송 성공 to \(peer.displayName)")
            
            // 전송한 피어를 추적
            cardsSentTo.insert(peer.displayName)
            
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
    
    // 받은 카드를 SwiftData에 저장하는 메서드
    private func saveReceivedCard(_ card: CardModel, from senderID: String) {
        guard let context = modelContext else {
            print("ModelContext가 설정되지 않음")
            return
        }
        
        // 새로운 UUID로 카드 생성 (중복 방지)
        let newCard = CardModel(
            id: UUID(),
            name: card.name,
            age: card.age,
            description: card.cardDescription,
            birthDate: card.birthDate,
            mbti: card.mbti,
            tag: card.tag,
            dDay: card.dDay,
            imageData: card.imageData
        )
        
        context.insert(newCard)
        
        do {
            try context.save()
            print("카드 저장 완료: \(card.name)")
            
            // 받은 피어 추적
            cardsReceivedFrom.insert(senderID)
            
            // 양방향 교환이 완료되었는지 확인
            checkExchangeCompletion(with: senderID)
            
        } catch {
            print("카드 저장 실패: \(error)")
        }
    }
    
    // 양방향 교환 완료 확인
    private func checkExchangeCompletion(with peerID: String) {
        if cardsSentTo.contains(peerID) && cardsReceivedFrom.contains(peerID) {
            print("양방향 카드 교환 완료: \(peerID)")
            
            DispatchQueue.main.async {
                self.cardExchangeCompleted = true
                
                // 성공 메시지 표시 후 리셋
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.cardExchangeCompleted = false
                }
            }
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
                
                // 대기 중인 카드 전송
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
                
                // 연결 해제 시 상태 정리
                self.cardsSentTo.remove(peerID.displayName)
                self.cardsReceivedFrom.remove(peerID.displayName)
                
                if let currentPeer = self.currentInvitationPeer,
                   currentPeer.displayName == peerID.displayName,
                   self.incomingInvitation != nil {
                    print("상대방이 초대를 취소함, 초대 화면 닫기: \(peerID.displayName)")
                    self.forceCloseInvitation()
                }
                
                if let waitingPeer = self.waitingForResponse,
                   waitingPeer.displayName == peerID.displayName {
                    
                    if self.pendingCardSends[peerID] != nil {
                        self.connectionRejected = peerID.displayName
                        print("연결 거절됨: \(peerID.displayName)")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.connectionRejected = nil
                        }
                    }
                    
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
            do {
                let cardData = try JSONDecoder().decode(CardTransferData.self, from: data)
                self.receivedCard = cardData.card
                print("카드 디코딩 성공: \(cardData.card.name) from \(cardData.senderID)")
                
                // 받은 카드를 SwiftData에 저장
                self.saveReceivedCard(cardData.card, from: cardData.senderID)
                
            } catch {
                print("카드 디코딩 실패: \(error)")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("초대 수신: \(peerID.displayName)")
        
        invitationTimeoutTimer?.invalidate()
        
        currentInvitationHandler = invitationHandler
        currentInvitationPeer = peerID
        
        invitationTimeoutTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { [weak self] _ in
            print("초대 타임아웃: \(peerID.displayName)")
            self?.forceCloseInvitation()
        }
        
        DispatchQueue.main.async {
            self.incomingInvitation = (peer: peerID, handler: { accept in
                print("초대에 응답: \(accept ? "수락" : "거절")")
                
                self.invitationTimeoutTimer?.invalidate()
                self.invitationTimeoutTimer = nil
                
                invitationHandler(accept, accept ? self.session : nil)
                
                self.currentInvitationHandler = nil
                self.currentInvitationPeer = nil
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
            
            // 연결 해제 시 상태 정리
            self.cardsSentTo.remove(peerID.displayName)
            self.cardsReceivedFrom.remove(peerID.displayName)
            
            if let currentPeer = self.currentInvitationPeer,
               currentPeer.displayName == peerID.displayName,
               self.incomingInvitation != nil {
                print("피어 손실로 인한 초대 화면 닫기: \(peerID.displayName)")
                self.forceCloseInvitation()
            }
            
            if self.waitingForResponse?.displayName == peerID.displayName {
                print("피어 손실로 인한 대기 상태 취소: \(peerID.displayName)")
                self.waitingForResponse = nil
            }
            
            print("피어 목록에서 제거: \(peerID.displayName)")
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("검색 시작 실패: \(error.localizedDescription)")
        
        if error.localizedDescription.contains("denied") || error.localizedDescription.contains("permission") {
            print("네트워크 권한 거부됨")
        }
    }
}

// MARK: - 카드 전송 데이터 구조체
struct CardTransferData: Codable {
    let card: CardModel
    let senderID: String
    
    init(card: CardModel, senderID: String) {
        self.card = card
        self.senderID = senderID
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
