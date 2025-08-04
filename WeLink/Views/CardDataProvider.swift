//
//  CardDataProvider.swift
//  WeLink
//
//  Created by weonyee on 8/4/25.
//

import SwiftUI
import SwiftData

struct CardDataProvider {
    static func insertDummyCards(into context: ModelContext) {
        let dummy = [
            CardModel(
                name: "Winter",
                age: 25,
                description: "사실 저는 여름이 더 좋긴 해요.",
                birthDate: "1999-07-25",
                mbti: "ENFJ",
                tag: "#끈기",
                dDay: 10,
                imageData: UIImage(systemName: "person.fill")!.jpegData(compressionQuality: 1.0)!
            ),
            CardModel(
                name: "Ning Ning",
                age: 23,
                description: "닌닌 아니고 닠닠 아니고 닝닝입니다.",
                birthDate: "2004-01-12",
                mbti: "INFP",
                tag: "#야근",
                dDay: 18,
                imageData: UIImage(systemName: "person.crop.circle")!.jpegData(compressionQuality: 1.0)!
            )
        ]
        for card in dummy {
            context.insert(card)
        }
    }

    static func addDummyCard(into context: ModelContext) {
        let names = ["장원영", "안유진", "리즈", "레이", "가을", "이서"]
        let ages = [18, 20, 22, 25, 27, 30]
        let descriptions = [
            "새로 추가된 친구",
            "친절하고 상냥한 친구",
            "열심히 사는 사람",
            "늘 웃는 얼굴",
            "모험을 좋아함"
        ]
        let mbtis = ["ISFP", "ENFJ", "INTJ", "INFP", "ESFP", "ENTP"]
        let tags = ["#친구", "#추가", "#즐거움", "#열정", "#성실", "#웃음"]
        
        // 애셋에 있는 이미지 이름 배열
        let imageNames = ["Winter", "NingNing"]
        let images = imageNames.compactMap { UIImage(named: $0) }
        
        let randomName = names.randomElement() ?? "새 친구"
        let randomAge = ages.randomElement() ?? 20
        let randomDesc = descriptions.randomElement() ?? "새로 추가된 친구"
        let randomMBTI = mbtis.randomElement() ?? "ISFP"
        let randomTag = tags.randomElement() ?? "#친구"
        let randomImageOptional = images.randomElement()
        
        guard let randomImage = randomImageOptional,
              let imageData = randomImage.jpegData(compressionQuality: 1.0) else {
            print("이미지 변환 실패")
            return
        }
        
        let newCard = CardModel(
            name: randomName,
            age: randomAge,
            description: randomDesc,
            birthDate: "2000-01-01",
            mbti: randomMBTI,
            tag: randomTag,
            dDay: Int.random(in: 0...30),
            imageData: imageData
        )
        context.insert(newCard)
    }


}
