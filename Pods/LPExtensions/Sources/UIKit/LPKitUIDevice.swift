//
//  LPKitUIDevice.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/8.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import UIKit

public enum UIDevicePlatform: String {
  case unknown = "Unknown iOS device"
  
  case simulator = "Simulator"
  case simulatoriPhone = "iPhone Simulator"
  case simulatoriPad = "iPad Simulator"
  case simulatorAppleTV = "Apple TV Simulator"
  
  case iPhone1G = "iPhone 1G"
  case iPhone3G = "iPhone 3G"
  case iPhone3GS = "iPhone 3GS"
  case iPhone4 = "iPhone 4"
  case iPhone4S = "iPhone 4S"
  case iPhone5 = "iPhone 5"
  case iPhone5S = "iPhone 5S"
  case iPhone5C = "iPhone 5C"
  case iPhone6 = "iPhone 6"
  case iPhone6P = "iPhone 6Plus"
  case iPhone6S = "iPhone 6S"
  case iPhone6SP = "iPhone 6SPlus"
  case iPhoneSE = "iPhone SE"
  case iPhone7 = "iPhone 7"
  case iPhone7P = "iPhone 7Plus"
  
  case iPod1G = "iPod touch 1G"
  case iPod2G = "iPod touch 2G"
  case iPod3G = "iPod touch 3G"
  case iPod4G = "iPod touch 4G"
  case iPod5G = "iPod touch 5G"
  case iPod6G = "iPod touch 6G"
  
  case iPad1G = "iPad 1G"
  case iPad2G = "iPad 2G"
  case iPad3G = "iPad 3G"
  case iPad4G = "iPad 4G"
  case iPadAir = "iPad Air"
  case iPadAir2 = "iPad Air 2"
  case iPadProL = "iPad Pro (12.9 inch)"
  case iPadProS = "iPad Pro (9.7 inch)"
  
  case iPadmini = "iPad mini"
  case iPadmini2 = "iPad mini 2"
  case iPadmini3 = "iPad mini 3"
  case iPadmini4 = "iPad mini 4"
  
  case appleTV2 = "Apple TV 2G"
  case appleTV3 = "Apple TV 3G"
  case appleTV4 = "Apple TV 4G"
  
  case appleWatch = "Apple Watch"
  case appleWatchS1 = "Apple Watch Series 1"
  case appleWatchS2 = "Apple Watch Series 2"
  
  case unknowniPhone = "Unknown iPhone"
  case unknowniPod = "Unknown iPod"
  case unknowniPad = "Unknown iPad"
  case unknownAppleTV = "Unknown Apple TV"
  case iFPGA = "iFPGA"
}

public enum UIDeviceFamily {
  case iPhone, iPod, iPad, appleTV, unknown
}

extension UIDevice: NamespaceWrappable {}

public extension TypeWrapperProtocol where WrappedType == UIDevice {
    
    // MARK: - sysctlbyname utils
    private func getSysInfoByName(typeSpecifier: UnsafeMutablePointer <CChar>) -> String? {
        
        var size:size_t = 0
        sysctlbyname(typeSpecifier,nil , &size, nil, 0)
        
        let answer = malloc(size)
        sysctlbyname(typeSpecifier, answer, &size, nil, 0)
        
        //UnsafeMutableRawPointer UnsafePointer<CChar> 问题
        let opaquePtr = OpaquePointer(answer)
        let answerPtr = UnsafePointer<CChar>(opaquePtr)
        let results = String(cString: answerPtr!, encoding: .utf8)
        
        free(answer)
        return results
    }
    
    public func platform() -> String {
        let name:UnsafeMutablePointer <CChar> = UnsafeMutablePointer <CChar>(mutating: "hw.machine")
        return self.getSysInfoByName(typeSpecifier: name)!
    }
    
    public func hwmodel() -> String {
        let name:UnsafeMutablePointer <CChar> = UnsafeMutablePointer <CChar>(mutating: "hw.model")
        return self.getSysInfoByName(typeSpecifier: name)!
    }
    
    // MARK: - sysctl utils
    private func getSysInfo(typeSpecifier:Int32) -> Int {
        var size = MemoryLayout<Int>.size
        var results: Int = 0
        var mib:[Int32] = [CTL_HW, typeSpecifier]
        sysctl(&mib, 2, &results, &size, nil, 0)
        return results
    }
    
    func cpuFrequency() -> Int {
        return self.getSysInfo(typeSpecifier: HW_CPU_FREQ)
    }
    
    func busFrequency() -> Int {
        return self.getSysInfo(typeSpecifier: HW_BUS_FREQ)
    }
    
    func cpuCount() -> Int {
        return self.getSysInfo(typeSpecifier: HW_NCPU)
    }
    
    func totalMemory() -> Int {
        return self.getSysInfo(typeSpecifier: HW_PHYSMEM)
    }
    
    func userMemory() -> Int {
        return self.getSysInfo(typeSpecifier: HW_USERMEM)
    }
    
    func maxSocketBufferSize() -> Int {
        return self.getSysInfo(typeSpecifier: KIPC_MAXSOCKBUF)
    }
    
    // MARK: - file system -- Thanks Joachim Bean!
    private func diskSpace(key: FileAttributeKey) -> Any? {
        var fattributes:[FileAttributeKey : Any]?
        do {
            fattributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
        } catch {
            print("\(error.localizedDescription)")
        }
        if let fattri = fattributes {
            return fattri[key]
        } else {
            return nil
        }
    }
    
    func totalDiskSpace() -> Any? {
        return diskSpace(key: .systemSize)
    }
    
    func freeDiskSpace() -> Any? {
        return diskSpace(key: .systemFreeSize)
    }
    
    /// Platform type and name utils
    func platformType() -> UIDevicePlatform {
        let platform = self.platform()
        
        // The ever mysterious iFPGA
        if platform == "iFPGA" {
            return .iFPGA
        }
        
        //iPhone
        if platform == "iPhone1,1" {
            return .iPhone1G
        }
        
        if platform == "iPhone1,2" {
            return .iPhone3G
        }
        
        if platform.hasPrefix("iPhone2") {
            return .iPhone3GS
        }
        
        if platform.hasPrefix("iPhone3") {
            return .iPhone4
        }
        
        if platform.hasPrefix("iPhone4") {
            return .iPhone4S
        }
        
        if platform == "iPhone5.1" || platform == "iPhone5,2" {
            return .iPhone5
        }
        
        if platform == "iPhone5,3" || platform == "iPhone5,4" {
            return .iPhone5C
        }
        
        if platform.hasPrefix("iPhone6") {
            return .iPhone5S
        }
        
        if platform == "iPhone7,2" {
            return .iPhone6
        }
        
        if platform == "iPhone7,1" {
            return .iPhone6P
        }
        
        if platform == "iPhone8,1" {
            return .iPhone6S
        }
        
        if platform == "iPhone8,2" {
            return .iPhone6SP
        }
        
        if platform == "iPhone8,4" {
            return .iPhoneSE
        }
        
        if platform == "iPhone9,1" || platform == "iPhone9,3"{
            return .iPhone7
        }
        
        if platform == "iPhone9,2" || platform == "iPhone9,4"{
            return .iPhone7P
        }
        
        // iPod
        if platform.hasPrefix("iPod1") {
            return .iPod1G
        }
        
        if platform.hasPrefix("iPod2") {
            return .iPod2G
        }
        
        if platform.hasPrefix("iPod3") {
            return .iPod3G
        }
        
        if platform.hasPrefix("iPod4") {
            return .iPod4G
        }
        
        if platform.hasPrefix("iPod5") {
            return .iPod5G
        }
        
        if platform.hasPrefix("iPod7") {
            return .iPod6G
        }
        
        //iPad
        if platform.hasPrefix("iPad1") {
            return .iPad1G
        }
        
        if platform == "iPad2,1" || platform == "iPad2,2" || platform == "iPad2,3" || platform == "iPad2,4"{
            return .iPad2G
        }
        
        if platform == "iPad3,1" || platform == "iPad3,2" || platform == "iPad3,3" {
            return .iPad3G
        }
        
        if platform == "iPad3,4" || platform == "iPad3,5" || platform == "iPad3,6"{
            return .iPad4G
        }
        
        if platform == "iPad4" || platform == "iPad4,2" || platform == "iPad4,3" {
            return .iPadAir
        }
        
        if platform == "iPad5,3" || platform == "iPad5,4"{
            return .iPadAir2
        }
        
        if platform == "iPad6,7" || platform == "iPad6,8" {
            return .iPadProL
        }
        
        if platform == "iPad6,3" || platform == "iPad6,4" {
            return .iPadProS
        }
        
        if platform == "iPad2,5" || platform == "iPad2,6" || platform == "iPad2,7" {
            return .iPadmini
        }
        
        if platform == "iPad4,4" || platform == "iPad4,5" || platform == "iPad4,6" {
            return .iPadmini2
        }
        
        if platform == "iPad4,7" || platform == "iPad4,8" || platform == "iPad4,9" {
            return .iPadmini3
        }
        
        if platform == "iPad5,1" || platform == "iPad5,2" {
            return .iPadmini4
        }
        
        
        //Apple TV
        if platform.hasPrefix("AppleTV2") {
            return .appleTV2
        }
        
        if platform.hasPrefix("AppleTV3") {
            return .appleTV3
        }
        
        if platform.hasPrefix("AppleTV5") {
            return.appleTV4
        }
        
        //Apple Watch
        if platform.hasPrefix("Watch1") {
            return .appleWatch
        }
        
        if platform.hasPrefix("Watch2,6") || platform.hasPrefix("Watch2,7") {
            return .appleWatchS1
        }
        
        if platform.hasPrefix("Watch2,3") || platform.hasPrefix("Watch2,4") {
            return .appleWatchS2
        }
        
        //unknow
        if platform.hasPrefix("iPhone") {
            return .unknowniPhone
        }
        
        if platform.hasPrefix("iPod") {
            return .unknowniPod
        }
        
        if platform.hasPrefix("iPad") {
            return .unknowniPad
        }
        
        if platform.hasPrefix("AppleTV") {
            return .unknownAppleTV
        }
        
        if platform.hasPrefix("86") || platform == "x86_64" {
            let smallerScreen = UIScreen.main.bounds.size.width < 768
            return smallerScreen ? .simulatoriPhone : .simulatoriPad
        }
        
        return .unknown
    }
    
    /// Platform name
    func platformString() -> String {
        return self.platformType().rawValue
    }
    
    /// Device family
    func deviceFamily() -> UIDeviceFamily {
        let platform = self.platform()
        if platform.hasPrefix("iPhone") {
            return .iPhone
        }
        
        if platform.hasPrefix("iPod") {
            return .iPod
        }
        
        if platform.hasPrefix("iPad") {
            return .iPad
        }
        
        if platform.hasPrefix("AppleTV") {
            return .appleTV
        }
        
        return .unknown
    }

}

