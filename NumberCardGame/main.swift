
import Foundation


extension Array where Element == Int {
    func chunked(by size: Int) -> [[Int]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0 ..< $0 + size])
        }
    }
}

// 동일한 최소거리를 갖는 주어진 배열이 있는 경우 마지막 숫자가 더 큰 숫자의 배열의 인덱스 리턴 함수
// 매개변수: 조사 대상 array
// return 값: [동일 최소값을 갖는 요소의 index들]
func FindIndicesOfMinValues(from array: [Int]) -> [Int] {
    // 최소값 구하기
    guard !array.isEmpty, let minValue = array.min() else {return []}
    // 최소값의 인덱스 구하기
    let indices = array.enumerated().compactMap { index, value in
        (value == minValue) ? index : nil
    }
    return indices
}

// 동일한 최소거리를 갖는 주어진 배열이 있는지 확인하는 함수
// 매개변수: 조사대상 array
// return 값: Bool
func hasTwoMinValues(from array: [Int]) -> Bool {
    guard !array.isEmpty, let minValue = array.min() else { return false}
    let numOfMinValues = array.filter { $0 == minValue }.count
    return numOfMinValues == 2
}

// Participant 구조체의 인스턴스 3개의 배열에서 각 인스턴스의 속성(cardNumber: Int)을 오름차순으로 정렬한 순서 대로 각 인스턴스의 다른 속성(priority: Int)에 각각 1, 2, 3을 주는 함수( -> 객체를 cardNumber 순으로 나열하고 각각의 priority는 배열의 index + 1을 입력)
// 매개변수:byCardNumber participants: inout [Participant]
// return값: [Participant]
func assignPrioritiesToParticipants(byCardNumber participants: inout [Participant]) {
    let ascendingParticipants = participants.sorted { $0.cardNumber < $1.cardNumber }
    for (index, participantSorted) in ascendingParticipants.enumerated() {
        // 참조복사본 참가자 인스턴스들에 priority를 입력하고
        let priority = index + 1
        
        // 참조복사본 참가자 인스턴스와 이름이 동일한 참가자 인스턴스의 participants 인덱스를 확보하고 해당 참가자 인스턴스의 priority 업데이트
        guard let i = participants.firstIndex(where: { $0.name == participantSorted.name }) else { fatalError("인덱스를 찾지 못했어요") }
        participants[i].updatePriority(newValue: priority)
    }
    
}

struct Participant {
    
    let name: String
    var cardNumber: Int
    var priority: Int
    var distance: Int
    var cardGroupAppending: CardGroup?
    var cardGroup: CardGroup?
    var penalty: Int
    
    static var countOfInitializing = 0  // 참가자 객체가 몇번 생성되었나
    
    init(name: String, cardNumber: Int = 0, priority: Int = 0, distance: Int = 100, cardGroupAppending: CardGroup? = nil, cardGroup: CardGroup? = nil, penalty: Int = 0) {
        self.name = name
        self.cardNumber = cardNumber
        self.priority = priority
        self.distance = distance
        self.cardGroupAppending = cardGroupAppending
        self.cardGroup = cardGroup
        self.penalty = penalty
        
        Self.countOfInitializing += 1
    }
    
    mutating func updatePriority(newValue: Int) { // 배열 순서 우선순위
        priority = newValue
    }
    
    mutating func updateDistance(newValue: Int) { // 참가자의 숫자와 주어진 배열의 숫자와의 거리
        distance = newValue
    }
    
    mutating func updateCardGroup(newValue: CardGroup) {
        cardGroup = newValue
    }
    
    mutating func updatePenalty(newValue: Int) {
        penalty += newValue
    }
    
    
    // 거리 계산 및 동일 최소값의 경우 가장 큰 last 값을 가진 인덱스 변환
    mutating func decideCardGroup(from cardGroups: [CardGroup?]) ->Int? {
        
        // A 조건
        // 최소거리 파악 함수
        var distances: [Int] = []
        cardGroups.forEach { cardGroup in
            guard let lastCardGroupNumber = cardGroup?.cards.last else {fatalError("카드 그룹을 확인하세요")}
            let numDistance = abs(lastCardGroupNumber - cardNumber)
            distances.append(numDistance)
        }
        guard let minDistance = distances.min() else {fatalError("빈배열인가? distances")}
        
        // 동일한 최소거리를 갖는 주어진 배열이 있는 경우 마지막 숫자가 더 큰 숫자의 배열의 인덱스 리턴 함수
        // 동일한 최소거리를 갖는 주어진 배열이 있는지 확인하는 함수
        var hasTwoMinValues =  hasTwoMinValues(from: distances)
        var minDistanceCardGroupIndex: Int?
        
        if hasTwoMinValues {
            // 최소값 인덱스들 배열
            let indices = FindIndicesOfMinValues(from: distances)
            
            // 최소값 중에서 cardGroups의 마지막 요소가 가장 큰 값인 경우의 cardGroups 인덱스
            minDistanceCardGroupIndex = indices.sorted {
                let lastMin0 = cardGroups[$0]?.cards.last ?? -1
                let lastMin1 = cardGroups[$1]?.cards.last ?? -1
                return lastMin0 < lastMin1
            }.last
        } else {
            minDistanceCardGroupIndex = distances.enumerated().compactMap({ index, distance in
                (distance == minDistance) ? index : nil
            }).last
        }
        self.distance = minDistance
        self.cardGroupAppending = cardGroups[minDistanceCardGroupIndex ?? -1]
        
        return minDistanceCardGroupIndex
    }
    
    
    // 조건 비교 후 append or 벌점처리와 cardGroup 업데이트
    mutating func applyToCardGroup(index: Int, cardGroups: inout [CardGroup]) {
        
        // B조건: 이것은 play()에서 해결해야 할 듯

        // 해당 참가자 객체의 저장된 배열(주어진 배열과 동일)의 마지막 요소 숫자가 참가자가 제시한 숫자보다
        //   가) 크면: 해당 참가자 객체의 저장된 배열에 참가자가 제시한 숫자를 append 한다
        //   나) 작으면: 해당 참가자 객체의 저장된 배열의 크기(size)를 참가자 객체 속성인 panalty에 담고 그 객체에 저장된 배열을 비우고, 주어진 배열에서 해당 배열(value)과 key 값을 제거한다.
        
        guard let lastNumberOfCardGroup = cardGroups[index].cards.last else {fatalError("cardGroup에 숫자가 없어요")}
        
        if self.cardNumber < lastNumberOfCardGroup {
            cardGroupAppending?.appendCards(newValue: self.cardNumber)
            guard let aCardGroup = cardGroupAppending else {fatalError("cardGroupAppending이 nil입니다.")}
            cardGroups[index] = aCardGroup
        } else {
            guard let count = cardGroupAppending?.cards.count else {fatalError("cardGroupAppending이 이상합니다.")}
            self.updatePenalty(newValue: count)
            cardGroupAppending?.deActivateThisCardGroup()
            cardGroups[index].deActivateThisCardGroup()
        }
    }
}


struct CardGroup {
    
    let id: Int
    var cards: [Int]
    var isActive: Bool {
        cards.isEmpty ? false : true
    }
    
    var lastCardNumber: Int {
        guard let last = cards.last else {return -1}
        return last
    }
    
    mutating func appendCards(newValue: Int) {
        cards.append(newValue)
    }
    
    mutating func deActivateThisCardGroup() {
        cards = []
    }
}


var cardGroups = [
    CardGroup(id: 10, cards: [10]),
    CardGroup(id: 30, cards: [30]),
    CardGroup(id: 50, cards: [50]),
    CardGroup(id: 80, cards: [80])
]


func play(cardsArr: [Int]) -> [String: Int] {
    
    // 이중배열로 매개변수 분리
    let cardsChunkedByThree = cardsArr.chunked(by: 3)
    
    // 참가자 객체 생성
    var participantA = Participant(name: "A")
    var participantB = Participant(name: "B")
    var participantC = Participant(name: "C")
    
    // 참가자 객체가 1 turn 플레이 하는 것을 반복함
    for cards in cardsChunkedByThree {
        
        // 종료 조건: 구현해야 함
        
        // 참가자가 각자 내놓은 카드 숫자를 각 객체에 입력
        participantA.cardNumber = cards[0]
        participantB.cardNumber = cards[1]
        participantC.cardNumber = cards[2]
        
        var participants = [participantA, participantB, participantC]
        // 참가자의 숫자의 크기 순으로 participant 인스턴스의 속성(priority) 업데이트(함수)
        assignPrioritiesToParticipants(byCardNumber: &participants)
        
        // participants를 priority 순으로 배열 만들기
        participants.sort { $0.priority < $1.priority }
        
        for participant in participants {
            var person = participant
            if let shortestDistanceIndex = person.decideCardGroup(from: cardGroups) {
                person.applyToCardGroup(index: shortestDistanceIndex, cardGroups: &cardGroups)
            }
        }
    }
    return [participantA.name: participantA.penalty, participantB.name: participantB.penalty, participantC.name: participantC.penalty]
}

print(play(cardsArr: [21, 9, 4]))
      
