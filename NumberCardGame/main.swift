
import Foundation

struct NumArr {
    let keyNum: Int
    var mutatingArr: [Int]
}

struct Participant {
    let name: String
    let cardDistributed: [Int]? = nil
    var cardDisposed: Int
    var panalties: Int = 0
    var arrayOfYours: NumArr? = nil
    
    mutating func updateArrayOfYours(newValue: NumArr?) {
        arrayOfYours = newValue
    }
}

func play(cardsFromParticipant: [Int]) -> [String: Int] {
    
    // 게임 설정
    let participantA = Participant(name: "A", cardDisposed: cardsFromParticipant[0])
    let participantB = Participant(name: "B", cardDisposed: cardsFromParticipant[1])
    let participantC = Participant(name: "C", cardDisposed: cardsFromParticipant[2])
    
    var numbers10 = NumArr(keyNum: 10, mutatingArr: [10])
    var numbers30 = NumArr(keyNum: 30, mutatingArr: [30])
    var numbers50 = NumArr(keyNum: 50, mutatingArr: [50])
    var numbers80 = NumArr(keyNum: 80, mutatingArr: [80])
    
    let arrangedParticipants: [Participant] = [participantA, participantB, participantC].sorted {
        $0.cardDisposed < $1.cardDisposed
    }
    let numArrs: [NumArr] = [numbers10, numbers30, numbers50, numbers80]
    
    // 게임 연산
    
    for personStruct in arrangedParticipants {
        // 각 참가자의 제시한 숫자와 주어진 배열의 마지막 요소와의 차이
        var person = personStruct
        var minNum = 100
        for numStruct in numArrs {
            let distance = abs(numStruct.keyNum - personStruct.cardDisposed)
            if distance < minNum {
                minNum = distance
                person.updateArrayOfYours(newValue: numStruct)
            }
        }
        
        
    }
}
