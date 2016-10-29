//
//  AppDelegate.swift
//  Tablecloth
//
//  Created by Erdem Turançiftçi on 29/10/2016.
//  Copyright © 2016 Erdem Turançiftçi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        window!.rootViewController = ViewController()

        return true
    }
}
