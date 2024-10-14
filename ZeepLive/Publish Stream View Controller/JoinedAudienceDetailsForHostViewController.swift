//
//  JoinedAudienceDetailsForHostViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/10/24.
//

import UIKit
import ImSDK_Plus
import Kingfisher

protocol delegateJoinedAudienceDetailsForHostViewController:AnyObject {

    func viewProfileDetailsForHost(isClicked:Bool, userID:String)
    func muteUserChat(isMute:Bool)
    func kickOutUser(isKickout:Bool)
    
}


class JoinedAudienceDetailsForHostViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnImageOutlet: UIButton!
    @IBOutlet weak var imgViewUserFrame: UIImageView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnFollowUserOutlet: UIButton!
    @IBOutlet weak var viewUserID: UIView!
    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var viewUserCountry: UIView!
    @IBOutlet weak var lblUserCountry: UILabel!
    @IBOutlet weak var viewUserAge: UIView!
    @IBOutlet weak var imgViewUserGender: UIImageView!
    @IBOutlet weak var lblUserAge: UILabel!
    @IBOutlet weak var viewRichLevel: UIView!
    @IBOutlet weak var imgViewRichLevel: UIImageView!
    @IBOutlet weak var lblUserRichLevel: UILabel!
    @IBOutlet weak var viewCharmLevel: UIView!
    @IBOutlet weak var imgViewCharmLevel: UIImageView!
    @IBOutlet weak var lblUserCharmLevel: UILabel!
    @IBOutlet weak var btnReportUserProfileOutlet: UIButton!
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var viewBottomLine: UIView!
    @IBOutlet weak var btnMuteChatOutlet: UIButton!
    @IBOutlet weak var lblMuteChat: UILabel!
    @IBOutlet weak var btnKickOutUserOutlet: UIButton!
    
    weak var delegate: delegateJoinedAudienceDetailsForHostViewController?
    lazy var broadGroupJoinuser = V2TIMUserFullInfo()
    lazy var messageDetails = joinedGroupUserProfile()
    lazy var overLayer: CustomAlertViewController? = nil
    lazy var viewFrom: String = "group"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureToClose()
        setData()
        
    }
    
    @IBAction func btnImagePressed(_ sender: Any) {
        
        print("Button Image Pressed in Joined Audience Details For Host View Controller.")
        
        dismiss(animated: true, completion: nil)
        if (viewFrom != "group") {
            
            delegate?.viewProfileDetailsForHost(isClicked: true, userID: messageDetails.userID ?? "")
            
        } else {
            
            delegate?.viewProfileDetailsForHost(isClicked: false, userID: broadGroupJoinuser.userID ?? "")
            
        }
        
    }
    
    @IBAction func btnFollowUserPressed(_ sender: Any) {
        
        print("Button Follow User Pressed in Joined Audience Details For Host View Controller.")
        
    }
    
    @IBAction func btnReportUserProfilePressed(_ sender: Any) {
        
        print("Button Report User Pressed in Joined Audience Details For Host View Controller.")
        
        overLayer = CustomAlertViewController()
        
        if (viewFrom != "group") {
            
            overLayer?.appear(sender: self, userId: Int(messageDetails.userID ?? "") ?? 0)
            
        } else {
            
            overLayer?.appear(sender: self, userId: Int(broadGroupJoinuser.userID ?? "") ?? 0)
            
        }
        
    }
    
    @IBAction func btnMuteChatPressed(_ sender: Any) {
        
        print("Button Mute Chat Pressed in Joined Audience Details For Host View Controller.")
       
        delegate?.muteUserChat(isMute: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnKickOutUserPressed(_ sender: Any) {
        
        print("Button KickOut User Pressed in Joined Audience Details For Host View Controller.")
       
        delegate?.kickOutUser(isKickout: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    deinit {
       
        broadGroupJoinuser = V2TIMUserFullInfo()
               delegate = nil
               viewFrom = ""
               messageDetails = joinedGroupUserProfile()
        
    }
    
}

extension JoinedAudienceDetailsForHostViewController {
    
    func configureUI() {
    
        btnFollowUserOutlet.isHidden = true
        btnImageOutlet.layer.cornerRadius = btnImageOutlet.frame.height / 2
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.height / 2
        imgViewUserFrame.layer.cornerRadius = imgViewUserFrame.frame.height / 2
        viewUserCountry.layer.cornerRadius = viewUserCountry.frame.height / 2
        viewUserID.layer.cornerRadius = viewUserID.frame.height / 2
        viewMain.layer.cornerRadius = 20
        
        let gradientColors: [UIColor] = [UIColor(hexString: "#7B73EF")!, UIColor(hexString: "#C76ADE")!]
        addGradientToView(to: viewUserCountry, cornerRadius: viewUserCountry.frame.height/2, colors: gradientColors)
        addGradientToView(to: viewUserID, cornerRadius: viewUserID.frame.height/2, colors: gradientColors)
        
        print("User ki jo details hai woh hai: \(broadGroupJoinuser)")
        
    }
    
    func configureToClose() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewMain)
        
        // Check if the tap was inside viewBottom or not
        if viewMain.bounds.insetBy(dx: -50, dy: -50).contains(location) {
            
            print("View main par tap hua hai")
            
        } else {
            
            print("View main par tap nahi hua hai")
            broadGroupJoinuser = V2TIMUserFullInfo()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setData() {
        
        if (viewFrom == "message") {
            
            lblUserName.text = messageDetails.nickName
            lblUserRichLevel.text = "Lv." + " " +  (messageDetails.richLevel ?? "0")
            lblUserCharmLevel.text = "Lv." + " " + (messageDetails.charmLevel ?? "0")
            lblUserAge.text = "24"
            lblUserCountry.text = "India"
            lblUserID.text = "ID:" + " " + (messageDetails.userID ?? "N/A")
            
            if (messageDetails.gender == 1) {
                imgViewUserGender.image = UIImage(named: "MaleBackgroundImage")
            } else {
                imgViewUserGender.image = UIImage(named: "FemaleBackgroundImage")
            }
            
            if let imageURL = URL(string: messageDetails.faceURL ?? "") {
                KF.url(imageURL)
                    .cacheOriginalImage()
                    .onSuccess { result in
                        DispatchQueue.main.async {
                            self.imgViewUserPhoto.image = result.image
                        }
                    }
                    .onFailure { error in
                        print("Image loading failed with error: \(error)")
                        self.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                    }
                    .set(to: imgViewUserPhoto)
            } else {
                imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
            
        } else {
            if let customInfo = broadGroupJoinuser.customInfo {
                if let charmlvlData = customInfo["charmlvl"],
                   let charmLevelString = String(data: charmlvlData, encoding: .utf8) {
                    print("Charm Level: \(charmLevelString)")
                    lblUserCharmLevel.text = "Lv." + " " + (charmLevelString ?? "0")
                }
                
                if let richlvlData = customInfo["richlvl"],
                   let richLevelString = String(data: richlvlData, encoding: .utf8) {
                    print("Rich Level: \(richLevelString)")
                    lblUserRichLevel.text = "Lv." + " " +  (richLevelString ?? "0")
                }
            } else {
                print("Custom info is not available for broadGroupJoinuser.")
            }
            
            
            lblUserName.text = broadGroupJoinuser.nickName
            lblUserAge.text = "24"
            lblUserCountry.text = "India"
            lblUserID.text = "ID:" + " " + (broadGroupJoinuser.userID ?? "N/A")
            
            if (broadGroupJoinuser.gender.rawValue == 1) {
                imgViewUserGender.image = UIImage(named: "MaleBackgroundImage")
            } else {
                imgViewUserGender.image = UIImage(named: "FemaleBackgroundImage")
            }
            
            if let imageURL = URL(string: broadGroupJoinuser.faceURL ?? "") {
                KF.url(imageURL)
                    .cacheOriginalImage()
                    .onSuccess { result in
                        DispatchQueue.main.async {
                            self.imgViewUserPhoto.image = result.image
                        }
                    }
                    .onFailure { error in
                        print("Image loading failed with error: \(error)")
                        self.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                    }
                    .set(to: imgViewUserPhoto)
            } else {
                imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
        }
    }
    
}
