//
//  AppDelegate.swift
//  LearnWCDB
//
//  Created by ice on 2021/6/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DatabaseManager.default.initDataBase()
        
        let object = Sample()
        object.identifier = 1
        object.description = "sample_insert3"
        DatabaseManager.default.insert(object: object)
        
        let object2 = Sample()
        object2.identifier = 2
        object2.description = "2222222"
        DatabaseManager.default.insert(object: object2)
        
        let object3 = Sample()
        object3.identifier = 3
        object3.description = "333333"
        DatabaseManager.default.insert(object: object3)
        
        let object4 = Sample()
        object4.identifier = 4
        object4.description = "44444"
        DatabaseManager.default.insert(object: object4)
        
        let ss = DatabaseManager.default.getWithWhere()
        print(ss)
        
       // DatabaseManager.default.deletate(identifier: 1)
        print(ss)
        
        let object5 = Sample()
        object5.identifier = 5
        object5.description = "4444455555"
        DatabaseManager.default.updateWithRow2()
        
        let objc = DatabaseManager.default.getMax()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    func delete() {
        
    }
}

