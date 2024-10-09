//
//  BottomWebViewViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/01/24.
//

import UIKit
import WebKit
import FittedSheets

protocol delegateBottomWebViewViewController: AnyObject {

    func showRechargePage(show:Bool)
    
}

class BottomWebViewViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var url = String()
    weak var sheetController:SheetViewController!
    lazy var height: CGFloat = 0
    weak var delegate: delegateBottomWebViewViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  congifureView()
        configureWebView()
        
       }
    
    func configureWebView() {
    
        let wcc = WKUserContentController()
                
                // Binding method name
                wcc.add(self, name: "closeGame")
                wcc.add(self, name: "pay")
                
                let webConfiguration = WKWebViewConfiguration()
                webConfiguration.userContentController = wcc
                
                if #available(iOS 10.0, *) {
                    webConfiguration.mediaTypesRequiringUserActionForPlayback = []
                } else {
                    webConfiguration.requiresUserActionForMediaPlayback = false
                }
               
            let webViewHeight: CGFloat = view.frame.height
            let webViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        
                webView.isOpaque = false
               webView.uiDelegate = self
                webView = WKWebView(frame: webViewFrame, configuration: webConfiguration)
            view.addSubview(webView)
        
       // webView.navigationDelegate = self
        self.navigationController?.navigationBar.isHidden = true
        
        if url == "" {
            print("URL nahi aaya")
        } else {
        let myURL = URL(string:url)
             let myRequest = URLRequest(url: myURL!)
             webView.load(myRequest)
        }
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            let method = "\(message.name):"
            let selector = NSSelectorFromString(method)
            
            if responds(to: selector) {
                // Using reflectors
                perform(selector, with: message.body)
            } else {
                print("Unimplemented method \(message.name) --> \(message.body)")
            }
        }
        
        // Close the game
        @objc func closeGame(_ args: Any) {
            // Your implementation here
            print("recharge wale page ko band kar denge")
            
        }
        
        // Displayed recharge page
        @objc func pay(_ args: Any) {
            // Your implementation here
            print("recharge wale page ko khol denge")
            delegate?.showRechargePage(show: true)
            
        }
    
    deinit {
   
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "buttonClicked")
        webView.removeFromSuperview()
        
    }
    
}

//    func congifureView() {
//
//        webView.navigationDelegate = self
//        tabBarController?.tabBar.isHidden = true
//       // self.navigationController?.navigationBar.isHidden = true
//
//        print("The url here is: \(url)")
//
//        if let myURL = URL(string: url) {
//            let myRequest = URLRequest(url: myURL)
//            webView.load(myRequest)
//        } else {
//            print("URL is nil")
//        }
//
//    }
    
