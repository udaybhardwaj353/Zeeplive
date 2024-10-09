//
//  NewProfileDetailViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/04/24.
//

import UIKit
import Kingfisher
import RealmSwift
import SwiftyJSON

class NewProfileDetailViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnShowOptionsOutlet: UIButton!
    @IBOutlet weak var btnReportProfileOutlet: UIButton!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btnMessageOutlet: UIButton!
    @IBOutlet weak var btnVideoCallOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var id: String = ""
    lazy var userID: String = ""
    lazy var userDetails = [userProfileDetailsResult]()
    lazy var hostFollowed = Int()
    lazy var callForProfileId: Bool = false
    lazy var overLayer: CustomAlertViewController? = nil
    lazy var isBlocked: Bool = false
    lazy var OneToOneCallData = GetOneToOneNotificationDataResult()
    lazy var malePointsData = MaleBalance()
    lazy var femalePointsData = FemaleBalance()
    
    let realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("profileMoment"), object: nil)
        
        id = userID
        print("The id here is: \(id)")
        if (id == "0") {
            isBlocked = true
            viewButtons.isHidden = true
            btnReportProfileOutlet.isHidden = true
        } else {
            
            isBlocked = false
            viewButtons.isHidden = false
            btnReportProfileOutlet.isHidden = false
            
        }
        
        print("The user id of the user in Profile Detail is \(userID)")
        print(UserDefaults.standard.string(forKey: "token"))
        print(UserDefaults.standard.string(forKey: "UserProfileId"))
        print(UserDefaults.standard.string(forKey: "userId"))
        let userIdToCheck = userID
        let userBlocked = isUserBlocked(userIdToCheck: userIdToCheck)
        print("User with ID \(userIdToCheck) is blocked: \(userBlocked)")
        
        configureUI()
        tableViewWork()
        
        if (userBlocked == true) {
            print("KUch bhi data nahi dikhana hai.")
            isBlocked = true
            viewButtons.isHidden = true
            btnReportProfileOutlet.isHidden = true
        } else {
           isBlocked = false
            btnReportProfileOutlet.isHidden = false
            loadData()
            
        }
        
        let userProfileId = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        let userid = (UserDefaults.standard.string(forKey: "userId") ?? "")
        
        if (userID == userid) || (userID == userProfileId) {
            
            print("Options ko hide kra denge upar walon ko.")
            btnShowOptionsOutlet.isHidden = true
            btnReportProfileOutlet.isHidden = true
            viewButtons.isHidden = true
            
        } else {
        
            print("Options ko hide nahi kraenge upar walon ko.")
            btnShowOptionsOutlet.isHidden = false
            btnReportProfileOutlet.isHidden = false
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        
    }
    
    @objc func handleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            // Access the data sent with the notification using userInfo
            if let value1 = userInfo["momentData"] as? MomentResult,
               let value2 = userInfo["currentIndex"] as? Int,
               let value3 = userInfo["pageNo"] as? Int,
               let value4 = userInfo["lastPageNo"] as? Int,
               let value5 = userInfo["cameFrom"] as? String {
                // Handle the received data
                print("Received notification with values:")
                print("Value1: \(value1)")
                print("Value2: \(value2)")
                print("Value3: \(value3)")
                print("Value4: \(value4)")
                print("Value5: \(value5)")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReelsViewController") as! ReelsViewController
                nextViewController.momentData = value1
                nextViewController.currentIndex = value2
                nextViewController.pageNo = value3
                nextViewController.lastPageNo = value4
                nextViewController.cameFrom = value5//"profile"
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
            }
        }
    }    

    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed.")
        callForProfileId = false
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnShowOptionsPressed(_ sender: Any) {
        
        print("Button Show Options From Below Pressed.")
        showOptionsFromBelow()
        
    }
    
    @IBAction func btnReportProfilePressed(_ sender: Any) {
        
        print("Button Report Profile Pressed.")
        overLayer = CustomAlertViewController()
        overLayer?.appear(sender: self, userId: Int(userID) ?? 0)
        
    }
    
    @IBAction func btnMessagePressed(_ sender: Any) {
        
        print("Button Message Pressed.")
        let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId")
        
        if !userDetails.isEmpty {
            if (userProfileId == String(userDetails[0].profileID ?? 0)) {
                
                print("User message nahi kar sakta khud ko")
                showAlert(title: "ERROR!", message: "You cannot message yourself.", viewController: self)
                
            } else {
                
                let vc = ChatViewController()
                vc.title = "Chatting"
                vc.recieverUserId = String(userDetails[0].profileID ?? 0)
                vc.recieverUserName = userDetails[0].name ?? "N/A"
                vc.recieverUserImage = userDetails.first?.femaleImages?.first?.imageName ?? ""
                // present(vc, animated: true, completion: nil)
                if let navigationController = navigationController {
                    navigationController.pushViewController(vc, animated: true)
                } else {
                    // If there's no navigation controller, create one and push the view controller
                    let newNavigationController = UINavigationController(rootViewController: vc)
                    present(newNavigationController, animated: true, completion: nil)
                }
            }
        } else {
            print("User Details amin kuch bhi nahi hai abhi.")
            showAlert(title: "ERROR!", message: "Please wait..!", viewController: self)
        }
        
    }
    
    @IBAction func btnVideoCallPressed(_ sender: Any) {
        
        print("Button Video Call Pressed.")
//        oneToOneCallDial()
        getPoints()
        
    }
    
    func startOneToOneCallWork() {
      
        let userCoins = UserDefaults.standard.string(forKey: "coins")
        print("The User Coins is: \(userCoins)")
        
        let hostCallRate = userDetails.first?.callRate ?? 0 //usersList.data?[indexSelected].newCallRate ?? 0
        print("The host call rate is: \(hostCallRate)")
        
        let coinForHostCall = (hostCallRate * 60)
        print("The coin required for calling host is: \(coinForHostCall)")
        
        if ((Int(userCoins ?? "0") ?? 0) >= (Int(coinForHostCall))) {
            
            print("User ke wallet main balance hai. Call lga lenge hum log")
            print("The User Coins in integer is: \(Int(userCoins ?? "0") ?? 0)")
            oneToOneCallDial()
         //   oneToOneCallDialInBroad()
            
        } else {
            
            print("User ke wallet main balance nahi hai. Call nahi lgegi.")
            
            showAlert(title: "ERROR!", message: "Sorry, you don't have enough balance to initiate call", viewController: self)
           
        }
        
    }
    
    deinit {
        print("Deinit call hua hai new profile detail view controller main.")
        NotificationCenter.default.removeObserver(self)
    }

}

extension NewProfileDetailViewController: UIScrollViewDelegate {
    
    func configureUI() {
    
        tabBarController?.tabBar.isHidden = true
        
        addGradient(to: btnMessageOutlet, width: btnMessageOutlet.frame.width, height: btnMessageOutlet.frame.height, cornerRadius: btnMessageOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
        addGradient(to: btnVideoCallOutlet, width: btnVideoCallOutlet.frame.width, height: btnVideoCallOutlet.frame.height, cornerRadius: btnVideoCallOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.buttonVideoCallFirstColour(), endColor: GlobalClass.sharedInstance.buttonVideoCallSecondColour())
       
        let userProfileId = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        let userid = (UserDefaults.standard.string(forKey: "userId") ?? "")
        
        if (userID == userid) || (userID == userProfileId) {
            
            print("Options ko hide kra denge upar walon ko.")
            btnShowOptionsOutlet.isHidden = true
            btnReportProfileOutlet.isHidden = true
            
        } else {
        
            print("Options ko hide nahi kraenge upar walon ko.")
            btnShowOptionsOutlet.isHidden = false
            btnReportProfileOutlet.isHidden = false
            
        }
        
//        viewButtons.isUserInteractionEnabled = false
//        btnMessageOutlet.isUserInteractionEnabled = false
//        btnVideoCallOutlet.isUserInteractionEnabled = false
        
        
    }
    
    func tableViewWork() {
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "NewProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "NewProfileDetailTableViewCell")
        
    }
    
    func loadData() {
    
        if let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId"),
           let userId = UserDefaults.standard.string(forKey: "UserId"),
           userId == userProfileId || userId == userID {
            viewButtons.isHidden = true
            btnReportProfileOutlet.isHidden = true
            btnShowOptionsOutlet.isHidden = true
        } else {
            viewButtons.isHidden = false
            btnReportProfileOutlet.isHidden = false
        }

        
        if (callForProfileId == false) {
            getUserDetails()
           // getGiftDetails()
        } else {
            
            let userFollow = GlobalClass.sharedInstance.isUserFollowed(userIdToCheck: userID)
            print("User with ID \(userID) is followed: \(userFollow)")
            
            if (userFollow == true) {
                hostFollowed = 1
                print("User isko follow karta hai.")
            } else {
                
                checkForFollow()
            }
            
            //checkForFollow()
            getUserProfileID()
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let yOffset = tblView.contentOffset.y
            print("Table view scrolled vertically by \(yOffset) points.")
        if (yOffset >= 200) {
            
          print("Table viewko scroll mat krao.")
           // tblView.setContentOffset(CGPoint(x: 0, y: 400), animated: false)
            viewTop.isHidden = true
        } else {
            
           print("Table view ko scroll kara do.")
            viewTop.isHidden = false
        }
    }
    
    // MARK: - FUNCTION TO SHOW OPTIONS FROM BELOW THE SCREEN ON THE CLICK OF OPTIONS BUTTON
       
        func showOptionsFromBelow() {
           
           let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           var blockButton = UIAlertAction()
           var followButton = UIAlertAction()
            
            if (isBlocked == true) {
                
                blockButton = UIAlertAction(title: "UnBlock", style: .default, handler: { (action) -> Void in
                    print("UnBlock button tapped")
                    self.callForProfileId = false
                    self.removeUserFromBlockList(userIdToRemove: self.id)
                    self.isBlocked = false
                    self.loadData()
                    self.block()
                    
                })
                
            } else {
                blockButton = UIAlertAction(title: "Block", style: .default, handler: { (action) -> Void in
                    print("Block button tapped")
                    self.userDetails.removeAll()
                    self.btnReportProfileOutlet.isHidden = true
                    self.viewButtons.isHidden = true
                    self.saveUserToBlockList(userID: self.id)
                    self.isBlocked = true
                    self.block()
                    self.tblView.reloadData()
                    
                })
            }
            
            if (hostFollowed == 0) {
                followButton = UIAlertAction(title: "Follow", style: .default, handler: { (action) -> Void in
                    print("Follow button tapped")
                    if (self.isBlocked == true) {
                        self.showAlert(title: "ERROR!", message: "Sorry you have blocked the user. So you cannot follow the user.", viewController: self)
                    } else {
                        self.follow()
                        self.hostFollowed = 1
                        GlobalClass.sharedInstance.saveUserToFollowList(profileID: self.userID)
                    }
                })
            } else {
                followButton = UIAlertAction(title: "UnFollow", style: .default, handler: { (action) -> Void in
                    print("Follow button tapped")
                    if (self.isBlocked == true) {
                        self.showAlert(title: "ERROR!", message: "Sorry you have blocked the user. So you cannot unfollow the user.", viewController: self)
                    } else {
                        self.follow()
                        self.hostFollowed = 0
                        GlobalClass.sharedInstance.removeUserFromFollowList(userIdToRemove: self.userID)
                    }
                })
                
            }
            
              let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                  print("Cancel button tapped")
              })

              alertController.addAction(blockButton)
              alertController.addAction(followButton)
              alertController.addAction(cancelButton)

           self.navigationController?.present(alertController, animated: true, completion: nil)
           
       }
    
}

extension NewProfileDetailViewController {
    
    func isUserBlocked(userIdToCheck: String) -> Bool {
        // Get the current userSelfId from UserDefaults
        guard let currentUserSelfId = UserDefaults.standard.string(forKey: "UserProfileId"), !currentUserSelfId.isEmpty else {
            // Return false if no userSelfId is found in UserDefaults
            return false
        }

        guard let realm = realm else {
            print("Realm not found")
            return false
        }
        
        // Query objects where userSelfId matches the value from UserDefaults
        let userBlockListsForSelfId = realm.objects(userBlockList.self)
            .filter("userBlockSelfId == %@", currentUserSelfId)

        // Check if any objects exist for the current user
        guard !userBlockListsForSelfId.isEmpty else {
            // If no object matches userSelfId, return false
            return false
        }

        // If userSelfId matches, check for the userId (userIdToCheck)
        let userBlockListsWithUserId = userBlockListsForSelfId
            .filter("userId == %@", userIdToCheck)

        // Return true if an object with the specified userId exists, false otherwise
        return !userBlockListsWithUserId.isEmpty
        
    }

    
//    func isUserBlocked(userIdToCheck: String) -> Bool {
//        
//        // Query objects based on userId
//        let userBlockListsWithUserId = realm.objects(userBlockList.self).filter("userId == %@", userIdToCheck)
//
//        // Check if any objects match the criteria
//        if userBlockListsWithUserId.isEmpty {
//            // No object with the specified userId exists
//            return false
//        } else {
//            // An object with the specified userId exists
//            return true
//        }
//    }
    
    func saveUserToBlockList(userID:String = "") {
        
        guard let realm = realm else {
            print("Realm not found")
            return
        }
        
            do {
                try realm.write {
                    let blockList = userBlockList()
                    
                    // Set the properties of the object
                    blockList.userId = userID
                    blockList.profileId = ""
                    blockList.userName = ""
                    blockList.isBlocked = true
                    blockList.userBlockSelfId = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                    
                    realm.add(blockList)
                }
                
            } catch let error as NSError {
                print("Error creating user details: \(error)")
            }
        
    }
    
    func removeUserFromBlockList(userIdToRemove: String) {
        // Get the default Realm instance
        let realm = try! Realm()

        // Begin a write transaction
        try! realm.write {
            // Query the object to remove based on userId
            let userBlockListsWithUserId = realm.objects(userBlockList.self).filter("userId == %@", userIdToRemove)

            // Check if any objects match the criteria
            if let userToRemove = userBlockListsWithUserId.first {
                // Delete the object from the Realm database
                realm.delete(userToRemove)
                print("User with ID \(userIdToRemove) removed from block list.")
                isBlocked = false
            } else {
                print("User with ID \(userIdToRemove) not found in block list.")
            }
        }
    }

}

// MARK: - EXTENSION FOR USING REALM MODEL FOR LOCAL CHECKING OF FOLLOW AND UNFOLLOW OF HOST BY THE USER

extension NewProfileDetailViewController {
    
    func isUserFollowed(userIdToCheck: String) -> Bool {
        
        guard let realm = realm else {
            print("Realm not found")
            return false
        }
        
        // Query objects based on userId
        let userFollowListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", userIdToCheck)

        // Check if any objects match the criteria
        if userFollowListsWithUserId.isEmpty {
            // No object with the specified userId exists
            return false
        } else {
            // An object with the specified userId exists
            return true
        }
    }
    
    func saveUserToFollowList(profileID:String = "") {
        
        guard let realm = realm else {
            print("Realm not found")
            return
        }
        
        let userFollowListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", profileID)

        // Check if any objects match the criteria
        if userFollowListsWithUserId.isEmpty {
            do {
                try realm.write {
                    let followList = userFollowList()
                    
                    // Set the properties of the object
                    followList.userId = ""
                    followList.profileId = profileID
                    
                    realm.add(followList)
                }
                
            } catch let error as NSError {
                print("Error creating user details: \(error)")
            }
        } else {
            print("User Follow List main pehle se hi hai. Phir se Add karne ki jrurat nahi hai.")
        }
        
    }
    
    func removeUserFromFollowList(userIdToRemove: String) {
        // Get the default Realm instance
       // let realm = try! Realm()

        guard let realm = realm else {
            print("Realm not found")
            return
        }
        
        do {
            // Begin a write transaction
            try realm.write {
                // Query the object to remove based on userId
                let userBlockListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", userIdToRemove)
                
                // Check if any objects match the criteria
                if let userToRemove = userBlockListsWithUserId.first {
                    // Delete the object from the Realm database
                    realm.delete(userToRemove)
                    print("User with ID \(userIdToRemove) removed from block list.")
                } else {
                    print("User with ID \(userIdToRemove) not found in block list.")
                }
            }
        } catch {
            print("User not removed from follow list in new profile detail view controller.")
        }
    }

}

extension NewProfileDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return userDetails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewProfileDetailTableViewCell", for: indexPath) as! NewProfileDetailTableViewCell
        
        if let firstUserDetails = userDetails.first {
            
            cell.hostFollowed = hostFollowed
            cell.userID = userID
            cell.richLevel = (firstUserDetails.richLevel ?? 0)
            cell.charmLevel = (firstUserDetails.charmLevel ?? 0)
            cell.setData()
            
            cell.lblUserName.text = firstUserDetails.name
            cell.lblUserID.text = "ID: \(firstUserDetails.profileID ?? 0)"//"ID: \(firstUserDetails.id ?? 0)"
            cell.lblFriendCount.text = "\(firstUserDetails.friendCount ?? 0)"
            cell.lblFollowingCount.text = "\(firstUserDetails.followingCount ?? 0)"
            cell.lblFollowersCount.text = "\(firstUserDetails.followerCount ?? 0)"
            cell.lblUserCountry.text = firstUserDetails.city ?? "N/A"

            if firstUserDetails.isOnline == 0 {
                cell.lblUserStatus.text = "Offline"
                cell.viewUserStatus.backgroundColor = GlobalClass.sharedInstance.setWalletDetailsBackgroundPaymentStatusRedColour()
            } else {
                cell.lblUserStatus.text = "Online"
                cell.viewUserStatus.backgroundColor = .systemGreen
            }

            if let dob = firstUserDetails.dob, let yearDifference = calculateYearDifference(from: dob) {
                cell.lblUserAge.text = "\(yearDifference)"
            } else {
                cell.lblUserAge.text = "0"
                print("Invalid date format")
            }

            if let firstFemaleImage = firstUserDetails.femaleImages?.first {
                loadImage(from: firstFemaleImage.imageName ?? "", into: cell.imgViewUserPhoto)
                loadImage(from: firstFemaleImage.imageName ?? "", into: cell.imgViewUserProfilePhoto)
            } else {
                // Handle the case where there are no female images available
                // For example, you can set default images or hide the image views
            }

            if firstUserDetails.gender == "male" {
                cell.imgViewUserGender.image = UIImage(named: "MaleBackgroundImage")
            } else {
                cell.imgViewUserGender.image = UIImage(named: "FemaleBackgroundImage")
            }
        } else {
            // Handle the case where userDetails is empty
            // For example, you can set default values for all labels and image views
        }

        
            cell.selectionStyle = .none
            return cell
        
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
        let height = self.view.frame.height / 2
        print("The height returnign is: \(self.view.frame.height + height)")
        return self.view.frame.height + height
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM SERVER

extension NewProfileDetailViewController {
   
    func getUserDetails() {
        
        let url = AllUrls.baseUrl + "getprofiledata?id=\(userID)"
        print("The url that is going for profile detail is: \(url)")
        
        ApiWrapper.sharedManager().getUserProfileDetails(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            userDetails = data ?? userDetails
            print(userDetails)
            print(userDetails.first?.femaleImages?.first?.imageName)
            
            print("the user details in the profile details is: \(userDetails)")
            print("The user gender here is: \(userDetails.first?.gender?.lowercased())")
            
//            if (userDetails.first?.gender?.lowercased() == "male") {
//                
//                btnVideoCallOutlet.isHidden = true
//                viewButtons.isUserInteractionEnabled = true
//                btnMessageOutlet.isUserInteractionEnabled = true
//                btnVideoCallOutlet.isUserInteractionEnabled = false
//                
//            } else {
//                
//                viewButtons.isUserInteractionEnabled = true
//                btnMessageOutlet.isUserInteractionEnabled = true
//                btnVideoCallOutlet.isUserInteractionEnabled = true
//                btnVideoCallOutlet.isHidden = false
//                
//            }
            
//            viewButtons.isUserInteractionEnabled = true
//            btnMessageOutlet.isUserInteractionEnabled = true
//            btnVideoCallOutlet.isUserInteractionEnabled = true
            
            tblView.reloadData()
            
        }
    }
    
    
    // MARK: - FUNCTION FOR CALLING API TO FOLLOW THE USER
    
      func follow() {
        
        let params = [
            "following_id": userID//26354605
           
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
    
    // MARK: - FUNCTION FOR CALLING API TO BLOCK THE USER
    
      func block() {
        
        let params = [
            "blocked_id": userID//26354605
           
        ] as [String : Any]
        
        
        ApiWrapper.sharedManager().blockUsers(url: AllUrls.getUrl.blockUser,parameters: params) { [weak self] (data) in
            guard let self = self else { return }
            
            if (data["success"] as? Bool == true) {
                print(data)
             
                print("sab shi hai. kuch gadbad nahi hai. user ko block/unblock kar diya hai shi se.")
                
           //     showAlertwithButtonAction(title: "SUCCESS !", message: "Your Profile has been updated successfully", viewController: self)
                
            }  else {
                
                print("Kuch gadbad hai")
                
            }
        }
    }
    
    func getUserProfileID() {
        let url = AllUrls.baseUrl + "getdatabyprofileid?profile_id=\(userID)"
        
        ApiWrapper.sharedManager().getProfileID(url: url, completion: { [weak self] (data) in
            guard let self = self else {
                return // The object has been deallocated
            }

            if let success = data["success"] as? Bool, success {
                print("Sab kuch sahi hai")
                
                if let resultArray = data["result"] as? [[String: Any]], let profileData = resultArray.first {
                    print(profileData)
                    
                    if let id = profileData["id"] as? Int {
                        userID = String(id)
                        getUserDetails()
                      //  getGiftDetails()
                    }
                } else {
                    print("Result array is empty or couldn't extract profile data")
                }
            } else {
                if let error = data["error"] {
                    print(error)
                }
                print("Kuch error hai")
            }
        })
    }

    func checkForFollow() {
        
        let url = "https://zeep.live/api/checkfollowbyyou?profile_id=\(userID)"
        
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
                        GlobalClass.sharedInstance.removeUserFromFollowList(userIdToRemove: userID)
                    } else {
                        print("Host ko pehle se follow kiya hai.")
                        GlobalClass.sharedInstance.saveUserToFollowList(profileID: userID)
                    }
                }
              
            } else {
                
                print("Api se response mai false aaya hai. matlab kuch gadbad hai.")
               
                
            }
                
        })
    }
    
    func oneToOneCallDial() {
        
        showLoader()
        
        let connectingUserId = String(userDetails.first?.profileID ?? 0) //String(usersList.data?[currentIndex].profileID ?? 0)
        let hostCallRate = String(userDetails.first?.callRate ?? 1) //callRate//String(usersList.data?[currentIndex].newCallRate ?? 0)
        
        let currentDate = Date()
        let currentTimeStamp = String(currentDate.timeIntervalSince1970)
        
        let params = [
            "connecting_user_id": connectingUserId,//"229792703",
              "outgoing_time": currentTimeStamp,//"1710137930578",
              "convId": "0",
              "call_rate": hostCallRate,//"1.5",
              "is_free_call": "false",
              "rem_gift_cards": "0"
           
        ] as [String : Any]
        
        print("The params we are sending in New Profile Detail View Controller for fcm token is: \(params)")
        
        ApiWrapper.sharedManager().callOneToOneNotification(url: AllUrls.getUrl.oneToOneCallSendNotification,parameters: params ,completion: { [weak self] (data, value) in
            guard let self = self else {
                // The object has been deallocated
               
                return
            }
            
            hideLoader()
            
                print(data)
                print(value)
            
            
            OneToOneCallData = data ?? OneToOneCallData
            print("The one to one call data in new profile detail is: \(OneToOneCallData)")
            // Assuming you have already decoded your JSON response into GetOneToOneNotificationData instance

            if let receiverChannelName = OneToOneCallData.data?.receiverChannelName?.channelName {
                print("Receiver Channel Name: \(receiverChannelName)")
            } else {
                print("Receiver Channel Name not found")
            }

            if let senderChannelName = OneToOneCallData.data?.senderChannelName?.channelName {
                print("Sender Channel Name: \(senderChannelName)")
            } else {
                print("Sender Channel Name not found")
            }

            // Extracting unique_id
             let result = value["result"] as? [String: Any]
            let data = result?["data"] as? [String: Any]
            let uniqueID = data?["unique_id"] as? String
            print("Unique ID: \(uniqueID)")
            
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneCallViewController") as! OneToOneCallViewController
            
                    nextViewController.channelName = uniqueID ?? ""
                    nextViewController.cameFrom = "user"
                    nextViewController.hostName = userDetails.first?.name ?? ""
                    nextViewController.hostImage = userDetails.first?.femaleImages?.first?.imageName ?? ""
                    nextViewController.hostID = String(userDetails.first?.profileID ?? 0)
                    nextViewController.idHost = userID//String(usersList.data?[currentIndex].id ?? 0)
                    nextViewController.hostCallRate = String(userDetails.first?.callRate ?? 0)
                    nextViewController.uniqueID = uniqueID ?? ""
            
                    self.navigationController?.pushViewController(nextViewController, animated: true)
            hideLoader()
            
        })
        
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneCallViewController") as! OneToOneCallViewController
//
//        nextViewController.channelName = oneToOneUniqueID
//        nextViewController.cameFrom = "user"
//        nextViewController.hostName = usersList.data?[currentIndex].name ?? ""
//        nextViewController.hostImage = usersList.data?[currentIndex].profileImage ?? ""
//        nextViewController.hostID = String(usersList.data?[currentIndex].profileID ?? 0)
//        nextViewController.idHost = userID//String(usersList.data?[currentIndex].id ?? 0)
//        nextViewController.hostCallRate = callRate
//        nextViewController.uniqueID = oneToOneUniqueID
//        
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func getPoints() {
       
        ApiWrapper.sharedManager().getPointsDetails(url: AllUrls.getUrl.getPoints) { [weak self] (value) in
            guard let self = self else { return }
            
            let jsonData = JSON(value)
            print(jsonData)
            
            let gender = UserDefaults.standard.string(forKey: "gender")
            
            if (gender == "female") {
                
                if let decodeData = try? jsonData["result"].rawData() {
                    print(decodeData)
                    if let gaReportData = try? JSONDecoder().decode(femaleResult.self, from: decodeData) {
                        print(gaReportData)
                    }
                }
                
                // Decode and print 'femaleweeklyEarningBeansData' data
                if let decodeData1 = try? jsonData["weeklyEarningBeansData"].rawData() {
                    print(decodeData1)
                    if let gaReportData1 = try? JSONDecoder().decode(femaleWeeklyEarningBeansData.self, from: decodeData1) {
                        print(gaReportData1)
                        UserDefaults.standard.set(gaReportData1.weeklyEarningBeans , forKey: "weeklyearning")
                        print(gaReportData1.weeklyEarningBeans)
                    }
                }
                
                // Decode and print 'femaleBalance' data
                if let decodeData2 = try? jsonData["femaleBalance"].rawData() {
                    print(decodeData2)
                    if let gaReportData2 = try? JSONDecoder().decode(FemaleBalance.self, from: decodeData2) {
                        print(gaReportData2)
                        femalePointsData = gaReportData2
                        UserDefaults.standard.set(femalePointsData.purchasePoints , forKey: "coins")
                        UserDefaults.standard.set(femalePointsData.redeemPoint , forKey: "earning")
               //         UserDefaults.standard.set("100000" , forKey: "coins")
                        print(femalePointsData)
                      startOneToOneCallWork()
                    
                    }
                }
             
            } else {
                // Decode and print 'result' data
                if let decodeData = try? jsonData["result"].rawData() {
                    print(decodeData)
                    if let gaReportData = try? JSONDecoder().decode(maleResult.self, from: decodeData) {
                        print(gaReportData)
                    }
                }
                
                // Decode and print 'weeklyEarningBeansData' data
                if let decodeData1 = try? jsonData["weeklyEarningBeansData"].rawData() {
                    print(decodeData1)
                    if let gaReportData1 = try? JSONDecoder().decode(maleWeeklyEarningBeansData.self, from: decodeData1) {
                        print(gaReportData1)
                    }
                }
                
                // Decode and print 'maleBalance' data
                if let decodeData2 = try? jsonData["maleBalance"].rawData() {
                    print(decodeData2)
                    if let gaReportData2 = try? JSONDecoder().decode(MaleBalance.self, from: decodeData2) {
                        print(gaReportData2)
                        malePointsData = gaReportData2
                        UserDefaults.standard.set(malePointsData.purchasePoints , forKey: "coins")
                        UserDefaults.standard.set(malePointsData.earningRedeemPoint , forKey: "earning")
                  //      UserDefaults.standard.set("100000" , forKey: "coins")
                        print(malePointsData)
                       startOneToOneCallWork()
                       
                    }
                }
            }
        }
        
    }
    
}

//        cell.lblUserName.text = userDetails[indexPath.row].name
//        cell.lblUserID.text = "ID:" + " " + String(userDetails[indexPath.row].id ?? 0)
//        cell.lblFriendCount.text = String(userDetails[indexPath.row].friendCount ?? 0)
//        cell.lblFollowingCount.text = String(userDetails[indexPath.row].followingCount ?? 0)
//        cell.lblFollowersCount.text = String(userDetails[indexPath.row].followerCount ?? 0)
//        cell.lblUserCountry.text = userDetails[indexPath.row].city ?? "N/A"
//        if (userDetails[indexPath.row].isOnline == 0) {
//
//            cell.lblUserStatus.text = "Offline"
//            cell.viewUserStatus.backgroundColor = GlobalClass.sharedInstance.setWalletDetailsBackgroundPaymentStatusRedColour()
//
//        } else {
//
//            cell.lblUserStatus.text = "Online"
//            cell.viewUserStatus.backgroundColor = .systemGreen//GlobalClass.sharedInstance.setWalletDetailsBackgroundPaymentStatusGreenColour()
//
//        }
//        if let yearDifference = calculateYearDifference(from: userDetails[indexPath.row].dob ?? " ") {
//            print("Year difference: \(yearDifference)")
//            cell.lblUserAge.text = String(yearDifference)
//        } else {
//            cell.lblUserAge.text = "0"
//            print("Invalid date format")
//        }
//
//        loadImage(from: userDetails.first?.femaleImages?.first?.imageName ?? "", into: cell.imgViewUserPhoto)
//        loadImage(from: userDetails.first?.femaleImages?.first?.imageName ?? "", into: cell.imgViewUserProfilePhoto)
//
//        if (userDetails[indexPath.row].gender == "male") {
//
//            cell.imgViewUserGender.image = UIImage(named: "MaleBackgroundImage")
//
//        }  else {
//
//            cell.imgViewUserGender.image = UIImage(named: "FemaleBackgroundImage")
//
//        }

//func saveUserToBlockList(userID:String = "") {
//    let userDetails = realm.objects(userBlockList.self).filter("userId == %@", userID)
//    
//    if userDetails.isEmpty {
//        
//        do {
//            try realm.write {
//                let blockList = userBlockList()
//                
//                // Set the properties of the object
//                blockList.userId = userID
//                blockList.profileId = ""
//                blockList.userName = ""
//                blockList.isBlocked = true
//                
//                realm.add(blockList)
//            }
//            
//        } catch let error as NSError {
//            print("Error creating user details: \(error)")
//        }
//    } else {
//        
//        do {
//            try realm.write {
//                for userDetail in userDetails {
//                    
//                    // Set the properties of the object
//                    userDetail.userId = userID
//                    userDetail.profileId = ""
//                    userDetail.userName = ""
//                    userDetail.isBlocked = true
//                    realm.add(userDetail)
//                }
//            }
//        } catch let error as NSError {
//            print("Error saving message: \(error)")
//        }
//        
//    }
//}
