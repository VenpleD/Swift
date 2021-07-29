//
//  ViewController.swift
//  PlayingCard
//
//  Created by duanwenpu on 2021/7/29.
//

import UIKit



class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
        // Do any additional setup after loading the view.
    }


}

