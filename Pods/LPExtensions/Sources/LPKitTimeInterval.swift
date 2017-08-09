//
//  LPKitTimeInterval.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/12/6.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import Foundation

public extension TimeInterval {
    
    func formatTime(format: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        return date.formatTime(format: format)
    }
}

