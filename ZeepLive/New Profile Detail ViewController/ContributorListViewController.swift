//
//  ContributorListViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 07/10/24.
//

import UIKit
import WebKit

class ContributorListViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewTopHeightConstraints: NSLayoutConstraint!
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewTop.isHidden = true
        viewTopHeightConstraints.constant = 0
        
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
        
        print("Btton Back Pressed in Contributor List View Controller.")
      
        //self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        
    }
    
}
