import UIKit
import SwiftData

struct CardDataProvider {
    static func insertDummyCards(into context: ModelContext) {
        let dummyCards = [
            CardModel(
                name: "Howard",
                age: 25,
                description: "내 귀에 캔디\n하워드의 라이브 코딩\n테크멘토 하워드",
                birthDate: "1998-08-17",
                mbti: "ENFJ",
                tag: "아이돌",
                dDay: 3,

                imageData: UIImage(named: "winter")?.jpegData(compressionQuality: 0.8) ?? Data(),
                //윈터 사진 바꿔야함
            ),
            CardModel(
                name: "Winter",
                age: 25,
                description: "사실 저는 여름이 더 좋긴 해요.\n겨울에는 생존하느라 기억이 희미해요.\n절전모드로 들어가야하거든요.",
                birthDate: "1998-12-01",
                mbti: "ENFJ",
                tag: "아이돌",
                dDay: 98,

                imageData: UIImage(named: "winter")?.jpegData(compressionQuality: 0.8) ?? Data(),
                //윈터 사진 바꿔야함
            ),
            CardModel(
                name: "Karina",
                age: 27,
                description: "너와 나의 세대가 마지막이면 어떡해~\n또 다른 빙하기가 찾아오면 어떡해~",
                birthDate: "1996-07-15",
                mbti: "ISFP",
                tag: "간호사",
                dDay: 150,
                imageData: UIImage(named: "Karina")?.jpegData(compressionQuality: 0.8) ?? Data(),
            ),
            CardModel(
                name: "Ning Ning",
                age: 24,
                description: "닌닌 아니고 닠닠 아니고\n닝닝입니다 Ning Ning. 알겠닝?\nWarning !!!",
                birthDate: "1999-04-10",
                mbti: "INTJ",
                tag: "직장인",
                dDay: 50,
                imageData: UIImage(named: "ningning")?.jpegData(compressionQuality: 0.8) ?? Data(),
            ),
            CardModel(
                name: "Giselle",
                age: 26,
                description: "지젤은 처음 들었을 때 조금 가젤 같았음\n지젤의 인스타아이디 @aerichandesu 간지",
                birthDate: "1997-10-20",
                mbti: "INFJ",
                tag: "대학생",
                dDay: 75,
                imageData: UIImage(named: "Giselle")?.jpegData(compressionQuality: 0.8) ?? Data(),
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
