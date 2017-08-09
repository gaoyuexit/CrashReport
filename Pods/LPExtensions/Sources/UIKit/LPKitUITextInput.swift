//
//  LPKitUITextInput.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/21.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import Foundation

public extension UITextInput {
    
    @discardableResult
    func isOutnumber(limit: Int, cut: Bool = true) -> Bool {
        var isOutNumber = false
        
        let noneSelect = markedTextRange?.isEmpty ?? true
        
        guard limit != 0 && noneSelect,
            let textRange = textRange(from: beginningOfDocument, to: endOfDocument),
            let unicodes = text(in: textRange)?.unicodeScalars else { return isOutNumber }
        
        var ascii: Int = 0//ASCII
        var noAscii: Int = 0//汉字，表情
        
        unicodes.forEach {
            if $0.isASCII { ascii += 1 }
            else { noAscii += 1 }
        }
        isOutNumber = ascii + noAscii * 2 > limit
        
        if isOutNumber && cut { deleteBackward() }
        
        return isOutNumber
    }
    
}
