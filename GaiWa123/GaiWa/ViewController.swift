//
//  ViewController.swift
//  GaiWa
//
//  Created by duanwenpu on 2022/3/4.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubViewController()
        // Do any additional setup after loading the view.
    }
    func initSubViewController() {
        
        let tabbarController = UITabBarController.init()
        tabbarController.view.frame = self.view.bounds
        self.addChild(tabbarController)
        self.view.addSubview(tabbarController.view)
        tabbarController.didMove(toParent: self)
        
        let addNav = UINavigationController.init(rootViewController: GWHomeAddViewController.init())
        addNav.tabBarItem = UITabBarItem.init(title: "hello", image: UIImage.init(systemName: "plus.circle"), selectedImage: UIImage.init(systemName: "plus.circle.fill"))
        tabbarController.tabBar.backgroundColor = UIColor.red
        tabbarController.viewControllers = [addNav]

    }

}

