//
//  ViewController.swift
//  Concentration
//
//  Created by duanwenpu on 2021/7/2.
//

import UIKit

enum FastFoodMenuItem {
    case hamburger(numberOfPatties: Int)
    case fries(size: FryOrderSize)
    case drink(String, ounces: Int)
    case cookie
    func isIncludedInSpecialOrder(number: Int) -> Bool {
        switch self {
            case .hamburger(let pattyCount): return pattyCount == number
            case .fries, .cookie: return true
            case .drink(_, let ounces): return ounces == 16
        }
    }
    var calories: Int {
        return 1-2
    }
    mutating func switchToBeingACookie() {
        self = .hamburger(numberOfPatties: 20)
    }
}

enum FryOrderSize {
    case large
    case small
}

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    private var numberOfPairsOfCards: Int {
        return (CardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateViewConstraints()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.orange,
            .strokeWidth: 5.0
        ]
        flipCountLabel.attributedText = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
    }
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private var CardButtons: [UIButton]!
//    var emojiChoices = ["🐶", "🐹", "🐶", "🐹"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        testEnum()
//        testOptionals()
        // Do any additional setup after loading the view.
    }
    /// 声明属性闭包
    typealias closure = (String)->Void;
    var someProperty: ((String)->Void)?
    
    func testOptionals() -> Void {
        var hello: String?
        hello = "nihao"
        print(hello!)
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = CardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        

    }
    
    private func updateViewFromModel() -> Void {
        for index in CardButtons.indices {
            let button = CardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? UIColor.clear : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private func flipCard(withEmoji emoji:String, on button:UIButton) -> Void {
        print("flipCard(withEmoji : \(emoji)")
        if button.currentTitle == emoji {

        } else {

        }
    }
//    private var emojiChoices = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐼"]
    private var emojiChoices = "🐶🐱🐭🐹🐰🦊🐼"
    private var emoji = [Card:String]() // Dictionary<Int, String>()
    
    private func emoji(for card:Card) -> String {
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        } else {
//            return "?"
//        }
//        if emoji[card.identifier] == nil {
//            if emojiChoices.count > 0 {
//                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
//                emoji[card.identifier] = emojiChoices[randomIndex]
//            }
//        }
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomIndex))
        }
        return emoji[card] ?? "?"
    }
    
    private func test() -> Void {
        
    }

    
}

extension Int {
    var arc4random:Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

