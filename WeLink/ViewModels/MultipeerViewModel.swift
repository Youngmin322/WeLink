//
//  MultipeerManager.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import Foundation
import MultipeerConnectivity

class MultipeerManager: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    private let serviceType = "card-share" // 앱을 식별하는 고유한 서비스 타입
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name) // 현재 기기를 식별하는 ID

    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    // 카드 전송을 위한 대기열
    private var pendingCardSends: [MCPeerID: CardModel] = [:]

    @Published var receivedCard: CardModel?
    @Published var isConnected: Bool = false
    @Published var discoveredPeers: [MCPeerID] = [] // 발견된 피어들
    @Published var connectedPeers: [MCPeerID] = [] // 연결된 피어들
    @Published var cardSentSuccessfully: Bool = false // 카드 전송 성공 플래그
    @Published var waitingForResponse: MCPeerID? = nil // 응답을 기다리고 있는 피어
    @Published var incomingInvitation: (peer: MCPeerID, handler: (Bool) -> Void)? = nil // 받은 초대

    override init() {
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self

        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self

        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser.delegate = self
    }

    func startHosting() {
        advertiser.startAdvertisingPeer()
    }

    func startBrowsing() {
        browser.startBrowsingForPeers()
    }

    func stopHosting() {
        advertiser.stopAdvertisingPeer()
    }

    func stopBrowsing() {
        browser.stopBrowsingForPeers()
    }

    func disconnect() {
        session.disconnect()
        stopHosting()
        stopBrowsing()
    }
    
    // 특정 피어에게 연결 요청
    func invitePeer(_ peerID: MCPeerID) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    // 피어에게 연결하고 카드를 전송하는 통합 함수
    func invitePeerAndSendCard(_ peerID: MCPeerID, card: CardModel) {
        // 카드를 대기열에 추가
        pendingCardSends[peerID] = card
        // 응답 대기 상태로 설정
        DispatchQueue.main.async {
            self.waitingForResponse = peerID
        }
        // 피어에게 연결 요청
        invitePeer(peerID)
    }
    
    // 초대 응답 처리
    func respondToInvitation(accept: Bool) {
        guard let invitation = incomingInvitation else { return }
        invitation.handler(accept)
        DispatchQueue.main.async {
            self.incomingInvitation = nil
        }
    }

    func sendCard(_ card: CardModel) {
        guard !session.connectedPeers.isEmpty else { return }
        do {
            let data = try JSONEncoder().encode(card)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            DispatchQueue.main.async {
                self.cardSentSuccessfully = true
                // 플래그를 잠시 후 리셋
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.cardSentSuccessfully = false
                }
            }
        } catch {
            print("Send failed: \(error.localizedDescription)")
        }
    }
    
    // 특정 피어에게만 카드 전송
    private func sendCard(_ card: CardModel, to peer: MCPeerID) {
        guard session.connectedPeers.contains(peer) else { return }
        do {
            let data = try JSONEncoder().encode(card)
            try session.send(data, toPeers: [peer], with: .reliable)
            DispatchQueue.main.async {
                self.cardSentSuccessfully = true
                // 플래그를 잠시 후 리셋
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.cardSentSuccessfully = false
                }
            }
            print("Card sent to \(peer.displayName)")
        } catch {
            print("Send failed to \(peer.displayName): \(error.localizedDescription)")
        }
    }
    
    // MARK: - MCSessionDelegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            self.isConnected = !session.connectedPeers.isEmpty
            self.connectedPeers = session.connectedPeers
            
            switch state {
            case .connected:
                print("Connected to \(peerID.displayName)")
                
                // 대기 상태 해제
                if self.waitingForResponse == peerID {
                    self.waitingForResponse = nil
                }
                
                // 연결이 완료되면 대기 중인 카드가 있다면 전송
                if let cardToSend = self.pendingCardSends[peerID] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.sendCard(cardToSend, to: peerID)
                        self.pendingCardSends.removeValue(forKey: peerID)
                    }
                }
                
            case .connecting:
                print("Connecting to \(peerID.displayName)")
            case .notConnected:
                print("Disconnected from \(peerID.displayName)")
                // 연결이 끊어지면 대기 상태 해제 및 대기 중인 카드 제거
                if self.waitingForResponse == peerID {
                    self.waitingForResponse = nil
                }
                self.pendingCardSends.removeValue(forKey: peerID)
            @unknown default:
                print("Unknown state for \(peerID.displayName)")
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let card = try? JSONDecoder().decode(CardModel.self, from: data) {
                self.receivedCard = card
                print("Received card from \(peerID.displayName): \(card.name)")
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}

    // MARK: - MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // UI에서 사용자에게 확인을 받도록 초대 정보 저장
        DispatchQueue.main.async {
            self.incomingInvitation = (peer: peerID, handler: { accept in
                invitationHandler(accept, accept ? self.session : nil)
            })
        }
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Failed to advertise: \(error.localizedDescription)")
    }

    // MARK: - MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if !self.discoveredPeers.contains(peerID) {
                self.discoveredPeers.append(peerID)
                print("Found peer: \(peerID.displayName)")
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.discoveredPeers.removeAll { $0 == peerID }
            // 발견되지 않은 피어의 대기 중인 카드도 제거
            self.pendingCardSends.removeValue(forKey: peerID)
            print("Lost peer: \(peerID.displayName)")
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to browse: \(error.localizedDescription)")
    }
}
