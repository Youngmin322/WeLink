//
//  Category.swift
//  WeLink
//
//  Created by 럭스(양광모) on 8/4/25.
//

var topicTitlesDict: [String: [String: [String]]] = [
    "패션": [
        "스타일": ["미니멀", "클래식", "스트릿", "캐주얼", "빈티지", "러블리", "Y2K", "젠더리스", "긱시크", "힙한", "스포티", "심플"],
        "아이템": ["가방", "신발", "모자", "시계", "주얼리", "벨트", "헤어소품", "키링", "아이웨어"],
        "취향 포인트": ["무채색", "컬러풀", "트렌디", "편안함", "패턴", "브랜드", "그래픽"]
        ],
    "여가": ["활동": ["영화", "독서", "전시회", "음악", "뮤지컬", "연극", "산책", "요리", "드라이브", "다꾸", "혼술"],
           "휴식 스타일": ["집순이", "밖순이", "기록형", "손활동", "힐링 지향", "콘텐츠", "숙면", "만들기"],
           "아이템": ["조명", "향초", "커피", "스피커", "티", "술잔", "책", "요리도구"]
           ],
    "스포츠": [:],
    "영화": [:],
    "맛집탐방": [:],
    "뷰티": [:],
    "여행": [:],
    "독서": [:],
    "반려동물": [:],
    "게임": [:],
    "식물": [:],
    "문화생활": [:]
]


// .mainTopics['패션'].children['스타일'].children['미니멀']
class category{
    var mainTopics: [String: mainTopic]
    var isSelected: Bool
    
    init() {
        self.mainTopics = [:]
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
            self.mainTopics[mainTitle] = mainTopic(title: mainTitle, children: subTopicDict)
        }
    }
    
    func addMainTopic(target: mainTopic){
        self.mainTopics[target.title] = target
    }
    
}

class mainTopic{
    let title: String
    var children: [String:subTopic]
    var isSelected: Bool
    
    init(title: String, children: [String:subTopic]) {
        self.title = title
        self.children = children
        self.isSelected = false
    }
    
    func addSubTopic(target: subTopic){
        self.children[target.title] = target
    }
}

class subTopic{
    let title: String
    var children: [String: detailedTopic]
    
    init(title: String, children: [String: detailedTopic]) {
        self.title = title
        self.children = children
    }
    
    func addDetailedTopic(target: detailedTopic){
        self.children[target.title] = target
    }
}

class detailedTopic{
    let title: String
    var isSeleted: Bool
    
    init(title: String) {
        self.title = title
        self.isSeleted = false
    }
}
