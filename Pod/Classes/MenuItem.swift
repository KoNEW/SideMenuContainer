//
//  MenuItem.swift
//  Sweedate
//
//  Created by VLADIMIR KONEV on 29.01.16.
//  Copyright © 2016 Sweedate. All rights reserved.
//

import UIKit

/**
 Side menu item.
*/
public class MenuItem{
    // MARK: Properties

    /// Title of menu item
    public var title: String?
    
    /// Badge value of menu item
    public var badgeValue: Int
    
    /// Icon of menu item
    public var icon: UIImage?
    
    public var segueIdentifier: String?
    public var content: UIViewController?
    
    private init(title: String, badgeValue: Int = 0, icon: UIImage? = nil){
        self.title = title
        self.badgeValue = badgeValue
        self.icon = icon
    }
    
    public convenience init(title: String, segueIdentifier: String, badgeValue: Int = 0, icon: UIImage? = nil){
        self.init(title: title, badgeValue: badgeValue, icon: icon)
        self.segueIdentifier = segueIdentifier
    }
    
    public convenience init(title: String, content: UIViewController, badgeValue: Int = 0, icon: UIImage? = nil){
        self.init(title: title, badgeValue: badgeValue, icon: icon)
        self.content = content
    }
}