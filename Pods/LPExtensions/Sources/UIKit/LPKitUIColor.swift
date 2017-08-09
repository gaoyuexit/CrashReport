//
//  LPKitUIColor.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/8.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import UIKit

extension UIColor: NamespaceWrappable {}

public extension TypeWrapperProtocol where WrappedType == UIColor {
    static func colorFrom(RGB: Int) -> UIColor {
        let red = CGFloat((RGB & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((RGB & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(RGB & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func colorFrom(ARGB: Int64) -> UIColor {
        let alpha = CGFloat((ARGB & 0xFF000000) >> 24) / 255.0
        let red = CGFloat((ARGB & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((ARGB & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(ARGB & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
