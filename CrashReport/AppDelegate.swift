//
//  AppDelegate.swift
//  CrashReport
//
//  Created by 郜宇 on 2017/8/7.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPExtensions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        
        print("totalMemory: \(UIDevice.current.lp.totalMemory() / 1000 / 1000)")
        print("userMemory: \(UIDevice.current.lp.userMemory() / 1000 / 1000)")
        print("totalDiskSpace: \(UIDevice.current.lp.totalDiskSpace() as! UInt64 / 1000 / 1000)")
        print("freeDiskSpace: \(UIDevice.current.lp.freeDiskSpace() as! UInt64 / 1000 / 1000)")
        print("platformString: \(UIDevice.current.lp.platformString())")
        print("deviceFamily: \(UIDevice.current.lp.deviceFamily())")

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
 
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
    }


}

