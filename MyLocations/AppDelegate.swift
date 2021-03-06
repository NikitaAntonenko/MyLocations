//
//  AppDelegate.swift
//  MyLocations
//
//  Created by getTrickS2 on 12/27/17.
//  Copyright © 2017 Nik's. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties ===============================================
    var window: UIWindow?
    // The purpose of two lazy variables that create the "managedObjectContext" !!!
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores() {
            storeDescription, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        }
        return container
    }()
    lazy var managedObjectContext: NSManagedObjectContext =
        persistentContainer.viewContext
    
    // ==========================================================
    
    // MARK: - Mandatory Functions ======================================
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let tabBarController = window!.rootViewController as! UITabBarController
        if let tapBarViewControllers = tabBarController.viewControllers {
            // For first screen
            let currentLocationViewController = tapBarViewControllers[0] as! CurrentLocationViewController
            currentLocationViewController.managedObjectContext = managedObjectContext
            // Fpr second screen
            let navigationController = tapBarViewControllers[1] as! UINavigationController
            let locationsViewController = navigationController.viewControllers[0] as! LocationsViewController
            locationsViewController.managedObjectContext = managedObjectContext
            // Start fetchResultsController with viewDidLoad() by LocationsViewController
            _ = locationsViewController.view
        }
        listenForFatalCoreDataNotifications()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    // ==========================================================
    
    // MARK: - Functions ========================================
    func listenForFatalCoreDataNotifications() {
        NotificationCenter.default.addObserver(forName: MyManagedObjectContextSaveDidFailNotification, object: nil, queue: .main, using: { nitification in
            // 1. Create Alert
            let alert = UIAlertController(title: "Internal Error", message: "There was a fatal errer in the app and it cannot continue. \n\n Press OK to terminate the app. Sorry for the inconvenience.", preferredStyle: .alert)
            // 2. Create "OK" action
            let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
                let exeption = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal Core Data Error", userInfo: nil)
                exeption.raise()
                })
            // 3. Add "OK" action to the alsert
            alert.addAction(action)
            // 4. Show the alert
            self.viewControllerForShowingAlert().present(alert, animated: true, completion: nil)
            })
        
    }
    
    func viewControllerForShowingAlert() -> UIViewController {
        let rootViewController = window!.rootViewController!
        
        if let presentedViewController = rootViewController.presentedViewController {
            return presentedViewController
        } else {
            return rootViewController
        }
    }
    // ==========================================================

}

