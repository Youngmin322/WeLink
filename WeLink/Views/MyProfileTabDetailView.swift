//
//  MyProfileTabViewDetail.swift
//  WeLink
//
//  Created by 남만두 on 8/5/25.
//

import SwiftUI

struct MyProfileTabDetailView: View {
    @State private var selectedCategory: String = "패션"
    var body: some View {
        ScrollView{
            ZStack{
                Image("winrer_category")
                    .resizable()
                    .scaledToFit()
                
                VStack{
                    Spacer()
                    
                    HStack(spacing: 285){
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .frame(width: 15, height: 25)
                            .foregroundColor(Color("MainColor"))
                        
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color("MainColor"))
                            .font(.system(size: 30))
                            .rotationEffect(Angle(degrees: 90))
                            .bold()
                        
                    }
                    .offset(y:100)
                    
                    VStack(spacing: 30){
                        
                        VStack(spacing:10){
                            Text("Winter")
                                .font(.system(size: 50))
                                .bold()
                                .foregroundColor(.white)
                            
                            VStack(spacing:10){
                                Text(" 사실 저는 여름이 더 좋긴 해요.")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text("겨울에는 생존하느라 기억이 희미해요.")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundColor(.white)
                                
                                
                                Text("절전모드로 들어가야하거든요.")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        HStack(spacing: 19) {
                            ForEach(["25 July", "ENFJ", "아이돌"], id: \.self) { label in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 45)
                                        .foregroundColor(Color.gray)
                                        .frame(width: 76, height: 29)
                                        .opacity(0.6)
                                    Text(label)
                                        .foregroundColor(.white)
                                        .font(.system(size: 13))
                                }
                            }
                        }
                        //동그라미 3개까지의 화면
                        
                        HStack(spacing: 21){
                            Button(action: {
                                selectedCategory = "패션"
                            }) {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 100, height: 88)
                                        .foregroundColor(selectedCategory == "패션" ? Color("MainColor") : Color("CategoryColor"))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.white), lineWidth: 0.3)
                                        )
                                    Text("패션")
                                        .foregroundColor(.white)
                                        .font(.system(size: 17))
                                        .bold()
                                }
                            }
                            
                            Button(action: {
                                selectedCategory = "여가생활"
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 100, height: 88)
                                        .foregroundColor(selectedCategory == "여가생활" ? Color("MainColor") : Color("CategoryColor"))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white, lineWidth: 0.3)
                                        )
                                    Text("여가생활")
                                        .foregroundColor(.white)
                                        .font(.system(size: 17))
                                        .bold()
                                }
                            }
                            
                            Button(action: {
                                selectedCategory = "스포츠"
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 100, height: 88)
                                        .foregroundColor(selectedCategory == "스포츠" ? Color("MainColor") : Color("CategoryColor"))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white, lineWidth: 0.3)
                                        )
                                    Text("스포츠")
                                        .foregroundColor(.white)
                                        .font(.system(size: 17))
                                        .bold()
                                }
                            }
                        }
                        
                        Group {
                            if selectedCategory == "패션" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 290)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("스타일")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("미니멀")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("클래식")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("스트릿")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("캐주얼")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("빈티지")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("러블리")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("Y2K")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("젠더리스")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("긱시크")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("힙한")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("스포티")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("심플")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 233)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("아이템")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("가방")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("신발")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("모자")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("시계")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("주얼리")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("벨트")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("헤어소품")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("키링")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("아이웨어")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 224)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("취향 포인트")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("무채색")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("컬러풀")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("트렌디")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("편안함")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("패턴")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("브랜드")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("그래픽")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("그래픽")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            } else if selectedCategory == "여가생활" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 290)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("활동")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("미니멀")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("클래식")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("스트릿")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("캐주얼")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("빈티지")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("러블리")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("Y2K")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("젠더리스")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("긱시크")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("힙한")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("스포티")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("심플")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 233)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("아이템")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("가방")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("신발")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("모자")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("시계")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("주얼리")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("벨트")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("헤어소품")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("키링")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("아이웨어")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 224)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("취향 포인트")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("무채색")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("컬러풀")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("트렌디")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("편안함")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("패턴")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("브랜드")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("그래픽")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("그래픽")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            } else if selectedCategory == "스포츠" {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 290)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("활동2")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("미니멀")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("클래식")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("스트릿")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("캐주얼")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("빈티지")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("러블리")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("Y2K")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("젠더리스")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("긱시크")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("힙한")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("스포티")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("심플")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 233)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("아이템")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("가방")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("신발")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("모자")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("시계")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("주얼리")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("벨트")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("헤어소품")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("키링")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("아이웨어")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 348, height: 224)
                                        .foregroundColor(Color(hex: 0x3C3C3C))
                                        .opacity(0.7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(.clear), lineWidth: 0.3)
                                                .opacity(0.5)
                                        )
                                    VStack{
                                        VStack(spacing:22){
                                            HStack(spacing: 1){
                                                Text("#")
                                                    .foregroundColor(Color("MainColor"))
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text("취향 포인트")
                                                    .font(.system(size: 20))
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                            VStack(spacing:15){
                                                HStack(spacing:15){
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("무채색")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("컬러풀")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                    
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .frame(width: 81.77, height: 31.2)
                                                            .foregroundColor(Color(hex: 0x524B4B))
                                                            .opacity(0.43)
                                                        
                                                        
                                                        Text("트렌디")
                                                            .foregroundColor(Color(hex:0xA5A5A5))
                                                            .font(.system(size: 13))
                                                            .bold()
                                                    }
                                                }
                                            }
                                            
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("편안함")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("패턴")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("브랜드")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                            }
                                            HStack(spacing:15){
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("그래픽")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 100)
                                                        .frame(width: 81.77, height: 31.2)
                                                        .foregroundColor(Color(hex: 0x524B4B))
                                                        .opacity(0.43)
                                                    
                                                    
                                                    Text("그래픽")
                                                        .foregroundColor(Color(hex:0xA5A5A5))
                                                        .font(.system(size: 13))
                                                        .bold()
                                                }
                                                
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            //                            else {
                            //                                Text("정보를 선택하세요.")
                            //                            }
                        }
                        
                    }
                    .padding(.top,460)
                }
                
            }
        }
        
    }
}



#Preview {
    MyProfileTabDetailView()
}
