//
//  SceneDelegate.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 13/04/23.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootVC: TabBarViewController?
    
    func setRootViewController() {
        let token = UserDefaults.standard.string(forKey: "token")
        print(token)
        
        if token == nil || token == "" {
            // User is not logged in, so set the login view controller as the root
            let logVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NavigationViewController")
            self.window?.rootViewController = logVc
            GlobalClass.sharedInstance.window = self.window
            
        } else {
            // User is logged in, so set the main tab bar controller as the root
            let mainVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController") as TabBarViewController
            self.rootVC = mainVc
            self.window?.rootViewController = rootVC
            GlobalClass.sharedInstance.window = self.window
        }
    }

    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        UIApplication.shared.isIdleTimerDisabled = true
        setRootViewController()
        window!.overrideUserInterfaceStyle = .light
        guard let _ = (scene as? UIWindowScene) else { return }
    
          //  guard let _ = (scene as? UIWindowScene) else { return }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        print("App bnd ho gya hai")
        ZLFireBaseManager.share.updateUserStatusToFirebase(status: "Offline")
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        print("App phir se khul gya hai")
      //  ZLFireBaseManager.share.updateUserStatusToFirebase(status: "Online")
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        print("App inactive state main chala gya hai")
      //  ZLFireBaseManager.share.updateUserStatusToFirebase(status: "Offline")
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        print("App so rha hai. ")
    }


}

