//
//  Card.swift
//  Concentration
//
//  Created by duanwenpu on 2021/7/6.
//

import Foundation

struct Card: Hashable
{
    func hash(into hasher: inout Hasher) {
        var temp: Hasher = Hasher.init()
        temp.combine(self.identifier)
        hasher = temp
//        hasher = self.identifier
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
