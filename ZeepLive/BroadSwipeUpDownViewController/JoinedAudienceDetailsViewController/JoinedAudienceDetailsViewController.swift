//
//  JoinedAudienceDetailsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 22/01/24.
//

import UIKit
import Kingfisher
import ImSDK_Plus

protocol delegateJoinedAudienceDetailsViewController:AnyObject {

    func viewProfileDetails(isClicked:Bool, userID:String)
    
}

class JoinedAudienceDetailsViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewImageOutlet: UIButton!
    @IBOutlet weak var imgViewUserFrame: UIImageView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnFollowUserOutlet: UIButton!
    @IBOutlet weak var viewUserID: UIView!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var viewUserCountry: UIView!
    @IBOutlet weak var lblUserCountry: UILabel!
    @IBOutlet weak var viewUserAge: UIView!
    @IBOutlet weak var lblUserAge: UILabel!
    @IBOutlet weak var imgViewUserGender: UIImageView!
    @IBOutlet weak var viewRichLevel: UIView!
    @IBOutlet weak var lblUserRichLevel: UILabel!
    @IBOutlet weak var viewCharmLevel: UIView!
    @IBOutlet weak var lblUserCharmLevel: UILabel!
    @IBOutlet weak var imgViewCharmLevel: UIImageView!
    @IBOutlet weak var imgViewRichLevel: UIImageView!
    @IBOutlet weak var btnReportProfileOutlet: UIButton!
    
    lazy var broadGroupJoinuser = V2TIMUserFullInfo()
    weak var delegate: delegateJoinedAudienceDetailsViewController?
    lazy var viewFrom: String = "group"
    lazy var messageDetails = joinedGroupUserProfile()
    lazy var hostFollowed = Int()
    lazy var overLayer: CustomAlertViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("User ki jo details hai woh hai: \(broadGroupJoinuser)")
       
        configureToClose()
        setData()
        configureUI()
        //checkForFollow()
//        if (hostFollowed == 0) {
//            print("Host ko follow nahi kiya hai.")
//            btnFollowUserOutlet.isHidden = false
//        } else {
//            print("Host ko pehle se follow kiya hai.")
//            btnFollowUserOutlet.isHidden = true
//        }
        
    }
    
    @IBAction func viewImagePressed(_ sender: Any) {
        
        print("View Image Pressed For Further Details.")
     
        dismiss(animated: true, completion: nil)
        if (viewFrom != "group") {
            
//            delegate?.viewProfileDetails(isClicked: false, userID: broadGroupJoinuser.userID ?? "")
            delegate?.viewProfileDetails(isClicked: true, userID: messageDetails.userID ?? "")
        } else {
            
//            delegate?.viewProfileDetails(isClicked: true, userID: messageDetails.userID ?? "")
            delegate?.viewProfileDetails(isClicked: false, userID: broadGroupJoinuser.userID ?? "")
            
        }
    }
    
    @IBAction func btnFollowUserPressed(_ sender: Any) {
        
        print("Button Follow User Pressed")
        if (viewFrom != "group") {
    
            guard let id = messageDetails.userID else {
                print("Error: profileID is nil.")
                return
            }
          follow(id: id)
            
        } else {
  
            guard let id = broadGroupJoinuser.userID else {
                print("Error: profileID is nil.")
                return
            }
           follow(id: id)
        }
        
    }
    
    @IBAction func btnReportUserPressed(_ sender: Any) {
        
        print("Button Report User Pressed.")
        
        overLayer = CustomAlertViewController()
        
        if (viewFrom != "group") {
            
            overLayer?.appear(sender: self, userId: Int(messageDetails.userID ?? "") ?? 0)
            
        } else {
            
            overLayer?.appear(sender: self, userId: Int(broadGroupJoinuser.userID ?? "") ?? 0)
            
        }
        
    }
    
    func configureUI() {
    
        btnFollowUserOutlet.isHidden = true
        viewImageOutlet.layer.cornerRadius = viewImageOutlet.frame.height / 2
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.height / 2
        imgViewUserFrame.layer.cornerRadius = imgViewUserFrame.frame.height / 2
        viewUserCountry.layer.cornerRadius = viewUserCountry.frame.height / 2
      //  viewUserCountry.backgroundColor = .purple.withAlphaComponent(0.4)//GlobalClass.sharedInstance.setGapColour()
        viewUserID.layer.cornerRadius = viewUserID.frame.height / 2
       // viewUserID.backgroundColor = .purple.withAlphaComponent(0.4)//GlobalClass.sharedInstance.setGapColour()
        //viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        viewMain.layer.cornerRadius = 20
        
        let gradientColors: [UIColor] = [UIColor(hexString: "#7B73EF")!, UIColor(hexString: "#C76ADE")!]
        addGradientToView(to: viewUserCountry, cornerRadius: viewUserCountry.frame.height/2, colors: gradientColors)
        addGradientToView(to: viewUserID, cornerRadius: viewUserID.frame.height/2, colors: gradientColors)
        
       // addGradientToView(to: viewUserID, width: viewUserID.frame.width, height: viewUserID.frame.height, cornerRadius: viewUserID.frame.height/2, colors: gradientColors)
        
    }
    
    func setData() {
        
        if (viewFrom == "message") {
            
            lblUserName.text = messageDetails.nickName
            lblUserRichLevel.text = "Lv." + " " +  (messageDetails.richLevel ?? "0")
            lblUserCharmLevel.text = "Lv." + " " + (messageDetails.charmLevel ?? "0")
            lblUserAge.text = "24"
            lblUserCountry.text = "India"
            lblUserId.text = "ID:" + " " + (messageDetails.userID ?? "N/A")
            
            if (messageDetails.gender == 1) {
                imgViewUserGender.image = UIImage(named: "MaleBackgroundImage")
            } else {
                imgViewUserGender.image = UIImage(named: "FemaleBackgroundImage")
            }
            
            if let imageURL = URL(string: messageDetails.faceURL ?? "") {
                KF.url(imageURL)
                //  .downsampling(size: CGSize(width: 200, height: 200))
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
            //        lblUserRichLevel.text = "Lv." + " " +  (broadGroupJoinuser.richLevel ?? "0")
            //        lblUserCharmLevel.text = "Lv." + " " + (broadGroupJoinuser.charmLevel ?? "0")
            lblUserAge.text = "24"
            lblUserCountry.text = "India"
            lblUserId.text = "ID:" + " " + (broadGroupJoinuser.userID ?? "N/A")
            
            if (broadGroupJoinuser.gender.rawValue == 1) {
                imgViewUserGender.image = UIImage(named: "MaleBackgroundImage")
            } else {
                imgViewUserGender.image = UIImage(named: "FemaleBackgroundImage")
            }
            
            if let imageURL = URL(string: broadGroupJoinuser.faceURL ?? "") {
                KF.url(imageURL)
                //  .downsampling(size: CGSize(width: 200, height: 200))
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
    
    func configureToClose() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewMain)
        
        // Check if the tap was inside viewBottom or not
        if viewMain.bounds.insetBy(dx: -50, dy: -50).contains(location) {
            // The tap occurred inside viewBottom, handle accordingly (if needed)
            // For example, perform an action or do nothing
            print("View main par tap hua hai")
            
        } else {
            
            print("View main par tap nahi hua hai")
            // The tap occurred outside viewBottom, dismiss the view controller
            broadGroupJoinuser = V2TIMUserFullInfo()
            dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
       
        broadGroupJoinuser = V2TIMUserFullInfo()
               delegate = nil
               viewFrom = ""
               messageDetails = joinedGroupUserProfile()
        
    }
}

// MARK: - EXTENSION FOR API CALLING

extension JoinedAudienceDetailsViewController {
    
    func checkForFollow() {
        
        var url: String = ""
        
        if (viewFrom != "group") {
    
            guard let id = messageDetails.userID else {
                print("Error: profileID is nil.")
                return
            }
            url = "https://zeep.live/api/checkfollowbyyou?profile_id=\(id)"
            
        } else {
  
            guard let id = broadGroupJoinuser.userID else {
                print("Error: profileID is nil.")
                return
            }
             url = "https://zeep.live/api/checkfollowbyyou?profile_id=\(id)"
        }
        
      
            
        print("The URL is: \(url)")
        
        ApiWrapper.sharedManager().checkForFollow(url: url, completion: { [weak self] (data) in
            guard let self = self else {
                // The object has been deallocated
               
                return
            }
                print(data)
                print("Sab kuch sahi hai")
                
            if (data["success"] as? Bool == true) {
                
                print("Api se response true aaya hai. matlab data aaya hai.")
               
                if let followed = data["result"] as? Int {
                    
                   hostFollowed = followed
                    
                    if (hostFollowed == 0) {
                        print("Host ko follow nahi kiya hai.")
                        btnFollowUserOutlet.isHidden = false
                    } else {
                        print("Host ko pehle se follow kiya hai.")
                        btnFollowUserOutlet.isHidden = true
                    }
                }
                
              
            } else {
                
                print("Api se response mai false aaya hai. matlab kuch gadbad hai.")
               
                
            }
                
           
        })
    }
    
    func follow(id:String) {
      
      let params = [
          "following_id": id//26354605
         
      ] as [String : Any]
      
      
      ApiWrapper.sharedManager().followUser(url: AllUrls.getUrl.followUser,parameters: params) { [weak self] (data) in
          guard let self = self else { return }
          
          if (data["success"] as? Bool == true) {
              print(data)
           
              print("sab shi hai. kuch gadbad nahi hai")
         //     showAlertwithButtonAction(title: "SUCCESS !", message: "Your Profile has been updated successfully", viewController: self)
              
          }  else {
              
              print("Kuch gadbad hai")
              
          }
      }
  }
    
}
