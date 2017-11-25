//
//  CustomTabBarController.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    var lastTab: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.hexStringToUIColor(hex: "11A791")
        self.tabBar.barTintColor = .white
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.clipsToBounds = true
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag != 2{
            lastTab = item.tag
        }
    }
}

