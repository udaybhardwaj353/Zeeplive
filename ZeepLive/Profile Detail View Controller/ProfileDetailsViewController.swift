//
//  ProfileDetailsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 06/07/23.
//

import UIKit
import Kingfisher


class ProfileDetailsViewController: UIViewController, delegateInfoCollectionViewCell {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var btnOptionsOutlet: UIButton!
    
    @IBOutlet weak var btnInfoOutlet: UIButton!
    @IBOutlet weak var btnMomentsOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnReportProfileOutlet: UIButton!
    
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btnMessageOutlet: UIButton!
    @IBOutlet weak var btnVideoCallOutlet: UIButton!
    
    
    lazy var userID = String()
    lazy var userName = String()
    lazy var userCity = String()
    lazy var userGender = String()
    lazy var userDateOfBirth = String()
    lazy var userLevel = Int()
    lazy var userDetails = [userProfileDetailsResult]()
   
    lazy var overLayer: CustomAlertViewController? = nil
    lazy var giftDetails = [giftRecievedResult]()
    var callForProfileId: Bool = false
    lazy var hostFollowed = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
       //userId = "1311698"//UserDefaults.standard.string(forKey: "UserId") ?? "" // MARK: - PARI USER ID FOR INFORMATION
        print("The user id of the user in Profile Detail is \(userID)")
        print(UserDefaults.standard.string(forKey: "token"))
        print(UserDefaults.standard.string(forKey: "UserProfileId"))
        print(UserDefaults.standard.string(forKey: "userId"))
        
//        if (userId == (UserDefaults.standard.string(forKey: "UserProfileId") ?? "0")) || userId == (UserDefaults.standard.string(forKey: "UserId") ?? "0"){
//        
//            viewButtons.isHidden = true
//            
//        } else {
//            
//            viewButtons.isHidden = false
//            
//        }
        
        if let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId"),
           let userId = UserDefaults.standard.string(forKey: "UserId"),
           userId == userProfileId || userId == userID {
            viewButtons.isHidden = true
        } else {
            viewButtons.isHidden = false
        }

        
        if (callForProfileId == false) {
            getUserDetails()
            getGiftDetails()
        } else {
            checkForFollow()
            getUserProfileID()
        }
    }
    
    private func configureUI() {
        
        collectionView.register(UINib(nibName: "GiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftCollectionViewCell")
        collectionView.register(UINib(nibName: "InfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InfoCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        btnInfoOutlet.setTitleColor(.black, for: .normal)
        btnMomentsOutlet.setTitleColor(.lightGray, for: .normal)
        
        btnInfoOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        btnMomentsOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderViewIdentifier")
       
        addGradient(to: btnMessageOutlet, width: btnMessageOutlet.frame.width, height: btnMessageOutlet.frame.height, cornerRadius: btnMessageOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
        addGradient(to: btnVideoCallOutlet, width: btnVideoCallOutlet.frame.width, height: btnVideoCallOutlet.frame.height, cornerRadius: btnVideoCallOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.buttonVideoCallFirstColour(), endColor: GlobalClass.sharedInstance.buttonVideoCallSecondColour())
        
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
    
 // MARK: - FUNCTION TO SHOW OPTIONS FROM BELOW THE SCREEN ON THE CLICK OF OPTIONS BUTTON
    
    private func showOptionsFromBelow() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

           let followButton = UIAlertAction(title: "Follow", style: .default, handler: { (action) -> Void in
               print("Follow button tapped")
               self.follow()
           })

           let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
               print("Cancel button tapped")
           })

           alertController.addAction(followButton)
           alertController.addAction(cancelButton)

        self.navigationController?.present(alertController, animated: true, completion: nil)
        
    }
    
 // MARK: - BUTTONS ACTIONS AND THIER WORKING WHEN PRESSED
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        callForProfileId = false
        
    }
    
    @IBAction func btnOptionsPressed(_ sender: Any) {
        
        print("Button Options Pressed")
        showOptionsFromBelow()
        
    }
    
    @IBAction func btnReportProfilePressed(_ sender: Any) {
        
        print("Report Profile Button Pressed")
        overLayer = CustomAlertViewController()
        overLayer?.appear(sender: self, userId: Int(userID) ?? 0)
        
    }
    
    @IBAction func btnInfoPressed(_ sender: Any) {
        
        print("Button Info Pressed")
        btnInfoOutlet.setTitleColor(.black, for: .normal)
        btnMomentsOutlet.setTitleColor(.lightGray, for: .normal)
        
        btnInfoOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        btnMomentsOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
    }
    
    @IBAction func btnMomentsPressed(_ sender: Any) {
        
        print("Button Moments Pressed")
        btnMomentsOutlet.setTitleColor(.black, for: .normal)
        btnInfoOutlet.setTitleColor(.lightGray, for: .normal)
        
        btnMomentsOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        btnInfoOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
    }
    
    @IBAction func btnMessagePressed(_ sender: Any) {
        print("Button Message Pressed")
      
        let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId")
        
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
            //navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnVideoCallPressed(_ sender: Any) {
        print("Button Video Call Pressed")
    }
    
    deinit {
        
        collectionView.dataSource = nil
        collectionView.delegate = nil
        collectionView = nil
        userDetails.removeAll()
        giftDetails.removeAll()
        overLayer?.removeFromParent()
        overLayer = nil
        print("ProfileDetailsViewController deallocated")
        
    }
    
}

// MARK: - EXTENSION FOR USING COLLECTION VIEW DELEGATES AND DATASOURCE METHODS AND THEIR FUNCTIONALITIES

extension ProfileDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

// MARK: - FUNCTION TO GIVE HEIGHT OF HEADER VIEW
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 1) {
            return CGSize(width: collectionView.bounds.width, height: 50.0)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
 
 // MARK: - FUNCTION TO SHOW HEADER VIEW AND REGISTER IT
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (indexPath.section == 1) {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderViewIdentifier", for: indexPath)
                
                // Customize the section header view
                headerView.backgroundColor = UIColor.white
                
                // Create a label and set the title for the section header
                let titleLabel = UILabel(frame: headerView.bounds)
                titleLabel.text = "Gift Recieved"
                titleLabel.textAlignment = .left
                titleLabel.textColor = UIColor.black
                titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
                // Add the label to the section header view
                headerView.addSubview(titleLabel)
                
                return headerView
            }
            
        } else {
            
            return UICollectionReusableView()
        }
            
            return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return userDetails.count
        } else {
            
            return giftDetails.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.section == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as! InfoCollectionViewCell
            print("The image url is: \(userDetails.first?.femaleImages?.first?.imageName)")
            
            if let profileImageURL = URL(string: userDetails.first?.femaleImages?.first?.imageName ?? "") {
                KF.url(profileImageURL)
                  //  .downsampling(size: CGSize(width: 200, height: 200))
                    .cacheOriginalImage()
                    .onSuccess { result in
                        DispatchQueue.main.async {
                            cell.imgViewUserPhoto.image = result.image
                        }
                    }
                    .onFailure { error in
                        print("Image loading failed with error: \(error)")
                        cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                    }
                    .set(to: cell.imgViewUserPhoto)
            } else {
                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
            
            if (userDetails[indexPath.row].gender == "male") {
                
                cell.imgViewUserAge.image = UIImage(named: "MaleBackgroundImage")
                
            }  else {
                
                cell.imgViewUserAge.image = UIImage(named: "FemaleBackgroundImage")
                
            }
            
            if (userDetails[indexPath.row].isOnline == 0) {
                
                cell.lblUserStatus.text = "Offline"
                cell.viewUserStatus.backgroundColor = GlobalClass.sharedInstance.setWalletDetailsBackgroundPaymentStatusRedColour()
                
            } else {
                
                cell.lblUserStatus.text = "Online"
                cell.viewUserStatus.backgroundColor = .systemGreen//GlobalClass.sharedInstance.setWalletDetailsBackgroundPaymentStatusGreenColour()
                
            }
            
            let a: Int = userDetails[indexPath.item].id ?? 0
            var b : String = String(a)
            
            let c: Int = userDetails[indexPath.item].level ?? 0
            var d : String = String(c)
            
            cell.lblUserName.text = userDetails[indexPath.row].name
            cell.lblUserCountry.text = userDetails[indexPath.row].city
            cell.lblUserId.text = "ID:" + " " + b
            cell.lblLevelName.text = "Rich"
            cell.lblLevel.text = "Lv." + " " + d
            
            if let yearDifference = calculateYearDifference(from: userDetails[indexPath.row].dob ?? " ") {
                print("Year difference: \(yearDifference)")
                cell.lblUserAge.text = String(yearDifference)
            } else {
                cell.lblUserAge.text = "0"
                print("Invalid date format")
            }
            
            if (hostFollowed == 0) {
                
                cell.btnFollowOutlet.isHidden = false
            } else {
                
                cell.btnFollowOutlet.isHidden = true
            }
            
            cell.delegate = self
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCollectionViewCell", for: indexPath) as! GiftCollectionViewCell
            
            cell.lblNoOfGifts.text = "x" + " " + String(giftDetails[indexPath.row].total ?? 0)
            
            if let profileImageURL = URL(string: giftDetails[indexPath.row].giftDetails?.image ?? "") {
                KF.url(profileImageURL)
                    .downsampling(size: CGSize(width: 300, height: 300))
                    .cacheOriginalImage()
                    .onSuccess { result in
                        DispatchQueue.main.async {
                            cell.imgViewGift.image = result.image
                        }
                    }
                    .onFailure { error in
                        print("Image loading failed with error: \(error)")
                        cell.imgViewGift.image = UIImage(named: "GiftImage")
                    }
                    .set(to: cell.imgViewGift)
            } else {
                cell.imgViewGift.image = UIImage(named: "GiftImage")
            }
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (indexPath.section == 0) {
            let width : CGFloat = collectionView.bounds.width
            let height : CGFloat = 270
            return CGSize(width: width, height: height)
        } else {
            
            let width = (collectionView.bounds.size.width - 10 * 6 ) / 5
            let height : CGFloat = 130
            return CGSize(width: width, height: height)
            
        }
    }
   
    func buttonFollowPressed(isPressed: Bool) {
        
        print(isPressed)
        follow()
        
    }
    
    func reloadSectionZero() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM SERVER

extension ProfileDetailsViewController {
   
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
          
            if let imageName = userDetails.first?.femaleImages?.first?.imageName,
                   let imageURL = URL(string: imageName) {
                    downloadImage(from: imageURL, into: imgViewUserPhoto)
                       
            } else {
            
                    imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                
                  }
            
            print("the user details in the profile details is: \(userDetails)")
            print("The user gender here is: \(userDetails.first?.gender?.lowercased())")
            
            if (userDetails.first?.gender?.lowercased() == "male") {
                
                btnVideoCallOutlet.isHidden = true
                
            } else {
                
                btnVideoCallOutlet.isHidden = false
                
            }
            
            collectionView.reloadData()
        }
    }
    
 // MARK: - FUNCTION TO CALL API TO GET GIFT RECIEVED LIST FROM THE SERVER
    
    func getGiftDetails() {
        
        let url = AllUrls.baseUrl + "get-gift-count?id=\(userID)" //"https://zeep.live/api/get-gift-count-latest?id=32314422"//AllUrls.baseUrl + "get-gift-count?id=\(userId)"
        print(url)
        
        ApiWrapper.sharedManager().getGiftRecievedList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
        
            giftDetails = data ?? []
            print(giftDetails)
            
            collectionView.reloadData()
            
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
                        getGiftDetails() 
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
                      
                    } else {
                        print("Host ko pehle se follow kiya hai.")
                       
                    }
                }
                reloadSectionZero()
              
            } else {
                
                print("Api se response mai false aaya hai. matlab kuch gadbad hai.")
               
                
            }
                
        })
    }
    
}
