//
//  UINavigationBarBottomHairline.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/10.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import UIKit

public extension TypeWrapperProtocol where WrappedType == UINavigationBar {
    var bottomHairline: UIImageView? { return findHairlineImageViewUnder(view: wrappedValue) }
    
    private func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self) && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for sub in view.subviews {
            if let imageView =  findHairlineImageViewUnder(view: sub) {
                return imageView
            }
        }
        return nil
    }
}
