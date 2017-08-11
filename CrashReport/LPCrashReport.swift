//
//  LPCrash.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/8.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation
import SwiftyJSON

/*============================  crash handle  ===================================*/

func exceptionHandler(exception: NSException) {
    
    print("----- exceptionHandler ------")
    print(LPCrashReport.crashPath)
    readFromLocal()
    
    let crash = Crash(type: CrashType.exception.rawValue,
                      name: exception.name.rawValue,
                      reason: exception.reason ?? "",
                      callStack: exception.callStackSymbols.joined(separator: "\r"),
                      date: String.since1970)
    writeToLocal(crash)
}

func handleSignal(signal: Int32) {
    
    readFromLocal()
    let crash = Crash(type: CrashType.signal.rawValue,
                      name: signal.signalName,
                      reason: signal.signalName,
                      callStack: Thread.callStackSymbols.joined(separator: "\r"),
                      date: String.since1970)
    writeToLocal(crash)
}

func writeToLocal(_ crash: Crash?) {
    //如果一打开就崩溃了, 启动时间和终止时间相同
    if LPCrashReport.time.start == nil { LPCrashReport.time.start = String.since1970 }
    LPCrashReport.time.end = String.since1970
    let report = Report(appInfo: AppInfo(), crash: crash, time: LPCrashReport.time, warnings: LPCrashReport.warnings)
    LPCrashReport.reports.add(report.decode())
    LPCrashReport.reports.write(toFile: LPCrashReport.crashPath, atomically: true)
    
    LPCrashReport.reports = NSMutableArray()
    LPCrashReport.time = Time()
    LPCrashReport.warnings.removeAll()
}

func readFromLocal() {
    if let array = NSMutableArray(contentsOfFile: LPCrashReport.crashPath) {
        LPCrashReport.reports = array
    }
}

/*============================  LPCrashReport  ===================================*/
class LPCrashReport {

    static let shared = LPCrashReport()
    
    static let crashPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/reports.plist"

    static var reports = NSMutableArray()
    static var time = Time()
    static var warnings = [MemoryWarning]()
    
    private init() {
        registerCrash()
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMemoryWarning), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    deinit {
        unregisterCrash()
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerCrash() {
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
    
    func unregisterCrash() {
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
    
    @objc func becomeActive() {
        
        print("----- becomeActive ------")
        print(LPCrashReport.crashPath)
        
        LPCrashReport.time.start = String.since1970
        readFromLocal()
        uploadData()
    }
    
    /// 后台 记录end时间
    @objc func resignActive() {
        print("----- resignActive ------")
        writeToLocal(nil)
    }
    
    /// 接收到内存警告
    @objc func receiveMemoryWarning() {
        let warning = MemoryWarning(date: String.since1970,
                                    totalMemory: UIDevice.current.lp.totalMemory().description,
                                    useMemory: UIDevice.current.lp.userMemory().description)
        LPCrashReport.warnings.append(warning)
    }
    
    /// 上传数据
    func uploadData() {
        guard LPCrashReport.reports.count != 0 else { return }
        
        let json = JSON(LPCrashReport.reports)
        let param = ["data": json.rawString() ?? ""]
        
        Network.shared.request(method: .POST, urlStr: "http://120.92.117.234:80/api/v1/upload", parameter: param, success: { (result) in
            
            guard UIApplication.shared.applicationState == .background,
                  let last = LPCrashReport.reports.lastObject as? NSDictionary else{
                LPCrashReport.reports.removeAllObjects()
                return
            }
            LPCrashReport.reports.removeAllObjects()
            LPCrashReport.reports.add(last)
            LPCrashReport.reports.write(toFile: LPCrashReport.crashPath, atomically: true)
            
        }) { (result) in
            print(result.error ?? "")
        }
    }
    
}

