//
//  Item.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import Foundation
import SwiftData

@Model
class MyUUID{
    var id: UUID
    
    init(id: UUID){
        self.id = id
    }
}

@Model
class CardModel: Codable, ObservableObject {
    var id: UUID
    var name: String
    var age: Int
    var cardDescription: String
    var birthDate: String
    var mbti: String
    var tag: String
    var dDay: Int
    var imageData: Data
    var topics: [mainTopic] = []
    
    enum CodingKeys: String, CodingKey {
        case id, name, age, cardDescription, birthDate, mbti, tag, dDay, imageData, topics
    }
    
    init(id: UUID , name: String, age: Int, description: String, birthDate: String, mbti: String, tag: String, dDay: Int, imageData: Data) {
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
        self.topics = try container.decode([mainTopic].self, forKey: .topics)
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
        try container.encode(topics, forKey: .topics)
    }
}
