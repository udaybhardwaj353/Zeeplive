//
//  NavigationViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/09/23.
//

import UIKit

class NavigationViewController: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    

}
