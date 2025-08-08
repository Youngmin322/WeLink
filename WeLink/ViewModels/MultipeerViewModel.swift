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

    @Published var receivedCard: CardModel?
    @Published var isConnected: Bool = false
    @Published var discoveredPeers: [MCPeerID] = [] // 발견된 피어들
    @Published var connectedPeers: [MCPeerID] = [] // 연결된 피어들

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

    func sendCard(_ card: CardModel) {
        guard !session.connectedPeers.isEmpty else { return }
        do {
            let data = try JSONEncoder().encode(card)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Send failed: \(error.localizedDescription)")
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
            case .connecting:
                print("Connecting to \(peerID.displayName)")
            case .notConnected:
                print("Disconnected from \(peerID.displayName)")
            @unknown default:
                print("Unknown state for \(peerID.displayName)")
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let card = try? JSONDecoder().decode(CardModel.self, from: data) {
                self.receivedCard = card
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}

    // MARK: - MCNearbyServiceAdvertiserDelegate
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // 자동으로 초대를 수락
        invitationHandler(true, session)
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
            print("Lost peer: \(peerID.displayName)")
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to browse: \(error.localizedDescription)")
    }
}
