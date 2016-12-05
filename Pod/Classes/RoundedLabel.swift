//
//  RoundeLabel.swift
//  Sweedate
//
//  Created by VLADIMIR KONEV on 02.12.15.
//  Copyright © 2015 Sweedate. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundedLabel : UILabel {
    
    private var textInsets: UIEdgeInsets {
        let offset = self.font.pointSize / 2
        return  UIEdgeInsets(top: 0.0, left: offset, bottom: 0.0, right: offset)
    }
    
    override public func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = textInsets.apply(bounds)
        rect = super.textRectForBounds(rect, limitedToNumberOfLines: numberOfLines)
        return textInsets.inverse.apply(rect)
    }
    
    override public func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(textInsets.apply(rect))
    }
    
    override public func drawRect(rect: CGRect) {
        let minSide = min(self.frame.height, self.frame.width)
        self.layer.cornerRadius = minSide / 2
        self.layer.masksToBounds = true
        super.drawRect(rect)
    }
}

extension UIEdgeInsets {
    var inverse: UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
    func apply(rect: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(rect, self)
    }
}
