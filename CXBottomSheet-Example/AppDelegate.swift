//
//  AppDelegate.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/16/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        let rootViewController = BottomSheetExampleContainerViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }

}

