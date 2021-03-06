//
//  Concentration.swift
//  Concentration
//
//  Created by duanwenpu on 2021/7/6.
//

import Foundation
import UIKit

protocol Moveable {
    func move(to point: CGPoint) -> Void
}

class Car: Moveable {
    func move(to point: CGPoint) {
        
    }
    func changeOil() -> Void {
        
    }
}

struct Shape: Moveable {
    func move(to point: CGPoint) {
        
    }
    func draw() -> Void {
        
    }
}

struct Concentration
{
    /// 在结构体中，这个cards对外是只读的，对内是可写的
    var cards = [Card]()
    
    /// 这个变量，是因为有set和get方法，所以系统知道他是可变的，不需要加mutating
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) -> Void {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
//                for flipDwonIndex in cards.indices {
//                    cards[flipDwonIndex].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }

    }
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
