//
//  AppDelegate.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 16.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Class Properties
    
    var window: UIWindow?
    
    // MARK: - Application Settings
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupTabBar()
        setupNavigationBar()
        return true
    }
    
    // MARK: - Custom Methods
    
    func setupTabBar() {
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
    }
    
    func setupNavigationBar() {
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
}

