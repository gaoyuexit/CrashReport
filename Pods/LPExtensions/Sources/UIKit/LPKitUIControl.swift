//
//  LPKitUIControl.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/8.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import UIKit

var keyHitThstEdgeInsets = "HitTestEdgeInsets"

/// Expand the range of UIButton clicks

extension UIControl {
  
    public var lp_hitEdgeInsets: UIEdgeInsets? {
        get {
            let value = objc_getAssociatedObject(self, &keyHitThstEdgeInsets) as? NSValue
            return value.map { $0.uiEdgeInsetsValue }
        }
        set {
            guard newValue != nil else { return }
            objc_setAssociatedObject(self, &keyHitThstEdgeInsets, NSValue(uiEdgeInsets: newValue!), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.lp_hitEdgeInsets == nil || !self.isEnabled || self.isHidden {
            return super.point(inside: point, with: event)
        }

        let relativeFrame = self.bounds
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.lp_hitEdgeInsets!)
        return hitFrame.contains(point)
    }
}
