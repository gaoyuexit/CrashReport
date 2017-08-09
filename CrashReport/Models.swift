//
//  Models.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/8.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation
import LPExtensions

struct AppInfo: CustomStringConvertible {
    var version = String.projectVersion //eg: 2.0.0
    var deviceID = UIDevice.current.identifierForVendor!.uuidString
    var platform = UIDevice.current.lp.platformString() //eg: iphone 7plus
    var system = UIDevice.current.systemName + UIDevice.current.systemVersion //eg: iOS10.2.1
    var appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") ?? ""
    
    var description: String {
        return "app: \(appName)\n" + "version: \(version)\n" + "deviceID: \(deviceID)\n" + "platform: \(platform)\n" + "system: \(system)"
    }
}

enum CrashType: String {
    case signal = "Signal"
    case exception = "Exception"
}


struct Report {
    let crash: Crash?
    let Time: Time
    let warning: [MemoryWarning]?
}

struct Crash {
    let type: String
    let name: String
    let reason: String
    let appInfo: String
    let callStack: String
    let date: String
    
    init(type: String, name: String, reason: String, appInfo: String, callStack: String, date: String) {
        self.type = type
        self.name = name
        self.reason = reason
        self.appInfo = appInfo
        self.callStack = callStack
        self.date = date
    }
    
    func encode() -> NSDictionary {
        return ["type": type, "name": name, "reason": reason, "date": date, "appInfo": appInfo, "callStack": callStack]
    }
    
    init?(decode: Dictionary<String, String>) {
        guard let type = decode["type"],
              let name = decode["name"],
              let reason = decode["reason"],
              let appInfo = decode["appInfo"],
              let callStack = decode["callStack"],
              let date = decode["date"] else { return nil }
        self.init(type: type, name: name, reason: reason, appInfo: appInfo, callStack: callStack, date: date)
    }
}

struct Time {
    var start: String?
    var end: String?
    var warning: MemoryWarning?
    
    init(start: String? = nil, end: String? = nil, warning: MemoryWarning? = nil) {
        self.start = start
        self.end = end
        self.warning = warning
    }
    
    func encode() -> NSDictionary {
        let timeDict = ["start": start ?? "", "end": end ?? ""]
        guard let warning = warning else { return timeDict as NSDictionary }
        let warnDict = warning.encode()
        return (timeDict + warnDict) as NSDictionary
    }
    
    init(decode: Dictionary<String, String>) {
        self.init(start: decode["start"], end: decode["end"], warning: MemoryWarning(decode: decode))
    }
    
}

struct MemoryWarning {
    var date: String
    var totalMemory: String
    var useMemory: String
    
    init(date: String, totalMemory: String, useMemory: String) {
        self.date = date
        self.totalMemory = totalMemory
        self.useMemory = useMemory
    }
    
    func encode() -> [String: String] {
        return ["date": date, "totalMemory": totalMemory, "useMemory": useMemory]
    }
    
    init?(decode: Dictionary<String, String>) {
        guard let date = decode["date"],
              let totalMemory = decode["totalMemory"],
              let useMemory = decode["useMemory"] else { return nil }
        self.init(date: date, totalMemory: totalMemory, useMemory: useMemory)
    }
}









