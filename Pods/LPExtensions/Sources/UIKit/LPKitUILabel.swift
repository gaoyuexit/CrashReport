//
//  LPKitUILabel.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/9.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import UIKit

public extension TypeWrapperProtocol where WrappedType == UILabel {
    // Calculate the UILabel height
    func contentSize() -> CGSize? {
        if wrappedValue.attributedText != nil {
            let attributedContentSize = wrappedValue.attributedText?.boundingRect(with: wrappedValue.frame.size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
            return attributedContentSize
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = wrappedValue.lineBreakMode
        paragraphStyle.alignment = wrappedValue.textAlignment
        
        let attributes = [NSFontAttributeName: wrappedValue.font, NSParagraphStyleAttributeName: paragraphStyle] as [String : Any]
        
        let contentSize = wrappedValue.text?.boundingRect(with: wrappedValue.frame.size, options:[.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
        
        return contentSize
    }
}
