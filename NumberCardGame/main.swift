
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

func ifCardNumberIsBiggerThanCardGroupAppending() {
    
}


struct Participant {
    
    let name: String
    var cardNumber: Int = 0
    var priority: Int = 0
    var distance: Int = NUMBERS[99]
    var cardGroupAppending: CardGroup?
    var cardGroup: CardGroup?
    var penalty: Int = 0
    
    static var countOfInitializing = 0  // 참가자 객체가 몇번 생성되었나
    
    init() {
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
    
    mutating func comapare(pariticant: Participant, cardGroups: [CardGroup?]) {
        
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
            let indices = FindIndicesOfMinValues(from: distances)  // 최소값 인덱스들 배열
            minDistanceCardGroupIndex = indices.sorted {         // 최소값 중에서 cardGroups의 마지막 요소가 가장 큰 값인 경우의 cardGroups 인덱스
                let lastMin0 = cardGroups[$0]?.cards.last ?? -1
                let lastMin1 = cardGroups[$1]?.cards.last ?? -1
                return lastMin0 < lastMin1
            }.last
        } else {
            minDistanceCardGroupIndex = distances.enumerated().compactMap({ index, distance in
                (distance == minDistance) ? index : nil
            }).last
        }
        
        guard let minDistanceCardGroupIdx = minDistanceCardGroupIndex else { fatalError("최소값 카드 그룹 인덱스가 사라졌어요.")}
        distance = minDistance
        cardGroupAppending = cardGroups[minDistanceCardGroupIdx] // 속성 업데이트
        
        /*
        // B조건: 이것은 play()에서 해결해야 할 듯

        // 해당 참가자 객체의 저장된 배열(주어진 배열과 동일)의 마지막 요소 숫자가 참가자가 제시한 숫자보다
        //   가) 크면: 해당 참가자 객체의 저장된 배열에 참가자가 제시한 숫자를 append 한다
        //   나) 작으면: 해당 참가자 객체의 저장된 배열의 크기(size)를 참가자 객체 속성인 panalty에 담고 그 객체에 저장된 배열을 비우고, 주어진 배열에서 해당 배열(value)과 key 값을 제거한다.
        
        guard let cardGroupAppendingLastNumber = self.cardGroupAppending?.cards.last else {fatalError("cardGroupAppending속성이 없어요")}
        
        if self.cardNumber < cardGroupAppendingLastNumber {
            
        }
        */

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

let NUMBERS = Array(1...100)
var cardGroups = [
    CardGroup(id: 10, cards: [10]),
    CardGroup(id: 30, cards: [30]),
    CardGroup(id: 50, cards: [50]),
    CardGroup(id: 80, cards: [80])
]







func play(cardsArr: [Int]) -> [String: Int] {
    
    let cardsChunkedByThree = cardsArr.chunked(by: 3)
    
    var participants: [Participant] = [
        Participant(name: "A"),
        Participant(name: "B"),
        Participant(name: "C")
    ]
    
    for cards in cardsChunkedByThree {
        participants[0].cardNumber = cards[0]
        participants[1].cardNumber = cards[1]
        participants[2].cardNumber = cards[2]
        
        guard let cardNumMin = cards.min(by: { $0 < $1 }),
              let cardNumMax = cards.max(by: {$0 < $1}) else {fatalError("매개변수 문제발생")}
        
        let cardNumMiddle = cards.filter({$0 != cardNumMin && $0 != cardNumMax})[0]
        
        participants = participants.map { participant in
            var person = participant
            switch participant.cardNumber {
            case cardNumMin: person.updatePriority(newValue: 1)
            case cardNumMiddle: person.updatePriority(newValue: 2)
            case cardNumMax: person.updatePriority(newValue: 3)
            default: fatalError("에러입니다.")
            }
            return person
        }
        let participantsDict = [
            participants[0].priority: participants[0],
            participants[1].priority: participants[1],
            participants[2].priority: participants[2]
        ]
        
        // 두 배열의 숫자 대조
        for i in 1...3 {
            guard var partaker = participantsDict[i] else {fatalError("참가자 배열을 확인하세요.")}
            
            var idx = 0
            
            for j in 0...2 {
                if (participants[j].name == partaker.name) {
                    idx = j
                }
            }
            
            
            var distance = 0
            
            print("참여자: \(partaker)")
            for (key, arr) in cardNumDicts {
                
                var value = arr
                guard let lastElem = value.last else {fatalError("\(value)")}
                guard let cardNumDict = cardNumDicts[key] else {fatalError("cardNumDicts를 확인하세요")}
                distance = lastElem - partaker.cardNumber
                
                partaker.updateArrayIndex(newValue: key)
                
                // 배열 마지막 요소와 가장 가까운 배열에 숫자 append
                if distance < partaker.distance {
                    partaker.updateDistance(newValue: distance)
                    
                    if value.count > cardNumDict.count {
                        value[value.count - 1] = partaker.cardNumber
                    } else if value.count == cardNumDict.count {
                        value.append(partaker.cardNumber)
                    }
                    
                    partaker.updateArrayBelongsTo(newValue: value)
                }
                print("최종 배열과 비교후 partaker: \(partaker)")
            }
            if partaker.arrayBelongTo[partaker.arrayBelongTo.count - 1] > partaker.arrayBelongTo[partaker.arrayBelongTo.count - 2] {
                partaker.updatePenalty(newValue: partaker.arrayBelongTo.count - 1)
                cardNumDicts.removeValue(forKey: partaker.arrayBelongTo[0])
                partaker.arrayBelongTo = []
                print("베열 제거: \(cardNumDicts)")
                print("속성값 제거: \(partaker)")
            } else {
                cardNumDicts[partaker.arrayBelongTo[0]] = partaker.arrayBelongTo
                print("참가자 카드와 비교 후 cardNumDicts \(cardNumDicts)")
            }
            participants[idx] = partaker
            print(participants)
        }
        
        
        if cardNumDicts.isEmpty {
            var result: [String: Int] = [:]
            
            participants.forEach { participant in
                result[participant.name] = participant.penalty
            }
            print(result)
            return result
        }
    }
    
    for participant in participants {
        print(participant)
    }
    
    var result: [String: Int] = [:]
    
    participants.forEach { participant in
        result[participant.name] = participant.penalty
    }
    print(result)
    return result
}
play(cardsArr: [55,8,29,13,7,61])
