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

        let _ = LPCrashReport.shared

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
      print("..applicationWillResignActive..")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("..applicationDidEnterBackground..")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("..applicationWillEnterForeground..")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("..applicationDidBecomeActive..")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("..applicationWillTerminate..")
    }


}

