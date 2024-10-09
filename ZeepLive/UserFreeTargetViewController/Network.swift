//
//  Network.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 18/06/24.
//

import Foundation
import SystemConfiguration
import UIKit
import Network

class Connectivity {
    static let shared = Connectivity()
    
    private let monitor = NWPathMonitor()
    private var isMonitoring = false
    
    private init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor.pathUpdateHandler = { [weak self] path in
                    if path.status == .satisfied {
                        print("Internet connection is available")
                        NotificationCenter.default.post(name: .internetConnectionRestored, object: nil)
                    } else {
                        print("Internet connection is not available")
                        NotificationCenter.default.post(name: .internetConnectionLost, object: nil)
                        self?.showNoInternetAlert()
                    }
                }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        
        monitor.cancel()
        isMonitoring = false
    }
    
    func showNoInternetAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            if let topViewController = UIApplication.getTopViewController() {
                topViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
extension UIApplication {
    static func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        }
        
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        
        return base
    }
}


extension Notification.Name {
    static let internetConnectionLost = Notification.Name("internetConnectionLost")
    static let internetConnectionRestored = Notification.Name("internetConnectionRestored")
}
