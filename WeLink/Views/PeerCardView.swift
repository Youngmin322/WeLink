////
////  PeerCardView.swift
////  WeLink
////
////  Created by 조영민 on 8/11/25.
////
//
//import SwiftUI
//
//struct PeerCardView: View {
//    let peerName: String
//    let profileImage: String
//    let isConnected: Bool
//    let isConnecting: Bool
//    let isRejected: Bool
//    let onConnect: () -> Void
//    
//    var buttonText: String {
//        if isConnected {
//            return "카드 전송됨"
//        } else if isConnecting {
//            return "요청 중..."
//        } else if isRejected {
//            return "거절됨"
//        } else {
//            return "연결하기"
//        }
//    }
//    
//    var buttonColor: Color {
//        if isConnected {
//            return Color.green
//        } else if isConnecting {
//            return Color.orange
//        } else if isRejected {
//            return Color.red
//        } else {
//            return Color(red: 0.75, green: 1, blue: 0)
//        }
//    }
//    
//    var statusText: String? {
//        if isConnected {
//            return "전송 완료"
//        } else if isConnecting {
//            return "요청 대기 중..."
//        } else if isRejected {
//            return "연결 거절됨"
//        } else {
//            return nil
//        }
//    }
//    
//    var statusColor: Color {
//        if isConnected {
//            return .green
//        } else if isConnecting {
//            return .orange
//        } else if isRejected {
//            return .red
//        } else {
//            return .clear
//        }
//    }
//    
//    var body: some View {
//        HStack(spacing: 16) {
//            profileImageView
//            nameAndStatusView
//            Spacer()
//            connectButton
//        }
//        .padding(.horizontal, 5)
//        .padding(.vertical, 5)
//    }
//    
//    // MARK: - Private Views
//    
//    @ViewBuilder
//    private var profileImageView: some View {
//        Image(systemName: profileImage)
//            .font(.system(size: 40))
//            .foregroundColor(.blue)
//            .frame(width: 50, height: 50)
//            .background(Color.gray.opacity(0.1))
//            .clipShape(Circle())
//    }
//    
//    @ViewBuilder
//    private var nameAndStatusView: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            nameTextView
//            
//            if let statusText = statusText {
//                Text(statusText)
//                    .font(.caption)
//                    .foregroundColor(statusColor)
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private var nameTextView: some View {
//        HStack(spacing: 0) {
//            Text(peerName)
//                .font(.system(size: 17, weight: .bold))
//                .foregroundColor(Color("MainColor"))
//            
//            Text(" 님에게")
//                .font(.system(size: 17))
//                .foregroundColor(.white)
//        }
//    }
//    
//    @ViewBuilder
//    private var connectButton: some View {
//        Button(buttonText) {
//            if !isConnected && !isConnecting && !isRejected {
//                onConnect()
//            }
//        }
//        .font(.system(size: 14))
//        .frame(width: 100, height: 33)
//        .background(
//            Rectangle()
//                .foregroundColor(.clear)
//                .background(buttonColor)
//                .cornerRadius(19.5)
//        )
//        .disabled(isConnected || isConnecting || isRejected)
//        .foregroundColor(.black)
//    }
//}
//
//#Preview {
//    VStack(spacing: 20) {
//        // 기본 상태
//        PeerCardView(
//            peerName: "김철수",
//            profileImage: "person.circle.fill",
//            isConnected: false,
//            isConnecting: false,
//            isRejected: false
//        ) {
//            print("연결 시도")
//        }
//        
//        // 연결 중 상태
//        PeerCardView(
//            peerName: "이영희",
//            profileImage: "person.circle.fill",
//            isConnected: false,
//            isConnecting: true,
//            isRejected: false
//        ) {
//            print("연결 시도")
//        }
//        
//        // 연결 완료 상태
//        PeerCardView(
//            peerName: "박민수",
//            profileImage: "person.circle.fill",
//            isConnected: true,
//            isConnecting: false,
//            isRejected: false
//        ) {
//            print("연결 시도")
//        }
//        
//        // 거절된 상태
//        PeerCardView(
//            peerName: "최지은",
//            profileImage: "person.circle.fill",
//            isConnected: false,
//            isConnecting: false,
//            isRejected: true
//        ) {
//            print("연결 시도")
//        }
//    }
//    .padding()
//    .background(Color.black)
//}
