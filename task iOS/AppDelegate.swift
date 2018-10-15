//
//  AppDelegate.swift
//  task iOS
//
//  Created by petr on 10/10/18.
//  Copyright © 2018 petr. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

private var _activityIndicatorContext: UInt8 = 0;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    deinit {
        self.sna_unregisterAsObserver(
            withSubject: ActivityIndicatorController.instance,
            property: #selector(getter: ActivityIndicatorController.activityIndicatorCounter),
            context: &_activityIndicatorContext
        );
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self]);
        
        let model = UsersModel();
        let viewModel = UsersViewModel(model: model);
        let usersController = UsersViewController(with: viewModel);
        let masterNavigation = NavigationController(rootViewController: usersController);
        
        let detailsNavigation = NavigationController();
        
        let split = ContainerViewController();
        split.viewControllers = [masterNavigation, detailsNavigation];
        
        let rootViewController = split;
        
        self.window = UIWindow(frame: UIScreen.main.bounds);
        self.window?.rootViewController = rootViewController;
        self.window?.makeKeyAndVisible();
        
        self.sna_registerAsObserver(
            withSubject: ActivityIndicatorController.instance,
            property: #selector(getter: ActivityIndicatorController.activityIndicatorCounter),
            context: &_activityIndicatorContext
        ) { (subject, old, new) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = ActivityIndicatorController.instance.activityIndicatorCounter > 0
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        OperationQueue.tios_globalQueue.isSuspended = true;
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
        OperationQueue.tios_globalQueue.isSuspended = false;
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

