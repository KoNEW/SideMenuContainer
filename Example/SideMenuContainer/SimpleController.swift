//
//  SimpleController.swift
//  SideMenuContainer
//
//  Created by VLADIMIR KONEV on 23.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SideMenuContainer

class SimpleController: TableContainer {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let item1 = MenuItem(title: "Controller 1", content: storyboard.instantiateViewControllerWithIdentifier("ViewController1"))
        self.addMenuItem(item1)
        
        let item2 = MenuItem(title: "Controller 2", content: storyboard.instantiateViewControllerWithIdentifier("ViewController2"))
        self.addMenuItem(item2)

        let item3 = MenuItem(title: "Controller 3", content: storyboard.instantiateViewControllerWithIdentifier("ViewController3"))
        self.addMenuItem(item3)
        
        let item4 = MenuItem(title: "Controller 4",
            content: UIViewController(),
            badgeValue: 10,
            icon: UIImage(named: "icon_settings"))
        self.addMenuItem(item4)
    }
}
