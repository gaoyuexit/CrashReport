//
//  LPCrashReport.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/7.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation


class LPReport {
    
    static let shared = LPReport()
    
    private var crashReport = LPCrashReport()
    private var timeReport = LPTimeReport()
    
    private init() {
        
    }
}










