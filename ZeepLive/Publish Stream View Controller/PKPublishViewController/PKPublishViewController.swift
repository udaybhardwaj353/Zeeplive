//
//  PKPublishViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 26/06/24.
//

import UIKit
import Lottie
import ImSDK_Plus
import ZegoExpressEngine
import FittedSheets
import FirebaseDatabase
import Kingfisher

class PKPublishViewController: UIViewController, ZegoEventHandler, delegateJoinedAudienceListViewController, delegateCallNotificationViewController, delegateRequestJoinMicUserListCollectionViewCell, delegateJoinMicUserOptionsViewController, delegateCommonPopUpViewController {

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
    
    lazy var playCanvas = ZegoCanvas()
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
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnUserDetailOutlet: UIButton!
    @IBOutlet weak var imgViewUserImage: UIImageView!
    @IBOutlet weak var btnFollowHostOutlet: UIButton!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblBroadCount: UILabel!
    @IBOutlet weak var btnCloseBroadOutlet: UIButton!
    @IBOutlet weak var btnViewAudienceOutlet: UIButton!
   // @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewBroadUserJoinList: UICollectionView!
    @IBOutlet weak var btnViewDistributionOutlet: UIButton!
    @IBOutlet weak var imgViewDistribution: UIImageView!
    @IBOutlet weak var lblDistributionAmount: UILabel!
    @IBOutlet weak var btnViewRewardOutlet: UIButton!
    @IBOutlet weak var btnViewRewardRankOutlet: UIButton!
    @IBOutlet weak var lblViewRewardRank: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewOneToOneCall: UIView!
    @IBOutlet weak var btnOneToOneCallOutlet: UIButton!
    @IBOutlet weak var viewGift: UIView!
    @IBOutlet weak var btnGiftOutlet: UIButton!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var btnOpenMessageOutlet: UIButton!
    @IBOutlet weak var btnGameOutlet: UIButton!
    @IBOutlet weak var viewUserRoomStatus: UIView!
    @IBOutlet weak var lblRoomUserName: UILabel!
    @IBOutlet weak var lblRoomUserStatus: UILabel!
    @IBOutlet weak var viewLiveMessages: UIView!
    @IBOutlet weak var tblViewLiveMessages: UITableView!
    @IBOutlet weak var viewPK: UIView!
    @IBOutlet weak var viewPKFirstUserOutlet: UIButton!
    @IBOutlet weak var viewPKSecondUserOutlet: UIButton!
    @IBOutlet weak var viewPKSecondUserNameOutlet: UIButton!
    @IBOutlet weak var lblPKSecondUserName: UILabel!
    @IBOutlet weak var viewPKBottom: UIView!
    @IBOutlet weak var viewPKAnimation: UIView!
    @IBOutlet weak var viewUsersOnMic: UIView!
    @IBOutlet weak var viewOpponentUsersOnMic: UIView!
    @IBOutlet weak var viewThirdUserOnMic: UIButton!
    @IBOutlet weak var viewSecondUserOnMic: UIButton!
    @IBOutlet weak var viewFirstUserOnMic: UIButton!
    @IBOutlet weak var imgViewThirdUserOnMic: UIImageView!
    @IBOutlet weak var imgViewSecondUserOnMic: UIImageView!
    @IBOutlet weak var imgViewFirstUserOnMic: UIImageView!
    @IBOutlet weak var viewOpponentFirstUserOnMic: UIButton!
    @IBOutlet weak var viewOpponentSecondUserOnMic: UIButton!
    @IBOutlet weak var viewOpponentThirdUserOnMic: UIButton!
    @IBOutlet weak var imgViewOpponentFirstUserOnMic: UIImageView!
    @IBOutlet weak var imgViewOpponentSecondUserOnMic: UIImageView!
    @IBOutlet weak var imgViewOpponentThirdUserOnMic: UIImageView!
    @IBOutlet weak var pkBarStackView: UIStackView!
    @IBOutlet weak var viewStackLeft: UIView!
    @IBOutlet weak var viewStackMiddle: UIView!
    @IBOutlet weak var viewStackRight: UIView!
    @IBOutlet weak var lblLeftStackViewGiftAmount: UILabel!
    @IBOutlet weak var lblRightStackViewGiftAmount: UILabel!
    @IBOutlet weak var viewPKGiftedUsers: UIView!
    @IBOutlet weak var viewPKUserGifted: UIView!
    @IBOutlet weak var viewPKOpponentUserGifted: UIView!
    @IBOutlet weak var btnGiftUserThreeOutlet: UIButton!
    @IBOutlet weak var btnGiftUserTwoOutlet: UIButton!
    @IBOutlet weak var btnGiftUserOneOutlet: UIButton!
    @IBOutlet weak var btnGiftOpponentUserOneOutlet: UIButton!
    @IBOutlet weak var btnGiftOpponentUserTwoOutlet: UIButton!
    @IBOutlet weak var btnGiftOpponentUserThreeOutlet: UIButton!
    @IBOutlet weak var viewTimerCount: UIView!
    @IBOutlet weak var lblTimerCount: UILabel!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnSendMessageOutlet: UIButton!
    @IBOutlet weak var viewTextFieldOutlet: UIView!
    @IBOutlet weak var txtFldMessage: UITextField!
    @IBOutlet weak var viewLuckyGift: UIView!
    @IBOutlet weak var lblNoOfGift: UILabel!
    @IBOutlet weak var viewLuckyGiftDetails: UIView!
    @IBOutlet weak var viewUserImage: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var viewGiftImage: UIView!
    @IBOutlet weak var imgViewGift: UIImageView!
    @IBOutlet weak var lblSendGiftHostName: UILabel!
    @IBOutlet weak var btnGameWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewMessageBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var imgViewGiftUserOne: UIImageView!
    @IBOutlet weak var imgViewGiftUserTwo: UIImageView!
    @IBOutlet weak var imgViewGiftUserThree: UIImageView!
    @IBOutlet weak var imgViewGiftOpponentUserOne: UIImageView!
    @IBOutlet weak var imgViewGiftOpponentUserTwo: UIImageView!
    @IBOutlet weak var imgViewGiftOpponentUserThree: UIImageView!
    @IBOutlet weak var viewLeftStackWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewRightStackWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnFollowHostWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewPKFirstUserOutletWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewPKSecondUserOutletWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionViewJoinMic: UICollectionView!
    
    
    lazy var lottieAnimationViews: [LottieAnimationView] = []
    lazy var timer = Timer()
    lazy var dailyEarningBeans: String = ""
    lazy var weeklyEarningBeans:String = ""
    lazy var myGiftCoins: Int = 0
    lazy var opponentGiftCoins: Int = 0
    lazy var viewBijlee = UIView()
    lazy var pktimer = Timer()
    lazy var totalTime = 240
    lazy var totalMsgData = liveMessageModel()
    lazy var liveMessages: [liveMessageModel] = []
    lazy var groupUsers = [joinedGroupUserProfile]()
    lazy var userInfoList: [V2TIMUserFullInfo]? = []
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
    lazy var zegoMicUsersList: [getZegoMicUserListModel] = []
    lazy var zegoOpponentMicUsersList: [getZegoMicUserListModel] = []
    lazy var pkRequestHostDetail = getPKRequestHostsModel()
    lazy var channelName: String = ""
    lazy var streamName: String = ""
    lazy var isMuteMicButtonPressed = false
    lazy var vcAudiencePresent:Bool = false
    lazy var messageListener = MessageListener()
    lazy var liveMessage = liveMessageModel()
    lazy var luckyGiftCount: Int = 0
    lazy var callMemberList: Bool = false
    lazy var groupID: String = ""
    lazy var hasUpdatedStatus: Bool = false
    lazy var isFirstTime: Bool = true
    lazy var pkUserGiftDetail = pkUsersGiftModel()
    lazy var pkGiftList: [pkUsersGiftModel] = []
    lazy var pkOpponentGiftList: [pkUsersGiftModel] = []
    lazy var pkUserTotalGiftCoins: Int = 0
    lazy var pkUserOpponentTotalGiftCoins: Int = 0
    lazy var callSenderID: String = ""
    lazy var callSenderName: String = ""
    lazy var callChannelName: String = ""
    lazy var callSenderImage: String = ""
    lazy var zegoSendMicUsersList: [String: String] = [:]
    lazy var coHostRequestList: [getCoHostInviteUsersDetail] = []
    lazy var micUser = getZegoMicUserListModel()
    lazy var secondRoom: String = ""
    lazy var room: String = ""
    lazy var currentIndexForCoHost: Int = 0
    lazy var pkRequestID: String = ""
    lazy var pkID: String = ""
    lazy var secondGroupID: String = ""
    lazy var pkEndTime: Int = 0
    lazy var taskID: String = ""
    
    weak var sheetController:SheetViewController!
    var userMessageHandle: DatabaseHandle?
    var userStatusHandle: DatabaseHandle?
    var HostMicRequestHandle:DatabaseHandle?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let pID = self.pkRequestHostDetail.inviteUserID ?? ""
//        
//        ZLFireBaseManager.share.userRef.child("UserStatus").child(pID).child("status").setValue("PK") { [weak self] (error, reference) in
//            
//            guard let self = self else {
//                // self is nil, probably deallocated
//                return
//            }
//            
//            if let error = error {
//                print("Error writing data: \(error)")
//            } else {
//                print("User Online Details written successfully on firebase on opponent node in pk publish view controller.")
//            }
//        }
        
       // getUserDetails()
      //  getUserProfileID()
        
        btnCloseBroadOutlet.isUserInteractionEnabled = false
        
        print("THe pk id we are getting in the PK Publish View Controller is: \(pkID)")
        
        room = channelName
        print("The room id in pk publish view controller is: \(room)")
        
     //   removePKRequestDetailsOnFirebase()
        removeMessagesOnFirebase()
      //  removePKRequestOnFirebase()
        removeCoHostInviteDetailsOnFirebase()
        removeCoHostInviteListOnFirebase()

       // ZegoExpressEngine.shared().logoutRoom()
        ZegoExpressEngine.destroy(nil)
       // createEngine()
        configureUI()
        addLottieAnimation()
        configureImages()
        configureBottomBarWork()
        timerAndNotification()
        tableViewWork()
        collectionViewWork()
        setData()
        startTimer()
        addListeners()
        getGroupCallBack()
        joinGroup(id: groupID)
        addObserverForCoHostInviteList()
        
//        let identifier = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
//        addMessageObserver(id: identifier)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            let inviteUserID = self.pkRequestHostDetail.inviteUserID ?? ""
//            self.addObserve(id: inviteUserID)
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }  // Ensure self is not deallocated
            
            let inviteUserID = self.pkRequestHostDetail.inviteUserID ?? ""  // Safe default to empty string
            self.addObserve(id: inviteUserID)  // Proceed with the observation
        }

        print("THe channel name we are getting is: \(channelName) ")
        print("The stream name we are getting is: \(streamName)")
     //   setRoomExtraInfo()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createEngine()
        setData()
       
        if isMuteMicButtonPressed
        
        {
          
            isMuteMicButtonPressed = false
          btnMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
            ZegoExpressEngine.shared().muteMicrophone(false)
            
        }
        
        else {
            
            isMuteMicButtonPressed = true
          btnMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
            ZegoExpressEngine.shared().muteMicrophone(true)
            
        }
        
    }
    
    func setRoomExtraInfoOnExit() {
    
        // Information to be sent
        let pkHostRoomID = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        let pkHostUserID = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        let type = "pk_end"

        // Create the pkHost dictionary
        let pkHost: [String: Any] = [
            "pkHostRoomID": pkHostRoomID,
            "pkHostUserID": pkHostUserID,
            "type": type
        ]

        // Convert the pkHost dictionary to JSON string
        if let pkHostData = try? JSONSerialization.data(withJSONObject: pkHost, options: []),
           let pkHostJSONString = String(data: pkHostData, encoding: .utf8) {
            
            // Create the outer dictionary
            let outerJSON: [String: String] = [
                "pkHost": pkHostJSONString
            ]
            
            // Convert the outer dictionary to JSON string
            if let outerJSONData = try? JSONSerialization.data(withJSONObject: outerJSON, options: []),
               let finalJSONString = String(data: outerJSONData, encoding: .utf8) {
                
                // Print the final JSON string
                print("Final JSON String: \(finalJSONString)")
                
                ZegoExpressEngine.shared().setRoomExtraInfo(finalJSONString, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in

                        print(errorCode)
                        print(errorCode.description)
                        if errorCode == 0 {
                         print("Successfully delete wala message bhej dia hai extra room info wale main pk publish view controller main..")
                            
                        } else {
                            print("Message abhi group mai shi se nahi gya hai room extra info wala pk publish view controller main..")
                        }
                    })
                
            }
        }
        
    }
    
    func setRoomExtraInfo() {
        
        // Get the current date
        let currentDate = Date()

        // Add 4 minutes to the current date
         let newDate = Calendar.current.date(byAdding: .minute, value: 4, to: currentDate)
            // Convert the new date to milliseconds since the Unix epoch
        let milliseconds = Int((newDate?.timeIntervalSince1970 ?? 0.0) * 1000)
            
        print("Current Global Time + 4 Minutes in milliseconds: \(milliseconds)")
        
        // Information to be sent
        let pkHostImage = pkRequestHostDetail.userImage //(UserDefaults.standard.string(forKey: "profilePicture") ?? "")
        let pkHostName = pkRequestHostDetail.name //(UserDefaults.standard.string(forKey: "UserName") ?? "")
        let pkHostRoomID = pkRequestHostDetail.inviteUserID //(UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        let pkHostUserID = pkRequestHostDetail.inviteUserID //(UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        let pkEndTime = milliseconds
        let type = "pk_start"

        self.pkEndTime = pkEndTime
        
        // Create the pkHost dictionary
        let pkHost: [String: Any] = [
            "pkHostImage": pkHostImage,
            "pkHostName": pkHostName,
            "pkHostRoomID": pkHostRoomID,
            "pkHostUserID": pkHostUserID,
            "pk_end_time": pkEndTime,
            "type": type
        ]
        // Convert the pkHost dictionary to JSON string
        if let pkHostData = try? JSONSerialization.data(withJSONObject: pkHost, options: []),
           let pkHostJSONString = String(data: pkHostData, encoding: .utf8) {
            
            // Create the outer dictionary
            let outerJSON: [String: String] = [
                "pkHost": pkHostJSONString
            ]
            
            // Convert the outer dictionary to JSON string
            if let outerJSONData = try? JSONSerialization.data(withJSONObject: outerJSON, options: []),
               let finalJSONString = String(data: outerJSONData, encoding: .utf8) {
                
                // Print the final JSON string
                print("Final JSON String: \(finalJSONString)")
                // Set room extra info using the SDK
                ZegoExpressEngine.shared().setRoomExtraInfo(finalJSONString, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in

                        print(errorCode)
                        print(errorCode.description)
                        if errorCode == 0 {
                         print("Successfully delete wala message bhej dia hai extra room info wale main pk publish view controller main..")
                        } else {
                            print("Message abhi group mai shi se nahi gya hai room extra info wala pk publish view controller main..")
                        }
                    })
                
            }
        }
        
            print("Poori dictionary  bhejni hai. Woh wala kaam krna hai.")
        
    }
    
//    func sendPKInfo() {
//        // Create the nested dictionary in the required format
////        let coHostInfo: [String: Any] = [
////            "coHostID": "12",
////            "coHostUserName": "12",
////            "coHostUserImage": "12",
////            "coHostUserStatus": "12",
////            "coHostLevel": "12"
////        ]
//        
////        let pkHostMap: [String: Any] = [
////            "type": "pk_start",
////            "pkHostUserID": pkRequestHostDetail.inviteUserID,
////            "pkHostRoomID": pkRequestHostDetail.inviteUserID,
////            "pkHostName": pkRequestHostDetail.name,
////            "pkHostImage": pkRequestHostDetail.userImage,
////            "pk_end_time": pkEndTime,
////            "coHost123": jsonObject//zegoSendMicUsersList
////        ]
////        
////        // Convert the dictionary to JSON data
////        if let jsonData = try? JSONSerialization.data(withJSONObject: pkHostMap, options: []),
////           let jsonString = String(data: jsonData, encoding: .utf8) {
////            
////            // Print or send the final JSON string
////            print("Final JSON String: \(jsonString)")
////            
////            // Send it via SDK (Example using ZegoExpressEngine)
////            ZegoExpressEngine.shared().setRoomExtraInfo(jsonString, forKey: "SYC_USER_INFO", roomID: channelName) { errorCode in
////                if errorCode == 0 {
////                    print("Successfully sent extra room info.")
////                } else {
////                    print("Failed to send extra room info.")
////                }
////            }
////        } else {
////            print("Error serializing JSON.")
////        }
//        
//        let pkHostMap: [String: Any] = [
//            "type": "pk_start",
//            "pkHostUserID": pkRequestHostDetail.inviteUserID,
//            "pkHostRoomID": pkRequestHostDetail.inviteUserID,
//            "pkHostName": pkRequestHostDetail.name,
//            "pkHostImage": pkRequestHostDetail.userImage,
//            "pk_end_time": pkEndTime,
//            "coHost123": zegoSendMicUsersList
//        ]
//        
//        // Convert the dictionary to JSON data
//        if let jsonData = try? JSONSerialization.data(withJSONObject: pkHostMap, options: []),
//           let jsonString = String(data: jsonData, encoding: .utf8) {
//            
//            // Print or send the final JSON string
//            print("Final JSON String: \(jsonString)")
//            
//            // Send it via SDK (Example using ZegoExpressEngine)
//            ZegoExpressEngine.shared().setRoomExtraInfo(jsonString, forKey: "SYC_USER_INFO", roomID: channelName) { errorCode in
//                if errorCode == 0 {
//                    print("Successfully sent extra room info.")
//                } else {
//                    print("Failed to send extra room info.")
//                }
//            }
//        } else {
//            print("Error serializing JSON.")
//        }
//    }

    func muteLiveCoHost(userid: String, value: String) {
        print("The id we are getting in mute/unmute function for unmute is: \(userid)")
        
        print("The zegosendmic users list is: \(zegoSendMicUsersList)")
        
        if zegoSendMicUsersList.contains(where: { $0.key == userid }) {
            print("ID exists in zegoSendMicUsersList")
            
            if let jsonString = zegoSendMicUsersList[userid],
               let data = jsonString.data(using: .utf8),
               var jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // Modify the coHostAudioStatus and isHostMuted values
                jsonObject["coHostAudioStatus"] = value
                jsonObject["isHostMuted"] = (value.lowercased() == "mute") ? "true" : "false"
                
                // Convert the updated JSON object back to a string
                if let updatedJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
                   let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
                    
                    // Update the value in zegoSendMicUsersList
                    zegoSendMicUsersList[userid] = updatedJsonString
                    print("Updated User Data: \(updatedJsonString)")
                } else {
                    print("Error converting JSON object to string")
                }
                
            } else {
                print("User ID \(userid) not found in zegoSendMicUsersList or data is not a valid JSON string")
            }
            
            print("The zegosendmicusers list before sending is: \(zegoSendMicUsersList)")
            
            let listString = jsonString(from: zegoSendMicUsersList)
            
            // Create the structure for pkHost as a dictionary
            let pkHost: [String: Any] = [
                "coHost123": listString // This should be a nested dictionary
            ]
            
            // Convert pkHost to JSON string
             let pkHostString = jsonString(from: pkHost)
            
//            // Prepare the map (coHost123 data)
//            let coHostInfoStr = jsonString(from: zegoSendMicUsersList)
//            
            // Build the main JSON structure for pkHost
            let pkHostMap: [String: Any] = [
                "pkHost": pkHostString,
               // "coHost123": zegoSendMicUsersList, // coHost123 data
                "pkHostImage": pkRequestHostDetail.userImage, // Example data
                "pkHostName": pkRequestHostDetail.name,  // Example data, you can replace these values dynamically
                "pkHostRoomID": pkRequestHostDetail.inviteUserID, // Example data
                "pkHostUserID": pkRequestHostDetail.inviteUserID, // Example data
                "pk_end_time": pkEndTime, // Example end time
                "type": "pk_start"
                
            ]
            
            // Convert pkHostMap to JSON string
            if let pkHostData = try? JSONSerialization.data(withJSONObject: pkHostMap, options: []),
               let infoStr = String(data: pkHostData, encoding: .utf8) {
                
                print("The final information being sent is: \(infoStr)")
                
                // Set room extra info using the SDK
                ZegoExpressEngine.shared().setRoomExtraInfo(infoStr, forKey: "SYC_USER_INFO", roomID: channelName) { errorCode in
                    print(errorCode)
                    print(errorCode.description)
                    if errorCode == 0 {
                        print("Successfully sent extra room info.")
                    } else {
                        print("Failed to send extra room info.")
                    }
                }
            } else {
                print("Error converting pkHostMap to JSON string")
            }
        }
        
        print("The changed zegoSendMicUsersList are: \(zegoSendMicUsersList)")
    }

    
    @IBAction func btnUserDetailOutletPressed(_ sender: Any) {
        
        print("Button User Details Pressed, to know host information.")
        
    }
    
    @IBAction func btnFollowHostPressed(_ sender: Any) {
        
        print("Button Follow Host Pressed, to follow the host.")
        
    }
    
    func deleteButtonPressed(isPressed: Bool) {
       
        dismiss(animated: true, completion: nil)
        
        updateDataOnClosePK()
        print("The pk id we are passing on the firebase is: \(pkID)")
        
        ZLFireBaseManager.share.updateUserStatusToPKRequestFirebase(status: "completed", pkid: pkID)
      
        removeObserverForCoHostInviteList()
        setRoomExtraInfoOnExit()
        
        let identifier = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        removeMessageObserver(id: identifier)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("BroadTencentMessage"),
                                                  object: nil)

        quitgroup(id: groupID)
        removeListeners()
        
        
        let inviteUserID = self.pkRequestHostDetail.inviteUserID ?? ""
        removeObserver(id: inviteUserID)
        ZegoExpressEngine.destroy(nil)
        
    }
    
    @IBAction func btnCloseBroadPressed(_ sender: Any) {
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
        nextViewController.delegate = self
        nextViewController.headingText = "Are you sure you want to close?"
        nextViewController.buttonName = "Close"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
        print("Button Close Broad Pressed.")
//        updateDataOnClosePK()
////        ZLFireBaseManager.share.updateUserStatusToPKRequestFirebase(status: "completed", pkid: pkRequestID)
//        ZLFireBaseManager.share.updateUserStatusToPKRequestFirebase(status: "completed", pkid: pkID)
//      
//        removeObserverForCoHostInviteList()
//        setRoomExtraInfoOnExit()
//        
//        let identifier = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
//        removeMessageObserver(id: identifier)
//        
//        NotificationCenter.default.removeObserver(self,
//                                                  name: Notification.Name("BroadTencentMessage"),
//                                                  object: nil)
//
//        quitgroup(id: groupID)
//        removeListeners()
//        
//        
//   //     let identifier = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
//        let inviteUserID = self.pkRequestHostDetail.inviteUserID ?? ""
//        removeObserver(id: inviteUserID)
//        ZegoExpressEngine.destroy(nil)
       // navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnViewAudiencePressed(_ sender: Any) {
        
        print("Button View Audience Pressed.")
        
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "JoinedAudienceListViewController") as! JoinedAudienceListViewController
        vcAudiencePresent = true
        vc.delegate = self
        vc.userInfoList = userInfoList
        
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
        sheetController.didDismiss = { _ in
                    // This is called after the sheet is dismissed
                    print("sheet band ho gayi hai audience list wali")
            self.vcAudiencePresent = false
            
                }
        
    }
    
    @IBAction func btnViewDistributionPressed(_ sender: Any) {
        
        print("Button View Distribution Pressed, in pk publish view controller.")
        
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BottomWebViewViewController") as! BottomWebViewViewController
       
        let userID = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        vc.url = "https://zeep.live/top-fans-ranking?userid=\(userID)"
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
    
    @IBAction func btnViewRewardPressed(_ sender: Any) {
        
        print("Button View Reward Pressed, in pk publish view controller.")
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
    
    @IBAction func btnViewRewardRankPressed(_ sender: Any) {
        
        print("Button View Reward Rank Pressed, in pk publish view controller.")
      
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
    
    @IBAction func btnOneoOneCallPressed(_ sender: Any) {
        
        print("Button One To One Call Pressed, in pk publish view controller.")
        
    }
    
    @IBAction func btnGiftPressed(_ sender: Any) {
        
        print("Button Gift Pressed, in pk publish view controller.")
        
    }
    
    @IBAction func btnMicPressed(_ sender: Any) {
        
        print("Button Mic Pressed, in pk publish view controller.")
        
        if isMuteMicButtonPressed
        
        {
          
            isMuteMicButtonPressed = false
          btnMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
           // ZegoExpressEngine.shared().muteSpeaker(false)
            ZegoExpressEngine.shared().muteMicrophone(false)
            
        }
        
        else {
            
            isMuteMicButtonPressed = true
          btnMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
           // ZegoExpressEngine.shared().muteSpeaker(true)
            ZegoExpressEngine.shared().muteMicrophone(true)
        }
        
    }
    
    @IBAction func btnOpenMessagePressed(_ sender: Any) {
        
        print("Button Open Message Pressed, in pk publish view controller.")
        txtFldMessage.becomeFirstResponder()
        
    }
    
    @IBAction func btnGamePressed(_ sender: Any) {
        
        print("Button Game Pressed, in pk publish view controller.")
        
    }
    
    @IBAction func viewPKFirstUserPressed(_ sender: Any) {
        
        print("View PK First User Pressed, in pk publish view controller.")
        view.endEditing(true)
        
    }
    
    @IBAction func viewPKSecondUserPressed(_ sender: Any) {
        
        print("View PK Second User Pressed, in pk publish view controller.")
        view.endEditing(true)
       
        var user = joinedGroupUserProfile()
        
        user.userID =  pkRequestHostDetail.inviteUserID ?? "0"
        user.nickName = pkRequestHostDetail.name ?? "N/A"
        user.faceURL =  pkRequestHostDetail.userImage ?? ""
        user.richLevel =  "0"
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        nextViewController.messageDetails = user
        nextViewController.delegate = self
        nextViewController.viewFrom = "message"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func viewPKSecondUserNamePressed(_ sender: Any) {
        
        print("View PK Second User Name Pressed, in pk publish view controller.")
        
        var user = joinedGroupUserProfile()
        
        user.userID =  pkRequestHostDetail.inviteUserID ?? "0"
        user.nickName = pkRequestHostDetail.name ?? "N/A"
        user.faceURL =  pkRequestHostDetail.userImage ?? ""
        user.richLevel =  "0"
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        nextViewController.messageDetails = user
        nextViewController.delegate = self
        nextViewController.viewFrom = "message"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func viewThirdUserOnMicPressed(_ sender: Any) {
        
        print("View Third User On Mic Pressed, in pk publish view controller.")
       
        if zegoMicUsersList.indices.contains(2) {
            
            currentIndexForCoHost = 2
            
            if let coHostID = zegoMicUsersList[2].coHostID,
               let coHostUserName = zegoMicUsersList[2].coHostUserName,
               let coHostUserImage = zegoMicUsersList[2].coHostUserImage {
                
                
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
        
//        if zegoMicUsersList.indices.contains(2) {
//            // Access the mic user details at the specified index
//            var user = joinedGroupUserProfile()
//            user.userID = zegoMicUsersList[2].coHostID
//            user.nickName = zegoMicUsersList[2].coHostUserName
//            user.faceURL = zegoMicUsersList[2].coHostUserImage
//            user.richLevel = zegoMicUsersList[2].coHostLevel
//
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
//            nextViewController.messageDetails = user
//            nextViewController.delegate = self
//            nextViewController.viewFrom = "message"
//            nextViewController.modalPresentationStyle = .overCurrentContext
//
//            present(nextViewController, animated: true, completion: nil)
//        } else {
//            // Handle the case where the index is out of bounds
//            print("Index out of bounds")
//        }
        
    }
    
    @IBAction func viewSecondUserOnMicPressed(_ sender: Any) {
        
        print("View Second User On Mic Pressed, in pk publish view controller.")
        
        if zegoMicUsersList.indices.contains(1) {
            
            currentIndexForCoHost = 1
            
            if let coHostID = zegoMicUsersList[1].coHostID,
               let coHostUserName = zegoMicUsersList[1].coHostUserName,
               let coHostUserImage = zegoMicUsersList[1].coHostUserImage {
                
                
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
//        if zegoMicUsersList.indices.contains(1) {
//            // Access the mic user details at the specified index
//            var user = joinedGroupUserProfile()
//            user.userID = zegoMicUsersList[1].coHostID
//            user.nickName = zegoMicUsersList[1].coHostUserName
//            user.faceURL = zegoMicUsersList[1].coHostUserImage
//            user.richLevel = zegoMicUsersList[1].coHostLevel
//
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
//            nextViewController.messageDetails = user
//            nextViewController.delegate = self
//            nextViewController.viewFrom = "message"
//            nextViewController.modalPresentationStyle = .overCurrentContext
//
//            present(nextViewController, animated: true, completion: nil)
//        } else {
//            // Handle the case where the index is out of bounds
//            print("Index out of bounds")
//        }
        
    }
    
    @IBAction func viewFirstUserOnMicPressed(_ sender: Any) {
        
        print("View First User On Mic Pressed, in pk publish view controller.")
        
        if zegoMicUsersList.indices.contains(0) {
            
            currentIndexForCoHost = 0
            
            if let coHostID = zegoMicUsersList[0].coHostID,
                let coHostUserName = zegoMicUsersList[0].coHostUserName,
                let coHostUserImage = zegoMicUsersList[0].coHostUserImage {
              
                
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
            
//            // Access the mic user details at the specified index
//            var user = joinedGroupUserProfile()
//            user.userID = zegoMicUsersList[0].coHostID
//            user.nickName = zegoMicUsersList[0].coHostUserName
//            user.faceURL = zegoMicUsersList[0].coHostUserImage
//            user.richLevel = zegoMicUsersList[0].coHostLevel
//
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
//            nextViewController.messageDetails = user
//            nextViewController.delegate = self
//            nextViewController.viewFrom = "message"
//            nextViewController.modalPresentationStyle = .overCurrentContext
//
//            present(nextViewController, animated: true, completion: nil)
        } else {
            // Handle the case where the index is out of bounds
            print("Index out of bounds")
        }
        
    }
    
    @IBAction func viewOpponentFirstUserOnMicPressed(_ sender: Any) {
        
        print("View First User Of Opponent On Mic Pressed, in pk publish view controller.")
        if zegoOpponentMicUsersList.indices.contains(0) {
            // Access the mic user details at the specified index
            var user = joinedGroupUserProfile()
            user.userID = zegoOpponentMicUsersList[0].coHostID
            user.nickName = zegoOpponentMicUsersList[0].coHostUserName
            user.faceURL = zegoOpponentMicUsersList[0].coHostUserImage
            user.richLevel = zegoOpponentMicUsersList[0].coHostLevel

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext

            present(nextViewController, animated: true, completion: nil)
        } else {
            // Handle the case where the index is out of bounds
            print("Index out of bounds")
        }
         
    }
    
    @IBAction func viewOpponentSecondUserOnMicPressed(_ sender: Any) {
        
        print("View Second User Of Opponent On Mic Pressed, in pk publish view controller.")
        
        if zegoOpponentMicUsersList.indices.contains(1) {
            // Access the mic user details at the specified index
            var user = joinedGroupUserProfile()
            user.userID = zegoOpponentMicUsersList[1].coHostID
            user.nickName = zegoOpponentMicUsersList[1].coHostUserName
            user.faceURL = zegoOpponentMicUsersList[1].coHostUserImage
            user.richLevel = zegoOpponentMicUsersList[1].coHostLevel

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext

            present(nextViewController, animated: true, completion: nil)
        } else {
            // Handle the case where the index is out of bounds
            print("Index out of bounds")
        }
        
    }
    
    @IBAction func viewOpponentThirdUserOnMicPressed(_ sender: Any) {
        
        print("View Third User Of Opponent On Mic Pressed, in pk publish view controller.")
        
        if zegoOpponentMicUsersList.indices.contains(2) {
            // Access the mic user details at the specified index
            var user = joinedGroupUserProfile()
            user.userID = zegoOpponentMicUsersList[2].coHostID
            user.nickName = zegoOpponentMicUsersList[2].coHostUserName
            user.faceURL = zegoOpponentMicUsersList[2].coHostUserImage
            user.richLevel = zegoOpponentMicUsersList[2].coHostLevel

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext

            present(nextViewController, animated: true, completion: nil)
        } else {
            // Handle the case where the index is out of bounds
            print("Index out of bounds")
        }
        
    }
    
    @IBAction func btnGiftUserThreePressed(_ sender: Any) {
        
        print("Button Gift User Three Pressed , for more details of user in pk publish view controller.")
       
        if (giftThirdUserID == 0) {
            print("Koi user nahi hai gift wale par. To popup nahi dikhana hai")
        } else {
            var user = joinedGroupUserProfile()
            
            user.userID = String(giftThirdUserID)
            user.nickName = giftThirdUserName
            user.faceURL = giftThirdUserImage
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnGiftUserTwoPressed(_ sender: Any) {
        
        print("Button Gift User Two Pressed, for more details of user in pk publish view controller.")
        
        if (giftSecondUserID == 0) {
            print("Koi user nahi hai gift wale par. To popup nahi dikhana hai")
        } else {
            var user = joinedGroupUserProfile()
            
            user.userID = String(giftSecondUserID)
            user.nickName = giftSecondUserName
            user.faceURL = giftSecondUserImage
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"

            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnGiftUserOnePressed(_ sender: Any) {
        
        print("Button Gift User One Pressed, for more details of user in pk publish view controller.")
        
        if (giftFirstUserID == 0) {
            print("Koi user nahi hai gift wale par. To popup nahi dikhana hai")
        } else {
            var user = joinedGroupUserProfile()
            
            user.userID = String(giftFirstUserID)
            user.nickName = giftFirstUserName
            user.faceURL = giftFirstUserImage
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnGiftOpponentUserOnePressed(_ sender: Any) {
        
        print("Button Gift Opponent User One pressed, in pk publish view controller.")
      
        if (giftOpponentFirstUserID == 0) {
            print("Koi user nahi hai gift wale par. To popup nahi dikhana hai")
        } else {
            var user = joinedGroupUserProfile()
            
            user.userID = String(giftOpponentFirstUsername)
            user.nickName = giftOpponentFirstUsername
            user.faceURL = giftOpponentFirstUserImage
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnGiftOpponentUserTwoPressed(_ sender: Any) {
        
        print("Button Gift Opponent User Two pressed, in pk publish view controller.")
      
        if (giftOpponentSecondUserID == 0) {
            print("Koi user nahi hai gift wale par. To popup nahi dikhana hai")
        } else {
            var user = joinedGroupUserProfile()
            
            user.userID = String(giftOpponentSecondUserID)
            user.nickName = giftOpponentSecondUsername
            user.faceURL = giftOpponentSecondUserImage
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnGiftOpponentUserThreePressed(_ sender: Any) {
        
        print("Button Gift Opponent User Three pressed, in pk publish view controller.")
        
        if (giftOpponentThirdUserID == 0) {
            print("Koi user nahi hai gift wale par. To popup nahi dikhana hai")
        } else {
            var user = joinedGroupUserProfile()
            
            user.userID = String(giftOpponentThirdUserID)
            user.nickName = giftOpponentThirdUsername
            user.faceURL = giftOpponentThirdUserImage
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnSendMessagePressed(_ sender: Any) {
        
        print("Button Send Message Pressed.")
        if (txtFldMessage.text == "") || (txtFldMessage.text == nil) {
            print("Firebase par message post nahi karenge.")
        } else {
            print("Firebase par message post kar denge")
            
            let replacedString = replaceNumbersWithAsterisks(txtFldMessage.text ?? "")
                print(replacedString)
            
            sendMessage(message: replacedString)
            sendMessageToSecondGroup(message: replacedString)
            txtFldMessage.resignFirstResponder()
        }
        
    }
    
    func userData(selectedUserIndex: Int) {
        print("THe selected userindex in the joineduser list is: \(selectedUserIndex)")
        
                if let sheetController = sheetController {
                        sheetController.animateOut()
                        sheetController.dismiss(animated: true)
                    }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        if let selectedUser = userInfoList?[selectedUserIndex] {
            nextViewController.broadGroupJoinuser = selectedUser
        } else {
            // Handle the case where userInfoList or the selected user is nil
        }

        nextViewController.delegate = self
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
        
    }
    
    deinit {
        
        print("Deinit call hua hai pk publish view controller main.")
      
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("BroadTencentMessage"),
                                                  object: nil)

        removeMessagesOnFirebase()
        ZegoExpressEngine.destroy(nil)
        removeLottieAnimationViews()
      //  removePKRequestOnFirebase()
      //  removePKRequestDetailsOnFirebase()
        removeListeners()
        removeCoHostInviteListOnFirebase()
        removeCoHostInviteDetailsOnFirebase()
        removeObserverForCoHostInviteList()
        
    }
    
}

extension PKPublishViewController {
    
    func startTimer() {

        pktimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
    //    btnResendOtpOutlet.setTitle(NSLocalizedString("Resend : \(timeFormatted(totalTime))", comment: ""), for: .normal)
        lblTimerCount.text = (timeFormatted(totalTime))
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
//    User ko mute krne wala kaam krna hai.
//    ID does not exist in zegoSendMicUsersList
    
    func endTimer() {
        
        pktimer.invalidate()
        lblTimerCount.text = "00:00"
        
    }
    
    func leaveMicPressed(isPressed: Bool) {
        print("Button to remove user for remove from join mic pressed by the host.")
        removeLiveAsCoHost(userid: zegoMicUsersList[currentIndexForCoHost].coHostID ?? "")
        stopPlayingCoHostStream(userid: zegoMicUsersList[currentIndexForCoHost].coHostID ?? "")
        zegoMicUsersList.remove(at: currentIndexForCoHost)
       // tblViewMicJoinedUsers.reloadData()
        
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
    
    func stopPlayingCoHostStream(userid:String) {
        
        let config = ZegoPublisherConfig()
        config.roomID = channelName // Assuming channelName is a valid variable accessible in this scope

        let streamID = channelName + userid + "_cohost_stream"
        print("THe stream id we are passing in case of joining mic in live is: \(streamID)")
        
        // Assuming expressObject is an instance of ZegoExpressEngine
        ZegoExpressEngine.shared().stopPlayingStream(streamID)
        
    }
    
    func removeLiveAsCoHost(userid: String) {
    
        print("The zego send mic users list in removeliveascohost in pk publish controller is: \(zegoSendMicUsersList)")
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
                       
                        print("The data count in zegomic user list before removing is: \(self.zegoMicUsersList.count)")
                        self.zegoMicUsersList.removeAll { $0.coHostID == userid }
                        print("The data count in zegomic user list after removing is: \(self.zegoMicUsersList.count)")
                        
                        self.usersOnMic(data: self.zegoMicUsersList)
                        
                    } else {
                        print("Message abhi group mai shi se nahi gya hai room extra info wala.")
                    }
                })
             
           } else {
               print("ID does not exist in zegoSendMicUsersList")
           }
        print("The changed zegosendmicuserslist are: \(zegoSendMicUsersList)")
        
    }
    
//    func muteLiveCoHost(userid: String, value: String) {
//        print("The id we are getting in mute/unmute function for unmute is: \(userid)")
//        
//        print("The zegosendmic users list is: \(zegoSendMicUsersList)")
//        if zegoSendMicUsersList.contains(where: { $0.key == userid }) {
//            print("ID exists in zegoSendMicUsersList")
//            
//            if let jsonString = zegoSendMicUsersList[userid],
//               let data = jsonString.data(using: .utf8),
//               var jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                
//                // Access and modify the data inside the JSON object
//                if let coHostUserStatus = jsonObject["coHostAudioStatus"] as? String {
//                    print("Original coHostAudioStatus: \(coHostUserStatus)")
//                    jsonObject["coHostAudioStatus"] = value//"mute"  // Update the value of "coHostUserStatus"
//                    if (value.lowercased() == "mute") {
//                        jsonObject["isHostMuted"] = "true"
//                    } else {
//                        jsonObject["isHostMuted"] = "false"
//                    }
//                } else {
//                    print("coHostUserStatus not found in JSON object")
//                    jsonObject["coHostAudioStatus"] = value//"mute"
//                    if (value.lowercased() == "mute") {
//                        jsonObject["isHostMuted"] = "true"
//                    } else {
//                        jsonObject["isHostMuted"] = "false"
//                    }
//                }
//                
////                // Access and modify the data inside the JSON object
////                if let coHostAudioStatus = jsonObject["coHostAudioStatus"] as? String? {
////                    print("Original coHostAudioStatus: \(coHostAudioStatus ?? "")")
////                    jsonObject["coHostAudioStatus"] = value
//                    
//                    // Convert the updated JSON object back to a string
//                    if let updatedJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
//                       let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
//                        
//                        // Update the value in zegoSendMicUsersList with the updated JSON string
//                        zegoSendMicUsersList[userid] = updatedJsonString
//                        print("Updated User Data: \(updatedJsonString)")
//                    } else {
//                        print("Error converting JSON object to string")
//                    }
////                } else {
////                    print("coHostAudioStatus not found in JSON object")
////                }
//            } else {
//                print("User ID \(userid) not found in zegoSendMicUsersList or data is not a valid JSON string")
//            }
//            
//            // Prepare the map
//            let coHostInfoStr = jsonString(from: zegoSendMicUsersList)
//            let map: [String: String] = ["coHost123": coHostInfoStr]
//            
//            // Prepare the final JSON
//            let pkHostMap: [String: Any] = [
//                "pkHost": map
//            ]
//            
//            // Convert pkHostMap to JSON string
//            let infoStr = jsonString(from: pkHostMap)
//            
//            // Set room extra info using the SDK
//            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr, forKey: "SYC_USER_INFO", roomID: channelName) { errorCode in
//                print(errorCode)
//                print(errorCode.description)
//                if errorCode == 0 {
//                    print("Successfully sent extra room info.")
//                } else {
//                    print("Failed to send extra room info.")
//                }
//            }
//        }
//        
//        print("The changed zegoSendMicUsersList are: \(zegoSendMicUsersList)")
//    }
    
//    func muteLiveCoHost(userid: String,value:String) {
//    
//    
//        print("The id we are geting in mute/unmute function for unmute is: \(userid)")
//        
//        if zegoSendMicUsersList.contains(where: { $0.key == userid }) {
//               print("ID exists in zegoSendMicUsersList")
//          //  zegoSendMicUsersList["coHostUserStatus"] = "delete"
//            if let jsonString = zegoSendMicUsersList[userid],
//                let data = jsonString.data(using: .utf8),
//                var jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                
//                // Access and modify the data inside the JSON object
//                if let coHostUserStatus = jsonObject["coHostAudioStatus"] as? String? {
//                    print("Original coHostAudioStatus: \(coHostUserStatus)")
//                    jsonObject["coHostAudioStatus"] = value//"mute"  // Update the value of "coHostUserStatus"
//                    
//                    // Convert the updated JSON object back to a string
//                    if let updatedJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
//                        let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
//                        
//                        // Update the value in zegoSendMicUsersList with the updated JSON string
//                        zegoSendMicUsersList[userid] = updatedJsonString
//                        print("Updated User Data: \(updatedJsonString)")
//                    } else {
//                        print("Error converting JSON object to string")
//                    }
//                } else {
//                    print("coHostUserStatus not found in JSON object")
//                }
//            } else {
//                print("User ID \(userid) not found in zegoSendMicUsersList or data is not a valid JSON string")
//            }
//            
//            var infoStr1 = ""
//            var type = ""
//                // Convert mainCoHostList to JSON string
//                infoStr1 = jsonString(from: zegoSendMicUsersList)
//                type = "coHost123"
//            
//            
//            // Create a map with type as key and infoStr1 as value
//            var map: [String: String] = [:]
//            map[type] = infoStr1
//          
//            // Convert map to JSON string
//            let infoStr2 = jsonString(from: map)
//           
//            // Set room extra info using the SDK
//            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in
//
//                    print(errorCode)
//                    print(errorCode.description)
//                    if errorCode == 0 {
//                     print("Successfully mute wala message bhej dia hai extra room info wale main.")
//                    } else {
//                        print("Message abhi group mai shi se nahi gya hai room extra info wala.")
//                    }
//                })
//             
//           } else {
//               print("ID does not exist in zegoSendMicUsersList")
//           }
//        print("The changed zegosendmicuserslist are: \(zegoSendMicUsersList)")
//        
//    }
    
    // Function to convert an object to a JSON string
    func jsonString(from object: Any) -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: object, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }
    
}

extension PKPublishViewController {

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
                print("The response we are getting from Firebase in CoHost InviteList in PK Publish View Controller is:\(value)")
                
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
    
    func addObserve(id:String?) {
        
//        guard let currentUserProfileID = id else {    // usersList.data?[currentIndex].profileID
//            // Handle the case where currentUserProfileID is nil
//            return
//        }
       
        guard let currentUserProfileID = id, !currentUserProfileID.isEmpty else {
            // Handle the case where currentUserProfileID is nil or empty
            print("Invalid or empty user profile ID")
            return
        }

        
        print("The profile id for observe is: \(currentUserProfileID)")
        let userStatusRef = ZLFireBaseManager.share.userRef.child("UserStatus").child(currentUserProfileID)
        
        userStatusHandle = userStatusRef.observe(.value) { [weak self] (snapshot, error) in
            guard let self = self else {
                // Ensure self is still valid
                return
            }
            
            if let error = error {
                // Handle the error, if any
                print("Firebase observe error: \(error)")
                return
            }
            
            btnCloseBroadOutlet.isUserInteractionEnabled = true
            
            // Handle the updated data here
            if let value = snapshot.value as? [String: Any] {
                print("The response we are getting from Firebase is:The response we are getting from Firebase is:\(value)")
                
                let callRate = value["callRate"] as? String
                let name = value["name"] as? String
                let pid = value["pid"] as? String
                let newVersionPK = value["newVersionPK"] as? Bool
                let channelName = value["channelName"] as? String
                let uid = value["uid"] as? String
                let profilePic = value["profilePic"] as? String
                let fcmToken = value["fcmToken"] as? String
                let level = value["level"] as? Int
                let newCallRate = value["new_call_rate"] as? String
                let star = value["star"] as? String
                let count = value["count"] as? Int
                let gender = value["gender"] as? String
                let status = value["status"] as? String
                let imGroupId = value["imGroupId"] as? String
                let weeklyPoints = value["weeklyPoints"] as? String
                let channaleName = value["channaleName"] as? String
                 
                 print("Call Rate: \(callRate)")
                 print("Name: \(name)")
                 print("PID: \(pid)")
                 print("New Version PK: \(newVersionPK)")
                 print("Channel Name: \(channelName)")
                 print("UID: \(uid)")
                 print("Profile Pic: \(profilePic)")
                 print("FCM Token: \(fcmToken)")
                 print("Level: \(level)")
                 print("New Call Rate: \(newCallRate)")
                 print("Star: \(star)")
                 print("Count: \(count)")	
                 print("Gender: \(gender)")
                 print("Status: \(status)")
                 print("IM Group ID: \(imGroupId)")
                 print("Weekly Points: \(weeklyPoints)")
                 print("Channel Name: \(channaleName)")
                
             //   updateStatusToFirebaseForPK(data: value)
                secondGroupID = (imGroupId ?? "")
                print("The second group id is: \(secondGroupID)")
                
                if !self.hasUpdatedStatus {
                    self.updateStatusSecondHostToFirebaseForPK(data: value)
                    self.updateStatusToFirebaseForPK(data: value)
                    self.hasUpdatedStatus = true
                }
                
                if let status = value["status"] as? String {
                    print("The status coming from the firebase is: \(status)")
                        
                    if (status.lowercased() == "live") {
                        
                        print("User ke khud ka status live hai pk publish view controller main.")
                            
                        if (isFirstTime == true) {
                            
                            print("Pehli baar hai.")
                            isFirstTime = false
                            
                        } else {
                            
                            endLiveBroadcast()
                            dismiss(animated: true, completion: nil)
                            setRoomExtraInfoOnExit()
                            let identifier = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                            removeMessageObserver(id: identifier)
                            
                            NotificationCenter.default.removeObserver(self,
                                                                      name: Notification.Name("BroadTencentMessage"),
                                                                      object: nil)
                            
                            quitgroup(id: groupID)
                            removeListeners()
                            removeObserverForCoHostInviteList()
                            //  let identifier = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                            removeObserver(id: id)
                            ZegoExpressEngine.destroy(nil)
                            navigationController?.popViewController(animated: true)
                            
                        }
                        
                        
                    } else if (status.lowercased() == "pk") {
                        
                        print("User ke khud ka status pk hai pk publish view controller main.")
                        // Check if the updateStatusToFirebaseForPK function has already been called
                        
                        isFirstTime = false
                       
                        
                        
                        if let pkMyGiftCoin = value["pk_opponent_gift_coins"]  as? Int {
                            
                            print("The gift Coin that we are getting is: \(pkMyGiftCoin)")
                            myGiftCoins = pkMyGiftCoin
                            pkUserTotalGiftCoins = pkMyGiftCoin
                            // cell.updateBottomBar()
                            
                        }
                        
                        if let pkOpponentGiftCoin = value["pk_myside_gift_coins"] as? Int {
                            
                            print("The gift Coin that opponent are getting is: \(pkOpponentGiftCoin)")
                            opponentGiftCoins = pkOpponentGiftCoin
                            pkUserOpponentTotalGiftCoins = pkOpponentGiftCoin
                            
                            //  cell.updateBottomBar()
                        
                        }
                        
                        print("Pk Publish main bar update karne wale par aaya hai")
                        updateBottomBarStack()
                        
                        if let pkMySideGiftedUsers = value["pk_opponent_side_gifted_users"] as? [String: Any] {
                            // User1
                            if let user1 = pkMySideGiftedUsers["User1"] as? [String: Any] {
                                let totalGift1 = user1["totalGift"] as? Int ?? 0
                                let type1 = user1["type"] as? Int ?? 0
                                let userID1 = user1["userID"] as? Int ?? 0
                                let userImage1 = user1["userImage"] as? String ?? ""
                                let userName1 = user1["userName"] as? String ?? ""
                                
                                // Use user1 data as needed
                                print("User1:")
                                print("Total Gift: \(totalGift1)")
                                print("Type: \(type1)")
                                print("User ID: \(userID1)")
                                print("User Image URL: \(userImage1)")
                                print("User Name: \(userName1)")
                                if (userID1 == 0) {
                                    print("pehle gift par koi user nahi hai.")
                                    mySideGiftUser(fromUser: "1", userImage: "", userID: userID1, userName: "")
                                    pkUserGiftDetail.userID = userID1
                                    pkUserGiftDetail.userName = userName1
                                    pkUserGiftDetail.userImage = userImage1
                                    pkUserGiftDetail.type = type1
                                    pkGiftList.insert(pkUserGiftDetail, at: 0)
                                } else {
                                    print("Pehle gift mai user hai.")
                                    mySideGiftUser(fromUser: "1", userImage: userImage1, userID: userID1, userName: userName1)
                                    pkUserGiftDetail.userID = userID1
                                    pkUserGiftDetail.userName = userName1
                                    pkUserGiftDetail.userImage = userImage1
                                    pkUserGiftDetail.type = type1
                                    pkGiftList.insert(pkUserGiftDetail, at: 0)
                                   // pkGiftList.append(pkUserGiftDetail)
                                    
                                }
                            }
                            
                            // User2
                            if let user2 = pkMySideGiftedUsers["User2"] as? [String: Any] {
                                let totalGift2 = user2["totalGift"] as? Int ?? 0
                                let type2 = user2["type"] as? Int ?? 0
                                let userID2 = user2["userID"] as? Int ?? 0
                                let userImage2 = user2["userImage"] as? String ?? ""
                                let userName2 = user2["userName"] as? String ?? ""
                                
                                // Use user2 data as needed
                                print("User2:")
                                print("Total Gift: \(totalGift2)")
                                print("Type: \(type2)")
                                print("User ID: \(userID2)")
                                print("User Image URL: \(userImage2)")
                                print("User Name: \(userName2)")
                                if (userID2 == 0) {
                                    print("Doosre gift par koi nahi hai")
                                    mySideGiftUser(fromUser: "2", userImage: "", userID: userID2, userName: "")
                                    pkUserGiftDetail.userID = userID2
                                    pkUserGiftDetail.userName = userName2
                                    pkUserGiftDetail.userImage = userImage2
                                    pkUserGiftDetail.type = type2
                                    pkGiftList.insert(pkUserGiftDetail, at: 1)
                                    
                                } else {
                                    print("Doosre gift par koi hai")
                                    mySideGiftUser(fromUser: "2", userImage: userImage2, userID: userID2, userName: userName2)
                                    pkUserGiftDetail.userID = userID2
                                    pkUserGiftDetail.userName = userName2
                                    pkUserGiftDetail.userImage = userImage2
                                    pkUserGiftDetail.type = type2
                                    pkGiftList.insert(pkUserGiftDetail, at: 1)
                                    
                                }
                            }
                            
                            // User3
                            if let user3 = pkMySideGiftedUsers["User3"] as? [String: Any] {
                                let totalGift3 = user3["totalGift"] as? Int ?? 0
                                let type3 = user3["type"] as? Int ?? 0
                                let userID3 = user3["userID"] as? Int ?? 0
                                let userImage3 = user3["userImage"] as? String ?? ""
                                let userName3 = user3["userName"] as? String ?? ""
                                
                                // Use user3 data as needed
                                print("User3:")
                                print("Total Gift: \(totalGift3)")
                                print("Type: \(type3)")
                                print("User ID: \(userID3)")
                                print("User Image URL: \(userImage3)")
                                print("User Name: \(userName3)")
                                if (userID3 == 0) {
                                    print("Teesre gift par koi nahi hai.")
                                    mySideGiftUser(fromUser: "3", userImage: "", userID: userID3, userName: "")
                                    pkUserGiftDetail.userID = userID3
                                    pkUserGiftDetail.userName = userName3
                                    pkUserGiftDetail.userImage = userImage3
                                    pkUserGiftDetail.type = type3
                                    pkGiftList.insert(pkUserGiftDetail, at: 2)
                                    
                                } else {
                                    print("Teesre gift par koi user hai")
                                    mySideGiftUser(fromUser: "3", userImage: userImage3, userID: userID3, userName: userName3)
                                    pkUserGiftDetail.userID = userID3
                                    pkUserGiftDetail.userName = userName3
                                    pkUserGiftDetail.userImage = userImage3
                                    pkUserGiftDetail.type = type3
                                    pkGiftList.insert(pkUserGiftDetail, at: 2)
                                    
                                }
                            }
                            print("The pk gift model before sorting is: \(pkGiftList)")
                            pkGiftList.sort { $0.totalGift ?? 0 > $1.totalGift ?? 0 }
                            print("The pk gift list model after sorting is: \(pkGiftList)")
                        }
                        
                        
                        
                        if let pkOpponentSideGiftedUsers = value["pk_my_side_gifted_users"]  as? [String: Any] {
                            // User1
                            if let user1 = pkOpponentSideGiftedUsers["User1"] as? [String: Any] {
                                let totalGift1 = user1["totalGift"] as? Int ?? 0
                                let type1 = user1["type"] as? Int ?? 0
                                let userID1 = user1["userID"] as? Int ?? 0
                                let userImage1 = user1["userImage"] as? String ?? ""
                                let userName1 = user1["userName"] as? String ?? ""
                                
                                // Use user1 data as needed
                                print("Opponent User1:")
                                print("Opponent Total Gift: \(totalGift1)")
                                print("Opponent Type: \(type1)")
                                print("Opponent User ID: \(userID1)")
                                print("Opponent User Image URL: \(userImage1)")
                                print("Opponent User Name: \(userName1)")
                                if (userID1 == 0) {
                                    print("Opponent ke pehle gift par koi nahi hai")
                                    opponentSideGiftUser(fromUser: "1", userImage: "", userID: userID1, userName: "")
                                    pkUserGiftDetail.userID = userID1
                                    pkUserGiftDetail.userName = userName1
                                    pkUserGiftDetail.userImage = userImage1
                                    pkUserGiftDetail.type = type1
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 0)
                                    
                                } else {
                                    print("Opponent ke pehle gift par user hai")
                                    opponentSideGiftUser(fromUser: "1", userImage: userImage1, userID: userID1, userName: userName1)
                                    pkUserGiftDetail.userID = userID1
                                    pkUserGiftDetail.userName = userName1
                                    pkUserGiftDetail.userImage = userImage1
                                    pkUserGiftDetail.type = type1
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 0)
                                    
                                }
                            }
                            
                            // User2
                            if let user2 = pkOpponentSideGiftedUsers["User2"] as? [String: Any] {
                                let totalGift2 = user2["totalGift"] as? Int ?? 0
                                let type2 = user2["type"] as? Int ?? 0
                                let userID2 = user2["userID"] as? Int ?? 0
                                let userImage2 = user2["userImage"] as? String ?? ""
                                let userName2 = user2["userName"] as? String ?? ""
                                
                                // Use user2 data as needed
                                print("Opponent User2:")
                                print("Opponent Total Gift: \(totalGift2)")
                                print("Opponent Type: \(type2)")
                                print("Opponent User ID: \(userID2)")
                                print("Opponent User Image URL: \(userImage2)")
                                print("Opponent User Name: \(userName2)")
                                if (userID2 == 0) {
                                    print("Opponent ke doosre gift par koi nahi hai")
                                    opponentSideGiftUser(fromUser: "2", userImage: "", userID: userID2, userName: "")
                                    pkUserGiftDetail.userID = userID2
                                    pkUserGiftDetail.userName = userName2
                                    pkUserGiftDetail.userImage = userImage2
                                    pkUserGiftDetail.type = type2
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 1)
                                    
                                } else {
                                    print("Opponent ke doosre gift par user hai.")
                                    opponentSideGiftUser(fromUser: "2", userImage: userImage2, userID: userID2, userName: userName2)
                                    pkUserGiftDetail.userID = userID2
                                    pkUserGiftDetail.userName = userName2
                                    pkUserGiftDetail.userImage = userImage2
                                    pkUserGiftDetail.type = type2
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 1)
                                    
                                }
                            }
                            
                            // User3
                            if let user3 = pkOpponentSideGiftedUsers["User3"] as? [String: Any] {
                                let totalGift3 = user3["totalGift"] as? Int ?? 0
                                let type3 = user3["type"] as? Int ?? 0
                                let userID3 = user3["userID"] as? Int ?? 0
                                let userImage3 = user3["userImage"] as? String ?? ""
                                let userName3 = user3["userName"] as? String ?? ""
                                
                                // Use user3 data as needed
                                print("Opponent User3:")
                                print("Opponent Total Gift: \(totalGift3)")
                                print("Opponent Type: \(type3)")
                                print("Opponent User ID: \(userID3)")
                                print("Opponent User Image URL: \(userImage3)")
                                print("Opponent User Name: \(userName3)")
                                if (userID3 == 0) {
                                    print("Opponent ke teesre gift par koi nahi hai")
                                    opponentSideGiftUser(fromUser: "3", userImage: "", userID: userID3, userName: "")
                                    pkUserGiftDetail.userID = userID3
                                    pkUserGiftDetail.userName = userName3
                                    pkUserGiftDetail.userImage = userImage3
                                    pkUserGiftDetail.type = type3
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 2)
                                    
                                } else {
                                    print("Opponent ke teesre gift par user hai.")
                                    opponentSideGiftUser(fromUser: "3", userImage: userImage3, userID: userID3, userName: userName3)
                                    pkUserGiftDetail.userID = userID3
                                    pkUserGiftDetail.userName = userName3
                                    pkUserGiftDetail.userImage = userImage3
                                    pkUserGiftDetail.type = type3
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 2)
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    func removeObserver(id:String?) {
        guard let userStatusHandle = userStatusHandle else {
            // Handle the case where the observer handle is nil
            return
        }
        
//        guard let currentUserProfileID = id else {  // usersList.data?[previousIndex].profileID
//            // Handle the case where currentUserProfileID is nil
//            return
//        }
        
        guard let currentUserProfileID = id, !currentUserProfileID.isEmpty else {
            // Handle the case where currentUserProfileID is nil or empty
            print("Invalid or empty user profile ID")
            return
        }

        
        let userStatusRef = ZLFireBaseManager.share.userRef.child("UserStatus").child(currentUserProfileID)
        userStatusRef.removeObserver(withHandle: userStatusHandle)
        
    }
    
}

// MARK: - EXTENSION FOR RECIEVING TENCENT MESSAGE TO SHOW MESSAGES AND GIFTS SENT BY THE USER

extension PKPublishViewController {

    func sendMessageToSecondGroup(message:String) {
    
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
        
        print("The group id for sending message is: \(secondGroupID)")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                V2TIMManager.sharedInstance().sendGroupTextMessage(
                    jsonString,
                    to: secondGroupID,
                    priority: V2TIMMessagePriority(rawValue: 1)!,
                    succ: {
                        // Success closure
                        print("Message sent successfully in pk publish view controller for second user.")
//                        self.addMessage(message: message)
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
                        print("Message sent successfully in pk publish view controller.")
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
                    lblSendGiftHostName.text = liveMessage.sendGiftTo ?? ""
                    
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
    
    // MARK - Function to add message observer to listen for messages and gifts from firebase
      
      func addMessageObserver(id:String = "0") {
          
          print("The profile id message for observe is: \(id)")
          
          let userMessageRef = ZLFireBaseManager.share.messageRef.child("message").child(id).queryLimited(toLast: 1)
          
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
                          lblSendGiftHostName.text = liveMessage.sendGiftTo ?? ""
                          
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
    
    func updateStatusToFirebaseForPK(data: [String:Any]) {
    
        // Get the current date
        let currentDate = Date()

        // Add 4 minutes to the current date
         let newDate = Calendar.current.date(byAdding: .minute, value: 4, to: currentDate)
            // Convert the new date to milliseconds since the Unix epoch
        let milliseconds = Int((newDate?.timeIntervalSince1970 ?? 0.0) * 1000)
            
            print("Current Global Time + 4 Minutes in milliseconds: \(milliseconds)")
        
        let currentTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        print(currentTimestampInMilliseconds)
        
        let callRate = data["callRate"] as? String
        let name = data["name"] as? String
        let pid = data["pid"] as? String
        let newVersionPK = data["newVersionPK"] as? Bool
        let channelName = data["channelName"] as? String
        let uid = data["uid"] as? String
        let profilePic = data["profilePic"] as? String
        let fcmToken = data["fcmToken"] as? String
        let level = data["level"] as? String
        let newCallRate = data["new_call_rate"] as? String
        let star = data["star"] as? String
        let count = data["count"] as? Int
        let genderOpponent = data["gender"] as? String
        let status = data["status"] as? String
        let imGroupId = data["imGroupId"] as? String
        let weeklyPoints = data["weeklyPoints"] as? String
        let channaleName = data["channaleName"] as? String
        
        var result = String()
        
        let gender = UserDefaults.standard.string(forKey: "gender")
        if (gender?.lowercased() == "male") {
            
            result = "1"
            
        } else {
            
            result = "0"
            
        }
        
        let pkData: [String: Any] = [
            "broadId": "null",
            "callRate": (UserDefaults.standard.string(forKey: "callrate") ?? "1"),
            "channaleName": self.channelName, //"Zeeplive854249056",
            "count": 0,
            "fcmToken": (UserDefaults.standard.string(forKey: "Firebasetoken") ?? "") ,
            "gender": result,
            "host1_groupid": groupID, //"@TGS#aHNRUBUSY",
            "host2_groupid": imGroupId ,//"@TGS#aAFWUBUSO",
            "host_streak_count": 0,
            "imGroupId": groupID, //"@TGS#aHNRUBUSY",
            "level": (UserDefaults.standard.string(forKey: "level") ?? ""),
            "name": (UserDefaults.standard.string(forKey: "UserName") ?? ""),
            "newVersionPK": true,
            "new_call_rate": (UserDefaults.standard.string(forKey: "newcallrate") ?? "1"),
            "pid": (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""),
            "pk_current_id": pkID,//(UserDefaults.standard.string(forKey: "UserProfileId") ?? "") + String(currentTimestampInMilliseconds), //"1791877611721037574652",
            "pk_end_time": milliseconds, //1721037917000,
            "pk_my_side_gifted_users": [
                "User1": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ],
                "User2": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ],
                "User3": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ]
            ],
            "pk_myside_gift_coins": 0,
            "pk_opponent_gift_coins": 0,
            "pk_opponent_side_gifted_users": [
                "User1": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ],
                "User2": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ],
                "User3": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ]
            ],
            "pk_opponent_user_detail": [
                "age": "24",
                "call_rate": "1",
                "coins": "0",
                "language": "Hindi",
                "level": level,//"12",
                "location": "India",
                "status": "PK",
                "user_id": pid,//"179187761",
                "user_image": profilePic,//"https://zeeplivesg.oss-ap-southeast-1.aliyuncs.com/zeepliveProfileImages/2024/07/14/1720944399.webp",
                "user_name": name,//"lazy🦋",
                "user_uid": uid//"34854940"
            ],
            "pk_opponent_userid": pid,//"179187761",
            "profilePic": (UserDefaults.standard.string(forKey: "profilePicture") ?? ""),
            "remote_streak_count": 0,
            "star": "0",
            "status": "PK",
            "uid": (UserDefaults.standard.string(forKey: "userId") ?? "0"),
            "weeklyPoints": (UserDefaults.standard.string(forKey: "weeklyearning") ?? "")
        ]

//        let pkID = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "") + String(currentTimestampInMilliseconds)
//        
//        pkRequestID = pkID
//        print("The PK Request id is: \(pkRequestID)")
        
        ZLFireBaseManager.share.writeDataToFirebase(data: pkData)
        updateStatusToPkRequest(data: data, pkstatus: "accept") // status was idle changed to accepted on 22 August
        
      //  ZLFireBaseManager.share.writeDataToPKFirebase(data: pkData, pkid: pkID)
        
    }
    
    func updateStatusToPkRequest(data: [String:Any], pkstatus:String = "idle") {
    
        let currentTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        print(currentTimestampInMilliseconds)
        
        let callRate = data["callRate"] as? String
        let name = data["name"] as? String
        let pid = data["pid"] as? String
        let newVersionPK = data["newVersionPK"] as? Bool
        let channelName = data["channelName"] as? String
        let uid = data["uid"] as? String
        let profilePic = data["profilePic"] as? String
        let fcmToken = data["fcmToken"] as? String
        let level = data["level"] as? String
        let newCallRate = data["new_call_rate"] as? String
        let star = data["star"] as? String
        let count = data["count"] as? Int
        let genderOpponent = data["gender"] as? String
        let status = data["status"] as? String
        let imGroupId = data["imGroupId"] as? String
        let weeklyPoints = data["weeklyPoints"] as? String
        let channaleName = data["channaleName"] as? String
        
        var result = String()
        
        let gender = UserDefaults.standard.string(forKey: "gender")
        if (gender?.lowercased() == "male") {
            
            result = "1"
            
        } else {
            
            result = "0"
            
        }
        
        // Define the data you want to update
        let pkRequestData: [String: Any] = [
            "group_idim": groupID , //"@TGS#aS6XWBUST",
            "host1": (UserDefaults.standard.string(forKey: "userId") ?? "0") , //"117911369",
            "host1_user_details": [
                "age": "24",
                "call_rate": (UserDefaults.standard.string(forKey: "callrate") ?? "1") , //"1",
                "coins": "0" ,//"7",
                "language": "Hindi",
                "level": (UserDefaults.standard.string(forKey: "level") ?? "") ,//"17",
                "location": "India",
                "status": "PK",
                "user_id": (UserDefaults.standard.string(forKey: "userId") ?? "0") , //"117911369",
                "user_image": (UserDefaults.standard.string(forKey: "profilePicture") ?? "") ,
                "user_name": (UserDefaults.standard.string(forKey: "UserName") ?? "") ,//"REDWINE",
                "user_uid": (UserDefaults.standard.string(forKey: "UserProfileId") ?? "") //"36509554"
               // "group_id": groupID // added on 28 august for checking purpose.
            ],
            "host1_username": (UserDefaults.standard.string(forKey: "UserName") ?? "") ,//"REDWINE",
            "host1_userpic": (UserDefaults.standard.string(forKey: "profilePicture") ?? ""),
            "host2": pid,//uid,//"410515416",
            "host2_user_details": [
                "age": "24" ,//"01-01-2000",
                "call_rate": callRate ,//"1",
                "coins": "",
                "group_id": imGroupId ,//"@TGS#a5I4YBUSF",
                "language": "Hindi",
                "level": level , //"5",
                "location": "India",
                "status": "PK",
                "user_id": pid,//uid ,//"410515416",
                "user_image": profilePic ,
                "user_name": name ,//"Dua Rajpoot",
                "user_uid": uid//pid //"38922156"
            ],
            "host2_username": name ,//"Dua Rajpoot",
            "host2_userpic": profilePic ,
            "invite": "true",
          //  "result": "",
            "status": pkstatus//"accept"
        ]
        
        print("The pk request data is: \(pkRequestData)")
//        ZLFireBaseManager.share.writeDataToPKFirebase(data: pkRequestData, pkid: pkRequestID)
        ZLFireBaseManager.share.writeDataToPKFirebase(data: pkRequestData, pkid: pkID)
        
    }
    
    func removeMessageObserver(id:String = "0") {
        guard let userMessageHandle = userMessageHandle else {
            // Observer handle is nil, meaning there's no observer to remove
            return
        }
        
        let userMessageRef = ZLFireBaseManager.share.messageRef.child("message").child(id)
        userMessageRef.removeObserver(withHandle: userMessageHandle)
        
        //  ZLFireBaseManager.share.messageRef.removeObserver(withHandle: userMessageHandle)
        
    }
    
    func updateDataOnClosePK() {
    
        var dic = [String: Any]()

        dic["pk_opponent_gift_coins"] = 0
        dic["pk_opponent_user_detail"] = nil
        dic["pk_opponent_side_gifted_users"] = nil
        dic["pk_opponent_userid"] = ""
        dic["pk_end_time"] = 0
        dic["host2_groupid"] = ""
        dic["pk_my_side_gifted_users"] = nil
        dic["pk_current_id"] = ""//0
        dic["status"] = "LIVE"
        dic["host1_groupid"] = ""
        dic["pk_myside_gift_coins"] = 0

        print("The dictionary to update is: \(dic)")
        
        let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        
        ZLFireBaseManager.share.writeDataToFirebaseEndPK(data: dic, id: id)
        
      //  ZLFireBaseManager.share.writeDataToFirebase(data: dic)
       
        let pendID = self.pkRequestHostDetail.inviteUserID ?? ""
        print("The pendID is: \(pendID)")
        
        ZLFireBaseManager.share.writeDataToFirebaseEndPK(data: dic, id: pendID)
        
    }
    
    func updateStatusSecondHostToFirebaseForPK(data: [String:Any]) {
    
        // Get the current date
        let currentDate = Date()

        // Add 4 minutes to the current date
         let newDate = Calendar.current.date(byAdding: .minute, value: 4, to: currentDate)
            // Convert the new date to milliseconds since the Unix epoch
        let milliseconds = Int((newDate?.timeIntervalSince1970 ?? 0.0) * 1000)
            
            print("Current Global Time + 4 Minutes in milliseconds: \(milliseconds)")
        
        let currentTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        print(currentTimestampInMilliseconds)
        
        let callRate = data["callRate"] as? String
        let name = data["name"] as? String
        let pid = data["pid"] as? String
        let newVersionPK = data["newVersionPK"] as? Bool
        let channelName = data["channelName"] as? String
        let uid = data["uid"] as? String
        let profilePic = data["profilePic"] as? String
        let fcmToken = data["fcmToken"] as? String
        let level = data["level"] as? String
        let newCallRate = data["new_call_rate"] as? String
        let star = data["star"] as? String
        let count = data["count"] as? Int
        let genderOpponent = data["gender"] as? String
        let status = data["status"] as? String
        let imGroupId = data["imGroupId"] as? String
        let weeklyPoints = data["weeklyPoints"] as? String
        let channaleName = data["channaleName"] as? String
        
        var result = String()
        
        let gender = UserDefaults.standard.string(forKey: "gender")
        if (gender?.lowercased() == "male") {
            
            result = "1"
            
        } else {
            
            result = "0"
            
        }
        
        let pkData: [String: Any] = [
            "broadId": "null",
            "callRate": callRate,//(UserDefaults.standard.string(forKey: "callrate") ?? "1"),
            "channaleName": channelName,
            "count": 0,
            "fcmToken": fcmToken ,
            "gender": genderOpponent,
            "host1_groupid": imGroupId,
            "host2_groupid": groupID ,
            "host_streak_count": 0,
            "imGroupId": imGroupId,
            "level": level,
            "name": name,
            "newVersionPK": true,
            "new_call_rate": callRate,
            "pid": pid,
            "pk_current_id": pkID,
            "pk_end_time": milliseconds,
            "pk_my_side_gifted_users": [
                "User1": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ],
                "User2": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ],
                "User3": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ]
            ],
            "pk_myside_gift_coins": 0,
            "pk_opponent_gift_coins": 0,
            "pk_opponent_side_gifted_users": [
                "User1": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ],
                "User2": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ],
                "User3": [
                    "totalGift": 0,
                    "type": 0,
                    "userID": 0,
                    "userName": ""
                ]
            ],
            "pk_opponent_user_detail": [
                "age": "24",
                "call_rate": (UserDefaults.standard.string(forKey: "callrate") ?? "1"),
                "coins": "0",
                "language": "Hindi",
                "level": (UserDefaults.standard.string(forKey: "level") ?? ""),
                "location": "India",
                "status": "PK",
                "user_id": (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""),
                "user_image": (UserDefaults.standard.string(forKey: "profilePicture") ?? ""),
                "user_name": (UserDefaults.standard.string(forKey: "UserName") ?? ""),
                "user_uid": (UserDefaults.standard.string(forKey: "userId") ?? "0")
            ],
            "pk_opponent_userid": (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""),//(UserDefaults.standard.string(forKey: "userId") ?? "0"),
            "profilePic": profilePic,
            "remote_streak_count": 0,
            "star": "0",
            "status": "PK",
            "uid": uid,
            "weeklyPoints": weeklyPoints
        ]

        let pID = self.pkRequestHostDetail.inviteUserID ?? ""
        print("The pID is: \(pID)")
       
        ZLFireBaseManager.share.writeDataToFirebaseForPK(data: pkData, id: pID)
        
      //  ZLFireBaseManager.share.writeDataToFirebase(data: pkData)
        updateStatusToPkRequest(data: data, pkstatus: "accept") // status was idle changed to accepted on 22 August
        
    }
    
}


extension PKPublishViewController {

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
                print("Child node removed successfully for cohost invite list in pk publish view controller.")
            }
        }
    }
    
    func removeObserverForCoHostInviteList() {
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let coHostRef = ZLFireBaseManager.share.coHostRef.child("sub-cohost-invite-list").child(currentUserProfileID)
        
        if let handle = HostMicRequestHandle {
            coHostRef.removeObserver(withHandle: handle)
            HostMicRequestHandle = nil
            print("Observer removed for CoHost InviteList")
        }
        
        // Remove the data at the node
          coHostRef.removeValue { error, _ in
              if let error = error {
                  print("Failed to remove data at node: \(error)")
              } else {
                  print("Data removed for CoHost InviteList")
              }
          }
        
    }

    
}

extension PKPublishViewController {
    
    func addListeners() {
    
        V2TIMManager.sharedInstance().addGroupListener(listener: messageListener)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMessagePushNotification(_:)),
                                               name: Notification.Name("BroadTencentMessage"),
                                               object: nil)
        
    }
    
    // Method to configure and create ZegoExpressEngine
    func createEngine() {
        NSLog("🚀 Create ZegoExpressEngine")

        let profile = ZegoEngineProfile()
        profile.appID = KeyCenter.appID
        profile.appSign = KeyCenter.appSign
        profile.scenario = .broadcast

        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
        ZegoExpressEngine.shared().enableHardwareEncoder(false)

        enableCamera = true
        muteSpeaker = false
        muteMicrophone = false

        let videoConfig = ZegoVideoConfig()
        videoConfig.fps = 15
        videoConfig.bitrate = 1200
        videoConfig.captureResolution = CGSizeMake(540, 960);
        videoConfig.encodeResolution = CGSizeMake(540, 960);

        ZegoExpressEngine.shared().setVideoConfig(videoConfig)

        let videoMirrorMode: ZegoVideoMirrorMode = .onlyPreviewMirror
        ZegoExpressEngine.shared().setVideoMirrorMode(videoMirrorMode)

         previewCanvas = ZegoCanvas(view: viewPKFirstUserOutlet)
        previewCanvas.viewMode = .aspectFill
        print("The preview view shape and size is: \(String(describing: previewCanvas.view.frame))")
        NSLog("🔌 Start preview")
        
       // ZegoExpressEngine.shared().startPreview(previewCanvas)
        
        ZegoExpressEngine.shared().setEventHandler(self)
    }
    
    func configureUI() {
    
        viewGift.isHidden = true
        btnGiftOutlet.isHidden = true
        
        btnFollowHostOutlet.isHidden = true
        btnFollowHostWidthConstraints.constant = 0
        
        let gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        
        if (gender.lowercased() == "male") {
        
            viewOneToOneCall.isHidden = false
        } else {
            
            viewOneToOneCall.isHidden = true
            
        }
        
        viewLuckyGift.isHidden = true
        btnGameWidthConstraints.constant = 0
        btnGameOutlet.isHidden = true
        viewMain.backgroundColor = GlobalClass.sharedInstance.setPKControllerBackgroundColour()
        viewMessage.isHidden = true
        viewMessage.layer.cornerRadius = viewMessage.frame.size.height / 2
        viewMessage.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        txtFldMessage.setLeftPaddingPoints(15)
        btnUserDetailOutlet.backgroundColor = .black.withAlphaComponent(0.4)
        btnUserDetailOutlet.layer.cornerRadius = btnUserDetailOutlet.frame.size.height / 2
        imgViewUserImage.layer.cornerRadius = imgViewUserImage.frame.size.height / 2
        imgViewUserImage.clipsToBounds = true
        btnViewDistributionOutlet.layer.cornerRadius = btnViewDistributionOutlet.frame.size.height / 2
        btnViewDistributionOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btnViewRewardOutlet.layer.cornerRadius = btnViewRewardOutlet.frame.size.height / 2
        btnViewRewardOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewUserRoomStatus.layer.cornerRadius = viewUserRoomStatus.frame.height / 2
        viewUserRoomStatus.backgroundColor = .black.withAlphaComponent(0.6)
        lblRoomUserName.textColor = UIColor(hexString: "F9B248")
        
        viewPKSecondUserNameOutlet.backgroundColor = .black.withAlphaComponent(0.4)
        viewPKSecondUserNameOutlet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        viewPKSecondUserNameOutlet.layer.cornerRadius = viewPKSecondUserNameOutlet.frame.height / 2
        
        viewPKBottom.backgroundColor = GlobalClass.sharedInstance.setPKControllerBackgroundColour()
       
        viewLuckyGiftDetails.layer.cornerRadius = viewLuckyGiftDetails.frame.height / 2
        viewLuckyGiftDetails.backgroundColor = .black.withAlphaComponent(0.3)
        viewGiftImage.layer.cornerRadius = viewGiftImage.frame.height / 2
        viewUserImage.layer.cornerRadius = viewUserImage.frame.height / 2
        imgViewGift.layer.cornerRadius = imgViewGift.frame.height / 2
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        
        viewTimerCount.backgroundColor = .black.withAlphaComponent(0.5)
        
        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.width - 20)
        widthConstraint.isActive = true
       
        let userNameWidthConstraint = NSLayoutConstraint(item: lblRoomUserName, attribute: .width, relatedBy: .lessThanOrEqual, toItem: viewUserRoomStatus, attribute: .width, multiplier: 0.5, constant: viewUserRoomStatus.frame.width / 2) // Adjust the multiplier and constant as needed
        userNameWidthConstraint.isActive = true
        
        lblLeftStackViewGiftAmount.text = "0"
        lblRightStackViewGiftAmount.text = "0"
       
        let formattedString1 = formatNumber(Int(UserDefaults.standard.string(forKey: "weeklyearning") ?? "0") ?? 0)
        lblDistributionAmount.text = formattedString1
        
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
        animationView3.contentMode = .scaleToFill
        animationView3.frame = viewPKAnimation.bounds
        viewPKAnimation.addSubview(animationView3)
        
        animationView3.animation = LottieAnimation.named("PK_small") // Replace with your animation file name
        animationView3.loopMode = .loop
        animationView3.play()
        animationView3.isUserInteractionEnabled = false
        
        let animationView4 = LottieAnimationView()
        animationView4.contentMode = .scaleToFill
        animationView4.frame = viewStackMiddle.bounds
        viewStackMiddle.addSubview(animationView4)
        
        animationView4.animation = LottieAnimation.named("MId_animation_Udpated") // Replace with your animation file name
        animationView4.loopMode = .loop
        animationView4.play()
        animationView4.isUserInteractionEnabled = false
        
        lottieAnimationViews = [animationView, animationView1, animationView2, animationView3, animationView4]
        
    }
    
    func removeLottieAnimationViews() {
          // Remove Lottie animation views from their superviews
          lottieAnimationViews.forEach { $0.removeFromSuperview() }
      }
    
    func timerAndNotification() {
       
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(handleTap), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.width - 20)
        widthConstraint.isActive = true
       
        let userNameWidthConstraint = NSLayoutConstraint(item: lblRoomUserName, attribute: .width, relatedBy: .lessThanOrEqual, toItem: viewUserRoomStatus, attribute: .width, multiplier: 0.5, constant: viewUserRoomStatus.frame.width / 2) // Adjust the multiplier and constant as needed
        userNameWidthConstraint.isActive = true
        
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
    
        collectionViewBroadUserJoinList.register(UINib(nibName: "BroadJoinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BroadJoinCollectionViewCell")
        collectionViewBroadUserJoinList.delegate = self
        collectionViewBroadUserJoinList.dataSource = self
        collectionViewBroadUserJoinList.isUserInteractionEnabled = true
        
        collectionViewJoinMic.register(UINib(nibName: "RequestJoinMicUserListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RequestJoinMicUserListCollectionViewCell")
        collectionViewJoinMic.delegate = self
        collectionViewJoinMic.dataSource = self
        collectionViewJoinMic.isUserInteractionEnabled = true
        
    }
    
    // Method to handle data setting and streaming logic
    func setData() {
        print("The Pk Accepted Host Details are - \(pkRequestHostDetail)")
        
        lblHostName.text = UserDefaults.standard.string(forKey: "UserName") ?? "N/A"
        lblPKSecondUserName.text = pkRequestHostDetail.name ?? "N/A"

        if let imageURL = UserDefaults.standard.string(forKey: "profilePicture") {
            loadImage(from: imageURL, into: imgViewUserImage)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let userID = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
            let user = ZegoUser(userID: userID)

            let roomID = "Zeeplive" + (self.pkRequestHostDetail.inviteUserID ?? "")
            let channelName = roomID + "_stream"
            
            self.secondRoom = roomID
            print("The second room id in pk  publish view controller is; \(self.secondRoom)")
            
            let config = ZegoRoomConfig()
    //        config.token = KeyCenter.token
            config.isUserStatusNotify = true
            
            // Login to the room for publishing
            ZegoExpressEngine.shared().loginRoom(self.channelName, user: user, config: config)//ZegoRoomConfig())
            print("Channel name publish kar: \(self.channelName)")

            let zegoMultiConfig = ZegoPublisherConfig()
            zegoMultiConfig.roomID = self.channelName
            
            ZegoExpressEngine.shared().startPreview(self.previewCanvas)
            
            ZegoExpressEngine.shared().startPublishingStream(self.streamName, config: zegoMultiConfig, channel: .main)
            print("Stream name publish kar: \(self.streamName)")
            
            // Login to the room for playing
            let zegocanvas = ZegoCanvas(view: self.viewPKSecondUserOutlet)
            zegocanvas.viewMode = .aspectFill

            print("The channel name we are getting is: \(channelName)")
            print("The room id we are getting for host is: \(roomID)")

            ZegoExpressEngine.shared().loginRoom(roomID, user: user, config: ZegoRoomConfig())

            let config1 = ZegoPlayerConfig()
            config1.roomID = roomID
            ZegoExpressEngine.shared().startPlayingStream(channelName, canvas: zegocanvas, config: config1)

            print("The room ID here is: \(roomID)")
            print("The channel name here is: \(channelName)")
            
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
                            self.setRoomExtraInfo()
                        }
            
        }
    }
    
}

extension PKPublishViewController {
    
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
           //    self.view.bringSubviewToFront(viewMessage)
               let keyboardHeight = keyboardFrame.cgRectValue.height
              
               let viewBottomY = viewMessage.frame.origin.y + viewMessage.frame.size.height + 25
               let keyboardTopY = self.view.frame.size.height - keyboardHeight
               
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
         
        //   self.view.sendSubviewToBack(viewMessage)
           UIView.animate(withDuration: 0.3) {
               self.viewMessageBottomConstraints.constant = 20 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
               self.viewMessage.frame.origin.y = self.view.frame.size.height - self.viewMessage.frame.size.height
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
    
    func configureBottomBarWork() {
        
        let leftColor = GlobalClass.sharedInstance.setPKLeftViewColour()
        let rightColor = GlobalClass.sharedInstance.setPKRightViewColour()
        GlobalClass.sharedInstance.addGradientToLeftAndRight(to: viewStackMiddle, cornerRadius: 0, leftColor: leftColor, rightColor: rightColor)
        
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
    
}

// MARK: - EXTENSION FOR GETTING VALUES AND USING FUNCTIONS TO SET VALUES IN MESSAGES TABLE VIEW AND IN COLLECTION VIEW

extension PKPublishViewController: delegateJoinedAudienceDetailsViewController {
    
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
            collectionViewBroadUserJoinList.reloadData()
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
              
                loadImage(from: userImage, into: imgViewGiftUserOne)
            }
            if fromUser == "2" {
                giftSecondUserID = userID
                giftSecondUserName = userName
                giftSecondUserImage = userImage
            
                loadImage(from: userImage, into: imgViewGiftUserTwo)
            }
            if fromUser == "3" {
                giftThirdUserID = userID
                giftThirdUserName = userName
                giftThirdUserImage = userImage
          
                loadImage(from: userImage, into: imgViewGiftUserThree)
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
             
                loadImage(from: userImage, into: imgViewGiftOpponentUserOne)
            }
            if fromUser == "2" {
                giftOpponentSecondUserID = userID
                giftOpponentSecondUsername = userName
                giftOpponentSecondUserImage = userImage
            
                loadImage(from: userImage, into: imgViewGiftOpponentUserTwo)
            }
            if fromUser == "3" {
                giftOpponentThirdUserID = userID
                giftOpponentThirdUsername = userName
                giftOpponentThirdUserImage = userImage
             
                loadImage(from: userImage, into: imgViewGiftOpponentUserThree)
                
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
                
                    loadImage(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
                    imgViewSecondUserOnMic.image = UIImage(named: "seatimage")
                    imgViewThirdUserOnMic.image = UIImage(named: "seatimage")
                }
                if (zegoMicUsersList.count == 2) {
               
                    loadImage(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
                    loadImage(from: zegoMicUsersList[1].coHostUserImage ?? "", into: imgViewSecondUserOnMic)
                    imgViewThirdUserOnMic.image = UIImage(named: "seatimage")
                }
                if (zegoMicUsersList.count >= 3) {

                    loadImage(from: zegoMicUsersList[0].coHostUserImage ?? "", into: imgViewFirstUserOnMic)
                    loadImage(from: zegoMicUsersList[1].coHostUserImage ?? "", into: imgViewSecondUserOnMic)
                    loadImage(from: zegoMicUsersList[2].coHostUserImage ?? "", into: imgViewThirdUserOnMic)
                    
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
                
                    loadImage(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
                    imgViewOpponentSecondUserOnMic.image = UIImage(named: "seatimage")
                    imgViewOpponentThirdUserOnMic.image = UIImage(named: "seatimage")
                }
                if (zegoOpponentMicUsersList.count == 2) {
                    
                    loadImage(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
                    loadImage(from: zegoOpponentMicUsersList[1].coHostUserImage ?? "", into: imgViewOpponentSecondUserOnMic)
                    imgViewOpponentThirdUserOnMic.image = UIImage(named: "seatimage")
                }
                if (zegoOpponentMicUsersList.count >= 3) {

                    loadImage(from: zegoOpponentMicUsersList[0].coHostUserImage ?? "", into: imgViewOpponentFirstUserOnMic)
                    loadImage(from: zegoOpponentMicUsersList[1].coHostUserImage ?? "", into: imgViewOpponentSecondUserOnMic)
                    loadImage(from: zegoOpponentMicUsersList[2].coHostUserImage ?? "", into: imgViewOpponentThirdUserOnMic)
                    
                }
            }
        }
    }

    func viewProfileDetails(isClicked: Bool, userID: String) {

        print("User ki profile details wala page kholna hai.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController

        nextViewController.userID = (pkRequestHostDetail.inviteUserID ?? "")
        nextViewController.callForProfileId = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
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
    
    func buttonRecieveCallPressed(isPressed: Bool) {
        
        print("Button Call Recieved Pressed by the host.")
        sendMessageUsingZego()
        
    }
    
}

// MARK: - EXTENSION FOR SENDING CUSTOM MESSAGE THROUGH ZEGO TO KNOW THE USER THAT ONE TO ONE CALL IS ACCEPTED.

extension PKPublishViewController {

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
                        
                     //   self.updateUserStatusToFirebase(status:"BUSY")
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneCallViewController") as! OneToOneCallViewController
                        nextViewController.channelName = self.callChannelName
                        nextViewController.cameFrom = "host"
                        nextViewController.userName = self.callSenderName
                        nextViewController.userImage = self.callSenderImage
                        nextViewController.userID = self.callSenderID
                        nextViewController.uniqueID = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "") //String(self.uniqueID)
                        
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

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND THEIR FUNCTION'S WORKING

extension PKPublishViewController : UITableViewDelegate,UITableViewDataSource {
    
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
        
        var user = joinedGroupUserProfile()
        
        user.userID = liveMessages[indexPath.row].userID ?? ""
        user.nickName = liveMessages[indexPath.row].userName ?? ""
        user.faceURL = liveMessages[indexPath.row].userImage ?? ""
        user.richLevel = liveMessages[indexPath.row].level ?? ""
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        nextViewController.messageDetails = user
        nextViewController.delegate = self
        nextViewController.viewFrom = "message"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
      //  delegate?.pkmessageClicked(userImage: image, userName: name, userLevel: level, userID: id)
        
    }
}

// MARK: - EXTENSION FOR USING COLLECTION VIEW DELEGATES AND FUNCTIONS AND THEIR WORKING

extension PKPublishViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == collectionViewBroadUserJoinList) {
            
            return userInfoList?.count ?? 0
            
        } else {
            
            return coHostRequestList.count
            
        }
        
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
        if (collectionView == collectionViewBroadUserJoinList) {
          
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BroadJoinCollectionViewCell", for: indexPath) as! BroadJoinCollectionViewCell
            
            
            cell.resetCellState()
            cell.isUserInteractionEnabled = true
            cell.imgViewUserPhoto.layer.cornerRadius = cell.imgViewUserPhoto.frame.height / 2
            cell.imgViewUserPhoto.clipsToBounds = true
            
            // Clear the image first
            cell.imgViewUserPhoto.image = nil
            
            if let imageURL = URL(string: userInfoList?[indexPath.row].faceURL ?? "") {
                KF.url(imageURL)
                    .cacheOriginalImage()
                    .onSuccess { [weak cell] result in
                        DispatchQueue.main.async {
                            cell?.imgViewUserPhoto.image = result.image
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
            
            cell.imgViewUserPhoto.isUserInteractionEnabled = true
            cell.viewMain.isUserInteractionEnabled = true
            
            return cell
            
        } else {
        
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
        
        if (collectionView == collectionViewBroadUserJoinList) {
         
            let width = (collectionView.bounds.size.width ) / 4
            let height = width - 65
            return CGSize(width: width, height: 40)
            
        } else {
        
            return CGSize(width: 155, height: 110)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
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
    
}
    
extension PKPublishViewController {
    
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
            print("The group enter callback result are \(msgID), \(text)")
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
            
            insertUserName(name: text.nickName ?? "N/A", status: "3")
            
            print("The group leave callback result are \(msgID), \(text)")
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

               lblBroadCount.text = String(memberList?.count ?? 0)
            
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

            collectionViewBroadUserJoinList.reloadData()
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

// MARK: - EXTENSION FOR API CALLING IN PK PUBLISH VIEW CONTROLLER

extension PKPublishViewController {
    
    
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
       
    
}

extension PKPublishViewController {
    
    func onPublisherStateUpdate(_ state: ZegoPublisherState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
       
        print("The publisher room state is: \(state)")
        
    }
    
    func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
        NSLog(" 🚩 🚪 Room state update, state: \(state.rawValue), errorCode: \(errorCode), roomID: \(roomID)")
        roomState = state
        print(roomState)

        if state == .connected {
//            ZegoExpressEngine.shared().startPreview(previewCanvas)
        }
        
    }
    
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
        // User received
        
        print("The update type is: \(updateType)")
        print("The stream list is: \(streamList)")
        print("The room stream extended data is: \(extendedData)")
        print("The room stream id in update is: \(roomID)")
        
        if updateType == ZegoUpdateType.add {
            // Handle added streams
            for stream in streamList {
                let streamID = stream.streamID
                // Use streamID as needed
                print("Added stream ID: \(streamID)")
                btnCloseBroadOutlet.isUserInteractionEnabled = true
                createLiveBroadcastForListing()
            }
            
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
            
        }
        
    }
       
    func onIMRecvCustomCommand(_ command: String, from fromUser: ZegoUser, roomID: String) {
        print(command)
        print(fromUser)
        print(roomID)

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
    
    func onRoomExtraInfoUpdate(_ roomExtraInfoList: [ZegoRoomExtraInfo], roomID: String) {
        print("The extra info we are getting from the Zego is: \(roomExtraInfoList)")
        print("The extra info room id is: \(roomID)")
        print("The extra info room details count is: \(roomExtraInfoList.count)")
        
        print(roomExtraInfoList)
        print(roomExtraInfoList[0])
        print("The room values in the pk publish view controller are: \(roomExtraInfoList.first?.value)")
        
//        for roomExtraInfo in roomExtraInfoList {
//            let updatedRoomID = roomExtraInfo.value.description
//            let a = roomExtraInfo.value
//            print(updatedRoomID)
//            print(a)
//        }
        
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
                        
                        // Safely access the "type" value
                           if let type = pkHostJson["type"] as? String {
                               print("The type is: \(type)")
                               if (type == "pk_end") {
                                   print("PK band karna hai.")
                               } else {
                                   print("PK ko chalte rkhna hai.")
                               }
                           } else {
                               print("Type key not found or is not a String")
                           }
                        
                        
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
                                                        } else {
                                                            print("coHostAudioStatus is not a String or is nil")
                                                            micUser.coHostAudioStatus = "unmute"
                                                        }
                                                        
                                                        let micUserJson: [String: Any] = [
                                                                "coHostUserImage": micUser.coHostUserImage,
                                                                "coHostUserName": micUser.coHostUserName,
                                                                "coHostID": micUser.coHostID,
                                                                "coHostUserStatus": micUser.coHostUserStatus,
                                                                "coHostLevel": micUser.coHostLevel,
                                                                "coHostAudioStatus":micUser.coHostAudioStatus,
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
                                                        
                                                         if (roomID == room ) {
                                                             
                                                             print("Room ID same hai yhn par ehi kaam krenge jo chal raha hai.")
                                                             
                                                        if zegoMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                            // There is already an element with the same coHostID in zegoMicUsersList
                                                            if ( micUser.coHostUserStatus != "add") {
                                                                
                                                                let streamID = room + micUser.coHostID! + "_cohost_stream"
                                                                print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                                
                                                                ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                                
                                                                zegoMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                                zegoOpponentMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                                print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                              
                                                                usersOnMic(data: zegoMicUsersList)
                                                            }
                                                        } else {
                                                            // There is no element with the same coHostID in zegoMicUsersList
                                                            zegoMicUsersList.append(micUser)
                                                            for i in zegoMicUsersList {
                                                                print(i)
                                                                print(i.coHostID)
                                                                let streamID = room + i.coHostID! + "_cohost_stream"
                                                                print("THe stream id we are passing in case of the join mic is: \(streamID)")
                                                                
                                                                let config = ZegoPlayerConfig()
                                                                config.roomID = room
                                                                
                                                                let zegocanvas = ZegoCanvas(view: UIView())
                                                                
                                                                ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                                
                                                            }
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
                                                                  
                                                                     opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                                 }
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
                                                             }
                                                         }
                                                    
                                                       // zegoMicUsersList.append(micUser)
                                                        print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                                        // Repeat the same for other properties like coHostUserImage, coHostUserName, coHostUserStatus
                                                    }
                                                }
                                            }
                                            print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                    
                                                if (roomID == room) {
                                                    usersOnMic(data: zegoMicUsersList)
                                                } else {
                                                    opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                            }
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
                                                
                                                if (roomID == room ) {
                                                    print("Room ID same hai yhn par ehi kaam krenge jo chal raha hai.")
                                                    
                                               if zegoMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                   // There is already an element with the same coHostID in zegoMicUsersList
                                                   if ( micUser.coHostUserStatus != "add") {
                                                       
                                                       let streamID = room + micUser.coHostID! + "_cohost_stream"
                                                       print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                       
                                                       ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                       
                                                       zegoMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                       zegoOpponentMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                       print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                    
                                                       usersOnMic(data: zegoMicUsersList)
                                                   }
                                               } else {
                                                   // There is no element with the same coHostID in zegoMicUsersList
                                                   zegoMicUsersList.append(micUser)
                                                   for i in zegoMicUsersList {
                                                       print(i)
                                                       print(i.coHostID)
                                                       let streamID = room + i.coHostID! + "_cohost_stream"
                                                       print("THe stream id we are passing in case of the join mic is: \(streamID)")
                                                       
                                                       let config = ZegoPlayerConfig()
                                                       config.roomID = room
                                                       
                                                       let zegocanvas = ZegoCanvas(view: UIView())
                                                       
                                                       ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                       
                                                   }
                                               }
                                                    let micUserJson: [String: Any] = [
                                                            "coHostUserImage": micUser.coHostUserImage,
                                                            "coHostUserName": micUser.coHostUserName,
                                                            "coHostID": micUser.coHostID,
                                                            "coHostUserStatus": micUser.coHostUserStatus,
                                                            "coHostLevel": micUser.coHostLevel,
                                                            "coHostAudioStatus":micUser.coHostAudioStatus,
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
                                                           
                                                            opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                        }
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
                                                    }
//                                                    let micUserJson: [String: Any] = [
//                                                            "coHostUserImage": micUser.coHostUserImage,
//                                                            "coHostUserName": micUser.coHostUserName,
//                                                            "coHostID": micUser.coHostID,
//                                                            "coHostUserStatus": micUser.coHostUserStatus,
//                                                            "coHostLevel": micUser.coHostLevel,
//                                                            "coHostAudioStatus":micUser.coHostAudioStatus,
//                                                            "isHostMuted": micUser.isHostMuted
//                                                        ]
//                                                        
//                                                        // Convert the JSON object to a JSON string
//                                                        if let jsonData = try? JSONSerialization.data(withJSONObject: micUserJson, options: []),
//                                                           let jsonString = String(data: jsonData, encoding: .utf8) {
//                                                            
//                                                            // Add the JSON string to zegoSendMicUsersList with coHostID as the key
//                                                            zegoSendMicUsersList[micUser.coHostID ?? ""] = jsonString
//                                                        } else {
//                                                            print("Error converting micUser to JSON string")
//                                                        }
//                                                    
                                                }

//                                                zegoMicUsersList.append(micUser)
                                                print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                                // Repeat the same for other properties like coHostUserImage, coHostUserName, coHostUserStatus
                                            
                                                print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                               
                                                 
                                                    if (roomID == room) {
                                                        usersOnMic(data: zegoMicUsersList)
                                                    } else {
                                                        opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                    }
                                                                                                
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
                                // Deserialize the JSON data
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    // Access the value associated with the key "coHost123"
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
                                                                } else {
                                                                    micUser.coHostAudioStatus = "unmute"
                                                                }
                                                                
                                                                
                                                                if zegoMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                                    // There is already an element with the same coHostID in zegoMicUsersList
                                                                    if ( micUser.coHostUserStatus != "add") {
                                                    
                                                                            let streamID = room + micUser.coHostID! + "_cohost_stream"
                                                                            print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                                        
                                                                            ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                                        
                                                                        let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                        
                                                                        if (id == micUser.coHostID) {
                                                                            ZegoExpressEngine.shared().stopPublishingStream()
                                                                        print("User ne join mic  kia tha isliye stream publish  hui hai aur publish karna bnd hui hai....")
                                                                        } else {
                                                                            print("User ne join mic nahi kia tha isliye stream publish nahi hui hai bas play hui hai....")
                                                                        }
                                                                        
                                                                        zegoMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                                        print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                                       
                                                                        // Remove the user from zegoSendMicUsersList
                                                                        zegoSendMicUsersList.removeValue(forKey: micUser.coHostID ?? "")
                                                                           print("User removed from zegoSendMicUsersList")
                                                                        
                                                                        setRoomExtraInfo()
                                                                        
                                                                            
                                                                        usersOnMic(data: zegoMicUsersList)
                                                                        
                                                                    } else {
                                                                        
                                                                        print("Dekh rhain hai yhn aaega kya...")
                                                                        let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                        print("The user joined id we are checking is : \(id)")
                                                                        
//                                                                        if (id == micUser.coHostID) {
//                                                            
//                                                                            
//                                                                            if (micUser.coHostAudioStatus?.lowercased() == "mute") {
//                                                                                isMutedByHost = true
//                                                                                ZegoExpressEngine.shared().muteMicrophone(true)
//                                                                                print("Microphone ko mute kar diya hai.")
//                                                                                isMicMutedByHost = true
//                                                                                btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
//                                                                            } else {
//                                                                               
//                                                                                isMutedByHost = false
//                                                                                ZegoExpressEngine.shared().muteMicrophone(false)
//                                                                                print("Microphone ko unmute kar diya hai.")
//                                                                               isMicMutedByHost = false
//                                                                                btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
//                                                                            }
//                                                                            
//                                                                        print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
//                                                                        }
                                                                        
                                                                    }
                                                                } else {
                                                                    // There is no element with the same coHostID in zegoMicUsersList
                                                                    zegoMicUsersList.append(micUser)
                                                                    for i in zegoMicUsersList {
                                                                        print(i)
                                                                        print(i.coHostID)
                                                                        let streamID = room + i.coHostID! + "_cohost_stream"
                                                                        print("THe stream id we are passing in case of the join mic in live is: \(streamID)")
                                                                        
                                                                        if (i.coHostUserStatus?.lowercased() == "delete") {
                                                                            
                                                                            let coHostIDToRemove = i.coHostID
                                                                            
                                                                            print("User ko delete krna hai. add nahi.")
                                                                            // Check if the zegoOpponentMicUsersList contains the coHostID
                                                                            if zegoOpponentMicUsersList.contains(where: { $0.coHostID == coHostIDToRemove }) {
                                                                                // Remove the element(s) with the matching coHostID
                                                                                zegoOpponentMicUsersList.removeAll { $0.coHostID == coHostIDToRemove }
                                                                                print("Removed coHostID \(coHostIDToRemove) from zegoOpponentMicUsersList")
                                                                            } else {
                                                                                print("coHostID \(coHostIDToRemove) does not exist in zegoOpponentMicUsersList")
                                                                            }
                                                                            
                                                                            if zegoMicUsersList.contains(where: { $0.coHostID == coHostIDToRemove }) {
                                                                                // Remove the element(s) with the matching coHostID
                                                                                zegoMicUsersList.removeAll { $0.coHostID == coHostIDToRemove }
                                                                                print("Removed coHostID \(coHostIDToRemove) from zegoOpponentMicUsersList")
                                                                            } else {
                                                                                print("coHostID \(coHostIDToRemove) does not exist in zegoOpponentMicUsersList")
                                                                            }
                                                                            
                                                                            usersOnMic(data: zegoMicUsersList)
                                                                            opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                                            
                                                                        } else {
                                                                        
                                                                            print("User ko add karna hai. delete nahi.")
                                                                            
                                                                        let config = ZegoPlayerConfig()
                                                                        config.roomID = room
                                                                        
                                                                        
                                                                        let zegocanvas = ZegoCanvas(view: UIView())
                                                                        
                                                                        ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                                        
                                                                        let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                        print("The user joined id we are checking is : \(id)")
                                                                        
                                                                        
                                                                        let micUserJson: [String: Any] = [
                                                                            "coHostUserImage": micUser.coHostUserImage,
                                                                            "coHostUserName": micUser.coHostUserName,
                                                                            "coHostID": micUser.coHostID,
                                                                            "coHostUserStatus": micUser.coHostUserStatus,
                                                                            "coHostLevel": micUser.coHostLevel,
                                                                            "coHostAudioStatus":micUser.coHostAudioStatus,
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
                                                                    }
                                                                }
                                                            }
                                                          
                                                                if (roomID == room) {
                                                                    usersOnMic(data: zegoMicUsersList)
                                                                } else {
                                                                    opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                                }
                                                                                                                        
                                                        } catch {
                                                            print("Error parsing nested JSON: \(error)")
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
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
    
}

//    func createEngine() {
//        NSLog("🚀 Create ZegoExpressEngine")
//
//        let profile = ZegoEngineProfile()
//        profile.appID = KeyCenter.appID
//        profile.appSign = KeyCenter.appSign
//        profile.scenario = .broadcast
//
//        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
//        ZegoExpressEngine.shared().enableHardwareEncoder(false)
//
//        enableCamera = true
//        muteSpeaker = false
//        muteMicrophone = false
//
//        let videoConfig = ZegoVideoConfig()
//        videoConfig.fps = 30
//        videoConfig.bitrate = 2400
//        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
//
//        let videoMirrorMode: ZegoVideoMirrorMode = .onlyPreviewMirror
//        ZegoExpressEngine.shared().setVideoMirrorMode(videoMirrorMode)
//
//        let previewCanvas = ZegoCanvas(view: viewPKFirstUserOutlet)
//        previewCanvas.viewMode = .aspectFill
//        print("The preview view shape and size is: \(String(describing: previewCanvas.view.frame))")
//        NSLog("🔌 Start preview")
//
//     //   ZegoExpressEngine.shared().startPreview(previewCanvas)
//
//        ZegoExpressEngine.shared().setEventHandler(self)
//    }
    
//    func createEngine() {
//        NSLog("🚀 Create ZegoExpressEngine")
//
//        let profile = ZegoEngineProfile()
//        profile.appID = KeyCenter.appID
//        profile.appSign = KeyCenter.appSign
//        profile.scenario = .broadcast
//
//        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
//        ZegoExpressEngine.shared().enableHardwareEncoder(false)
//
//        enableCamera = true
//        muteSpeaker = false
//        muteMicrophone = false
//
//        let videoConfig = ZegoVideoConfig()
//        videoConfig.fps = 30
//        videoConfig.bitrate = 2400
//        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
//
//        let videoMirrorMode: ZegoVideoMirrorMode = .onlyPreviewMirror
//        ZegoExpressEngine.shared().setVideoMirrorMode(videoMirrorMode)
//
//        let previewCanvas = ZegoCanvas(view: viewPKFirstUserOutlet)
//        previewCanvas.viewMode = .aspectFill
//        print("The preview view shape and size is: \(String(describing: previewCanvas.view.frame))")
//        NSLog("🔌 Start preview")
//
////        if ZegoExpressEngine.shared().startPreview(previewCanvas) == nil {
////            NSLog("✅ Preview started successfully")
////        } else {
////            NSLog("❌ Failed to start preview")
////        }
//
//        ZegoExpressEngine.shared().setEventHandler(self)
//    }
    
//    func createEngine() {
//
//        NSLog(" 🚀 Create ZegoExpressEngine")
//        let profile = ZegoEngineProfile()
//        profile.appID = KeyCenter.appID
//        profile.appSign = KeyCenter.appSign
//
//        profile.scenario = .broadcast
//
//      //  ZegoExpressEngine.setRoomMode(.multiRoom)
//        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
//
//        ZegoExpressEngine.shared().enableHardwareEncoder(false)
//
//        enableCamera = true
//        muteSpeaker = false
//        muteMicrophone = false
//
//        videoConfig.fps = 30
//        videoConfig.bitrate = 2400;
//        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
//
//        ZegoExpressEngine.shared().setVideoMirrorMode(videoMirrorMode)
//
//        previewCanvas.view = viewPKFirstUserOutlet
//        previewCanvas.viewMode = previewViewMode
//        print("The preview view shape and size is: \(previewCanvas.view.frame)")
//        NSLog(" 🔌 Start preview")
//
//      //  ZegoExpressEngine.shared().startPreview(previewCanvas)
//        ZegoExpressEngine.shared().setEventHandler(self)
//
//    }

//        func onRoomStateChanged(_ reason: ZegoRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable : Any], roomID: String) {
//            print(roomID)
//            switch reason {
//               case .logining:
//                   // logging in
//                   // When loginRoom is called to log in to the room or switchRoom is used to switch to the target room, it enters this state, indicating that it is requesting to connect to the server.
//                print(reason)
//                print(errorCode)
//                   break
//               case .logined:
//                   // login successful
//                   // Currently, the loginRoom is successfully called by the developer or the callback triggered by the successful switchRoom. Here, you can handle the business logic for the first successful login to the room, such as fetching chat room and live streaming basic information.
//                print(reason)
//                print(errorCode)
//                print("The room id we are logined for is: \(roomID)")
//    //            group.leave()
//                   break
//               case .loginFailed:
//                   // login failed
//                   if errorCode == 1002033 {
//                       // When using the login room authentication function, the incoming Token is incorrect or expired.
//                       print(reason)
//                       print(errorCode)
//                       print("The room id we are logined failed for is: \(roomID)")
//                   }
//                print("The room id we are logined failed for is: \(roomID)")
//                print(reason)
//                print(errorCode)
//                   break
//               case .reconnecting:
//                   // Reconnecting
//                   // This is currently a callback triggered by successful disconnection and reconnection of the SDK. It is recommended to show some reconnection UI here.
//                print(reason)
//                print(errorCode)
//
//                   break
//               case .reconnected:
//                   // Reconnection successful
//                print(reason)
//                print(errorCode)
//
//                   break
//               case .reconnectFailed:
//                   // Reconnect failed
//                   // When the room connection is completely disconnected, the SDK will not reconnect. If developers need to log in to the room again, they can actively call the loginRoom interface.
//                   // At this time, you can exit the room/live broadcast room/classroom in the business, or manually call the interface to log in again.
//                print(reason)
//                print(errorCode)
//
//                   break
//               case .kickOut:
//                   // kicked out of the room
//                   if errorCode == 1002050 {
//                       // The user was kicked out of the room (because the user with the same userID logged in elsewhere).
//                       print(reason)
//                       print(errorCode)
//                   }
//                   else if errorCode == 1002055 {
//                       // The user is kicked out of the room (the developer actively calls the background kicking interface).
//                       print(reason)
//                       print(errorCode)
//                   }
//                   break
//               case .logout:
//                   // Logout successful
//                   // The developer actively calls logoutRoom to successfully log out of the room.
//                   // Or call switchRoom to switch rooms. Log out of the current room successfully within the SDK.
//                   // Developers can handle the logic of actively logging out of the room callback here.
//                   break
//               case .logoutFailed:
//                   // Logout failed
//                   // The developer actively calls logoutRoom and fails to log out of the room.
//                   // Or call switchRoom to switch rooms. Logout of the current room fails internally in the SDK.
//                   // The reason for the error may be that the logout room ID is wrong or does not exist.
//                   break
//               @unknown default:
//                   break
//               }
//        }

//    func setData() {
//        print("The Pk Accepted Host Details are - \(pkRequestHostDetail)")
//
//        lblHostName.text = UserDefaults.standard.string(forKey: "UserName") ?? "N/A"
//        lblPKSecondUserName.text = pkRequestHostDetail.name ?? "N/A"
//
//        if let imageURL = UserDefaults.standard.string(forKey: "profilePicture") {
//            loadImage(from: imageURL, into: imgViewUserImage)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            let userID = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
//            let user = ZegoUser(userID: userID)
//
//            ZegoExpressEngine.shared().loginRoom(self.channelName, user: user, config: ZegoRoomConfig())
//            print("Channel name publish kar")
//
//            let zegoMultiConfig = ZegoPublisherConfig()
//            zegoMultiConfig.roomID = self.channelName
//            ZegoExpressEngine.shared().startPublishingStream(self.streamName, config: zegoMultiConfig, channel: .third)
//
//            let roomID = "Zeeplive" + (self.pkRequestHostDetail.inviteUserID ?? "")
//            let channelName = roomID + "_stream"
//
//            let zegocanvas = ZegoCanvas(view: self.viewPKSecondUserOutlet)
//            zegocanvas.viewMode = .aspectFill
//
//            print("The channel name we are getting is: \(channelName)")
//            print("The room id we are getting is: \(roomID)")
//
//            ZegoExpressEngine.shared().loginRoom(roomID, user: user, config: ZegoRoomConfig())
//
//            let config = ZegoPlayerConfig()
//            config.roomID = roomID
//            ZegoExpressEngine.shared().startPlayingStream(channelName, canvas: zegocanvas, config: config)
//
//            print("The room ID here is: \(roomID)")
//            print("The channel name here is: \(channelName)")
//        }
//    }
    
//    func setData() {
//
//        print("The Pk Accepted Host Details are - \(pkRequestHostDetail)")
//
//        lblHostName.text = UserDefaults.standard.string(forKey: "UserName") ?? "N/A" //pkRequestHostDetail.name ?? "N/A"
//        lblPKSecondUserName.text = (pkRequestHostDetail.name ?? "N/A")
//        let imageURL = UserDefaults.standard.string(forKey: "profilePicture") ?? ""
//        loadImage(from: imageURL, into: imgViewUserImage)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//
//            ZegoExpressEngine.shared().loginRoom(self.channelName, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
//
//            print("Channel name publish kar")
//
//
//            let zegoMultiConfig = ZegoPublisherConfig()
//            zegoMultiConfig.roomID = self.channelName
//
//            ZegoExpressEngine.shared().startPublishingStream(self.streamName,config: zegoMultiConfig,channel: .main)
//
//                let roomID = "Zeeplive" + (self.pkRequestHostDetail.inviteUserID ?? "")
//                let channelName = roomID + "_stream"
//
//                let zegocanvas = ZegoCanvas(view: self.viewPKSecondUserOutlet)
//                zegocanvas.viewMode = .aspectFill
//
//            print("THe channel name we are getting is: \(channelName) ")
//            print("The room id we are getting is: \(roomID)")
//
//                ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
//                let config = ZegoPlayerConfig()
//                config.roomID = channelName
//
//                ZegoExpressEngine.shared().startPlayingStream(channelName, canvas: zegocanvas, config: config)
//                print("The roomid here is: \(roomID)")
//                print("The channel name here is: \(channelName)")
//
//
//        }
//    }

//    func getUserDetails(id: Int = 0) {
//
////        let url = AllUrls.baseUrl + "getprofiledata?id=\(pkRequestHostDetail.inviteUserID)"
////        print("The url that is going for profile detail is: \(url)")
//
//      //  let inviteUserID = pkRequestHostDetail.inviteUserID ?? ""
//        let url = AllUrls.baseUrl + "getprofiledata?id=\(id)"
//        print(url)
//
//
//        ApiWrapper.sharedManager().getUserProfileDetails(url: url) { [weak self] (data, value) in
//            guard let self = self else { return }
//
//            let a = type(of: data)
//            print(a)
//
//            print(data)
//            print(value)
//
//        }
//    }
//
//    func getUserProfileID() {
//        let inviteUserID = pkRequestHostDetail.inviteUserID ?? ""
//
//        let url = AllUrls.baseUrl + "getdatabyprofileid?profile_id=\(inviteUserID)"
//        print("The url that is going for profile detail is: \(url)")
//
//        ApiWrapper.sharedManager().getProfileID(url: url, completion: { [weak self] (data) in
//            guard let self = self else {
//                return // The object has been deallocated
//            }
//
//            if let success = data["success"] as? Bool, success {
//                print("Sab kuch sahi hai")
//
//                if let resultArray = data["result"] as? [[String: Any]], let profileData = resultArray.first {
//                    print(profileData)
//
//                    if let id = profileData["id"] as? Int {
//
//                        getUserDetails(id:id)
//                      //  getGiftDetails()
//                    }
//                } else {
//                    print("Result array is empty or couldn't extract profile data")
//                }
//            } else {
//                if let error = data["error"] {
//                    print(error)
//                }
//                print("Kuch error hai")
//            }
//        })
//    }

//    // Function to convert an object to a JSON string
//    func jsonString(from object: Any) -> String {
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: object, options: []),
//              let jsonString = String(data: jsonData, encoding: .utf8) else {
//            return ""
//        }
//        return jsonString
//    }


//            var infoStr1 = ""
//            var type = ""
//                // Convert mainCoHostList to JSON string
//                infoStr1 = jsonString(from: zegoSendMicUsersList)
//                type = "test"
//
//
//            // Create a map with type as key and infoStr1 as value
//            var map: [String: String] = [:]
//            map[type] = infoStr1
//            map[type] = infoStr1
//
//            // Convert map to JSON string
//            let infoStr2 = jsonString(from: map)
//
//            // Set room extra info using the SDK
//            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in
//
//                    print(errorCode)
//                    print(errorCode.description)
//                    if errorCode == 0 {
//                     print("Successfully delete wala message bhej dia hai extra room info wale main pk publish view controller main..")
//                    } else {
//                        print("Message abhi group mai shi se nahi gya hai room extra info wala pk publish view controller main..")
//                    }
//                })
        

//                // Access and modify the data inside the JSON object
//                if let coHostAudioStatus = jsonObject["coHostAudioStatus"] as? String? {
//                    print("Original coHostAudioStatus: \(coHostAudioStatus ?? "")")
//                    jsonObject["coHostAudioStatus"] = value

//                } else {
//                    print("coHostAudioStatus not found in JSON object")
//                }

//    func muteLiveCoHost(userid: String, value: String) {
//        print("The id we are getting in mute/unmute function for unmute is: \(userid)")
//
//        print("The zegosendmic users list is: \(zegoSendMicUsersList)")
//        if zegoSendMicUsersList.contains(where: { $0.key == userid }) {
//            print("ID exists in zegoSendMicUsersList")
//
//            if let jsonString = zegoSendMicUsersList[userid],
//               let data = jsonString.data(using: .utf8),
//               var jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//
//                // Access and modify the data inside the JSON object
//                if let coHostUserStatus = jsonObject["coHostAudioStatus"] as? String {
//                    print("Original coHostAudioStatus: \(coHostUserStatus)")
//                    jsonObject["coHostAudioStatus"] = value//"mute"  // Update the value of "coHostUserStatus"
//                    if (value.lowercased() == "mute") {
//                        jsonObject["isHostMuted"] = "true"
//                    } else {
//                        jsonObject["isHostMuted"] = "false"
//                    }
//                    jsonObject["type"] = "pk_start"
//
//                } else {
//                    print("coHostUserStatus not found in JSON object")
//                    jsonObject["coHostAudioStatus"] = value//"mute"
//                    if (value.lowercased() == "mute") {
//                        jsonObject["isHostMuted"] = "true"
//                    } else {
//                        jsonObject["isHostMuted"] = "false"
//                    }
//                    jsonObject["type"] = "pk_start"
//                }
//
//
//
//                                // Convert the updated JSON object back to a string
//                                    if let updatedJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
//                                       let updatedJsonString = String(data: updatedJsonData, encoding: .utf8) {
//
//                                        // Update the value in zegoSendMicUsersList with the updated JSON string
//                                        zegoSendMicUsersList[userid] = updatedJsonString
//                                        print("Updated User Data: \(updatedJsonString)")
//                                    } else {
//                                        print("Error converting JSON object to string")
//                                    }
//
//                            } else {
//                                print("User ID \(userid) not found in zegoSendMicUsersList or data is not a valid JSON string")
//                            }
//
//                            print("The zegosendmicusers list before sending is: \(zegoSendMicUsersList)")
//
//                            // Prepare the map
//                            let coHostInfoStr = jsonString(from: zegoSendMicUsersList)
//
//                            let map: [String: String] = ["coHost123": coHostInfoStr]
//
//                            print("The map in pk is: \(map)")
//
//                            let infoMap = jsonString(from: map)
//
//                            print("THe infomap in pk is: \(infoMap)")
//
//                            // Prepare the final JSON
//                            let pkHostMap: [String: Any] = [
//                                "pkHost": infoMap //map//infoMap//map
//                            ]
//
//                            print("The pkHostMap in pk is: \(pkHostMap)")
//
//                            // Convert pkHostMap to JSON string
//                            let infoStr = jsonString(from: pkHostMap)
//
//                            let finalString = jsonString(from: infoStr)
//                            print("The final string is: \(finalString)")
//
//                            print("The information we are sending for mute/unmute mic in pk is: \(infoStr)")
//
//                            // Set room extra info using the SDK
//                            ZegoExpressEngine.shared().setRoomExtraInfo(finalString, forKey: "SYC_USER_INFO", roomID: channelName) { errorCode in
//                                print(errorCode)
//                                print(errorCode.description)
//                                if errorCode == 0 {
//                                    print("Successfully sent extra room info.")
//                                } else {
//                                    print("Failed to send extra room info.")
//                                }
//                            }
//            }
//
//        print("The changed zegoSendMicUsersList are: \(zegoSendMicUsersList)")
//    }
