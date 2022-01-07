//
//  AppDelegate.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import UIKit
import SnapKit
import CocoaLumberjack

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        DDLog.add(DDOSLogger.sharedInstance)

        let fileLogger = DDFileLogger(logFileManager: DDLogFileManagerDefault())
        
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        
        //重用log文件，不要每次启动都创建新的log文件(默认值是NO)
        fileLogger.doNotReuseLogFiles = true;
        //log文件夹最多保存20M
        fileLogger.logFileManager.logFilesDiskQuota = 1024*1024*20;
        DDLog.add(fileLogger)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = NNNavigationController(rootViewController: NNHomeViewController())
        
        
        
        window?.makeKeyAndVisible()
        return true
    }
}


