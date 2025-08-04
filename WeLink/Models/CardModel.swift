//
//  Item.swift
//  Wishing
//
//  Created by 조영민 on 8/4/25.
//

import Foundation
import SwiftData

@Model
class CardModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var age: Int
    var cardDescription: String
    var birthDate: String
    var mbti: String
    var tag: String
    var dDay: Int
    var imageData: Data
    
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
}
