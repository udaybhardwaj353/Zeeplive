//
//  LiveRoomCellTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 08/01/24.
//

import UIKit
import Lottie
import Kingfisher
import ImSDK_Plus

protocol delegateLiveRoomCellTableViewCell: AnyObject {

        func giftButton(isPressed:Bool)
        func userDetailsPressed(selectedIndex: Int)
        func closeBroad(isPressed:Bool)
        func distributionClicked(openWebView:Bool)
        func viewRewardClicked(isClicked:Bool)
        func buttonAudienceList(isClicked:Bool)
        func cellIndexClicked(index:Int)
        func messageClicked(userImage:String , userName:String , userLevel:String, userID:String)
        func gameButtonClicked(isClicked:Bool)
        func micJoinedUserClicked(userID:String,userName:String, userImage:String)
        func buttonOneToOneCallPressed(isPressed:Bool)
        func buttonFollowPressed(isPressed:Bool)
        func buttonJoinMicPressed(isPressed:Bool)
        func buttonMicPressed(isPressed:Bool)
        func muteMic(isPressed:String)
}

class LiveRoomCellTableViewCell: UITableViewCell {

    lazy var headerView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: viewLiveMessage.frame.width, height: 100))
        v.backgroundColor = UIColor(hexString: "000000")?.withAlphaComponent(0.35)
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        let lab = UILabel(frame: CGRect(x: 9, y: 8, width: viewLiveMessage.frame.width - 18, height: 100 - 16))
        lab.backgroundColor = .clear
        lab.text = "Welcome to ZeepLive!! Please don't share inappropriate content like pornography or violence as it's strictly against our policy. Our AI system continuously monitors content to ensure compliance"
        lab.textColor = UIColor(hexString: "FFC300")
        lab.numberOfLines = 0
        lab.textAlignment = .left
        lab.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        v.addSubview(lab)
        v.isUserInteractionEnabled = false
        return v
    }()
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnMessageOutlet: UIButton!
    @IBOutlet weak var viewGiftOutlet: UIControl!
    @IBOutlet weak var btnGameOutlet: UIButton!
    @IBOutlet weak var btnGiftOutlet: UIButton!
    @IBOutlet weak var viewGift: UIView!
    
    weak var delegate: delegateLiveRoomCellTableViewCell?
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnSendMessageOutlet: UIButton!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var txtFldMessage: UITextField!
    @IBOutlet weak var viewMessageBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewUserDetailsOutlet: UIButton!
    @IBOutlet weak var imgViewUserProfilePhoto: UIImageView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblViewersCount: UILabel!
    @IBOutlet weak var btnFollowHostOutlet: UIButton!
    @IBOutlet weak var btnCloseBroadOutlet: UIButton!
    @IBOutlet weak var viewDistributionOutlet: UIButton!
    @IBOutlet weak var lblDistributionAmount: UILabel!
    @IBOutlet weak var viewRewardOutlet: UIButton!
    @IBOutlet weak var viewLiveMessage: UIView!
    @IBOutlet weak var tblViewLiveMessage: UITableView!
  
    @IBOutlet weak var viewLuckyGift: UIView!
    @IBOutlet weak var lblNoOfGift: UILabel!
    @IBOutlet weak var viewLuckyGiftDetails: UIView!
    @IBOutlet weak var viewUserImage: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var viewGiftImage: UIView!
    @IBOutlet weak var imgViewGift: UIImageView!
    @IBOutlet weak var lblSendGiftHostName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnViewAudienceOutlet: UIButton!
    @IBOutlet weak var viewUserRoomStatus: UIView!
    @IBOutlet weak var lblRoomUserName: UILabel!
    @IBOutlet weak var lblRoomUserStatus: UILabel!
    @IBOutlet weak var lblRewardRank: UILabel!
 //   @IBOutlet weak var viewRewardRank: UIView!
    @IBOutlet weak var viewRewardRank: UIButton!
    @IBOutlet weak var imgViewContributionTrophyImage: UIImageView!
    @IBOutlet weak var viewContributionTrophy: UIView!
    @IBOutlet weak var viewUserBusy: UIView!
    @IBOutlet weak var viewEndView: UIView!
    @IBOutlet weak var viewSwipeUpAnimation: UIView!
    @IBOutlet weak var viewSwipeFingerAnimation: UIView!
    @IBOutlet weak var viewEndUserDetails: UIView!
    @IBOutlet weak var imgViewEndUserDetail: UIImageView!
    @IBOutlet weak var lblEndViewUserName: UILabel!
    @IBOutlet weak var viewOneToOneCall: UIView!
    @IBOutlet weak var btnOneToOneCallOutlet: UIButton!
    @IBOutlet weak var viewMicJoinedUsersList: UIView!
    @IBOutlet weak var tblViewMicJoinedUsers: UITableView!
    @IBOutlet weak var btnFollowWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnJoinMicOutlet: UIButton!
    @IBOutlet weak var btnJoinMicWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var btnMuteMicOutlet: UIButton!
    @IBOutlet weak var imgViewContributionTrophy: UIImageView!
    @IBOutlet weak var btnGameWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnMuteMicWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewLiveAnimationOutlet: UIView!
    @IBOutlet weak var imgViewPlaceholderPhoto: UIImageView!
    
    var totalMsgData = liveMessageModel()
    var liveMessages: [liveMessageModel] = []
    var groupUsers = [joinedGroupUserProfile]()
    var timer: Timer?
    var dailyEarningBeans: String = ""
    var weeklyEarningBeans:String = ""
  lazy var lottieAnimationViews: [LottieAnimationView] = []
    var userInfoList: [V2TIMUserFullInfo]?
    lazy var profileID: Int = 0
    lazy var userID:Int = 0
    lazy var zegoMicUsersList: [getZegoMicUserListModel] = []
    var countdownTimer: Timer?
    lazy var totalTime = 15
    lazy var isJoinMicPressed: Bool = false
    lazy var isMuteMicButtonPressed = false
    lazy var muteMic = false
    lazy var isMicMutedByHost: Bool = false
    lazy var hostFollow: Int = 0
    lazy var groupID: String = ""
    var liveMessage = liveMessageModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblViewMicJoinedUsers.transform = CGAffineTransform(scaleX: 1, y: -1)
        txtFldMessage.delegate = self
        configureGiftView()
        configureUI()
        collecionViewWork()
        tableViewWorkOfJoinMicUsers()
        zegoMicUsersList.reverse()
        tblViewMicJoinedUsers.reloadData()
        
        lblName.isHidden = true
        print("The user ID we get in the cell is: \(userID)")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    deinit {
      
                zegoMicUsersList.removeAll()
                groupUsers.removeAll()
                liveMessages.removeAll()
                userInfoList?.removeAll()
                tblViewLiveMessage.dataSource = nil
                tblViewLiveMessage.delegate = nil
                collectionView.dataSource = nil
                collectionView.delegate = nil
                tblViewMicJoinedUsers.dataSource = nil
                tblViewMicJoinedUsers.delegate = nil
        
//        collectionView?.collectionViewLayout.invalidateLayout()
                collectionView.removeFromSuperview()
                totalMsgData = liveMessageModel()
        
                viewMain = nil
                imgView = nil
                lblName = nil
                viewBottom = nil
                btnMessageOutlet = nil
                viewGiftOutlet = nil
                btnGameOutlet = nil
                btnGiftOutlet = nil
                viewGift = nil
                
                delegate = nil
                viewMessage = nil
                btnSendMessageOutlet = nil
                viewTextField = nil
                txtFldMessage = nil
                viewMessageBottomConstraints = nil
                viewUserDetailsOutlet = nil
                imgViewUserProfilePhoto = nil
                lblHostName = nil
                lblViewersCount = nil
                btnFollowHostOutlet = nil
                btnCloseBroadOutlet = nil
                viewDistributionOutlet = nil
                lblDistributionAmount = nil
                viewRewardOutlet = nil
                viewLiveMessage = nil
                tblViewLiveMessage = nil
              
                viewLuckyGift = nil
                lblNoOfGift = nil
                viewLuckyGiftDetails = nil
                viewUserImage = nil
                imgViewUser = nil
                viewGiftImage = nil
                imgViewGift = nil
                lblSendGiftHostName = nil
                collectionView = nil
                btnViewAudienceOutlet = nil
                viewUserRoomStatus = nil
                lblRoomUserName = nil
                lblRoomUserStatus = nil
                lblRewardRank = nil
                viewRewardRank = nil
                imgViewContributionTrophyImage = nil
                viewContributionTrophy = nil
                viewUserBusy = nil
                viewEndView = nil
                viewSwipeUpAnimation = nil
                viewSwipeFingerAnimation = nil
                viewEndUserDetails = nil
                imgViewEndUserDetail = nil
                lblEndViewUserName = nil
                viewOneToOneCall = nil
        
        headerView.removeFromSuperview()
        print("Live video room table cell ka deinit call hua hai.")
        timer?.invalidate()
        removeLottieAnimationViews()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearCache() {
            // Completion block (optional)
            print("Saare cache clear hue hai")
        }
        lblViewersCount = nil
        NotificationCenter.default.removeObserver(self)
        headerView.removeFromSuperview()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        backgroundView = nil
        
    }
    
    func collecionViewWork() {
    
        collectionView.register(UINib(nibName: "BroadJoinCollectionViewCell2", bundle: nil), forCellWithReuseIdentifier: "BroadJoinCollectionViewCell2")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true

    }
    
    func tableViewWorkOfJoinMicUsers() {
    
        tblViewMicJoinedUsers?.register(UINib(nibName: "MicJoinedUsersTableViewCell", bundle: nil), forCellReuseIdentifier: "MicJoinedUsersTableViewCell")
        tblViewMicJoinedUsers.delegate = self
        tblViewMicJoinedUsers.dataSource = self
        
    }
    
    func configureUI() {
    
        let gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        
        if (gender.lowercased() == "male") {
        
            viewOneToOneCall.isHidden = false
        } else {
            
            viewOneToOneCall.isHidden = true
            
        }
        
        btnGameWidthConstraints.constant = 0
        btnGameOutlet.isHidden = true
        btnMuteMicOutlet.isUserInteractionEnabled = false
        viewMessage.isHidden = true
        viewMessage.layer.cornerRadius = viewMessage.frame.size.height / 2
        viewMessage.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        txtFldMessage.setLeftPaddingPoints(15)
        viewUserDetailsOutlet.layer.cornerRadius = viewUserDetailsOutlet.frame.size.height / 2
        imgViewUserProfilePhoto.layer.cornerRadius = imgViewUserProfilePhoto.frame.size.height / 2
        imgViewUserProfilePhoto.clipsToBounds = true
        
        viewDistributionOutlet.layer.cornerRadius = viewDistributionOutlet.frame.size.height / 2
        viewDistributionOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
     
        viewRewardOutlet.layer.cornerRadius = viewRewardOutlet.frame.size.height / 2
        viewRewardOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tblViewLiveMessage?.register(UINib(nibName: "LiveMessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessagesTableViewCell")
        tblViewLiveMessage?.register(UINib(nibName: "LiveMessageHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessageHeaderTableViewCell")
        tblViewLiveMessage.rowHeight = UITableView.automaticDimension
        tblViewLiveMessage.delegate = self
        tblViewLiveMessage.dataSource = self
        tblViewLiveMessage.tableHeaderView = headerView
        
        viewLuckyGiftDetails.layer.cornerRadius = viewLuckyGiftDetails.frame.height / 2
        //viewLuckyGiftDetails.layer.borderWidth = 1
       // viewLuckyGiftDetails.layer.borderColor = UIColor.purple.withAlphaComponent(0.3).cgColor
        viewLuckyGiftDetails.backgroundColor = .black.withAlphaComponent(0.3)
        
        viewGiftImage.layer.cornerRadius = viewGiftImage.frame.height / 2
        viewUserImage.layer.cornerRadius = viewUserImage.frame.height / 2
        
        imgViewGift.layer.cornerRadius = imgViewGift.frame.height / 2
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        
        viewUserRoomStatus.layer.cornerRadius = viewUserRoomStatus.frame.height / 2
        viewUserRoomStatus.backgroundColor = UIColor(hexString: "000000")?.withAlphaComponent(0.35)//.black.withAlphaComponent(0.6)
        lblRoomUserName.textColor = UIColor(hexString: "FFC300")
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(handleTap), userInfo: nil, repeats: true)
        imgViewEndUserDetail.layer.cornerRadius = imgViewEndUserDetail.frame.height / 2
        
//        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: contentView.frame.width - 125)
//        widthConstraint.isActive = true
       
        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: btnJoinMicOutlet, attribute: .leading, multiplier: 1.0, constant: 2)
        widthConstraint.isActive = true
        
        let userNameWidthConstraint = NSLayoutConstraint(item: lblRoomUserName, attribute: .width, relatedBy: .lessThanOrEqual, toItem: viewUserRoomStatus, attribute: .width, multiplier: 0.5, constant: viewUserRoomStatus.frame.width / 2) // Adjust the multiplier and constant as needed
        userNameWidthConstraint.isActive = true
        
    }
    
    @objc func handleTap() {
        lblRewardRank.text = "Daily" + " " + dailyEarningBeans
        let originalFrame = viewRewardRank.frame
        let newFrame = CGRect(x: originalFrame.origin.x,
                              y: originalFrame.origin.y - 4, // Adjust the value as needed
                              width: originalFrame.size.width,
                              height: originalFrame.size.height)

        // Perform the animation
        UIView.animate(withDuration: 0.5, animations: {
            self.viewRewardRank.frame = newFrame
        })
//
        animateView()
    }
    
    func configureGiftView() {
    
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.frame = viewGift.bounds
        viewGift.addSubview(animationView)
        viewGift.addSubview(btnGiftOutlet)
        
        animationView.animation = LottieAnimation.named("Gift_animation1by1") // Replace with your animation file name
        animationView.loopMode = .loop
        animationView.play()
        animationView.isUserInteractionEnabled = false
        
        let animationView1 = LottieAnimationView()
        animationView1.contentMode = .scaleAspectFit
        animationView1.frame = imgViewContributionTrophy.bounds
        imgViewContributionTrophy.addSubview(animationView1)
        
        animationView1.animation = LottieAnimation.named("contribution_icon") // Replace with your animation file name
        animationView1.loopMode = .loop
        animationView1.play()
        animationView1.isUserInteractionEnabled = false
        
        let animationView2 = LottieAnimationView()
        animationView2.contentMode = .scaleAspectFit
        animationView2.frame = viewUserBusy.bounds
        viewUserBusy.addSubview(animationView2)
        
        animationView2.animation = LottieAnimation.named("BusyTV") // Replace with your animation file name
        animationView2.loopMode = .loop
        animationView2.play()
        animationView2.isUserInteractionEnabled = false
        
        let animationView3 = LottieAnimationView()
        animationView3.contentMode = .scaleAspectFit
        animationView3.frame = viewSwipeUpAnimation.bounds
        viewSwipeUpAnimation.addSubview(animationView3)
        
        animationView3.animation = LottieAnimation.named("swipe_up_lottie") // Replace with your animation file name
        animationView3.loopMode = .loop
        animationView3.play()
        animationView3.isUserInteractionEnabled = false
        
        let animationView4 = LottieAnimationView()
        animationView4.contentMode = .scaleAspectFit
        animationView4.frame = viewSwipeFingerAnimation.bounds
        viewSwipeFingerAnimation.addSubview(animationView4)
        
        animationView4.animation = LottieAnimation.named("lottie_swipe_up_hand") // Replace with your animation file name
        animationView4.loopMode = .loop
        animationView4.play()
        animationView4.isUserInteractionEnabled = false
        
        let animationView5 = LottieAnimationView()
        animationView5.contentMode = .scaleAspectFit
        animationView5.frame = viewOneToOneCall.bounds
        viewOneToOneCall.addSubview(animationView5)
        
        animationView5.animation = LottieAnimation.named("Call2") // Replace with your animation file name
        animationView5.loopMode = .loop
        animationView5.play()
        animationView5.isUserInteractionEnabled = false
        
        let animationView6 = LottieAnimationView()
        animationView6.contentMode = .scaleAspectFit
        animationView6.frame = viewLiveAnimationOutlet.bounds
        viewLiveAnimationOutlet.addSubview(animationView6)
        
        animationView6.animation = LottieAnimation.named("live_animation") // Replace with your animation file name
        animationView6.loopMode = .loop
        animationView6.play()
        animationView6.isUserInteractionEnabled = false
        
        
        lottieAnimationViews = [animationView, animationView1, animationView2, animationView3, animationView4, animationView5, animationView6]
        
    }
    
     func removeLottieAnimationViews() {
           // Remove Lottie animation views from their superviews
           lottieAnimationViews.forEach { $0.removeFromSuperview() }
       }
    
    func hideViewsOnSwipe() {
    
        btnCloseBroadOutlet.isHidden = false
        viewBottom.isHidden = true
        viewUserDetailsOutlet.isHidden = true
        viewDistributionOutlet.isHidden = true
        viewRewardOutlet.isHidden = true
        viewLiveMessage.isHidden = true
        collectionView.isHidden = true
        btnViewAudienceOutlet.isHidden = true
        viewUserRoomStatus.isHidden = true
        viewUserBusy.isHidden = true
        viewEndUserDetails.isHidden = true
        viewEndView.isHidden = true
        viewMicJoinedUsersList.isHidden = true
        btnJoinMicOutlet.isHidden = true
        viewOneToOneCall.isHidden = true
        btnMuteMicOutlet.isHidden = true
        btnMicOutlet.isHidden = true
        btnMessageOutlet.isHidden = true
        btnGameOutlet.isHidden = true
      //  viewGift.isHidden = false
        
    }
    
    func unhideViewsOnSwipe() {
    
        btnCloseBroadOutlet.isHidden = false
        viewBottom.isHidden = false
        viewUserDetailsOutlet.isHidden = false
        viewDistributionOutlet.isHidden = false
        viewRewardOutlet.isHidden = false
        viewLiveMessage.isHidden = false
        collectionView.isHidden = false
        btnViewAudienceOutlet.isHidden = false
        viewUserRoomStatus.isHidden = false
        viewEndUserDetails.isHidden = true
        viewEndView.isHidden = true
        viewMicJoinedUsersList.isHidden = false
        if (isJoinMicPressed == true) {
            btnJoinMicOutlet.isHidden = true
        } else {
            btnJoinMicOutlet.isHidden = false
        }
        if (hostFollow == 1) {
            btnFollowHostOutlet.isHidden = true
        } else {
            btnFollowHostOutlet.isHidden = false
        }
        let gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        
        if (gender.lowercased() == "male") {
        
            viewOneToOneCall.isHidden = false
        } else {
            
            viewOneToOneCall.isHidden = true
            
        }
        
        viewOneToOneCall.isHidden = false
        btnMuteMicOutlet.isHidden = false
        btnMicOutlet.isHidden = false
        btnMessageOutlet.isHidden = false
        btnGameOutlet.isHidden = false
        
    }
    
    func hideViews() {
    
        btnCloseBroadOutlet.isHidden = false
        viewBottom.isHidden = true
        viewUserDetailsOutlet.isHidden = true
        viewDistributionOutlet.isHidden = true
        viewRewardOutlet.isHidden = true
        viewLiveMessage.isHidden = true
        collectionView.isHidden = true
        btnViewAudienceOutlet.isHidden = true
        viewUserRoomStatus.isHidden = true
        viewUserBusy.isHidden = true
        viewEndUserDetails.isHidden = true
        viewEndView.isHidden = true
        viewMicJoinedUsersList.isHidden = true
        btnJoinMicOutlet.isHidden = true
        viewOneToOneCall.isHidden = true
        btnMuteMicOutlet.isHidden = true
        btnMicOutlet.isHidden = true
        btnMessageOutlet.isHidden = true
        btnGameOutlet.isHidden = true
     //   viewGift.isHidden = false
        
    }
    
    func unhideViews() {
    
        btnCloseBroadOutlet.isHidden = false
        viewBottom.isHidden = false
        viewUserDetailsOutlet.isHidden = false
        viewDistributionOutlet.isHidden = false
        viewRewardOutlet.isHidden = false
        viewLiveMessage.isHidden = false
        collectionView.isHidden = false
        btnViewAudienceOutlet.isHidden = false
        viewUserRoomStatus.isHidden = false
        viewEndUserDetails.isHidden = true
        viewEndView.isHidden = true
        viewMicJoinedUsersList.isHidden = false
        if (isJoinMicPressed == true) {
            btnJoinMicOutlet.isHidden = true
        } else {
            btnJoinMicOutlet.isHidden = false
        }
        if (hostFollow == 1) {
            btnFollowHostOutlet.isHidden = true
        } else {
            btnFollowHostOutlet.isHidden = false
        }
        let gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        
        if (gender.lowercased() == "male") {
        
            viewOneToOneCall.isHidden = false
        } else {
            
            viewOneToOneCall.isHidden = true
            
        }
        
        viewOneToOneCall.isHidden = false
        btnMuteMicOutlet.isHidden = false
        btnMicOutlet.isHidden = false
        btnMessageOutlet.isHidden = false
        btnGameOutlet.isHidden = false
        
    }
    
    func animateView() {
           // Calculate the new frame for the view
           let originalFrame = viewRewardRank.frame
           let newFrame = CGRect(x: originalFrame.origin.x,
                                 y: originalFrame.origin.y - 4, // Adjust the value as needed
                                 width: originalFrame.size.width,
                                 height: originalFrame.size.height)

           // Perform the animation
           UIView.animate(withDuration: 0.5, animations: {
               self.viewRewardRank.frame = newFrame
           }) { (finished) in
               // Animation completion, update view with new data
            //   self.updateView()
               self.lblRewardRank.text = "Weekly" + " " + self.weeklyEarningBeans
           }
       }
    
    @IBAction func viewUserDetailsPressed(_ sender: UIButton) {
        
        print("View user details click hua hai. jo ki button ki trh kaam krega.")
        delegate?.userDetailsPressed(selectedIndex: sender.tag)
        
    }
    
    @IBAction func btnFollowHostPressed(_ sender: Any) {
        
        print("Button Follow Host Pressed")
        btnFollowHostOutlet.isUserInteractionEnabled = false
        delegate?.buttonFollowPressed(isPressed: true)
       // follow()
        
    }
    
    @IBAction func btnMessagePressed(_ sender: Any) {
        
        print("Open keyboard and textfield view button pressed")
        txtFldMessage.becomeFirstResponder()
        
    }
    
    @IBAction func btnGamePressed(_ sender: Any) {
        
        print("Open Button Games Option Pressed")
        delegate?.gameButtonClicked(isClicked: true)
        
    }
 
    @IBAction func btnGiftPressed(_ sender: Any) {
        
        print("Send gift button presseds")
        delegate?.giftButton(isPressed: true)
        
    }
    
//    func replaceNumbersWithAsterisks(_ string: String) -> String {
//        let regex = try! NSRegularExpression(pattern: "[0-9]")
//        let range = NSRange(location: 0, length: string.utf16.count)
//        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "*")
//    }

//    let replacedString = replaceNumbersWithAsterisks("Hello123World456")
//    print(replacedString) // Output: Hello***World***

    @IBAction func btnSendMessagePressed(_ sender: Any) {
        
        print("Button Send Message Pressed")
        print("The message which user want to send is: \(txtFldMessage.text)")
//        txtFldMessage.resignFirstResponder()
        if (txtFldMessage.text == "") || (txtFldMessage.text == nil) {
            print("Firebase par message post nahi karenge.")
        } else {
            print("Firebase par message post kar denge")
            let replacedString = replaceNumbersWithAsterisks(txtFldMessage.text ?? "")
                print(replacedString)
            sendMessage(message: replacedString ?? "N/A")
            txtFldMessage.resignFirstResponder()
        }
    }
    
    @IBAction func btnCloseBroadPressed(_ sender: Any) {
        
        print("Button Close Broad Pressed")
        timer?.invalidate()
        delegate?.closeBroad(isPressed: true)
        
    }
    
    @IBAction func viewDistributionPressed(_ sender: Any) {
        
        print("Button View Distribution Rewards Clicked")
        delegate?.distributionClicked(openWebView: true)
        
    }
    
    @IBAction func viewRewardPressed(_ sender: Any) {
        
        print("Button view reward list clicked.")
        delegate?.viewRewardClicked(isClicked: true)
        
    }
    
    @IBAction func btnViewAudiencePressed(_ sender: Any) {
        
        print("Button view audience list pressed")
        delegate?.buttonAudienceList(isClicked: true)
        
    }
    
    @IBAction func viewRewardRankPressed(_ sender: Any) {
        
        print("VIew reward rank Pressed that is animating.")
        delegate?.viewRewardClicked(isClicked: true)
        
    }
    
    @IBAction func btnOneToOneCallPressed(_ sender: Any) {
        
        print("Button One TO One call Pressed hui hai.")
        viewOneToOneCall.isHidden = true
        delegate?.buttonOneToOneCallPressed(isPressed: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) {
            self.viewOneToOneCall.isHidden = false
        }
        
    }
    
    @IBAction func btnJoinMicPressed(_ sender: Any) {
        
        print("Button Join Mic Pressed.")
        isJoinMicPressed = true
        btnJoinMicOutlet.isHidden = true
        delegate?.buttonJoinMicPressed(isPressed: true)
        startResendTimer()
        
    }
    
    func startResendTimer() {
        
        isJoinMicPressed = true
        totalTime = 15
        startTimer()
        
    }
    
    @IBAction func btnMicPressed(_ sender: Any) {
        
        print("Button Mic Pressed. For mute and unmute the broad while watching.")
      
        if isMuteMicButtonPressed
        
        {
            delegate?.buttonMicPressed(isPressed: isMuteMicButtonPressed)
            isMuteMicButtonPressed = false
          btnMicOutlet.setImage(UIImage(named:"speakeron"), for: .normal)
//          muteMicrophone = false
            
        }
        
        else{
            
            delegate?.buttonMicPressed(isPressed: isMuteMicButtonPressed)
            isMuteMicButtonPressed = true
          btnMicOutlet.setImage(UIImage(named:"speakeroff"), for: .normal)
//            muteMicrophone = true
            
        }
        
    }
    
    @IBAction func btnMuteMicPressed(_ sender: Any) {
        
        print("Button Mute the user mic pressed. to stop it's sound from coming.")
        
        if (isMicMutedByHost == false) {
            if muteMic
                
            {
                delegate?.muteMic(isPressed: "true")
                muteMic = false
                btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                //          muteMicrophone = false
                
            }
            
            else{
                
                delegate?.muteMic(isPressed: "false")
                muteMic = true
                btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                //            muteMicrophone = true
                
            }
        } else {
            print("User ko host ne mute mic kar diya hai. isliye ab ye conditions chalengi.")
            delegate?.muteMic(isPressed: "host")
            btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
            
        }
    }
    
}

// MARK: - EXTENSION TO START TIMER FOR HIDING AND SHOWING THE JOIN MIC BUTTON

extension LiveRoomCellTableViewCell {
    
    func startTimer() {

        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        if totalTime != 0 {
            totalTime -= 1
            isJoinMicPressed = true
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        
        isJoinMicPressed = false
        countdownTimer?.invalidate()
        btnJoinMicOutlet.isHidden = false
        
    }
    
}


// MARK: - EXTENSION FOR USING AND DEFINING THE FUNCTIONS FOR KEYBOARD HIDE AND SHOW ON THE CLICK OF BUTTON ADN ON TAP OF SCREEN

extension LiveRoomCellTableViewCell {
    
    @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardHeight = keyboardFrame.cgRectValue.height
              
               let viewBottomY = viewMessage.frame.origin.y + viewMessage.frame.size.height + 25
               let keyboardTopY = self.contentView.frame.size.height - keyboardHeight
               
               if viewBottomY > keyboardTopY {
               
                   UIView.animate(withDuration: 0.3) {
                       self.viewMessage.isHidden = false
                       self.txtFldMessage.text = ""
                       self.viewMessageBottomConstraints.constant = (viewBottomY - keyboardTopY)
                       self.viewMessage.frame.origin.y -= (viewBottomY - keyboardTopY)
                       print("The bottom constraints is \(self.viewMessageBottomConstraints.constant)")
                       print("The message view frame origin y hai: \(self.viewMessage.frame.origin.y )")
                       
                   }
               }
           }
       }
    
       @objc func keyboardWillHide(_ notification: Notification) {
         
           UIView.animate(withDuration: 0.3) {
               self.viewMessageBottomConstraints.constant = 20 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
               self.viewMessage.frame.origin.y = self.contentView.frame.size.height - self.viewMessage.frame.size.height
               self.viewMessage.isHidden = true
               self.txtFldMessage.text = ""
               print("jab keyboard hide hoga tb message view ka origin y hai: \(self.viewMessage.frame.origin.y)")
               
           }
       }
    
}

// MARK: - EXTENSION FOR THE FIREBASE FUNCTION TO SEND MESSAGE IN THE LIVE BROAD TO THE HOST

extension LiveRoomCellTableViewCell {

    func sendMessage(message:String) {
    
        var dic = [String: Any]()
        dic["level"] = UserDefaults.standard.string(forKey: "level")
        dic["gender"] = UserDefaults.standard.string(forKey: "gender")
        dic["user_id"] = UserDefaults.standard.string(forKey: "UserProfileId")
        dic["user_name"] = UserDefaults.standard.string(forKey: "UserName")
        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
            dic["user_image"] = picM ?? ""
        }
        
        dic["type"] = "1"
        dic["message"] = message
        dic["ownHost"] = true
        
   //     let nodeName =  ZLFireBaseManager.share.messageRef.childByAutoId().key ?? generateRandomString(length: 20)

//        ZLFireBaseManager.share.messageRef.child("message").child(String(format: "%d", profileID ?? 0)).child(nodeName).setValue(dic) { [weak self] (error, reference) in
//            
//            guard let self = self else {
//                           // self is nil, probably deallocated
//                           return
//                       }
//            
//            if let error = error {
//                print("Error writing data: \(error)")
//            } else {
//                print("Message sent and written successfully on firebase.")
//            }
//        }
        
        print("The group id for sending message is: \(groupID)")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                V2TIMManager.sharedInstance().sendGroupTextMessage(
                    jsonString,
                    to: groupID,
                    priority: V2TIMMessagePriority(rawValue: 1)!,
                    succ: {
                        // Success closure
                        print("Message sent successfully")
                        self.addMessage(message: message)
                    },
                    fail: { (code, desc) in
                        // Failure closure
                        print("Failed to send message with error code: \(code), description: \(desc ?? "Unknown")")
                    }
                )
            } else {
                print("Failed to convert JSON data to string")
            }
        } catch {
            print("Error converting dictionary to JSON: \(error.localizedDescription)")
        }
        
    }
    
    func addMessage(message:String) {
    
        liveMessage.gender = UserDefaults.standard.string(forKey: "gender")
        liveMessage.level = UserDefaults.standard.string(forKey: "level")
        liveMessage.message = message
        liveMessage.ownHost = true
        liveMessage.type = "1"
        liveMessage.userID = UserDefaults.standard.string(forKey: "UserProfileId")
        liveMessage.userImage = UserDefaults.standard.string(forKey: "profilePicture")
        liveMessage.userName = UserDefaults.standard.string(forKey: "UserName")
        
        insertNewMsgs(msgs: liveMessage)
        //tblViewLiveMessage.reloadData()
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND DATASOURCE METHODS AND SETTIGN DATA IN THE TABLE VIEWS

extension LiveRoomCellTableViewCell : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == tblViewMicJoinedUsers) {
            return zegoMicUsersList.count
        } else if (tableView == tblViewLiveMessage) {
            return liveMessages.count ?? 0//10//tableData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        scrollToBottom()
        
        
       
        if (tableView == tblViewMicJoinedUsers) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MicJoinedUsersTableViewCell", for: indexPath) as! MicJoinedUsersTableViewCell
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.lblMicUserName.text = zegoMicUsersList[indexPath.row].coHostUserName//"Prakhar Dixit"
//            cell.imgViewMicUserImage.image = UIImage(named: "UserPlaceHolderImageForCell")
            loadImageForCell(from: zegoMicUsersList[indexPath.row].coHostUserImage, into: cell.imgViewMicUserImage)
            cell.selectionStyle = .none
            return cell
            
        } else if (tableView == tblViewLiveMessage) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveMessagesTableViewCell", for: indexPath) as! LiveMessagesTableViewCell
//            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            /*cell.lblUserMessage.text = liveMessages[indexPath.row].message ?? " N/A"*/ //"User Message User Message"
            cell.lblUserLevel.text = " Lv." + (liveMessages[indexPath.row].level ?? "N/A")
            cell.lblUserName.text = liveMessages[indexPath.row].userName ?? "N/A"
            
            print("Live message cell main user ka gender hai: \(liveMessages[indexPath.row].gender)")
            if (liveMessages[indexPath.row].type == "2") {
                
                //let fullString = "Send \(liveMessages[indexPath.row].giftCount) \(liveMessages[indexPath.row].sendGiftName) to \(liveMessages[indexPath.row].sendGiftTo)"
                let count = String(liveMessages[indexPath.row].giftCount ?? 0)
                let giftName = liveMessages[indexPath.row].sendGiftName ?? "N/A"
                let sendTo = liveMessages[indexPath.row].sendGiftTo ?? "N/A"
                
                let formattedAttributedString = formatAttributedString(giftCount: count , sendGiftName: giftName, sendGiftTo: sendTo, sendGiftToColor: GlobalClass.sharedInstance.setLiveMessageColour())
                
                cell.lblUserMessage.attributedText = formattedAttributedString
                
            } else {
                
                cell.lblUserMessage.text = liveMessages[indexPath.row].message ?? " N/A"
                cell.lblUserMessage.textColor = .white
            }
            
            if (liveMessages[indexPath.row].type == "12") {
                
                cell.lblUserMessage.text = (liveMessages[indexPath.row].userName ?? "N/A") + " " + "is muted by Host"
                cell.lblUserMessage.textColor = GlobalClass.sharedInstance.setLiveMessageColour()
                
            } else if (liveMessages[indexPath.row].type == "13") {
                
                cell.lblUserMessage.text = (liveMessages[indexPath.row].userName ?? "N/A") + " " + "is unmuted by host"
                cell.lblUserMessage.textColor = GlobalClass.sharedInstance.setLiveMessageColour()
                
            }
            
            if let gender = liveMessages[indexPath.row].gender {
                if let levelString = liveMessages[indexPath.row].level, let level = Int(levelString) {
                    if (gender.lowercased() == "male") {
                        print("Gender male hai")
                        if (level == 0) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv0")
                        } else if (level >= 1 && level <= 5) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv1-5")
                        } else if (level >= 6 && level <= 10) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv6-10")
                        } else if (level >= 11 && level <= 15) {
                            cell.imgViewLevel.image =  UIImage(named: "reach_Lv11-15")
                        } else if (level >= 16 && level <= 20) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv16-20")
                        } else if (level >= 21 && level <= 25) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv21-25")
                        } else if (level >= 26 && level <= 30) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv26-30")
                        } else if (level >= 31 && level <= 35) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv31-35")
                        } else if (level >= 36 && level <= 40) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv36-40")
                        } else if (level >= 41 && level <= 45) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv41-45")
                        } else if (level >= 46 ) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv45-50")
                        }
                        
                    } else {
                        print("Gender female hai")
                        if (level == 0) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv0")
                        } else if (level >= 1 && level <= 5) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv1-5")
                        } else if (level >= 6 && level <= 10) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv6-10")
                        } else if (level >= 11 && level <= 15) {
                            cell.imgViewLevel.image =  UIImage(named: "charm_Lv11-15")
                        } else if (level >= 16 && level <= 20) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv16-20")
                        } else if (level >= 21 && level <= 25) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv21-25")
                        } else if (level >= 26 && level <= 30) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv26-30")
                        } else if (level >= 31 && level <= 35) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv31-35")
                        } else if (level >= 36 && level <= 40) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv36-40")
                        } else if (level >= 41 && level <= 45) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv41-45")
                        } else if (level >= 46 ) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv46-50")
                        }
                    }
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - scrollToBottom
    func scrollToBottom() {
        let lastIndex = IndexPath(row: zegoMicUsersList.count - 1, section: 0)
        tblViewMicJoinedUsers.scrollToRow(at: lastIndex, at: .bottom, animated: true)
       
        
        
//        if !zegoMicUsersList.isEmpty {
//            let firstElement = zegoMicUsersList.removeFirst()
//            zegoMicUsersList.append(firstElement)
//            tblViewMicJoinedUsers.reloadData()
//            
//            // Scroll to the last row
//            let lastRowIndex = zegoMicUsersList.count - 1
//            if lastRowIndex >= 0 {
//                let indexPath = IndexPath(row: lastRowIndex, section: 0)
//                tblViewMicJoinedUsers.scrollToRow(at: indexPath, at: .bottom, animated: true) // Set animated to true for smooth scrolling
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (tableView == tblViewMicJoinedUsers) {
            return 100
        } else if (tableView == tblViewLiveMessage) {
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == tblViewMicJoinedUsers) {
            
            print("Table view mic joined user wale main click hua hai. iska index path hai \(indexPath.row)")
            // Check if the index is within the bounds of the zegoMicUsersList array
            if zegoMicUsersList.indices.contains(indexPath.row) {
                // Access the mic user details at the specified index
                let userID = zegoMicUsersList[indexPath.row].coHostID ?? ""
                let userName = zegoMicUsersList[indexPath.row].coHostUserName ?? "N/A"
                let userImage = zegoMicUsersList[indexPath.row].coHostUserImage ?? ""
                
                // Call the delegate method with the mic user details
                delegate?.micJoinedUserClicked(userID: userID, userName: userName, userImage: userImage)
            } else {
                // Handle the case where the index is out of bounds
                print("Index out of bounds")
            }

            
        } else if (tableView == tblViewLiveMessage) {
            print("The selected message indexPath is: \(indexPath.row)")
            let image = liveMessages[indexPath.row].userImage ?? ""
            let name = liveMessages[indexPath.row].userName ?? ""
            let level = liveMessages[indexPath.row].level ?? ""
            let id = liveMessages[indexPath.row].userID ?? ""
            
            delegate?.messageClicked(userImage: image, userName: name, userLevel: level, userID: id)
        }
    }
    
    func insertNewMsgs(msgs: liveMessageModel) {
        totalMsgData  = msgs
        liveMessages.append(msgs)
        print("The live message count here is: \(liveMessages.count)")
        print("The total message count here is: \(msgs.message?.count)")
        tblViewLiveMessage.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Use the last row index in the only section
            //               let lastRowIndex = self.tblViewLiveMessage.numberOfRows(inSection: 0) - 1
            //               let indexPath = IndexPath(row: lastRowIndex, section: 0)
            //            print("Scrolling to indexPath: \(indexPath)")
            //               self.tblViewLiveMessage.scrollToRow(at: indexPath, at: .bottom, animated: true)
            if self.tblViewLiveMessage.numberOfRows(inSection: 0) > 0 {
                let lastRowIndex = self.tblViewLiveMessage.numberOfRows(inSection: 0) - 1
                let indexPath = IndexPath(row: lastRowIndex, section: 0)
                print("Scrolling to indexPath: \(indexPath)")
                self.tblViewLiveMessage.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
        // tblViewLiveMessage.reloadData()
    }
    
    func insertUserName(name:String,status:String) {
        print(name)
        print(status)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Assuming name and status are your variables
            self.lblRoomUserName.text = name + ":"
            
            if (status == "4") {
                self.lblRoomUserStatus.text = "has entered the room"
            } else {
                self.lblRoomUserStatus.text = "has left the room"
            }
            
        }
    }
    
    func usersOnMic(data: [getZegoMicUserListModel] = []) {
        zegoMicUsersList.removeAll()
        
      //  zegoMicUsersList = data
        
        // Convert the array to a Set to remove duplicates, then back to an array
           let uniqueData = Set(data)
           zegoMicUsersList = Array(uniqueData)
        
        
        if (zegoMicUsersList.count == 0) {
            viewMicJoinedUsersList.isHidden = true
        } else {
            viewMicJoinedUsersList.isHidden = false
        }
        
        let userid = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        let containsUser = zegoMicUsersList.contains { $0.coHostID == userid }
        print("Did user joined mic list contains himself: \(containsUser)")
       
        if (containsUser == true) {
            btnJoinMicOutlet.isHidden = true
            countdownTimer?.invalidate()
          
        } else {
        
            btnJoinMicOutlet.isHidden = false
            
        }
        
        tblViewMicJoinedUsers.reloadData()
    }
    
}

// MARK: - EXTENSION FOR USING DELEGATES AND DATASOURCE METHODS FOR SETTING AND SHOWING DATA IN THE COLLECTION VIEW

extension LiveRoomCellTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userInfoList?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BroadJoinCollectionViewCell2", for: indexPath) as! BroadJoinCollectionViewCell2
         
        
        cell.resetCellState()
        cell.isUserInteractionEnabled = true
        cell.viewMain2.layer.cornerRadius = 15
        cell.imgViewUserPhoto2.layer.cornerRadius = cell.imgViewUserPhoto2.frame.height / 2 /*15*/ //cell.imgViewUserPhoto.frame.height / 2
        cell.imgViewUserPhoto2.layer.masksToBounds = true
        
        // Clear the image first
        cell.imgViewUserPhoto2.image = nil

        if let imageURL = URL(string: userInfoList?[indexPath.row].faceURL ?? "") {
            KF.url(imageURL)
                .cacheOriginalImage()
                .onSuccess { [weak cell] result in
                    DispatchQueue.main.async {
                        cell?.imgViewUserPhoto2.image = result.image
                    }
                }
                .onFailure { error in
                    print("Image loading failed with error: \(error)")
                    cell.imgViewUserPhoto2.image = UIImage(named: "UserPlaceHolderImageForCell")
                }
                .set(to: cell.imgViewUserPhoto2)
        } else {
            cell.imgViewUserPhoto2.image = UIImage(named: "UserPlaceHolderImageForCell")
        }

        cell.imgViewUserPhoto2.isUserInteractionEnabled = true
        cell.viewMain2.isUserInteractionEnabled = true
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.size.width ) / 4
        let height = width - 65
        return CGSize(width: width, height: 40)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Kuch bhi hai.")
        print("The selected indexpath in the collectionview is : \(indexPath.row)")
        //  print("The data that needs to be passed to show is: \(groupUsers[indexPath.row])")
        delegate?.cellIndexClicked(index: indexPath.row)
        
    }
    
//    func showJoinedUser(users: [V2TIMUserFullInfo]) {
//        DispatchQueue.main.async {
//            print(users.count)
//            self.userInfoList?.removeAll()
//            self.userInfoList = users
//            self.collectionView.reloadData()
//        }
//    }
    func showJoinedUser(users: [V2TIMUserFullInfo]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            print(users.count)
            self.userInfoList?.removeAll()
            self.userInfoList = users
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - EXTENSION FOR API CALLING

extension LiveRoomCellTableViewCell {
    
    func follow() {
      
      let params = [
          "following_id": userID
         
      ] as [String : Any]
      
      print("The parameter for following user is: \(params)")
        
      ApiWrapper.sharedManager().followUser(url: AllUrls.getUrl.followUser,parameters: params) { [weak self] (data) in
          guard let self = self else { return }
          
          if (data["success"] as? Bool == true) {
              print(data)
              
              btnFollowHostOutlet.isHidden = true
              btnFollowHostOutlet.isUserInteractionEnabled = true
              btnFollowWidthConstraints.constant = 0
              print("sab shi hai. kuch gadbad nahi hai")
         //     showAlertwithButtonAction(title: "SUCCESS !", message: "Your Profile has been updated successfully", viewController: self)
              
          }  else {
                
              btnFollowHostOutlet.isHidden = false
              btnFollowHostOutlet.isUserInteractionEnabled = true
              btnFollowWidthConstraints.constant = 30
              print("Kuch gadbad hai")
              
          }
      }
  }
    
}

extension LiveRoomCellTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtFldMessage) {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            print("The count in verify otp textfield is : \(count)")
            
            
            return count <= 100
            
        }
        
        return true
    }
    
}

//    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
//        // Perform the action you want when the image is tapped
//        if let tappedImageView = sender.view as? UIImageView {
//            // Access the tapped image view or its tag, etc.
//            print("Image tapped! ImageView tag: \(tappedImageView.tag)")
//
//            // Add your custom logic here
//        }
//    }
    
//}

//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                let indexPath = IndexPath(row: 0, section: self.liveMessages.count)
//                self.tblViewLiveMessage.scrollToRow(at: indexPath, at: .bottom, animated: true)
//
//        }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        return 120
//
//    }
//
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//       return "Welcome to ZeepLive!! Please don't share inappropriate content like pornography or violence as it's strictly againest our policy. Our AI system continuosly monitors content to ensure compliance."
//
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//
//        if let headerView = view as? UITableViewHeaderFooterView {
//            headerView.contentView.backgroundColor = .black.withAlphaComponent(0.3)
//                headerView.textLabel?.textColor = .yellow
//            headerView.textLabel?.font = UIFont.systemFont(ofSize: 12)
//            headerView.textLabel?.numberOfLines = 0
//        }
//
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerCell = tableView.dequeueReusableCell(withIdentifier: "LiveMessageHeaderTableViewCell") as! LiveMessageHeaderTableViewCell
//
//        headerCell.lblHeaderMessage.text = "Welcome to ZeepLive!! Please don't share inappropriate content like pornography or violence as it's strictly againest our policy. Our AI system continuosly monitors content to ensure compliance."
//
//        return headerCell
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        return UITableView.automaticDimension
//    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let headerView = view as? UITableViewHeaderFooterView {
//                headerView.contentView.backgroundColor = .white
//               // headerView.backgroundView?.backgroundColor = .black
//                headerView.textLabel?.textColor = .black
//            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
//            }
//    }

//                        if (status == "4") {
//
//                            print("User ne room enter kia hai.")
//                            let a = name + ":" + " "
//                            let b = "has entered the room "
//
//                    let attributedString = self.createAttributedString(name: name, action: b, color1: UIColor(hexString: "F9B248") ?? .white, color2: .white, fontSize: 16)
//
//                        // Assuming 'lblRoomUserName' is a UILabel
//
//                        } else {
//
//                            print("User room se bhr chala gya hai.")
//                            let a = name + ":" + " "
//                            let b = "has left the room"
//
//
//                let attributedString = self.createAttributedString(name: name, action: b, color1: UIColor(hexString: "F9B248") ?? .white, color2: .white, fontSize: 16)
//
//                            // Assuming 'lblRoomUserName' is a UILabel
//                            self.lblRoomUserName.attributedText = attributedString
//
//
//                        }

// MARK: - Function to have two different colors of a same label

//func createAttributedString(name: String, action: String, color1: UIColor, color2: UIColor, fontSize: CGFloat) -> NSAttributedString {
//    let text = name + ":" + " " + action
//    let attributedString = NSMutableAttributedString(string: text)
//
//    // Set the first part of the text in color1 with the specified font size
//    let range1 = NSRange(location: 0, length: name.count + 3) // Adjust the range as needed
//    attributedString.addAttribute(.foregroundColor, value: color1, range: range1)
//    attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range1)
//
//    // Set the second part of the text in color2 with the specified font size
//    let range2 = NSRange(location: name.count + 3, length: action.count) // Adjust the range as needed
//    attributedString.addAttribute(.foregroundColor, value: color2, range: range2)
//    attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range2)
//
//    return attributedString
//}

//            if let data = htmlString.data(using: .utf8),
//               let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
//
//                // Now 'attributedString' contains the formatted string
//                let finalString = attributedString.string
//                print(finalString)
//                cell.lblUserMessage.text = finalString
//
//
//
//            } else {
//                // Handle the case when HTML parsing fails
//                print("Failed to parse HTML string")
//                cell.lblUserMessage.text = liveMessages[indexPath.row].message ?? " N/A"
//            }

//            let htmlString = liveMessages[indexPath.row].message ?? " N/A" //"send 1 tempo to <font color='#f4c11f'><b>🌟Aayat Mano🌟</b></font>"
//            if let decodedString = htmlString.applyingTransform(StringTransform(rawValue: "Any-Hex/Java"), reverse: true) {
//
//                cell.lblUserMessage.text = decodedString
//            }

//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BroadJoinCollectionViewCell", for: indexPath) as! BroadJoinCollectionViewCell
//
//        cell.resetCellState()
//        cell.isUserInteractionEnabled = true
//        cell.imgViewUserPhoto.layer.cornerRadius = cell.imgViewUserPhoto.frame.height / 2
//        //        cell.imgViewUserPhoto.image = nil
//
//        cell.imgViewUserPhoto.image = nil // Clear the image first
//
//        if let imageURL = URL(string: userInfoList?[indexPath.row].faceURL ?? "") {
//            KF.url(imageURL)
//                .cacheOriginalImage()
//                .onSuccess { result in
//                    DispatchQueue.main.async {
//                        cell.imgViewUserPhoto.image = result.image
//                    }
//                }
//                .onFailure { error in
//                    print("Image loading failed with error: \(error)")
//                    cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//                }
//                .set(to: cell.imgViewUserPhoto)
//        } else {
//            cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//        }
//
//       // cell.imgViewUserPhoto.tag = indexPath.row
//        cell.imgViewUserPhoto.isUserInteractionEnabled = true
//        cell.viewMain.isUserInteractionEnabled = true
//
//        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
//        //            cell.imgViewUserPhoto.addGestureRecognizer(tapGesture)
//
//
//        return cell
//
//    }

//        groupUsers.removeAll()
//       liveMessages.removeAll()
//        userInfoList?.removeAll()
//        tblViewLiveMessage.dataSource = nil
//        tblViewLiveMessage.delegate = nil
//        collectionView.dataSource = nil
//        collectionView.delegate = nil
////        collectionView?.collectionViewLayout.invalidateLayout()
//        collectionView.removeFromSuperview()
//        delegate = nil
//        tblViewLiveMessage = nil
//        totalMsgData = liveMessageModel()
        
//        collectionView = nil
//        viewMain = nil
//        viewBottom = nil
//        viewGift = nil
//        viewMessage = nil
//        viewLiveMessage = nil
//        viewLuckyGiftDetails = nil
