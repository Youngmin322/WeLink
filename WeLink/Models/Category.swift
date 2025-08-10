//
//  Category.swift
//  WeLink
//
//  Created by 럭스(양광모) on 8/4/25.
//
import SwiftUI

var mainTopicsOrder: [String] = ["패션", "여가", "스포츠", "영화", "맛집탐방", "뷰티", "여행", "독서", "반려동물", "게임", "식물", "문화생활"]

var topicTitlesDict: [String: [String: [String]]] = [
    "패션 👚": [
        "스타일": ["미니멀", "클래식", "스트릿", "캐주얼", "빈티지", "러블리", "Y2K", "젠더리스", "긱시크", "힙한", "스포티", "심플"],
        "아이템": ["가방", "신발", "모자", "시계", "주얼리", "벨트", "헤어소품", "키링", "아이웨어"],
        "취향 포인트": ["무채색", "컬러풀", "트렌디", "편안함", "패턴", "브랜드", "그래픽"]
        ],
    "여가 🛋️": ["활동": ["영화", "독서", "전시회", "음악", "뮤지컬", "연극", "산책", "요리", "드라이브", "다꾸", "혼술"],
           "휴식 스타일": ["집순이", "밖순이", "기록형", "손활동", "힐링 지향", "콘텐츠", "숙면", "만들기"],
           "아이템": ["조명", "향초", "커피", "스피커", "티", "술잔", "책", "요리도구"]
           ],
    "스포츠 ⚽️": [:],
    "영화 📹": [:],
    "맛집탐방 🍝": [:],
    "뷰티 💄": [:],
    "여행 ✈️": [:],
    "독서 📖": [:],
    "반려동물 🐶": [:],
    "게임 👾": [:],
    "식물 🌱": [:],
    "문화생활 🎤": [:]
]


// .mainTopics['패션'].children['스타일'].children['미니멀']
class Category: ObservableObject{
    @Published var mainTopics: [String: mainTopic]
    var mainTopicsList: [String]
    var isSelected: Bool
    
    init() {
        self.mainTopics = [:]
        self.mainTopicsList = mainTopicsOrder
        self.isSelected = false
        
        for (mainTitle, subTitleDict) in topicTitlesDict {
            var subTopicDict: [String:subTopic] = [:]
            for (subTitle, detailedTitles) in subTitleDict {
                var detailedTopicDict: [String: detailedTopic] = [:]
                for detailedTitle in detailedTitles {
                    detailedTopicDict[detailedTitle] = detailedTopic(title: detailedTitle)
                }
                subTopicDict[subTitle] = subTopic(title: subTitle, children: detailedTopicDict)
            }
            let title:String = String(mainTitle.split(separator: " ")[0])
            let emoji:String = String(mainTitle.split(separator: " ")[1])
            self.mainTopics[title] = mainTopic(title: title, emoji: emoji, children: subTopicDict, isSelected: false)
        }
    }
    
    func addMainTopic(target: mainTopic){
        self.mainTopics[target.title] = target
    }
    
}

class mainTopic: Identifiable, ObservableObject, Codable{
    var id: UUID
    let title: String
    let emoji: String
    var children: [String:subTopic]
    @Published var isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
            case id, title, emoji, isSelected, children
        }
    
    
    init(id: UUID = UUID(), title: String, emoji: String, children: [String:subTopic], isSelected: Bool) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.children = children
        self.isSelected = isSelected
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.title = try container.decode(String.self, forKey: .title)
            self.emoji = try container.decode(String.self, forKey: .emoji)
            self.isSelected = try container.decode(Bool.self, forKey: .isSelected)
            self.children = try container.decode([String: subTopic].self, forKey: .children)  // 수정된 부분
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(emoji, forKey: .emoji)
            try container.encode(isSelected, forKey: .isSelected)
            try container.encode(children, forKey: .children)  // 수정된 부분
        }
    
    func addSubTopic(target: subTopic){
        self.children[target.title] = target
    }
}

class subTopic: Identifiable, Codable{
    var id: UUID
    let title: String
    var children: [String: detailedTopic]
    
    enum CodingKeys: String, CodingKey {
            case id, title, children
        }
    
    init(id:UUID = UUID(), title: String, children: [String: detailedTopic]) {
        self.id = id
        self.title = title
        self.children = children
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.title = try container.decode(String.self, forKey: .title)
            self.children = try container.decode([String: detailedTopic].self, forKey: .children)  // 수정된 부분
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(children, forKey: .children)  // 수정된 부분
        }
    
    func addDetailedTopic(target: detailedTopic){
        self.children[target.title] = target
    }
}

class detailedTopic: Identifiable, ObservableObject, Codable{
    var id: UUID
    let title: String
    @Published var isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
            case id, title, isSelected
        }
    
    init(id:UUID = UUID(), title: String) {
        self.id = id
        self.title = title
        self.isSelected = false
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.title = try container.decode(String.self, forKey: .title)
            self.isSelected = try container.decode(Bool.self, forKey: .isSelected)  // 수정된 부분
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(isSelected, forKey: .isSelected)  // 수정된 부분
        }
}
