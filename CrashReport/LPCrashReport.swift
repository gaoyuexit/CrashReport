//
//  LPCrash.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/8.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation

/*============================  crash handle  ===================================*/

func exceptionHandler(exception: NSException) {
    
    let crash = Crash(type: CrashType.exception.rawValue,
                      name: exception.name.rawValue,
                      reason: exception.reason ?? "",
                      appInfo: AppInfo().description,
                      callStack: exception.callStackSymbols.joined(separator: "\r"),
                      date: Date().formatTimeYMDHMS())
    let dict = crash.encode()
    dict.write(toFile: LPCrashReport.crashPath + "/" + crash.date + ".plist", atomically: true)
}

func handleSignal(signal: Int32) {
    
    let crash = Crash(type: CrashType.signal.rawValue,
                      name: signal.signalName,
                      reason: signal.signalName,
                      appInfo: AppInfo().description,
                      callStack: Thread.callStackSymbols.joined(separator: "\r"),
                      date: Date().formatTimeYMDHMS())
    let dict = crash.encode()
    dict.write(toFile: LPCrashReport.crashPath + "/" + crash.date + ".plist", atomically: true)
}


/*============================  LPCrashReport  ===================================*/
class LPCrashReport {
    
    static let crashPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Crash"

    init() {
        FileTool.creatDirectory(path: LPCrashReport.crashPath)
        register()
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        unregister()
        NotificationCenter.default.removeObserver(self)
    }
    
    func register() {
        NSSetUncaughtExceptionHandler(exceptionHandler)
        signal(SIGILL, handleSignal)
        signal(SIGABRT, handleSignal)
        signal(SIGFPE, handleSignal)
        signal(SIGBUS, handleSignal)
        signal(SIGSEGV, handleSignal)
        signal(SIGSYS, handleSignal)
        signal(SIGPIPE, handleSignal)
        signal(SIGTRAP, handleSignal)
    }
    
    func unregister() {
        NSSetUncaughtExceptionHandler(nil)
        signal(SIGILL, SIG_DFL)
        signal(SIGABRT, SIG_DFL)
        signal(SIGFPE, SIG_DFL)
        signal(SIGBUS, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGSYS, SIG_DFL)
        signal(SIGPIPE, SIG_DFL)
        signal(SIGTRAP, SIG_DFL)
    }
    
    @objc func enterForeground() {
        guard let subPaths = FileTool.allFiles(in: LPCrashReport.crashPath) else { return }
        // 遍历子路径发送请求, 成功后删除
        for subPath in subPaths {
            guard let nsDict = NSDictionary(contentsOfFile: subPath),
                  let dict = nsDict as? Dictionary<String, String>,
                  let crash = Crash(decode: dict) else { continue }
            Network.shared.request(method: .GET, urlStr: "https://www.baidu.com", success: { (result) in
                print(result.response)
                FileTool.remove(at: subPath)
            }, fail: { (result) in
                print(result.response)
            })
        }
    }
    
}

