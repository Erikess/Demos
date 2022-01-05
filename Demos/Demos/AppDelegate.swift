//
//  AppDelegate.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import UIKit
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = NNNavigationController(rootViewController: NNHomeViewController())
        
        window?.makeKeyAndVisible()
        return true
    }
}

