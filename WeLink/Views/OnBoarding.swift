import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#2C2C2C")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // 아이콘 자리 (임시 네모)
                    Rectangle()
                        .fill(Color(hex: "#C0FF00"))
                        .frame(width: 180, height: 180)
                        .cornerRadius(30)
                    
                    // 앱 이름 텍스트
                    Text("WeLink")
                        .font(.system(size: 55, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    // 시작하기 버튼
                    NavigationLink(destination: NextView()) {
                        Text("시작하기")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(hex: "#C0FF00"))
                            .cornerRadius(12)
                            .padding(.top, 40)
                    }
                }
            }
        }
    }
}

struct NextView: View {
    var body: some View {
        ZStack {
            Color(hex: "#2C2C2C")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 170) // 네모와 맨 위 간격 유지
                
                Rectangle()
                    .fill(Color(hex: "#C0FF00"))
                    .frame(width: 180, height: 180)
                    .cornerRadius(30)
                
                Spacer().frame(height: 60)
                
                Text("위링이 처음이신가요?")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 80)
                
                Spacer().frame(height: 20)
                
                Text("말로 설명하기 어려운 내 취향, 분위기, 스타일을 이제 한 장의 '취향 카드'로 표현해보세요.")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#848484"))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
//                    .padding(.bottom, 80)
                
                VStack {
                    HStack {
                        Text("skip")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.leading, 35)
                        
                        Spacer()
                        
                        NavigationLink(destination: ThirdView()) {
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "#C0FF00"))
                                .padding(.trailing, 35)
                        }
                    }
                    .padding(.bottom, 0)
                }
            }
            .navigationBarBackButtonHidden(true)

        }
    }
}

struct ThirdView: View {
    var body: some View {
        ZStack {
            Color(hex: "#2C2C2C")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 170) // 네모와 맨 위 간격 유지
                
                Rectangle()
                    .fill(Color(hex: "#C0FF00"))
                    .frame(width: 180, height: 180)
                    .cornerRadius(30)
                
                Spacer().frame(height: 60)
                
                Text("당신의 취향을 기록하고, 나를 표현해보세요")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 20)
                
                Text("좋아하는 색, 향, 스타일, 관심사까지 카드 한 장에 나를 담아 공유할 수 있어요")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#848484"))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
                    .padding(.bottom, 80)
                
                VStack {
                    HStack {
                        Text("Skip")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.leading, 35)
                        
                        Spacer()
                        
                        NavigationLink(destination: ThirdplusoneView()) {
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(hex: "#C0FF00"))
                                .padding(.trailing, 35)
                        }
                    }
                    .padding(.bottom, 0)
                }
            }
            .navigationBarBackButtonHidden(true)

        }
    }
    
}


struct ThirdplusoneView: View {
    var body: some View {
        ZStack {
            Color(hex: "#2C2C2C")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 170) // 네모와 맨 위 간격 유지
                
                Rectangle()
                    .fill(Color(hex: "#C0FF00"))
                    .frame(width: 180, height: 180)
                    .cornerRadius(30)
                
                Spacer().frame(height: 60)
                
                Text("당신의 취향이 누군가에게 큰 힌트가 됩니다.")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 20)
                
                Text("당신을 더 잘 알고 싶은 사람에게, \n 당신을 닮은 선물이 도착할 거예요")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#848484"))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
                    .padding(.bottom, 80)
                
                VStack {
                    HStack {
                        Text("Skip")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.leading, 35)
                        
                        Spacer()
                        
                        NavigationLink(destination: ThirdView()) {
                            Text("Done")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(hex: "#C0FF00"))
                                .padding(.trailing, 35)
                        }

                    }
                    .padding(.bottom, 0)
                }
            }
            .navigationBarBackButtonHidden(true)

        }
    }
}

// HEX 색상 확장
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}



#Preview {
    OnboardingView()
}
