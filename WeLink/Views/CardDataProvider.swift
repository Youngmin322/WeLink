import UIKit
import SwiftData

struct CardDataProvider {
    static func insertDummyCards(into context: ModelContext) {
        let dummyCards = [
            CardModel(
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
                name: "Karina",
                age: 27,
                description: "너와 나의 세대가 마지막이면 어떡해~",
                birthDate: "1996-07-15",
                mbti: "ISFP",
                tag: "간호사",
                dDay: 150,
                imageData: UIImage(named: "Karina")?.jpegData(compressionQuality: 0.8) ?? Data()
            ),
            CardModel(
                name: "Ning Ning",
                age: 24,
                description: "닌닌 아니고 닠닠 아니고 닝닝입니다.",
                birthDate: "1999-04-10",
                mbti: "INTJ",
                tag: "직장인",
                dDay: 50,
                imageData: UIImage(named: "NingNing")?.jpegData(compressionQuality: 0.8) ?? Data()
            ),
            CardModel(
                name: "Giselle",
                age: 26,
                description: "지젤은 처음 들었을 때 조금 가젤 같았음",
                birthDate: "1997-10-20",
                mbti: "INFJ",
                tag: "대학생",
                dDay: 75,
                imageData: UIImage(named: "Giselle")?.jpegData(compressionQuality: 0.8) ?? Data()
            ),
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
