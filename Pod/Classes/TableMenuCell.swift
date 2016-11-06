//
//  TableMenuCell.swift
//  Sweedate
//
//  Created by VLADIMIR KONEV on 13.12.15.
//  Copyright © 2015 Sweedate. All rights reserved.
//

import UIKit
import Cartography

public class TableMenuCell: UITableViewCell{
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var badgeLabel: RoundedLabel!
    
    private func construct(){
        if iconView != nil && itemLabel != nil && badgeLabel != nil{
            // Interface already created - probably via interface builder
            return
        }
        
        // Create icon
        iconView = UIImageView(frame: CGRectZero)
        contentView.addSubview(iconView)
        
        itemLabel = UILabel(frame: CGRectZero)
        contentView.addSubview(itemLabel)
        
        badgeLabel = RoundedLabel(frame: CGRectZero)
        badgeLabel.backgroundColor = UIColor.blueColor()
        badgeLabel.textAlignment = .Center
        badgeLabel.textColor = UIColor.whiteColor()
        badgeLabel.backgroundColor = UIColor.redColor()
        contentView.addSubview(badgeLabel)
        
        constrain(iconView, itemLabel, badgeLabel, contentView){
            iconView, itemLabel, badgeLabel, contentView in
            
            // Icon position and size
            iconView.width == 20.0
            iconView.height == 20.0
            iconView.left == contentView.left + 10.0
            iconView.centerY == contentView.centerY
            
            // Badge position and size
            badgeLabel.height == 20.0
            badgeLabel.right == contentView.right - 10.0
            badgeLabel.centerY == contentView.centerY
            
            // Title between icon and badge
            itemLabel.left == iconView.right + 10.0
            itemLabel.right == badgeLabel.left - 10.0
            itemLabel.centerY == contentView.centerY
        }
        
        // Priorities
        itemLabel.setContentHuggingPriority(badgeLabel.contentHuggingPriorityForAxis(.Horizontal) - 1, forAxis: .Horizontal)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.construct()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.construct()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var badgeValue: Int?{
        get {
            guard let text = badgeLabel.text else{
                return nil
            }
            return Int(text)
        }
        set{
            //TODO: In production change condition to > 0
            guard let value = newValue where value != 0 else{
                badgeLabel.text = ""
                badgeLabel.hidden = true
                return
            }
            badgeLabel.hidden = false
            badgeLabel.text = String(value)
        }
    }
    
    public var item: MenuItem? = nil{
        didSet{
            iconView.image = item?.icon
            itemLabel.text = item?.title
            badgeValue = item?.badgeValue
        }
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        let badgeColor = badgeLabel.backgroundColor
        super.setSelected(selected, animated: true)
        badgeLabel.backgroundColor = badgeColor
    }
}