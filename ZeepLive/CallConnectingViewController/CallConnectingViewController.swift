//
//  CallConnectingViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 19/06/24.
//

import UIKit
import ZegoExpressEngine

class CallConnectingViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var btnCancelCallOutlet: UIButton!
    
    lazy var hostImage: String = ""
    lazy var hostName: String = ""
    lazy var channelName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // ZegoExpressEngine.destroy(nil)
        configureUI()
        loadData()
        
    }
    
    @IBAction func btnCancelCallPressed(_ sender: Any) {
        
        print("Button Cancel Call Pressed.")
        ZegoExpressEngine.shared().logoutRoom()
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("callcut"), object: nil)
    }
    
    func configureUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("callconnecting"), object: nil)
        tabBarController?.tabBar.isHidden = true
        viewMain.layer.cornerRadius = viewMain.frame.height / 2
        imgView.layer.cornerRadius = imgView.frame.height / 2
       // imgView.clipsToBounds = true
       // imgView.layer.masksToBounds = true
        
    }
    
    func loadData() {
    
        loadImage(from: hostImage, into: imgView)
        lblHostName.text = hostName
        print("The host image url is: \(hostImage)")
        print("The host name is: \(hostName)")
        print("The channel name is: \(channelName)")
        
    }
    
    @objc func handleNotification(_ notification: Notification) {
        // Handle the notification here
        print("The notification is printed here in call connecting view controller.")
        navigationController?.popViewController(animated: false)
        
    }

    deinit {
        
        print("Deinit call hua hai Call Connecting View Controller main.")
        NotificationCenter.default.removeObserver(self)
       // ZegoExpressEngine.destroy(nil)
        
    }
    
}
