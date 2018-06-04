//
//  AppDelegate.swift
//  DDSample
//
//  Created by Igor Novik on 2018-06-03.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureGlobalAppearance()
        return true
    }
    
    private func configureGlobalAppearance() {
        // tab bar
        UITabBar.appearance().tintColor = Constants.Apperance.ddRedColor
        
        // navigation bar
        UINavigationBar.appearance().tintColor = Constants.Apperance.ddRedColor
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: Constants.Apperance.ddRedColor,
            NSAttributedStringKey.font: Constants.Apperance.navBarTitleFont
        ]

    }
}

