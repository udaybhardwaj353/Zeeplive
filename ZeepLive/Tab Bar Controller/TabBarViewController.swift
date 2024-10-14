//
//  TabBarViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/05/23.
//

import UIKit
import ZegoExpressEngine

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set tab bar appearance
        configureTabBarAppearance()
        
    }
   
    private func configureTabBarAppearance() {
           UITabBar.appearance().tintColor = UIColor.systemPurple
           UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
       }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            // Pop to root view controller when the same tab is selected again
        
        print("This function is working in tab bar.")
        
        ZegoExpressEngine.shared().logoutRoom()
        ZegoExpressEngine.destroy(nil)
        
            if let controllers = self.viewControllers, controllers.count > selectedIndex {
                if let navController = controllers[selectedIndex] as? UINavigationController {
                    navController.popToRootViewController(animated: false)
                }
            }
        }
    
    // UITabBarControllerDelegate
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
          // Handle tab bar item selection
          print("Selected view controller")
        
        
      }
  }

