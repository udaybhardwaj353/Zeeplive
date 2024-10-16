//
//  NewPublishStreamViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 27/06/24.
//

import UIKit
import ImSDK_Plus
import RealmSwift
import ZegoExpressEngine
import FirebaseDatabase
import FittedSheets

class NewPublishStreamViewController: UIViewController, ZegoEventHandler, V2TIMConversationListener {

    @IBOutlet weak var tblView: UITableView!
    
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

    lazy var dailyEarningBeans: String = ""
    lazy var weeklyEarningBeans:String = ""
    lazy var hostFollowed: Int = 0
    lazy var callMemberList: Bool = false
    lazy var page = 1
    lazy var currentIndex = 0
    lazy var newIndex = 0
    lazy var previousIndex: Int = 0
    lazy var vcAudiencePresent:Bool = false
    lazy var groupID: String = ""
    lazy var liveMessage = liveMessageModel()
    lazy var luckyGiftCount = 0
    lazy var uniqueID: Int = 0
    lazy var channelName: String = ""
    lazy var userId: String = ""
    lazy var zegoSendMicUsersList: [String: String] = [:]
    lazy var messageListener = MessageListener()
    lazy var coHostRequestList: [getCoHostInviteUsersDetail] = []
    lazy var pkRequestsHostList: [getPKRequestHostsModel] = []
    lazy var pkRequestHostDetail = getPKRequestHostsModel()
    lazy var zegoMicUsersList: [getZegoMicUserListModel] = []
    lazy var zegoOpponentMicUsersList: [getZegoMicUserListModel] = []
    lazy var streamName: String = ""
    lazy var taskID: String = ""
    lazy var isFirstTime: Bool = true
    lazy var secondRoom: String = ""
    
    var isPK: Bool = false
    var leftSwipeGesture: UISwipeGestureRecognizer!
    var rightSwipeGesture: UISwipeGestureRecognizer!
    var userInfoList: [V2TIMUserFullInfo]?
    var userRankHandle: DatabaseHandle?
    var userDailyEarningHandle: DatabaseHandle?
    var HostMicRequestHandle:DatabaseHandle?
    var pkRequestHandle:DatabaseHandle?
    weak var sheetController:SheetViewController!
    
    let realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        tableViewWork()
        removePKRequestOnFirebase()
        removeCoHostInviteDetailsOnFirebase()
        removeCoHostInviteListOnFirebase()
        createLiveBroadcast()
        getGroupCallBack()
        addObserverForPKRequest()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // createEngine()
        
        if (isFirstTime == true) {
            print("YE sb kch kaam nahi karana hai.")
        } else {
            print("YE sab kaam karana hai.")
            addUserOnMic()
            playStream()
            updateUserStatusToFirebase(status:"LIVE")
           // ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), status: "live")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        removeUserOnMic()
        stopStream()
        isFirstTime = false
        
    }
    
    func tableViewWork() {
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "NewPublishStreamLiveTableViewCell", bundle: nil), forCellReuseIdentifier: "NewPublishStreamLiveTableViewCell")
        tblView.contentInsetAdjustmentBehavior = .never;
        tblView.isScrollEnabled = false
        
    }
    
    
    func tencentWork() {
    
        V2TIMManager.sharedInstance()?.setConversationListener(self)
        V2TIMManager.sharedInstance().addGroupListener(listener: messageListener)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMessagePushNotification(_:)),
                                               name: Notification.Name("BroadTencentMessage"),
                                               object: nil)
        getGroupCallBack()
    }
    
    func addSwipeGestures() {
    
        leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
       leftSwipeGesture.cancelsTouchesInView = false
          leftSwipeGesture.direction = .left
          tblView.addGestureRecognizer(leftSwipeGesture)

           rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
       rightSwipeGesture.cancelsTouchesInView = false
          rightSwipeGesture.direction = .right
          tblView.addGestureRecognizer(rightSwipeGesture)
        
    }
    
    func removeSwipeGestures() {
        if let leftSwipeGesture = leftSwipeGesture, let rightSwipeGesture = rightSwipeGesture,
           leftSwipeGesture is UISwipeGestureRecognizer, rightSwipeGesture is UISwipeGestureRecognizer {
            // Remove the gesture recognizers
            DispatchQueue.main.async {
                self.tblView?.removeGestureRecognizer(leftSwipeGesture)
                self.tblView?.removeGestureRecognizer(rightSwipeGesture)
            }
        } else {
            // Handle case where gesture recognizers are not valid or of the wrong type
            print("Invalid or incorrect gesture recognizers.")
        }

    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            // Handle left swipe
            print("Left swipe detected")
            if (isPK == true) {
                print("PK chal rha hai abhi kuch nahi krenge swipe par")
            } else {
                print("Abhi live chal rha hai. Swipe wala kaam kraenge. ")
                guard let cell = tblView?.visibleCells[0] as? NewPublishStreamLiveTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
             //   cell.hostFollow = hostFollowed
              //  cell.unhideViews()
             //   cell.unhideViewsOnSwipe()
            }
        } else if gesture.direction == .right {
            // Handle right swipe
            print("Right swipe detected")
            if (isPK == true) {
                print("Abhi PK chal rha hai. abhi hum kuch nahi kraenge.")
            } else {
                print("Abhi Live Chal Raha hai. abhi Swipe wala kaam kraenge.")
                guard let cell = tblView?.visibleCells[0] as? NewPublishStreamLiveTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
               // cell.hideViews()
               // cell.hideViewsOnSwipe()
            }
        }
    }
    
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
        
        videoConfig.fps = 30
        videoConfig.bitrate = 2400;
        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
        
        ZegoExpressEngine.shared().setVideoMirrorMode(videoMirrorMode)
        
        // Ensure the table view and visible cells exist
           guard let tableView = tblView else {
               NSLog(" 🚫 Table view is nil")
               return
           }
           
           let visibleCells = tableView.visibleCells
           guard !visibleCells.isEmpty else {
               NSLog(" 🚫 No visible cells in table view")
               return
           }
           
           // Safely get the first visible cell and cast it to NewPublishStreamLiveTableViewCell
           guard let cell = visibleCells[0] as? NewPublishStreamLiveTableViewCell else {
               NSLog(" 🚫 Visible cell is not of type NewPublishStreamLiveTableViewCell")
               return
           }
        
        previewCanvas.view = cell.viewMain
        previewCanvas.viewMode = previewViewMode
        
        NSLog(" 🔌 Start preview")
        ZegoExpressEngine.shared().startPreview(previewCanvas)
        
    }
    
// MARK: - FUNCTION TO START LIVE AND PUBLISH STREAM
    
    func startLive(roomID: String, streamID: String) {
        NSLog(" 🚪 Start login room, roomID: \(roomID)")
        
        let config = ZegoRoomConfig()
//        config.token = KeyCenter.token
        config.isUserStatusNotify = true
        
        print("The room id to login in host is: \(roomID)")
        print("The stream id in host is: \(streamID)")
        
        ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), config: config)
        
        NSLog(" 📤 Start publishing stream, streamID: \(streamID)")
        ZegoExpressEngine.shared().startPublishingStream(streamID)
        
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
    
    func getGroupCallBack() {
        
        messageListener.groupUserEnter = { [weak self] msgID, text in
            guard let self = self else { return }
            
            print(msgID)
            print(text)
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
    
    func removeListeners() {
        
        messageListener.groupUserEnter = nil
        messageListener.groupUserLeave = nil
        
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
                    self.getUsersInformation(list: Array(Set(userIds)) as? [String] ?? [])
                } else {
                    // Handle the case where userIds is empty
                    print("No user IDs found in the memberList.")
                }
            }
            
            if (isPK == true) {
                
                guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                cell.lblBroadViewCount.text = String(memberList?.count ?? 0)
                
            } else {
                
                guard let cell = self.tblView?.visibleCells[0] as? NewPublishStreamLiveTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                cell.lblViewersCount.text = String(memberList?.count ?? 0)
            }
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
            guard let self = self else { return }
            guard let profiles = profiles else { return }
            print("The data in the profile is: \(profiles)")
            print("Member Details count is: \(profiles.count)")
            // groupJoinUsers.removeAll()
            userInfoList?.removeAll()
            userInfoList = profiles
            print("The UserInfoList counts are: \(userInfoList?.count)")

            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let userInfoList = self.userInfoList {
                        if isPK == true {
                            guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else { return }
                            cell.showJoinedUser(users: userInfoList)
                            if self.vcAudiencePresent {
                                print("Controller khula hua hai")
                                NotificationCenter.default.post(name: Notification.Name("groupJoinUsersUpdated"), object: userInfoList)
                            } else {
                                print("Controller bnd hai")
                               // NotificationCenter.default.removeObserver(self)
                                NotificationCenter.default.removeObserver(self, name: Notification.Name("groupJoinUsersUpdated"), object: nil)
                            }
                        } else {
                            guard let cell = self.tblView?.visibleCells[0] as? NewPublishStreamLiveTableViewCell else { return }
                            cell.showJoinedUser(users: userInfoList)
                            if self.vcAudiencePresent {
                                print("Controller khula hua hai")
                                NotificationCenter.default.post(name: Notification.Name("groupJoinUsersUpdated"), object: userInfoList)
                            } else {
                                print("Controller bnd hai")
                              //  NotificationCenter.default.removeObserver(self)
                                NotificationCenter.default.removeObserver(self, name: Notification.Name("groupJoinUsersUpdated"), object: nil)
                            }
                        }
                    }
                }
            }
            self.callMemberList = true
        }, fail: { code, desc in
            // Failed to obtain
            print("Failed to obtain group members. Code: \(code), Description: \(desc)")
            self.callMemberList = true
        })

    }

    
    func joinGroup(id:String) {
        
        if (isPK == true) {
            
            guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                return
            }
            
            if previousIndex != currentIndex {
                
                cell.groupUsers.removeAll()
                cell.collectionView.reloadData()
                
            }
            
        } else {
            
            guard let cell = self.tblView?.visibleCells[0] as? NewPublishStreamLiveTableViewCell else {
                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                return
            }
            
            if previousIndex != currentIndex {
                
                cell.groupUsers.removeAll()
                cell.collectionViewBroadList.reloadData()
                
            }
        }
     //   groupJoinUsers.removeAll()
        userInfoList?.removeAll()
        
        print("Group se jo id bhejni hai woh hai: \(id)")
        // Join a group
        V2TIMManager.sharedInstance().joinGroup(id, msg: "", succ: {
            // Joined the group successfully
            print("Group Join Login Success")
       
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }

                self.getGroupMemberList()
                // self.getGroupCallBack() // Uncomment if needed
                self.callMemberList = true
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
        
            if (isPK == true) {
               
                print("PK wale cell main data dikhana hai.")
                guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                cell.insertNewMsgs(msgs: liveMessage)
                cell.tblViewLiveMessages.reloadData()
                
            } else {
            
                print("Live wale cell main data dikhana hai.")
                
                guard let cell = self.tblView?.visibleCells[0] as? NewPublishStreamLiveTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                cell.insertNewMsgs(msgs: liveMessage)
                cell.tblViewLiveMessage.reloadData()
            }
            
        } else if (liveMessage.type == "4") || (liveMessage.type == "5"){
            
            if (isPK == true) {
                
                guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                cell.insertUserName(name: liveMessage.userName ?? "N/A", status: liveMessage.type ?? "N/A")
                
            } else {
                
                guard let cell = self.tblView?.visibleCells[0] as? NewPublishStreamLiveTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                cell.insertUserName(name: liveMessage.userName ?? "N/A", status: liveMessage.type ?? "N/A")
                
            }
            
        } else if (liveMessage.type == "2") {
            
            if (isPK == true) {
                
                print("PK wale view controller main gift play wala kaam kraenge.")
                
                guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
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
                    
                    cell.insertNewMsgs(msgs: liveMessage)
                    cell.tblViewLiveMessages.reloadData()
                    
                    cell.viewLuckyGift.isHidden = false
                    shakeAnimation(for: cell.viewGiftImage)
                    hideViewAfterDelay(viewToHide: cell.viewLuckyGift, duration: 0.48) {
                        // This block will be executed when the animation is finished
                        print("Animation finished!")
                        cell.viewLuckyGift.isHidden = true
                        
                    }
                    
                    cell.lblNoOfGift.text =  "X" + " " + String(giftDetails["count"] as? Int ?? 1)
                    cell.lblSendGiftHostName.text = liveMessage.sendGiftTo ?? ""
                    
                    loadImage(from: giftDetails["icon"] as? String ?? "", into: cell.imgViewGift)
                    loadImage(from: giftDetails["fromHeader"] as? String ?? "", into: cell.imgViewUser)
                    
                    
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
                
            } else {
                
                guard let cell = self.tblView?.visibleCells[0] as? NewPublishStreamLiveTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                print("Live wale view controller main gift play wala kaam kraenge.")
                
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
                    
                    cell.insertNewMsgs(msgs: liveMessage)
                    cell.tblViewLiveMessage.reloadData()
                    
                    cell.viewLuckyGift.isHidden = false
                    shakeAnimation(for: cell.viewGiftImage)
                    hideViewAfterDelay(viewToHide: cell.viewLuckyGift, duration: 0.24) {
                        // This block will be executed when the animation is finished
                        print("Animation finished!")
                        cell.viewLuckyGift.isHidden = true
                        
                    }
                    
                    cell.lblNoOfGift.text =  "X" + " " + String(giftDetails["count"] as? Int ?? 1)
                    cell.lblSendGiftHostName.text = liveMessage.sendGiftTo ?? ""
                    
                    loadImage(from: giftDetails["icon"] as? String ?? "", into: cell.imgViewGift)
                    loadImage(from: giftDetails["fromHeader"] as? String ?? "", into: cell.imgViewUser)
                    
                    
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
    
}

extension NewPublishStreamViewController {
    
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

// MARK: - EXTENSION FOR UPDATING USER STATUS DETAILS ON THE ON THE FIREBASE

extension NewPublishStreamViewController {
    
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
        
        let nodeName =  ZLFireBaseManager.share.messageRef.childByAutoId().key ?? generateRandomString(length: 20)

        ZLFireBaseManager.share.messageRef.child("message").child(String(format: "%d", uniqueID ?? 0)).child(nodeName).setValue(dic) { [weak self] (error, reference) in
            
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

// MARK - Function to update user Information on Firebase that he has started the live
    
    func updateUserStatusToFirebase(status:String = "LIVE") {
        
        let gender = UserDefaults.standard.string(forKey: "gender")
        var dic = [String: Any]()
        
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
                    //    lblViewRewardRank.text = "Weekly" + " " + String(count)
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
                 //   lblViewRewardRank.text = "Daily" + " " + String(count)
                    dailyEarningBeans = String(count)
                    
                } else {
                    
                    print("value['count'] is not an integer")
                   // lblViewRewardRank.text = "Daily"
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
            //    collectionViewJoinMic.reloadData()
                
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
    
    func setRoomExtraInfo(from:String) {
        
        if (from == "close") {
            
            var map = [String: Any]()
            map["coHostID"] = userId
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: map, options: [])
                if let infoStr = String(data: jsonData, encoding: .utf8) {
                    ZegoExpressEngine.shared().setRoomExtraInfo(infoStr, forKey: "SYC_USER_INFO", roomID: channelName, callback: { errorCode in
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
                     print("Successfully delete wala message bhej dia hai extra room info wale main.")
                    } else {
                        print("Message abhi group mai shi se nahi gya hai room extra info wala.")
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
        
        
//        guard let hostid = id else {  // usersList.data?[currentIndex].profileID
//            // Handle the case where currentUserProfileID is nil
//            return
//        }
        
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
                                  let pkID = userDetails["pk_id"] as? String
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
                         // tblViewPKRequest.reloadData()
                      }
                  } catch {
                      print("Failed to parse JSON: \(error.localizedDescription)")
                  }
                
            }
        }
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM THE SERVER AND CREATING ENGINE FOR GOING LIVE

extension NewPublishStreamViewController {
    
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
                    createEngine()
                    updateUserBroadStatus()
                    updateUserStatusToFirebase(status:"LIVE")
                    startLive(roomID: channelName, streamID: streamName)
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
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS AND THEIR WORKING

extension NewPublishStreamViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewPublishStreamLiveTableViewCell", for: indexPath) as! NewPublishStreamLiveTableViewCell
            
            let profilePic = UserDefaults.standard.string(forKey: "profilePicture") ?? ""
        
            cell.lblHostName.text =  UserDefaults.standard.string(forKey: "UserName") ?? "N/A"
            cell.loadImageForCell(from: profilePic, into: cell.imgViewUserProfilePhoto)
        
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
        return UIScreen.main.bounds.size.height + 10 //self.tblView.frame.height
        
    }
    
}

extension NewPublishStreamViewController: delegateNewPublishStreamLiveTableViewCell, delegateCommonPopUpViewController, delegateJoinedAudienceListViewController, delegateJoinedAudienceDetailsViewController, delegateGamesOptionInBroadViewController, delegateJoinMicUserOptionsViewController, delegateBottomWebViewViewController {
    
    func giftButton(isPressed: Bool) {
        
        print("View Send Gift Pressed by Host")
        
    }
    
    func userDetailsPressed(selectedIndex: Int) {
        
        print("View User Details Pressed")
        
    }
    
    func closeBroad(isPressed: Bool) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
        nextViewController.delegate = self
        nextViewController.headingText = "Are you sure you want to close?"
        nextViewController.buttonName = "Close"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func distributionClicked(openWebView: Bool) {
        
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
    
    func viewRewardClicked(isClicked: Bool) {
        
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
    
    func buttonAudienceList(isClicked: Bool) {
        
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
    
    func cellIndexClicked(index: Int) {
        
        print("The index when clicking on the collection view cell is: \(index)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        if let selectedUser = userInfoList?[index] {
            nextViewController.broadGroupJoinuser = selectedUser
        } else {
            print("broad join user ki array khali hai")
            // Handle the case where userInfoList or the selected user is nil
        }
        
        nextViewController.delegate = self
        nextViewController.hostFollowed = hostFollowed
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func messageClicked(userImage: String, userName: String, userLevel: String, userID: String) {
        
        print("The message user image is: \(userImage)")
        print("The message user name is: \(userName)")
        print("The message user level is: \(userLevel)")
        print("The message user id is: \(userID)")
        
        var user = joinedGroupUserProfile()
        
        user.userID = userID
        user.nickName = userName
        user.faceURL = userImage
        user.richLevel = userLevel
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        nextViewController.messageDetails = user
        nextViewController.delegate = self
        nextViewController.viewFrom = "message"
        nextViewController.hostFollowed = hostFollowed
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func gameButtonClicked(isClicked: Bool) {
        
        print("The game button is clicked: \(isClicked)")
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
    
    func micJoinedUserClicked(userID: String, userName: String, userImage: String) {
        
        print("The join mic user id is: \(userID)")
        print("The join mic user name is: \(userName)")
        print("The join mic user image is: \(userImage)")
        
        guard let userid = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The user id in join mic comparison is: \(userid)")
        
        if (userID == userid) {
            
            print("User ne broad join kiya hua hai.")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinMicUserOptionsViewController") as! JoinMicUserOptionsViewController
            nextViewController.cameFrom = "user"
            nextViewController.userName = userName
            nextViewController.userImage = userImage
            nextViewController.delegate = self
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
            
        } else {
            
            var user = joinedGroupUserProfile()
            
            user.userID = userID
            user.nickName = userName
            user.faceURL = userImage
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.hostFollowed = hostFollowed
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
            
        }
        
    }
    
    func buttonOneToOneCallPressed(isPressed: Bool) {
        
        print("Button One To One Call With Host Pressed ")
        
    }
    
    func buttonFollowPressed(isPressed: Bool) {
        
        print("Follow host button pressed.")
        
    }
    
    func buttonJoinMicPressed(isPressed: Bool) {
        
        print("Button Join Mic Pressed in Live Publish Broad.")
        
    }
    
    func buttonMicPressed(isPressed: Bool) {
        
        print("Button TO MUTE/UNMUTE SPEAKER WHILE LISTENING TO BROAD IS PRESSED")
        if (isPressed == true) {
            print("Speaker Ko unMute kar dena hai.")
            ZegoExpressEngine.shared().muteSpeaker(false)
        } else {
            print("Speaker ko Mute kar dena hai.")
            ZegoExpressEngine.shared().muteSpeaker(true)
        }
        
    }
    
    func muteMic(isPressed: String) {
        
        print("The button to mute the mic by the user is pressedd.")
        
    }
    
    func deleteButtonPressed(isPressed: Bool) {
        
        removePKRequestOnFirebase()
        setRoomExtraInfo(from: "close")
        removeCoHostInviteDetailsOnFirebase()
        removeCoHostInviteListOnFirebase()
        endLiveBroadcast()
        sendMessageToExitUserFromBroad()
        stopPublishingStream()
        stopLive(roomID: channelName)
        destroyEngine()
        updateUserStatusToFirebaseExit()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func sendMessageToExitUserFromBroad() {
        let dictionary: [String: Any] = ["action_type": "kickout_all_user_from_app"]
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary),
           let convertedString = String(data: jsonData, encoding: .utf8) {
            print(convertedString)
            //    ZegoExpressEngine.shared().sendBarrageMessage(convertedString, roomID: "123456")
            ZegoExpressEngine.shared().sendBarrageMessage(convertedString, roomID: channelName)
            print("Message bheja hai dheere se nikal lo tum .. bhut hua....")
        }
    }
    
    func userData(selectedUserIndex: Int) {
        
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
        nextViewController.hostFollowed = hostFollowed
        nextViewController.modalPresentationStyle = .overCurrentContext

        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func leaveMicPressed(isPressed: Bool) {
        print("Leave Mic is pressed in the Watching Broad Page. For Leaving the join mic.")
       
    }
    
    func muteMicPressed(isPressed: Bool) {
        
        print("Mute mic pressed in the Watching Broad Page. ")
    }
    
    func openProfileDetails(isPressed: Bool) {
        
        print("Open Profile Details in the watching Broad Page.")
        
    }
    
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
    
    func viewProfileDetails(isClicked: Bool, userID: String) {
        
        print("User ki profile details wala page kholna hai.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController

        nextViewController.userID = userID
        nextViewController.callForProfileId = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
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
    
}
