//
//  ProfileCustom.swift
//  WeLink
//
//  Created by 남만두 on 8/4/25.
//

import SwiftUI



struct ProfileCustom: View {
    
    @State private var name: String = ""
    @State private var birthDate: String = ""
    @State private var nickname: String = ""
    @State private var introduction: String = ""
    @State private var mbti: String = ""
    @State private var job: String = ""
    @State private var showPicker = false
    @State private var selectedImage: UIImage?
    @FocusState private var focusedField: FocusField?

    enum FocusField: Hashable {
        case name, birthDate, nickname, introduction, mbti, job
    }
    
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                   .ignoresSafeArea()
            ScrollView(.vertical) {
                VStack{
                    Spacer(minLength: 15)
                    
                    RoundedRectangle(cornerRadius: 26)
                        .frame(width: 324, height: 2)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 54)
                    
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
                                            ZStack{
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
                                    ZStack(alignment: .center){
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
                
                VStack(spacing: 40){
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
                            TextField("", text: $birthDate)
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
                    
                    Button(action: {
                        print("확인 버튼 클릭됨")
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 45)
                                .foregroundColor(Color("MainColor"))
                                .frame(width: 324, height: 58)
                            Text("확인")
                                .bold()
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                        }
                    }
                }
            }
                    
                }
            }
}
    


#Preview {
    ProfileCustom()
}
