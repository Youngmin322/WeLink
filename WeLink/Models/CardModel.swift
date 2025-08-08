//
//  Item.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import Foundation
import SwiftData

@Model
class CardModel: Codable {
    @Attribute(.unique) var id: UUID
    var name: String
    var age: Int
    var cardDescription: String
    var birthDate: String
    var mbti: String
    var tag: String
    var dDay: Int
    var imageData: Data
    
    enum CodingKeys: String, CodingKey {
        case id, name, age, cardDescription, birthDate, mbti, tag, dDay, imageData
    }
    
    init(id: UUID = UUID(), name: String, age: Int, description: String, birthDate: String, mbti: String, tag: String, dDay: Int, imageData: Data) {
        self.id = id
        self.name = name
        self.age = age
        self.cardDescription = description
        self.birthDate = birthDate
        self.mbti = mbti
        self.tag = tag
        self.dDay = dDay
        self.imageData = imageData
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.cardDescription = try container.decode(String.self, forKey: .cardDescription)
        self.birthDate = try container.decode(String.self, forKey: .birthDate)
        self.mbti = try container.decode(String.self, forKey: .mbti)
        self.tag = try container.decode(String.self, forKey: .tag)
        self.dDay = try container.decode(Int.self, forKey: .dDay)
        self.imageData = try container.decode(Data.self, forKey: .imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(cardDescription, forKey: .cardDescription)
        try container.encode(birthDate, forKey: .birthDate)
        try container.encode(mbti, forKey: .mbti)
        try container.encode(tag, forKey: .tag)
        try container.encode(dDay, forKey: .dDay)
        try container.encode(imageData, forKey: .imageData)
    }
}

// 테스트용 목업 데이터 extension
extension CardModel {
    static let mockCard1 = CardModel(
        name: "조영민",
        age: 26,
        description: "iOS 개발자입니다. 좋은 앱을 만들고 싶어요!",
        birthDate: "1998-05-15",
        mbti: "INFP",
        tag: "개발자",
        dDay: 120,
        imageData: Data()
    )
    
    static let mockCard2 = CardModel(
        name: "김철수",
        age: 25,
        description: "안녕하세요! 백엔드 개발자 김철수입니다.",
        birthDate: "1999-03-15",
        mbti: "ENFP",
        tag: "백엔드",
        dDay: 100,
        imageData: Data()
    )
    
    static let mockCard3 = CardModel(
        name: "이영희",
        age: 28,
        description: "UI/UX 디자이너 이영희입니다!",
        birthDate: "1996-07-22",
        mbti: "INFJ",
        tag: "디자이너",
        dDay: 50,
        imageData: Data()
    )
    
    // 기본 테스트용 카드
    static let defaultMockCard = CardModel(
        name: "홍길동",
        age: 30,
        description: "반갑습니다!",
        birthDate: "1994-01-01",
        mbti: "ISFJ",
        tag: "일반",
        dDay: 365,
        imageData: Data()
    )
}
