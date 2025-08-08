import UIKit

struct SampleData {
    static let sampleCards: [CardModel] = [
        CardModel(
            name: "Ning Ning",
            age: 23,
            description: "닌닌 아니고 닠닠 아니고 닝닝입니다.",
            birthDate: "2000.01.12",
            mbti: "INFP",
            tag: "직장인",
            dDay: 3,
            imageData: UIImage(named: "ningning")!.jpegData(compressionQuality: 1.0)!
        ),
        CardModel(
            name: "Karina",
            age: 26,
            description: "너와 나의 세대가 마지막이면 어떡해~",
            birthDate: "1999.07.15",
            mbti: "INTJ",
            tag: "간호사",
            dDay: 5,
            imageData: UIImage(named: "Karina")!.jpegData(compressionQuality: 1.0)!
        ),
    ]
}
