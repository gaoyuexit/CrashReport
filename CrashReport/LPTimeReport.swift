//
//  LPTimeReport.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/8.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation
import LPExtensions

class LPTimeReport {
    
    
    static let timePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Time"
    
    private var timeModel: Time?
    
    init() {
        FileTool.creatDirectory(path: LPTimeReport.timePath)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMemoryWarning), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 前台 记录start时间
    @objc func becomeActive() {
        timeModel = Time()
        timeModel?.start = Date().formatTimeYMDHMS()
        /// 遍历plist
        guard let subPaths = FileTool.allFiles(in: LPTimeReport.timePath) else { return }
        for subPath in subPaths {
            // 发送网络请求
            guard let nsDict = NSDictionary(contentsOfFile: subPath),
                let dict = nsDict as? Dictionary<String, String> else { continue }
                let model = Time(decode: dict)
                print(model.encode())
            // 成功后移除subpath
            
            
        }
    }
    
    /// 后台 记录end时间
    @objc func resignActive() {
        
        if timeModel == nil { return }
        
        timeModel!.end = Date().formatTimeYMDHMS()
        // 写入path
        timeModel!.encode().write(toFile: LPTimeReport.timePath + "/" + timeModel!.end! + ".plist", atomically: true)
        // 置空
        timeModel = nil
        print(LPTimeReport.timePath)
    }
    
    /// 只接受前台的内存警告
    @objc func receiveMemoryWarning() {
        let warning = MemoryWarning(date: Date().formatTimeYMDHMS(),
                                    totalMemory: UIDevice.current.lp.totalMemory().description,
                                    useMemory: UIDevice.current.lp.userMemory().description)
        timeModel?.warning = warning
    }
}
