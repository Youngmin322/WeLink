//
//  MyProfileTabViewDetail.swift
//  WeLink
//
//  Created by 남만두 on 8/5/25.
//

import SwiftUI

struct MyProfileTabDetailView: View {
    var body: some View {
     
        ZStack{
            Image("Winter")
                .resizable()
                .frame(width: 470,height: 910)
                .scaledToFit()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.black.opacity(0.6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            ScrollView{
                VStack{
                    Spacer()
                    
                    HStack(spacing: 317){
//                        Text("〈")
//                            .foregroundColor(Color("MainColor"))
//                            .font(.system(size: 30))
//                            .bold()
                        
                        
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color("MainColor"))
                            .font(.system(size: 30))
                            .rotationEffect(Angle(degrees: 90))
                            .bold()
                        
                    }
                    .offset(x:10, y:100)
                    
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
                        
                        
                        HStack(spacing: 21){
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 100, height: 88)
                                    .foregroundColor(Color("CategoryColor"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(.white), lineWidth: 0.3)
                                    )
                                Text("패션")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17))
                                    .bold()
                            }
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 100, height: 88)
                                    .foregroundColor(Color("CategoryColor"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(.white), lineWidth: 0.3)
                                    )
                                Text("여가생활")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17))
                                    .bold()
                            }
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 100, height: 88)
                                    .foregroundColor(Color("CategoryColor"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(.white), lineWidth: 0.3)
                                    )
                                Text("스포츠")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17))
                                    .bold()
                            }
                        
                            
                            
                        }
                    }
                    .padding(.top,460)
                }
               
            }
        }
    }
}

//
//#Preview {
//    MyProfileTabDetailView()
//}
