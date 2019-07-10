//
//  AppDelegate.swift
//  DeliveryApp
//
//  Created by Bhavuk Chawla on 08/07/19.
//  Copyright © 2019 Bhavuk Chawla. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = DeliveryListViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.isTranslucent = false
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        return true
    }

}

extension AppDelegate {
    class func delegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
