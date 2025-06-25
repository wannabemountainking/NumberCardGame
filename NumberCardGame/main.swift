
import Foundation


extension Array where Element == Int {
    func chunked(by size: Int) -> [[Int]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0 ..< $0 + size])
        }
    }
}

struct Participant {
    let name: String
    var cardNumber: Int = 0
    var priority: Int = 0
    var distance: Int = NUMBERS[99]
    var arrayBelongTo: [Int] = []
    var arrayIndex: Int = 0
    var penalty: Int = 0
    
    
    mutating func updatePriority(newValue: Int) {
        priority = newValue
    }
    
    mutating func updateDistance(newValue: Int) {
        distance = newValue
    }
    
    mutating func updateArrayBelongsTo(newValue: [Int]) {
        arrayBelongTo = newValue
    }
    
    mutating func updateArrayIndex(newValue: Int) {
        arrayIndex = newValue
    }
    
    mutating func updatePenalty(newValue: Int) {
        penalty += newValue
    }
}

var cardNumDicts: [Int : [Int]] = [10: [10], 30: [30], 50: [50], 80: [80]]

let NUMBERS = Array(1...100)

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
