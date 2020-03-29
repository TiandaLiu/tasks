//
//  SceneDelegate.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/5.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var launchFromTerminated = false
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Override point for customization after application launch.
        DataManager.sharedInstance.loadTimesOfLaunched()
        if DataManager.sharedInstance.timesOfLaunched < 5 {
            DataManager.sharedInstance.increaseTimesOfLaunched()
        }
        self.launchFromTerminated = true
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if launchFromTerminated {
            showSplashScreen(autoDismiss: false)
            launchFromTerminated = false
        }
        
        /* set the launch date*/
        if UserDefaults.standard.object(forKey: "launchedBefore") == nil {
            var today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            today = dateFormatter.date(from: dateFormatter.string(from: today))!
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(dateFormatter.string(from: today), forKey: "lauch_date")
        }
    }

    
    func sceneWillEnterForeground(_ scene: UIScene) {

        if launchFromTerminated == false {
            showSplashScreen(autoDismiss: true)
        }
    }

}


extension SceneDelegate {
    func showSplashScreen(autoDismiss: Bool) {
        let storyboard = UIStoryboard(name:"Splash", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "splash") as! LaunchScreen
        controller.modalPresentationStyle = .fullScreen

        //Cntrol the behavior from suspended to launch
        controller.autoDismiss = autoDismiss
        let vc = topController()
        vc.present(controller, animated: false, completion: nil)
        
    }
    
    func topController(_ parent: UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return topController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return topController(top)
            } else if let presented = vc.presentedViewController {
                return topController(presented)
            } else {
                return vc
            }
        } else {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            return topController(keyWindow!.rootViewController)
        }
    }
    
}

