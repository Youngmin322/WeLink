import UIKit
import SwiftData

struct CardDataProvider {
    static func insertDummyCards(into context: ModelContext) {
        let dummyCards = [
            CardModel(
                id: UUID(),
                name: "Winter",
                age: 25,
                description: "사실 저는 여름이 더 좋긴 해요.",
                birthDate: "1998-12-01",
                mbti: "ENFJ",
                tag: "아이돌",
                dDay: 98,
                imageData: UIImage(named: "Winter")?.jpegData(compressionQuality: 0.8) ?? Data()
            ),
            CardModel(
                id: UUID(),
                name: "Summer",
                age: 27,
                description: "여름에는 바다를 좋아해요.",
                birthDate: "1996-07-15",
                mbti: "ISFP",
                tag: "여행",
                dDay: 150,
                imageData: UIImage(named: "Summer")?.jpegData(compressionQuality: 0.8) ?? Data()
            ),
            CardModel(
                id: UUID(),
                name: "Spring",
                age: 24,
                description: "봄꽃이 참 좋아요.",
                birthDate: "1999-04-10",
                mbti: "INTJ",
                tag: "책읽기",
                dDay: 50,
                imageData: UIImage(named: "Spring")?.jpegData(compressionQuality: 0.8) ?? Data()
            ),
            CardModel(
                id: UUID(),
                name: "Autumn",
                age: 26,
                description: "가을 단풍 구경을 좋아합니다.",
                birthDate: "1997-10-20",
                mbti: "INFJ",
                tag: "사진",
                dDay: 75,
                imageData: UIImage(named: "Autumn")?.jpegData(compressionQuality: 0.8) ?? Data()
            )
        ]

        for card in dummyCards {
            context.insert(card)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save dummy cards: \(error)")
        }
    }
}
