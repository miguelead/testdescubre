//
//  CustomTabBarController.swift
//  testdescubre
//
//  Created by Momentum Lab 2 on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class CustomTabBarController: RAMAnimatedTabBarController {

    var lastTab: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag != 2{
            lastTab = item.tag
        }
    }
}

