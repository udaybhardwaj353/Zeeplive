//
//  CallNotificationViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 06/05/24.
//

import UIKit
import ZegoExpressEngine

protocol delegateCallNotificationViewController: AnyObject {

    func buttonRecieveCallPressed(isPressed:Bool)
    
}

class CallNotificationViewController: UIViewController {

    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnRecieveCallOutlet: UIButton!
    @IBOutlet weak var btnRejectCallOutlet: UIButton!
    weak var delegate: delegateCallNotificationViewController?
    
    lazy var imageUrl: String = ""
    lazy var userName: String = ""
    lazy var roomID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    @IBAction func btnRecieveCallPressed(_ sender: Any) {
        
        print("Button Recieve Call Pressed.")
        
        delegate?.buttonRecieveCallPressed(isPressed: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.transition(with: self.viewNotification, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.viewNotification.isHidden = true
            }, completion: { finished in
                if finished {
                    // Animation completed
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
    }
    
    @IBAction func btnRejectCallPressed(_ sender: Any) {
        
        print("Button Reject Call Pressed.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.transition(with: self.viewNotification, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.viewNotification.isHidden = true
            }, completion: { finished in
                if finished {
                    // Animation completed
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func configureUI() {
    
        loadImage(from: imageUrl, into: imgViewUser)
        lblUserName.text = userName
        
        viewNotification.isHidden = true
        viewNotification.layer.cornerRadius = 10
        viewNotification.backgroundColor = .white
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(with: self.viewNotification, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.viewNotification.isHidden = false
            }, completion: nil)
        }
        
    }
    
    
    deinit {
        print("Deinit call hua hai call notification view controller main.")
    }
    
}


//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//
//            self.viewNotification.isHidden = false
//
//         }

//        dismiss(animated: true, completion: nil)

// dismiss(animated: true, completion: nil)
