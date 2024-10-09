//
//  PublishStreamViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/07/23.
//

import UIKit
import ZegoExpressEngine
import Lottie
import Kingfisher
import ImSDK_Plus
import FirebaseDatabase
import FittedSheets
import ToastViewSwift
//import FURenderKit
import Vision
import AVFoundation

class PublishStreamViewController: UIViewController, delegateJoinMicUserOptionsViewController, delegateCallNotificationViewController, delegatePKShowFriendsListOptionsViewController {
  
    lazy var headerView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: viewLiveMessages.frame.width, height: 100))
        v.backgroundColor = UIColor(hexString: "000000")?.withAlphaComponent(0.35)
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        let lab = UILabel(frame: CGRect(x: 9, y: 8, width: viewLiveMessages.frame.width - 18, height: 100 - 16))
        lab.backgroundColor = .clear
        lab.text = "Welcome to ZeepLive!! Please don't share inappropriate content like pornography or violence as it's strictly against our policy. Our AI system continuously monitors content to ensure compliance"
        lab.textColor = UIColor(hexString: "F9B248")
        lab.numberOfLines = 0
        lab.textAlignment = .left
        lab.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        v.addSubview(lab)
        v.isUserInteractionEnabled = false
        return v
    }()
    
    @IBOutlet weak var viewUserDetailOutlet: UIButton!
    @IBOutlet weak var imgViewUserImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblBroadViewCount: UILabel!
    @IBOutlet weak var btnCloseBroadOutlet: UIButton!
    @IBOutlet weak var btnViewAudienceOutlet: UIButton!
    @IBOutlet weak var collectionViewBroadList: UICollectionView!
    @IBOutlet weak var viewDistributionOutlet: UIButton!
    @IBOutlet weak var imgViewDistribution: UIImageView!
    @IBOutlet weak var lblDistributionAmount: UILabel!
    @IBOutlet weak var viewRewardOutlet: UIButton!
    @IBOutlet weak var viewRewardRankOutlet: UIButton!
    @IBOutlet weak var lblViewRewardRank: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewOneToOneCall: UIView!
    @IBOutlet weak var btnOneToOneCallOutlet: UIButton!
    @IBOutlet weak var viewGift: UIView!
    @IBOutlet weak var btnGiftOutlet: UIButton!
    @IBOutlet weak var btnOpenMessageOutlet: UIButton!
    @IBOutlet weak var btnGameOutlet: UIButton!
    @IBOutlet weak var viewUserRoomStatus: UIView!
    @IBOutlet weak var lblRoomUserName: UILabel!
    @IBOutlet weak var lblRoomUserStatus: UILabel!
    @IBOutlet weak var viewLiveMessages: UIView!
    @IBOutlet weak var tblViewLiveMessages: UITableView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnSendMessageOutlet: UIButton!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var txtfldMessage: UITextField!
    @IBOutlet weak var viewMessageBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewLuckyGift: UIView!
    @IBOutlet weak var lblNoOfGift: UILabel!
    @IBOutlet weak var viewLuckyGiftDetails: UIView!
    @IBOutlet weak var viewUserImage: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var viewGiftImage: UIView!
    @IBOutlet weak var imgViewGift: UIImageView!
    @IBOutlet weak var lblSendGiftToHostName: UILabel!
    @IBOutlet weak var collectionViewJoinMic: UICollectionView!
    @IBOutlet weak var tblViewMicJoinedUsers: UITableView!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var btnPKOutlet: UIButton!
    @IBOutlet weak var tblViewPKRequest: UITableView!
    @IBOutlet weak var viewBeautyFilter: UIView!
    @IBOutlet weak var viewNoFaceDetected: UIView!
    @IBOutlet weak var lblNoFaceDetectTime: UILabel!
    @IBOutlet weak var viewLiveAnimation: UIView!
    
    
    
    lazy var roomState = ZegoRoomState.disconnected
    lazy var publishState = ZegoPublisherState.noPublish
      
    lazy var videoSize = CGSize(width: 0, height: 0)
    lazy var videoCaptureFPS : Double = 0.0
    lazy var videoEncodeFPS : Double = 0.0
    lazy var videoSendFPS : Double = 0.0
    lazy var videoBitrate : Double = 0.0
    lazy var videoNetworkQuality = ""
    lazy var isHardwareEncode = false

    lazy var enableCamera = true {
          didSet {
              ZegoExpressEngine.shared().enableCamera(enableCamera)
          }
      }

     lazy var muteSpeaker = false {
          didSet {
              ZegoExpressEngine.shared().muteSpeaker(muteSpeaker)
          }
      }

     lazy var muteMicrophone = false {
          didSet {
              ZegoExpressEngine.shared().muteMicrophone(muteMicrophone)
          }
      }
      
     lazy var videoConfig = ZegoVideoConfig(preset: .preset1080P)
     lazy var videoMirrorMode = ZegoVideoMirrorMode.onlyPreviewMirror
     lazy var previewViewMode = ZegoViewMode.aspectFill
     lazy var previewCanvas = ZegoCanvas()
    
    lazy var roomId = String()
    lazy var streamId = String()
    lazy var userId = String()
    lazy var timer = Timer()
    lazy var dailyEarningBeans: String = ""
    lazy var weeklyEarningBeans:String = ""
    lazy var lottieAnimationViews: [LottieAnimationView] = []
    lazy var liveMessages: [liveMessageModel] = []
    lazy var groupUsers = [joinedGroupUserProfile]()
    lazy var userInfoList: [V2TIMUserFullInfo]? = []
    lazy var totalMsgData = liveMessageModel()
  //  weak var delegate: delegatePublishStreamViewController?
    var channelName: String = ""
    var userRankHandle: DatabaseHandle?
    var userDailyEarningHandle: DatabaseHandle?
    lazy var streamName: String = ""
    lazy var groupID: String = ""
    lazy var uniqueID: Int = 0
    lazy var weeklyDistributionAmount:String = "0"
    lazy var messageListener = MessageListener()
    lazy var callMemberList: Bool = false
    lazy var vcAudiencePresent:Bool = false
    var userMessageHandle: DatabaseHandle?
    lazy var liveMessage = liveMessageModel()
    lazy var luckyGiftCount = 0
    weak var sheetController:SheetViewController!
   lazy var selectedIndexForProfileDetails = Int()
    lazy var taskID: String = ""
    lazy var coHostRequestList: [getCoHostInviteUsersDetail] = []
     var HostMicRequestHandle:DatabaseHandle?
    lazy var zegoMicUsersList: [getZegoMicUserListModel] = []
    lazy var micUser = getZegoMicUserListModel()
    lazy var zegoOpponentMicUsersList: [getZegoMicUserListModel] = []
   // lazy var room = String()
    lazy var secondRoom = String()
    lazy var isFirstLive: Bool = true
    lazy var isMuteMicButtonPressed = false
    lazy var currentIndexForCoHost: Int = 0
    lazy var zegoSendMicUsersList: [String: String] = [:]
    lazy var openedVCID: String = ""
    lazy var callSenderID: String = ""
    lazy var callSenderName: String = ""
    lazy var callChannelName: String = ""
    lazy var isFirstTime: Bool = true
    lazy var callSenderImage: String = ""
    var pkRequestHandle:DatabaseHandle?
    lazy var pkRequestsHostList: [getPKRequestHostsModel] = []
    lazy var pkRequestHostDetail = getPKRequestHostsModel()
    lazy var pkID: String = ""
    lazy var pkInviteHostData = liveHostListData()
    lazy var hostPKID: String = ""
    var startTime :CFAbsoluteTime?
    var lastCalculateTime : CFAbsoluteTime?
    lazy var isBeautyFilterButtonPressed = false
    var countdownTimer: Timer?
    lazy var totalTime = 180
    var isTimerRunning: Bool = false
    lazy var selectedMessageIndex: Int = 0
    
//    let captureSession = AVCaptureSession()
//      let movieOutput = AVCaptureMovieFileOutput()
//      var previewLayer: AVCaptureVideoPreviewLayer!
//      let faceDetectionRequest = VNDetectFaceRectanglesRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // ZLFaceUnity.share.initSDK()
        
        viewNoFaceDetected.isHidden = true
        
        userId = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        print(userId)
        
        V2TIMManager.sharedInstance().addGroupListener(listener: messageListener)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMessagePushNotification(_:)),
                                               name: Notification.Name("BroadTencentMessage"),
                                               object: nil)
       
        ZegoExpressEngine.destroy(nil)
        
        removePKRequestDetailsOnFirebase()
        removeMessagesOnFirebase()
        removePKRequestOnFirebase()
        removeCoHostInviteDetailsOnFirebase()
        removeCoHostInviteListOnFirebase()
        createLiveBroadcast()
        configureUI()
        tableViewWorkOfPKRequestHosts()
        tableViewWorkOfJoinMicUsers()
        tableViewWork()
        collectionViewWork()
        timerAndNotification()
        addLottieAnimation()
        getGroupCallBack()
        addObserverForPKRequest()
        
      //  setRoomExtraInfo(from: "close")
    //    addObserverForPKRequestDetails()
       // setupCaptureSession()
        // setupPreview()
        
       // createEngine()
        
    }
    
    @IBAction func btnOpenOptionsPressed(_ sender: Any) {
        
        print("Button Open Options Pressed For Selecting Options.")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneOptionsViewController") as! OneToOneOptionsViewController
      
        nextViewController.cameFrom = "host"
        nextViewController.modalPresentationStyle = .overCurrentContext
        nextViewController.delegate = self
        present(nextViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnPKPressed(_ sender: Any) {
        
        print("Button PK Pressed. For Showing Options.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PKPopUpViewController") as! PKPopUpViewController
        nextViewController.modalPresentationStyle = .overCurrentContext
        nextViewController.delegate = self
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createEngine()
        
        if (isFirstTime == true) {
            print("YE sb kch kaam nahi karana hai.")
        } else {
            print("YE sab kaam karana hai.")
         
            createLiveBroadcastForListing()
            addUserOnMic()
            playStream()
            updateUserStatusToFirebase(status:"LIVE")
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleMessagePushNotification(_:)),
                                                   name: Notification.Name("BroadTencentMessage"),
                                                   object: nil)
           // ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), status: "live")
            if isMuteMicButtonPressed
            
            {
                
                isMuteMicButtonPressed = false
              btnMicOutlet.setImage(UIImage(named:  "micon"), for: .normal)
              muteMicrophone = false
                
            }
            
            else{
              
                isMuteMicButtonPressed = true
              btnMicOutlet.setImage(UIImage(named:  "micoff"), for: .normal)
                muteMicrophone = true
                
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("BroadTencentMessage"),
                                                  object: nil)

        endLiveBroadcast()
        removeUserOnMic()
        stopStream()
        isFirstTime = false
        countdownTimer?.invalidate()
        totalTime = 180
        isTimerRunning = false
        countdownTimer = nil
       // FUDemoManager.shared().removeDemoView()
        
    }
    
    deinit {
        print("Publish krne wale controller main deinit call hua hai")
    }
    
}

// MARK: - EXTENSION FOR USING DELEGATES METHODS AND WORKING ACCORDINGLY TO IT.

extension PublishStreamViewController: delegatePKPopUpViewController {

    func buttonRandomMatchPressed(isPressed: Bool) {
        
        print("Button Random PK Pressed. In The Publish Stream View Controller.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PKShowFriendsListOptionsViewController") as! PKShowFriendsListOptionsViewController
            
            nextViewController.delegate = self
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            self.present(nextViewController, animated: true, completion: nil)
        }
        

    }
    
    func buttonPKWithFriendsPressed(isPressed: Bool) {
        
        print("Button PK With friends pressed. In the Publish View Controller.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PKShowFriendsListOptionsViewController") as! PKShowFriendsListOptionsViewController
            
            nextViewController.delegate = self
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - EXTENSION FOR USING DELEGATE FUNCTIONS OF ONE TO ONE OPTIONS VIEW CONTROLLER

extension PublishStreamViewController: delegateOneToOneOptionsViewController {
    
    func cameraOnOffPressed(isPressed: Bool) {
        
        print("Camera On Off function is being called in publish stream view controller.")
        
    }
    
    func cameraFlipPressed(isPressed: Bool) {
        
        print("Flip Camera function is being called in publish stream view controller.")
        
    }
    
    func openBeautyPressed(isPressed: Bool) {
        
        print("Open Face Unity Options is being called in publish stream view controller.")
      
        dismiss(animated: true, completion: nil)
        
        if (isPressed == false) {
        
            print("Face Unity Options ko hide krna hai aur nahi dikhana hai.")
            
            FUDemoManager.shared().hideBottomBar()
            
        } else {
            
            print("Face Unity Options ko show karna hai aur dikhana hai.")
            
            FUDemoManager.shared().showBottomBar()
            
        }
        
    }
    
    //    @IBAction func btnBeautyFilterPressed(_ sender: Any) {
    //
    //        print("Button Open Beauty Filter Pressed.")
    //
    //        if isBeautyFilterButtonPressed {
    //
    //            isBeautyFilterButtonPressed = false
    //            FUDemoManager.shared().hideBottomBar()
    //
    //        } else{
    //
    //            isBeautyFilterButtonPressed = true
    //            FUDemoManager.shared().showBottomBar()
    //
    //        }
    //
    ////        FUDemoManager.shared().showBottomBar()
    //
    //    }
    
}
// MARK: -  EXTENSION FOR ADDING AND REMOVING USERS FROM MIC AND STOPPNG AND PLAYING STREAM OF THE USER AFTER COMING TO THIS PAGE AGAIN

extension PublishStreamViewController {
    
    // MARK: - FUNCTION TO ADD USERS WHO ARE SITTING ON THE MIC AND PLAYING THEIR STREAM
    
    func addUserOnMic() {
        
        if (zegoMicUsersList.count == 0) {
            print("Kuch remove karne ke jarurat nahi hai.")
        } else {
            // Iterate over each element in the zegoMicUsersList array
            zegoMicUsersList.forEach { micUser in
                // Construct the stream ID
                let streamID = channelName + micUser.coHostID! + "_cohost_stream"
                print("The stream id we are passing in case to add join mic is: \(streamID)")
                
                // Stop playing the stream using ZegoExpressEngine
                ZegoExpressEngine.shared().startPlayingStream(streamID)
                
            }
        }
        
        if (zegoOpponentMicUsersList.count == 0) {
            print("Kuch remove karne ke jarurat nahi hai.")
        } else {
            // Iterate over each element in the zegoMicUsersList array
            zegoOpponentMicUsersList.forEach { micUser in
                // Construct the stream ID
                let streamID = channelName + micUser.coHostID! + "_cohost_stream"
                print("The stream id we are passing in case to add join mic is: \(streamID)")
                
                // Stop playing the stream using ZegoExpressEngine
                ZegoExpressEngine.shared().startPlayingStream(streamID)
                
            }
        }
    }
    
    // MARK: - FUNCTION TO REMOVE USERS WHO ARE SITTING ON THE MIC AND STOPPING THEIR STREAM FROM PLAYING
    
    func removeUserOnMic() {
        
        if (zegoMicUsersList.count == 0) {
            print("Kuch remove karne ke jarurat nahi hai.")
        } else {
            // Iterate over each element in the zegoMicUsersList array
            zegoMicUsersList.forEach { micUser in
                // Construct the stream ID
                let streamID = channelName + micUser.coHostID! + "_cohost_stream"
                print("The stream id we are passing in case to remove join mic is: \(streamID)")
                
                // Stop playing the stream using ZegoExpressEngine
                ZegoExpressEngine.shared().stopPlayingStream(streamID)
                
            }
        }
       
        if (zegoOpponentMicUsersList.count == 0) {
            print("Kuch remove karne ke jarurat nahi hai.")
        } else {
            // Iterate over each element in the zegoMicUsersList array
            zegoOpponentMicUsersList.forEach { micUser in
                // Construct the stream ID
                let streamID = secondRoom + micUser.coHostID! + "_cohost_stream"
                print("The stream id we are passing in case to remove opponent join mic is: \(streamID)")
                
                // Stop playing the stream using ZegoExpressEngine
                ZegoExpressEngine.shared().stopPlayingStream(streamID)
                
            }
        }
        
    }
    
    func stopStream() {
        
            stopPlayingStream(streamID: streamName)
        
        
    }
    
    func playStream() {

            ZegoExpressEngine.shared().logoutRoom()
            startLive(roomID: channelName, streamID: streamName)
        
    }
    
    // MARK: - FUNCTION TO START PLAYING LIVE STREAM / JOIN A LIVE ROOM
       
    func stopPlayingStream(streamID: String) {
            
            ZegoExpressEngine.shared().stopPlayingStream(streamID)
           ZegoExpressEngine.shared().logoutRoom()
           
        }
    
}
// MARK: - EXTENSION FOR RECIEVING TENCENT MESSAGE TO SHOW MESSAGES AND GIFTS SENT BY THE USER

extension PublishStreamViewController {

    @objc func handleMessagePushNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            print("Invalid userInfo")
            return
        }
        
        print(userInfo)
        
        // Check if the "message" field is present in the userInfo dictionary
        if let message = userInfo["message"] as? String {
            print("Received message: \(message)")

            // Now you can access other fields from the userInfo dictionary
            if let gender = userInfo["gender"] as? String {
                print("Gender: \(gender)")
            }
            if let user_id = userInfo["user_id"] as? String {
                print("User ID: \(user_id)")
            }
            // Access other fields similarly
        } else {
            print("Message field not found in userInfo")
        }
        
        liveMessage.emoji = userInfo["emoji"] as? Int
        liveMessage.emojiName = userInfo["emojiName"] as? String
        liveMessage.gender = userInfo["gender"] as? String
        liveMessage.level = userInfo["level"] as? String
        liveMessage.message = userInfo["message"] as? String
        liveMessage.ownHost = userInfo["ownHost"] as? Bool
        liveMessage.type = userInfo["type"] as? String
        liveMessage.userID = userInfo["user_id"] as? String
        liveMessage.userImage = userInfo["user_image"] as? String
        liveMessage.userName = userInfo["user_name"] as? String
        
        if (liveMessage.type == "1") || (liveMessage.type == "16") || (liveMessage.type == "12") || (liveMessage.type == "13") {
                
                insertNewMsgs(msgs: liveMessage)
              
            
        } else if (liveMessage.type == "4") || (liveMessage.type == "5"){
            
                
                insertUserName(name: liveMessage.userName ?? "N/A", status: liveMessage.type ?? "N/A")
                
            } else if (liveMessage.type == "2") {
            
                
                if let giftDetails = userInfo["gift"] as? [String: Any] {
                    
                    print("The gift details are: \(giftDetails)")
                    
                    if let count = giftDetails["count"] as? Int,
                       let giftName = giftDetails["name"] as? String,
                       let toName = giftDetails["toName"] as? String {
                        
                        let fullString = "Send \(count) \(giftName) to \(toName)"
                        
                        liveMessage.giftCount = count
                        liveMessage.sendGiftName = giftName
                        liveMessage.sendGiftTo = toName
                        
                    } else {
                        // Handle the case where 'count', 'name', or 'toName' is nil or not of the expected types
                        print("Error: Unable to extract gift details.")
                    }
                    
                    insertNewMsgs(msgs: liveMessage)
                    
                    viewLuckyGift.isHidden = false
                    shakeAnimation(for: viewGiftImage)
                    hideViewAfterDelay(viewToHide: viewLuckyGift, duration: 0.24) {
                        // This block will be executed when the animation is finished
                        print("Animation finished!")
                        self.viewLuckyGift.isHidden = true
                        
                    }
                    
                    lblNoOfGift.text =  "X" + " " + String(giftDetails["count"] as? Int ?? 1)
                    lblSendGiftToHostName.text = liveMessage.sendGiftTo ?? ""
                    
                    loadImage(from: giftDetails["icon"] as? String ?? "", into: imgViewGift)
                    loadImage(from: giftDetails["fromHead"] as? String ?? "", into: imgViewUser)
                    
                    
                    var sendGiftModel = Gift()
                    sendGiftModel.id = giftDetails["giftId"] as? Int
                    //     sendGiftModel.giftCategoryID
                    sendGiftModel.giftName = giftDetails["name"] as? String
                    sendGiftModel.image = giftDetails["icon"] as? String
                    sendGiftModel.amount = giftDetails["giftCoin"] as? Int
                    sendGiftModel.animationType = giftDetails["animationType"] as? Int
                    sendGiftModel.isAnimated = giftDetails["animation"] as? Int
                    sendGiftModel.animationFile = giftDetails["animation_file"] as? String
                    sendGiftModel.soundFile = giftDetails["soundFile"] as? String
                    sendGiftModel.imageType = giftDetails["icon_type"] as? String
                    
                    if (sendGiftModel.animationType == 0) {
                        print("Animation play nahi krana hai")
                    } else {
                        print("Animation play krana hai")
                        ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: self)
                    }
                }
        }
        
    }
    
}

// MARK: - EXTENSION FOR BUTTONS ACTIONS AND THEIR WORKING

extension PublishStreamViewController: delegateCommonPopUpViewController {
    
    func deleteButtonPressed(isPressed: Bool) {
       
        removeUserOnMic()
        quitgroup(id: groupID)
        removePKRequestDetailsOnFirebase()
        removeMessagesOnFirebase()
        removePKRequestOnFirebase()
        setRoomExtraInfo(from: "close")
        removeCoHostInviteDetailsOnFirebase()
        removeCoHostInviteListOnFirebase()
        endLiveBroadcast()
        sendMessageToExitUserFromBroad()
        stopPublishingStream()
        stopLive(roomID: roomId)
        destroyEngine()
        removeLottieAnimationViews()
        updateUserStatusToFirebaseExit()
        FUDemoManager.destory()
        
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnCloseBroadPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
        nextViewController.delegate = self
        nextViewController.headingText = "Are you sure you want to close?"
        nextViewController.buttonName = "Close"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
//        setRoomExtraInfo(from: "close")
//        removeCoHostInviteDetailsOnFirebase()
//        removeCoHostInviteListOnFirebase()
//        endLiveBroadcast()
//        sendMessageToExitUserFromBroad()
//        stopPublishingStream()
//        stopLive(roomID: roomId)
//        destroyEngine()
//        removeLottieAnimationViews()
//        updateUserStatusToFirebaseExit()
//        
//        
//        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func viewUserDetailsPressed(_ sender: Any) {
        
        print("View User Details Pressed")
        
    }
    
    @IBAction func btnViewAudiencePressed(_ sender: Any) {
        print("Button View Audience List Pressed")
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "JoinedAudienceListViewController") as! JoinedAudienceListViewController
     //   vc.groupUsers = groupJoinUsers
        vcAudiencePresent = true
        vc.delegate = self
        vc.userInfoList = userInfoList
        
        let options = SheetOptions(
            pullBarHeight: 0, useInlineMode: true
        )
        
//        vcAudiencePresent = true
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(500), .fixed(500)], options: options)

        sheetController.cornerRadius = 30
        sheetController?.allowPullingPastMaxHeight = false
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true
        sheetController.dismissOnOverlayTap = true
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = true
        
        sheetController.animateIn(to: view, in: self)
        sheetController.didDismiss = { _ in
                    // This is called after the sheet is dismissed
                    print("sheet band ho gayi hai audience list wali")
            self.vcAudiencePresent = false
            
                }
    }
    
    @IBAction func viewDistributionPressed(_ sender: Any) {
        print("Button View Distribution Rewards Pressed")
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BottomWebViewViewController") as! BottomWebViewViewController
     
        vc.url = "https://zeep.live/top-fans-ranking?userid=\(uniqueID ?? 0)"
        vc.height = 500
        
        let options = SheetOptions(
            pullBarHeight: 0, useInlineMode: true
        )
        
        
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(500), .fixed(500)], options: options)

        sheetController?.allowPullingPastMaxHeight = false
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true
        sheetController.dismissOnOverlayTap = true
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = true
        
        sheetController.animateIn(to: view, in: self)
        
    }
    
    @IBAction func viewRewardPressed(_ sender: Any) {
        print("Button View Reward Pressed")
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewRewardViewController") as! ViewRewardViewController
        
        let options = SheetOptions(
            pullBarHeight: 0, useInlineMode: true
        )
        
        
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(500), .fixed(500)], options: options)

        sheetController.cornerRadius = 30
        sheetController?.allowPullingPastMaxHeight = false
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true
        sheetController.dismissOnOverlayTap = true
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = true
        
        sheetController.animateIn(to: view, in: self)
        
    }
    
    @IBAction func viewRewardRankPressed(_ sender: Any) {
        print("Button View Reward Pressed")
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewRewardViewController") as! ViewRewardViewController
        
        let options = SheetOptions(
            pullBarHeight: 0, useInlineMode: true
        )
        
        
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(500), .fixed(500)], options: options)

        sheetController.cornerRadius = 30
        sheetController?.allowPullingPastMaxHeight = false
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true
        sheetController.dismissOnOverlayTap = true
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = true
        
        sheetController.animateIn(to: view, in: self)
        
    }
    
    @IBAction func btnOneToOneCallPressed(_ sender: Any) {
        print("Button One To One Call Pressed")
    }
    
    @IBAction func btnGiftPressed(_ sender: Any) {
        print("Button Open Gift List Pressed")
    }
    
    @IBAction func btnOpenMessagePressed(_ sender: Any) {
        print("Button Open Message Textfield Pressed")
        txtfldMessage.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    @IBAction func btnGamePressed(_ sender: Any) {
        print("Button Open Game Pressed")
       
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GamesOptionInBroadViewController") as! GamesOptionInBroadViewController
        vc.delegate = self
        
        let options = SheetOptions(
            pullBarHeight: 0, useInlineMode: true
        )
        
        
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(150), .fixed(150)], options: options)

        sheetController.cornerRadius = 20
        sheetController?.allowPullingPastMaxHeight = false
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true
        sheetController.dismissOnOverlayTap = true
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = true
        
        sheetController.animateIn(to: view, in: self)
        
    }
        
    @IBAction func btnSendMessagePressed(_ sender: Any) {
        print("Button Send Message Pressed")
        print("The emssage text field is \(txtfldMessage.text)")
        
        let replacedString = replaceNumbersWithAsterisks(txtfldMessage.text ?? "")
            print(replacedString)
        
        sendMessage(message: replacedString)
        txtfldMessage.resignFirstResponder()
        removeMessageView()
        
    }
    
    @IBAction func btnMicPressed(_ sender: Any) {
        
        print("Button Mic Pressed. For Mute and UnMute.")
        
        if isMuteMicButtonPressed
        
        {
            
            isMuteMicButtonPressed = false
          btnMicOutlet.setImage(UIImage(named:  "micon"), for: .normal)
          muteMicrophone = false
            
        }
        
        else{
          
            isMuteMicButtonPressed = true
          btnMicOutlet.setImage(UIImage(named:  "micoff"), for: .normal)
            muteMicrophone = true
            
        }
        
    }
    
}

// MARK: - EXTENSION FOR THE DELEGATES AND THEIR METHODS ARE DEFINED HERE FOR THEIR WORKING

extension PublishStreamViewController: delegateGamesOptionInBroadViewController, delegateBottomWebViewViewController, delegateJoinedAudienceListViewController, delegateJoinedAudienceDetailsViewController, delegateJoinedAudienceDetailsForHostViewController  {
    
    func gameClicked(url: String) {
    
        print("The index at which the game is clicked. It's url is \(url)")
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BottomWebViewViewController") as! BottomWebViewViewController
        vc.url = url
        vc.height = 400
        vc.delegate = self
        
        let options = SheetOptions(
            pullBarHeight: 0, useInlineMode: true
        )
        
        
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(400), .fixed(400)], options: options)

        sheetController?.allowPullingPastMaxHeight = false
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true
        sheetController.dismissOnOverlayTap = true
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = true
        
        sheetController.animateIn(to: view, in: self)
        
    }
    
    func showRechargePage(show: Bool) {
        
        print("Low balance wala page show karna hai. Jab user game main add coin par click karega.")
        
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            //    sheetController.animateOut()
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LowBalanceViewController") as! LowBalanceViewController
        
        let options = SheetOptions(
            pullBarHeight: 0, useInlineMode: true
        )
        
        
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(450), .fixed(450)], options: options)

        sheetController?.allowPullingPastMaxHeight = false
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true
        sheetController.dismissOnOverlayTap = true
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = true
        
        sheetController.animateIn(to: view, in: self)
        
    }

    func userData(selectedUserIndex: Int) {
        print("THe selected userindex in the joineduser list is: \(selectedUserIndex)")
        //        print("\(groupJoinUsers[selectedUserIndex])")
        
        if let sheetController = sheetController {
            sheetController.animateOut()
            sheetController.dismiss(animated: true)
        }
        
        let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId")
        let userId = UserDefaults.standard.string(forKey: "UserId")
        
        if let selectedUser = userInfoList?[selectedUserIndex] {
            
            if (userId == selectedUser.userID) || (userProfileId == selectedUser.userID) {
                
                print("User apne khud ki profile ko khol raha hai.")
                
            } else {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsForHostViewController") as! JoinedAudienceDetailsForHostViewController
                selectedIndexForProfileDetails = selectedUserIndex
                if let selectedUser = userInfoList?[selectedUserIndex] {
                    nextViewController.broadGroupJoinuser = selectedUser
                } else {
                    // Handle the case where userInfoList or the selected user is nil
                }
                
                nextViewController.delegate = self
                nextViewController.modalPresentationStyle = .overCurrentContext
                
                present(nextViewController, animated: true, completion: nil)
            }
        }
    }
    
    func viewProfileDetails(isClicked: Bool, userID:String) {
        
        print("User ki profile details wala page kholna hai.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController

        nextViewController.userID = userID
        nextViewController.callForProfileId = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func viewProfileDetailsForHost(isClicked: Bool, userID:String) {
        
        print("User ki profile details wala page kholna hai.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController

        nextViewController.userID = userID
        nextViewController.callForProfileId = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func muteUserChat(isMute: Bool) {
        
        print("User ki caht ko mute karna hai.")
        
    }
    
    func kickOutUser(isKickout: Bool) {
        
        print("User ko KickOut karna hai broad se.")
        
    }
    
}
// MARK: - EXTENSION FOR UPDATING USER STATUS DETAILS ON THE ON THE FIREBASE

extension PublishStreamViewController {
    
  //  Function to add message to show in the message list
    
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
    
    func sendUserPKRequestDetails(hostProfileID: String = "") {
    
      //  let currentTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        
        var dic = [String: Any]()
        dic["status"] = "pk_accept"
        dic["pk_id"] = pkID
        
        let id =  UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        
        ZLFireBaseManager.share.pkRequestRef.child("pk-invite-details").child(id).child(hostProfileID).setValue(dic) { [weak self] (error, reference) in
            
            guard let self = self else {
                // self is nil, probably deallocated
                return
            }
            
            if let error = error {
                print("Error writing data: \(error)")
            } else {
                print("PK request sent and written successfully on firebase in pk invite details to start pk work.")
            }
        }
        
    }
    
    func updateUserBroadStatus() {
        
        var dic = [String: Any]()
        dic["level"] = UserDefaults.standard.string(forKey: "level")
        dic["gender"] = UserDefaults.standard.string(forKey: "gender")
        dic["user_id"] = UserDefaults.standard.string(forKey: "UserProfileId")
        dic["user_name"] = UserDefaults.standard.string(forKey: "UserName")
        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
            dic["user_image"] = picM ?? ""
        }
        
        dic["type"] = "4"//"1"
        dic["message"] = ""
        dic["ownHost"] = true
        
        let id =  UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        
        let nodeName =  ZLFireBaseManager.share.messageRef.childByAutoId().key ?? generateRandomString(length: 20)
        
        ZLFireBaseManager.share.messageRef.child("message").child(String(format: "%d", id )).child(nodeName).setValue(dic) { [weak self] (error, reference) in
            
            guard let self = self else {
                // self is nil, probably deallocated
                return
            }
            
            if let error = error {
                print("Error writing data: \(error)")
            } else {
                print("Message sent and written successfully on firebase.")
            }
        }
        
    }
    
 // MARK - Function to send message to the firebase so that other users can see message as well in the live broad
    
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
                        print("Message sent successfully in publish stream view controller.")
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
        
//        let nodeName =  ZLFireBaseManager.share.messageRef.childByAutoId().key ?? generateRandomString(length: 20)
//
//        ZLFireBaseManager.share.messageRef.child("message").child(String(format: "%d", uniqueID ?? 0)).child(nodeName).setValue(dic) { [weak self] (error, reference) in
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
        
    }

// MARK - Function to update user Information on Firebase that he has started the live
    
    func updateUserStatusToFirebase(status:String = "LIVE") {
        
        let gender = UserDefaults.standard.string(forKey: "gender")
        var dic = [String: Any]()
        
        dic["imGroupId"] = groupID
        dic["channaleName"] = channelName
        dic["channelName"] = channelName
        dic["weeklyPoints"] = UserDefaults.standard.string(forKey: "weeklyearning") //weeklyDistributionAmount
        dic["newVersionPK"] = true
        dic["count"] = 0
        dic["callRate"] = UserDefaults.standard.string(forKey: "callrate")
        dic["fcmToken"] = ""
        dic["new_call_rate"] = UserDefaults.standard.string(forKey: "newcallrate")
        dic["star"] = "0"
        dic["level"] = UserDefaults.standard.string(forKey: "level")
        dic["name"] = UserDefaults.standard.string(forKey: "UserName")
        dic["pid"] = UserDefaults.standard.string(forKey: "UserProfileId")
        dic["status"] = status//"LIVE"
        dic["uid"] = UserDefaults.standard.string(forKey: "userId")
        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
            dic["profilePic"] = picM ?? ""
        }
        
        if (gender?.lowercased() == "male") {
            
            dic["gender"] = "1"
            
        } else {
            
            dic["gender"] = "0"
            
        }
        print("The dictionary to update is: \(dic)")
        ZLFireBaseManager.share.writeDataToFirebase(data: dic)
        
    }
   
    // MARK - Function to update status and details on firebase when the user exits the broad
    
    func updateUserStatusToFirebaseExit() {
        
        let gender = UserDefaults.standard.string(forKey: "gender")
        var dic = [String: Any]()
        
        dic["weeklyPoints"] = UserDefaults.standard.string(forKey: "weeklyearning")
        dic["callRate"] = UserDefaults.standard.string(forKey: "callrate")
        dic["fcmToken"] = ""
        dic["new_call_rate"] = UserDefaults.standard.string(forKey: "newcallrate")
        dic["star"] = "0"
        dic["level"] = UserDefaults.standard.string(forKey: "level")
        dic["name"] = UserDefaults.standard.string(forKey: "UserName")
        dic["pid"] = UserDefaults.standard.string(forKey: "UserProfileId")
        dic["status"] = "Online"
        dic["uid"] = UserDefaults.standard.string(forKey: "userId")
        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
            dic["profilePic"] = picM ?? ""
        }
        
        if (gender?.lowercased() == "male") {
            
            dic["gender"] = "1"
            
        } else {
            
            dic["gender"] = "0"
            
        }
        print("The dictionary to update is: \(dic)")
        ZLFireBaseManager.share.writeDataToFirebase(data: dic)
        
    }
    
 // MARK: - FUNCTION TO REMOVE MESSAGES NODE ON FIREBASE AFTER THE BROAD ENDED BY THE USER
    
    func removeMessagesOnFirebase() {
        
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The profile id for observe to remove in CoHost InviteList  is: \(currentUserProfileID)")
        
        let userMessageRef = ZLFireBaseManager.share.messageRef.child("message").child(String(currentUserProfileID))

        // Remove the child node
        userMessageRef.removeValue { error, _ in
            if let error = error {
                print("Error removing child node: \(error.localizedDescription)")
            } else {
                print("Child node removed successfully for message nodes.")
            }
        }
    }
    
  // MARK - Function to add message observer to listen for messages and gifts from firebase
    
    func addMessageObserver(id:Int = 0) {
        
        print("The profile id message for observe is: \(id)")
        
        let userMessageRef = ZLFireBaseManager.share.messageRef.child("message").child(String(id)).queryLimited(toLast: 1)
        
        userMessageHandle = userMessageRef.observe(DataEventType.childAdded) { [weak self] (snapshot) in
            guard let self = self else {
                // Ensure self is still valid
                return
            }
            
            guard snapshot.exists() else {
                // Handle the case where the snapshot doesn't exist
                return
            }
            print(snapshot)
            print(snapshot.value)
            print("The snapshot value we are getting is: \(snapshot.value)")
            // Assuming 'snapshot' is the dictionary you provided
            if let userDictionary = snapshot.value as? [String: Any] {
                
                print("Animation ya gift play krne wala kaam krna hai")
                
                liveMessage.emoji = userDictionary["emoji"] as? Int
                liveMessage.emojiName = userDictionary["emojiName"] as? String
                liveMessage.gender = userDictionary["gender"] as? String
                liveMessage.level = userDictionary["level"] as? String
                liveMessage.message = userDictionary["message"] as? String
                liveMessage.ownHost = userDictionary["ownHost"] as? Bool
                liveMessage.type = userDictionary["type"] as? String
                liveMessage.userID = userDictionary["user_id"] as? String
                liveMessage.userImage = userDictionary["user_image"] as? String
                liveMessage.userName = userDictionary["user_name"] as? String
                
                if (liveMessage.type == "1") || (liveMessage.type == "16") {
                    
                    print("The sending model data is: \(liveMessage)")
                    print("The sending model name is: \(liveMessage.userName)")
                    insertNewMsgs(msgs: liveMessage)
                    tblViewLiveMessages.reloadData()
                } else if (liveMessage.type == "4") || (liveMessage.type == "5"){
                    
                    insertUserName(name: liveMessage.userName ?? "N/A", status: liveMessage.type ?? "N/A")
                    
                } else if (liveMessage.type == "2") {
                    
                    print("Gift wala animation play krna hai jo firebase se aaya hai. aur luckgift wala popup dikhana hai. ")
                  
                    if let giftDetails = userDictionary["gift"] as? [String: Any] {
                        
                        print("The gift details are: \(giftDetails)")
                        
                        if let count = giftDetails["count"] as? Int,
                           let giftName = giftDetails["name"] as? String,
                           let toName = giftDetails["toName"] as? String {
                            
                            let fullString = "Send \(count) \(giftName) to \(toName)"
                            
                            liveMessage.giftCount = count
                            liveMessage.sendGiftName = giftName
                            liveMessage.sendGiftTo = toName
                            
                        } else {
                            // Handle the case where 'count', 'name', or 'toName' is nil or not of the expected types
                            print("Error: Unable to extract gift details.")
                        }
                        
                        insertNewMsgs(msgs: liveMessage)
                        tblViewLiveMessages.reloadData()
                        
                        viewLuckyGift.isHidden = false
                        shakeAnimation(for: viewGiftImage)
                        hideViewAfterDelay(viewToHide: viewLuckyGift, duration: 0.24) {
                            // This block will be executed when the animation is finished
                            print("Animation finished!")
                            self.viewLuckyGift.isHidden = true
                            
                        }
                        
                        lblNoOfGift.text =  "X" + " " + String(giftDetails["count"] as? Int ?? 1)
                        lblSendGiftToHostName.text = liveMessage.sendGiftTo ?? ""
                        
                        loadImage(from: giftDetails["icon"] as? String ?? "", into: imgViewGift)
                        loadImage(from: giftDetails["fromHead"] as? String ?? "", into: imgViewUser)
                        
                        
                        var sendGiftModel = Gift()
                        sendGiftModel.id = giftDetails["giftId"] as? Int
                        //     sendGiftModel.giftCategoryID
                        sendGiftModel.giftName = giftDetails["name"] as? String
                        sendGiftModel.image = giftDetails["icon"] as? String
                        sendGiftModel.amount = giftDetails["giftCoin"] as? Int
                        sendGiftModel.animationType = giftDetails["animationType"] as? Int
                        sendGiftModel.isAnimated = giftDetails["animation"] as? Int
                        sendGiftModel.animationFile = giftDetails["animation_file"] as? String
                        sendGiftModel.soundFile = giftDetails["soundFile"] as? String
                        sendGiftModel.imageType = giftDetails["icon_type"] as? String
                        
                        if (sendGiftModel.animationType == 0) {
                            print("Animation play nahi krana hai")
                        } else {
                            print("Animation play krana hai")
                            ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: self)
                        }
                    }
                }
                
            } else {
                print("Snapshot is not a valid dictionary")
            }
            
            // Convert the snapshot value to a dictionary
            guard let snapshotValue = snapshot.value as? [String: Any] else {
                print("Unexpected format of Firebase snapshot value")
                return
            }
            
        }
    }
    
    // MARK - Function to get the user ranking from the Firebase
    
        func addObserveForRanking(id:Int? = 0) {
            guard let currentUserProfileID = id else {  // usersList.data?[currentIndex].profileID
                // Handle the case where currentUserProfileID is nil
                return
            }
            
            print("The profile id for observe in ranking is: \(currentUserProfileID)")
            let userStatusRef = ZLFireBaseManager.share.rankRef.child("weekly_earning_beans").child(String(currentUserProfileID))
            
            userRankHandle = userStatusRef.observe(.value) { [weak self] (snapshot, error) in
                guard let self = self else {
                    // Ensure self is still valid
                    return
                }
                
                if let error = error {
                    // Handle the error, if any
                    print("Firebase observe error: \(error)")
                    return
                }
                
                
                // Handle the updated data here
                if let value = snapshot.value as? [String: Any] {
                    print("The response we are getting from Firebase in rank is:\(value)")
                    
                    
                    if let count = value["rank"] as? Int {
                        
                        print("The rank is: \(count)")
                        lblViewRewardRank.text = "Weekly" + " " + String(count)
                        weeklyEarningBeans = String(count)
                       
                        
                    } else {
                        
                        print("value['count'] is not an integer")
                        
                    }
                    
                }
            }
            
        }
      
  // MARK - Function to get the user daily earning from the firebase
    
    func addObserverForDailyEarning(id:Int? = 0) {
        
        guard let currentUserProfileID = id else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let userDailyRef = ZLFireBaseManager.share.rankRef.child("daily_earning_beans").child(String(currentUserProfileID))
        
        userDailyEarningHandle = userDailyRef.observe(.value) { [weak self] (snapshot, error) in
            guard let self = self else {
                // Ensure self is still valid
                return
            }
            
            if let error = error {
                // Handle the error, if any
                print("Firebase observe error: \(error)")
                return
            }
            
            // Handle the updated data here
            if let value = snapshot.value as? [String: Any] {
                print("The response we are getting from Firebase in rank is:\(value)")
                
                if let count = value["rank"] as? Int {
                    
                    print("The rank is: \(count)")
                    lblViewRewardRank.text = "Daily" + " " + String(count)
                    dailyEarningBeans = String(count)
                    
                } else {
                    
                    print("value['count'] is not an integer")
                    lblViewRewardRank.text = "Daily"
                }
                
            }
        }
    }
  
    // MARK - FUNCTION TO ADD OBSERVER FOR LISTENING TO THE CHANGES IN THE CO- HOST LIST FOR JOIN MIC REQUEST
    
    func addObserverForCoHostInviteList() {
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The profile id for observe in CoHost InviteList  is: \(currentUserProfileID)")
        let coHostRef = ZLFireBaseManager.share.coHostRef.child("sub-cohost-invite-list").child(String(currentUserProfileID))
        
        HostMicRequestHandle = coHostRef.observe(.value) { [weak self] (snapshot, error) in
            guard let self = self else {
                // Ensure self is still valid
                return
            }
            
            if let error = error {
                // Handle the error, if any
                print("Firebase observe error: \(error)")
                return
            }
            
            
            // Handle the updated data here
            if let value = snapshot.value as? [String: Any] {
                print("The response we are getting from Firebase in CoHost InviteList is:\(value)")
                
                // Convert the dictionary to an array of key-value pairs
                let keyValuePairs = value.map { ($0.key, $0.value) }
                
                // Use map on the array of key-value pairs to create instances of your model
                let detailsArray = keyValuePairs.map { (key, value) -> getCoHostInviteUsersDetail in
                    var detail = getCoHostInviteUsersDetail()
                    detail.userID = (value as? [String: Any])?["invitelog_userid"] as? String
                    detail.userName = (value as? [String: Any])?["name"] as? String
                    detail.userImage = (value as? [String: Any])?["profile"] as? String
                    
                    if let timeValue = (value as? [String: Any])?["time"] as? Int64 {
                      //  detail.time = timeValue//Int(timeValue / 1000) // Convert milliseconds to seconds
                        let utcTime = GlobalClass.sharedInstance.millisecondsToUniversalTime(milliseconds: timeValue)
                        print("Current Universal Time:", utcTime)
                        detail.time = utcTime
                    }
                    
                    return detail
                }
                
                // Define dateFormatter within this scope
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(identifier: "UTC")
                
                // Get the current global time string
                   let currentGlobalTime = GlobalClass.sharedInstance.millisecondsToUniversalTime(milliseconds: GlobalClass.sharedInstance.currentUTCms())
                   
                // Convert the current global time string to a Date object
                let currentGlobalDate = dateFormatter.date(from: currentGlobalTime) ?? Date()
                
                   // Filter the coHostRequestList based on the time condition
                   let filteredArray = detailsArray.filter { detail in
                       guard let detailTime = detail.time,
                             let detailDate = dateFormatter.date(from: detailTime) else {
                           return false // Skip if time format is invalid
                       }
                       
                       let timeDifference = Calendar.current.dateComponents([.second], from: detailDate, to: currentGlobalDate).second ?? 0
                       print("The time difference between the two given dates are: \(timeDifference)")
                       
                       // Return true to keep the detail if the time difference is less than or equal to 30 seconds
                       return timeDifference <= 15
                   }
                // Assign the filtered detailsArray to coHostRequestList
                   coHostRequestList = filteredArray
                
//                // Assign the detailsArray to coHostRequestList
//                   coHostRequestList = detailsArray
                
                print("The values in coHostRequest array is: \(coHostRequestList)")
                print("The count of the values are: \(coHostRequestList.count)")
                collectionViewJoinMic.reloadData()
                
            }

        }
        
    }
    
    func removeCoHostInviteListOnFirebase() {
        
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The profile id for observe to remove in CoHost InviteList  is: \(currentUserProfileID)")
        
        let coHostRef = ZLFireBaseManager.share.coHostRef.child("sub-cohost-invite-list").child(String(currentUserProfileID))

        // Remove the child node
        coHostRef.removeValue { error, _ in
            if let error = error {
                print("Error removing child node: \(error.localizedDescription)")
            } else {
                print("Child node removed successfully")
            }
        }
    }
    
    func removeCoHostInviteDetailsOnFirebase() {
        
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The profile id for observe to remove in CoHost InviteList  is: \(currentUserProfileID)")
        
        let coHostRef = ZLFireBaseManager.share.coHostRef.child("sub-cohost-invite-details").child(String(currentUserProfileID))

        // Remove the child node
        coHostRef.removeValue { error, _ in
            if let error = error {
                print("Error removing child node: \(error.localizedDescription)")
            } else {
                print("Child node removed successfully")
            }
        }
    }
    
    // MARK - Function to remove firebase observer for ranking
    
    func removeObserverForRanking(id:Int? = 0) {
        guard let userStatusHandle = userRankHandle else {
            // Handle the case where the observer handle is nil
            return
        }
        
        guard let currentUserProfileID = id else {   // usersList.data?[previousIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let userStatusRef = ZLFireBaseManager.share.rankRef.child("weekly_earning_beans").child(String(currentUserProfileID))
        userStatusRef.removeObserver(withHandle: userStatusHandle)
        
    }
  
// MARK - Function to remove firebase observer for daily earning
    
    func removeObserverForDailyEarning(id:Int? = 0) {
        
        guard let userStatusHandle = userDailyEarningHandle else {
            // Handle the case where the observer handle is nil
            return
        }
        
        guard let currentUserProfileID = id else {  // usersList.data?[previousIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let userDailyRef = ZLFireBaseManager.share.rankRef.child("daily_earning_beans").child(String(currentUserProfileID))
        userDailyRef.removeObserver(withHandle: userStatusHandle)
        
    }
    
    func removePKRequestOnFirebase() {
        
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The profile id for observe to remove in CoHost InviteList  is: \(currentUserProfileID)")
        
        let pkInviteRef = ZLFireBaseManager.share.pkRequestRef.child("pk-invite-list").child(String(currentUserProfileID))

        // Remove the child node
        pkInviteRef.removeValue { error, _ in
            if let error = error {
                print("Error removing child node: \(error.localizedDescription)")
            } else {
                print("Child node removed successfully for pk request.")
            }
        }
    }
    
    func removePKRequestDetailsOnFirebase() {
        
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The profile id for observe to remove in CoHost InviteList  is: \(currentUserProfileID)")
        
        let pkInviteRef = ZLFireBaseManager.share.pkRequestRef.child("pk-invite-details").child(String(currentUserProfileID))

        // Remove the child node
        pkInviteRef.removeValue { error, _ in
            if let error = error {
                print("Error removing child node: \(error.localizedDescription)")
            } else {
                print("Child node removed successfully for pk request.")
            }
        }
    }
 
    func removeMessageObserver(id:Int = 0) {
        guard let userMessageHandle = userMessageHandle else {
            // Observer handle is nil, meaning there's no observer to remove
            return
        }
        
        let userMessageRef = ZLFireBaseManager.share.messageRef.child("message").child(String(id))
        userMessageRef.removeObserver(withHandle: userMessageHandle)
        
        //  ZLFireBaseManager.share.messageRef.removeObserver(withHandle: userMessageHandle)
        
    }
    
    func setRoomExtraInfo(from:String) {
        
        if (from == "close") {
            
            var map = [String: Any]()
            map["coHostID"] = userId
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: map, options: [])
                if let infoStr = String(data: jsonData, encoding: .utf8) {
                    ZegoExpressEngine.shared().setRoomExtraInfo(infoStr, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in
                        print("The infostr we are sending in publish stream is: \(infoStr)")
                        print("onRoomSetRoomExtraInfoResult: \(errorCode)")
                    })
                } else {
                    print("Error: Failed to convert map to JSON string.")
                }
            } catch {
                print("Error: JSON serialization failed.")
            }
        } else {
            print("Poori dictionary  bhejni hai. Woh wala kaam krna hai.")
            var infoStr1 = ""
            var type = ""
                // Convert mainCoHostList to JSON string
                infoStr1 = jsonString(from: zegoSendMicUsersList)
                type = "coHost123"
            
            
            // Create a map with type as key and infoStr1 as value
            var map: [String: String] = [:]
            map[type] = infoStr1
          
            // Convert map to JSON string
            let infoStr2 = jsonString(from: map)
           
            // Set room extra info using the SDK
            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in

                    print(errorCode)
                    print(errorCode.description)
                    if errorCode == 0 {
                     print("Successfully delete wala message bhej dia hai extra room info wale main room band karne ke time par.")
                    } else {
                        print("Message abhi group mai shi se nahi gya hai room extra info wale main room band karne ke case main.")
                    }
                })
            
        }
    }

    func removeLiveAsCoHost(userid: String) {
    
        
        if zegoSendMicUsersList.contains(where: { $0.key == userid }) {
               print("ID exists in zegoSendMicUsersList")
          //  zegoSendMicUsersList["coHostUserStatus"] = "delete"
            if let jsonString = zegoSendMicUsersList[userid],
                let data = jsonString.data(using: .utf8),
                var jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // Access and modify the data inside the JSON object
                if let coHostUserStatus = jsonObject["coHostUserStatus"] as? String {
                    print("Original coHostUserStatus: \(coHostUserStatus)")
                    jsonObject["coHostUserStatus"] = "delete"  // Update the value of "coHostUserStatus"
                    
                    // Convert the updated JSON object back to a string
                    if let updatedJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
                        let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
                        
                        // Update the value in zegoSendMicUsersList with the updated JSON string
                        zegoSendMicUsersList[userid] = updatedJsonString
                        print("Updated User Data: \(updatedJsonString)")
                    } else {
                        print("Error converting JSON object to string")
                    }
                } else {
                    print("coHostUserStatus not found in JSON object")
                }
            } else {
                print("User ID \(userid) not found in zegoSendMicUsersList or data is not a valid JSON string")
            }
            
            var infoStr1 = ""
            var type = ""
                // Convert mainCoHostList to JSON string
                infoStr1 = jsonString(from: zegoSendMicUsersList)
                type = "coHost123"
            
            
            // Create a map with type as key and infoStr1 as value
            var map: [String: String] = [:]
            map[type] = infoStr1
          
            // Convert map to JSON string
            let infoStr2 = jsonString(from: map)
           
            // Set room extra info using the SDK
            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in

                    print(errorCode)
                    print(errorCode.description)
                    if errorCode == 0 {
                     print("Successfully delete wala message bhej dia hai extra room info wale main.")
                    } else {
                        print("Message abhi group mai shi se nahi gya hai room extra info wala.")
                    }
                })
             
           } else {
               print("ID does not exist in zegoSendMicUsersList")
           }
        print("The changed zegosendmicuserslist are: \(zegoSendMicUsersList)")
        
    }
    
    func muteLiveCoHost(userid: String,value:String) {
    
        
        if zegoSendMicUsersList.contains(where: { $0.key == userid }) {
               print("ID exists in zegoSendMicUsersList")
          //  zegoSendMicUsersList["coHostUserStatus"] = "delete"
            if let jsonString = zegoSendMicUsersList[userid],
                let data = jsonString.data(using: .utf8),
                var jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // Access and modify the data inside the JSON object
                if let coHostUserStatus = jsonObject["coHostAudioStatus"] as? String {
                    print("Original coHostAudioStatus: \(coHostUserStatus)")
                    jsonObject["coHostAudioStatus"] = value//"mute"  // Update the value of "coHostUserStatus"
                    if (value.lowercased() == "mute") {
                        jsonObject["isHostMuted"] = "true"
                    } else {
                        jsonObject["isHostMuted"] = "false"
                    }
                } else {
                    print("coHostUserStatus not found in JSON object")
                    jsonObject["coHostAudioStatus"] = value//"mute"
                    if (value.lowercased() == "mute") {
                        jsonObject["isHostMuted"] = "true"
                    } else {
                        jsonObject["isHostMuted"] = "false"
                    }
                }
                    // Convert the updated JSON object back to a string
                    if let updatedJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
                        let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
                        
                        // Update the value in zegoSendMicUsersList with the updated JSON string
                        zegoSendMicUsersList[userid] = updatedJsonString
                        print("Updated User Data: \(updatedJsonString)")
                    } else {
                        print("Error converting JSON object to string")
                    }
            } else {
                print("User ID \(userid) not found in zegoSendMicUsersList or data is not a valid JSON string")
            }
            
            var infoStr1 = ""
            var type = ""
                // Convert mainCoHostList to JSON string
                infoStr1 = jsonString(from: zegoSendMicUsersList)
                type = "coHost123"
            
            
            // Create a map with type as key and infoStr1 as value
            var map: [String: String] = [:]
            map[type] = infoStr1
          
            // Convert map to JSON string
            let infoStr2 = jsonString(from: map)
           
            // Set room extra info using the SDK
            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in

                    print(errorCode)
                    print(errorCode.description)
                    if errorCode == 0 {
                     print("Successfully mute wala message bhej dia hai extra room info wale main.")
                    } else {
                        print("Message abhi group mai shi se nahi gya hai room extra info wala.")
                    }
                })
             
           } else {
               print("ID does not exist in zegoSendMicUsersList")
           }
        print("The changed zegosendmicuserslist are: \(zegoSendMicUsersList)")
        
    }
    
    // Function to convert an object to a JSON string
    func jsonString(from object: Any) -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: object, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }
    
    func stopPlayingCoHostStream(userid:String) {
        
        let config = ZegoPublisherConfig()
        config.roomID = channelName // Assuming channelName is a valid variable accessible in this scope

        let streamID = channelName + userid + "_cohost_stream"
        print("THe stream id we are passing in case of joining mic in live is: \(streamID)")
        
        // Assuming expressObject is an instance of ZegoExpressEngine
        ZegoExpressEngine.shared().stopPlayingStream(streamID)
        
    }
    
    
    func addObserverForPKRequest() {
        
 
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let coHostRef = ZLFireBaseManager.share.pkRequestRef.child("pk-invite-list").child(String(currentUserProfileID))
        
        pkRequestHandle = coHostRef.observe(.value) { [weak self] (snapshot, error) in
            guard let self = self else {
                // Ensure self is still valid
                return
            }
            
            if let error = error {
                // Handle the error, if any
                print("Firebase observe error: \(error)")
                return
            }
            
            // Handle the updated data here
            if let value = snapshot.value as? [String: Any] {
                print("The response we are getting from Firebase in PK Request is:\(value)")
                
                do {
                      // Convert the dictionary to JSON data
                      let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                      
                      // Convert the JSON data to a string (if needed, but not necessary for parsing)
                      if let jsonString = String(data: jsonData, encoding: .utf8) {
                          print("JSON String: \(jsonString)")
                      }
                      
                      // Parse the JSON data to a dictionary
                      if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                          // Iterate over the keys in the dictionary
                          for (key, userDetails) in json {
                              if let userDetails = userDetails as? [String: Any] {
                                  let invitelogUserID = userDetails["invitelog_userid"] as? String
                                  let name = userDetails["name"] as? String
                                  let pkId = userDetails["pk_id"] as? String
                                  let pkIsOneMore = userDetails["pk_is_one_more"] as? Bool
                                  let pkTime = userDetails["pk_time"] as? Int
                                  let userImage = userDetails["user_image"] as? String

                                  print("Key: \(key)")
                                  print("Invite Log User ID: \(invitelogUserID ?? "0")")
                                  print("Name: \(name ?? "")")
                                  print("PK ID: \(pkID ?? "0")")
                                  print("PK Is One More: \(pkIsOneMore ?? false)")
                                  print("PK Time: \(pkTime ?? 0)")
                                  print("User Image: \(userImage ?? "")")
                                  
                                  pkID = pkId ?? ""
                                  print("The pk id when we are getting request is: \(pkID)")
                                  
                                  pkRequestHostDetail.key = key
                                  pkRequestHostDetail.inviteUserID = invitelogUserID
                                  pkRequestHostDetail.name = name
                                  pkRequestHostDetail.pkID = pkID
                                  pkRequestHostDetail.pkOneMoreTime = pkIsOneMore
                                  pkRequestHostDetail.pkTime = pkTime
                                  pkRequestHostDetail.userImage = userImage
                                  
                                  pkRequestsHostList.append(pkRequestHostDetail)
                                  print("The Data in the PK Request Host List is: \(pkRequestsHostList)")
                                  print("The count in the PK Request Host List is: \(pkRequestsHostList.count)")
                                  
                              }
                          }
                     
                          tblViewPKRequest.reloadData()
                      }
                  } catch {
                      print("Failed to parse JSON: \(error.localizedDescription)")
                  }
                
            }
        }
        
    }
    

    func addObserverForPKRequestDetails(hostProfileID: String = "") {
        
        
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let coHostRef = ZLFireBaseManager.share.pkRequestRef.child("pk-invite-details").child(hostProfileID).child(String(currentUserProfileID))
        
        pkRequestHandle = coHostRef.observe(.value) { [weak self] (snapshot, error) in
            guard let self = self else {
                // Ensure self is still valid
                return
            }
            
            if let error = error {
                // Handle the error, if any
                print("Firebase observe error: \(error)")
                return
            }
           
            if let value = snapshot.value as? [String: Any] {
                print("The response we are getting from Firebase in PK Request Details is: \(value)")
                
                if let status = value["status"] as? String, let pkID = value["pk_id"] as? String {
                    print("Status: \(status)")
                    print("PK ID: \(pkID)")
                    
                    if status.lowercased() == "pk_accept" {
                       
                    //    updateUserStatusToFirebase(status:"PK")
                        removeMessagesOnFirebase()
                        
                        if let sheetController = sheetController {
                                sheetController.dismiss(animated: true)
                            }
                        dismiss(animated: true, completion: nil)
                        quitgroup(id: groupID)
                      //  removePKRequestDetailsOnFirebase()
                        removeMessagesOnFirebase()
                      //  removePKRequestOnFirebase()
                        removeCoHostInviteDetailsOnFirebase()
                        removeCoHostInviteListOnFirebase()
                        
                        pkRequestsHostList.removeAll()
                        
                    //    pkRequestHostDetail.key = key
                        pkRequestHostDetail.inviteUserID = hostProfileID
                        pkRequestHostDetail.name = pkInviteHostData.name
                        pkRequestHostDetail.pkID = pkID
                        pkRequestHostDetail.pkOneMoreTime = false
                      //  pkRequestHostDetail.pkTime = pkTime
                        pkRequestHostDetail.userImage = pkInviteHostData.profileImage
                        
                        pkRequestsHostList.append(pkRequestHostDetail)
                        
                       // sendUserPKRequestDetails(hostProfileID: pkRequestsHostList.inviteUserID ?? "")
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PKPublishViewController") as! PKPublishViewController
                        nextViewController.pkRequestHostDetail = self.pkRequestsHostList[0]
                        nextViewController.channelName = self.channelName
                        nextViewController.streamName = self.streamName
                        nextViewController.groupID = self.groupID
                        nextViewController.dailyEarningBeans = dailyEarningBeans
                        nextViewController.weeklyEarningBeans = weeklyEarningBeans
                        nextViewController.pkID = hostPKID
                        
                        print("The data we are sending in the PKPublish View COntroller is: \(self.pkRequestsHostList[0])")
                        if (pkRequestsHostList[0].inviteUserID == "") || (pkRequestsHostList[0].inviteUserID == nil) {
                            
                            showAlert(title: "ERROR!", message: "Something Went Wrong", viewController: self)
                        } else {
                            self.navigationController?.pushViewController(nextViewController, animated: true)
                        }
                        
                       // self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                      //  showAlert(title: "AA GYA", message: "Accept ho gyi request", viewController: self)
                    }
                } else {
                    print("Could not find 'status' or 'pk_id' in the response.")
                }
            }
            
        }
        
    }
    
    func removePKRequestObserver(hostProfileID: String = "") {
        
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        if let pkRequestHandle = pkRequestHandle {
            let coHostRef = ZLFireBaseManager.share.pkRequestRef.child("pk-invite-details").child(hostProfileID).child(String(currentUserProfileID))
            coHostRef.removeObserver(withHandle: pkRequestHandle)
            self.pkRequestHandle = nil
        }
    }

    func setRoomExtraInfo() {
        
            print("Poori dictionary  bhejni hai. Woh wala kaam krna hai.")
            var infoStr1 = ""
            var type = ""
                // Convert mainCoHostList to JSON string
                infoStr1 = jsonString(from: zegoSendMicUsersList)
                type = "coHost123"
            
            
            // Create a map with type as key and infoStr1 as value
            var map: [String: String] = [:]
            map[type] = infoStr1
            map[type] = infoStr1
          
            // Convert map to JSON string
            let infoStr2 = jsonString(from: map)
           
            // Set room extra info using the SDK
            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in

                    print(errorCode)
                    print(errorCode.description)
                    if errorCode == 0 {
                     print("Successfully delete wala message bhej dia hai extra room info wale main.")
                    } else {
                        print("Message abhi group mai shi se nahi gya hai room extra info wala.")
                    }
                })
        
    }
    
    
}

// MARK: - EXTENSION FOR DEFINING FUNCTION TO CONFIGURE UI , START TIMER AND TO DEFINE OTHER FUNCTION AND THEIR WORKINGS HERE.

extension PublishStreamViewController {
    
    func configureUI() {
    
        tabBarController?.tabBar.isHidden = true
        
        viewGift.isHidden = true
        viewOneToOneCall.isHidden = true
        btnGameOutlet.isHidden = true
        
        viewLuckyGift.isHidden = true
        viewMessage.isHidden = true
        viewMessage.layer.cornerRadius = viewMessage.frame.size.height / 2
        viewMessage.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewUserDetailOutlet.backgroundColor = .black.withAlphaComponent(0.4)
        txtfldMessage.setLeftPaddingPoints(15)
        viewUserDetailOutlet.layer.cornerRadius = viewUserDetailOutlet.frame.size.height / 2
        imgViewUserImage.layer.cornerRadius = imgViewUserImage.frame.size.height / 2
        imgViewUserImage.clipsToBounds = true
        viewDistributionOutlet.layer.cornerRadius = viewDistributionOutlet.frame.size.height / 2
        viewDistributionOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewRewardOutlet.layer.cornerRadius = viewRewardOutlet.frame.size.height / 2
        viewRewardOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewUserRoomStatus.layer.cornerRadius = viewUserRoomStatus.frame.height / 2
        viewUserRoomStatus.backgroundColor = .black.withAlphaComponent(0.6)
        lblRoomUserName.textColor = UIColor(hexString: "F9B248")
       
        viewLuckyGiftDetails.layer.cornerRadius = viewLuckyGiftDetails.frame.height / 2
        viewLuckyGiftDetails.backgroundColor = .black.withAlphaComponent(0.3)
        viewGiftImage.layer.cornerRadius = viewGiftImage.frame.height / 2
        viewUserImage.layer.cornerRadius = viewUserImage.frame.height / 2
        imgViewGift.layer.cornerRadius = imgViewGift.frame.height / 2
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        
        lblUserName.text = UserDefaults.standard.string(forKey: "UserName")
        loadImage(from: UserDefaults.standard.string(forKey: "profilePicture"), into: imgViewUserImage)
        let formattedString1 = formatNumber(Int(UserDefaults.standard.string(forKey: "weeklyearning") ?? "0") ?? 0)
        lblDistributionAmount.text = formattedString1
        
    }
    
    func tableViewWorkOfPKRequestHosts() {
    
        tblViewPKRequest?.register(UINib(nibName: "PKRequestListTableViewCell", bundle: nil), forCellReuseIdentifier: "PKRequestListTableViewCell")
        tblViewPKRequest.delegate = self
        tblViewPKRequest.dataSource = self
        
    }
    
    func tableViewWorkOfJoinMicUsers() {
    
        tblViewMicJoinedUsers?.register(UINib(nibName: "MicJoinedUsersTableViewCell", bundle: nil), forCellReuseIdentifier: "MicJoinedUsersTableViewCell")
        tblViewMicJoinedUsers.delegate = self
        tblViewMicJoinedUsers.dataSource = self
        
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
    
        collectionViewBroadList.register(UINib(nibName: "BroadJoinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BroadJoinCollectionViewCell")
        collectionViewBroadList.delegate = self
        collectionViewBroadList.dataSource = self
        collectionViewBroadList.isUserInteractionEnabled = true
       
        collectionViewJoinMic.register(UINib(nibName: "RequestJoinMicUserListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RequestJoinMicUserListCollectionViewCell")
        collectionViewJoinMic.delegate = self
        collectionViewJoinMic.dataSource = self
        collectionViewJoinMic.isUserInteractionEnabled = true
        
    }
    
    func timerAndNotification() {
       
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(handleTap), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.width - 20)
        widthConstraint.isActive = true
       
        let userNameWidthConstraint = NSLayoutConstraint(item: lblRoomUserName, attribute: .width, relatedBy: .lessThanOrEqual, toItem: viewUserRoomStatus, attribute: .width, multiplier: 0.5, constant: viewUserRoomStatus.frame.width / 2) // Adjust the multiplier and constant as needed
        userNameWidthConstraint.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchTap))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
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
        animationView3.contentMode = .scaleAspectFit
        animationView3.frame = viewLiveAnimation.bounds
        viewLiveAnimation.addSubview(animationView3)
        
        animationView3.animation = LottieAnimation.named("live_animation") // Replace with your animation file name
        animationView3.loopMode = .loop
        animationView3.play()
        animationView3.isUserInteractionEnabled = false
        
        lottieAnimationViews = [animationView, animationView1, animationView2, animationView3]
        
    }
   
    func removeLottieAnimationViews() {
          // Remove Lottie animation views from their superviews
          lottieAnimationViews.forEach { $0.removeFromSuperview() }
      }
    
    @objc func touchTap(tap : UITapGestureRecognizer){
       // view.endEditing(true)
        let tapLocation = tap.location(in: self.view)

        if tapLocation.y < self.view.frame.size.height / 2 {
               view.endEditing(true)
            removeMessageView()
            isBeautyFilterButtonPressed = false
            FUDemoManager.shared().hideBottomBar()
            
           // FUDemoManager.shared().removeDemoView()
          //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
           } else {
               print("Neeche ki screen par tap hua hai")
              
           }
    }
    
    @objc func handleTap() {
       
        lblViewRewardRank.text = "Daily" + " " + dailyEarningBeans
        let originalFrame = viewRewardRankOutlet.frame
        let newFrame = CGRect(x: originalFrame.origin.x,
                              y: originalFrame.origin.y - 4, // Adjust the value as needed
                              width: originalFrame.size.width,
                              height: originalFrame.size.height)

        UIView.animate(withDuration: 0.5, animations: {
            self.viewRewardRankOutlet.frame = newFrame
        })
        animateView()
    }
    
    func animateView() {
           // Calculate the new frame for the view
           let originalFrame = viewRewardRankOutlet.frame
           let newFrame = CGRect(x: originalFrame.origin.x,
                                 y: originalFrame.origin.y - 4, // Adjust the value as needed
                                 width: originalFrame.size.width,
                                 height: originalFrame.size.height)

           UIView.animate(withDuration: 0.5, animations: {
               self.viewRewardRankOutlet.frame = newFrame
           }) { (finished) in
               self.lblViewRewardRank.text = "Weekly" + " " + self.weeklyEarningBeans
           }
       }
    
    @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               self.view.bringSubviewToFront(viewMessage)
               let keyboardHeight = keyboardFrame.cgRectValue.height
             
               let viewBottomY = viewMessage.frame.origin.y + viewMessage.frame.size.height
               let keyboardTopY = self.view.frame.size.height - keyboardHeight
               
               if viewBottomY > keyboardTopY {
               
                   UIView.animate(withDuration: 0.3) {
                       self.viewMessage.isHidden = false
                       self.txtfldMessage.text = ""
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
               self.viewMessageBottomConstraints.constant = 0 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
               self.viewMessage.frame.origin.y = self.view.frame.size.height - self.viewMessage.frame.size.height
               self.viewMessage.isHidden = true
               self.txtfldMessage.text = ""
               print("jab keyboard hide hoga tb message view ka origin y hai: \(self.viewMessage.frame.origin.y)")
               
           }
       }
    
    func removeMessageView() {
    
        self.viewMessageBottomConstraints.constant = 0
        self.viewMessage.frame.origin.y = self.view.frame.size.height - self.viewMessage.frame.size.height
        self.viewMessage.isHidden = true
        self.txtfldMessage.text = ""
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND THEIR FUNCTION'S WORKING

extension PublishStreamViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tblViewLiveMessages) {
            return liveMessages.count
        } else if (tableView == tblViewPKRequest) {
            return pkRequestsHostList.count
        } else {
            return zegoMicUsersList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == tblViewLiveMessages) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveMessagesTableViewCell", for: indexPath) as! LiveMessagesTableViewCell
            
            
            //   cell.lblUserLevel.text = liveMessages[indexPath.row].level ?? "N/A"
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
            
        } else if (tableView == tblViewPKRequest) {
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "PKRequestListTableViewCell", for: indexPath) as! PKRequestListTableViewCell
            
            cell.lblHostName.text = pkRequestsHostList[indexPath.row].name ?? "N/A"
            GlobalClass.sharedInstance.loadImageForCell(from: pkRequestsHostList[indexPath.row].userImage, into: cell.imgViewHostImage)
           
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MicJoinedUsersTableViewCell", for: indexPath) as! MicJoinedUsersTableViewCell
            
            cell.lblMicUserName.text = zegoMicUsersList[indexPath.row].coHostUserName
            GlobalClass.sharedInstance.loadImageForCell(from: zegoMicUsersList[indexPath.row].coHostUserImage, into: cell.imgViewMicUserImage)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == tblViewLiveMessages) {
            
            selectedMessageIndex = indexPath.row
           
            print("The selected message indexPath is: \(selectedMessageIndex)")
            
            print("The selected message indexPath is: \(indexPath.row)")
            let image = liveMessages[indexPath.row].userImage ?? ""
            let name = liveMessages[indexPath.row].userName ?? ""
            let level = liveMessages[indexPath.row].level ?? ""
            let id = liveMessages[indexPath.row].userID ?? ""
            
            //delegate?.messageClicked(userImage: image, userName: name, userLevel: level, userID: id)
            var user = joinedGroupUserProfile()
            
            user.userID = liveMessages[indexPath.row].userID ?? ""
            user.nickName = liveMessages[indexPath.row].userName ?? ""
            user.faceURL = liveMessages[indexPath.row].userImage ?? ""
            user.richLevel = liveMessages[indexPath.row].level ?? ""
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsForHostViewController") as! JoinedAudienceDetailsForHostViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
        } else if (tableView == tblViewPKRequest) {
        
         //   updateUserStatusToFirebase(status:"PK")
            
            sendUserPKRequestDetails(hostProfileID: pkRequestsHostList[indexPath.row].inviteUserID ?? "")
            
           // ZegoExpressEngine.shared().stopPublishingStream()
            ZegoExpressEngine.shared().stopPublishingStream(.main)
           //  ZegoExpressEngine.shared().logoutRoom()
          //  ZegoExpressEngine.destroy(nil)
            
            print("The PK Request Clicked or Selected index is: \(indexPath.row) ")
            
         //   DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PKPublishViewController") as! PKPublishViewController
                nextViewController.pkRequestHostDetail = pkRequestsHostList[indexPath.row]
                nextViewController.channelName = channelName
                nextViewController.streamName = streamName
                nextViewController.groupID = groupID
                nextViewController.dailyEarningBeans = dailyEarningBeans
                nextViewController.weeklyEarningBeans = weeklyEarningBeans
                nextViewController.pkID = pkID//hostPKID
            
            print("The data we are sending in the PKPublish View COntroller is: \(self.pkRequestsHostList[indexPath.row])")
            
            if (pkRequestsHostList[indexPath.row].inviteUserID == "") || (pkRequestsHostList[indexPath.row].inviteUserID == nil) {
                
                showAlert(title: "ERROR!", message: "Something Went Wrong", viewController: self)
            } else {
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
                
                self.pkRequestsHostList.remove(at: indexPath.row)
                self.tblViewPKRequest.reloadData()
           // }
        } else {
            
            currentIndexForCoHost = indexPath.row
            print("Users jo Join mic kie baithe hai unki list par click hua hai.")
            if let coHostID = zegoMicUsersList[indexPath.row].coHostID,
                let coHostUserName = zegoMicUsersList[indexPath.row].coHostUserName,
                let coHostUserImage = zegoMicUsersList[indexPath.row].coHostUserImage {
              
                openedVCID = coHostID
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinMicUserOptionsViewController") as! JoinMicUserOptionsViewController
                nextViewController.cameFrom = "host"
                nextViewController.userName = coHostUserName
                nextViewController.userImage = coHostUserImage
                nextViewController.delegate = self
                nextViewController.modalPresentationStyle = .overCurrentContext
                
                present(nextViewController, animated: true, completion: nil)
                
            } else {
                // Handle the case where data is empty or nil
                print("Error: Data is empty or nil.")
            }
            
        }
    }
}

// MARK: - EXXTENSION FOR USING COLLECTION VIEW DELEGATES AND FUNCTIONS AND THEIR WORKING

extension PublishStreamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == collectionViewBroadList) {
            
            return userInfoList?.count ?? 0
            
        } else {
            
            return coHostRequestList.count
            
        }
        
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewBroadList {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BroadJoinCollectionViewCell", for: indexPath) as! BroadJoinCollectionViewCell
            
            // Reset the cell state before reuse
            cell.resetCellState()
            cell.isUserInteractionEnabled = true
            
            // Set the image view to be circular
            cell.imgViewUserPhoto.layer.cornerRadius = cell.imgViewUserPhoto.frame.height / 2
            cell.imgViewUserPhoto.clipsToBounds = true
            
            // Clear the previous image
            cell.imgViewUserPhoto.image = nil
            
            // Safely unwrap the userInfoList array and check the index bounds
            if let userInfoList = userInfoList, indexPath.row < userInfoList.count {
                
                // Attempt to create a URL from the faceURL string
                if let imageURL = URL(string: userInfoList[indexPath.row].faceURL ?? "") {
                    KF.url(imageURL)
                        .cacheOriginalImage()
                        .onSuccess { [weak cell] result in
                            DispatchQueue.main.async {
                                cell?.imgViewUserPhoto.image = result.image
                            }
                        }
                        .onFailure { error in
                            print("Image loading failed with error: \(error)")
                            DispatchQueue.main.async {
                                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                            }
                        }
                        .set(to: cell.imgViewUserPhoto)
                } else {
                    // If URL is invalid, use a placeholder image
                    cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                }
                
            } else {
                // Handle case where userInfoList is nil or index is out of range
                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                print("userInfoList is nil or indexPath.row is out of bounds")
            }
            
            cell.imgViewUserPhoto.isUserInteractionEnabled = true
            cell.viewMain.isUserInteractionEnabled = true
            
            return cell
        }
 else {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestJoinMicUserListCollectionViewCell", for: indexPath) as! RequestJoinMicUserListCollectionViewCell
            
            cell.delegate = self
            cell.btnAcceptRequestOutlet.tag = indexPath.row
            cell.btnRejectRequestOutlet.tag = indexPath.row
            
            cell.lblUserName.text = coHostRequestList[indexPath.row].userName
            loadImage(from: coHostRequestList[indexPath.row].userImage, into: cell.imgViewUser)
            
            return cell
            
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == collectionViewBroadList) {
           
            let width = (collectionView.bounds.size.width ) / 4
            let height = width - 65
            return CGSize(width: width, height: 40)
            
        } else {
            
//            let width = (collectionView.bounds.size.width ) / 4
//            let height = width - 65
            return CGSize(width: 155, height: 110)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        if (collectionView == collectionViewBroadList) {
            
             let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId")
               let userId = UserDefaults.standard.string(forKey: "UserId")
               
            if let selectedUser = userInfoList?[indexPath.item] {
                
                if (userId == selectedUser.userID) || (userProfileId == selectedUser.userID) {
                    
                    print("User apne khud ki profile ko khol raha hai.")
                    
                } else {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsForHostViewController") as! JoinedAudienceDetailsForHostViewController
                    selectedIndexForProfileDetails = indexPath.item
                    if let selectedUser = userInfoList?[indexPath.item] {
                        nextViewController.broadGroupJoinuser = selectedUser
                    } else {
                        print("broad join user ki array khali hai")
                        // Handle the case where userInfoList or the selected user is nil
                    }
                    
                    nextViewController.delegate = self
                    nextViewController.modalPresentationStyle = .overCurrentContext
                    
                    present(nextViewController, animated: true, completion: nil)
                    
                }
                
            }
            
        } else {
           
            print("THe indexPath of the request is: \(indexPath.row)")
            
        }
    }
    
}

// MARK: - EXTENSION FOR GETTING VALUES AND USING FUNCTIONS TO SET VALUES IN MESSAGES TABLE VIEW AND IN COLLECTION VIEW

extension PublishStreamViewController: delegateRequestJoinMicUserListCollectionViewCell {
    
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
            self.lblRoomUserName.text = name + ":"
            
            if (status == "4") {
                self.lblRoomUserStatus.text = "has entered the room"
            } else {
                self.lblRoomUserStatus.text = "has left the room"
            }
            
        }
    }
    
    func showJoinedUser(users: [V2TIMUserFullInfo]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print(users.count)
            self.userInfoList?.removeAll()
            self.userInfoList = users
            self.collectionViewBroadList.reloadData()
        }
    }
    
    func hideViewAfterDelay(viewToHide: UIView, duration: TimeInterval, completion: (() -> Void)? = nil) {
        // Store the original x-axis position
        let originalX = self.view.frame.origin.x

        // Set the delay duration (in seconds)
        let delayInSeconds: TimeInterval = 0.8

        // Use DispatchQueue to execute code after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            // Perform the animation to move the view to the right
            UIView.animate(withDuration: duration, animations: {
                // Apply a translation transformation to move the view to the right
                viewToHide.transform = CGAffineTransform(translationX: self.view.frame.width / 2.5, y: 0)
                
            }) { _ in
                // Once the animation is complete, reset the x-axis position
                viewToHide.transform = CGAffineTransform(translationX: originalX - 10, y: 0)
                self.luckyGiftCount = 0
                
                // Call the completion block if provided
                completion?()
            }
        }
    }
   
    func acceptClicked(index: Int) {
     
        print("The index clicked for the accept button is: \(index)")

        ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (coHostRequestList[index].userID ?? ""), status: "accept")
       // playStreamAcceptedUser(userid: (coHostRequestList[index].userID ?? ""))
        coHostRequestList.remove(at: index)
        print(coHostRequestList)
        print(coHostRequestList.count)
        collectionViewJoinMic.reloadData()
        
    }
    
    func rejectClicked(index: Int) {
        
        print("The index clicked for the reject button is: \(index)")
       
        ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (coHostRequestList[index].userID ?? ""), status: "decline")
        coHostRequestList.remove(at: index)
        print(coHostRequestList)
        print(coHostRequestList.count)
        collectionViewJoinMic.reloadData()
        
    }
    
    func playStreamAcceptedUser(userid:String) {
    
        let streamID = channelName + userid + "_cohost_stream"
        print("THe stream id we are passing in case of the join mic is: \(streamID)")
        
        let config = ZegoPlayerConfig()
        config.roomID = channelName
        
        let zegocanvas = ZegoCanvas(view: UIView())
        
        ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
        
    }
    
    func leaveMicPressed(isPressed: Bool) {
        print("Button to remove user for remove from join mic pressed by the host.")
        removeLiveAsCoHost(userid: zegoMicUsersList[currentIndexForCoHost].coHostID ?? "")
        stopPlayingCoHostStream(userid: zegoMicUsersList[currentIndexForCoHost].coHostID ?? "")
        zegoMicUsersList.remove(at: currentIndexForCoHost)
        tblViewMicJoinedUsers.reloadData()
        
    }
    
    func muteMicPressed(isPressed: Bool) {
        print("Button to mute the user mic Pressed by the host. \(isPressed)")
        
        if (isPressed == true) {
            print("User ko mute krne wala kaam krna hai.")
            muteLiveCoHost(userid: zegoMicUsersList[currentIndexForCoHost].coHostID ?? "", value: "mute")
        } else {
            print("User ko unmute krne wala kaam krna hai.")
            muteLiveCoHost(userid: zegoMicUsersList[currentIndexForCoHost].coHostID ?? "", value: "unmute")
        }
    }
    
    func openProfileDetails(isPressed: Bool) {
        print("Button to open the user profile details pressed by the host.")
    }
    
    func buttonRecieveCallPressed(isPressed: Bool) {
        
        print("Button Call Recieved Pressed by the host.")
        sendMessageUsingZego()
        
    }
 
    func pkInvitedHostID(id: String, details: liveHostListData) {
        
        print("The PK invite sent host id is: \(id)")
        print("The PK invite sent host details are: \(details)")
        
        removePKRequestObserver(hostProfileID: id)
        pkInviteHostData = details
        addObserverForPKRequestDetails(hostProfileID: id)
        
    }
    
    func pkID(id: String) {
        
        print("The pk id we need to pass is: \(id)")
         hostPKID = id
        print("The host pk id that we need to update data on in publish view controller is: \(hostPKID)")
        
    }
    
}

// MARK: - EXTENSION FOR SENDING CUSTOM MESSAGE THROUGH ZEGO TO KNOW THE USER THAT ONE TO ONE CALL IS ACCEPTED.

extension PublishStreamViewController {

    func sendMessageUsingZego() {
        
        let dic = [
            "sender_id": callSenderID ,//"229792703",
            "action_type": "call_request_approved_from_app"
            
        ] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Json Ko String main convert kar diya hai.")
                print(jsonString)
                
                var userList = [ZegoUser]()
                let hostID = callSenderID//UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
                
                let newUser = ZegoUser(userID: String(hostID))
                userList.append(newUser)
                
                ZegoExpressEngine.shared().sendCustomCommand(jsonString, toUserList: userList, roomID: channelName) { errorCode in
                    if errorCode == 0 {
                        // Custom command sent successfully
                        // Custom command sent successfully
                        print("Custom command sent successfully to the user to start call process.")
                        
                       // ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), status: "busy")
                        
                        self.updateUserStatusToFirebase(status:"BUSY")
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneCallViewController") as! OneToOneCallViewController
                        nextViewController.channelName = self.callChannelName
                        nextViewController.cameFrom = "host"
                        nextViewController.userName = self.callSenderName 
                        nextViewController.userImage = self.callSenderImage
                        nextViewController.userID = self.callSenderID
                        nextViewController.uniqueID = String(self.uniqueID)
                        
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                    } else {
                        // Error occurred
                        print("Error sending custom command. Error code: \(errorCode)")
                    }
                }
                
            } else {
                print("Failed to convert JSON data to string")
            }
        } catch {
            print("Error converting dictionary to JSON: \(error.localizedDescription)")
        }
    }
}

// MARK: - EXTENSION FOR TENCENT JOINING GROUP , EXITING GROUP AND GETTING INFORMATION OF THE USERS IN THE GROUP

extension PublishStreamViewController {
    
    func joinGroup(id:String) {
        
        userInfoList?.removeAll()
        
        print("Group se jo id bhejni hai woh hai: \(id)")
        // Join a group
        V2TIMManager.sharedInstance().joinGroup(id, msg: "", succ: {
            // Joined the group successfully
            print("Group Join Login Success")
       
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }

               // getGroupCallBack()
                getGroupMemberList()
                callMemberList = true
            }

        }, fail: { (code, desc) in
            // Failed to join the group
            print(code)
            print(desc)
            
        })
    }
    
    func quitgroup(id:String) {
        
        print("Group se jo id htani hai woh hai: \(id)")
        V2TIMManager.sharedInstance().quitGroup(id, succ: {
            // Left the group successfully
            print("Group se bhr niakl gye shi se")
            
        }, fail: { (code, desc) in
            // Failed to leave the group
            print(code)
            print(desc)
            print("group se bhr nii nikle shi se")
        })
        
    }
    
    func getGroupCallBack() {
        
        messageListener.groupUserEnter = { [weak self] msgID, text in
            guard let self = self else { return }
            
            print(msgID)
            print(text)
            print(text.description)
            if (text.count == 0) {
                print("Khali hai.")
            } else {
                print("Bhara hai.")
                print(text[0].nickName)
                print(text[0].userID)
                print(text[0].faceURL)
              
                insertUserName(name: text[0].nickName ?? "N/A", status: "4")
                
            }
            
            print("The group enter callback result are \(msgID), \(text)")
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                
                if self.callMemberList {
                    self.getGroupMemberList()
                } else {
                    print("Group member list won't be called in the message receive for group enter.")
                }
            }
        }

        messageListener.groupUserLeave = { [weak self] msgID, text in
            guard let self = self else { return }
            
            print(msgID)
            print(text)
            print("The group leave callback result are \(msgID), \(text)")
            
            insertUserName(name: text.nickName ?? "N/A", status: "3")
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                
                if self.callMemberList {
                    self.getGroupMemberList()
                } else {
                    print("Group member list won't be called in the message leave for group enter.")
                }
            }
        }
    }
    
    func getGroupMemberList() {
        callMemberList = false
        V2TIMManager.sharedInstance()?.getGroupMemberList(groupID, filter: 0x00, nextSeq: 0, succ: { [weak self] nextSeq, memberList in
            // Safe unwrap of self
            guard let self = self else { return }

            print("The group member list count is: \(memberList?.count)")
            print(memberList?.first?.customInfo)
            if let userIds = memberList?.map({ $0.userID }) {
                // Call the method to get detailed information with the list of user IDs
                if !userIds.isEmpty {
                    // Call the method to get detailed information with the list of user IDs
                    self.getUsersInformation(list: Array(Set(userIds)) as! [String])
                } else {
                    // Handle the case where userIds is empty
                    print("No user IDs found in the memberList.")
                }
            }

               lblBroadViewCount.text = String(memberList?.count ?? 0)
            
        }) { [weak self] code, desc in
            // Safe unwrap of self
            guard let self = self else { return }
            
            // Messages failed to be pulled
            print("Failed to get group member list. Code: \(code), Description: \(desc)")
            self.callMemberList = false
        }
    }
    
    func getUsersInformation(list:[String]) {

        callMemberList = false
        V2TIMManager.sharedInstance()?.getUsersInfo(list, succ: { [weak self] profiles in
               guard let self = self, let profiles = profiles else {
                   return
               }
            
            print("The data in the profile is: \(profiles)")
            print("Member Details count is: \(profiles.count)")

            userInfoList?.removeAll()
            
            userInfoList = profiles
            print("The UserInfoList counts are: \(userInfoList?.count)")

            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    // Assuming cell.showJoinedUser has a parameter of type [V2TIMUserFullInfo]
                    if let userInfoList = self.userInfoList {
                        
                            showJoinedUser(users: userInfoList)
                            if self.vcAudiencePresent {
                                print("Controller khula hua hai")
                                NotificationCenter.default.post(name: Notification.Name("groupJoinUsersUpdated"),
                                                                object: userInfoList)
                            } else {
                                print("Controller bnd hai")
                               // NotificationCenter.default.removeObserver(self)
                                NotificationCenter.default.removeObserver("groupJoinUsersUpdated")
                            }
                          
                    }
                }
            }

            collectionViewBroadList.reloadData()
            callMemberList = true
           
        }, fail: { code, desc in
            // Failed to obtain
            print("Failed to obtain group members. Code: \(code), Description: \(desc)")
            self.callMemberList = true
        })
    }

    
    func removeListeners() {
        
        messageListener.groupUserEnter = nil
        messageListener.groupUserLeave = nil
        
    }
    
}
// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM THE SERVER AND CREATING ENGINE FOR GOING LIVE

extension PublishStreamViewController {
    
  // MARK - Function to call api and get the details from the server for going live
    
    func createLiveBroadcast() {
        
        ApiWrapper.sharedManager().createLiveBroadCast(url: AllUrls.getUrl.createLiveBroadcast, completion: { [weak self] (data) in
           
            guard let self = self else {
                return // The object has been deallocated
            }
            
            if (data["success"] as? Bool == true) {
                print(data)
                print("Sab kuch sahi hai")
                
                let a = data["result"] as? [String: Any]
                print(a)
                
                if let id = a?["user_id"] as? Int {
                    
                    print("The id is: \(id)")
                }
                
                if let token = a?["token"] as? String {
                    
                    print("The token is: \(token)")
                }
                
                if let u_id = a?["unique_id"] as? Int {
                    
                    print("The unique id is: \(u_id)")
//                    updateUserBroadStatus()
                    addObserveForRanking(id: u_id)
                    addObserverForDailyEarning(id: u_id)
                    uniqueID = u_id
                    addObserverForCoHostInviteList()
                }
                
                if let channelname = a?["channel_name"] as? String {
                    
                    print("The channel name is: \(channelname)")
                    channelName = channelname
                    streamName = channelName + "_stream"
//                    createEngine()
                    updateUserBroadStatus()
//                    updateUserStatusToFirebase(status:"LIVE")
                    startLive(roomID: channelName, streamID: streamName)
                    setRoomExtraInfo(from: "close")
                    startCensorForTaskID()
                    createLive()
                    print("The channelname: \(channelName)")
                    print("The streamname: \(streamName)")
                    
                }
                
                if let groupid = a?["group_id"] as? String {
                    
                    print("The groupid is: \(groupid)")
                    groupID = groupid
                    joinGroup(id: groupID)
                  //  addMessageObserver(id: uniqueID)
                    updateUserStatusToFirebase(status:"LIVE")
                }
                
                
            } else {
                print(data["error"])
                print("Kuch error hai")
            }
        })
    }
  
 // MARK - Function to get the task id from the backend on the basis of which we have to close the broad
    
    func startCensorForTaskID() {
        
        let params = [
            
            "room_id": channelName
            
        ] as [String : Any]
        
        ApiWrapper.sharedManager().startCensorVideo(url: AllUrls.getUrl.startCensorVideo,parameter: params ,completion: { [weak self] (data) in
           
            guard let self = self else {
                return // The object has been deallocated
            }
            
            if (data["success"] as? Bool == true) {
                print(data)
                print("Sab kuch sahi hai")
                
                if let taskid = data["task_id"] as? String {
                    
                    print("The task id is: \(taskid)")
                    taskID = taskid
                    
                }
                
                
            } else {
                print(data["error"])
                print("Kuch error hai")
            }
        })
    }
  
  // MARK - Function to delete the live broadcast and call api for the backend to know the broad has ended
    
    func endLiveBroadcast() {
        
        let params = [
            
            "task_id": taskID
            
        ] as [String : Any]
        
        ApiWrapper.sharedManager().closeLiveBroadcastByHost(url: AllUrls.getUrl.endLiveBroadcastForHost,parameter: params ,completion: { [weak self] (data) in
           
            guard let self = self else {
                return // The object has been deallocated
            }
            
            if (data["success"] as? Bool == true) {
                print(data)
                print("Sab kuch sahi hai")
                print("Broad delete ho gyi hai. backend par update kar diya hai")
                
            } else {
                print(data["error"])
                print("Kuch error hai")
            }
        })
    }
    
  // MARK - Function to call and let baccknd know ki host live ho gya hai
    
    func createLive() {
        
        ApiWrapper.sharedManager().createLive(url: AllUrls.getUrl.createLive, completion: { [weak self] (data) in
           
            guard let self = self else {
                return // The object has been deallocated
            }
            
            if (data["success"] as? Bool == true) {
                print(data)
                print("Sab kuch sahi hai. Backend ko pta chl gya hai ki hum live ho gye hain.")
                
            } else {
                print(data["error"])
                print("Kuch error hai")
            }
        })
    }
    
    // MARK - Function to call api and get the details from the server for going live
      
      func createLiveBroadcastForListing() {
          
          ApiWrapper.sharedManager().createLiveBroadCast(url: AllUrls.getUrl.createLiveBroadcast, completion: { [weak self] (data) in
             
              guard let self = self else {
                  return // The object has been deallocated
              }
              
              print("Phir se live dikhne wala api hit ho gaya hai.")
              
              if (data["success"] as? Bool == true) {
                  print(data)
                  print("Sab kuch sahi hai")
                  
                  let a = data["result"] as? [String: Any]
                  print(a)
                  
                  if let id = a?["user_id"] as? Int {
                      
                      print("The id is: \(id)")
                  }
                  
                  if let token = a?["token"] as? String {
                      
                      print("The token is: \(token)")
                  }
                  
                  startCensorForTaskID()
                  createLive()
                  
              } else {
                  print(data["error"])
                  print("Kuch error hai")
              }
          })
      }

    
}
// MARK: - EXTENSION FOR THE FUNCTIONS OF ZEGO TO CREATE ENGINE, GO LIVE , STOP LIVE , STOP PUBLISHING STREAM AND DESTROY ENGINE

extension PublishStreamViewController {
    
    func createEngine() {
        
        NSLog(" 🚀 Create ZegoExpressEngine")
        let profile = ZegoEngineProfile()
        profile.appID = KeyCenter.appID
        profile.appSign = KeyCenter.appSign
        profile.scenario = .broadcast
        
        
        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)

        ZegoExpressEngine.shared().enableHardwareEncoder(false)

        enableCamera = true
        muteSpeaker = false
        muteMicrophone = false
        
        videoConfig.fps = 15
        videoConfig.bitrate = 1200;
        videoConfig.captureResolution = CGSizeMake(540, 960);
        videoConfig.encodeResolution = CGSizeMake(540, 960);
        
        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
        ZegoExpressEngine.shared().setVideoMirrorMode(videoMirrorMode)
        
        previewCanvas.view = self.view
        previewCanvas.viewMode = previewViewMode
        
        NSLog(" 🔌 Start preview")
        ZegoExpressEngine.shared().startPreview(previewCanvas)
        ZegoExpressEngine.shared().setEventHandler(self)
        

//        let config = ZegoCustomVideoProcessConfig()
//        config.bufferType = .cvPixelBuffer
//        
//        ZegoExpressEngine.shared().setCustomVideoProcessHandler(self)
//        ZegoExpressEngine.shared().enableCustomVideoProcessing(true, config: config, channel: .main)
        
        // Init process config
        let processConfig = ZegoCustomVideoProcessConfig()
        processConfig.bufferType = .cvPixelBuffer

        // Enable custom video process
        ZegoExpressEngine.shared().enableCustomVideoProcessing(true, config: processConfig, channel: .main)

        // Set self as custom video process handler
        ZegoExpressEngine.shared().setCustomVideoProcessHandler(self)
        
//        FURenderKitManager.shared().setupRenderKit()
//        FUBeautyComponentManager.shared().setModel()
//        FURenderKitManager.loadFaceAIModel()
//        
//        FURenderKit.share().delegate = self
        initFaceUnity()

    }
    
    func initFaceUnity(){
      
        FUDemoManager.setupFUSDK()

    }
    
    
// MARK: - FUNCTION TO START LIVE AND PUBLISH STREAM
    
    func startLive(roomID: String, streamID: String) {
        NSLog(" 🚪 Start login room, roomID: \(roomID)")
        
        let config = ZegoRoomConfig()
//        config.token = KeyCenter.token
        config.isUserStatusNotify = true
       
        let zegoMultiConfig = ZegoPublisherConfig()
        zegoMultiConfig.roomID = roomID
        
        print("The room id to login in host is: \(roomID)")
        print("The stream id in host is: \(streamID)")
        
        ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: String(uniqueID)), config: config)
        
        NSLog(" 📤 Start publishing stream, streamID: \(streamID)")
        ZegoExpressEngine.shared().startPublishingStream(streamID,config: zegoMultiConfig,channel: .main)
       
        FUDemoManager.shared().addDemoView(to: self.view, originY: UIScreen.main.bounds.height - FUBottomBarHeight - FUSafaAreaBottomInsets())
        
        FUDemoManager.shared().hideBottomBar()
        
        
    }

// MARK: - FUNCTION TO STOP LIVE AND LOGOUT FROM ROOM
    
    func stopLive(roomID: String) {
        NSLog(" 🚪 Logout room")
        ZegoExpressEngine.shared().logoutRoom(roomID)
        
        videoSize = CGSize(width: 0, height: 0)
        videoCaptureFPS = 0.0
        videoEncodeFPS = 0.0
        videoSendFPS = 0.0
        videoBitrate = 0.0
        videoNetworkQuality = ""
        
    }
    
    func stopPublishingStream() {
    
        ZegoExpressEngine.shared().stopPublishingStream()
    
    }
    
// MARK: - FUNCTION TO DESTROY ZEGO ENGINE
    
    func destroyEngine() {
        
        print("Yhn live karne vale ka band hua hai")
        NSLog(" 🏳️ Destroy ZegoExpressEngine")
        ZegoExpressEngine.destroy(nil)
        
    }
    
    // MARK: - FUNCTION TO SEND MESSAGE TO THE USER TO EXIT FROM THE BROAD WHEN HOST EXITTED THE BROAD AND ROOM
       
       func sendMessageToExitUserFromBroad() {
               let dictionary: [String: Any] = ["action_type": "kickout_all_user_from_app"]
               if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary),
                  let convertedString = String(data: jsonData, encoding: .utf8) {
                   print(convertedString)
               //    ZegoExpressEngine.shared().sendBarrageMessage(convertedString, roomID: "123456")
                   ZegoExpressEngine.shared().sendBarrageMessage(convertedString, roomID: roomId)
                   print("Message bheja hai dheere se nikal lo tum .. bhut hua....")
               }
           }
    
}

// MARK: - EXTENSION FOR USING ZEGO EVENT HANDLER DELEGATE METHOD AND TO KNOW THE EVENT RESPONSE COMING FROM ZEGO

extension PublishStreamViewController: ZegoEventHandler {
    
    func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
        NSLog(" 🚩 🚪 Room state update, state: \(state.rawValue), errorCode: \(errorCode), roomID: \(roomID)")
        roomState = state
        print(roomState)

        if state == .connected {
            ZegoExpressEngine.shared().startPreview(previewCanvas)
        }
        
    }
    
    func onPublisherStateUpdate(_ state: ZegoPublisherState, errorCode: Int, extendedData: [AnyHashable : Any]?) {
           switch state {
           case .noPublish:
               print("No stream is being published")
           case .publishRequesting:
               print("The engine is requesting to publish the stream")
           case .publishing:
               if errorCode == 0 {
                   print("Publishing stream successfully")
               } else {
                   print("Failed to publish stream, error code: \(errorCode)")
               }
           @unknown default:
               fatalError("Unknown publishing state")
           }
       }
    
//    func onPublisherStateUpdate(_ state: ZegoPublisherState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
//        NSLog(" 🚩 📤 Publisher state update, state: \(state.rawValue), errorCode: \(errorCode), streamID: \(streamID)")
//        publishState = state
//        print(publishState)
//        
//    }
    
    func onPublisherQualityUpdate(_ quality: ZegoPublishStreamQuality, streamID: String) {
        videoCaptureFPS = quality.videoCaptureFPS
        videoEncodeFPS = quality.videoEncodeFPS
        videoSendFPS = quality.videoSendFPS
        videoBitrate = quality.videoKBPS
        isHardwareEncode = quality.isHardwareEncode
        
        switch (quality.level) {
        case .excellent:
            videoNetworkQuality = "☀️"
            break
        case .good:
            videoNetworkQuality = "⛅️"
            break
        case .medium:
            videoNetworkQuality = "☁️"
            break
        case .bad:
            videoNetworkQuality = "🌧"
            break
        case .die:
            videoNetworkQuality = "❌"
            break
        default:
            break
        }
    }
    
    func onPublisherVideoSizeChanged(_ size: CGSize, channel: ZegoPublishChannel) {
        videoSize = size
        print(videoSize)
        print(channel)
        print(channel.rawValue)
        
        if (videoSize.width == 0) && (videoSize.height == 0) {
            print("Abhi stream play nahi hua hai.")
        } else {
            print("Abhi stream play hona shuru ho gaya hai")
//            updateUserStatusToFirebase()
          //  addMessageObserver(id: uniqueID)
            joinGroup(id: groupID)
            insertUserName(name: UserDefaults.standard.string(forKey: "UserName") ?? "N/A", status: "4" ?? "N/A")
          //  createLive()
            
        }
        
    }
    
    
    func onIMRecvCustomCommand(_ command: String, from fromUser: ZegoUser, roomID: String) {
        print(command)
        print(fromUser)
        print(roomID)

//        let config = ToastConfiguration(
//            direction: .bottom
//        )
//        
//        let toast = Toast.text(command,config: config)
//        toast.show()
        
        print("The data that we are getting in host side is: \(command)")
        
        let jsonData = command.data(using: .utf8)!

        do {
            // Deserialize JSON data
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                // Access values from JSON dictionary
                 let senderProfileId = json["sender_profile_id"] as? String
                   let userName = json["user_name"] as? String
                   let channelName = json["channel_name"] as? String
                   let profileImage = json["profile_image"] as? String
                   let actionType = json["action_type"] as? String
                   let senderId = json["sender_id"] as? String
                   let token = json["token"] as? String
                    // Print or use the values as needed
                    print("Sender Profile ID: \(senderProfileId)")
                    print("User Name: \(userName)")
                    print("Channel Name: \(channelName)")
                    print("Profile Image: \(profileImage)")
                    print("Action Type: \(actionType)")
                    print("Sender ID: \(senderId)")
                    print("Token: \(token)")
                    
                callSenderID = senderId ?? ""
                callSenderName = userName ?? ""
                callChannelName = channelName ?? ""
                callSenderImage = profileImage ?? ""
                
                    print("The call sender id is: \(callSenderID)")
                    
                    if (actionType == "call_request_from_user_from_appZ") {
                        print("One to one call wala kaam shuru karna hai.")
                    
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallNotificationViewController") as! CallNotificationViewController
        
                        nextViewController.imageUrl = profileImage ?? ""
                        nextViewController.userName = userName ?? ""
                        nextViewController.delegate = self
                        
                        nextViewController.modalPresentationStyle = .overCurrentContext
                        
                        present(nextViewController, animated: true, completion: nil)
                        
                    } else {
                        print("One to one wala kaam nahi krna hai.")
                    }
                    
                
            } else {
                print("Failed to deserialize JSON.")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func onRoomOnlineUserCountUpdate(_ count: Int32, roomID: String) {
        print(count)
        print(roomID)
        
    }
    
    func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
        print(userList)
        print(userList.count)
        print(roomID)
        print(updateType.rawValue)
        print(userList[0].userID)
        print(userList[0].userName)
        
    }
    
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
 
        print(updateType)
        print(streamList)
        print(extendedData)
        print(roomID)
        
    }
    
    func onRoomExtraInfoUpdate(_ roomExtraInfoList: [ZegoRoomExtraInfo], roomID: String) {
        
        print("The extra info we are getting from the Zego is: \(roomExtraInfoList)")
        print("The extra info room id is: \(roomID)")
        print("The extra info room details count is: \(roomExtraInfoList.count)")
        
        print(roomExtraInfoList)
        print(roomExtraInfoList[0])
        print("The room values are: \(roomExtraInfoList.first?.value)")
        
        // Ensure roomExtraInfoList is not empty
        guard let firstInfo = roomExtraInfoList.first else {
            print("Room extra info list is empty.")
            return
        }
   
        // Assuming jsonString contains your JSON data
        let jsonString = firstInfo.value

        if let data = jsonString.data(using: .utf8) {
            do {
                // Deserialize the JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Access the value associated with the key "pkHost"
                    if let pkHostString = json["pkHost"] as? String,
                       let pkHostData = pkHostString.data(using: .utf8),
                       let pkHostJson = try JSONSerialization.jsonObject(with: pkHostData, options: []) as? [String: Any] {
                        
                        // Access the JSON object represented by "pkHost"
                        print("Value associated with 'pkHost' as JSON object: \(pkHostJson)")
                        
                        let host = type(of: pkHostJson["coHost123"])
                        print(host)
                        
                        if let coHost1234 = pkHostJson["coHost123"] as? String {
                            print(coHost1234)
                      
                            // Assuming coHost1234 contains your JSON string
                            if let coHostData = coHost1234.data(using: .utf8) {
                                do {
                                    if let coHostJson = try JSONSerialization.jsonObject(with: coHostData, options: []) as? [String: Any] {
                                        // Now you have access to the coHostJson
                                        print("coHostJson: \(coHostJson)")
                                        
                                        if let coHostJson = try JSONSerialization.jsonObject(with: coHostData, options: []) as? [String: Any] {
                                            // Iterate over all key-value pairs in coHostJson
                                            for (key, value) in coHostJson {
                                                // Access the value for each key
                                                
                                                print("Key: \(key), Value: \(value)")
                                                if let jsonData = (value as? String)?.data(using: .utf8) {
                                                    if let coHostDetails = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                                        micUser = getZegoMicUserListModel()
                                                        
                                                        // Access and print nested properties
                                                        if let coHostID = coHostDetails["coHostID"] as? String {
                                                            print("coHostID: \(coHostID)")
                                                            micUser.coHostID = coHostID
                                                            
                                                        }
                                                        if let coHostLevel = coHostDetails["coHostLevel"] as? String {
                                                            print("coHostLevel: \(coHostLevel)")
                                                            micUser.coHostLevel = coHostLevel
                                                        }
                                                        if let coHostImage = coHostDetails["coHostUserImage"] as? String {
                                                            print("coHostImage: \(coHostImage)")
                                                            micUser.coHostUserImage = coHostImage
                                                        }
                                                        if let coHostName = coHostDetails["coHostUserName"] as? String {
                                                            print("coHostName: \(coHostName)")
                                                            micUser.coHostUserName = coHostName
                                                        }
                                                        if let coHostMuted = coHostDetails["isHostMuted"] as? Bool {
                                                            print("coHostMuted: \(coHostMuted)")
                                                            micUser.isHostMuted = coHostMuted
                                                        }
                                                        if let coHostStatus = coHostDetails["coHostUserStatus"] as? String {
                                                            print("coHostStatus: \(coHostStatus)")
                                                            micUser.coHostUserStatus = coHostStatus
                                                        }
                                                        if let coHostAudioStatus = coHostDetails["coHostAudioStatus"] as? String {
                                                            print("coHostAudioStatus: \(coHostAudioStatus)")
                                                            micUser.coHostAudioStatus = coHostAudioStatus
                                                        }
                                                        
                                                         if (roomID == channelName ) {
                                                             print("Room ID same hai yhn par ehi kaam krenge jo chal raha hai.")
                                                             
                                                        if zegoMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                            // There is already an element with the same coHostID in zegoMicUsersList
                                                            if ( micUser.coHostUserStatus != "add") {
                                                                
                                                                let streamID = channelName + micUser.coHostID! + "_cohost_stream"
                                                                print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                                
                                                                ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                                
                                                                zegoMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                                print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                              
                                                            }
                                                            tblViewMicJoinedUsers.reloadData()
                                                        } else {
                                                            // There is no element with the same coHostID in zegoMicUsersList
                                                            zegoMicUsersList.append(micUser)
                                                            for i in zegoMicUsersList {
                                                                print(i)
                                                                print(i.coHostID)
                                                                let streamID = channelName + i.coHostID! + "_cohost_stream"
                                                                print("THe stream id we are passing in case of the join mic is: \(streamID)")
                                                                
                                                                let config = ZegoPlayerConfig()
                                                                config.roomID = channelName
                                                                
                                                                let zegocanvas = ZegoCanvas(view: UIView())
                                                                
                                                                ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                            }
                                                            tblViewMicJoinedUsers.reloadData()
                                                        }
                                                         } else {
                                                             print("Yhn par pk ke opponent wala mic par users wala kaam krna hai")
                                                           
                                                             if zegoOpponentMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                                 // There is already an element with the same coHostID in zegoMicUsersList
                                                                 if ( micUser.coHostUserStatus != "add") {
                                                                     
                                                                     let streamID = secondRoom + micUser.coHostID! + "_cohost_stream"
                                                                     print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                                     
                                                                     ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                                     
                                                                     zegoOpponentMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                                     print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                                 }
                                                                 tblViewMicJoinedUsers.reloadData()
                                                             } else {
                                                                 // There is no element with the same coHostID in zegoOpponentMicUsersList
                                                                 zegoOpponentMicUsersList.append(micUser)
                                                                 for i in zegoOpponentMicUsersList {
                                                                     print(i)
                                                                     print(i.coHostID)
                                                                     let streamID = secondRoom + i.coHostID! + "_cohost_stream"
                                                                     print("THe stream id we are passing in case of the join mic is: \(streamID)")
                                                                     
                                                                     let config = ZegoPlayerConfig()
                                                                     config.roomID = secondRoom
                                                                     
                                                                     let zegocanvas = ZegoCanvas(view: UIView())
                                                                     
                                                                     ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                                 }
                                                                 tblViewMicJoinedUsers.reloadData()
                                                             }
                                                         }
                                                    
                                                       // zegoMicUsersList.append(micUser)
                                                        print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                                        // Repeat the same for other properties like coHostUserImage, coHostUserName, coHostUserStatus
                                                    }
                                                }
                                            }
                                            print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                        }
                                        
                                    }
                                } catch {
                                    print("Error parsing JSON: \(error)")
                                }
                            }
                            
                        }
                        
                        if let coHost123 = pkHostJson["coHost123"] as? [String: Any] {
                            // Now `coHost123` contains the data you want

                            for (_, value) in coHost123 {
                                if let coHostData = value as? String {
                                    // Assuming `coHostData` is a JSON string, you can parse it to get its values
                                    if let jsonData = coHostData.data(using: .utf8) {
                                        do {
                                            if let coHostDetails = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                                // Now you have access to the values in coHostDetails
                                                
//                                                // Access and print nested properties
//                                                let micUser = getZegoMicUserListModel()
                                                
                                                if let coHostID = coHostDetails["coHostID"] as? String {
                                                    print("coHostID: \(coHostID)")
                                                    micUser.coHostID = coHostID
                                                }
                                                if let coHostLevel = coHostDetails["coHostLevel"] as? String {
                                                    print("coHostLevel: \(coHostLevel)")
                                                    micUser.coHostLevel = coHostLevel
                                                }
                                                if let coHostImage = coHostDetails["coHostUserImage"] as? String {
                                                    print("coHostImage: \(coHostImage)")
                                                    micUser.coHostUserImage = coHostImage
                                                }
                                                if let coHostName = coHostDetails["coHostUserName"] as? String {
                                                    print("coHostName: \(coHostName)")
                                                    micUser.coHostUserName = coHostName
                                                }
                                                if let coHostMuted = coHostDetails["isHostMuted"] as? Bool {
                                                    print("coHostMuted: \(coHostMuted)")
                                                    micUser.isHostMuted = coHostMuted
                                                }
                                                if let coHostStatus = coHostDetails["coHostUserStatus"] as? String {
                                                    print("coHostStatus: \(coHostStatus)")
                                                    micUser.coHostUserStatus = coHostStatus
                                                }
                                                if let coHostAudioStatus = coHostDetails["coHostAudioStatus"] as? String {
                                                    print("coHostAudioStatus: \(coHostAudioStatus)")
                                                    micUser.coHostAudioStatus = coHostAudioStatus
                                                }
                                                
                                                if (roomID == channelName ) {
                                                    print("Room ID same hai yhn par ehi kaam krenge jo chal raha hai.")
                                                    
                                               if zegoMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                   // There is already an element with the same coHostID in zegoMicUsersList
                                                   if ( micUser.coHostUserStatus != "add") {
                                                       
                                                       let streamID = channelName + micUser.coHostID! + "_cohost_stream"
                                                       print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                       
                                                       ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                       
                                                       zegoMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                       print("Host ko hta do yhn se remove ho gyi hai par aaya hai")

                                                   }
                                                   tblViewMicJoinedUsers.reloadData()
                                               } else {
                                                   // There is no element with the same coHostID in zegoMicUsersList
                                                   zegoMicUsersList.append(micUser)
                                                   for i in zegoMicUsersList {
                                                       print(i)
                                                       print(i.coHostID)
                                                       let streamID = channelName + i.coHostID! + "_cohost_stream"
                                                       print("THe stream id we are passing in case of the join mic is: \(streamID)")
                                                       
                                                       let config = ZegoPlayerConfig()
                                                       config.roomID = channelName
                                                       
                                                       let zegocanvas = ZegoCanvas(view: UIView())
                                                       
                                                       ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                   }
                                                   tblViewMicJoinedUsers.reloadData()
                                               }
                                                } else {
                                                    print("Yhn par pk ke opponent wala mic par users wala kaam krna hai")
                                                  
                                                    if zegoOpponentMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                        // There is already an element with the same coHostID in zegoMicUsersList
                                                        if ( micUser.coHostUserStatus != "add") {
                                                            
                                                            let streamID = secondRoom + micUser.coHostID! + "_cohost_stream"
                                                            print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                            
                                                            ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                            
                                                            zegoOpponentMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                            print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                            
                                                        }
                                                        tblViewMicJoinedUsers.reloadData()
                                                    } else {
                                                        // There is no element with the same coHostID in zegoOpponentMicUsersList
                                                        zegoOpponentMicUsersList.append(micUser)
                                                        for i in zegoOpponentMicUsersList {
                                                            print(i)
                                                            print(i.coHostID)
                                                            let streamID = secondRoom + i.coHostID! + "_cohost_stream"
                                                            print("THe stream id we are passing in case of the join mic is: \(streamID)")
                                                            
                                                            let config = ZegoPlayerConfig()
                                                            config.roomID = secondRoom
                                                            
                                                            let zegocanvas = ZegoCanvas(view: UIView())
                                                            
                                                            ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                        }
                                                        tblViewMicJoinedUsers.reloadData()
                                                    }
                                                }

//                                                zegoMicUsersList.append(micUser)
                                                print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                                // Repeat the same for other properties like coHostUserImage, coHostUserName, coHostUserStatus
                                            
                                                print("The zego mic user list count is: \(zegoMicUsersList.count)")

                                                
                                            }
                                        } catch {
                                            print("Error parsing JSON: \(error)")
                                        }
                                    }
                                }
                            }
                        }

                        
                        // Now you can access the individual properties of the pkHost JSON object
                        if let value = pkHostJson["pkHostUserID"] as? String {
                            print("Value associated with 'key': \(value)")
                        }
                        if let value1 = pkHostJson["pkHostImage"] as? String {
                            print("Value associated with 'key': \(value1)")
                        }
                        
                    } else {
                        print("Failed to parse 'pkHost' as a JSON object.")
                        print("Yhn par LIVE Ke case main jo kaam hai woh karenge")
                        do {
                          
                            if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                   // Access the dictionary and its values
                                   print("JSON Dictionary:")
                                   print(jsonDictionary)
                                   
                                   // Now you have access to the JSON data as a dictionary
                                   // You can access specific values using keys
                                   
                                   if let value = jsonDictionary["coHost123"] as? String {
                                       print("Value from JSON: \(value)")
                                   }
                               } else {
                                   print("Failed to parse Data as JSON dictionary")
                               }
                            
                            let variableType = type(of: data)

                            // Print the type
                            print("The type of variable is: \(variableType)")
                            
                                // Deserialize the JSON data
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    // Access the value associated with the key "coHost123"
                                    let variableType = type(of: json["coHost123"])

                                    // Print the type
                                    print("The type of variable is: \(variableType)")
                                    
                                    if let coHost123String = json["coHost123"] as? String {
                                        // Parse the nested JSON string associated with "coHost123"
                                        if let coHost123Data = coHost123String.data(using: .utf8) {
                                            if let coHost123Json = try JSONSerialization.jsonObject(with: coHost123Data, options: []) as? [String: Any] {
                                                // Now you have access to the nested JSON objects
                                                for (key, value) in coHost123Json {
                                                    print("Key: \(key), Value: \(value)")
                                                    // Access the value associated with each key
                                                    
                                                    // Access the value associated with the key
                                                    if let nestedJSONString = value as? String,
                                                       let nestedData = nestedJSONString.data(using: .utf8) {
                                                        do {
                                                            // Parse the nested JSON string
                                                            if let nestedJson = try JSONSerialization.jsonObject(with: nestedData, options: []) as? [String: Any] {
                                                                // Now you can access the values in the nested JSON object
                                                                micUser = getZegoMicUserListModel()
                                                                
                                                                // Access and print nested properties
                                                                if let coHostID = nestedJson["coHostID"] as? String {
                                                                    print("coHostID: \(coHostID)")
                                                                    micUser.coHostID = coHostID
                                                                   
                                                                }
                                                                if let coHostLevel = nestedJson["coHostLevel"] as? String {
                                                                    print("coHostLevel: \(coHostLevel)")
                                                                    micUser.coHostLevel = coHostLevel
                                                                }
                                                                if let coHostImage = nestedJson["coHostUserImage"] as? String {
                                                                    print("coHostImage: \(coHostImage)")
                                                                    micUser.coHostUserImage = coHostImage
                                                                }
                                                                if let coHostName = nestedJson["coHostUserName"] as? String {
                                                                    print("coHostName: \(coHostName)")
                                                                    micUser.coHostUserName = coHostName
                                                                }
                                                                if let coHostMuted = nestedJson["isHostMuted"] as? Bool {
                                                                    print("coHostMuted: \(coHostMuted)")
                                                                    micUser.isHostMuted = coHostMuted
                                                                }
                                                                if let coHostStatus = nestedJson["coHostUserStatus"] as? String {
                                                                    print("coHostStatus: \(coHostStatus)")
                                                                    micUser.coHostUserStatus = coHostStatus
                                                                }
                                                                if let coHostAudioStatus = nestedJson["coHostAudioStatus"] as? String {
                                                                    print("coHostAudioStatus: \(coHostAudioStatus)")
                                                                    micUser.coHostAudioStatus = coHostAudioStatus
                                                                }
                                                                
                                                                
                                                                if zegoMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                                    // There is already an element with the same coHostID in zegoMicUsersList
                                                                    if ( micUser.coHostUserStatus != "add") {
                                                    
                                                                            let streamID = channelName + micUser.coHostID! + "_cohost_stream"
                                                                            print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                                        
                                                                            ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                                        
                                                                        zegoMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                                        print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                                        zegoSendMicUsersList.removeValue(forKey: micUser.coHostID ?? "")
                                                                           print("User removed from zegoSendMicUsersList")
                                                                        setRoomExtraInfo(from: "delete")
                                                                        if (openedVCID == micUser.coHostID) {
                                                                            dismiss(animated: true, completion: nil)
                                                                        } else {
                                                                            print("View ko bnd krne ki koi jrurt nahi hai.")
                                                                        }
                                                                    }
                                                                    
                                                                    tblViewMicJoinedUsers.reloadData()
                                                                } else {
                                                                    // There is no element with the same coHostID in zegoMicUsersList
//                                                                    if (isFirstLive == true) {
//                                                                        print("Kuch bhi nahi karna hai bhai.")
//                                                                        isFirstLive = false
//                                                                    } else {
                                                                    zegoMicUsersList.append(micUser)
                                                                    for i in zegoMicUsersList {
                                                                        print(i)
                                                                        print(i.coHostID)
                                                                        let streamID = channelName + i.coHostID! + "_cohost_stream"
                                                                        print("THe stream id we are passing in case of the join mic in live is: \(streamID)")
                                                                        
                                                                        let config = ZegoPlayerConfig()
                                                                        config.roomID = channelName
                                                                        
                                                                        let zegocanvas = ZegoCanvas(view: UIView())
                                                                        
                                                                        ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                                        let micUserJson: [String: Any] = [
                                                                                "coHostUserImage": micUser.coHostUserImage,
                                                                                "coHostUserName": micUser.coHostUserName,
                                                                                "coHostID": micUser.coHostID,
                                                                                "coHostUserStatus": micUser.coHostUserStatus,
                                                                                "coHostLevel": micUser.coHostLevel,
                                                                                "coHostAudioStatus": micUser.coHostAudioStatus,
                                                                                "isHostMuted": micUser.isHostMuted
                                                                                
                                                                            ]
                                                                            
                                                                            // Convert the JSON object to a JSON string
                                                                            if let jsonData = try? JSONSerialization.data(withJSONObject: micUserJson, options: []),
                                                                               let jsonString = String(data: jsonData, encoding: .utf8) {
                                                                                
                                                                                // Add the JSON string to zegoSendMicUsersList with coHostID as the key
                                                                                zegoSendMicUsersList[micUser.coHostID ?? ""] = jsonString
                                                                            } else {
                                                                                print("Error converting micUser to JSON string")
                                                                            }
                                                                        
                                                                    }
                                                                    tblViewMicJoinedUsers.reloadData()
                                                               // }
                                                                }
                                                            }
                                                            
                                                        } catch {
                                                            print("Error parsing nested JSON: \(error)")
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    print("Ye string nahi hai. aaagey ki baat karo.")
                                }
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

    }
    
    func onRoomStateChanged(_ reason: ZegoRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable : Any], roomID: String) {
        print(roomID)
        switch reason {
           case .logining:
               // logging in
               // When loginRoom is called to log in to the room or switchRoom is used to switch to the target room, it enters this state, indicating that it is requesting to connect to the server.
            print(reason)
            print(errorCode)
               break
           case .logined:
               // login successful
               // Currently, the loginRoom is successfully called by the developer or the callback triggered by the successful switchRoom. Here, you can handle the business logic for the first successful login to the room, such as fetching chat room and live streaming basic information.
            print(reason)
            print(errorCode)
            print("The room id we are logined for is: \(roomID)")
//            group.leave()
               break
           case .loginFailed:
               // login failed
               if errorCode == 1002033 {
                   // When using the login room authentication function, the incoming Token is incorrect or expired.
                   print(reason)
                   print(errorCode)
                   print("The room id we are logined failed for is: \(roomID)")
               }
            print("The room id we are logined failed for is: \(roomID)")
            print(reason)
            print(errorCode)
               break
           case .reconnecting:
               // Reconnecting
               // This is currently a callback triggered by successful disconnection and reconnection of the SDK. It is recommended to show some reconnection UI here.
            print(reason)
            print(errorCode)

               break
           case .reconnected:
               // Reconnection successful
            print(reason)
            print(errorCode)

               break
           case .reconnectFailed:
               // Reconnect failed
               // When the room connection is completely disconnected, the SDK will not reconnect. If developers need to log in to the room again, they can actively call the loginRoom interface.
               // At this time, you can exit the room/live broadcast room/classroom in the business, or manually call the interface to log in again.
            print(reason)
            print(errorCode)

               break
           case .kickOut:
               // kicked out of the room
               if errorCode == 1002050 {
                   // The user was kicked out of the room (because the user with the same userID logged in elsewhere).
                   print(reason)
                   print(errorCode)
               }
               else if errorCode == 1002055 {
                   // The user is kicked out of the room (the developer actively calls the background kicking interface).
                   print(reason)
                   print(errorCode)
               }
               break
           case .logout:
               // Logout successful
               // The developer actively calls logoutRoom to successfully log out of the room.
               // Or call switchRoom to switch rooms. Log out of the current room successfully within the SDK.
               // Developers can handle the logic of actively logging out of the room callback here.
            print("Logout Successfully.")
               break
           case .logoutFailed:
               // Logout failed
               // The developer actively calls logoutRoom and fails to log out of the room.
               // Or call switchRoom to switch rooms. Logout of the current room fails internally in the SDK.
               // The reason for the error may be that the logout room ID is wrong or does not exist.
               break
           @unknown default:
               break
           }
    }
    
}

extension PublishStreamViewController : ZegoCustomVideoProcessHandler{
    
    
    func onCapturedUnprocessedCVPixelBuffer(_ buffer: CVPixelBuffer, timestamp: CMTime, channel: ZegoPublishChannel) {
        //        if self.filterType == .invert {
        //            filterInvert(buffer)
        //        } else if self.filterType == .grayscale {
        //            filterGrayscale(buffer)
        //        }
        
        //   FUDemoManager.shared().checkAITrackedResult()
        
        FUDemoManager.shared().checkResult { hidden, text in
            // Handle the result here
            print("Track Tip Label hidden: \(hidden)")
            print("Track Tip Label message: \(text)")
            
            if (hidden == true) {
                
                print("Chehra dikh rha hai koi na koi")
                
                self.viewNoFaceDetected.isHidden = true
                self.countdownTimer?.invalidate()
                self.isTimerRunning = false
                
            } else {
                
                print("Chehra nahi dikh raha hai koi bhi.")
                
                // Start the timer only if it's not already running
                      if !self.isTimerRunning {
                          self.totalTime = 180
                          self.startTimer()
                          self.isTimerRunning = true   // Mark the timer as running
                      }
                
                //self.startTimer()
                
               // self.viewNoFaceDetected.isHidden = false
                
            }
            
        }
        
        
        if FUDemoManager.shared().shouldRender {
            FUDemoManager.updateBeautyBlurEffect()
            let input = FURenderInput()
            // 默认图片内部的人脸始终是朝上，旋转屏幕也无需修改该属性。
            input.renderConfig.imageOrientation = FUImageOrientationUP
            // 开启重力感应，内部会自动计算正确方向，设置fuSetDefaultRotationMode，无须外面设置
            input.renderConfig.gravityEnable = true
            input.renderConfig.isFromFrontCamera = true
            // input.renderConfig.isFromMirroredCamera = true
            input.renderConfig.stickerFlipH = true
            input.pixelBuffer = buffer
            let output = FURenderKit.share().render(with: input)
            if let pixelBuffer = output.pixelBuffer {
                ZegoExpressEngine.shared().sendCustomVideoProcessedCVPixelBuffer(pixelBuffer, timestamp: timestamp, channel: channel)
            } else {
                print("Error: One or more parameters are nil")
            }
            
            // ZegoExpressEngine.shared().sendCustomVideoProcessedCVPixelBuffer(output.pixelBuffer, timestamp: timestamp, channel: channel)
        } else {
            ZegoExpressEngine.shared().sendCustomVideoProcessedCVPixelBuffer(buffer, timestamp: timestamp, channel: channel)
        }
        
    }
 
}

// MARK: - EXTENSION TO START TIMER FOR HIDING AND SHOWING THE NO FACE POPUP

extension PublishStreamViewController {
    
    func startTimer() {
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTime() {
        // Print the remaining time
        print("The total time left for closing the broadcast in case of no face visible is: \(totalTime)")
        
        // If totalTime is less than 60, show the no face detected view
        if totalTime < 60 {
            print("Showing the 'No Face Detected' label and performing related tasks.")
            viewNoFaceDetected.isHidden = false
            lblNoFaceDetectTime.text =  String(totalTime) + "s" //timeFormatted(totalTime) // Update the label with the formatted time
        } else {
            print("Not showing the 'No Face Detected' label and skipping related tasks.")
            viewNoFaceDetected.isHidden = true
        }

        // Decrement totalTime each second
        if totalTime > 0 {
            totalTime -= 1
        } else {
            endTimer() // Stop the timer when it reaches 0
        }
    }
    
    func endTimer() {
        
        print("Timer ko band krane wala function call hua hai ab. kyunki time poora ho gaya hai timer ka ab.")
        
        countdownTimer?.invalidate()
        countdownTimer = nil
        isTimerRunning = false
        
        removeUserOnMic()
        quitgroup(id: groupID)
        removePKRequestDetailsOnFirebase()
        removeMessagesOnFirebase()
        removePKRequestOnFirebase()
        setRoomExtraInfo(from: "close")
        removeCoHostInviteDetailsOnFirebase()
        removeCoHostInviteListOnFirebase()
        endLiveBroadcast()
        sendMessageToExitUserFromBroad()
        stopPublishingStream()
        stopLive(roomID: roomId)
        destroyEngine()
        removeLottieAnimationViews()
        updateUserStatusToFirebaseExit()
        FUDemoManager.destory()
        dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

//    func onCapturedUnprocessedCVPixelBuffer(_ buffer: CVPixelBuffer, timestamp: CMTime, channel: ZegoPublishChannel) {
//
//        
//        let input = FURenderInput()
//        input.pixelBuffer = buffer
//      
//        let out = FURenderKit.share().render(with: input)
//        print("The out.pixel buffer is: \(out.pixelBuffer)")
//        
//        ZegoExpressEngine.shared().sendCustomVideoProcessedCVPixelBuffer(out.pixelBuffer, timestamp: timestamp, channel: channel)
//
//
//        let detectingResult = FURenderKitManager.faceTracked()
//        
//        print("The detecting result is: \(detectingResult)")
//
//        let a = FURenderer.isTracking()
//        print("If faceunity is tracking: \(a)")
//
//        if(!detectingResult){
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                print("Host ki shakal nahi dikh rahi hai. Pop up dikhana hai yhn par.")
//             //   ZLNoFaceAlertManager.share.show()
//             //   ZLNoFaceAlertManager.share.detegate = self
//            }
//        } else{
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                print("Host ki shakal dikh rahi hai. Pop Up ko bnd kr do no face detected wale ko.")
//              //  ZLNoFaceAlertManager.share.dismissView()
//            }
//        }
//    }

//extension PublishStreamViewController : FURenderKitDelegate{
//    
//    func renderKitWillRender(from renderInput: FURenderInput) {
//        
//        startTime = CFAbsoluteTimeGetCurrent()
//    }
//    
//    func renderKitDidRender(to renderOutput: FURenderOutput) {
//
//
//        let endTime = CFAbsoluteTimeGetCurrent();
//        // 加一帧占用时间
//        lastCalculateTime = (endTime - self.startTime!)
//    
//      
//    }
//    // MARK: - FURenderKitDelegate
//
//      func renderKit(_ renderKit: FURenderKit, didProcessFrameWithTime time: CMTime) {
//          // Optional: Handle any post-processing or updates based on FURenderKit's rendering process
//          let trackingStatus = FURenderer.isTracking()
//          if trackingStatus > 0 {
//              NSLog("Face is being tracked")
//          } else {
//              NSLog("No face is being tracked")
//          }
//      }
    
