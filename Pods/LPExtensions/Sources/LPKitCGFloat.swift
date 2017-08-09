//
//  LPKitCGFloat.swift
//  LPExtensions
//
//  Created by Han Shuai on 17/3/7.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit


public extension CGFloat {
    func aline() -> CGFloat {
        let unit = 1.0 / UIScreen.main.scale
        let remain = fmod(self, unit)
        return self - remain + (remain >= unit/2 ? unit: 0)
    }
}

public extension CGFloat {
    static var screenWidth: CGFloat { return UIScreen.main.bounds.size.width }
    static var screenHeight: CGFloat { return UIScreen.main.bounds.size.height }
}
