//
//  AppDelegate.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 25/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import EasyTipView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let onboardingViewController = Presenter.inject(.onboarding)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = onboardingViewController
        window?.makeKeyAndVisible()
        
        setupTooltip()
        
//        if UserDefaults.standard.bool(forKey: "didDisplayOnboarding") {
//            let documentBrowserViewController = Presenter.inject(.documentBrowser)
//
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.rootViewController = documentBrowserViewController
//            window?.makeKeyAndVisible()
//
//        } else {
//            let onboardingViewController = Presenter.inject(.onboarding)
//
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.rootViewController = onboardingViewController
//            window?.makeKeyAndVisible()
//
//            UserDefaults.standard.set(true, forKey: "didDisplayOnboarding")
//        }

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
        NotificationCenter.default.removeObserver(self)
    }

}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: UIViewController? {
        return window?.rootViewController
    }
}

extension AppDelegate {
    private func setupTooltip() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.textAlignment = .center
        
        preferences.drawing.backgroundColor = .yellow
        preferences.drawing.foregroundColor = .black
        
        preferences.drawing.arrowHeight = 10.0
        preferences.drawing.arrowWidth = 10.0
        preferences.drawing.arrowPosition = .top
        
        EasyTipView.globalPreferences = preferences
    }
}
