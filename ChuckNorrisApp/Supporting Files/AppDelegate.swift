//
//  AppDelegate.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 16.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var сontainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // MARK: - Class Properties
    var window: UIWindow?
    
    // MARK: - AppDelegate Methods
    
    // Launching Options
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupTabBar()
        setupNavigationBar()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
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
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Jokes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

