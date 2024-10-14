//
//  WebViewViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 13/04/23.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, UINavigationBarDelegate, WKNavigationDelegate {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var webView: WKWebView!
    var url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        if url == "" {
            print("URL nahi aaya")
        } else {
        let myURL = URL(string:url)
             let myRequest = URLRequest(url: myURL!)
             webView.load(myRequest)
        }

        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let text = webView.request?.url?.absoluteString{
             print(text)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.view.removeFromSuperview()
        self.removeFromParent()
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Web view failed to load with error: \(error)")
        
        // Handle the error here
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Web view navigation failed with error: \(error)")
        
        // Handle the error here
    }
    
}
