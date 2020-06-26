//
//  AppDelegate.swift
//  photoDemo
//
//  Created by 徐常璿 on 2020/6/23.
//  Copyright © 2020 Eric Hsu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let nvc = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
        
        return true
    }

    


}

