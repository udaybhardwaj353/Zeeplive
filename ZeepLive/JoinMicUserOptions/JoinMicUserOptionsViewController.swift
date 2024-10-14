//
//  JoinMicUserOptionsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 17/04/24.
//

import UIKit

protocol delegateJoinMicUserOptionsViewController: AnyObject {

    func leaveMicPressed(isPressed:Bool)
    func muteMicPressed(isPressed: Bool)
    func openProfileDetails(isPressed: Bool)
    
}

class JoinMicUserOptionsViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewHostOptions: UIView!
    @IBOutlet weak var btnMuteUserOutlet: UIButton!
    @IBOutlet weak var lblMute: UILabel!
    @IBOutlet weak var imgViewMute: UIImageView!
    @IBOutlet weak var btnKickOutUserOutlet: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewUserImageOutlet: UIButton!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var btnCloseOutlet: UIButton!
    @IBOutlet weak var viewUserOption: UIView!
    @IBOutlet weak var btnLeaveOutlet: UIButton!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewDashLine: UIView!
    
    weak var delegate: delegateJoinMicUserOptionsViewController?
    lazy var cameFrom: String = ""
    lazy var userName: String = ""
    lazy var userImage: String = ""
    lazy var isMuteMicButtonPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
       configureUI()
       configureToClose()
        
    }
    
    @IBAction func btnMuteUserPressed(_ sender: Any) {
        
        print("Button Mute User Pressed by Host.")
        if isMuteMicButtonPressed
        
        {
           
            isMuteMicButtonPressed = false
            delegate?.muteMicPressed(isPressed: isMuteMicButtonPressed)
            lblMute.text = "Mute"
            imgViewMute.image = UIImage(named: "mute")
            
        }
        
        else{
            
         
            isMuteMicButtonPressed = true
            delegate?.muteMicPressed(isPressed: isMuteMicButtonPressed)
            lblMute.text = "UnMute"
            imgViewMute.image = UIImage(named: "unmute")
            
        }

    }
    
    @IBAction func btnKickOutUserPressed(_ sender: Any) {
        
        print("Button Kickout User Pressed by Host.")
        dismiss(animated: true, completion: nil)
        delegate?.leaveMicPressed(isPressed: true)
       
        
    }
    
    @IBAction func viewUserPressed(_ sender: Any) {
        
        print("View User Pressed for opening profile detail page.")
        delegate?.openProfileDetails(isPressed: true)
        
    }
    
    @IBAction func btnClosePressed(_ sender: Any) {
        
        print("Button Close this page clicked.")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnLeavePressed(_ sender: Any) {
        
        print("Button Remove from join mic is pressed by the user.")
        dismiss(animated: true, completion: nil)
        delegate?.leaveMicPressed(isPressed: true)
        
    }
    
}

extension JoinMicUserOptionsViewController {
    
    func loadData() {
    
        loadImage(from: userImage, into: imgViewUser)
        lblUserName.text = userName
        
    }
    
    func configureUI() {
    
        if (cameFrom == "host") {
            print("Host ne view controller khola hai.")
            viewUserOption.isHidden = true
            viewHostOptions.isHidden = false
            
        } else {
            print("User ne apne liye view controller khola hai.")
            viewHostOptions.isHidden = true
            viewUserOption.isHidden = false
            
        }
        
        viewMain.layer.cornerRadius = 20
        viewUserImageOutlet.layer.cornerRadius = viewUserImageOutlet.frame.height / 2
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        viewLine.backgroundColor = GlobalClass.sharedInstance.userOptionsDashLineColour()
        viewDashLine.backgroundColor = GlobalClass.sharedInstance.userOptionsDashLineColour()
        lblUserName.textColor = GlobalClass.sharedInstance.userOptionsTextColour()
        
    }
    
    func configureToClose() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewMain)
        
        // Check if the tap was inside viewBottom or not
        if view.bounds.contains(location) {

            print("View bottom par tap hua hai")
            
        } else {
            
            print("View bottom par tap nahi hua hai")
            dismiss(animated: true, completion: nil)
        }
    }
    
}
