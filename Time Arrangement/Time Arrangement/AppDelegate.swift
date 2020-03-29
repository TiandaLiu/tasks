//
//  AppDelegate.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/5.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchFromTerminated = false
    
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
    func showSplashScreen(autoDismiss: Bool) {
        let storyboard = UIStoryboard(name:"splace", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "splash") as! LaunchScreen
        
        //Cntrol the behavior from suspended to launch
        controller.autoDismiss = autoDismiss
        let mainStoryBoard = UIStoryboard(name:"main", bundle: nil)
        let vc = mainStoryBoard.instantiateInitialViewController()
        vc!.present(controller, animated: false, completion: nil)
        
    }
    
    
}

