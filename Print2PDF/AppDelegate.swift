//
//  AppDelegate.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // init window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // init root view
        let mainVC = MainTableViewController()
        let rootVC = UINavigationController(rootViewController: mainVC)
        
        // Set window's root
        guard let w = window else { return true }
        w.rootViewController = rootVC
        w.makeKeyAndVisible()
        return true
    }
}
