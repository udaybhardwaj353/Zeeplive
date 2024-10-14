//
//  PlayGameViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/09/23.
//

import UIKit
import WebKit

class PlayGameViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {

    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    lazy var imageName = String()
    lazy var url = String()
    lazy var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  url = "https://d1qiq0tjxfnegh.cloudfront.net/games/wheel_half/index.html?uid=26354605&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=103"
        
        setUrlForWebView()
        configureWebView()
        
    }
    
    func setUrlForWebView() {
        let id = UserDefaults.standard.string(forKey: "userId")
        
         if index == 0 {
             url = "https://d1qiq0tjxfnegh.cloudfront.net/games/thimbles_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=104"
         } else if index == 1 {
             url = "https://d1qiq0tjxfnegh.cloudfront.net/games/racep_chamet_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=101"
         } else if index == 2 {
             url = "https://d1qiq0tjxfnegh.cloudfront.net/games/wheel_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=103"
         } else if index == 3 {
             url = "https://d1qiq0tjxfnegh.cloudfront.net/games/race_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=102"
         }
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
               
            let webViewHeight: CGFloat = 430
            let webViewFrame = CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: webViewHeight)
        
                webView.isOpaque = false
               webView.uiDelegate = self
                webView = WKWebView(frame: webViewFrame, configuration: webConfiguration)
            view.addSubview(webView)
        
        print(index)
        print(imageName)
        imgViewBackground.image = UIImage(named: imageName)
        
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
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
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
            
        }
    
    
    // WKScriptMessageHandler method to handle messages from JavaScript
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            if message.name == "buttonClicked", let messageBody = message.body as? String {
//                // Handle the message when the button is clicked
//                if messageBody == "Button was clicked" {
//                    // Open a view in your app
//                    // For example, navigate to a new view controller
//                    let newViewController = GameViewController() // Replace with your custom view controller
//                    navigationController?.pushViewController(newViewController, animated: true)
//                }
//            }
//        }
    
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//           if message.name == "LingxianAndroid", let body = message.body as? String {
//               // Handle the message from JavaScript
//               // You can call Swift functions or perform actions here
//               print("Received message from JavaScript: \(body)")
//           }
//       }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Web view failed to load with error: \(error)")
        
        // Handle the error here
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Web view navigation failed with error: \(error)")
        
        // Handle the error here
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "buttonClicked")
        print("Iska deinit call ho raha hai..")
    }
    
}
