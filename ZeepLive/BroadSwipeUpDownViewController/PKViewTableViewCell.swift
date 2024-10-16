//
//  PKViewTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 08/02/24.
//

import UIKit
import ImSDK_Plus
import Lottie
import Kingfisher

protocol delegatePKViewTableViewCell: AnyObject {
    
    func pkgiftButton(isPressed:Bool)
    func pkuserDetailsPressed(selectedIndex: Int)
    func pkcloseBroad(isPressed:Bool, status : Int)
    func pkdistributionClicked(openWebView:Bool)
    func pkviewRewardClicked(isClicked:Bool)
    func pkbuttonAudienceList(isClicked:Bool)
    func pkcellIndexClicked(index:Int)
    func pkmessageClicked(userImage:String , userName:String , userLevel:String, userID:String)
    func pkgameButtonClicked(isClicked:Bool)
    func pkFirstViewClicked(isClicked:Bool)
    func pkSecondViewClicked(isClicked:Bool)
    func giftedUserPressed(userID:Int, userName:String, userImage: String)
    func pkuserOnMic(index:Int)
    func pkOpponentuserOnMic(index:Int)
    func pkButtonFollowPressed(isPressed:Bool)
    func pkmicButtonPressed(isPressed:Bool)
    func pkbuttonOneToOnePressed(isPressed:Bool)
    func pkbuttonJoinMicPressed(isPressed:Bool)
    func pkmuteMic(isPressed:String)
    
}

class PKViewTableViewCell: UITableViewCell {
    
    lazy var headerView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: viewLiveMessages.frame.width, height: 100))
        v.backgroundColor = UIColor(hexString: "000000")?.withAlphaComponent(0.35)
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        let lab = UILabel(frame: CGRect(x: 9, y: 8, width: viewLiveMessages.frame.width - 18, height: 100 - 16))
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
    @IBOutlet weak var viewUserDetailOutlet: UIButton!
    @IBOutlet weak var imgViewUserImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblBroadViewCount: UILabel!
    @IBOutlet weak var btnFollowUserOutlet: UIButton!
    @IBOutlet weak var btnCloseBroadOutlet: UIButton!
    @IBOutlet weak var btnViewAudienceOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnViewDistributionOutlet: UIButton!
    @IBOutlet weak var imgViewDistribution: UIImageView!
    @IBOutlet weak var lblDistributionAmount: UILabel!
    @IBOutlet weak var btnViewRewardOutlet: UIButton!
    @IBOutlet weak var btnViewRewardRankOutlet: UIButton!
    @IBOutlet weak var lblViewRewardRank: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewOneToOneCall: UIView!
    @IBOutlet weak var btnOneToOneOutlet: UIButton!
    @IBOutlet weak var viewGift: UIView!
    @IBOutlet weak var btnGiftOutlet: UIButton!
    @IBOutlet weak var btnOpenMessage: UIButton!
    @IBOutlet weak var btnGameOutlet: UIButton!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnSendMessageOutlet: UIButton!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var txtFldMessage: UITextField!
    @IBOutlet weak var viewUserRoomStatus: UIView!
    @IBOutlet weak var lblRoomUserName: UILabel!
    @IBOutlet weak var lblRoomUserStatus: UILabel!
    @IBOutlet weak var viewLiveMessages: UIView!
    @IBOutlet weak var tblViewLiveMessages: UITableView!
    @IBOutlet weak var viewPK: UIView!
    @IBOutlet weak var viewPKFirstUserOutlet: UIButton!
    @IBOutlet weak var viewPKSecondUserOutlet: UIButton!
    @IBOutlet weak var viewMessageBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewPKSecondUserName: UIButton!
    @IBOutlet weak var lblPKSecondUserName: UILabel!
    @IBOutlet weak var viewPKBottom: UIView!
    @IBOutlet weak var viewPKAnimation: UIView!
    @IBOutlet weak var viewPKAnimation01: UIView!
    @IBOutlet weak var viewUsersOnMic: UIView!
    @IBOutlet weak var viewOpponentUsersOnMic: UIView!
    @IBOutlet weak var viewFirstUserOnMicOutlet: UIButton!
    @IBOutlet weak var viewSecondUserOnMicOutlet: UIButton!
    @IBOutlet weak var viewThirdUserOnMicOutlet: UIButton!
    @IBOutlet weak var viewOpponentFirstUserOnMicOutlet: UIButton!
    @IBOutlet weak var viewOpponentSecondUserOnMicOutlet: UIButton!
    @IBOutlet weak var viewOpponentThirdUserOnMicOutlet: UIButton!
    @IBOutlet weak var imgViewFirstUserOnMic: UIImageView!
    @IBOutlet weak var imgViewSecondUserOnMic: UIImageView!
    @IBOutlet weak var imgViewThirdUserOnMic: UIImageView!
    @IBOutlet weak var imgViewOpponentFirstUserOnMic: UIImageView!
    @IBOutlet weak var imgViewOpponentSecondUserOnMic: UIImageView!
    @IBOutlet weak var imgViewOpponentThirdUserOnMic: UIImageView!
    @IBOutlet weak var pkBarStackView: UIStackView!
    @IBOutlet weak var viewStackLeft: UIView!
    @IBOutlet weak var viewStackMiddle: UIView!
    @IBOutlet weak var viewStackRight: UIView!
    @IBOutlet weak var viewLeftStackWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewMiddleStackWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewRightStackWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblLeftStackViewGiftAmount: UILabel!
    @IBOutlet weak var lblRightStackViewGiftAmount: UILabel!
    @IBOutlet weak var viewPKGiftedUsers: UIView!
    @IBOutlet weak var viewPKUserGifted: UIView!
    @IBOutlet weak var viewPKOpponentGifted: UIView!
    @IBOutlet weak var btnGiftUserOneOutlet: UIButton!
    @IBOutlet weak var btnGiftUserTwoOutlet: UIButton!
    @IBOutlet weak var btnGiftUserThreeOutlet: UIButton!
    @IBOutlet weak var btnGiftOpponentOneOutlet: UIButton!
    @IBOutlet weak var btnGiftOpponentTwoOutlet: UIButton!
    @IBOutlet weak var btnGiftOpponentThreeOutlet: UIButton!
    @IBOutlet weak var viewLuckyGift: UIView!
    @IBOutlet weak var lblNoOfGift: UILabel!
    @IBOutlet weak var viewLuckyGiftDetails: UIView!
    @IBOutlet weak var viewUserImage: UIView!
    @IBOutlet weak var viewGiftImage: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var imgViewGift: UIImageView!
    @IBOutlet weak var lblSendGiftHostName: UILabel!
    @IBOutlet weak var imgViewGiftUserOne: UIImageView!
    @IBOutlet weak var imgViewGiftUserTwo: UIImageView!
    @IBOutlet weak var imgViewGiftUserThree: UIImageView!
    @IBOutlet weak var imgViewGiftOpponentUserOne: UIImageView!
    @IBOutlet weak var imgViewGiftOpponentUserTwo: UIImageView!
    @IBOutlet weak var imgViewGiftOpponentUserThree: UIImageView!
    @IBOutlet weak var lblTimerCount: UILabel!
    @IBOutlet weak var viewTimerCount: UIView!
    @IBOutlet weak var btnFollowWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var btnGameWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnJoinMicOutlet: UIButton!
    @IBOutlet weak var btnMuteMicOutlet: UIButton!
    @IBOutlet weak var btnMuteMicWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewLiveAnimation: UIView!
    
    
    weak var delegate: delegatePKViewTableViewCell?
    lazy var totalMsgData = liveMessageModel()
    lazy var liveMessages: [liveMessageModel] = []
    lazy var groupUsers = [joinedGroupUserProfile]()
    lazy var timer = Timer()
    lazy var dailyEarningBeans: String = ""
    lazy var weeklyEarningBeans:String = ""
    lazy var lottieAnimationViews: [LottieAnimationView] = []
    lazy var userInfoList: [V2TIMUserFullInfo]? = []
    lazy var profileID: Int = 0
    lazy var userID:Int = 0
    lazy var giftFrom:String = ""
    lazy var giftFirstUserID: Int = 0
    lazy var giftFirstUserName: String = ""
    lazy var giftFirstUserImage: String = ""
    lazy var giftSecondUserID: Int = 0
    lazy var giftSecondUserName: String = ""
    lazy var giftSecondUserImage: String = ""
    lazy var giftThirdUserID: Int = 0
    lazy var giftThirdUserName: String = ""
    lazy var giftThirdUserImage: String = ""
    lazy var giftOpponentFirstUserID: Int = 0
    lazy var giftOpponentFirstUsername: String = ""
    lazy var giftOpponentFirstUserImage: String = ""
    lazy var giftOpponentSecondUserID: Int = 0
    lazy var giftOpponentSecondUsername: String = ""
    lazy var giftOpponentSecondUserImage: String = ""
    lazy var giftOpponentThirdUserID: Int = 0
    lazy var giftOpponentThirdUsername: String = ""
    lazy var giftOpponentThirdUserImage: String = ""
    lazy var myGiftCoins: Int = 0
    lazy var opponentGiftCoins: Int = 0
    lazy var zegoMicUsersList: [getZegoMicUserListModel] = []
    lazy var viewBijlee = UIView()
    lazy var pktimer = Timer()
    lazy var totalTime = 240
    lazy var zegoOpponentMicUsersList: [getZegoMicUserListModel] = []
    lazy var pkEndTime: Int = 0
    lazy var pkCurrentTime: String = ""
    lazy var pkTimeDifference: Int = 0
    lazy var isMuteMicButtonPressed = false
    lazy var groupID: String = ""
    lazy var secondgroupID: String = ""
    var liveMessage = liveMessageModel()
    lazy var isJoinMicPressed: Bool = false
    lazy var muteMic = false
    lazy var isMicMutedByHost: Bool = false
    lazy var hostFollow: Int = 0
    var hasAnimated = [IndexPath: Bool]()
    var pkcloseBroad = Int()
    var isAnimation = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        myGiftCoins = 119
        //        opponentGiftCoins = 450
        
        txtFldMessage.delegate = self
        
        configureUI()
        addLottieAnimation()
        tableViewWork()
        collectionViewWork()
        timerAndNotification()
        configureBottomBarWork()
        configureImages()
        LottieBoomAnimation()
        //   startTimer()
        
        //  updateBottomBar()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isAnimation = false
        viewPKAnimation01.isHidden = false
        
        
    }
    
    //    override func prepareForReuse() {
    //           super.prepareForReuse()
    //
    //        removeLottieAnimationViews()
    //        groupUsers.removeAll()
    //        liveMessages.removeAll()
    //        userInfoList?.removeAll()
    //        // Clearing other instance variables
    //        liveMessages = []
    //        groupUsers = []
    //        lottieAnimationViews = []
    //        userInfoList = nil
    //        zegoMicUsersList = []
    //        zegoOpponentMicUsersList = []
    //        NotificationCenter.default.removeObserver(self)
    //        headerView.removeFromSuperview()
    //
    //       }
    
    @IBAction func btnCloseBroadPressed(_ sender: Any) {
        print("Close Broad Button Pressed")
        let status = 1
        timer.invalidate()
        delegate?.pkcloseBroad(isPressed: true, status: status)
        pkcloseBroad = status
        print("pkcloseBroad: \(status)")
    }
    @IBAction func btnViewAudiencePressed(_ sender: Any) {
        print("View Audience List Button Pressed")
        delegate?.pkbuttonAudienceList(isClicked: true)
    }
    @IBAction func viewUserDetailPressed(_ sender: UIButton) {
        print("View User Detail Button Pressed")
        delegate?.pkuserDetailsPressed(selectedIndex: sender.tag)
    }
    @IBAction func btnFollowUserPressed(_ sender: Any) {
        print("Follow User Button Press hui hai.")
        btnFollowUserOutlet.isUserInteractionEnabled = false
        delegate?.pkButtonFollowPressed(isPressed: true)
        //follow()
    }
    @IBAction func btnViewDistributionPressed(_ sender: Any) {
        print("Button View Distribution Pressed")
        delegate?.pkdistributionClicked(openWebView: true)
    }
    @IBAction func btnViewRewardPressed(_ sender: Any) {
        print("Button View Reward Pressed")
        delegate?.pkviewRewardClicked(isClicked: true)
    }
    @IBAction func btnViewRewardRankPressed(_ sender: Any) {
        print("Button View Reward Rank Pressed")
        delegate?.pkviewRewardClicked(isClicked: true)
    }
    @IBAction func btnOneToOneCallPressed(_ sender: Any) {
        print("Button One TO One Call Pressed")
        
        self.viewOneToOneCall.isHidden = true
        delegate?.pkbuttonOneToOnePressed(isPressed: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewOneToOneCall.isHidden = false
        }
        
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) {
        //            self.viewOneToOneCall.isHidden = false
        //        }
        
    }
    @IBAction func btnGiftPressed(_ sender: Any) {
        print("Button Open Gift Pressed")
        delegate?.pkgiftButton(isPressed: true)
    }
    @IBAction func btnOpenMessagePressed(_ sender: Any) {
        print("Button Open Message TextField Pressed")
        txtFldMessage.becomeFirstResponder()
    }
    @IBAction func btnGamePressed(_ sender: Any) {
        print("Button Game Pressed to open")
        delegate?.pkgameButtonClicked(isClicked: true)
    }
    @IBAction func btnSendMessagePressed(_ sender: Any) {
        print("Button Send Message Pressed")
        if (txtFldMessage.text == "") || (txtFldMessage.text == nil) {
            print("Firebase par message post nahi karenge.")
        } else {
            print("Firebase par message post kar denge")
            let replacedString = replaceNumbersWithAsterisks(txtFldMessage.text ?? "")
            print(replacedString)
            
            sendMessage(message: replacedString ?? "N/A", groupid: groupID)
            sendMessage(message: replacedString ?? "N/A", groupid: secondgroupID)
            txtFldMessage.resignFirstResponder()
        }
        
    }
    
    @IBAction func viewPKFirstUserPressed(_ sender: Any) {
        print("View PK First User Pressed")
        delegate?.pkFirstViewClicked(isClicked: true)
    }
    @IBAction func viewPKSecondUserPressed(_ sender: Any) {
        print("View PK Second User Pressed")
        delegate?.pkSecondViewClicked(isClicked: true)
    }
    @IBAction func viewPKSecondUserNamePressed(_ sender: Any) {
        print("View PK Second UserName Clicked hua hai . Jismain naam dikhta hai.")
        delegate?.pkSecondViewClicked(isClicked: true)
    }
    @IBAction func viewFirstUserOnMicPressed(_ sender: Any) {
        print("View First User On Mic Pressed")
        if (zegoMicUsersList.count == 0) {
            print("Delegaet call nahi hoga")
        } else {
            delegate?.pkuserOnMic(index: 0)
        }
    }
    @IBAction func viewSecondUserOnMicPressed(_ sender: Any) {
        print("View Second User On Mic Pressed")
        if (zegoMicUsersList.count <= 1) {
            print("Delegaet call nahi hoga")
        } else {
            delegate?.pkuserOnMic(index: 1)
        }
    }
    @IBAction func viewThirdUserOnMicPressed(_ sender: Any) {
        print("View Third User On Mic Pressed")
        if (zegoMicUsersList.count <= 2) {
            print("Delegaet call nahi hoga")
        } else {
            delegate?.pkuserOnMic(index: 2)
        }
    }
    @IBAction func viewOpponentFirstUserPressed(_ sender: Any) {
        print("View Opponent First User On Mic Pressed")
        if (zegoOpponentMicUsersList.count == 0) {
            print("Delegaet call nahi hoga")
        } else {
            delegate?.pkOpponentuserOnMic(index: 0)
        }
        
    }
    @IBAction func viewOpponentSecondUserPressed(_ sender: Any) {
        print("View Opponent Second User On Mic Pressed")
        if (zegoOpponentMicUsersList.count == 0) {
            print("Delegaet call nahi hoga")
        } else {
            delegate?.pkOpponentuserOnMic(index: 1)
        }
        
    }
    @IBAction func viewOpponentThirdUserPressed(_ sender: Any) {
        print("View Opponent Third User On Mic Pressed")
        if (zegoOpponentMicUsersList.count == 0) {
            print("Delegaet call nahi hoga")
        } else {
            delegate?.pkOpponentuserOnMic(index: 2)
        }
        
    }
    
    @IBAction func btnGiftUserOnePressed(_ sender: Any) {
        print("Button User First Gift Send Details Pressed")
        delegate?.giftedUserPressed(userID: giftFirstUserID, userName: giftFirstUserName, userImage: giftFirstUserImage)
    }
    @IBAction func btnGiftUserTwoPressed(_ sender: Any) {
        print("Button User Second Gift Send Details Pressed")
        delegate?.giftedUserPressed(userID: giftSecondUserID, userName: giftSecondUserName, userImage: giftSecondUserImage)
    }
    @IBAction func btnGiftUserThreePressed(_ sender: Any) {
        print("Button User Third Gift Send Details Pressed")
        delegate?.giftedUserPressed(userID: giftThirdUserID, userName: giftThirdUserName, userImage: giftThirdUserImage)
    }
    @IBAction func btnGiftOpponentOnePressed(_ sender: Any) {
        print("Button Opponent User First Gift Send Details Pressed")
        delegate?.giftedUserPressed(userID: giftOpponentFirstUserID, userName: giftOpponentFirstUsername, userImage: giftOpponentFirstUserImage)
    }
    @IBAction func btnGiftOpponentTwoPressed(_ sender: Any) {
        print("Button Opponent User Second Gift Send Details Pressed")
        delegate?.giftedUserPressed(userID: giftOpponentSecondUserID, userName: giftOpponentSecondUsername, userImage: giftOpponentSecondUserImage)
    }
    @IBAction func btnGiftOpponentThreePressed(_ sender: Any) {
        print("Button Opponent User Third Gift Send Details Pressed")
        delegate?.giftedUserPressed(userID: giftOpponentThirdUserID, userName: giftOpponentThirdUsername, userImage: giftOpponentThirdUserImage)
    }
    @IBAction func btnMicPressed(_ sender: Any) {
        print("Button Mic Pressed For Mute/Unmute Speaker in PK table view cell")
        if isMuteMicButtonPressed
            
        {
            delegate?.pkmicButtonPressed(isPressed: isMuteMicButtonPressed)
            isMuteMicButtonPressed = false
            btnMicOutlet.setImage(UIImage(named:  "speakeron"), for: .normal)
            
        }
        
        else{
            
            delegate?.pkmicButtonPressed(isPressed: isMuteMicButtonPressed)
            isMuteMicButtonPressed = true
            btnMicOutlet.setImage(UIImage(named:  "speakeroff"), for: .normal)
            
        }
        
    }
    
    @IBAction func btnJoinMicPressed(_ sender: Any) {
        
        print("Button Join Mic Pressed in PK Table View Cell ")
        isJoinMicPressed = true
        btnJoinMicOutlet.isHidden = true
        delegate?.pkbuttonJoinMicPressed(isPressed: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            self.btnJoinMicOutlet.isHidden = false
        }
        
    }
    
    @IBAction func btnMuteMicPressed(_ sender: Any) {
        
        print("Button Mute Mic Pressed in PK View Table View Cell")
        
        if (isMicMutedByHost == false) {
            
            if muteMic
                
            {
                delegate?.pkmuteMic(isPressed: "true")
                muteMic = false
                btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                //          muteMicrophone = false
                
            }
            
            else{
                
                delegate?.pkmuteMic(isPressed: "false")
                muteMic = true
                btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                //            muteMicrophone = true
                
            }
        } else {
            print("User ko host ne mute mic kar diya hai. isliye ab ye conditions chalengi.")
            delegate?.pkmuteMic(isPressed: "host")
            btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
            
        }
        
    }
    
    func clearData() {
        
        removeLottieAnimationViews()
        groupUsers.removeAll()
        liveMessages.removeAll()
        userInfoList?.removeAll()
        
        collectionView.removeFromSuperview()
        totalMsgData = liveMessageModel()
        
        viewMain = nil
        imgViewUserImage = nil
        lblUserName = nil
        viewBottom = nil
        btnSendMessageOutlet = nil
        viewGift = nil
        btnGameOutlet = nil
        btnGiftOutlet = nil
        viewGift = nil
        
        delegate = nil
        viewMessage = nil
        btnSendMessageOutlet = nil
        viewTextField = nil
        txtFldMessage = nil
        viewMessageBottomConstraints = nil
        viewUserDetailOutlet = nil
        imgViewDistribution = nil
        lblRoomUserName = nil
        lblBroadViewCount = nil
        btnFollowUserOutlet = nil
        btnCloseBroadOutlet = nil
        btnViewDistributionOutlet = nil
        lblDistributionAmount = nil
        btnViewRewardOutlet = nil
        viewLiveMessages = nil
        tblViewLiveMessages = nil
        
        collectionView = nil
        btnViewAudienceOutlet = nil
        viewUserRoomStatus = nil
        lblRoomUserName = nil
        lblRoomUserStatus = nil
        lblViewRewardRank = nil
        btnViewRewardOutlet = nil
        imgViewDistribution = nil
        viewOneToOneCall = nil
        viewLuckyGiftDetails = nil
        viewLuckyGift = nil
        imgViewGift = nil
        imgViewUser = nil
        viewUserImage = nil
        viewGift = nil
        lblSendGiftHostName = nil
        lblNoOfGift = nil
        
        headerView.removeFromSuperview()
        print("PK video room table cell ka deinit call hua hai.")
        timer.invalidate()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearCache() {
            print("Saare cache clear hue hai")
        }
        
        lblBroadViewCount = nil
        NotificationCenter.default.removeObserver(self)
        headerView.removeFromSuperview()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        backgroundView = nil
        viewBijlee.removeFromSuperview()
        // Invalidate timers
        timer.invalidate()
        pktimer.invalidate()
        
        // Clearing other instance variables
        liveMessages = []
        groupUsers = []
        lottieAnimationViews = []
        userInfoList = nil
        zegoMicUsersList = []
        zegoOpponentMicUsersList = []
        
        // Clearing other lazy variables
        dailyEarningBeans = ""
        weeklyEarningBeans = ""
        //  profileID = 0
        //  userID = 0
        giftFrom = ""
        //  giftFirstUserID = 0
        giftFirstUserName = ""
        giftFirstUserImage = ""
        //  giftSecondUserID = 0
        giftSecondUserName = ""
        giftSecondUserImage = ""
        //   giftThirdUserID = 0
        giftThirdUserName = ""
        giftThirdUserImage = ""
        // giftOpponentFirstUserID = 0
        giftOpponentFirstUsername = ""
        giftOpponentFirstUserImage = ""
        //  giftOpponentSecondUserID = 0
        giftOpponentSecondUsername = ""
        giftOpponentSecondUserImage = ""
        //  giftOpponentThirdUserID = 0
        giftOpponentThirdUsername = ""
        giftOpponentThirdUserImage = ""
        //  myGiftCoins = 0
        // opponentGiftCoins = 0
        // totalTime = 0
        //                    viewPK.removeFromSuperview()
        //                    viewGift.removeFromSuperview()
        //                    viewMain.removeFromSuperview()
        //                    viewBottom.removeFromSuperview()
        //                viewMessage.removeFromSuperview()
        
    }
    
    deinit {
        
        print("PK table view cell main deinit call hua hai.")
        removeLottieAnimationViews()
        groupUsers.removeAll()
        liveMessages.removeAll()
        if var userInfoList = userInfoList {
            userInfoList.removeAll()
        }
        //  userInfoList?.removeAll()
        //   tblViewLiveMessages.dataSource = nil
        //  tblViewLiveMessages.delegate = nil
        //   collectionView.dataSource = nil
        //  collectionView.delegate = nil
        //  collectionView.removeFromSuperview()
        totalMsgData = liveMessageModel()
        
        viewMain = nil
        imgViewUserImage = nil
        lblUserName = nil
        viewBottom = nil
        btnSendMessageOutlet = nil
        viewGift = nil
        btnGameOutlet = nil
        btnGiftOutlet = nil
        viewGift = nil
        
        delegate = nil
        viewMessage = nil
        btnSendMessageOutlet = nil
        viewTextField = nil
        txtFldMessage = nil
        viewMessageBottomConstraints = nil
        viewUserDetailOutlet = nil
        imgViewDistribution = nil
        lblRoomUserName = nil
        lblBroadViewCount = nil
        btnFollowUserOutlet = nil
        btnCloseBroadOutlet = nil
        btnViewDistributionOutlet = nil
        lblDistributionAmount = nil
        btnViewRewardOutlet = nil
        viewLiveMessages = nil
        tblViewLiveMessages = nil
        
        collectionView = nil
        btnViewAudienceOutlet = nil
        viewUserRoomStatus = nil
        lblRoomUserName = nil
        lblRoomUserStatus = nil
        lblViewRewardRank = nil
        btnViewRewardOutlet = nil
        imgViewDistribution = nil
        viewOneToOneCall = nil
        viewLuckyGiftDetails = nil
        viewLuckyGift = nil
        imgViewGift = nil
        imgViewUser = nil
        viewUserImage = nil
        viewGift = nil
        lblSendGiftHostName = nil
        lblNoOfGift = nil
        
        headerView.removeFromSuperview()
        print("PK video room table cell ka deinit call hua hai.")
        timer.invalidate()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearCache() {
            print("Saare cache clear hue hai")
        }
        
        lblBroadViewCount = nil
        NotificationCenter.default.removeObserver(self)
        headerView.removeFromSuperview()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        backgroundView = nil
        viewBijlee.removeFromSuperview()
        // Invalidate timers
        timer.invalidate()
        pktimer.invalidate()
        
        // Clearing other instance variables
        liveMessages = []
        groupUsers = []
        lottieAnimationViews = []
        userInfoList = nil
        zegoMicUsersList = []
        zegoOpponentMicUsersList = []
        
        // Clearing other lazy variables
        dailyEarningBeans = ""
        weeklyEarningBeans = ""
        profileID = 0
        userID = 0
        giftFrom = ""
        giftFirstUserID = 0
        giftFirstUserName = ""
        giftFirstUserImage = ""
        giftSecondUserID = 0
        giftSecondUserName = ""
        giftSecondUserImage = ""
        giftThirdUserID = 0
        giftThirdUserName = ""
        giftThirdUserImage = ""
        giftOpponentFirstUserID = 0
        giftOpponentFirstUsername = ""
        giftOpponentFirstUserImage = ""
        giftOpponentSecondUserID = 0
        giftOpponentSecondUsername = ""
        giftOpponentSecondUserImage = ""
        giftOpponentThirdUserID = 0
        giftOpponentThirdUsername = ""
        giftOpponentThirdUserImage = ""
        myGiftCoins = 0
        opponentGiftCoins = 0
        totalTime = 0
        //            viewPK.removeFromSuperview()
        //            viewGift.removeFromSuperview()
        //            viewMain.removeFromSuperview()
        //            viewBottom.removeFromSuperview()
        //        viewMessage.removeFromSuperview()
        
    }
    
}

// MARK: - EXTENSION FOR USING FUNCTIONS TO ADD/REMOVE LOTTIE ANIMATION AND TO CONFIGURE UI AND START TIMER AND REGISTER FUNCTIONS FOR TABLE AND COLLECTION VIEW WORK

extension PKViewTableViewCell {
    
    func addLottieAnimation() {
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
        animationView1.frame = imgViewDistribution.bounds
        imgViewDistribution.addSubview(animationView1)
        
        animationView1.animation = LottieAnimation.named("contribution_icon") // Replace with your animation file name
        animationView1.loopMode = .loop
        animationView1.play()
        animationView1.isUserInteractionEnabled = false
        
        let animationView2 = LottieAnimationView()
        animationView2.contentMode = .scaleAspectFit
        animationView2.frame = viewOneToOneCall.bounds
        viewOneToOneCall.addSubview(animationView2)
        
        animationView2.animation = LottieAnimation.named("Call2") // Replace with your animation file name
        animationView2.loopMode = .loop
        animationView2.play()
        animationView2.isUserInteractionEnabled = false
        
        let animationView3 = LottieAnimationView()
        animationView3.contentMode = .scaleToFill
        animationView3.frame = viewPKAnimation.bounds
        viewPKAnimation.addSubview(animationView3)
        
        animationView3.animation = LottieAnimation.named("PK_small") // Replace with your animation file name
        animationView3.loopMode = .loop
        animationView3.play()
        animationView3.isUserInteractionEnabled = false
        
//        //MARK: - LottieBoomAnimation
        self.viewPKAnimation01.isHidden = false
        isAnimation = false
        
        let animationView4 = LottieAnimationView()
        animationView4.contentMode = .scaleToFill
        animationView4.frame = viewStackMiddle.bounds
        viewStackMiddle.addSubview(animationView4)
        
        animationView4.animation = LottieAnimation.named("MId_animation_Udpated") // Replace with your animation file name
        animationView4.loopMode = .loop
        animationView4.animationSpeed = 0.5
        animationView4.play()
        animationView4.isUserInteractionEnabled = false
        
        let animationView5 = LottieAnimationView()
        animationView5.contentMode = .scaleAspectFit
        animationView5.frame = viewLiveAnimation.bounds
        viewLiveAnimation.addSubview(animationView5)
        
        animationView5.animation = LottieAnimation.named("live_animation") // Replace with your animation file name
        animationView5.loopMode = .loop
        animationView5.play()
        animationView5.isUserInteractionEnabled = false
        
        lottieAnimationViews = [animationView, animationView1, animationView2, animationView3, animationView4, animationView5]
        
    }
    
    func LottieBoomAnimation(){
        //MARK: - Animation
        let animationViewPK = LottieAnimationView()
        animationViewPK.contentMode = .scaleToFill
        animationViewPK.frame = viewPKAnimation01.bounds
        viewPKAnimation01.addSubview(animationViewPK)
        viewPKAnimation01.layer.cornerRadius = 10
        
        animationViewPK.animation = LottieAnimation.named("PK_small") // Replace with your animation file name
        animationViewPK.loopMode = .loop
        animationViewPK.animationSpeed = 0.5
//        animationViewPK.backgroundColor = UIColor.systemYellow
        viewPKAnimation01.alpha = 0.0
        viewPKAnimation01.transform = CGAffineTransform(scaleX: 0.0, y: 0.0) // Start fully scaled down
        boomAnimation()
        animationViewPK.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.boomAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                if self.pkcloseBroad == 0{
                    self.viewPKAnimation01.isHidden = true
                }
            }
        }
        animationViewPK.isUserInteractionEnabled = false
    }
    
    func boomAnimation() {
            // Start with a quick scale-up "boom" effect and add rotation
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 10,
                           options: [.curveEaseOut],
                           animations: {
                // Scale it up, rotate, and fade it in
                let scaleTransform = CGAffineTransform(scaleX: 1.2, y: 1.2) // Overshoot the size
                let rotationTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 4) // Rotate by 45 degrees
                self.viewPKAnimation01.transform = scaleTransform.concatenating(rotationTransform) // Combine scale and rotation
                self.viewPKAnimation01.alpha = 1.0
            }, completion: { _ in
                // Add a slight scale-down and remove some of the rotation for a subtle "bounce back" effect
                UIView.animate(withDuration: 0.1, animations: {
                    self.viewPKAnimation01.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // Return to normal size
                })
            })
        }
   
    func removeLottieAnimationViews() {
          // Remove Lottie animation views from their superviews
          lottieAnimationViews.forEach { $0.removeFromSuperview() }
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
        viewMain.backgroundColor = #colorLiteral(red: 0.1331779929, green: 0.01851655321, blue: 0.09019608051, alpha: 1)
//        GlobalClass.sharedInstance.setPKControllerBackgroundColour()
        viewMessage.isHidden = true
        viewMessage.layer.cornerRadius = viewMessage.frame.size.height / 2
        viewMessage.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        txtFldMessage.setLeftPaddingPoints(15)
        viewUserDetailOutlet.layer.cornerRadius = viewUserDetailOutlet.frame.size.height / 2
        imgViewUserImage.layer.cornerRadius = imgViewUserImage.frame.size.height / 2
        imgViewUserImage.clipsToBounds = true
        btnViewDistributionOutlet.layer.cornerRadius = btnViewDistributionOutlet.frame.size.height / 2
        btnViewDistributionOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btnViewRewardOutlet.layer.cornerRadius = btnViewRewardOutlet.frame.size.height / 2
        btnViewRewardOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewUserRoomStatus.layer.cornerRadius = viewUserRoomStatus.frame.height / 2
        viewUserRoomStatus.backgroundColor = .black.withAlphaComponent(0.6)
        lblRoomUserName.textColor = UIColor(hexString: "FFC300")
        
        viewPKSecondUserName.backgroundColor = .black.withAlphaComponent(0.4)
        viewPKSecondUserName.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        viewPKSecondUserName.layer.cornerRadius = viewPKSecondUserName.frame.height / 2
        
        viewPKBottom.backgroundColor = #colorLiteral(red: 0.1816209947, green: 0.1313851712, blue: 0.2472988534, alpha: 1)
//        GlobalClass.sharedInstance.setPKControllerBackgroundColour()
       
        viewLuckyGiftDetails.layer.cornerRadius = viewLuckyGiftDetails.frame.height / 2
        viewLuckyGiftDetails.backgroundColor = .black.withAlphaComponent(0.3)
        viewGiftImage.layer.cornerRadius = viewGiftImage.frame.height / 2
        viewUserImage.layer.cornerRadius = viewUserImage.frame.height / 2
        imgViewGift.layer.cornerRadius = imgViewGift.frame.height / 2
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        
        viewTimerCount.backgroundColor = .black.withAlphaComponent(0.5)
        
    }
    
    func tableViewWork() {
        
        tblViewLiveMessages?.register(UINib(nibName: "LiveMessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessagesTableViewCell")
        tblViewLiveMessages?.register(UINib(nibName: "LiveMessageHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessageHeaderTableViewCell")
        tblViewLiveMessages.rowHeight = UITableView.automaticDimension
        tblViewLiveMessages.delegate = self
        tblViewLiveMessages.dataSource = self
        tblViewLiveMessages.tableHeaderView = headerView
        
    }
    
    func collectionViewWork() {
        collectionView.register(UINib(nibName: "BroadJoinCollectionViewCell2", bundle: nil), forCellWithReuseIdentifier: "BroadJoinCollectionViewCell2")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true

    }
    
    func timerAndNotification() {
       
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(handleTap), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       
//        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: contentView.frame.width - 20)
//        widthConstraint.isActive = true
       
        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: btnJoinMicOutlet, attribute: .leading, multiplier: 1.0, constant: 2)
        widthConstraint.isActive = true
        
        let userNameWidthConstraint = NSLayoutConstraint(item: lblRoomUserName, attribute: .width, relatedBy: .lessThanOrEqual, toItem: viewUserRoomStatus, attribute: .width, multiplier: 0.5, constant: viewUserRoomStatus.frame.width / 2) // Adjust the multiplier and constant as needed
        userNameWidthConstraint.isActive = true
        
        
    }
    
    func configureBottomBarWork() {
        
      //  viewLeftStackWidthConstraints.constant = pkBarStackView.frame.width / 5
     //   viewMiddleStackWidthConstraints.constant = 100
       // viewStackMiddle.isHidden = true
        let leftColor = GlobalClass.sharedInstance.setPKLeftViewColour()
        let rightColor = GlobalClass.sharedInstance.setPKRightViewColour()
        addGradientToLeftAndRight(to: viewStackMiddle, cornerRadius: 0, leftColor: leftColor, rightColor: rightColor)
        
        viewStackLeft.backgroundColor = GlobalClass.sharedInstance.setPKLeftViewColour()
        viewStackRight.backgroundColor = GlobalClass.sharedInstance.setPKRightViewColour()
        
    }
    
    func configureImages() {
        
        imgViewGiftUserOne.layer.cornerRadius = imgViewGiftUserOne.frame.height / 2
        imgViewGiftUserTwo.layer.cornerRadius = imgViewGiftUserTwo.frame.height / 2
        imgViewGiftUserThree.layer.cornerRadius = imgViewGiftUserThree.frame.height / 2
       
        imgViewGiftUserOne.clipsToBounds = true
        imgViewGiftUserTwo.clipsToBounds = true
        imgViewGiftUserThree.clipsToBounds = true
        
        imgViewGiftOpponentUserOne.layer.cornerRadius = imgViewGiftOpponentUserOne.frame.height / 2
        imgViewGiftOpponentUserTwo.layer.cornerRadius = imgViewGiftOpponentUserTwo.frame.height / 2
        imgViewGiftOpponentUserThree.layer.cornerRadius = imgViewGiftOpponentUserThree.frame.height / 2
        
        imgViewGiftOpponentUserOne.clipsToBounds = true
        imgViewGiftOpponentUserTwo.clipsToBounds = true
        imgViewGiftOpponentUserThree.clipsToBounds = true
        
        imgViewFirstUserOnMic.layer.cornerRadius = imgViewFirstUserOnMic.frame.height / 2
        imgViewSecondUserOnMic.layer.cornerRadius = imgViewSecondUserOnMic.frame.height / 2
        imgViewThirdUserOnMic.layer.cornerRadius = imgViewThirdUserOnMic.frame.height / 2
        
        imgViewFirstUserOnMic.clipsToBounds = true
        imgViewSecondUserOnMic.clipsToBounds = true
        imgViewThirdUserOnMic.clipsToBounds = true
        
        imgViewOpponentFirstUserOnMic.layer.cornerRadius = imgViewOpponentFirstUserOnMic.frame.height / 2
        imgViewOpponentSecondUserOnMic.layer.cornerRadius = imgViewOpponentSecondUserOnMic.frame.height / 2
        imgViewOpponentThirdUserOnMic.layer.cornerRadius = imgViewOpponentThirdUserOnMic.frame.height / 2
        
        imgViewOpponentFirstUserOnMic.clipsToBounds = true
        imgViewOpponentSecondUserOnMic.clipsToBounds = true
        imgViewOpponentThirdUserOnMic.clipsToBounds = true
        
    }
    

    func updateBottomBarStack() {
        // Capture self weakly to avoid strong reference cycles
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("Updating bottom bar with myGiftCoins: \(myGiftCoins) and opponentGiftCoins: \(opponentGiftCoins)")
            
            let animationView5 = LottieAnimationView()
            
            // Ensure that both myGiftCoins and opponentGiftCoins are greater than or equal to 0
            guard myGiftCoins >= 0, opponentGiftCoins >= 0 else {
                print("Invalid values for gift coins.")
                viewBijlee.removeFromSuperview()
                viewBijlee.isHidden = true
                if let index = lottieAnimationViews.firstIndex(of: animationView5) {
                    animationView5.removeFromSuperview()
                    lottieAnimationViews.remove(at: index)
                } else {
                    print("Lottie animation array se bijlee wala lottie hai hi nahi.")
                }

                return
            }
            
            if myGiftCoins == opponentGiftCoins {
                print("Both coins are the same. No adjustment needed.")
                viewLeftStackWidthConstraints.constant = pkBarStackView.frame.width / 3
                viewRightStackWidthConstraints.constant = pkBarStackView.frame.width / 3
                lblLeftStackViewGiftAmount.text = String(myGiftCoins)
                lblRightStackViewGiftAmount.text = String(opponentGiftCoins)
                
            } else {
                print("Adjusting stack views based on different coins.")
                let totalCoins = Float(myGiftCoins + opponentGiftCoins)
                let mScreenWidth = Float(pkBarStackView.frame.width)
                
                let i4 = Int((mScreenWidth * Float(myGiftCoins)) / totalCoins)
                let i5 = Int((mScreenWidth * Float(opponentGiftCoins)) / totalCoins)
                
                let minimumWidth = Int(100)
                
                var adjustedI4 = max(minimumWidth, i4)
                var adjustedI5 = max(minimumWidth, i5)
                
                if adjustedI4 + adjustedI5 > Int(mScreenWidth) {
                    // Adjust widths proportionally if the sum exceeds the screen width
                    let ratio = mScreenWidth / Float(adjustedI4 + adjustedI5)
                    adjustedI4 = Int(Float(adjustedI4) * ratio)
                    adjustedI5 = Int(Float(adjustedI5) * ratio)
                }
                
                // Check if one of the coins is significantly smaller than the other
                if self.myGiftCoins < self.opponentGiftCoins {
                    // Decrease the width of the left view if myGiftCoins is smaller
                    adjustedI4 = Int(Float(adjustedI4) * 0.8) // Adjust the multiplier according to your preference
                } else if self.opponentGiftCoins < self.myGiftCoins {
                    // Decrease the width of the right view if opponentGiftCoins is smaller
                    adjustedI5 = Int(Float(adjustedI5) * 0.8) // Adjust the multiplier according to your preference
                }
                
                let diffBetweenViews = myGiftCoins - opponentGiftCoins
                if (diffBetweenViews < 100) {
                    if (myGiftCoins > opponentGiftCoins) {
                        viewRightStackWidthConstraints.constant = viewStackRight.frame.width - CGFloat(diffBetweenViews)
                        viewLeftStackWidthConstraints.constant = viewStackLeft.frame.width + CGFloat(diffBetweenViews)
                        if (viewRightStackWidthConstraints.constant < 50) {
                            viewRightStackWidthConstraints.constant = 100
                        } else if (viewLeftStackWidthConstraints.constant < 50) {
                            viewLeftStackWidthConstraints.constant = 100
                        }
                    } else {
                        viewLeftStackWidthConstraints.constant = CGFloat(adjustedI4)
                        viewRightStackWidthConstraints.constant = CGFloat(adjustedI5)
                    }
                } else {
                    viewLeftStackWidthConstraints.constant = CGFloat(adjustedI4)
                    viewRightStackWidthConstraints.constant = CGFloat(adjustedI5)
                }
                print("Adjusted left stack view width: \(adjustedI4)")
                print("Adjusted right stack view width: \(adjustedI5)")
                print("View stack left width: \(self.viewStackLeft.frame.width)")
                print("View stack right width: \(self.viewStackRight.frame.width)")
                print("Difference between views: \(diffBetweenViews)")
                print("Right stack constraint constant: \(self.viewRightStackWidthConstraints.constant)")
                print("Left stack constraint constant: \(self.viewLeftStackWidthConstraints.constant)")
                print("Stack View total width is: \(self.pkBarStackView.frame.width)")
                
                lblLeftStackViewGiftAmount.text = String(self.myGiftCoins)
                lblRightStackViewGiftAmount.text = String(self.opponentGiftCoins)
            }
            
            if (myGiftCoins > 1000 || opponentGiftCoins > 1000) {
                if !viewBijlee.isDescendant(of: viewPK) {
                    viewPK.addSubview(viewBijlee)
                }

                viewBijlee.frame = CGRect(x: 0, y: 0, width: 30, height: viewPK.frame.height - 110)
                viewBijlee.center = CGPoint(x: self.viewPK.center.x, y: viewBijlee.center.y + 30)

                print("Beech mai bijlee wala view dikhana hai")
                
                viewBijlee.isHidden = false
//                let animationView5 = LottieAnimationView()
                animationView5.contentMode = .scaleToFill
                animationView5.frame = viewBijlee.bounds
                viewBijlee.addSubview(animationView5)
                
                animationView5.animation = LottieAnimation.named("PkMiddleBijlee") // Replace with your animation file name
                animationView5.loopMode = .loop
                animationView5.play()
                animationView5.isUserInteractionEnabled = false
                
                lottieAnimationViews.append(animationView5)
            } else {
                print("Beech mai bijlee wala view nahi dikhana hai")
                viewBijlee.removeFromSuperview()
                viewBijlee.isHidden = true
            }
        }
    }

    func calculatePKTotalTime() {
    
        print(pkEndTime)
        
        getCurrentTime { success in
            if success {
                print("Current time fetched successfully")
                let timestamp = TimeInterval(self.pkEndTime)
                let dateString = self.convertTimestampToDateString(timestamp: timestamp)
                print(dateString)
                
                let dateString1 = self.pkCurrentTime
                let dateString2 = dateString

                if let timeDifference = self.timeLeftBetweenDatesInMinutesAndSeconds(dateString1: dateString1, dateString2: dateString2) {
                    print("Time difference in seconds: \(timeDifference)")
                    
                    let a = ((timeDifference.minutes * 60) + timeDifference.seconds) - 60
                    if (a < 0) {
                        self.totalTime = 240
                    } else {
                        self.totalTime = a
                    }
                    self.pkTimeDifference = a
//                    self.totalTime = a
                    self.startTimer()
                    
                } else {
                    print("Invalid date format")
                }
                
            } else {
                print("Failed to fetch current time")
            }
        }
        
    }
    
    func startTimer() {
        pktimer.invalidate()
        
        // Capture self weakly to avoid strong reference cycles
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            lblTimerCount.isHidden = false
            pktimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
  
    @objc func updateTime() {
        // Capture self weakly within the closure
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            lblTimerCount.text = timeFormatted(totalTime)
            
            if totalTime != 0 {
                totalTime -= 1
            } else {
                endTimer()
            }
        }
    }

    func endTimer() {
        // Capture self weakly to avoid strong reference cycles
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            lblTimerCount.text = "00:00"
//            totalTime = pkTimeDifference
//            startTimer()
           // self.pktimer.invalidate()
           // self.lblTimerCount.isHidden = true
        }
    }
   
    func timeFormatted(_ totalSeconds: Int) -> String {     // Added on 20 December
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func timeLeftBetweenDatesInMinutesAndSeconds(dateString1: String, dateString2: String) -> (minutes: Int, seconds: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date1 = dateFormatter.date(from: dateString1),
           let date2 = dateFormatter.date(from: dateString2) {
            let timeInterval = date2.timeIntervalSince(date1)
            
            // Convert time interval to seconds
            let totalSeconds = Int(timeInterval)
            
            // Calculate minutes and remaining seconds
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            
            return (minutes, seconds)
        }
        
        return nil
    }

    func hideViewsOnSwipe() {
    
        btnCloseBroadOutlet.isHidden = false
        viewBottom.isHidden = true
        viewUserDetailOutlet.isHidden = true
        btnViewDistributionOutlet.isHidden = true
        btnViewRewardOutlet.isHidden = true
        viewLiveMessages.isHidden = true
        collectionView.isHidden = true
        btnViewAudienceOutlet.isHidden = true
        viewUserRoomStatus.isHidden = true
        btnJoinMicOutlet.isHidden = true
        viewOneToOneCall.isHidden = true
        btnMuteMicOutlet.isHidden = true
        btnMicOutlet.isHidden = true
        btnSendMessageOutlet.isHidden = true
        btnGameOutlet.isHidden = true
      //  viewPKBottom.isHidden = true
      //  viewGift.isHidden = false
        
    }
    
    func unhideViewsOnSwipe() {
    
        btnCloseBroadOutlet.isHidden = false
        viewBottom.isHidden = false
        viewUserDetailOutlet.isHidden = false
        btnViewDistributionOutlet.isHidden = false
        btnViewRewardOutlet.isHidden = false
        viewLiveMessages.isHidden = false
        collectionView.isHidden = false
        btnViewAudienceOutlet.isHidden = false
        viewUserRoomStatus.isHidden = false
        if (isJoinMicPressed == true) {
            btnJoinMicOutlet.isHidden = true
        } else {
            btnJoinMicOutlet.isHidden = false
        }
        if (hostFollow == 1) {
            btnFollowUserOutlet.isHidden = true
        } else {
            btnFollowUserOutlet.isHidden = false
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
        btnSendMessageOutlet.isHidden = false
        btnGameOutlet.isHidden = false
     //   viewPKBottom.isHidden = false
        
    }
    
    
}

// MARK: - EXTENSION IS USED TO DEFINE FUNCTIONS HERE FOR VIEW ANIMATING AND FOR HIDE/SHOW KEYBOARD

extension PKViewTableViewCell {

    @objc func handleTap() {
        // Capture self weakly to avoid strong reference cycles
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            lblViewRewardRank.text = "Daily" + " " + dailyEarningBeans
            let originalFrame = btnViewRewardRankOutlet.frame
            let newFrame = CGRect(x: originalFrame.origin.x,
                                  y: originalFrame.origin.y - 4, // Adjust the value as needed
                                  width: originalFrame.size.width,
                                  height: originalFrame.size.height)

            UIView.animate(withDuration: 0.5, animations: {
                self.btnViewRewardRankOutlet.frame = newFrame
            })
            animateView()
        }
    }
    
    func animateView() {
        // Capture self weakly to avoid strong reference cycles
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Calculate the new frame for the view
            let originalFrame = btnViewRewardRankOutlet.frame
            let newFrame = CGRect(x: originalFrame.origin.x,
                                  y: originalFrame.origin.y - 4, // Adjust the value as needed
                                  width: originalFrame.size.width,
                                  height: originalFrame.size.height)

            UIView.animate(withDuration: 0.5, animations: {
                self.btnViewRewardRankOutlet.frame = newFrame
            }) { (finished) in
                self.lblViewRewardRank.text = "Weekly" + " " + self.weeklyEarningBeans
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               contentView.bringSubviewToFront(viewMessage)
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
         
           contentView.sendSubviewToBack(viewMessage)
           UIView.animate(withDuration: 0.3) {
               self.viewMessageBottomConstraints.constant = 20 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
               self.viewMessage.frame.origin.y = self.contentView.frame.size.height - self.viewMessage.frame.size.height
               self.viewMessage.isHidden = true
               self.txtFldMessage.text = ""
               print("jab keyboard hide hoga tb message view ka origin y hai: \(self.viewMessage.frame.origin.y)")
               
           }
       }
    
    func convertTimestampToDateString(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000) // Convert milliseconds to seconds
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND THEIR FUNCTION'S WORKING

extension PKViewTableViewCell : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveMessagesTableViewCell", for: indexPath) as! LiveMessagesTableViewCell
       
        cell.lblUserLevel.text = " Lv." + (liveMessages[indexPath.row].level ?? "N/A") 
        cell.lblUserName.text = liveMessages[indexPath.row].userName ?? "N/A"
       
        if (liveMessages[indexPath.row].type == "2") {
          
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("The selected message indexPath is: \(indexPath.row)")
        let image = liveMessages[indexPath.row].userImage ?? ""
        let name = liveMessages[indexPath.row].userName ?? ""
        let level = liveMessages[indexPath.row].level ?? ""
        let id = liveMessages[indexPath.row].userID ?? ""
        
        delegate?.pkmessageClicked(userImage: image, userName: name, userLevel: level, userID: id)
        
    }
}

// MARK: - EXXTENSION FOR USING COLLECTION VIEW DELEGATES AND FUNCTIONS AND THEIR WORKING

extension PKViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userInfoList?.count ?? 0
        
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BroadJoinCollectionViewCell2", for: indexPath) as! BroadJoinCollectionViewCell2
   
//        self.viewPKAnimation01.isHidden = false
      
        if isAnimation == false{
            LottieBoomAnimation()
            isAnimation = true
        }
       
        cell.resetCellState()
        cell.isUserInteractionEnabled = true
        //        self.viewPKAnimation01.isHidden = false
        cell.viewMain2.translatesAutoresizingMaskIntoConstraints = false
        cell.viewMain2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.viewMain2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cell.viewMain2.layer.cornerRadius = 15
        cell.viewMain2.layer.masksToBounds = true
        
        cell.imgViewUserPhoto2.translatesAutoresizingMaskIntoConstraints = false
        cell.imgViewUserPhoto2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.imgViewUserPhoto2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cell.imgViewUserPhoto2.layer.cornerRadius = 15
        cell.imgViewUserPhoto2.layer.masksToBounds = true
        
        //  cell.imgViewUserPhoto.layer.cornerRadius = cell.imgViewUserPhoto.frame.height / 2
        
        
        // Clear the image first
        cell.imgViewUserPhoto2.image = nil
        
        loadImageForCell(from: userInfoList?[indexPath.row].faceURL ?? "", into: cell.imgViewUserPhoto2)
        //        if let imageURL = URL(string: userInfoList?[indexPath.row].faceURL ?? "") {
        //            KF.url(imageURL)
        //                .cacheOriginalImage()
        //                .onSuccess { [weak cell] result in
        //                    DispatchQueue.main.async {
        //                        cell?.imgViewUserPhoto.image = result.image
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
        print(indexPath.item)
        delegate?.pkcellIndexClicked(index: indexPath.row)
        
    }
}

// MARK: - EXTENSION FOR GETTING VALUES AND USING FUNCTIONS TO SET VALUES IN MESSAGES TABLE VIEW AND IN COLLECTION VIEW

extension PKViewTableViewCell {
    
    func insertNewMsgs(msgs: liveMessageModel) {
        totalMsgData  = msgs
        liveMessages.append(msgs)
        print("The live message count here is: \(liveMessages.count)")
        print("The total message count here is: \(msgs.message?.count)")
        tblViewLiveMessages.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.tblViewLiveMessages.numberOfRows(inSection: 0) > 0 {
                let lastRowIndex = self.tblViewLiveMessages.numberOfRows(inSection: 0) - 1
                let indexPath = IndexPath(row: lastRowIndex, section: 0)
                print("Scrolling to indexPath: \(indexPath)")
                self.tblViewLiveMessages.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    
    func insertUserName(name:String,status:String) {
        print(name)
        print(status)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Assuming name and status are your variables
            lblRoomUserName.text = name + ":"
            
            if (status == "4") {
                lblRoomUserStatus.text = "has entered the room"
            } else {
                lblRoomUserStatus.text = "has left the room"
            }
            
        }
    }
    
    func showJoinedUser(users: [V2TIMUserFullInfo]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            print(users.count)
            userInfoList?.removeAll()
            userInfoList = users
            collectionView.reloadData()
        }
    }
    
    func mySideGiftUser(fromUser: String, userImage: String, userID: Int, userName: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print(fromUser)
            print(userImage)
            if fromUser == "1" {
                giftFirstUserID = userID
                giftFirstUserName = userName
                giftFirstUserImage = userImage
                //loadImage(for: userImage, into: imgViewGiftUserOne)
                loadImageForCell(from: userImage, into: imgViewGiftUserOne)
            }
            if fromUser == "2" {
                giftSecondUserID = userID
                giftSecondUserName = userName
                giftSecondUserImage = userImage
               // loadImage(for: userImage, into: imgViewGiftUserTwo)
                loadImageForCell(from: userImage, into: imgViewGiftUserTwo)
            }
            if fromUser == "3" {
                giftThirdUserID = userID
                giftThirdUserName = userName
                giftThirdUserImage = userImage
              //  loadImage(for: userImage, into: imgViewGiftUserThree)
                loadImageForCell(from: userImage, into: imgViewGiftUserThree)
            }
        }
    }

    
    func opponentSideGiftUser(fromUser: String, userImage: String, userID: Int, userName: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if fromUser == "1" {
                giftOpponentFirstUserID = userID
                giftOpponentFirstUsername = userName
                giftOpponentFirstUserImage = userImage
               // loadImage(for: userImage, into: imgViewGiftOpponentUserOne)
                loadImageForCell(from: userImage, into: imgViewGiftOpponentUserOne)
            }
            if fromUser == "2" {
                giftOpponentSecondUserID = userID
                giftOpponentSecondUsername = userName
                giftOpponentSecondUserImage = userImage
               // loadImage(for: userImage, into: imgViewGiftOpponentUserTwo)
                loadImageForCell(from: userImage, into: imgViewGiftOpponentUserTwo)
            }
            if fromUser == "3" {
                giftOpponentThirdUserID = userID
                giftOpponentThirdUsername = userName
                giftOpponentThirdUserImage = userImage
               // loadImage(for: userImage, into: imgViewGiftOpponentUserThree)
                loadImageForCell(from: userImage, into: imgViewGiftOpponentUserThree)
            }
        }
    }

   
   // MARK - Function to show own users on Mic

    func usersOnMic(data: [getZegoMicUserListModel] = []) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            zegoMicUsersList.removeAll()
            zegoMicUsersList = data
            
            if (zegoMicUsersList.isEmpty) || (zegoMicUsersList.count == 0){
                print("Mic user wale main koi nahi hai.")
                imgViewFirstUserOnMic.image = UIImage(named: "seatimage")
                imgViewSecondUserOnMic.image = UIImage(named: "seatimage")
                imgViewThirdUserOnMic.image = UIImage(named: "seatimage")
            } else {
                if (zegoMicUsersList.count == 1) {
                    loadImageForCell(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
                    imgViewSecondUserOnMic.image = UIImage(named: "seatimage")
                    imgViewThirdUserOnMic.image = UIImage(named: "seatimage")
                }
                if (zegoMicUsersList.count == 2) {
                    loadImageForCell(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
                    loadImageForCell(from: zegoMicUsersList[1].coHostUserImage ?? "", into: imgViewSecondUserOnMic)
                    imgViewThirdUserOnMic.image = UIImage(named: "seatimage")
                }
                if (zegoMicUsersList.count >= 3) {
                    loadImageForCell(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
                    loadImageForCell(from: zegoMicUsersList[1].coHostUserImage ?? "", into: imgViewSecondUserOnMic)
                    loadImageForCell(from: zegoMicUsersList[2].coHostUserImage ?? "", into: imgViewThirdUserOnMic)
                }
            }
        }
    }

    
 // MARK - Function to show opponent Users On Mic
    
    func opponentUsersOnMic(data: [getZegoMicUserListModel] = []) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            zegoOpponentMicUsersList.removeAll()
            zegoOpponentMicUsersList = data
            
            if (zegoOpponentMicUsersList.isEmpty) || (zegoOpponentMicUsersList.count == 0) {
                print("Mic user wale main koi nahi hai.")
                imgViewOpponentFirstUserOnMic.image = UIImage(named: "seatimage")
                imgViewOpponentSecondUserOnMic.image = UIImage(named: "seatimage")
                imgViewOpponentThirdUserOnMic.image = UIImage(named: "seatimage")
            } else {
                if (zegoOpponentMicUsersList.count == 1) {
                    loadImageForCell(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
                    imgViewOpponentSecondUserOnMic.image = UIImage(named: "seatimage")
                    imgViewOpponentThirdUserOnMic.image = UIImage(named: "seatimage")
                }
                if (zegoOpponentMicUsersList.count == 2) {
                    loadImageForCell(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
                    loadImageForCell(from: zegoOpponentMicUsersList[1].coHostUserImage ?? "", into: imgViewOpponentSecondUserOnMic)
                    imgViewOpponentThirdUserOnMic.image = UIImage(named: "seatimage")
                }
                if (zegoOpponentMicUsersList.count >= 3) {
                    loadImageForCell(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
                    loadImageForCell(from: zegoOpponentMicUsersList[1].coHostUserImage ?? "", into: imgViewOpponentSecondUserOnMic)
                    loadImageForCell(from: zegoOpponentMicUsersList[2].coHostUserImage ?? "", into: imgViewOpponentThirdUserOnMic)
                }
            }
        }
    }

}

// MARK: - EXTENSION FOR SENDING USER MESSAGE TO THE FIREBASE

extension PKViewTableViewCell {

    func sendMessage(message: String,groupid:String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
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
            
//            let nodeName =  ZLFireBaseManager.share.messageRef.childByAutoId().key ?? generateRandomString(length: 20)
//
//            ZLFireBaseManager.share.messageRef.child("message").child(String(format: "%d", profileID ?? 0)).child(nodeName).setValue(dic) { (error, reference) in
//                if let error = error {
//                    print("Error writing data: \(error)")
//                } else {
//                    print("Message sent and written successfully on firebase.")
//                }
//            }
            
            print("The group id for sending message is: \(groupid)")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    V2TIMManager.sharedInstance().sendGroupTextMessage(
                        jsonString,
                        to: groupid,
                        priority: V2TIMMessagePriority(rawValue: 1)!,
                        succ: {
                            // Success closure
                            print("Message sent successfully in second group in pk.")
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
//        tblViewLiveMessages.reloadData()
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING TO FOLLOW / UNFOLLOW THE USER

extension PKViewTableViewCell {
    
    func follow() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let params = [
                "following_id": strongSelf.userID
            ]
            
            print("The parameter for following user is: \(params)")
            
            ApiWrapper.sharedManager().followUser(url: AllUrls.getUrl.followUser, parameters: params) { (data) in
                guard let self = self else { return }
                
                if let success = data["success"] as? Bool, success {
                    print(data)
                    
                    self.btnFollowUserOutlet.isHidden = true
                    self.btnFollowUserOutlet.isUserInteractionEnabled = true
                    print("sab shi hai. kuch gadbad nahi hai")
                } else {
                    self.btnFollowUserOutlet.isHidden = false
                    self.btnFollowUserOutlet.isUserInteractionEnabled = true
                    
                    print("Kuch gadbad hai")
                }
            }
        }
    }
    
    func getCurrentTime(completion: @escaping (Bool) -> Void) {

        ApiWrapper.sharedManager().getCurrentTimeFromServer(url: AllUrls.getUrl.currentTimeFromServer, completion: { [weak self] (data) in
            guard let self = self else {
                // The object has been deallocated
                completion(false)
                return
            }
            
                print(data)
                print("Sab kuch sahi hai")
            
                print(data["server_time"] as? String)
              
                if let pkTime = data["server_time"] as? String {
                    
                    pkCurrentTime = pkTime
                    
                }
                
                completion(true)
           
        })
    }
}

// MARK: - EXTENSION FOR DOWNLOADING AND SETTING IMAGE INTO THE IMAGE VIEW

extension PKViewTableViewCell {
    
    func addGradientToLeftAndRight(to view: UIView, cornerRadius: CGFloat, leftColor: UIColor, rightColor: UIColor) {
        // Calculate the frame for left and right gradients
        let leftFrame = CGRect(x: 0, y: 0, width: view.bounds.width / 2, height: view.bounds.height)
        let rightFrame = CGRect(x: view.bounds.width / 2, y: 0, width: view.bounds.width / 2, height: view.bounds.height)
        
        // Create gradient layers for left and right sides
        let leftGradientLayer = CAGradientLayer()
        leftGradientLayer.frame = leftFrame
        leftGradientLayer.colors = [leftColor.cgColor, leftColor.cgColor] // Set the same color for the left side
        leftGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        leftGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        leftGradientLayer.cornerRadius = cornerRadius
        
        let rightGradientLayer = CAGradientLayer()
        rightGradientLayer.frame = rightFrame
        rightGradientLayer.colors = [rightColor.cgColor, rightColor.cgColor] // Set the same color for the right side
        rightGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        rightGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        rightGradientLayer.cornerRadius = cornerRadius
        
        // Adding the gradient layers to the view's layer
        view.layer.insertSublayer(leftGradientLayer, at: 0)
        view.layer.insertSublayer(rightGradientLayer, at: 1)
    }
    
}

extension PKViewTableViewCell: UITextFieldDelegate {
    
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
        
//        let gradientColors: [UIColor] = [UIColor(hexString: "#3663E7")!, UIColor(hexString: "#1EB1EB")!]
//        addGradient(to: viewStackRight, cornerRadius: 0, colors: gradientColors)

//        let gradientColors1: [UIColor] = [UIColor(hexString: "#F54355")!, UIColor(hexString: "#ED368E")!]
//        addGradient(to: viewStackLeft, cornerRadius: 0, colors: gradientColors1)

//    func updateBottomBar() {
//
//        if (myGiftCoins > opponentGiftCoins) {
//
//            viewRightStackWidthConstraints.constant = pkBarStackView.frame.width / 4
//
//        } else if (opponentGiftCoins > myGiftCoins) {
//
//            viewLeftStackWidthConstraints.constant = pkBarStackView.frame.width / 6
//          //  viewRightStackWidthConstraints.constant = pkBarStackView.frame.width / 2
//
//        } else if (myGiftCoins == opponentGiftCoins) {
//            viewLeftStackWidthConstraints.constant = pkBarStackView.frame.width / 3
//            viewRightStackWidthConstraints.constant = pkBarStackView.frame.width / 3
//        }
////        if (myGiftCoins <= 0) && (opponentGiftCoins <= 0) || (myGiftCoins == opponentGiftCoins) {
////
////            print("Donoun Coins Zero hai ya donoun coins same hai. Donon coins same rahenge.")
////
////            viewLeftStackWidthConstraints.constant = pkBarStackView.frame.width / 2
////            viewRightStackWidthConstraints.constant = pkBarStackView.frame.width / 2
////
////        }  else {
////
////            print("Ab jab coins kam jyada honge tab ye kaam karvaenge")
////            let totalCoins = Float(myGiftCoins + opponentGiftCoins)
////            let mScreenWidth = pkBarStackView.frame.width
////
////            var i4 = Int((Float(mScreenWidth) * Float(myGiftCoins)) / totalCoins)
////            var i5 = Int((Float(mScreenWidth) * Float(opponentGiftCoins)) / totalCoins)
////
////            print("Yhn i4 hai: \(i4)")
////            print("Yhn i5 hai: \(i5)")
////
////            let minimumWidth = Int(50)
////
////                if i4 < minimumWidth {
////                    i5 = minimumWidth
////                    i4 = Int(mScreenWidth) - minimumWidth
////             }
////                if i5 < minimumWidth {
////                    i4 = minimumWidth
////                    i5 = Int(mScreenWidth) - minimumWidth
////                }
////
////            viewLeftStackWidthConstraints.constant = CGFloat(i4)
////            viewRightStackWidthConstraints.constant = CGFloat(i5)
////
////            print("The left stack view width is: \(viewLeftStackWidthConstraints.constant)")
////            print("The right stack view width is: \(viewRightStackWidthConstraints.constant)")
////
////        }
////        print("User ke gift coins hai: \(myGiftCoins)")
////        print("Opponent ke gift coins hai: \(opponentGiftCoins)")
//
//        lblLeftStackViewGiftAmount.text = String(myGiftCoins)
//        lblRightStackViewGiftAmount.text = String(opponentGiftCoins)
//    }
//    func usersOnMic(data: [getZegoMicUserListModel] = []) {
//        zegoMicUsersList.removeAll()
//
//        zegoMicUsersList = data
//
//        if (zegoMicUsersList.count == 0) || (zegoMicUsersList == nil) {
//            print("Mic user wale main koi nahi hai.")
//            imgViewFirstUserOnMic.image = UIImage(named: "seatimage")
//            imgViewSecondUserOnMic.image = UIImage(named: "seatimage")
//            imgViewThirdUserOnMic.image = UIImage(named: "seatimage")
//
//        } else {
//            if (zegoMicUsersList.count == 1) {
//                loadImageForCell(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
//                imgViewSecondUserOnMic.image = UIImage(named: "seatimage")
//                imgViewThirdUserOnMic.image = UIImage(named: "seatimage")
//            } else if (zegoMicUsersList.count == 2) {
//                loadImageForCell(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
//                loadImageForCell(from: zegoMicUsersList[1].coHostUserImage ?? "", into: imgViewSecondUserOnMic)
//                imgViewThirdUserOnMic.image = UIImage(named: "seatimage")
//            } else if (zegoMicUsersList.count >= 3) {
//                loadImageForCell(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
//                loadImageForCell(from: zegoMicUsersList[1].coHostUserImage ?? "", into: imgViewSecondUserOnMic)
//                loadImageForCell(from: zegoMicUsersList[2].coHostUserImage ?? "", into: imgViewThirdUserOnMic)
//
//            }
//        }
//    }

//    func opponentUsersOnMic(data: [getZegoMicUserListModel] = []) {
//        zegoOpponentMicUsersList.removeAll()
//
//        zegoOpponentMicUsersList = data
//
//        if (zegoOpponentMicUsersList.count == 0) || (zegoOpponentMicUsersList == nil) {
//            print("Mic user wale main koi nahi hai.")
//            imgViewOpponentFirstUserOnMic.image = UIImage(named: "seatimage")
//            imgViewOpponentSecondUserOnMic.image = UIImage(named: "seatimage")
//            imgViewOpponentThirdUserOnMic.image = UIImage(named: "seatimage")
//
//        } else {
//            if (zegoOpponentMicUsersList.count == 1) {
//                loadImageForCell(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
//                imgViewOpponentSecondUserOnMic.image = UIImage(named: "seatimage")
//                imgViewOpponentThirdUserOnMic.image = UIImage(named: "seatimage")
//            } else if (zegoOpponentMicUsersList.count == 2) {
//                loadImageForCell(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
//                loadImageForCell(from: zegoOpponentMicUsersList[1].coHostUserImage ?? "", into: imgViewOpponentSecondUserOnMic)
//                imgViewOpponentThirdUserOnMic.image = UIImage(named: "seatimage")
//            } else if (zegoOpponentMicUsersList.count >= 3) {
//                loadImageForCell(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
//                loadImageForCell(from: zegoOpponentMicUsersList[1].coHostUserImage ?? "", into: imgViewOpponentSecondUserOnMic)
//                loadImageForCell(from: zegoOpponentMicUsersList[2].coHostUserImage ?? "", into: imgViewOpponentThirdUserOnMic)
//
//            }
//        }
//    }

//    func sendMessage(message:String) {
//
//        var dic = [String: Any]()
//        dic["level"] = UserDefaults.standard.string(forKey: "level")
//        dic["gender"] = UserDefaults.standard.string(forKey: "gender")
//        dic["user_id"] = UserDefaults.standard.string(forKey: "UserProfileId")
//        dic["user_name"] = UserDefaults.standard.string(forKey: "UserName")
//        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
//            dic["user_image"] = picM ?? ""
//        }
//
//        dic["type"] = "1"
//        dic["message"] = message
//        dic["ownHost"] = true
//
//        let nodeName =  ZLFireBaseManager.share.messageRef.childByAutoId().key ?? generateRandomString(length: 20)
//
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
//
//    }

//    func follow() {
//
//      let params = [
//          "following_id": userID
//
//      ] as [String : Any]
//
//      print("The parameter for following user is: \(params)")
//
//      ApiWrapper.sharedManager().followUser(url: AllUrls.getUrl.followUser,parameters: params) { [weak self] (data) in
//          guard let self = self else { return }
//
//          if (data["success"] as? Bool == true) {
//              print(data)
//
//              btnFollowUserOutlet.isHidden = true
//              btnFollowUserOutlet.isUserInteractionEnabled = true
//              print("sab shi hai. kuch gadbad nahi hai")
//
//          }  else {
//
//              btnFollowUserOutlet.isHidden = false
//              btnFollowUserOutlet.isUserInteractionEnabled = true
//
//              print("Kuch gadbad hai")
//
//          }
//      }
//  }

//    func loadImage(for imageURL: String?, into imageView: UIImageView) {
//        guard let imageURLString = imageURL, let url = URL(string: imageURLString) else {
//            imageView.image = UIImage(named: "UserPlaceHolderImageForCell")
//            return
//        }
//
//        KF.url(url)
//            .cacheOriginalImage()
//            .onSuccess { result in
//                DispatchQueue.main.async {
//                    imageView.image = result.image
//                }
//            }
//            .onFailure { error in
//                print("Image loading failed with error: \(error)")
//                imageView.image = UIImage(named: "UserPlaceHolderImageForCell")
//            }
//            .set(to: imageView)
//    }

//    func updateBottomBarStack() {
//        print("Updating bottom bar with myGiftCoins: \(myGiftCoins) and opponentGiftCoins: \(opponentGiftCoins)")
//
//        // Ensure that both myGiftCoins and opponentGiftCoins are greater than or equal to 0
//        guard myGiftCoins >= 0, opponentGiftCoins >= 0 else {
//            print("Invalid values for gift coins.")
//            viewBijlee.removeFromSuperview()
//            viewBijlee.isHidden = true
//
//            return
//        }
//
//        if myGiftCoins == opponentGiftCoins {
//            print("Both coins are the same. No adjustment needed.")
//            viewLeftStackWidthConstraints.constant = pkBarStackView.frame.width / 3
//            viewRightStackWidthConstraints.constant = pkBarStackView.frame.width / 3
//            lblLeftStackViewGiftAmount.text = String(myGiftCoins)
//            lblRightStackViewGiftAmount.text = String(opponentGiftCoins)
//
//        } else {
//            print("Adjusting stack views based on different coins.")
//            let totalCoins = Float(myGiftCoins + opponentGiftCoins)
//            let mScreenWidth = Float(pkBarStackView.frame.width)
//
//            let i4 = Int((mScreenWidth * Float(myGiftCoins)) / totalCoins)
//            let i5 = Int((mScreenWidth * Float(opponentGiftCoins)) / totalCoins)
//
//            let minimumWidth = Int(50)
//
//            var adjustedI4 = max(minimumWidth, i4)
//            var adjustedI5 = max(minimumWidth, i5)
//
//            if adjustedI4 + adjustedI5 > Int(mScreenWidth) {
//                // Adjust widths proportionally if the sum exceeds the screen width
//                let ratio = mScreenWidth / Float(adjustedI4 + adjustedI5)
//                adjustedI4 = Int(Float(adjustedI4) * ratio)
//                adjustedI5 = Int(Float(adjustedI5) * ratio)
//            }
//
//            // Check if one of the coins is significantly smaller than the other
//            if myGiftCoins < opponentGiftCoins {
//                // Decrease the width of the left view if myGiftCoins is smaller
//                adjustedI4 = Int(Float(adjustedI4) * 0.8) // Adjust the multiplier according to your preference
//            } else if opponentGiftCoins < myGiftCoins {
//                // Decrease the width of the right view if opponentGiftCoins is smaller
//                adjustedI5 = Int(Float(adjustedI5) * 0.8) // Adjust the multiplier according to your preference
//            }
//
//            let diffBetweenViews = myGiftCoins - opponentGiftCoins
//            if (diffBetweenViews < 100) {
//                if (myGiftCoins > opponentGiftCoins) {
//                    viewRightStackWidthConstraints.constant = viewStackRight.frame.width - CGFloat(diffBetweenViews)
//                    viewLeftStackWidthConstraints.constant = viewStackLeft.frame.width + CGFloat(diffBetweenViews)
//                    if (viewRightStackWidthConstraints.constant < 50) {
//                        viewRightStackWidthConstraints.constant = 50
//                    } else if (viewLeftStackWidthConstraints.constant < 50) {
//                        viewLeftStackWidthConstraints.constant = 50
//                    }
//                } else {
//                    viewLeftStackWidthConstraints.constant = CGFloat(adjustedI4)
//                    viewRightStackWidthConstraints.constant = CGFloat(adjustedI5)
//                }
//            } else {
//                viewLeftStackWidthConstraints.constant = CGFloat(adjustedI4)
//                viewRightStackWidthConstraints.constant = CGFloat(adjustedI5)
//            }
//            print("Adjusted left stack view width: \(adjustedI4)")
//            print("Adjusted right stack view width: \(adjustedI5)")
//            print("View stack left width: \(viewStackLeft.frame.width)")
//            print("View stack right width: \(viewStackRight.frame.width)")
//            print("Difference between views: \(diffBetweenViews)")
//            print("Right stack constraint constant: \(viewRightStackWidthConstraints.constant)")
//            print("Left stack constraint constant: \(viewLeftStackWidthConstraints.constant)")
//            print("Stack View total width is: \(pkBarStackView.frame.width)")
//
//            lblLeftStackViewGiftAmount.text = String(myGiftCoins)
//            lblRightStackViewGiftAmount.text = String(opponentGiftCoins)
//        }
//
//        if (myGiftCoins > 100 || opponentGiftCoins > 100) {
//
//                if !viewBijlee.isDescendant(of: viewPK) {
//                    viewPK.addSubview(viewBijlee)
//                }
//
//                viewBijlee.frame = CGRect(x: 0, y: 0, width: 30, height: viewPK.frame.height - 110)
//                viewBijlee.center = CGPoint(x: viewPK.center.x, y: viewBijlee.center.y + 30)
//
//                print("Beech mai bijlee wala view dikhana hai")
//
//
//            viewBijlee.isHidden = false
//            let animationView5 = LottieAnimationView()
//            animationView5.contentMode = .scaleToFill
//            animationView5.frame = viewBijlee.bounds
//            viewBijlee.addSubview(animationView5)
//
//            animationView5.animation = LottieAnimation.named("PkMiddleBijlee") // Replace with your animation file name
//            animationView5.loopMode = .loop
//            animationView5.play()
//            animationView5.isUserInteractionEnabled = false
//
//            lottieAnimationViews.append(animationView5)
//
//        } else {
//            print("Beech mai bijlee wala view nahi dikhana hai")
//            viewBijlee.removeFromSuperview()
//            viewBijlee.isHidden = true
//
//        }
//    }

//    func startTimer() {
//
//        lblTimerCount.isHidden = false
//        pktimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//
//    }

//    @objc func updateTime() {
//
//        lblTimerCount.text = timeFormatted(totalTime)
//
//        if totalTime != 0 {
//            totalTime -= 1
//        } else {
//            endTimer()
//        }
//    }

//    func endTimer() {
//        pktimer.invalidate()
//        lblTimerCount.isHidden = true
//
//    }

//    @objc func handleTap() {
//
//        lblViewRewardRank.text = "Daily" + " " + dailyEarningBeans
//        let originalFrame = btnViewRewardRankOutlet.frame
//        let newFrame = CGRect(x: originalFrame.origin.x,
//                              y: originalFrame.origin.y - 4, // Adjust the value as needed
//                              width: originalFrame.size.width,
//                              height: originalFrame.size.height)
//
//        UIView.animate(withDuration: 0.5, animations: {
//            self.btnViewRewardRankOutlet.frame = newFrame
//        })
//        animateView()
//    }

//    func animateView() {
//           // Calculate the new frame for the view
//           let originalFrame = btnViewRewardRankOutlet.frame
//           let newFrame = CGRect(x: originalFrame.origin.x,
//                                 y: originalFrame.origin.y - 4, // Adjust the value as needed
//                                 width: originalFrame.size.width,
//                                 height: originalFrame.size.height)
//
//           UIView.animate(withDuration: 0.5, animations: {
//               self.btnViewRewardRankOutlet.frame = newFrame
//           }) { (finished) in
//               self.lblViewRewardRank.text = "Weekly" + " " + self.weeklyEarningBeans
//           }
//       }

