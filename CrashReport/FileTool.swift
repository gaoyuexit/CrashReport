//
//  FileTool.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/8.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation

class FileTool {

    /// 创建目录
    static func creatDirectory(path: String) {
        if FileManager.default.fileExists(atPath: path) { return }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            print("creatDirectory success: \(path)")
        }catch {
            assertionFailure("creatDirectory fail, error: \(error)")
        }
    }
    
    /// 获取目录下所有的文件的路径
    static func allFiles(in directory: String) -> [String]? {
        guard directory.isDirectory else { return nil }
        do {
            let subPaths = try FileManager.default.subpathsOfDirectory(atPath: directory)
            return subPaths.filter{ !$0.hasPrefix(".") }.map{ directory + "/" + $0 }
        } catch {
            return nil
        }
    }
    
    /// 移除该路径下的文件
    static func remove(at path: String) {
        try? FileManager.default.removeItem(atPath: path)
    }
}


