//
//  Extensions.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/8.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation

extension Int32 {
    var signalName: String {
        switch self {
        case SIGABRT:
            return "SIGABRT"
        case SIGILL:
            return "SIGILL"
        case SIGSEGV:
            return "SIGSEGV"
        case SIGFPE:
            return "SIGFPE"
        case SIGBUS:
            return "SIGBUS"
        case SIGPIPE:
            return "SIGPIPE"
        case SIGSYS:
            return "SIGSYS"
        case SIGTRAP:
            return "SIGTRAP"
        default:
            return "OTHER"
        }
    }
}

extension String {
    
    var isDirectory: Bool {
        var isDir: ObjCBool = ObjCBool(false)
        let exist: Bool = FileManager.default.fileExists(atPath: self, isDirectory: &isDir)
        return exist && isDir.boolValue
    }
}

func + <Key: Hashable, Value>(lfs: [Key: Value], rfs: [Key: Value]) -> [Key: Value] {
    var temp = lfs
    rfs.forEach{ key, value in temp[key] = value }
    return temp
}

extension NSNumber {
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}












