//
//  ProfileCustom.swift
//  WeLink
//
//  Created by 남만두 on 8/4/25.
//

import SwiftUI
import SwiftData

struct ProfileCustomView: View {
    var progress: CGFloat
    @State private var name: String = ""
    @State private var birthDate: String = ""
    @State private var nickname: String = ""
    @State private var introduction: String = ""
    @State private var mbti: String = ""
    @State private var job: String = ""
    @State private var showPicker = false
    @State private var selectedImage: UIImage?
    @FocusState private var focusedField: FocusField?

    @State private var birthDateError: Bool = false
    @State private var cardModel: CardModel?
    @State private var goNext:Bool = false
    
    @Environment(\.modelContext) private var context
    
    @Query private var IDs: [MyUUID]
    @Query private var cards: [CardModel]
    
    private var myID: MyUUID = MyUUID(id: UUID())
    
    var isEdit: Bool
    
    init(progress: CGFloat, cardModel: CardModel? = nil, isEdit: Bool){
        self.progress = progress
        self.cardModel = cardModel
        self.isEdit = isEdit
        if cardModel != nil {
            self.myID = isEdit ? MyUUID(id: cardModel!.id) : self.myID
        }
    }
    enum FocusField: Hashable {
        case name, birthDate, nickname, introduction, mbti, job
    }
    
    private func calculateAgeByYear(from birthDateString: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let birthDate = formatter.date(from: birthDateString) else {
            return nil
        }
        let calendar = Calendar.current
        let birthYear = calendar.component(.year, from: birthDate)
        let currentYear = calendar.component(.year, from: Date())
        // Korean age: currentYear - birthYear + 1
        return currentYear - birthYear + 1
    }

    // Calculate D-Day (days until next birthday) from birth date string in yyyy-MM-dd format
    private func calculateDaysUntilBirthday(from birthDateString: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let birthDate = formatter.date(from: birthDateString) else {
            return nil
        }
        let calendar = Calendar.current
        let now = Date()
        var nextBirthdayComponents = calendar.dateComponents([.month, .day], from: birthDate)
        nextBirthdayComponents.year = calendar.component(.year, from: now)
        var nextBirthday = calendar.date(from: nextBirthdayComponents)!
        if nextBirthday < now {
            nextBirthdayComponents.year! += 1
            nextBirthday = calendar.date(from: nextBirthdayComponents)!
        }
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: now), to: calendar.startOfDay(for: nextBirthday)).day ?? 0
        return days
    }
    
var body: some View {
    NavigationStack {
        ZStack{
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack{
                ZStack(alignment: .leading) {
                    let barWidth: CGFloat = 324
                    let barHeight: CGFloat = 2
                    
                    // 회색 배경 바
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: barWidth, height: barHeight)
                    
                    // 연두색 프로그레스 바
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("MainColor"))
                        .frame(width: barWidth * 0.2, height: barHeight)
                }
                .padding(.bottom, 20)
                
                ScrollView(.vertical) {
                    VStack {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("프로필을 입력해주세요!")
                                .foregroundColor(.white)
                                .font(.system(size: 21))
                                .bold()
                            Text("당신만의 취향카드를 만들어드릴게요.")
                                .font(.system(size: 15))
                                .foregroundColor(Color("MainColor"))
                        }
                        .padding(.trailing, 100)

                        Spacer(minLength: 34)

                        profileImageInputView
                        userInfoFieldsView
                        
                        //TODO: 나이, 디데이 계산 로직 만들기
                        let age = calculateAgeByYear(from: birthDate) ?? 0
                        let dDay = calculateDaysUntilBirthday(from: birthDate) ?? 0
                        
                        let isReady = (!name.isEmpty &&
                        !birthDate.isEmpty &&
                        !nickname.isEmpty &&
                        !introduction.isEmpty &&
                        !mbti.isEmpty &&
                        !job.isEmpty &&
                        selectedImage != nil)
                        
                        VStack {
                                Button(action: {
                                    // 여기에 버튼 눌렀을 때 실행할 로직 작성
                                        // 예: cardModel 생성
                                    if isEdit {
                                        cardModel?.name = name
                                        cardModel?.age = age
                                        cardModel?.cardDescription = introduction
                                        cardModel?.birthDate = birthDate
                                        cardModel?.mbti = mbti
                                        cardModel?.tag = job
                                        cardModel?.dDay = dDay
                                        cardModel?.imageData = selectedImage!.pngData()!
                                    }
                                    else {
                                        cardModel = CardModel(id: myID.id,
                                                              name: name,
                                                              age: age,
                                                              description: introduction,
                                                              birthDate: birthDate,
                                                              mbti: mbti,
                                                              tag: job,
                                                              dDay: dDay,
                                                              imageData: selectedImage!.pngData()!
                                        )
                                        
                                        context.insert(myID)
                                        try? context.save()
                                    }
                                    
                                    
                                        // 화면 이동 트리거
                                        goNext = true
                                                                    }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 45)
                                            .foregroundColor(isReady ? Color("MainColor") : Color(.gray))
                                            .frame(width: 324, height: 58)
                                        Text("확인")
                                            .bold()
                                            .foregroundColor(.black)
                                            .font(.system(size: 17))
                                    }
                                }
//                                .disabled(!isReady)

                                // 화면 이동을 위한 NavigationLink
                                .navigationDestination(isPresented: $goNext) {
                                    if isEdit {
                                        MyProfileTabView()
                                    }
                                    else{
                                        if let cardModel = cardModel {
                                            CategoryView(progress: 2.0/4.0, cardModel: cardModel, isEdit: false)
                                        }
                                    }
                                    }
                                    
                            }
                        
    
                    }
                }
            }
        
        
            }
            
        }
    }
        

    
    private var profileImageInputView: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 196.3, height: 312)
                    .foregroundColor(Color("CategoryColor"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .onTapGesture {
                        showPicker = true
                    }

                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 196.3, height: 312)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            Button(action: {
                                showPicker = true
                            }) {
                                ZStack {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color("BackGround"))

                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .frame(width: 25, height: 20)
                                        .foregroundColor(Color.white)
                                }
                            },
                            alignment: .bottomTrailing
                        )
                } else {
                    VStack {
                        ZStack(alignment: .center) {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.4))
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showPicker) {
            PhotoPicker(selectedImage: $selectedImage)
        }
    }

    private var userInfoFieldsView: some View {
        
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("이름")
                        .foregroundColor(Color(hex:0xCACACA))
                        .bold()
                        .font(.system(size: 16))
                    TextField("", text: $name)
                        .padding()
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    focusedField == .name ? Color("MainColor") : Color("CategoryColor"),
                                    lineWidth: 1.5
                                )
                        )
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .name)

                    Text("생년월일")
                        .foregroundColor(Color(hex:0xCACACA))
                        .bold()
                        .font(.system(size: 16))
                    TextField(
                        "",
                        text: $birthDate
                    )
                        .padding()
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    focusedField == .birthDate ? Color("MainColor") : Color("CategoryColor"),
                                    lineWidth: 1.5
                                )
                        )
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .birthDate)
                        .onChange(of: birthDate) { newValue in
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            if formatter.date(from: newValue) != nil {
                                birthDateError = false
                            } else {
                                birthDateError = true
                            }
                        }
                    if birthDateError {
                        Text("생년월일을 yyyy-MM-dd 형식으로 입력해주세요")
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }

                    Text("닉네임")
                        .foregroundColor(Color(hex:0xCACACA))
                        .bold()
                        .font(.system(size: 16))
                    TextField("", text: $nickname)
                        .padding()
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    focusedField == .nickname ? Color("MainColor") : Color("CategoryColor"),
                                    lineWidth: 1.5
                                )
                        )
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .nickname)
                    
                    
                    
                    Text("한줄소개")
                        .foregroundColor(Color(hex:0xCACACA))
                        .bold()
                        .font(.system(size: 16))
                    TextField("", text: $introduction)
                        .padding()
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    focusedField == .introduction ? Color("MainColor") : Color("CategoryColor"),
                                    lineWidth: 1.5
                                )
                        )
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .introduction)
                    
                    
                    Text("MBTI")
                        .foregroundColor(Color(hex:0xCACACA))
                        .bold()
                        .font(.system(size: 16))
                    TextField("", text: $mbti)
                        .padding()
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    focusedField == .mbti ? Color("MainColor") : Color("CategoryColor"),
                                    lineWidth: 1.5
                                )
                        )
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .mbti)
                    
                    
                    Text("직업")
                        .foregroundColor(Color(hex:0xCACACA))
                        .bold()
                        .font(.system(size: 16))
                    TextField("", text: $job)
                        .padding()
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    focusedField == .job ? Color("MainColor") : Color("CategoryColor"),
                                    lineWidth: 1.5
                                )
                        )
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .job)
                    
                }
            }
            .padding(.horizontal, 30)
            .foregroundColor(Color("BackgroundColor"))

            Spacer()
            
        
            
        }
    }
}
    


#Preview {
    NavigationStack {
        ProfileCustomView(progress: 0.5, isEdit: false)
    }
}
