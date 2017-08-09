//
//  LPKitUIView.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/9.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import UIKit

public enum LPCornerType {
    case top,bottom,none,all
}

extension UIView: NamespaceWrappable {}

public extension TypeWrapperProtocol where WrappedType: UIView {
    
    func drawCorner(type: LPCornerType, radius size: CGSize = CGSize(width: 4,height: 4)) {
        switch type {
        case .top:
            drawCorner([.topLeft, .topRight], radius: size)
        case .bottom:
            drawCorner([.bottomLeft, .bottomRight], radius: size)
        case .all:
            drawCorner(radius: size)
        case .none:
            drawCorner([], radius: size)
        }
    }
    
    /// Round corners
    func drawCorner(_ corners: UIRectCorner = UIRectCorner.allCorners, radius size: CGSize) {
        guard !corners.isEmpty else {
            wrappedValue.layer.mask = nil
            return
        }
        
        let maskPath = UIBezierPath(roundedRect: wrappedValue.bounds, byRoundingCorners: corners, cornerRadii: size)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = wrappedValue.bounds
        maskLayer.path = maskPath.cgPath
        
        wrappedValue.layer.mask = maskLayer
    }
    
    /// Animation
    func shake() {
        let shake = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0)), NSValue(caTransform3D: CATransform3DMakeTranslation(5, 0, 0))]
        
        shake.autoreverses = true
        shake.repeatCount = 2.0
        shake.duration = 0.07
        
        wrappedValue.layer.add(shake, forKey: nil)
    }
    
    func spring(time: Double, scale: CGFloat = 1) {
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.values = [1, 1.1, 0.96, 1.03, 0.985, 1.007, 1].map { $0 == 1 ? $0 : $0 * scale }
        scaleAnimation.duration = time
        let keyTime = time / 6
        var times: [NSNumber] = []
        for i in 0...6 {
            times.append(NSNumber(value: keyTime * Double(i)))
        }
        scaleAnimation.keyTimes = times
        scaleAnimation.calculationMode = kCAAnimationCubic
        wrappedValue.layer.add(scaleAnimation, forKey: nil)
    }
}
