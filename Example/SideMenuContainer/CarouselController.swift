//
//  CarouselController.swift
//  SideMenuContainer
//
//  Created by VLADIMIR KONEV on 23.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SideMenuContainer
import iCarousel
import Cartography

class CarouselController: AbstractContainer {
    @IBOutlet weak var carousel: iCarousel!
    override func viewDidLoad() {
        toggleAnimationType = .SlideAbove
        toggleOffsetConstant = 250.0
        super.viewDidLoad()
        
        carousel.type = iCarouselType.CoverFlow2
        
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
    
    override func addMenuItem(item: MenuItem) {
        super.addMenuItem(item)
        carousel.reloadData()
    }
}

extension CarouselController: iCarouselDataSource{
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return menuItems.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let item = menuItems[index]
        let result = CarouselItemView(frame: carousel.bounds)
        result.imageView.image = item.icon
        result.itemLabel.text = item.title
        return result
    }
}

extension CarouselController: iCarouselDelegate{
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        let item = menuItems[index]
        if let c = item.content{
            self.pushController(c)
        }else if let segue = item.segueIdentifier{
            self.performSegueWithIdentifier(segue, sender: item)
        }
    }
}


class CarouselItemView: UIView{
    private (set) var imageView: UIImageView!
    private (set) var itemLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        construct()
    }
    
    
    private func construct(){
        itemLabel = UILabel()
        itemLabel.numberOfLines = 0
        itemLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(itemLabel)
        
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(imageView)
        
        constrain(itemLabel, imageView, self){
            itemLabel, imageView, container in
            
            itemLabel.left == container.left
            itemLabel.right == container.right
            itemLabel.bottom == container.bottom
            itemLabel.top == imageView.bottom
            
            imageView.left == container.left
            imageView.right == container.right
            imageView.top == container.top
            
        }
    }
}