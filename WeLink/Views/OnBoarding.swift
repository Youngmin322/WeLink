import SwiftUI

struct OnboardingView: View {
    @State private var isTapped = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#2C2C2C")
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTapped = true
                    }
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: "#2C2C2C"))
                            .frame(width: 180, height: 180)
                            .cornerRadius(30)
                            .shadow(color: Color.white.opacity(0.45), radius: 10, x: 0, y: 4)

                        Image("AppiconImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit) // 이미지 비율 유지
                            .frame(width: 180, height: 180) // Rectangle보다 살짝 작게
                            .clipShape(RoundedRectangle(cornerRadius: 30)) // 모서리 둥글게
                    }

                    Text("WeLink")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding()
                
                // Invisible NavigationLink triggered by tap
                NavigationLink(destination: NextView(), isActive: $isTapped) {
                    EmptyView()
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
                Spacer().frame(height: 140)
                
                Image("Onboarding2-1")
                    .resizable()
                    .aspectRatio(contentMode: .fill) // or .fit
                    .frame(width: 240, height: 240)
                
                
                Spacer().frame(height: 150)
                
                Text("위링이 처음이신가요?")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                
                Spacer().frame(height: 20)
                
                Text("말로 설명하기 어려운 내 취향, 분위기, 스타일을 이제 한 장의 '취향 카드'로 표현해보세요.")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#848484"))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                
                HStack {
                    // Skip
                    NavigationLink(destination: FinalView()) {
                        Text("Skip")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.leading, 30)
                    }
                    Spacer()
                    
                    // 인디케이터 부분
                    HStack(spacing: 10) {
                        ForEach(1...3, id: \.self) { index in
                            if index == 1 { // ← 현재 단계를 1로
                                Capsule()
                                    .fill(Color(hex: "#C0FF00"))
                                    .frame(width: 20, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 화살표 버튼
                    NavigationLink(destination: ThirdView()) {
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.trailing, 30)
                    }
                }
                .padding(.bottom, 10)
                
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
                Spacer().frame(height: 140) // 네모와 맨 위 간격 유지
                
                Image("Onboarding2-2")
                    .resizable()
                    .aspectRatio(contentMode: .fill) // or .fit
                    .frame(width: 240, height: 240)
                
                
                Spacer().frame(height: 150)
                
                Text("당신의 취향을 기록하고,\n나를 표현해보세요")
                    .font(.system(size: 25, weight: .bold))
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
                
                HStack {
                    // Skip
                    NavigationLink(destination: FinalView()) {
                        Text("Skip")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.leading, 30)
                    }
                    
                    Spacer()
                    
                    // 인디케이터
                    HStack(spacing: 10) {
                        ForEach(1...3, id: \.self) { index in
                            if index == 2 {
                                Capsule()
                                    .fill(Color(hex: "#C0FF00"))
                                    .frame(width: 20, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 화살표 버튼
                    NavigationLink(destination: ThirdplusoneView()) {
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.trailing, 30)
                    }
                }
                .padding(.bottom, 10)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}



struct ThirdplusoneView: View {
    var body: some View {
        ZStack {
            Color(hex: "#2C2C2C")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 140)
                
                Image("onboarding3")
                    .resizable()
                    .aspectRatio(contentMode: .fill) // or .fit
                    .frame(width: 240, height: 240)
                
                Spacer().frame(height: 150)
                
                Text("친구와 카드를 주고받으며\n서로의 취향을 확인해요")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 20)
                
                Text("각자의 카드를 보며 서로를 더 잘 이해할 수 있어요")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#848484"))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                HStack {
                    // Skip
                    NavigationLink(destination: FinalView()) {
                        Text("Skip")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.leading, 30)
                    }
                    
                    Spacer()
                    
                    // Indicator (3단계)
                    HStack(spacing: 10) {
                        ForEach(1...3, id: \.self) { index in
                            if index == 3 {
                                Capsule()
                                    .fill(Color(hex: "#C0FF00"))
                                    .frame(width: 20, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Done 버튼
                    NavigationLink(destination: FinalView()) {
                        Text("Done")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(hex: "#C0FF00"))
                            .padding(.trailing, 30)
                    }
                }
                .padding(.bottom, 10) // 하단 여백
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


struct FinalView: View {
    var body: some View {
        ZStack {
            Color(hex: "#C0FF00")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        .fill(Color(hex: "#2C2C2C"))
                        .frame(width: 180, height: 180)
                        .cornerRadius(30)
                        .shadow(color: Color.white.opacity(0.45), radius: 10, x: 0, y: 4)

                    Image("AppiconImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit) // 이미지 비율 유지
                        .frame(width: 180, height: 180) // Rectangle보다 살짝 작게
                        .clipShape(RoundedRectangle(cornerRadius: 30)) // 모서리 둥글게
                }
                Text("WeLink")
                    .font(.system(size: 55, weight: .bold))
                    .foregroundStyle(.black)
                Spacer() // 중간 공간 확보
                
                
                NavigationLink(destination: ProfileCustomView(progress: 1.0 / 4.0)) {
                    Text("시작하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 135)
                        .padding(.vertical, 18)
                        .background(Color(hex: "#2C2C2C"))
                        .cornerRadius(30)
                    // 버튼은 비워두거나 필요에 따라 추가 가능
                }
            }
            .padding(.bottom, 20) // 하단 여백
            
        }
        .navigationBarBackButtonHidden(true)
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
 
