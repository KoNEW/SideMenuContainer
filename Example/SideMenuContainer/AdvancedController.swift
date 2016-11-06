//
//  AdvancedController.swift
//  SideMenuContainer
//
//  Created by VLADIMIR KONEV on 23.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SideMenuContainer

class AdvancedController: TableContainer {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = MenuItem(title: "Controller 1", segueIdentifier: "vcSegue1")
        self.addMenuItem(item1)
        
        let item2 = MenuItem(title: "Controller 2", segueIdentifier: "vcSegue2")
        self.addMenuItem(item2)
        
        let item3 = MenuItem(title: "Controller 3", segueIdentifier: "vcSegue3")
        self.addMenuItem(item3)
        
        let item4 = MenuItem(title: "Controller 4",
            content: UIViewController(),
            badgeValue: 10,
            icon: UIImage(named: "icon_settings"))
        self.addMenuItem(item4)
    }
}
