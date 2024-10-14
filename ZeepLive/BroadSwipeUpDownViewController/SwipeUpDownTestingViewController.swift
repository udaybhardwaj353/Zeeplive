//
//  SwipeUpDownTestingViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 08/01/24.
//

import UIKit
import ZegoExpressEngine
import Kingfisher
import FittedSheets
import FirebaseDatabase
import ImSDK_Plus
import SwiftyJSON
import RealmSwift
import ToastViewSwift

class SwipeUpDownTestingViewController: UIViewController, V2TIMConversationListener, delegateCommonPopUpViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    var page = 1
    var currentIndex = 0
    var newIndex = 0
    var tableData : NSMutableArray = []
    let offsetY =  100
    var currentTime : Int?
    lazy var playViewMode = ZegoViewMode.aspectFill
    lazy var playCanvas = ZegoCanvas()
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    lazy var usersList = ListResult()
    lazy var pageNo: Int = 1
    lazy var lastPage: Int = 1
    lazy var room = String()
    lazy var broad = String()
    lazy var apiType: String = ""
    
    @IBOutlet weak var btnExitLiveOutlet: UIButton!
    weak var sheetController:SheetViewController!
    var userStatusHandle: DatabaseHandle?
    var userMessageHandle: DatabaseHandle?
    var userRankHandle: DatabaseHandle?
    var userDailyEarningHandle: DatabaseHandle?
    lazy var luckyGiftId: Int = 0
    lazy var luckyGiftCount = 0
    var previousIndex: Int = 0
    var liveMessage = liveMessageModel()
    lazy var messageListener = MessageListener()
    var broadGroupJoinuser = joinedGroupUserProfile()
    //  var groupJoinUsers: [joinedGroupUserProfile] = []
    lazy var callMemberList: Bool = false
    lazy var vcAudiencePresent:Bool = false
    //lazy var vc = JoinedAudienceListViewController()
    var selectedIndexForProfileDetails = Int()
    lazy var dailyEarningBeans: String = "Daily"
    lazy var weeklyEarningBeans:String = "Weekly"
    var isLiveStarted:Bool = true
    var userInfoList: [V2TIMUserFullInfo]?
    var isPK: Bool = false
    var secondBroad = String()
    lazy var opponentProfileID: String = ""
    lazy var opponentName: String = "N/A"
    lazy var opponentProfileImage: String = ""
    lazy var opponentLevel: String = ""
    lazy var isTableViewReloadedForPK: Bool = false
    
    // Variables for pk gift sending check
    lazy var giftFirstUserID: Int = 0
    lazy var giftSecondUserID: Int = 0
    lazy var giftThirdUserID: Int = 0
    lazy var giftFirstUserTotalAmount: Int = 0
    lazy var giftSecondUserTotalAmount: Int = 0
    lazy var giftThirdUserTotalAmount: Int = 0
    lazy var pkUserTotalGiftCoins: Int = 0
    lazy var pkUserOpponentTotalGiftCoins: Int = 0
    lazy var zegoMicUsersList: [getZegoMicUserListModel] = []
    var micUser = getZegoMicUserListModel()
    lazy var pkGiftList: [pkUsersGiftModel] = []
    var pkUserGiftDetail = pkUsersGiftModel()
    lazy var pkOpponentGiftList: [pkUsersGiftModel] = []
    lazy var secondRoom = String()
    lazy var zegoOpponentMicUsersList: [getZegoMicUserListModel] = []
    lazy var hostFollowed: Int = 0
    lazy var malePointsData = MaleBalance()
    lazy var femalePointsData = FemaleBalance()
    lazy var OneToOneCallData = GetOneToOneNotificationDataResult()
    var leftSwipeGesture: UISwipeGestureRecognizer!
    var rightSwipeGesture: UISwipeGestureRecognizer!
    let realm = try? Realm()
    var userMicRequestHandle:DatabaseHandle?
    lazy var zegoSendMicUsersList: [String: String] = [:]
    lazy var hasJoinedMic: Bool = false
    lazy var isMutedByHost: Bool = false
    lazy var userID: String = ""
    lazy var isFirstTime: Bool = true
    lazy var oneToOneUniqueID: String = ""
    lazy var callRate: String = "0"
    lazy var isOneToOneStarted: Bool = false
    lazy var opponentGroupId: String = ""
    
//    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   ZegoExpressEngine.shared().muteSpeaker(true)
        
        V2TIMManager.sharedInstance()?.setConversationListener(self)
       
        
        tabBarController?.tabBar.isHidden = true
        
        print("Swipe updown wla view controller khul gaya hai.")
        print("The pageNo we have is: \(pageNo)")
        
      //  checkForFollow()
        V2TIMManager.sharedInstance().addGroupListener(listener: messageListener)
        // joinGroup(id:usersList.data?[currentIndex].groupID ?? "")
        self.getGroupCallBack()
        print("THe store data count is: \(SettingsManager.shared.storeSettingResponse?.count)")
        createEngine()
        addSwipeGestures()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMessagePushNotification(_:)),
                                               name: Notification.Name("BroadTencentMessage"),
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        checkForFollow()
        
        let safeAreaInsets = view.safeAreaInsets
            print("Safe area insets - Top: \(safeAreaInsets.top), Bottom: \(safeAreaInsets.bottom), Left: \(safeAreaInsets.left), Right: \(safeAreaInsets.right)")
        
        btnExitLiveOutlet.isHidden = true
        
        print("The selected current index is: \(currentIndex)")
        viewTop.isHidden = true
        
        //        room = (usersList.data?[currentIndex].broadChannelName ?? "")
        //        room = (usersList.data?[currentIndex].broadChanneldidName ?? "")
        //        broad = (usersList.data?[currentIndex].broadChannelName)! + "_stream"
        
        tblView.contentInsetAdjustmentBehavior = .never;
        tblView?.dataSource = self
        tblView?.delegate = self
        tblView?.register(UINib(nibName: "LiveRoomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveRoomCellTableViewCell")
        tblView?.register(UINib(nibName: "PKViewTableViewCell", bundle: nil), forCellReuseIdentifier: "PKViewTableViewCell")
        //  tblView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchTap)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchTap))
        tapGesture.cancelsTouchesInView = false
        tblView.addGestureRecognizer(tapGesture)
        
        let index = IndexPath(row: currentIndex, section: 0)
        
        tblView?.scrollToRow(at: index , at: UITableView.ScrollPosition.top, animated: false)
        
        let check = checkToAddMessageObserver()
        if check {
            
            print("Message observer add mat karo ")
            
        } else {
            
            print("Message observer add karo")
            addObserve(id: usersList.data?[currentIndex].profileID ?? 0)
            let userIdToCheck = String(usersList.data?[currentIndex].profileID ?? 0)
            let userFollow = GlobalClass.sharedInstance.isUserFollowed(userIdToCheck: userIdToCheck)
            print("User with ID \(userIdToCheck) is followed: \(userFollow)")
            
            if (userFollow == true) {
                hostFollowed = 1
                print("User isko follow karta hai.")
            } else {
                
                checkForFollow()
            }
        }
        
        if (isFirstTime == true) {
            print("YE sb kch kaam nahi karana hai.")
        } else {
            print("YE sab kaam karana hai.")
          //  createEngine()
            addUserOnMic()
            playStream()
        }
        
        if (isOneToOneStarted == true) {
            
            createEngine()
            addUserOnMic()
            playStream()
            joinGroup(id: usersList.data?[currentIndex].groupID ?? "")
            
            isOneToOneStarted = false
            print("One to one start hua hai. isliye engine bnaenge hum.")
            
        } else {
            
            print("One to one start nahi hua hai. isliye engine nahi bnaenge phirse hum.")
            
        }
        
        tblView.setNeedsLayout()
        tblView.layoutIfNeeded()
        
//        // Add a tap gesture recognizer to the main view
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideSafeArea(_:)))
//            view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
//    @objc func handleTapOutsideSafeArea(_ gestureRecognizer: UITapGestureRecognizer) {
//        let tapLocation = gestureRecognizer.location(in: view)
//        let safeAreaInsets = view.safeAreaInsets
//        
//        // Check if the tap is outside the top safe area (above the safe area)
//        if tapLocation.y < safeAreaInsets.top {
//            // Disable table view scrolling if the tap is above the safe area
//            tblView.isScrollEnabled = false
//            print("Tap detected above the safe area. Disabling table view scrolling.")
//        } else {
//            // Re-enable table view scrolling for taps inside the safe area
//            tblView.isScrollEnabled = true
//            print("Tap detected inside the safe area. Enabling table view scrolling.")
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeUserOnMic()
        stopStream()
        isFirstTime = false
        
    }
    
    @objc func touchTap(tap : UITapGestureRecognizer){
        // view.endEditing(true)
        let tapLocation = tap.location(in: view)
        
        // Check if the tap is in the top half of the screen
        if tapLocation.y < view.frame.size.height / 2 {
            view.endEditing(true)
            // Handle tap in the top half of the screen
        } else {
            print("Neeche ki screen par tap hua hai")
            
            // Handle tap in the bottom half of the screen if needed
        }
        
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            // Handle left swipe
            print("Left swipe detected")
            if (isPK == true) {
                print("PK chal rha hai abhi kuch nahi krenge swipe par")
                guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                cell.hostFollow = hostFollowed
                cell.unhideViewsOnSwipe()
                
            } else {
                print("Abhi live chal rha hai. Swipe wala kaam kraenge. ")
                guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                cell.hostFollow = hostFollowed
              //  cell.unhideViews()
                cell.unhideViewsOnSwipe()
            }
        } else if gesture.direction == .right {
            // Handle right swipe
            print("Right swipe detected")
            if (isPK == true) {
                print("Abhi PK chal rha hai. abhi hum kuch nahi kraenge.")
               
                guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                cell.hostFollow = hostFollowed
                cell.hideViewsOnSwipe()
                
            } else {
                print("Abhi Live Chal Raha hai. abhi Swipe wala kaam kraenge.")
                guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
               // cell.hideViews()
                cell.hideViewsOnSwipe()
            }
        }
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
                
                guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
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
                
                guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
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
                
                guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
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



    
    @IBAction func btnExitLivePressed(_ sender: Any) {
        
        print("exit live broad button pressed")
        NSLog(" 🚪 Logout room")
        ZegoExpressEngine.shared().logoutRoom()
        ZegoExpressEngine.destroy(nil)
        removeMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
        quitgroup(id: usersList.data?[currentIndex].groupID ?? "")
        
    }
    
    @IBAction func btnbackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        ZegoExpressEngine.shared().logoutRoom()
        ZegoExpressEngine.destroy(nil)
        self.navigationController?.popViewController(animated: true)
        removeMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
        quitgroup(id: usersList.data?[currentIndex].groupID ?? "")
        
    }
    
    // MARK: - FUNCTION TO ADD USERS WHO ARE SITTING ON THE MIC AND PLAYING THEIR STREAM
    
    func addUserOnMic() {
        
        if (zegoMicUsersList.count == 0) {
            print("Kuch remove karne ke jarurat nahi hai.")
        } else {
            // Iterate over each element in the zegoMicUsersList array
            zegoMicUsersList.forEach { micUser in
                // Construct the stream ID
                let streamID = room + micUser.coHostID! + "_cohost_stream"
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
                let streamID = secondRoom + micUser.coHostID! + "_cohost_stream"
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
                let streamID = room + micUser.coHostID! + "_cohost_stream"
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
        
        if (isPK == true) {
            
//            ZegoExpressEngine.shared().stopPlayingStream(broad)
//            ZegoExpressEngine.shared().stopPlayingStream(secondBroad)
            stopPlayingStream(streamID: broad)
            stopPlayingStream(streamID: secondBroad)
             
            
            
        } else {
            
//            ZegoExpressEngine.shared().logoutRoom()
//            ZegoExpressEngine.shared().stopPlayingStream(broad)
            stopPlayingStream(streamID: broad)
        }
        
    }
    
    func playStream() {
        
        if (isPK == true) {
            
//            ZegoExpressEngine.shared().startPlayingStream(broad)
//            ZegoExpressEngine.shared().startPlayingStream(secondBroad)
            
            startLive(roomID: room, streamID: broad)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.startLive(roomID: self.secondRoom, streamID: self.secondBroad)
               }
            
        } else {
            ZegoExpressEngine.shared().logoutRoom()
            startLive(roomID: room, streamID: broad)
           // ZegoExpressEngine.shared().startPlayingStream(broad)
            
        }
        
    }
// MARK: - SCROLL VIEW SWIPE UP AND DOWN FUNCTIONALITY FUNCTION WORKING
   
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("Scroll view scrolled to top.")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      //  adjustScrollViewInsets()
        if scrollView.contentOffset.y < 0 {
            print("Scroll view is at the top.")
        } else {
            print("Scroll view is scrolling.")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Scroll view will begin dragging to top.")
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        print("scroll view should scroll to top function called.")
        return false
        
    }
    func adjustScrollViewInsets() {
        tblView.contentInsetAdjustmentBehavior = .never
        
    }

    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("Scroll view did scroll to top.")
//    }
    

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            self.previousIndex = self.currentIndex
            
            var isRun = false
            if translatedPoint.y < CGFloat(-offsetY) && self.currentIndex < (self.usersList.data!.count - 1) {
                self.currentIndex += 1
                NSLog("向下滑动索引递增")
                print("after translating it means Index increases as you scroll down.")
                isRun = true
                self.newIndex = self.currentIndex + 1
                print("The new index here jab scroll upar ki trf karenge tb hai: \(self.newIndex)")
            }
            
            if translatedPoint.y > CGFloat(offsetY) && self.currentIndex > 0 {
                self.currentIndex -= 1
                self.newIndex = self.currentIndex - 1
                NSLog("向上滑动索引递减")
                print("After translating it means Index decreases as you scroll up.")
                isRun = true
                print("The new index jab scroll neeche ki trf karenge tab hai: \(self.newIndex)")
            }
            
            if self.usersList.data!.count > 0 {
                UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
                    guard let self = self else { return }
                    let index = IndexPath(row: self.currentIndex, section: 0)
                    self.tblView?.scrollToRow(at: index, at: .top, animated: false)
                    print("Yhn par table view ka scroll to row ka current index hai: \(index)")
                    print("Userdata ka jo index ki value hai woh hai: \(self.usersList.data?[self.currentIndex].id)")
                    
                } completion: { [weak self] finish in
                    guard let self = self else { return }
                    scrollView.panGestureRecognizer.isEnabled = true
                }
               // scrollView.panGestureRecognizer.isEnabled = true
                if isRun {
                    let userIdToCheck = String(usersList.data?[currentIndex].profileID ?? 0)
                    let userFollow = GlobalClass.sharedInstance.isUserFollowed(userIdToCheck: userIdToCheck)
                    print("User with ID \(userIdToCheck) is followed: \(userFollow)")
                    
                    if (userFollow == true) {
                        hostFollowed = 1
                        print("User isko follow karta hai.")
                    } else {
                        
                        checkForFollow()
                    }
                    
                    isMutedByHost = false
                    isTableViewReloadedForPK = false
                    isPK = false
                    tblView.reloadData()
                    
                    print("Jo prevvious index ka remove ho rha hai woh hai: \(previousIndex)")
                    print("Jo agle index ka add ho rh ahai woh hai: \(currentIndex)")
                    removeMessageObserver(id: usersList.data?[previousIndex].profileID ?? 0)
                    quitgroup(id: usersList.data?[previousIndex].groupID ?? "")
                    removeObserver(id: usersList.data?[previousIndex].profileID ?? 0)
                    addObserve(id: usersList.data?[currentIndex].profileID ?? 0)
                    removeObserverForRanking(id: usersList.data?[previousIndex].profileID ?? 0)
                    removeObserverForDailyEarning(id: usersList.data?[previousIndex].profileID ?? 0)
                    updateUserBroadStatus(profileID: usersList.data?[previousIndex].profileID ?? 0, type: "5")
                    removeUserOnMic()
                    zegoMicUsersList.removeAll()
                    zegoOpponentMicUsersList.removeAll()
                    zegoSendMicUsersList.removeAll()
                  //  removeSwipeGestures()
                    ZegoExpressEngine.shared().muteSpeaker(false)
                    quitgroup(id: opponentGroupId ?? "")
                    if let visibleCells = tblView?.visibleCells {
                                for cell in visibleCells {
                                    if let pkCell = cell as? PKViewTableViewCell {
                                        // Clear data specific to PKViewTableViewCell
                                        pkCell.clearData()
                                    }
                                }
                            }
                    
                    view.endEditing(true)
                    stopPlayingStream(streamID: broad)
                    isLiveStarted = true
                  
                    print("滑动完成")
                    print("The content view offset y is : \(scrollView.contentOffset.y)")
                    
                    print("After converted it means Slide Completed")
                    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
                        guard let self = self else { return }
                        let index = IndexPath(row: self.currentIndex, section: 0)
                        self.tblView?.scrollToRow(at: index, at: .top, animated: false)
                        print("Yhn par table view ka scroll to row ka current index hai: \(index)")
                        print("Userdata ka jo index ki value hai woh hai: \(self.usersList.data?[self.currentIndex].id)")
                    } completion: { [weak self] finish in
                        guard let self = self else { return }
                        scrollView.panGestureRecognizer.isEnabled = true
                    }
                }
            }
        }
    }

    func deleteButtonPressed(isPressed: Bool) {
        
        if (isPK == true) {
            
            if let visibleCells = tblView?.visibleCells {
                        for cell in visibleCells {
                            if let pkCell = cell as? PKViewTableViewCell {
                                // Clear data specific to PKViewTableViewCell
                                pkCell.clearData()
                            }
                        }
                    }
            
            ZegoExpressEngine.shared().logoutRoom()
            ZegoExpressEngine.destroy(nil)
            self.navigationController?.popViewController(animated: true)
            
            removeSwipeGestures()
            removeUserOnMic()
            removeListeners()
            removeMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
            quitgroup(id: usersList.data?[currentIndex].groupID ?? "")

            removeObserver(id: usersList.data?[currentIndex].profileID ?? 0)
            removeObserverForRanking(id: usersList.data?[currentIndex].profileID ?? 0)
            removeObserverForDailyEarning(id: usersList.data?[currentIndex].profileID ?? 0)
            updateUserBroadStatus(profileID: self.usersList.data?[currentIndex].profileID ?? 0, type: "5")
            
            NotificationCenter.default.removeObserver(self)
            callMemberList = false
            tblView = nil
          
            KingfisherManager.shared.cache.clearDiskCache()
            KingfisherManager.shared.cache.clearMemoryCache()
            V2TIMManager.sharedInstance().removeGroupListener(listener: messageListener)
            messageListener = MessageListener()
            
        } else {
        
            
            if (hasJoinedMic == true) {
                removeLiveAsCoHost()
                print("User ne mic join kiya hua hai host ka.")
            } else {
            
                print("User ne mic join nahi kiya hua hai host ka.")
                
            }
            
            ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), status: "gone")
            stopPublishCoHostStream()
            ZegoExpressEngine.shared().logoutRoom()
            ZegoExpressEngine.destroy(nil)
            self.navigationController?.popViewController(animated: true)
            
            removeSwipeGestures()
            removeUserOnMic()
            isPK = false
            removeListeners()
            removeMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
            quitgroup(id: usersList.data?[currentIndex].groupID ?? "")

            removeObserver(id: usersList.data?[currentIndex].profileID ?? 0)
            removeObserverForRanking(id: usersList.data?[currentIndex].profileID ?? 0)
            removeObserverForDailyEarning(id: usersList.data?[currentIndex].profileID ?? 0)
            updateUserBroadStatus(profileID: self.usersList.data?[currentIndex].profileID ?? 0, type: "5")
            
            NotificationCenter.default.removeObserver(self)
            callMemberList = false
            tblView = nil
            
            KingfisherManager.shared.cache.clearDiskCache()
            KingfisherManager.shared.cache.clearMemoryCache()
            V2TIMManager.sharedInstance().removeGroupListener(listener: messageListener)
            messageListener = MessageListener()
            
        }
        
    }
    
    deinit {
        
        print("Swipe up down main deinit call huya hai.")
        tblView?.delegate = nil
        tblView?.dataSource = nil
        tblView = nil
        view.subviews.forEach { $0.removeFromSuperview() }
        
        ZegoExpressEngine.shared().logoutRoom()
       // ZegoExpressEngine.destroy(nil)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("groupJoinUsersUpdated"), object: nil)
        callMemberList = false
        removeListeners()
        usersList.data?.removeAll()
        liveMessage = liveMessageModel()
        broadGroupJoinuser = joinedGroupUserProfile()
        sheetController = nil
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearCache() {
            // Completion block (optional)
            print("Saare cache clear hue hai")
        }
      //  ZegoExpressEngine.destroy()
    }
    
}

// MARK: - Extension for using Firebase Methods and functionality for further work

extension SwipeUpDownTestingViewController {
    
    func updateUserBroadStatus(profileID:Int, type:String = "4") {
        
        var dic = [String: Any]()
        dic["level"] = UserDefaults.standard.string(forKey: "level")
        dic["gender"] = UserDefaults.standard.string(forKey: "gender")
        dic["user_id"] = UserDefaults.standard.string(forKey: "UserProfileId")
        dic["user_name"] = UserDefaults.standard.string(forKey: "UserName")
        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
            dic["user_image"] = picM ?? ""
        }
        
        dic["type"] = type//"1"
        dic["message"] = ""
        dic["ownHost"] = true
        
        let nodeName =  ZLFireBaseManager.share.messageRef.childByAutoId().key ?? generateRandomString(length: 20)
        
        ZLFireBaseManager.share.messageRef.child("message").child(String(format: "%d", profileID ?? 0)).child(nodeName).setValue(dic) { [weak self] (error, reference) in
            
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
    
    func checkToAddMessageObserver() -> Bool {
        guard let userStatusHandle = userStatusHandle else {
            // Observer handle is nil, meaning there's no observer to remove
            return false
        }
        return true
    }
    
    func addObserve(id:Int? = 0) {
        guard let currentUserProfileID = id else {    // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The profile id for observe is: \(currentUserProfileID)")
        let userStatusRef = ZLFireBaseManager.share.userRef.child("UserStatus").child(String(currentUserProfileID))
        
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
            
            // Handle the updated data here
            if let value = snapshot.value as? [String: Any] {
                print("The response we are getting from Firebase is:\(value)")
                
                //                guard let cell = tblView.visibleCells[0] as? LiveRoomCellTableViewCell else {
                //                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                //                    return
                //                }
                
                
                if let status = value["status"] as? String {
                    print("The status coming from the firebase is: \(status)")
                    
                    if let uid = value["uid"] as? String {
                        print("The user id of the user is: \(uid)")
                        userID = uid
                        print("the user id from firebase is: \(userID)")
                        
                    }
                    
                    if let callprice = value["new_call_rate"] as? String {
                        print("The call rate of host is: \(callprice)")
                        callRate = callprice
                        print("the call rate from firebase is: \(callRate)")
                        
                    }
                    
                    if (status.lowercased() == "live") {            // || (status.lowercased() == "pk")
                        
                        if (isPK == true) {
                            isTableViewReloadedForPK = false
                            isLiveStarted = true
                            tblView.reloadData()
                            isPK = false
                          
                        }
                        
                        guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                            return
                        }
                        
                        if let channelName = value["channaleName"] as? String {
                            
                            
                            // isPK = false
                            print("The channel name is: \(channelName)")
                            room = (channelName ?? "")
                            broad = (channelName) + "_stream"
                            cell.viewEndUserDetails.isHidden = true
                            
                            if (isLiveStarted == true) {
                             //   removeSwipeGestures()
                               // addSwipeGestures()
                                addUserOnMic()
                                startLive(roomID: room, streamID: broad)
                                isLiveStarted = false
                                addMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
                                joinGroup(id: usersList.data?[currentIndex].groupID ?? "")
                                addObserveForRanking(id: usersList.data?[currentIndex].profileID ?? 0)
                                addObserverForDailyEarning(id: usersList.data?[currentIndex].profileID ?? 0)
                                updateUserBroadStatus(profileID: self.usersList.data?[currentIndex].profileID ?? 0, type: "4")
                                
                            } else {
                                print("Broad pehle se hi chal rhi hai")
                            }
                        }
                        
                        print("User ka status live ya pk hai")
                        
                        cell.groupID = usersList.data?[currentIndex].groupID ?? ""
                        cell.hostFollow = hostFollowed
                        cell.userID = usersList.data?[currentIndex].id ?? 0
                        cell.lblName.isHidden = true
                        cell.viewUserBusy.isHidden = true
                    //    cell.unhideViews()
                        if let count = value["weeklyPoints"] as? String {
                            let formattedString1 = formatNumber(Int(count) ?? 0)
                            
                            cell.lblDistributionAmount.text = formattedString1
                        } else {
                            print("value['count'] is not an integer")
                            cell.lblDistributionAmount.text = "0"
                        }
                        
                        
                    } else if (status.lowercased() == "pk") || (status.lowercased() == "rpk") {
                        
                        isPK = true
                        // isLiveStarted = true
                        if !isTableViewReloadedForPK {
                      
                            tblView.reloadData()
                            isTableViewReloadedForPK = true
                            isLiveStarted = true
                        }
                        
                        guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                            return
                        }
                        
                        cell.userID = usersList.data?[currentIndex].id ?? 0
                        
                        if let pkEndTime = value["pk_end_time"] as? Int {
                            
                            print("The pk end timestamp we are getting is: \(pkEndTime)")
                            
                            if (pkEndTime == cell.pkEndTime) {
                                print("Function ko call nahi karwana hai timer wale ko.")
                            } else {
                                print("function ko call karwana hai timer wale ko")
                                cell.pkEndTime = pkEndTime
                                cell.calculatePKTotalTime()
                            }
                        }
                        
                        if let channelName = value["channaleName"] as? String {
                            
                            
                            room = (channelName ?? "")
                            broad = (channelName) + "_stream"
                        }
                        
                        if let opponentFirstgroup = value["host1_groupid"] as? String {
                            
                           // opponentGroupId = opponentgroup
                           print("The opponent first host group id is: \(opponentFirstgroup)")
                            cell.groupID = opponentFirstgroup
                            
                        }
                        
                        if let opponentgroup = value["host2_groupid"] as? String {
                            
                            opponentGroupId = opponentgroup
                           print("The opponent host group id is: \(opponentGroupId)")
                            
                        }
                        
                        if (isLiveStarted == true) {
                         //   removeSwipeGestures()
                         //   addSwipeGestures()
                            if (hostFollowed == 0) {
                                cell.btnFollowUserOutlet.isHidden = false
                            } else {
                                cell.btnFollowUserOutlet.isHidden = true
                            }
                            
                            isLiveStarted = false
                          
//                            cell.groupID = usersList.data?[currentIndex].groupID ?? ""
                            addMessageObserverPK(id: usersList.data?[currentIndex].profileID ?? 0)
                            joinGroup(id: usersList.data?[currentIndex].groupID ?? "")
                            addObserveForRankingPK(id: usersList.data?[currentIndex].profileID ?? 0)
                            addObserverForDailyEarningPK(id: usersList.data?[currentIndex].profileID ?? 0)
                            updateUserBroadStatus(profileID: self.usersList.data?[currentIndex].profileID ?? 0, type: "4")
                            if let opponentUserDetail = value["pk_opponent_user_detail"] as? [String: Any] {
                                let age = opponentUserDetail["age"] as? Int ?? 0
                                let callRate = opponentUserDetail["call_rate"] as? Int ?? 0
                                let language = opponentUserDetail["language"] as? String ?? ""
                                let level = opponentUserDetail["level"] as? Int ?? 0
                                let location = opponentUserDetail["location"] as? String ?? ""
                                let status = opponentUserDetail["status"] as? String ?? ""
                                let userId = opponentUserDetail["user_id"] as? String ?? ""
                                let userImageURL = opponentUserDetail["user_image"] as? String ?? ""
                                let userName = opponentUserDetail["user_name"] as? String ?? ""
                                let userUid = opponentUserDetail["user_uid"] as? Int ?? 0
                                opponentProfileID = userId
                                opponentName = userName
                                opponentLevel = String(level)
                                opponentProfileImage = userImageURL
                                
                                
                                
                                let zegocanvas = ZegoCanvas(view: cell.viewPKFirstUserOutlet)
                                zegocanvas.viewMode = .aspectFill
                                
                             //   group.enter()
                                ZegoExpressEngine.shared().logoutRoom()
                                    ZegoExpressEngine.shared().loginRoom(room, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
                                print("The room we are passing is: \(room)")
                                let config = ZegoPlayerConfig()
                                config.roomID = room
                                
                                ZegoExpressEngine.shared().startPlayingStream(room, canvas: zegocanvas, config: config)
                              //  ZegoExpressEngine.shared().setEventHandler(self)
                                
                               
                                
                                let room1 = "Zeeplive\(userId)"
                                let broad = room1 + "_stream"
                                secondBroad = broad
                                secondRoom = room1
                                let config1 = ZegoPlayerConfig()
                                config1.roomID = room1
                                
                                let zegocanvas2 = ZegoCanvas(view: cell.viewPKSecondUserOutlet)
                                zegocanvas2.viewMode = .aspectFill
                                
                              //  group.notify(queue: .main) {
                                    print("All downloads are complete.")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                           // Code to execute after the delay
                                           ZegoExpressEngine.shared().loginRoom(room1, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
                                           ZegoExpressEngine.shared().startPlayingStream(room1, canvas: zegocanvas2, config: config1)
                                        self.addUserOnMic()
                                      //  self.joinGroup(id: self.opponentGroupId )
                                        cell.secondgroupID = self.opponentGroupId
                                       }

                            }
                        }
                        
                        if let pkMyGiftCoin = value["pk_myside_gift_coins"] as? Int {
                            
                            print("The gift Coin that we are getting is: \(pkMyGiftCoin)")
                            cell.myGiftCoins = pkMyGiftCoin
                            pkUserTotalGiftCoins = pkMyGiftCoin
                            // cell.updateBottomBar()
                            
                        }
                        
                        if let pkOpponentGiftCoin = value["pk_opponent_gift_coins"] as? Int {
                            
                            print("The gift Coin that opponent are getting is: \(pkOpponentGiftCoin)")
                            cell.opponentGiftCoins = pkOpponentGiftCoin
                            pkUserOpponentTotalGiftCoins = pkOpponentGiftCoin
                            
                            //  cell.updateBottomBar()
                        
                        }
                        
                        print("Cell main bar update karne wale par aaya hai")
                        cell.updateBottomBarStack()
                     //   cell.viewMiddleStackWidthConstraints.constant = 60
                        
                        if let count = value["weeklyPoints"] as? String {
                            let formattedString1 = formatNumber(Int(count) ?? 0)
                            
                            cell.lblDistributionAmount.text = formattedString1
                        } else {
                            print("value['count'] is not an integer")
                            cell.lblDistributionAmount.text = "0"
                        }
                        
                        if let pkMySideGiftedUsers = value["pk_my_side_gifted_users"] as? [String: Any] {
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
                                    cell.mySideGiftUser(fromUser: "1", userImage: "", userID: userID1, userName: "")
                                    pkUserGiftDetail.userID = userID1
                                    pkUserGiftDetail.userName = userName1
                                    pkUserGiftDetail.userImage = userImage1
                                    pkUserGiftDetail.type = type1
                                    pkGiftList.insert(pkUserGiftDetail, at: 0)
                                } else {
                                    print("Pehle gift mai user hai.")
                                    cell.mySideGiftUser(fromUser: "1", userImage: userImage1, userID: userID1, userName: userName1)
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
                                    cell.mySideGiftUser(fromUser: "2", userImage: "", userID: userID2, userName: "")
                                    pkUserGiftDetail.userID = userID2
                                    pkUserGiftDetail.userName = userName2
                                    pkUserGiftDetail.userImage = userImage2
                                    pkUserGiftDetail.type = type2
                                    pkGiftList.insert(pkUserGiftDetail, at: 1)
                                    
                                } else {
                                    print("Doosre gift par koi hai")
                                    cell.mySideGiftUser(fromUser: "2", userImage: userImage2, userID: userID2, userName: userName2)
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
                                    cell.mySideGiftUser(fromUser: "3", userImage: "", userID: userID3, userName: "")
                                    pkUserGiftDetail.userID = userID3
                                    pkUserGiftDetail.userName = userName3
                                    pkUserGiftDetail.userImage = userImage3
                                    pkUserGiftDetail.type = type3
                                    pkGiftList.insert(pkUserGiftDetail, at: 2)
                                    
                                } else {
                                    print("Teesre gift par koi user hai")
                                    cell.mySideGiftUser(fromUser: "3", userImage: userImage3, userID: userID3, userName: userName3)
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
                        
                        if let pkOpponentSideGiftedUsers = value["pk_opponent_side_gifted_users"] as? [String: Any] {
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
                                    cell.opponentSideGiftUser(fromUser: "1", userImage: "", userID: userID1, userName: "")
                                    pkUserGiftDetail.userID = userID1
                                    pkUserGiftDetail.userName = userName1
                                    pkUserGiftDetail.userImage = userImage1
                                    pkUserGiftDetail.type = type1
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 0)
                                    
                                } else {
                                    print("Opponent ke pehle gift par user hai")
                                    cell.opponentSideGiftUser(fromUser: "1", userImage: userImage1, userID: userID1, userName: userName1)
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
                                    cell.opponentSideGiftUser(fromUser: "2", userImage: "", userID: userID2, userName: "")
                                    pkUserGiftDetail.userID = userID2
                                    pkUserGiftDetail.userName = userName2
                                    pkUserGiftDetail.userImage = userImage2
                                    pkUserGiftDetail.type = type2
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 1)
                                    
                                } else {
                                    print("Opponent ke doosre gift par user hai.")
                                    cell.opponentSideGiftUser(fromUser: "2", userImage: userImage2, userID: userID2, userName: userName2)
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
                                    cell.opponentSideGiftUser(fromUser: "3", userImage: "", userID: userID3, userName: "")
                                    pkUserGiftDetail.userID = userID3
                                    pkUserGiftDetail.userName = userName3
                                    pkUserGiftDetail.userImage = userImage3
                                    pkUserGiftDetail.type = type3
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 2)
                                    
                                } else {
                                    print("Opponent ke teesre gift par user hai.")
                                    cell.opponentSideGiftUser(fromUser: "3", userImage: userImage3, userID: userID3, userName: userName3)
                                    pkUserGiftDetail.userID = userID3
                                    pkUserGiftDetail.userName = userName3
                                    pkUserGiftDetail.userImage = userImage3
                                    pkUserGiftDetail.type = type3
                                    pkOpponentGiftList.insert(pkUserGiftDetail, at: 2)
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                    else if (status.lowercased() == "busy") {
                        
                        if (isPK == true) {
                            tblView.reloadData()
                            isPK = false
                            isLiveStarted = true
                        }
                        
                        guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                            return
                        }
                        
                      //  removeSwipeGestures()
                        isPK = false
                        cell.hostFollow = hostFollowed
                        cell.hideViews()
                        cell.lblName.isHidden = false
                        cell.lblName.text = "I'll be back soon"
                        cell.viewUserBusy.isHidden = false
                        cell.viewEndUserDetails.isHidden = true
                        cell.viewEndView.isHidden = true
                        
                        
                        ZegoExpressEngine.shared().stopPlayingStream(broad)
                        //  removeMessageObserver(id:usersList.data?[currentIndex].profileID ?? 0)
                        quitgroup(id: usersList.data?[currentIndex].groupID ?? "")
                        removeObserverForRanking(id:usersList.data?[currentIndex].profileID ?? 0)
                        removeObserverForDailyEarning(id:usersList.data?[currentIndex].profileID ?? 0)
                        
                        if let urlString = usersList.data?[currentIndex].profileImage,
                           let url = URL(string: urlString) {
                            
                            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                if let data = data,
                                   let image = UIImage(data: data),
                                   let blurredImage = blurImage(image: image) {
                                    // Update UI on the main thread
                                    DispatchQueue.main.async {
                                        cell.imgView.image = blurredImage
                                    }
                                }
                            }
                            
                            task.resume()
                        }
                        
                    }  else {
                        
                        if (isPK == true) {
                            tblView.reloadData()
                            isPK = false
                            isLiveStarted = true
                        }
                        
                        guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                            return
                        }
                        
                        //   cell.unhideViews()
                        if let sheetController = sheetController {
                            sheetController.dismiss(animated: true) {
                                // The completion block is called after the dismissal animation is completed
                                print("Sheet view controller dismissed")
                                sheetController.animateOut()
                            }
                        } else {
                            print("Sheet controller is nil. Unable to dismiss.")
                            
                        }
                        
                        
                       // removeSwipeGestures()
                        removeUserOnMic()
                        isLiveStarted = true
                        ZegoExpressEngine.shared().stopPlayingStream(broad)
                        removeMessageObserver(id:usersList.data?[currentIndex].profileID ?? 0)
                        quitgroup(id: usersList.data?[currentIndex].groupID ?? "")
                        removeObserverForRanking(id:usersList.data?[currentIndex].profileID ?? 0)
                        removeObserverForDailyEarning(id:usersList.data?[currentIndex].profileID ?? 0)
                        
                        // stopPlayingStream(streamID: ((usersList.data?[currentIndex].broadChannelName)!) + "_stream")
                        cell.hideViews()
                        cell.hostFollow = hostFollowed
                        // quitgroup(id: usersList.data?[currentIndex].groupID ?? "")
                        
                        cell.lblEndViewUserName.text = usersList.data?[currentIndex].name ?? "N/A"
                        cell.imgView.image = UIImage(named: "endbackgroundviewimage")
                        cell.viewEndUserDetails.isHidden = false
                        cell.lblName.isHidden = false
                        cell.lblName.text = "LIVE ENDED"
                        cell.viewUserBusy.isHidden = true
                        cell.viewEndView.isHidden = false
                        cell.btnJoinMicOutlet.isHidden = true
                         
                        loadImage(from: usersList.data?[currentIndex].profileImage, into: cell.imgViewEndUserDetail)

                        
                    }
                }
                
            }
        }
    }
}

// MARK: - EXTENSION FOR ADDING OBSERVERS TO GET DATA FROM THE FIREBASE AND WRITING THEIR FUNCTIONS HERE FOR LIVE BROAD AND REMOVING OBSERVERS IN HERE AND SETTING THE ROOM EXTRA INFO FUNCTION DEFINED HERE

extension SwipeUpDownTestingViewController {

    func setDataInMicList() {
    
        micUser = getZegoMicUserListModel()
        
        // Access and print nested properties
      
            micUser.coHostID = UserDefaults.standard.string(forKey: "UserProfileId")
            micUser.coHostLevel = UserDefaults.standard.string(forKey: "level")
            micUser.coHostUserImage = UserDefaults.standard.string(forKey: "profilePicture")
            micUser.coHostUserName = UserDefaults.standard.string(forKey: "UserName")
            micUser.isHostMuted = false
            micUser.coHostUserStatus = ""
            micUser.coHostAudioStatus = ""
        
        zegoMicUsersList.append(micUser)
         
        if (isPK == true) {
            print("Yhn par pk wale case main kaam karenge.")
            
            guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                return
            }
            cell.usersOnMic(data: zegoMicUsersList)
            cell.btnJoinMicOutlet.isHidden = true
            //cell.countdownTimer?.invalidate()
            cell.btnMuteMicOutlet.isUserInteractionEnabled = true
            cell.btnMuteMicOutlet.isHidden = false
            cell.btnMuteMicWidthConstraints.constant = 40
            
        } else {
            print("Yhn par broad chl rhi hai iss case amin kaam karenge.")
            guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                return
            }
            cell.usersOnMic(data: zegoMicUsersList)
            cell.btnJoinMicOutlet.isHidden = true
            cell.countdownTimer?.invalidate()
            cell.btnMuteMicOutlet.isUserInteractionEnabled = true
            cell.btnMuteMicOutlet.isHidden = false
            cell.btnMuteMicWidthConstraints.constant = 40
            
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
          
            // Convert map to JSON string
            let infoStr2 = jsonString(from: map)
           
            // Set room extra info using the SDK
            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: room, callback: { errorCode in

                    print(errorCode)
                    print(errorCode.description)
                    if errorCode == 0 {
                     print("Successfully delete wala message bhej dia hai extra room info wale main.")
                    } else {
                        print("Message abhi group mai shi se nahi gya hai room extra info wala.")
                    }
                })
        
    }
    
    func removeLiveAsCoHost() {
    
        hasJoinedMic = false
        guard let userID = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        if zegoSendMicUsersList.contains(where: { $0.key == userID }) {
            if zegoMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                zegoMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                cell.usersOnMic(data: zegoMicUsersList)
                cell.btnJoinMicOutlet.isHidden = false
            }
               print("ID exists in zegoSendMicUsersList")
          //  zegoSendMicUsersList["coHostUserStatus"] = "delete"
            if let jsonString = zegoSendMicUsersList[userID],
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
                        zegoSendMicUsersList[userID] = updatedJsonString
                        print("Updated User Data: \(updatedJsonString)")
                    } else {
                        print("Error converting JSON object to string")
                    }
                } else {
                    print("coHostUserStatus not found in JSON object")
                }
            } else {
                print("User ID \(userID) not found in zegoSendMicUsersList or data is not a valid JSON string")
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
            ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: room, callback: { errorCode in

                    print(errorCode)
                    print(errorCode.description)
                    if errorCode == 0 {
                     print("Successfully delete wala message bhej dia hai extra room info wale main remove live as cohost wale function main.")
                       
                        if (self.isPK == true) {
                          
                            print("Remove Live As CoHost wale function main pk wale case main aaye hai.")
                            
                            guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                            return
                        }
                            
                            cell.btnMuteMicOutlet.isHidden = true
                            cell.btnMuteMicWidthConstraints.constant = 0
                            
                        } else {
                            
                            guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                            return
                        }
                            
                            cell.btnMuteMicOutlet.isHidden = true
                            cell.btnMuteMicWidthConstraints.constant = 0
                            
                        }
                    } else {
                        print("Message abhi group mai shi se nahi gya hai room extra info wala.")
                    }
                })
             
           } else {
               print("ID does not exist in zegoSendMicUsersList")
           }
        print("The changed zegosendmicuserslist are: \(zegoSendMicUsersList)")
        
    }
    
    func joinLiveAsCoHostForPK() {
        
        guard let userID = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where userID is nil
            return
        }
        
        // Print debug information
        print("Check_CoHostJK joinLiveAsCoHost userID: \(userID) MainList Size: \(zegoSendMicUsersList.count)")
        
        // Initialize coHost details
        var coHostDetails: [String: Any] = [
            "coHostID": userID,
            "coHostUserName": UserDefaults.standard.string(forKey: "UserName") ?? "",
            "coHostUserImage": UserDefaults.standard.string(forKey: "profilePicture") ?? "",
            "coHostUserStatus": "add",
            "coHostLevel": UserDefaults.standard.string(forKey: "level") ?? ""
        ]
        
        // Convert coHostDetails to JSON string
        let infoStr = jsonString(from: coHostDetails)
        
        // Update or create a new entry in zegoSendMicUsersList
        zegoSendMicUsersList[userID] = infoStr

        // Create the structure for pkHost as a dictionary
        let pkHost: [String: Any] = [
            "coHost123": zegoSendMicUsersList // This should be a nested dictionary
        ]
        
        // Convert pkHost to JSON string
         let pkHostString = jsonString(from: pkHost)

        // Create the structure for the main JSON object
        let mainCoHostList: [String: Any] = [
            "pkHost": pkHostString, // Use the JSON string here
            "pkHostImage": UserDefaults.standard.string(forKey: "profilePicture") ?? "",
            "pkHostName": UserDefaults.standard.string(forKey: "UserName") ?? "",
            "pkHostRoomID": room, // Assuming room is defined in your class
            "pkHostUserID": userID,
            "pk_end_time": Date().timeIntervalSince1970 * 1000, // Current time in milliseconds
            "type": "pk_start"
        ]

        // Convert the mainCoHostList to JSON string
        let infoStr2 = jsonString(from: mainCoHostList)
        
        // Set room extra info using the SDK
        ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: room) { errorCode in
            print("Error Code: \(errorCode)")
            if errorCode == 0 {
                self.startPublishCoHostStream()
            } else {
                print("Message could not be sent to the room extra info in pk case.")
            }
        }
    }


    
    func joinLiveAsCoHost() {
        
        guard let userID = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        // Print debug information
        print("Check_CoHostJK joinLiveAsCoHost userID: \(userID) MainList Size: \(zegoSendMicUsersList.count)")
        
        // Initialize variables
        var infoStr = ""
        var type = ""
        
        // Check if mainCoHostList is not empty
        if zegoSendMicUsersList.count > 0 {
            // Create co-host user details dictionary
            var coHostUserExtraDetail: [String: Any] = [
                "coHostID": UserDefaults.standard.string(forKey: "UserProfileId"),
                "coHostUserName": UserDefaults.standard.string(forKey: "UserName"),
                "coHostUserImage": UserDefaults.standard.string(forKey: "profilePicture"),
                "coHostUserStatus": "add",
                "coHostLevel": UserDefaults.standard.string(forKey: "level"),
                "coHostAudioStatus":"unmute",
                "isHostMuted": false
            ]
            // Convert dictionary to JSON string
            infoStr = jsonString(from: coHostUserExtraDetail)
            // Update mainCoHostList with user ID as key and JSON string as value
            zegoSendMicUsersList[userID] = infoStr
        } else {
        
            // Create co-host user details dictionary
            var infoObj: [String: Any] = [
                "coHostID": UserDefaults.standard.string(forKey: "UserProfileId"),
                "coHostUserName": UserDefaults.standard.string(forKey: "UserName"),
                "coHostUserImage": UserDefaults.standard.string(forKey: "profilePicture"),
                "coHostUserStatus": "add",
                "coHostLevel": UserDefaults.standard.string(forKey: "level"),
                "coHostAudioStatus":"unmute",
                "isHostMuted": false
            ]
            // Convert dictionary to JSON string
            infoStr = jsonString(from: infoObj)
            // Update mainCoHostList with user ID as key and JSON string as value
            zegoSendMicUsersList[userID] = infoStr
            // Print debug information
            print("Check_CoHostJK joinLiveAsCoHost MainList Size: \(zegoSendMicUsersList.count)")
        }
        
        // Initialize more variables
        var infoStr1 = ""
       
            // Convert mainCoHostList to JSON string
            infoStr1 = jsonString(from: zegoSendMicUsersList)
            type = "coHost123"
        
        
        // Create a map with type as key and infoStr1 as value
        var map: [String: String] = [:]
        map[type] = infoStr1
        print("The info str1 json to final string is: \(map)")
        print("The info str1 json to final string is: \(infoStr1)")
        // Convert map to JSON string
        let infoStr2 = jsonString(from: map)
        print("The info str2 json to final string is: \(infoStr2)")
        print("The Send Mic Users List data is: \(zegoSendMicUsersList)")
        // Set room extra info using the SDK
        ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: room, callback: { errorCode in

                print(errorCode)
                print(errorCode.description)
                if errorCode == 0 {
                    self.startPublishCoHostStream()
                } else {
                    print("Message abhi group mai shi se nahi gya hai room extra info wala.")
                }
            })   
    }

    
    // Function to convert an object to a JSON string
    func jsonString(from object: Any) -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: object, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }

    
    
    func startPublishCoHostStream() {
      
                guard let userid = UserDefaults.standard.string(forKey: "UserProfileId") else {
                    // Handle the case where currentUserProfileID is nil
                    return
                }
        
        let config = ZegoPublisherConfig()
        config.roomID = room // Assuming channelName is a valid variable accessible in this scope

        let streamID = room + userid + "_cohost_stream"
        print("THe stream id we are passing in case of joining mic in live is: \(streamID)")
        
        // Assuming expressObject is an instance of ZegoExpressEngine
        ZegoExpressEngine.shared().startPublishingStream(streamID, config: config, channel: .main)
        setDataInMicList()
        
    }
    
    func stopPublishCoHostStream() {
      
        ZegoExpressEngine.shared().stopPublishingStream()
        
    }
    
    func addObserverForJoinMicSentRequest(id:Int? = 0) {
        
        
        guard let hostid = id else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        guard let currentUserProfileID = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let coHostRef = ZLFireBaseManager.share.coHostRef.child("sub-cohost-invite-details").child(String(hostid)).child(currentUserProfileID)
        
        userMicRequestHandle = coHostRef.observe(.value) { [weak self] (snapshot, error) in
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
                print("The response we are getting from Firebase in Mic Request is:\(value)")
                
                if let status = value["status"] as? String {
                    
                   print("THe status for the jon mic request is: \(status)")
                    if (status.lowercased() == "accept") {
                        print("Status accept ho gya hai. Apni broad publish krna shuru kar dena hai bhai.....")
                        if (isPK == true) {
                            joinLiveAsCoHostForPK()
                        } else {
                            joinLiveAsCoHost()
                        }
                        hasJoinedMic = true
                      //  startPublishCoHostStream()
                    } else {
                        print("Status accept nahi hai. baaki sab se koi lena dena nahi hai bhai....")
                        hasJoinedMic = false
                    }
                    
                } else {
                    
                 print("Status ko shi se decode nahi kar pae ham log.")
                    
                }
                
            }
        }
        
    }
    
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
                
                guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                if let count = value["rank"] as? Int {
                    
                    print("The rank is: \(count)")
                    cell.lblRewardRank.text = "Weekly" + " " + String(count)
                    weeklyEarningBeans = String(count)
                    cell.weeklyEarningBeans = weeklyEarningBeans
                    
                } else {
                    
                    print("value['count'] is not an integer")
                    
                }
                
            }
        }
        
    }
    
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
                
                guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                if let count = value["rank"] as? Int {
                    
                    print("The rank is: \(count)")
                    cell.lblRewardRank.text = "Daily" + " " + String(count)
                    dailyEarningBeans = String(count)
                    //  lblSetText.text = "NEw Data"
                    cell.dailyEarningBeans = dailyEarningBeans
                    
                } else {
                    
                    print("value['count'] is not an integer")
                    cell.lblRewardRank.text = "Daily"
                }
                
            }
        }
        
    }
    
    func addMessageObserver(id:Int = 0) {
        
        //        guard let currentUserProfileID = usersList.data?[currentIndex].profileID else {
        //            // Handle the case where currentUserProfileID is nil
        //            return
        //        }
        
        guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
            return
        }
        
        if previousIndex != currentIndex {
            
            zegoSendMicUsersList.removeAll()
            cell.zegoMicUsersList.removeAll()
            cell.usersOnMic(data: zegoMicUsersList)
            cell.liveMessages.removeAll()
            cell.tblViewLiveMessage.reloadData()
            
        }
        
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
                
                if (liveMessage.type == "1") || (liveMessage.type == "16") || (liveMessage.type == "12") || (liveMessage.type == "13") {
                    
                    print("The sending model data is: \(liveMessage)")
                    print("The sending model name is: \(liveMessage.userName)")
                    cell.insertNewMsgs(msgs: liveMessage)
                    cell.tblViewLiveMessage.reloadData()
                } else if (liveMessage.type == "4") || (liveMessage.type == "5"){
                    
                    cell.insertUserName(name: liveMessage.userName ?? "N/A", status: liveMessage.type ?? "N/A")
                    
                } else if (liveMessage.type == "2") {
                    
                    print("Gift wala animation play krna hai jo firebase se aaya hai. aur luckgift wala popup dikhana hai. ")
                    
                    //                        cell.insertNewMsgs(msgs: liveMessage)
                    //                        cell.tblViewLiveMessage.reloadData()
                    
                    
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
                        loadImage(from: giftDetails["fromHead"] as? String ?? "", into: cell.imgViewUser)
                        
                        
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
    
    func removeObserver(id:Int? = 0) {
        guard let userStatusHandle = userStatusHandle else {
            // Handle the case where the observer handle is nil
            return
        }
        
        guard let currentUserProfileID = id else {  // usersList.data?[previousIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let userStatusRef = ZLFireBaseManager.share.userRef.child("UserStatus").child(String(currentUserProfileID))
        userStatusRef.removeObserver(withHandle: userStatusHandle)
        
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
}

// MARK: - EXTENSION FOR WRITING AND GETTING DATA FROM FIREBASE AND SETTING OBSERVERS FOR PK IN HERE NAD REMOVING OBSERVERS HERE

extension SwipeUpDownTestingViewController {
    
    func addObserveForRankingPK(id:Int? = 0) {
        guard let currentUserProfileID = id else {  // usersList.data?[currentIndex].profileID
            // Handle the case where currentUserProfileID is nil
            return
        }
    
        print("The profile id for observe in ranking in PK is: \(currentUserProfileID)")
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
               
                guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                if let count = value["rank"] as? Int {
                
                    print("The rank is: \(count)")
                    cell.lblViewRewardRank.text = "Weekly" + " " + String(count)
                    weeklyEarningBeans = String(count)
                    cell.weeklyEarningBeans = weeklyEarningBeans
                    
                } else {
                    
                    print("value['count'] is not an integer")
                    
                }
                    
            }
        }
        
    }
    
    func addObserverForDailyEarningPK(id:Int? = 0) {
        
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
                print("The response we are getting from Firebase in rank PK is:\(value)")
               
                guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                    return
                }
                
                if let count = value["rank"] as? Int {
                
                    print("The rank is: \(count)")
                    cell.lblViewRewardRank.text = "Daily" + " " + String(count)
                    dailyEarningBeans = String(count)
                    cell.dailyEarningBeans = dailyEarningBeans
                    
                } else {
                    
                    print("value['count'] is not an integer")
                    cell.lblViewRewardRank.text = "Daily"
                }
                    
            }
        }
       
    }
    
    func addMessageObserverPK(id:Int = 0) {
        
//        guard let currentUserProfileID = usersList.data?[currentIndex].profileID else {
//            // Handle the case where currentUserProfileID is nil
//            return
//        }

        guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
            return
        }
        
        if previousIndex != currentIndex {
            
            zegoSendMicUsersList.removeAll()
            cell.zegoMicUsersList.removeAll()
            cell.usersOnMic(data: zegoMicUsersList)
            cell.zegoOpponentMicUsersList.removeAll()
            cell.opponentUsersOnMic(data: zegoOpponentMicUsersList)
            cell.opponentUsersOnMic(data: zegoOpponentMicUsersList)
            cell.liveMessages.removeAll()
            cell.tblViewLiveMessages.reloadData()
            
        }
        
        print("The profile id message for observe in PK is: \(id)")

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
                    
                if (liveMessage.type == "1") || (liveMessage.type == "16") || (liveMessage.type == "12") || (liveMessage.type == "13") {
                        
                        print("The sending model data is: \(liveMessage)")
                        print("The sending model name is: \(liveMessage.userName)")
                        cell.insertNewMsgs(msgs: liveMessage)
                        cell.tblViewLiveMessages.reloadData()
                    } else if (liveMessage.type == "4") || (liveMessage.type == "5"){
                        
                        cell.insertUserName(name: liveMessage.userName ?? "N/A", status: liveMessage.type ?? "N/A")
                        
                    } else if (liveMessage.type == "2") {
                        
                        print("Gift wala animation play krna hai jo firebase se aaya hai. aur luckgift wala popup dikhana hai pk main. ")
                        
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
                            
                            cell.insertNewMsgs(msgs: liveMessage)
                            cell.tblViewLiveMessages.reloadData()
                            
                            cell.viewLuckyGift.isHidden = false
                            shakeAnimation(for: cell.viewGiftImage)
                            hideViewAfterDelay(viewToHide: cell.viewLuckyGift, duration: 0.40) {
                                // This block will be executed when the animation is finished
                                print("Animation finished!")
                                cell.viewLuckyGift.isHidden = true
                                
                            }
                            
                            cell.lblNoOfGift.text =  "X" + " " + String(giftDetails["count"] as? Int ?? 1)
                            cell.lblSendGiftHostName.text = liveMessage.sendGiftTo ?? ""
                            
                            loadImage(from: giftDetails["icon"] as? String ?? "", into: cell.imgViewGift)
                            loadImage(from: giftDetails["fromHead"] as? String ?? "", into: cell.imgViewUser)
                                                       
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
    
}
// MARK: EXTENSION TO USE TENCENT FUNCTIONS AND GET LIST AND COUNT OF THE USER WHO JOINED THE GROUP

extension SwipeUpDownTestingViewController {

    func getGroupMemberList() {
        callMemberList = false
        V2TIMManager.sharedInstance()?.getGroupMemberList(usersList.data?[currentIndex].groupID, filter: 0x00, nextSeq: 0, succ: { [weak self] nextSeq, memberList in
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
                
                guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
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
                            guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else { return }
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
            
            guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                return
            }
            
            if previousIndex != currentIndex {
                
                cell.groupUsers.removeAll()
                cell.collectionView.reloadData()
                
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
    
    func getGroupCallBack() {
        
        messageListener.groupUserEnter = { [weak self] msgID, text in
            guard let self = self else { return }
            
            print(msgID)
            print(text)
            if (text.count == 0) {
                print("Khali hai.")
            } else {
                print("Bhara hai.")
                print(text[0].nickName)
                print(text[0].userID)
                print(text[0].faceURL)
            
                if (isPK == true) {
                    
                    guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                        return
                    }
                    
                    cell.insertUserName(name: text[0].nickName ?? "N/A", status: "4" ?? "N/A")
                    
                } else {
                    
                    guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                        return
                    }
                    
                    cell.insertUserName(name: text[0].nickName ?? "N/A", status: "4" ?? "N/A")
                    
                }
                
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
                print("Bhara hai.")
                
                if (isPK == true) {
                    
                    guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                        return
                    }
                    
                    cell.insertUserName(name: text.nickName ?? "N/A", status: "3" ?? "N/A")
                    
                } else {
                    
                    guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                        return
                    }
                    
                    cell.insertUserName(name: text.nickName ?? "N/A", status: "3" ?? "N/A")
                    
                
            }
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
    
}
// MARK: - EXTENSION FOR TABLE VIEW DELEGATES AND METHODS AND THEIR WORKING WITH THE DELEGATES AND OTHER WORK BEEN DONE HERE

extension SwipeUpDownTestingViewController : UITableViewDelegate,UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.data?.count ?? 0//tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (isPK == true) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PKViewTableViewCell", for: indexPath) as! PKViewTableViewCell
            
            cell.unhideViewsOnSwipe()
            cell.btnMuteMicOutlet.isHidden = true
            cell.btnMuteMicWidthConstraints.constant = 0
            cell.delegate = self
            cell.selectionStyle = .none
            
            
            loadImage(from: usersList.data?[currentIndex].profileImage, into: cell.imgViewUserImage)
            
            if let user = usersList.data?[currentIndex], let nameLabel = cell.lblUserName {
             
                cell.lblUserName.text = user.name
                cell.viewUserDetailOutlet.backgroundColor  = UIColor.black.withAlphaComponent(0.4)
               
            } else {
                
                cell.lblUserName.text = "No Name"
             
            }
            
            if (hostFollowed == 0) {
                
                cell.btnFollowUserOutlet.isHidden = false
                cell.btnFollowWidthConstraints.constant = 30
                
            } else {
                
                cell.btnFollowUserOutlet.isHidden = true
                cell.btnFollowWidthConstraints.constant = 0
                
            }
            
            cell.viewUserDetailOutlet.tag = indexPath.row
            cell.profileID = usersList.data?[currentIndex].profileID ?? 0
            cell.userID = usersList.data?[currentIndex].id ?? 0
            cell.viewLuckyGift.isHidden = true
            
            return cell
            
        } else {
            
            print("The current index in the live room cell table view cell is: \(currentIndex)")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveRoomCellTableViewCell", for: indexPath) as! LiveRoomCellTableViewCell
            
            cell.btnMuteMicOutlet.isHidden = true
            cell.btnMuteMicWidthConstraints.constant = 0
            cell.lblName.isHidden = true
            cell.delegate = self
            cell.selectionStyle = .none
            //  cell.imgView.isHidden = true
            
            cell.lblViewersCount.isHidden = false
            
            if let urlString = usersList.data?[currentIndex].profileImage,
               let url = URL(string: urlString) {
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data,
                       let image = UIImage(data: data),
                       let blurredImage = blurImage(image: image) {
                        // Update UI on the main thread
                        DispatchQueue.main.async {
                            cell.imgViewPlaceholderPhoto.image = blurredImage
                        }
                    }
                }
                
                task.resume()
            }
            
            if let profileImageURLString = usersList.data?[currentIndex].profileImage,
               let profileImageURL = URL(string: profileImageURLString) {
                // Modify the URL by appending query parameters for blur and image manipulation
                let modifiedURLString = profileImageURLString + "/blur,r_40,s_30"
                
                loadImage(from: modifiedURLString, into: cell.imgView)
                
            }
            
            loadImage(from: usersList.data?[currentIndex].profileImage, into: cell.imgViewUserProfilePhoto)
            
            if let user = usersList.data?[currentIndex], let nameLabel = cell.lblName {
                //  nameLabel.text = user.name
                cell.lblHostName.text = user.name
                //  cell.viewUserDetailsOutlet.frame.size.width = cell.lblHostName.intrinsicContentSize.width + 10
                cell.viewUserDetailsOutlet.backgroundColor  = UIColor.black.withAlphaComponent(0.4)
                
            } else {
                // Handle the case where either usersList.data is nil or currentIndex is out of range
                // For example, set a default text or log an error
                //  cell.lblName.text = "N/A"
                cell.lblHostName.text = "No Name"
                // Or log an error message
                print("Unable to fetch user's name for currentIndex \(currentIndex)")
            }
            
            //        if let urlString = usersList.data?[currentIndex].profileImage,
            //           let url = URL(string: urlString) {
            //
            //            let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //                if let data = data,
            //                   let image = UIImage(data: data),
            //                   let blurredImage = blurImage(image: image) {
            //                    // Update UI on the main thread
            //                    DispatchQueue.main.async {
            //                        cell.imgView.image = blurredImage
            //                    }
            //                }
            //            }
            //
            //            task.resume()
            //        }
            
            if (hostFollowed == 0) {
                
                cell.btnFollowHostOutlet.isHidden = false
                cell.btnFollowWidthConstraints.constant = 30
            } else {
                
                cell.btnFollowHostOutlet.isHidden = true
                cell.btnFollowWidthConstraints.constant = 0
            }
            
            cell.hostFollow = hostFollowed
            cell.hideViews()
            cell.viewLuckyGift.isHidden = true
            cell.viewUserDetailsOutlet.tag = indexPath.row
            cell.profileID = usersList.data?[currentIndex].profileID ?? 0
            cell.userID = usersList.data?[currentIndex].id ?? 0
            print("The indexpath at cell for row at is: \(indexPath.row)")
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(SCREEN_HEIGHT)
    }
       
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        print("The indexpath at will display is: \(indexPath.row)")
      
        
        if indexPath.row == lastRowIndex {
//            pageNo += 1
//            print(pageNo)
            
            if pageNo <= lastPage {
                // Perform actions for loading more data
                print("Call API for more data")
                pageNo += 1
                print(pageNo)
                
                getUsersNearbyList()
                // tableView.reloadData() // You may or may not need to reload data here
            } else {
                // Already at the last page, no need to load more data
                print("Reached the last page, no more API calls needed")

            }
        }
    }
    
     func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//           if let customCell = cell as? YourCustomTableViewCell {
//               customCell.clearData() // Implement clearData() method in your cell subclass
//           }
         print("The table view cell that did end displaying in broad watching is: \(cell)")
         
       }
}

// MARK: - EXTENSION FOR ALL THE DELEGATES METHODS AND THEIR WORKING FOR THIS CLASS

extension SwipeUpDownTestingViewController: delegateLiveRoomCellTableViewCell, delegateShowGiftViewController, delegateGamesOptionInBroadViewController, delegateBottomWebViewViewController, delegateJoinedAudienceListViewController, delegateJoinedAudienceDetailsViewController, delegateJoinMicUserOptionsViewController {
  
    
    func giftSentSuccessfully(gift: Gift, sendgiftTimes:Int) {
        print("The gift model sent is: \(gift)")
        
        if (isPK == true) {
            print("Yhn par pk wale cell mai kaam dikhana hai.")
            
            guard let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell else {
                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                return
            }
            
            liveMessage.gender = UserDefaults.standard.string(forKey: "gender")
            liveMessage.level = UserDefaults.standard.string(forKey: "level")
//            liveMessage.message = message
            liveMessage.ownHost = true
            liveMessage.type = "2"
            liveMessage.userID = UserDefaults.standard.string(forKey: "UserProfileId")
            liveMessage.userImage = UserDefaults.standard.string(forKey: "profilePicture")
            liveMessage.userName = UserDefaults.standard.string(forKey: "UserName")
            liveMessage.giftCount = sendgiftTimes
            liveMessage.sendGiftName = gift.giftName ?? ""
            liveMessage.sendGiftTo = usersList.data?[currentIndex].name ?? ""
            

        cell.insertNewMsgs(msgs: liveMessage)
        
        cell.viewLuckyGift.isHidden = false
        shakeAnimation(for: cell.viewGiftImage)
        hideViewAfterDelay(viewToHide: cell.viewLuckyGift, duration: 0.48) {
            // This block will be executed when the animation is finished
            print("Animation finished!")
            cell.viewLuckyGift.isHidden = true
            
        }
        
        cell.lblNoOfGift.text =  "X" + " " + String(sendgiftTimes ?? 1)
        cell.lblSendGiftHostName.text = liveMessage.sendGiftTo ?? ""
        
        loadImage(from: gift.image ?? "", into: cell.imgViewGift)
        loadImage(from: UserDefaults.standard.string(forKey: "profilePicture") ?? "", into: cell.imgViewUser)
        
        
        var sendGiftModel = Gift()
        sendGiftModel.id = gift.id
        //     sendGiftModel.giftCategoryID
        sendGiftModel.giftName = gift.giftName
        sendGiftModel.image = gift.image
        sendGiftModel.amount = gift.amount
        sendGiftModel.animationType = gift.animationType
        sendGiftModel.isAnimated = gift.isAnimated
        sendGiftModel.animationFile = gift.animationFile
        sendGiftModel.soundFile = gift.soundFile
        sendGiftModel.imageType = gift.imageType
        
        if (sendGiftModel.animationType == 0) {
            print("Animation play nahi krana hai")
        } else {
            print("Animation play krana hai pk cell wale main.")
            ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: self)
        }
            
        } else {
            print("Yhn par live wale cell mai kaam dikhana hai.")
            
            guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                return
            }
          
                liveMessage.gender = UserDefaults.standard.string(forKey: "gender")
                liveMessage.level = UserDefaults.standard.string(forKey: "level")
//                liveMessage.message = message
                liveMessage.ownHost = true
                liveMessage.type = "2"
                liveMessage.userID = UserDefaults.standard.string(forKey: "UserProfileId")
                liveMessage.userImage = UserDefaults.standard.string(forKey: "profilePicture")
                liveMessage.userName = UserDefaults.standard.string(forKey: "UserName")
                liveMessage.giftCount = sendgiftTimes
                liveMessage.sendGiftName = gift.giftName ?? ""
                liveMessage.sendGiftTo = usersList.data?[currentIndex].name ?? ""
                
            
            cell.insertNewMsgs(msgs: liveMessage)
            
            cell.viewLuckyGift.isHidden = false
            shakeAnimation(for: cell.viewGiftImage)
            hideViewAfterDelay(viewToHide: cell.viewLuckyGift, duration: 0.24) {
                // This block will be executed when the animation is finished
                print("Animation finished!")
                cell.viewLuckyGift.isHidden = true
                
            }
            
            cell.lblNoOfGift.text =  "X" + " " + String(sendgiftTimes ?? 1)
            cell.lblSendGiftHostName.text = liveMessage.sendGiftTo ?? ""
            
            loadImage(from: gift.image ?? "", into: cell.imgViewGift)
            loadImage(from: UserDefaults.standard.string(forKey: "profilePicture") ?? "", into: cell.imgViewUser)
            
            
            var sendGiftModel = Gift()
            sendGiftModel.id = gift.id
            //     sendGiftModel.giftCategoryID
            sendGiftModel.giftName = gift.giftName
            sendGiftModel.image = gift.image
            sendGiftModel.amount = gift.amount 
            sendGiftModel.animationType = gift.animationType
            sendGiftModel.isAnimated = gift.isAnimated
            sendGiftModel.animationFile = gift.animationFile
            sendGiftModel.soundFile = gift.soundFile
            sendGiftModel.imageType = gift.imageType
            
            if (sendGiftModel.animationType == 0) {
                print("Animation play nahi krana hai")
            } else {
                print("Animation play krana hai")
                ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: self)
            }
            
        }
        
    }
    
   
    func giftButton(isPressed: Bool) {
        
        print("gift button isPressed: \(isPressed)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowGiftViewController") as! ShowGiftViewController
        vc.delegate = self
        vc.groupID = usersList.data?[currentIndex].groupID ?? ""
//        vc.recieverID = usersList.data?[currentIndex].profileID ?? 0
//        vc.receiverName = usersList.data?[currentIndex].name ?? ""
        vc.sendUserModel = usersList.data?[currentIndex] ?? ListData()
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

    
    func giftSelected(gift: Gift, sendgiftTimes:Int) {
        
        guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
            return
        }
        
        
        if (gift.animationType == 0) {
            
            print("Lucky gift wala kaam krna hai.")
            
            if (luckyGiftId == gift.id) {
                
                luckyGiftCount = luckyGiftCount + sendgiftTimes
                print("Jab ek hi gift baar baar nahi bhej rhe hai tb total hai: \(luckyGiftCount)")
                
            } else {
                
                luckyGiftId = (gift.id ?? 0)
                luckyGiftCount = sendgiftTimes
                
            }
          
            cell.viewLuckyGift.isHidden = false
            shakeAnimation(for: cell.viewGiftImage)
            hideViewAfterDelay(viewToHide: cell.viewLuckyGift, duration: 0.12) {
                // This block will be executed when the animation is finished
                print("Animation finished!")
                cell.viewLuckyGift.isHidden = true
                
            }
          
            cell.lblNoOfGift.text =  "X" + " " + String(luckyGiftCount ?? 1)
            cell.lblSendGiftHostName.text = usersList.data?[currentIndex].name ?? ""
            
            loadImage(from: gift.image ?? "", into: cell.imgViewGift)
          
            loadImage(from: UserDefaults.standard.string(forKey: "profilePicture") ?? "", into: cell.imgViewUser)
            
        } else {
            print("Animation play karne wala kaam krna hai.")
            
            if let sheetController = sheetController {
                sheetController.dismiss(animated: true) {
                    // The completion block is called after the dismissal animation is completed
                    print("Sheet view controller dismissed")
                    sheetController.animateOut()
                }
            } else {
                print("Sheet controller is nil. Unable to dismis0s.")
                
            }
            
            print("The selected gift to play is: \(gift)")
        //    ZLGiftManager.share.playAnimation(gift: gift, vc: self)
            cell.viewLuckyGift.isHidden = true
           
        }
        
    }
    
    func showLuckyGift(giftName: String, amount: Int) {
        
        print("Lucky gift show karne ke liye delegate call hua hai. lucky gift dikhao ab.")
        print("Lucky gift ka naam hai \(giftName)")
        print("Lucky gift ka amount jo jeeta hai woh hai \(amount)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LuckyGiftCashbackViewController") as! LuckyGiftCashbackViewController
        nextViewController.giftName = giftName
        nextViewController.giftAmount = amount
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    
    
    func isBalanceLow(isLow: Bool) {
        print("User ka balance low hai. recharge plan wala popup kholna hai. \(isLow)")
        
//        sheetController.dismiss(animated: true)
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
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
    
    func userDetailsPressed(selectedIndex: Int) {
        
        print("The selected user profile details index is: \(selectedIndex)")
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetailsViewController") as! ProfileDetailsViewController
//        nextViewController.userId = String(usersList.data?[currentIndex].id ?? 0)
//        nextViewController.callForProfileId = false
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        var user = joinedGroupUserProfile()
        
        user.userID = String(usersList.data?[currentIndex].profileID ?? 0)
        user.nickName = usersList.data?[currentIndex].name ?? "N/A"
        user.faceURL = usersList.data?[currentIndex].profileImage ?? ""
        user.richLevel = String(usersList.data?[currentIndex].level ?? 0)
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        nextViewController.messageDetails = user
        nextViewController.delegate = self
        nextViewController.viewFrom = "message"
        nextViewController.hostFollowed = hostFollowed
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func closeBroad(isPressed: Bool) {
        print("Close broad button pressed")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
        nextViewController.delegate = self
        nextViewController.headingText = "Do you want to exit broad?"
        nextViewController.buttonName = "Yes"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
//        if (hasJoinedMic == true) {
//            removeLiveAsCoHost()
//            print("User ne mic join kiya hua hai host ka.")
//        } else {
//        
//            print("User ne mic join nahi kiya hua hai host ka.")
//            
//        }
//        
//        ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), status: "gone")
//        stopPublishCoHostStream()
//        ZegoExpressEngine.shared().logoutRoom()
//        ZegoExpressEngine.destroy(nil)
//        self.navigationController?.popViewController(animated: true)
//        
//        removeSwipeGestures()
//        removeUserOnMic()
//        isPK = false
//        removeListeners()
//        removeMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
//        quitgroup(id: usersList.data?[currentIndex].groupID ?? "")
//
//        removeObserver(id: usersList.data?[currentIndex].profileID ?? 0)
//        removeObserverForRanking(id: usersList.data?[currentIndex].profileID ?? 0)
//        removeObserverForDailyEarning(id: usersList.data?[currentIndex].profileID ?? 0)
//        updateUserBroadStatus(profileID: self.usersList.data?[currentIndex].profileID ?? 0, type: "5")
//        
//        NotificationCenter.default.removeObserver(self)
//        callMemberList = false
//        tblView = nil
//        
//        KingfisherManager.shared.cache.clearDiskCache()
//        KingfisherManager.shared.cache.clearMemoryCache()
//        V2TIMManager.sharedInstance().removeGroupListener(listener: messageListener)
//        messageListener = MessageListener()

    }
    
    func distributionClicked(openWebView: Bool) {
        
        print("Web view kholna hai yhn pr link pass krke. \(openWebView)")
    
      
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BottomWebViewViewController") as! BottomWebViewViewController
        print("THe current host id is:\(usersList.data?[currentIndex].profileID ?? 0)")
        vc.url = "https://zeep.live/top-fans-ranking?userid=\(usersList.data?[currentIndex].profileID ?? 0)"
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
        
        print("Reward wala view kholna hai. \(isClicked)")
        
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
        
        print("Button audience list click hui hai")
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
    
    func userData(selectedUserIndex: Int) {
        print("THe selected userindex in the joineduser list is: \(selectedUserIndex)")
//        print("\(groupJoinUsers[selectedUserIndex])")
        
                if let sheetController = sheetController {
                        sheetController.animateOut()
                        sheetController.dismiss(animated: true)
                    }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        selectedIndexForProfileDetails = selectedUserIndex
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
    
    func viewProfileDetails(isClicked: Bool, userID:String) {
        
        print("User ki profile details wala page kholna hai.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
//        if !groupJoinUsers.isEmpty && selectedIndexForProfileDetails < groupJoinUsers.count {
//            nextViewController.userId = groupJoinUsers[selectedIndexForProfileDetails].userID ?? "0"
//        } else {
//
//            nextViewController.userId = "0" // or provide a default value
//        }

        nextViewController.userID = userID
        nextViewController.callForProfileId = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func cellIndexClicked(index: Int) {
        print("The index when clicking on the collection view cell is: \(index)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        selectedIndexForProfileDetails = index
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
    
    func openLowBalanceView(isclicked: Bool) {
        print("View Total Coin Press hua tha. Low Balance wala popup kholkr dikhana hai.")
       
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
        getPoints()
        
    }
    
    func startOneToOneCallWork() {
      
        let userCoins = UserDefaults.standard.string(forKey: "coins")
        print("The User Coins is: \(userCoins)")
        
        let hostCallRate = usersList.data?[currentIndex].newCallRate ?? 0
        print("The host call rate is: \(hostCallRate)")
        
        let coinForHostCall = (hostCallRate * 60)
        print("The coin required for calling host is: \(coinForHostCall)")
        
        if ((Int(userCoins ?? "0") ?? 0) >= (Int(coinForHostCall))) {
            
            print("User ke wallet main balance hai. Call lga lenge hum log")
            print("The User Coins in integer is: \(Int(userCoins ?? "0") ?? 0)")
          //  oneToOneCallDial()
            oneToOneCallDialInBroad()
            
        } else {
            
            print("User ke wallet main balance nahi hai. Call nahi lgegi.")
            
            if let sheetController = sheetController {
                    sheetController.dismiss(animated: true)
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
    
    func buttonFollowPressed(isPressed: Bool) {
        print("Follow host button pressed.")
        follow()
    }
    
    func buttonJoinMicPressed(isPressed: Bool) {
        print("The button join mic is pressed. to start the join mic work.")
        
        let milliseconds = GlobalClass.sharedInstance.currentUTCms() //currentUTCms()
        print("Current UTC Time in Milliseconds:", milliseconds)

        let utcTime = GlobalClass.sharedInstance.millisecondsToUniversalTime(milliseconds: milliseconds)
        print("Current Universal Time:", utcTime)
        
        guard let userid = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let params = [
         
            "invitelog_userid": userid,
            "name": (UserDefaults.standard.string(forKey: "UserName") ?? ""),
            "profile": (UserDefaults.standard.string(forKey: "profilePicture") ?? ""),
            "time": milliseconds

        ] as [String : Any]
        
        print("The parameters we are sending for join mic joining is: \(params)")
        
        ZLFireBaseManager.share.sendCoHostInviteToFirebase(userid: userid, parameter: params,hostid: (usersList.data?[currentIndex].profileID ?? 0))
        ZLFireBaseManager.share.updateCoHostInviteStatusToFirebaseForUser(hostid: String(usersList.data?[currentIndex].profileID ?? 0), status: "request")
        addObserverForJoinMicSentRequest(id: (usersList.data?[currentIndex].profileID ?? 0))
        
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
    
    func leaveMicPressed(isPressed: Bool) {
        
        print("Leave Mic is pressed in the Watching Broad Page. For Leaving the join mic.")
        removeLiveAsCoHost()
        hasJoinedMic = false
        
    }
    
    func muteMicPressed(isPressed: Bool) {
        
        print("Mute Mic is pressed in the Watching Broad Page.")
        
    }
    
    func openProfileDetails(isPressed: Bool) {
        
        print("Open User Profile Details is being Clicked in the Watching Broad Page.")
        
    }
    
    func muteMic(isPressed: String) {
        
        print("The button to mute the mic by the user is pressedd.")
        
        if (isPressed == "host") {
            
            print("User ke mic ko host ne mute kar diya hai. yhn par toast type ka message dikhaenge user ko.")
           
            let config = ToastConfiguration(
                direction: .bottom
            )
            
            let toast = Toast.text("You have been muted by the host!",config: config)
            toast.show()
            
        } else {
            if (isPressed == "true") {
                print("Speaker Ko unMute kar dena hai.")
                if (isMutedByHost == true) {
                    ZegoExpressEngine.shared().muteMicrophone(true)
                } else {
                    ZegoExpressEngine.shared().muteMicrophone(false)
                }
            } else {
                print("Speaker ko Mute kar dena hai.")
                ZegoExpressEngine.shared().muteMicrophone(true)
            }
            
        }
    }
    
}

// MARK: - EXTENSION FOR USING DELEGATES METHODS WHEN THE PK IS BEING PLAYING

extension SwipeUpDownTestingViewController: delegatePKViewTableViewCell {

    func pkmuteMic(isPressed: String) {
        
        print("Mute pk mic is pressed: \(isPressed)")
        
        if (isPressed == "host") {
            
            print("User ke mic ko host ne mute kar diya hai. yhn par toast type ka message dikhaenge user ko.")
           
            let config = ToastConfiguration(
                direction: .bottom
            )
            
            let toast = Toast.text("You have been muted by the host!",config: config)
            toast.show()
            
        } else {
            if (isPressed == "true") {
                print("Speaker Ko unMute kar dena hai.")
                if (isMutedByHost == true) {
                    ZegoExpressEngine.shared().muteMicrophone(true)
                } else {
                    ZegoExpressEngine.shared().muteMicrophone(false)
                }
            } else {
                print("Speaker ko Mute kar dena hai.")
                ZegoExpressEngine.shared().muteMicrophone(true)
            }
            
        }
    }
   
    func pkgiftButton(isPressed: Bool) {
        print("PK gift button pressed hui hai")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowGiftViewController") as! ShowGiftViewController
        vc.delegate = self
        vc.sendUserModel = usersList.data?[currentIndex] ?? ListData()
        vc.cameFrom = "pk"
        vc.groupID = usersList.data?[currentIndex].groupID ?? ""
        vc.opponentGroupID = opponentGroupId
        
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
    
    func pkuserDetailsPressed(selectedIndex: Int) {
        print("PK User Details Pressed hui hai")
        var user = joinedGroupUserProfile()
        
        user.userID = String(usersList.data?[currentIndex].profileID ?? 0)
        user.nickName = usersList.data?[currentIndex].name ?? "N/A"
        user.faceURL = usersList.data?[currentIndex].profileImage ?? ""
        user.richLevel = String(usersList.data?[currentIndex].level ?? 0)
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        nextViewController.messageDetails = user
        nextViewController.delegate = self
        nextViewController.viewFrom = "message"
        nextViewController.hostFollowed = hostFollowed
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
    }
    
    func pkcloseBroad(isPressed: Bool , status : Int) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
        nextViewController.delegate = self
        nextViewController.headingText = "Are you sure you want to close?"
        nextViewController.buttonName = "Yes"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
        print("PK main broad bnd karni hai")
//        ZegoExpressEngine.shared().logoutRoom()
//        ZegoExpressEngine.destroy(nil)
//        self.navigationController?.popViewController(animated: true)
//        
//        removeSwipeGestures()
//        removeUserOnMic()
//        removeListeners()
//        removeMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
//        quitgroup(id: usersList.data?[currentIndex].groupID ?? "")
//
//        removeObserver(id: usersList.data?[currentIndex].profileID ?? 0)
//        removeObserverForRanking(id: usersList.data?[currentIndex].profileID ?? 0)
//        removeObserverForDailyEarning(id: usersList.data?[currentIndex].profileID ?? 0)
//        updateUserBroadStatus(profileID: self.usersList.data?[currentIndex].profileID ?? 0, type: "5")
//        
//        NotificationCenter.default.removeObserver(self)
//        callMemberList = false
//        tblView = nil
//      
//        KingfisherManager.shared.cache.clearDiskCache()
//        KingfisherManager.shared.cache.clearMemoryCache()
//        V2TIMManager.sharedInstance().removeGroupListener(listener: messageListener)
//        messageListener = MessageListener()

    }
    
    func pkdistributionClicked(openWebView: Bool) {
        print("PK main distribution view par click hua hai")
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BottomWebViewViewController") as! BottomWebViewViewController
        print("THe current host id is:\(usersList.data?[currentIndex].profileID ?? 0)")
        vc.url = "https://zeep.live/top-fans-ranking?userid=\(usersList.data?[currentIndex].profileID ?? 0)"
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
    
    func pkviewRewardClicked(isClicked: Bool) {
        print("PK main reward view par click hua hai dekhne ke liye")
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
    
    func pkbuttonAudienceList(isClicked: Bool) {
        print("PK main audience list dekhne ke liye button dabi hai")
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
                  
            print("sheet band ho gayi hai audience list wali pk main")
            self.vcAudiencePresent = false
            
        }
    }
    
    func pkcellIndexClicked(index: Int) {
        print("PK main cell par click hua hai.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        selectedIndexForProfileDetails = index
        if let selectedUser = userInfoList?[index] {
            nextViewController.broadGroupJoinuser = selectedUser
        } else {
            print("broad join user ki array khali hai")
        }
        nextViewController.delegate = self
        nextViewController.hostFollowed = hostFollowed
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
    }
    
    func pkmessageClicked(userImage: String, userName: String, userLevel: String, userID: String) {
        print("PK main message par click hua hai")
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
    
    func pkgameButtonClicked(isClicked: Bool) {
        print("PK main game button par click hua hai")
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
    
    func pkFirstViewClicked(isClicked: Bool) {
        print("PK main pehle view par click hua hai")
        var user = joinedGroupUserProfile()
        
        user.userID = String(usersList.data?[currentIndex].profileID ?? 0)
        user.nickName = usersList.data?[currentIndex].name ?? "N/A"
        user.faceURL = usersList.data?[currentIndex].profileImage ?? ""
        user.richLevel = String(usersList.data?[currentIndex].level ?? 0)
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        nextViewController.messageDetails = user
        nextViewController.delegate = self
        nextViewController.viewFrom = "message"
        nextViewController.hostFollowed = hostFollowed
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func pkSecondViewClicked(isClicked: Bool) {
        print("PK main second view par click hua hai")
       
        var user = joinedGroupUserProfile()
        
        user.userID = opponentProfileID
        user.nickName = opponentName
        user.faceURL = opponentProfileImage
        user.richLevel = opponentLevel
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
        nextViewController.messageDetails = user
        nextViewController.delegate = self
        nextViewController.viewFrom = "message"
        nextViewController.hostFollowed = hostFollowed
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func giftedUserPressed(userID: Int, userName: String, userImage: String) {
        print("The gifted user id is: \(userID)")
        print("The gifted user name is: \(userName)")
        print("The gifted user image is: \(userImage)")
        
        if (userID == 0) {
            print("Koi user nahi hai gift wale par. To popup nahi dikhana hai")
        } else {
            var user = joinedGroupUserProfile()
            
            user.userID = String(userID)
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

// MARK - PK GIFT SENDING FUNCTIONALITY AND ITS WORKIGN AND UPDATION ON FIREBASE NODE
    
    func pkGiftSent(giftAmount: Int, userName: String, userImage: String, userID: String, from: String) {
        print(giftAmount)
        print(userName)
        print(userImage)
        print(userID)
        print(from)
        
        pkUserTotalGiftCoins += giftAmount
        print("The total gift coin for user is: \(pkUserTotalGiftCoins)")
        
        let id = String(usersList.data?[currentIndex].profileID ?? 0)
        
        ZLFireBaseManager.share.updateMyUserPKGiftCoinsToFirebase(hostid: id, totalAmount: pkUserTotalGiftCoins)
        ZLFireBaseManager.share.updateOpponentUserPKGiftCoinsToFirebase(hostid: (Int(opponentProfileID) ?? 0), totalAmount: pkUserTotalGiftCoins)
        
        var dic = [String: Any]()
        dic["totalGift"] = giftAmount
        dic["type"] = 1
        dic["userID"] = Int(userID)
        dic["userImage"] = userImage
        dic["userName"] = userName
        
        pkUserGiftDetail.totalGift = giftAmount
        pkUserGiftDetail.type = 1
        pkUserGiftDetail.userID = Int(userID)
        pkUserGiftDetail.userImage = userImage
        pkUserGiftDetail.userName = userName
        pkGiftList.append(pkUserGiftDetail)
       
        pkGiftList.sort { $0.totalGift ?? 0 > $1.totalGift ?? 0 }
        print("The pk gift list model after sorting is: \(pkGiftList)")
        
            let pkGift = pkGiftList[0]
            let firstdic = pkGift.toDictionary()
            ZLFireBaseManager.share.updatePKGiftUserDetailToFirebase(hostid: id, updateTo: "User1", value: firstdic)
        
        
            let pkGift1 = pkGiftList[1]
            let seconddic = pkGift1.toDictionary()
            ZLFireBaseManager.share.updatePKGiftUserDetailToFirebase(hostid: id, updateTo: "User2", value: seconddic)
        
            let pkGift2 = pkGiftList[2]
            let thirddic = pkGift2.toDictionary()
            ZLFireBaseManager.share.updatePKGiftUserDetailToFirebase(hostid: id, updateTo: "User3", value: thirddic)
    
            ZLFireBaseManager.share.updateOpponentPKGiftUserDetailToFirebase(hostid: (Int(opponentProfileID) ?? 0), updateTo: "User1", value: firstdic)
            ZLFireBaseManager.share.updateOpponentPKGiftUserDetailToFirebase(hostid: (Int(opponentProfileID) ?? 0), updateTo: "User2", value: seconddic)
            ZLFireBaseManager.share.updateOpponentPKGiftUserDetailToFirebase(hostid: (Int(opponentProfileID) ?? 0), updateTo: "User3", value: thirddic)
        
//        ZLFireBaseManager.share.updatePKGiftUserDetailToFirebase(hostid: id,updateTo: "User1" ,value: dic)
//        ZLFireBaseManager.share.updatePKGiftUserDetailToFirebase(hostid: id,updateTo: "User2" ,value: dic)
//        ZLFireBaseManager.share.updatePKGiftUserDetailToFirebase(hostid: id,updateTo: "User3" ,value: dic)
        
    }
    
    func pkuserOnMic(index: Int) {
        
        print("The user on mic index clicked is: \(index)")
        
        guard let userid = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        print("The user id in join mic comparison is: \(userid)")
        
        if zegoMicUsersList.indices.contains(index) {

            let id = zegoMicUsersList[index].coHostID ?? ""
            
        if (id == userid) {
            
            print("User ne broad join kiya hua hai.")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinMicUserOptionsViewController") as! JoinMicUserOptionsViewController
            nextViewController.cameFrom = "user"
            nextViewController.userName = zegoMicUsersList[index].coHostUserName ?? "N/A"
            nextViewController.userImage = zegoMicUsersList[index].coHostUserImage ?? ""
            nextViewController.delegate = self
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
            
        } else {
            
            var user = joinedGroupUserProfile()
            
            user.userID = userID
            user.nickName = zegoMicUsersList[index].coHostUserName ?? "N/A"
            user.faceURL = zegoMicUsersList[index].coHostUserImage ?? ""
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.hostFollowed = hostFollowed
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
            
        }
    } else {
            // Handle the case where the index is out of bounds
            print("Index out of bounds")
        }
        
    }
    
    func pkOpponentuserOnMic(index: Int) {
        
        print("The Opponent mic index clicked is: \(index)")
        
        // Check if the index is within the bounds of the zegoMicUsersList array
        if zegoOpponentMicUsersList.indices.contains(index) {
            // Access the mic user details at the specified index
            var user = joinedGroupUserProfile()
            user.userID = zegoOpponentMicUsersList[index].coHostID
            user.nickName = zegoOpponentMicUsersList[index].coHostUserName
            user.faceURL = zegoOpponentMicUsersList[index].coHostUserImage
            user.richLevel = zegoOpponentMicUsersList[index].coHostLevel

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
            nextViewController.messageDetails = user
            nextViewController.delegate = self
            nextViewController.viewFrom = "message"
            nextViewController.hostFollowed = hostFollowed
            nextViewController.modalPresentationStyle = .overCurrentContext

            present(nextViewController, animated: true, completion: nil)
        } else {
            // Handle the case where the index is out of bounds
            print("Index out of bounds")
        }
        
    }
    
    func pkButtonFollowPressed(isPressed: Bool) {
        print("Follow Host Pressed in PK Cell")
        follow()
    }
    
    func pkmicButtonPressed(isPressed: Bool) {
        
        print("MIC MUTE BUTTON pressed in PK To mute the speaker to mute mic")
        if (isPressed == true) {
            print("Speaker Ko unMute kar dena hai.")
            ZegoExpressEngine.shared().muteSpeaker(false)
        } else {
            print("Speaker ko Mute kar dena hai.")
            ZegoExpressEngine.shared().muteSpeaker(true)
        }
        
    }
    
    func pkbuttonOneToOnePressed(isPressed: Bool) {
        
        print("Button One to One call in pk clicked. Start one to one process.")
        getPoints()
        
    }
    
    func pkbuttonJoinMicPressed(isPressed: Bool) {
        
        print("Button Join Mic Pressed in Swipe Up Down View Controller For Joining Mic.")
        
        let milliseconds = GlobalClass.sharedInstance.currentUTCms() //currentUTCms()
        print("Current UTC Time in Milliseconds:", milliseconds)

        let utcTime = GlobalClass.sharedInstance.millisecondsToUniversalTime(milliseconds: milliseconds)
        print("Current Universal Time:", utcTime)
        
        guard let userid = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        let params = [
         
            "invitelog_userid": userid,
            "name": (UserDefaults.standard.string(forKey: "UserName") ?? ""),
            "profile": (UserDefaults.standard.string(forKey: "profilePicture") ?? ""),
            "time": milliseconds

        ] as [String : Any]
        
        print("The parameters we are sending for join mic joining is: \(params)")
        
        ZLFireBaseManager.share.sendCoHostInviteToFirebase(userid: userid, parameter: params,hostid: (usersList.data?[currentIndex].profileID ?? 0))
        ZLFireBaseManager.share.updateCoHostInviteStatusToFirebaseForUser(hostid: String(usersList.data?[currentIndex].profileID ?? 0), status: "request")
        addObserverForJoinMicSentRequest(id: (usersList.data?[currentIndex].profileID ?? 0))
        isPK = true
        
    }
    
}
// MARK: - EXTENSION FOR USING ZEGO FUNCTION AND KNOWING THE BROAD STATUS

extension SwipeUpDownTestingViewController {
    
    private func createEngine() {
         
        if let cell = self.tblView?.visibleCells.first as? LiveRoomCellTableViewCell {
            // Your code using 'cell' here
            playCanvas.view = cell.imgView
            // ...
        } else {
            // Handle the case where there are no visible cells or the expected cell type is not found
            // For instance, log an error or perform appropriate actions.
        }
        
         NSLog(" 🚀 Create ZegoExpressEngine")
         let profile = ZegoEngineProfile()
         profile.appID = KeyCenter.appID
         profile.appSign = KeyCenter.appSign
         profile.scenario = ZegoScenario.general
        
         print(KeyCenter.appID)
         print(KeyCenter.appSign)
         
        ZegoExpressEngine.setRoomMode(.multiRoom)
         ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
         
         ZegoExpressEngine.shared().muteMicrophone(false)
         ZegoExpressEngine.shared().muteSpeaker(false)
         ZegoExpressEngine.shared().enableCamera(true)
         ZegoExpressEngine.shared().enableHardwareEncoder(false)
        
       //  ZegoExpressEngine.shared().createRealTimeSequentialDataManager("123456")
         
//         playCanvas.view = cell.viewMain
         playCanvas.viewMode = playViewMode
         
//         DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
//            // print("The Stream id in zego is \(self.streamId)")
//             self.startLive(roomID: self.room, streamID: self.broad)
//             
//         }
         
     }

 // MARK: - FUNCTION TO START PLAYING LIVE STREAM / JOIN A LIVE ROOM
    
    private func stopPlayingStream(streamID: String) {
         
         ZegoExpressEngine.shared().stopPlayingStream(streamID)
        ZegoExpressEngine.shared().logoutRoom()
        
     }
    
    private func startLive(roomID: String, streamID: String) {
         NSLog(" 🚪 Start login room, roomID: \(roomID)")
        
        NSLog(" 🚪 Logout room")
      //  ZegoExpressEngine.shared().logoutRoom()
//         let config = ZegoRoomConfig()
//         config.isUserStatusNotify = true
//         ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: String(usersList.data?[currentIndex].id ?? 0)), config: config)
        
        ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
        ZegoExpressEngine.shared().setEventHandler(self)
       //  ZegoExpressEngine.shared().createRealTimeSequentialDataManager("123456")
         
         NSLog(" 📥 Start playing stream, streamID: \(streamID)")
        print("The play canvas is: \(playCanvas)")
        let config = ZegoPlayerConfig()
        config.roomID = roomID
        
         ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: playCanvas,config: config)
        
         //updateFirebaseDatabase()
     }

}

// MARK: - EXTENSION FOR THE CALLBACK FUNCTIONS FROM THE ZEGO TO KNOW THE CURRENT STATE OF THE ZEGO.

extension SwipeUpDownTestingViewController: ZegoEventHandler {
    
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
        //user received
        
        
//        let cell = self.tblView.visibleCells[0] as! LiveRoomCellTableViewCell
        //add stream
        if(updateType == ZegoUpdateType.add){

//                cell.imgView.image = nil
           //     joinGroup(id: usersList.data?[currentIndex].groupID ?? "")
            if (isPK == true) {
             //   group.leave()
                
                    
                if let cell = self.tblView?.visibleCells[0] as? PKViewTableViewCell {
                    
                    cell.userID = usersList.data?[currentIndex].id ?? 0
                    
                    let config = ZegoPlayerConfig()
                    config.roomID = room
                    
                    let zegocanvas = ZegoCanvas(view: cell.viewPKFirstUserOutlet)
                    zegocanvas.viewMode = .aspectFill
                    ZegoExpressEngine.shared().startPlayingStream(broad, canvas: zegocanvas,config: config)
                    //ZegoExpressEngine.shared().startPreview(zegocanvas)
                    
                    let config1 = ZegoPlayerConfig()
                    config1.roomID = secondRoom
                    
                    let zegocanvas2 = ZegoCanvas(view: cell.viewPKSecondUserOutlet)
                    zegocanvas2.viewMode = .aspectFill
                    ZegoExpressEngine.shared().startPlayingStream(secondBroad, canvas: zegocanvas2,config: config1)
                    cell.lblPKSecondUserName.text = opponentName
                    
                    if (hostFollowed == 0) {
                        
                        cell.btnFollowUserOutlet.isHidden = false
                        cell.btnFollowWidthConstraints.constant = 30
                        
                    } else {
                        
                        cell.btnFollowUserOutlet.isHidden = true
                        cell.btnFollowWidthConstraints.constant = 0
                        
                    }
                }
            } else {
                let cell = self.tblView?.visibleCells[0] as! LiveRoomCellTableViewCell
                
                let config = ZegoPlayerConfig()
                config.roomID = room
                
                let zegocanvas = ZegoCanvas(view: cell.imgView)
                zegocanvas.viewMode = .aspectFill
                ZegoExpressEngine.shared().startPlayingStream(broad, canvas: zegocanvas,config: config)
                cell.viewLuckyGift.isHidden = true
                cell.viewUserBusy.isHidden = true
                cell.viewEndUserDetails.isHidden = true
                cell.viewEndView.isHidden = true
                cell.lblName.isHidden = true
                cell.userID = usersList.data?[currentIndex].id ?? 0
                if (hostFollowed == 0) {
                    
                    cell.btnFollowHostOutlet.isHidden = false
                    cell.btnFollowWidthConstraints.constant = 30
                } else {
                    
                    cell.btnFollowHostOutlet.isHidden = true
                    cell.btnFollowWidthConstraints.constant = 0
                }
                cell.unhideViews()
                //   cell.lblViewersCount.text = "10"
                //            startLive(roomID: room, streamID: broad)
            }
        } else if(updateType == ZegoUpdateType.delete){
            //delete stream
            print("delete stream par aaya hai zego mai")
            
            //            stopPlayingStream(streamID: ((usersList.data?[currentIndex].broadChannelName)!) + "_stream")
            //  quitgroup(id: usersList.data?[currentIndex].groupID ?? "")
            if (isPK == true) {
                print("PK true hai")
            } else {
//                let cell = self.tblView?.visibleCells[0] as! LiveRoomCellTableViewCell
//                cell.hideViews()
                
//                cell.lblEndViewUserName.text = usersList.data?[currentIndex].name ?? "N/A"
//                cell.imgView.image = UIImage(named: "endbackgroundviewimage")
//                cell.viewEndUserDetails.isHidden = false
//                cell.lblName.isHidden = false
//                cell.lblName.text = "LIVE ENDED"
//                cell.viewUserBusy.isHidden = true
//                cell.viewEndView.isHidden = false
//                cell.btnJoinMicOutlet.isHidden = true
//                loadImage(from: usersList.data?[currentIndex].profileImage, into: cell.imgViewEndUserDetail)
                
            }
        }
    }
    
    func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
        NSLog(" 🚩 🚪 Room state update, state: \(state.rawValue), errorCode: \(errorCode), roomID: \(roomID)")
        //    roomState = state
        print(errorCode)
        print(state)
        
    }
    
    func onPlayerStateUpdate(_ state: ZegoPlayerState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
        NSLog(" 🚩 📥 Player state update, state: \(state.rawValue), errorCode: \(errorCode), streamID: \(streamID)")
        // playerState = state
        print(state)
        print(errorCode)
        
    }
  
    func onPlayerVideoSizeChanged(_ size: CGSize, streamID: String) {
        
        //  videoSize = size
        print(size)
    
        guard let cell = self.tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
        return
    }
        
        if size.width == 0 && size.height == 0 {
               // The size is zero
               print("Video size is zero.")

            cell.hostFollow = hostFollowed
            cell.hideViews()
            cell.viewUserBusy.isHidden = false
            cell.lblName.text = "Live Ended"
            cell.viewEndUserDetails.isHidden = false
            cell.btnJoinMicOutlet.isHidden = true
           } else {
               // The size is not zero
               print("Video size is \(size)")
            
               cell.hostFollow = hostFollowed
               cell.unhideViews()
               cell.viewEndUserDetails.isHidden = true
           }
        
    }
    
    func onPlayerRecvVideoFirstFrame(_ streamID: String) {
        
        print("On recieve video first frame is: \(streamID)")
        
    }
    
    func onRemoteMicStateUpdate(_ state: ZegoRemoteDeviceState, streamID: String) {
        print(state)
        print(streamID)
        
    }
    
    func onPlayerRecvAudioFirstFrame(_ streamID: String) {
        print(streamID)
    }
    
    func onRoomExtraInfoUpdate(_ roomExtraInfoList: [ZegoRoomExtraInfo], roomID: String) {
        
        print("The extra info we are getting from the Zego is: \(roomExtraInfoList)")
        print("The extra info room id is: \(roomID)")
        print("The extra info room details count is: \(roomExtraInfoList.count)")
        
        print(roomExtraInfoList)
        print(roomExtraInfoList[0])
        print("The room values are: \(roomExtraInfoList.first?.value)")
        
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
                                                        
                                                         if (roomID == room ) {
                                                             print("Room ID same hai yhn par ehi kaam krenge jo chal raha hai.")
                                                             
                                                        if zegoMicUsersList.contains(where: { $0.coHostID == micUser.coHostID }) {
                                                            // There is already an element with the same coHostID in zegoMicUsersList
                                                            if ( micUser.coHostUserStatus != "add") {
                                                                
                                                                let streamID = room + micUser.coHostID! + "_cohost_stream"
                                                                print("THe stream id we are passing in case to remove join mic is: \(streamID)")
                                                                
                                                                ZegoExpressEngine.shared().stopPlayingStream(streamID)
                                                                
                                                                zegoMicUsersList.removeAll(where: { $0.coHostID == micUser.coHostID })
                                                                print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                                guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                    return
                                                                }
                                                                cell.usersOnMic(data: zegoMicUsersList)
                                                            } else {
                                                                
                                                                print("Dekh rhain hai yhn aaega kya...")
                                                                let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                print("The user joined id we are checking is : \(id)")
                                                                
                                                                if (id == micUser.coHostID) {
                                                                    guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                        return
                                                                    }
                                                                    
                                                                    if (micUser.coHostAudioStatus?.lowercased() == "mute") {
                                                                        isMutedByHost = true
                                                                        ZegoExpressEngine.shared().muteMicrophone(true)
                                                                        print("Microphone ko mute kar diya hai.")
                                                                        cell.isMicMutedByHost = true
                                                                        cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                                    } else {
                                                                       
                                                                        isMutedByHost = false
                                                                        ZegoExpressEngine.shared().muteMicrophone(false)
                                                                        print("Microphone ko unmute kar diya hai.")
                                                                        cell.isMicMutedByHost = false
                                                                        cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                                    }
                                                                    
                                                                print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                                } else {
                                                                    print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
                                                                }
                                                                
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
                                                                
                                                                let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                print("The user joined id we are checking is : \(id)")
                                                                
                                                                if (id == micUser.coHostID) {
                                                                    guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                        return
                                                                    }
                                                                    
                                                                    if (i.coHostAudioStatus?.lowercased() == "mute") {
                                                                    
                                                                        isMutedByHost = true
                                                                        ZegoExpressEngine.shared().muteMicrophone(true)
                                                                        print("Microphone ko mute kar diya hai.")
                                                                        cell.isMicMutedByHost = true
                                                                        cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                                    } else {
                                                                       
                                                                        isMutedByHost = false
                                                                        ZegoExpressEngine.shared().muteMicrophone(false)
                                                                        print("Microphone ko unmute kar diya hai.")
                                                                        cell.isMicMutedByHost = false
                                                                        cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                                    }
                                                                    
                                                                print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                                } else {
                                                                    print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
                                                                }
                                                                
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
                                                                     guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                         // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                         return
                                                                     }
                                                                     cell.opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                                 }  else {
                                                                     
                                                                     print("Dekh rhain hai yhn aaega kya...")
                                                                     let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                     print("The user joined id we are checking is : \(id)")
                                                                     
                                                                     if (id == micUser.coHostID) {
                                                                         guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                             // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                             return
                                                                         }
                                                                         
                                                                         if (micUser.coHostAudioStatus?.lowercased() == "mute") {
                                                                             isMutedByHost = true
                                                                             ZegoExpressEngine.shared().muteMicrophone(true)
                                                                             print("Microphone ko mute kar diya hai.")
                                                                             cell.isMicMutedByHost = true
                                                                             cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                                         } else {
                                                                            
                                                                             isMutedByHost = false
                                                                             ZegoExpressEngine.shared().muteMicrophone(false)
                                                                             print("Microphone ko unmute kar diya hai.")
                                                                             cell.isMicMutedByHost = false
                                                                             cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                                         }
                                                                         
                                                                     print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                                     } else {
                                                                         print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
                                                                     }
                                                                     
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
                                                                     
                                                                     let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                     print("The user joined id we are checking is : \(id)")
                                                                     
                                                                     if (id == micUser.coHostID) {
                                                                         guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                             // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                             return
                                                                         }
                                                                         
                                                                         if (i.coHostAudioStatus?.lowercased() == "mute") {
                                                                         
                                                                             isMutedByHost = true
                                                                             ZegoExpressEngine.shared().muteMicrophone(true)
                                                                             print("Microphone ko mute kar diya hai.")
                                                                             cell.isMicMutedByHost = true
                                                                             cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                                         } else {
                                                                            
                                                                             isMutedByHost = false
                                                                             ZegoExpressEngine.shared().muteMicrophone(false)
                                                                             print("Microphone ko unmute kar diya hai.")
                                                                             cell.isMicMutedByHost = false
                                                                             cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                                         }
                                                                         
                                                                     print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                                     } else {
                                                                         print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
                                                                     }
                                                                     
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
                                            if (isPK == true) {
                                                print("PK wala chal raha hai")
                                                guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                    return
                                                }
                                                if (roomID == room) {
                                                    cell.usersOnMic(data: zegoMicUsersList)
                                                } else {
                                                    cell.opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                }
                                            } else {
                                                print("Live broad chal raha hai")
                                                
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
                                                       print("Host ko hta do yhn se remove ho gyi hai par aaya hai")
                                                       guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                           // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                           return
                                                       }
                                                       cell.usersOnMic(data: zegoMicUsersList)
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
                                                       
                                                       let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                       print("The user joined id we are checking is : \(id)")
                                                       
                                                       if (id == micUser.coHostID) {
                                                           guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                               // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                               return
                                                           }
                                                           
                                                           if (i.coHostAudioStatus?.lowercased() == "mute") {
                                                           
                                                               isMutedByHost = true
                                                               ZegoExpressEngine.shared().muteMicrophone(true)
                                                               print("Microphone ko mute kar diya hai.")
                                                               cell.isMicMutedByHost = true
                                                               cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                           } else {
                                                              
                                                               isMutedByHost = false
                                                               ZegoExpressEngine.shared().muteMicrophone(false)
                                                               print("Microphone ko unmute kar diya hai.")
                                                               cell.isMicMutedByHost = false
                                                               cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                           }
                                                           
                                                       print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                       } else {
                                                           print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
                                                       }
                                                       
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
                                                            guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                return
                                                            }
                                                            cell.opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                        } else {
                                                            
                                                            print("Dekh rhain hai yhn aaega kya...")
                                                            let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                            print("The user joined id we are checking is : \(id)")
                                                            
                                                            if (id == micUser.coHostID) {
                                                                guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                    return
                                                                }
                                                                
                                                                if (micUser.coHostAudioStatus?.lowercased() == "mute") {
                                                                    isMutedByHost = true
                                                                    ZegoExpressEngine.shared().muteMicrophone(true)
                                                                    print("Microphone ko mute kar diya hai.")
                                                                    cell.isMicMutedByHost = true
                                                                    cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                                } else {
                                                                   
                                                                    isMutedByHost = false
                                                                    ZegoExpressEngine.shared().muteMicrophone(false)
                                                                    print("Microphone ko unmute kar diya hai.")
                                                                    cell.isMicMutedByHost = false
                                                                    cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                                }
                                                                
                                                            print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                            } else {
                                                                print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
                                                            }
                                                            
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
                                                            
                                                            let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                            print("The user joined id we are checking is : \(id)")
                                                            
                                                            if (id == micUser.coHostID) {
                                                                guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                    return
                                                                }
                                                                
                                                                if (i.coHostAudioStatus?.lowercased() == "mute") {
                                                                
                                                                    isMutedByHost = true
                                                                    ZegoExpressEngine.shared().muteMicrophone(true)
                                                                    print("Microphone ko mute kar diya hai.")
                                                                    cell.isMicMutedByHost = true
                                                                    cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                                } else {
                                                                   
                                                                    isMutedByHost = false
                                                                    ZegoExpressEngine.shared().muteMicrophone(false)
                                                                    print("Microphone ko unmute kar diya hai.")
                                                                    cell.isMicMutedByHost = false
                                                                    cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                                }
                                                                
                                                            print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                            } else {
                                                                print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
                                                            }
                                                            
                                                        }
                                                    }
                                                }

//                                                zegoMicUsersList.append(micUser)
                                                print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                                // Repeat the same for other properties like coHostUserImage, coHostUserName, coHostUserStatus
                                            
                                                print("The zego mic user list count is: \(zegoMicUsersList.count)")
                                                if (isPK == true) {
                                                    print("PK wala chal raha hai")
                                                    guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                        return
                                                    }
                                                    if (roomID == room) {
                                                        cell.usersOnMic(data: zegoMicUsersList)
                                                    } else {
                                                        cell.opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                    }
                                                } else {
                                                    print("Live broad chal raha hai")
                                                    
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
                                                                        
                                                                        if (isPK != true) {
                                                                            guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                                                                                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                                return
                                                                            }
                                                                            cell.usersOnMic(data: zegoMicUsersList)
                                                                        } else {
                                                                            print("abhi pk chal rha hai")
                                                                        }
                                                                    } else {
                                                                        
                                                                        print("Dekh rhain hai yhn aaega kya...")
                                                                        let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                        print("The user joined id we are checking is : \(id)")
                                                                        
                                                                        if (id == micUser.coHostID) {
                                                                            guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                                                                                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                                return
                                                                            }
                                                                            
                                                                            if (micUser.coHostAudioStatus?.lowercased() == "mute") {
                                                                                isMutedByHost = true
                                                                                ZegoExpressEngine.shared().muteMicrophone(true)
                                                                                print("Microphone ko mute kar diya hai.")
                                                                                cell.isMicMutedByHost = true
                                                                                cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                                            } else {
                                                                               
                                                                                isMutedByHost = false
                                                                                ZegoExpressEngine.shared().muteMicrophone(false)
                                                                                print("Microphone ko unmute kar diya hai.")
                                                                                cell.isMicMutedByHost = false
                                                                                cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                                            }
                                                                            
                                                                        print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                                        } else {
                                                                            print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
                                                                        }
                                                                        
                                                                    }
                                                                } else {
                                                                    // There is no element with the same coHostID in zegoMicUsersList
                                                                    zegoMicUsersList.append(micUser)
                                                                    for i in zegoMicUsersList {
                                                                        print(i)
                                                                        print(i.coHostID)
                                                                        let streamID = room + i.coHostID! + "_cohost_stream"
                                                                        print("THe stream id we are passing in case of the join mic in live is: \(streamID)")
                                                                        
                                                                        let config = ZegoPlayerConfig()
                                                                        config.roomID = room
                                                                        print("The config. room id in live is: \(broad)")
                                                                        
                                                                        let zegocanvas = ZegoCanvas(view: UIView())
                                                                    
                                                                        ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: zegocanvas, config: config)
                                                                        
                                                                        let id = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                                                                        print("The user joined id we are checking is : \(id)")
                                                                        
                                                                        if (id == micUser.coHostID) {
                                                                            guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                                                                                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                                return
                                                                            }
                                                                            
                                                                            if (i.coHostAudioStatus?.lowercased() == "mute") {
                                                                            
                                                                                isMutedByHost = true
                                                                                ZegoExpressEngine.shared().muteMicrophone(true)
                                                                                print("Microphone ko mute kar diya hai.")
                                                                                cell.isMicMutedByHost = true
                                                                                cell.btnMuteMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
                                                                            } else {
                                                                               
                                                                                isMutedByHost = false
                                                                                ZegoExpressEngine.shared().muteMicrophone(false)
                                                                                print("Microphone ko unmute kar diya hai.")
                                                                                cell.isMicMutedByHost = false
                                                                                cell.btnMuteMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
                                                                            }
                                                                            
                                                                        print("User ne join mic kia tha isliye stream ka microphone host ne mute kiya hai....")
                                                                        } else {
                                                                            print("User ne join mic nahi kia tha isliye stream ko host ne mute nahi kiya hai....")
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
                                                                        
                                                                    }
                                                                }
                                                            }
                                                            if (isPK == true) {
                                                                print("PK wala chal raha hai")
                                                                guard let cell = tblView?.visibleCells[0] as? PKViewTableViewCell else {
                                                                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                    return
                                                                }
                                                                if (roomID == room) {
                                                                    cell.usersOnMic(data: zegoMicUsersList)
                                                                } else {
                                                                    cell.opponentUsersOnMic(data: zegoOpponentMicUsersList)
                                                                }
                                                            } else {
                                                                print("Live broad chal raha hai")
                                                                guard let cell = tblView?.visibleCells[0] as? LiveRoomCellTableViewCell else {
                                                                    // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
                                                                    return
                                                                }
                                                                cell.usersOnMic(data: zegoMicUsersList)
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
//            group.leave()
               break
           case .loginFailed:
               // login failed
               if errorCode == 1002033 {
                   // When using the login room authentication function, the incoming Token is incorrect or expired.
                   print(reason)
                   print(errorCode)
               }
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
    
    func onRemoteAudioSpectrumUpdate(_ audioSpectrums: [String : [NSNumber]]) {
        print(audioSpectrums)
        print(audioSpectrums.count)
        
    }
    
    func onIMRecvCustomCommand(_ command: String, from fromUser: ZegoUser, roomID: String) {
        print(command)  // Check the structure of the received JSON string
        print(fromUser)
        print(roomID)
        print(command.description)
        
    //    let userId = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        
        if let jsonData = command.data(using: .utf8) {
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    print("JSON Data:", json)  // Debugging print for the parsed JSON data
                    
                    // Access values from JSON dictionary
                    // Extract values using nil coalescing operator
                    let senderProfileId = json["sender_profile_id"] as? String ?? ""
                    let userName = json["user_name"] as? String ?? ""
                    let channelName = json["channel_name"] as? String ?? ""
                    let profileImage = json["profile_image"] as? String ?? ""
                    let actionType = json["action_type"] as? String ?? ""
                    let senderId = json["sender_id"] as? String ?? ""
                    let token = json["token"] as? String ?? ""

                    // Print or use the values as needed
                    print("Sender Profile ID: \(senderProfileId)")
                    print("User Name: \(userName)")
                    print("Channel Name: \(channelName)")
                    print("Profile Image: \(profileImage)")
                    print("Action Type: \(actionType)")
                    print("Sender ID: \(senderId)")
                    print("Token: \(token)")

                    // Check action type and sender ID
                    if actionType == "call_request_approved_from_app" {
                        print("One to one call wala kaam shuru karna hai.")
                       
//                            let config = ToastConfiguration(direction: .bottom)
//                            let toast = Toast.text("One to one work started", config: config)
//                            toast.show()
                        
                        isOneToOneStarted = true
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneCallViewController") as! OneToOneCallViewController
                        nextViewController.channelName = oneToOneUniqueID
                        nextViewController.cameFrom = "user"
                        nextViewController.hostName = usersList.data?[currentIndex].name ?? ""
                        nextViewController.hostImage = usersList.data?[currentIndex].profileImage ?? ""
                        nextViewController.hostID = String(usersList.data?[currentIndex].profileID ?? 0)
                        nextViewController.idHost = userID//String(usersList.data?[currentIndex].id ?? 0)
                        nextViewController.hostCallRate = callRate
                        nextViewController.uniqueID = oneToOneUniqueID
                        
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                    } else {
                        print("One to one wala kaam nahi krna hai.")
                    }

                } else {
                    print("Failed to parse JSON data.")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Failed to convert JSON string to data.")
        }
    }

  
    func onIMRecvBarrageMessage(_ messageList: [ZegoBarrageMessageInfo], roomID: String) {
        
        print(messageList)
        print(messageList.count)
        print(messageList[0].description)
        print(messageList[0].message)
        print(messageList[0].messageID)
        print(messageList[0].fromUser.userName)
        print(messageList[0].fromUser.userID)
        print(messageList[0].fromUser)
        
        let result1 = convertStringToDictionary(text: messageList[0].message)
        print(result1)
        
        var result2 = messageList[0].message.contains("action_type")
        print(result2)
        
        var result = messageList[0].message.contains("kickout_all_user_from_app")
        print(result)
        
        if result == true {
        
            let imageDataDict:[String: String] = ["message": "Nikal lo ab tum", "userName": messageList[0].fromUser.userName]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
            
            stopPlayingStream(streamID: broad)
          //  stopLive(roomID: "123456")
          //  destroyEngine()
            
        } else {
            
            let imageDataDict:[String: String] = ["message": messageList[0].message, "userName": messageList[0].fromUser.userName]
            
            // post a notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
        }
    }

// MARK: - FUNCTION TO CONVERT STRING INTO DICTIONARY AND THEN CHECKING IF THE MESSAGE CONTAINS THE PERIMETER FOR LOGOUT
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               print(json)
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
}

// MARK: - EXTENSION FOR USING REALM MODEL FOR LOCAL CHECKING OF FOLLOW AND UNFOLLOW OF HOST BY THE USER

//extension SwipeUpDownTestingViewController {
//    
//    func isUserFollowed(userIdToCheck: String) -> Bool {
//        // Get the current userSelfId from UserDefaults
//        guard let currentUserSelfId = UserDefaults.standard.string(forKey: "UserProfileId"), !currentUserSelfId.isEmpty else {
//            // Return false if no userSelfId is found in UserDefaults
//            return false
//        }
//
//        // Query objects where userSelfId matches the value from UserDefaults
//        let userFollowListsForSelfId = realm.objects(userFollowList.self)
//            .filter("userSelfId == %@", currentUserSelfId)
//
//        // Check if any objects exist for the current user
//        guard !userFollowListsForSelfId.isEmpty else {
//            // If no object matches userSelfId, return false
//            return false
//        }
//
//        // If userSelfId matches, check for the profileId (userIdToCheck)
//        let userFollowListsWithUserId = userFollowListsForSelfId
//            .filter("profileId == %@", userIdToCheck)
//
//        // Return true if an object with the specified profileId exists, false otherwise
//        return !userFollowListsWithUserId.isEmpty
//    }
//
//    
////    func isUserFollowed(userIdToCheck: String) -> Bool {
////        
////        // Query objects based on userId
////        let userFollowListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", userIdToCheck)
////
////        // Check if any objects match the criteria
////        if userFollowListsWithUserId.isEmpty {
////            // No object with the specified userId exists
////            return false
////        } else {
////            // An object with the specified userId exists
////            return true
////        }
////    }
//    
//    func saveUserToFollowList(profileID:String = "") {
//        
//        let userFollowListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", profileID)
//
//        // Check if any objects match the criteria
//        if userFollowListsWithUserId.isEmpty {
//            do {
//                try realm.write {
//                    let followList = userFollowList()
//                    
//                    // Set the properties of the object
//                    followList.userId = ""
//                    followList.profileId = profileID
//                    
//                    realm.add(followList)
//                }
//                
//            } catch let error as NSError {
//                print("Error creating user details: \(error)")
//            }
//        } else {
//            print("User Follow List main pehle se hi hai. Phir se Add karne ki jrurat nahi hai.")
//        }
//        
//    }
//    
//    func removeUserFromFollowList(userIdToRemove: String) {
//        // Get the default Realm instance
//       // let realm = try! Realm()
//
//        // Begin a write transaction
//        try! realm.write {
//            // Query the object to remove based on userId
//            let userBlockListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", userIdToRemove)
//
//            // Check if any objects match the criteria
//            if let userToRemove = userBlockListsWithUserId.first {
//                // Delete the object from the Realm database
//                realm.delete(userToRemove)
//                print("User with ID \(userIdToRemove) removed from block list.")
//            } else {
//                print("User with ID \(userIdToRemove) not found in block list.")
//            }
//        }
//    }
//
//}

// MARK: - EXTENSION FOR API CALLING

extension SwipeUpDownTestingViewController {
    
    func getUsersNearbyList() {
        
        let url = AllUrls.baseUrl + "swipeuplivebroadcastList?type=\(apiType)&page=\(pageNo)"
        print("The url is \(url )")
        ApiWrapper.sharedManager().getUsersList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            lastPage = data?.lastPage ?? 0
            print(lastPage)
            
            if let userList = data?.data {
                print(userList)
                
                if usersList.data == nil {
                    usersList.data = userList
                    
                } else {
                    usersList.data?.append(contentsOf: userList)
                    
                }
            }
            
            tblView.reloadData()

        }
    }
    
    func checkForFollow() {
        
        guard let id = usersList.data?[currentIndex].profileID else {
            print("Error: profileID is nil.")
            return
        }

        let url = "https://zeep.live/api/checkfollowbyyou?profile_id=\(id)"
            
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
                        
                        GlobalClass.sharedInstance.removeUserFromFollowList(userIdToRemove: String(usersList.data?[currentIndex].profileID ?? 0))
                        
                    } else {
                        
                        GlobalClass.sharedInstance.saveUserToFollowList(profileID:  String(usersList.data?[currentIndex].profileID ?? 0))
                        
                    }
                }
                
              
            } else {
                
                print("Api se response mai false aaya hai. matlab kuch gadbad hai.")
               
                
            }
                
           
        })
    }
    
    func getPoints() {
       
        ApiWrapper.sharedManager().getPointsDetails(url: AllUrls.getUrl.getPoints) { [weak self] (value) in
            guard let self = self else { return }
            
            let jsonData = JSON(value)
            print(jsonData)
            
            let gender = (UserDefaults.standard.string(forKey: "gender") ?? "")
            print("The gender in the nearby view controller is: \(gender)")
            
            if (gender.lowercased() == "female") {
                
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
                        UserDefaults.standard.set(gaReportData1.weeklyEarningBeans , forKey: "weeklyearning")
                        print(gaReportData1)
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
                        let redeemPoint = UserDefaults.standard.string(forKey: "earning") ?? "0"
                        print("The redeem point is: \(redeemPoint)")
                        
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
                        //      UserDefaults.standard.set("100000" , forKey: "coins")
                        print(malePointsData)
                        startOneToOneCallWork()
                        
                    }
                }
                
            }
        }
    }
    
//    func getPoints() {
//       
//        ApiWrapper.sharedManager().getPointsDetails(url: AllUrls.getUrl.getPoints) { [weak self] (value) in
//            guard let self = self else { return }
//            
//            let jsonData = JSON(value)
//            print(jsonData)
//            
//                // Decode and print 'result' data
//                if let decodeData = try? jsonData["result"].rawData() {
//                    print(decodeData)
//                    if let gaReportData = try? JSONDecoder().decode(maleResult.self, from: decodeData) {
//                        print(gaReportData)
//                    }
//                }
//                
//                // Decode and print 'weeklyEarningBeansData' data
//                if let decodeData1 = try? jsonData["weeklyEarningBeansData"].rawData() {
//                    print(decodeData1)
//                    if let gaReportData1 = try? JSONDecoder().decode(maleWeeklyEarningBeansData.self, from: decodeData1) {
//                        print(gaReportData1)
//                    }
//                }
//                
//                // Decode and print 'maleBalance' data
//                if let decodeData2 = try? jsonData["maleBalance"].rawData() {
//                    print(decodeData2)
//                    if let gaReportData2 = try? JSONDecoder().decode(MaleBalance.self, from: decodeData2) {
//                        print(gaReportData2)
//                        malePointsData = gaReportData2
//                        UserDefaults.standard.set(malePointsData.purchasePoints , forKey: "coins")
//                  //      UserDefaults.standard.set("100000" , forKey: "coins")
//                        print(malePointsData)
//                        startOneToOneCallWork()
//                        
//                    }
//                }
//            
//        }
//    }
    
    func oneToOneCallDial() {
        
        let connectingUserId = String(usersList.data?[currentIndex].profileID ?? 0)
        let hostCallRate = callRate//String(usersList.data?[currentIndex].newCallRate ?? 0)
        
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
        
        print("The params we are sending for fcm token is: \(params)")
        
        ApiWrapper.sharedManager().callOneToOneNotification(url: AllUrls.getUrl.oneToOneCallSendNotification,parameters: params ,completion: { [weak self] (data, value) in
            guard let self = self else {
                // The object has been deallocated
               
                return
            }
                print(data)
                print(value)
            OneToOneCallData = data ?? OneToOneCallData
            print("The one to one call data is: \(OneToOneCallData)")
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

        })
    }
    
    func oneToOneCallDialInBroad() {
        
        let connectingUserId = String(usersList.data?[currentIndex].profileID ?? 0)
        let hostCallRate = callRate//String(usersList.data?[currentIndex].newCallRate ?? 0)
        
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
        
        print("The params we are sending for getting data for one to one is: \(params)")
        
        ApiWrapper.sharedManager().callOneToOneDialZego(url: AllUrls.getUrl.oneToOneCallDialCallZego,parameters: params ,completion: { [weak self] (data, value) in
            guard let self = self else {
                // The object has been deallocated
               
                return
            }
                print(data)
                print(value)
            
            OneToOneCallData = data ?? OneToOneCallData
            print("The one to one call data is: \(OneToOneCallData)")
            
            let a = value["result"] as? [String : Any]
            let b = a?["data"] as? [String : Any]
            let c = b?["notification"] as? [String : Any]
            
            let id = c?["connecting_id"] as? Int ?? 0
            let token = OneToOneCallData.data?.receiverChannelName?.token?.token ?? ""
            let uID = b?["unique_id"] as? String ?? ""
            print(id)
            print(token)
            print(uID)
            oneToOneUniqueID = uID
            
            sendMessageUsingZego(spid: String(id) , token: token , uniqueid: uID)
           
// yhn pr spid main notification main jo connecting_id aa rhi hai woh rhegi
// aur token mai "token" ke andar jo "token" aa rha hai woh aaega
// aur uniqueid main "data" ke andar jo "unique_id" aa rhi hai woh aaega
            

        })
  
    }
    
    func follow() {
      
      let params = [
          "following_id": userID//usersList.data?[currentIndex].id ?? 0
         
      ] as [String : Any]
      
      print("The parameter for following user is: \(params)")
        
      ApiWrapper.sharedManager().followUser(url: AllUrls.getUrl.followUser,parameters: params) { [weak self] (data) in
          guard let self = self else { return }
          
          if (data["success"] as? Bool == true) {
              print(data)
              
              GlobalClass.sharedInstance.saveUserToFollowList(profileID:  String(usersList.data?[currentIndex].profileID ?? 0))
              
              if (isPK == true) {
                  
                  let cell = self.tblView?.visibleCells[0] as! PKViewTableViewCell
                  cell.btnFollowUserOutlet.isHidden = true
                  cell.btnFollowUserOutlet.isUserInteractionEnabled = true
                  cell.btnFollowWidthConstraints.constant = 0
                  
              } else {
                  let cell = self.tblView?.visibleCells[0] as! LiveRoomCellTableViewCell
                  
                  cell.btnFollowHostOutlet.isHidden = true
                  cell.btnFollowHostOutlet.isUserInteractionEnabled = true
                  cell.btnFollowWidthConstraints.constant = 0
                  print("sab shi hai. kuch gadbad nahi hai")
              }
              
          }  else {
                
              if (isPK == true) {
                  let cell = self.tblView?.visibleCells[0] as! PKViewTableViewCell
                  cell.btnFollowUserOutlet.isHidden = false
                  cell.btnFollowUserOutlet.isUserInteractionEnabled = true
                  cell.btnFollowWidthConstraints.constant = 30
                  
              } else {
                  let cell = self.tblView?.visibleCells[0] as! LiveRoomCellTableViewCell
                  
                  cell.btnFollowHostOutlet.isHidden = false
                  cell.btnFollowHostOutlet.isUserInteractionEnabled = true
                  cell.btnFollowWidthConstraints.constant = 30
                  print("Kuch gadbad hai")
              }
          }
      }
  }
    
    
    func sendMessageUsingZego(spid:String, token: String, uniqueid: String) {
    
        let dic = [
            "sender_id": UserDefaults.standard.string(forKey: "UserProfileId") ?? "",//"229792703",
              "sender_profile_id": spid,//"1710137930578",
              "user_name": UserDefaults.standard.string(forKey: "UserName") ?? "",
              "profile_image": UserDefaults.standard.string(forKey: "profilePicture") ?? "" ,//"1.5",
              "token": token,
              "channel_name": uniqueid,
            "action_type": "call_request_from_user_from_appZ"
           
        ] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Json Ko String main convert kar diya hai.")
                
                var userList = [ZegoUser]()
                let hostID = usersList.data?[currentIndex].profileID ?? 0
                
                let newUser = ZegoUser(userID: String(hostID))
                userList.append(newUser)
                
                ZegoExpressEngine.shared().sendCustomCommand(jsonString, toUserList: userList, roomID: room) { errorCode in
                    if errorCode == 0 {
                        // Custom command sent successfully
                        print("Custom command sent successfully")
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

//     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//        DispatchQueue.main.async { [self] in
//            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
//            scrollView.panGestureRecognizer.isEnabled = false
//
//            previousIndex = currentIndex
//
//            var  isRun = false
//            if(translatedPoint.y < CGFloat(-offsetY) && self.currentIndex < (self.usersList.data!.count - 1)) {
//                self.currentIndex = self.currentIndex + 1
//                NSLog("向下滑动索引递增")
//                print("after translating it means Index increases as you scroll down.")
//                isRun = true
//                newIndex = self.currentIndex + 1
//                print("The new index here jab scroll upar ki trf karenge tb hai: \(newIndex)")
//               // print("Userdata ka jo index ki value hai woh hai: \(usersList.data?[newIndex].id)")
//
//            }
//
//            if(translatedPoint.y > CGFloat(offsetY) && self.currentIndex > 0) {
//                self.currentIndex = self.currentIndex  - 1
//                newIndex = self.currentIndex - 1
//                NSLog("向上滑动索引递减")
//                print("After translating it means Index decreases as you scroll up.")
//                isRun = true
//                print("The new index jab scroll neeche ki trf karenge tab hai: \(newIndex)")
//
//            }
//            if(self.usersList.data!.count > 0){
//
//                UIView.animate(withDuration: 0.15, delay: 0.0) { [self] in
//                    let index = IndexPath(row: currentIndex, section: 0)
//                    tblView?.scrollToRow(at: index , at: UITableView.ScrollPosition.top, animated: false)
//                    print("Yhn par table view ka scroll to row ka current index hai: \(index)")
//                    print("Userdata ka jo index ki value hai woh hai: \(usersList.data?[currentIndex].id)")
//
//                }completion: { finish in
//                    scrollView.panGestureRecognizer.isEnabled = true
//                }
//                if (isRun == true){
//
//                    tblView.reloadData()
//                    print("Jo prevvious index ka remove ho rha hai woh hai: \(previousIndex)")
//                    print("Jo agle index ka add ho rh ahai woh hai: \(currentIndex)")
//
//                    removeMessageObserver(id:usersList.data?[previousIndex].profileID ?? 0)
//                //    addMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
//                    quitgroup(id: usersList.data?[previousIndex].groupID ?? "")
//                 //   joinGroup(id: usersList.data?[currentIndex].groupID ?? "")
//                    removeObserver(id:usersList.data?[previousIndex].profileID ?? 0)
//                    addObserve(id: usersList.data?[currentIndex].profileID ?? 0)
//                    removeObserverForRanking(id:usersList.data?[previousIndex].profileID ?? 0)
//                  //  addObserveForRanking(id: usersList.data?[currentIndex].profileID ?? 0)
//                    removeObserverForDailyEarning(id:usersList.data?[previousIndex].profileID ?? 0)
//                  //  addObserverForDailyEarning(id: usersList.data?[currentIndex].profileID ?? 0)
//
////                    print("Jo broad play honi hai uska id hai: \(usersList.data?[currentIndex].broadChannelName ?? "")")
////                    print("Jo broad play hogi uski stream id hai: \(((usersList.data?[currentIndex].broadChannelName)!) + "_stream")")
//
////                     room = (usersList.data?[currentIndex].broadChannelName ?? "")
////                     broad = (usersList.data?[currentIndex].broadChannelName)! + "_stream"
//
//                    self.view.endEditing(true)
//
////                    self.stopPlayingStream(streamID: ((usersList.data?[previousIndex].broadChannelName)!) + "_stream")
//                    self.stopPlayingStream(streamID: broad)
//                    isLiveStarted = true
//
//                   // self.startLive(roomID: room, streamID: broad)
//
//                    //滚动完成
//                    print("滑动完成")
//                    print("After converted it means Slide Completed")
////                    tblView.reloadData()
//                }
//            }
//        }
//        // tblView.reloadData()
//    }

//        DispatchQueue.global(qos: .background).async {
//
//            self.getGroupMemberList()
//            self.callMemberList = true
////            self.addObserveForRanking(id: self.usersList.data?[self.currentIndex].profileID ?? 0)
////            self.addObserverForDailyEarning(id: self.usersList.data?[self.currentIndex].profileID ?? 0)
//
//        }

//tblView.reloadData()
// tblView.reloadData()
 //        addMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
//        createEngine()

//                            let zegocanvas = ZegoCanvas(view: cell.imgView)
//                            zegocanvas.viewMode = .aspectFill
//                            ZegoExpressEngine.shared().startPlayingStream(broad, canvas: zegocanvas)
//                            joinGroup(id: usersList.data?[currentIndex].groupID ?? "")

//    func getGroupMemberList() {
//
//        callMemberList = false
//        V2TIMManager.sharedInstance()?.getGroupMemberList(usersList.data?[currentIndex].groupID, filter: 0x00, nextSeq: 0, succ: { nextSeq, memberList in
//            // Conversations pulled successfully
////            print("Next Sequence: \(nextSeq)")
////            print("Group Member List: \(memberList?.description)")
//            print("The group member list count is: \(memberList?.count)")
//            print(memberList?.first?.customInfo)
//            if let userIds = memberList?.map({ $0.userID }) {
//                    // Call the method to get detailed information with the list of user IDs
//                if !userIds.isEmpty {
//                       // Call the method to get detailed information with the list of user IDs
//                       self.getUsersInformation(list: Array(Set(userIds)) as! [String])
//                   } else {
//                       // Handle the case where userIds is empty
//                       print("No user IDs found in the memberList.")
//                   }
//                }
//
//            guard let cell = self.tblView.visibleCells[0] as? LiveRoomCellTableViewCell else {
//                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
//                return
//            }
//
//            cell.lblViewersCount.text = String(memberList?.count ?? 0)
//
//
//        }) { code, desc in
//            // Messages failed to be pulled
//            print("Failed to get group member list. Code: \(code), Description: \(desc)")
//            self.callMemberList = false
//        }
//
//    }


//        guard tblView.numberOfRows(inSection: 0) > 0 else {
//            // Handle the case where the table view is empty
//            return
//        }

//        guard let cell = self.tblView.visibleCells.first as? LiveRoomCellTableViewCell else {
//            // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell or visibleCells is empty
//            return
//        }

//                guard let cell = self.tblView.visibleCells[0] as? LiveRoomCellTableViewCell else {
//                // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
//                return
//            }


//            DispatchQueue.global(qos: .background).async {
//
//
//                DispatchQueue.main.async {
//                    // Assuming cell.showJoinedUser has a parameter of type [V2TIMUserFullInfo]
//                    if let userInfoList = self.userInfoList {
//                        cell.showJoinedUser(users: userInfoList)
//                        if (self.vcAudiencePresent == true) {
//                            print("Controller khula hua hai")
//                            NotificationCenter.default.post(name: Notification.Name("groupJoinUsersUpdated"),
//                                                            object: userInfoList)
//
//                        } else {
//                            print("Controller bnd hai")
//                            NotificationCenter.default.removeObserver(self)
//                }
//                    } else {
//                        // Handle the case where userInfoList is nil or empty
//                        cell.showJoinedUser(users: [])
//                    }
//
//               }
//                 }

//   self.startTimer()
//            DispatchQueue.global(qos: .background).async {
//                self.getGroupMemberList()
////                self.getGroupCallBack()
//                self.callMemberList = true
//            }
//            self.getGroupCallBack()

//        messageListener.groupUserEnter = { msgID, text in
//
//            print(msgID)
//            print(text)
//            print("THe group enter callback result are\(msgID) , \(text)")
//            DispatchQueue.global(qos: .background).async {
//
//                if self.callMemberList == true {
//                    self.getGroupMemberList()
//                } else {
//                    print("Abi msg recieve mai group member list wala call nahi hoga")
//                }
//            }
//        }
//
//        messageListener.groupUserLeave = { msgID, text in
//
//            print(msgID)
//            print(text)
//
//            print("THe group leave callback result are\(msgID) , \(text)")
//            DispatchQueue.global(qos: .background).async {
//
//                if self.callMemberList == true {
//                    self.getGroupMemberList()
//                } else {
//                    print("ani msg leave mai group member list call nahi hoga")
//                }
//            }
//
//        }
// addMessageObserver(id: usersList.data?[currentIndex].profileID ?? 0)
//  addObserveForRanking(id: usersList.data?[currentIndex].profileID ?? 0)
//  addObserverForDailyEarning(id: usersList.data?[currentIndex].profileID ?? 0)
// joinGroup(id: usersList.data?[currentIndex].groupID ?? "")
//                            let zegocanvas2 = ZegoCanvas(view: cell.viewPKSecondUserOutlet)
//                            zegocanvas2.viewMode = .aspectFill
//                            ZegoExpressEngine.shared().loginRoom(a, user: ZegoUser(userID: String(usersList.data?[currentIndex].id ?? 0)), config: config)
//                            ZegoExpressEngine.shared().startPlayingStream(a, canvas: zegocanvas2)
//                if (isPK == true) {
//                    guard let cell = tblView.visibleCells[0] as? PKViewTableViewCell else {
//                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
//                        return
//                    }
//
//                    if let count = value["weeklyPoints"] as? String {
//                        let formattedString1 = formatNumber(Int(count) ?? 0)
//
//                        cell.lblDistributionAmount.text = formattedString1
//                    } else {
//                        print("value['count'] is not an integer")
//                        cell.lblDistributionAmount.text = "0"
//                    }
//
//                } else {
//                    guard let cell = tblView.visibleCells[0] as? LiveRoomCellTableViewCell else {
//                        // Handle the case where the cell cannot be cast to LiveRoomCellTableViewCell
//                        return
//                    }
//
//                    if let count = value["weeklyPoints"] as? String {
//                        let formattedString1 = formatNumber(Int(count) ?? 0)
//
//                        cell.lblDistributionAmount.text = formattedString1
//                    } else {
//                        print("value['count'] is not an integer")
//                        cell.lblDistributionAmount.text = "0"
//                    }
//                }

//   if let profileImageURL = usersList.data?[currentIndex].profileImage,
//                           let profileImage = URL(string: profileImageURL) {
//
//                            if let profileImageURL = URL(string: profileImageURL) {
//                                KF.url(profileImageURL)
//                                    .cacheOriginalImage()
//                                    .onSuccess { result in
//                                        DispatchQueue.main.async {
//                                            cell.imgViewUserProfilePhoto.image = result.image
//                                        }
//                                    }
//                                    .onFailure { error in
//                                        print("Image loading failed with error: \(error)")
//                                        cell.imgViewEndUserDetail.image = UIImage(named: "UserPlaceHolderImageForCell")
//                                    }
//                                    .set(to: cell.imgViewEndUserDetail)
//                            } else {
//                                cell.imgViewEndUserDetail.image = UIImage(named: "UserPlaceHolderImageForCell")
//                            }
//                        }

//                        if let imageURL = URL(string: giftDetails["icon"] as? String ?? "") {
//                            KF.url(imageURL)
//                            //  .downsampling(size: CGSize(width: 200, height: 200))
//                                .cacheOriginalImage()
//                                .onSuccess { result in
//                                    DispatchQueue.main.async {
//                                        cell.imgViewGift.image = result.image
//                                    }
//                                }
//                                .onFailure { error in
//                                    print("Image loading failed with error: \(error)")
//                                    cell.imgViewGift.image = UIImage(named: "UserPlaceHolderImageForCell")
//                                }
//                                .set(to: cell.imgViewGift)
//                        } else {
//                            cell.imgViewGift.image = UIImage(named: "UserPlaceHolderImageForCell")
//                        }

//                        if let profileImageURL = URL(string: giftDetails["fromHead"] as? String ?? "") {
//                            KF.url(profileImageURL)
//                            //  .downsampling(size: CGSize(width: 200, height: 200))
//                                .cacheOriginalImage()
//                                .onSuccess { result in
//                                    DispatchQueue.main.async {
//                                        cell.imgViewUser.image = result.image
//                                    }
//                                }
//                                .onFailure { error in
//                                    print("Image loading failed with error: \(error)")
//                                    cell.imgViewUser.image = UIImage(named: "UserPlaceHolderImageForCell")
//                                }
//                                .set(to: cell.imgViewUser)
//                        } else {
//                            cell.imgViewUser.image = UIImage(named: "UserPlaceHolderImageForCell")
//                        }

//                            if let imageURL = URL(string: giftDetails["icon"] as? String ?? "") {
//                                KF.url(imageURL)
//                                //  .downsampling(size: CGSize(width: 200, height: 200))
//                                    .cacheOriginalImage()
//                                    .onSuccess { result in
//                                        DispatchQueue.main.async {
//                                            cell.imgViewGift.image = result.image
//                                        }
//                                    }
//                                    .onFailure { error in
//                                        print("Image loading failed with error: \(error)")
//                                        cell.imgViewGift.image = UIImage(named: "UserPlaceHolderImageForCell")
//                                    }
//                                    .set(to: cell.imgViewGift)
//                            } else {
//                                cell.imgViewGift.image = UIImage(named: "UserPlaceHolderImageForCell")
//                            }

//                            if let profileImageURL = URL(string: giftDetails["fromHead"] as? String ?? "") {
//                                KF.url(profileImageURL)
//                                //  .downsampling(size: CGSize(width: 200, height: 200))
//                                    .cacheOriginalImage()
//                                    .onSuccess { result in
//                                        DispatchQueue.main.async {
//                                            cell.imgViewUser.image = result.image
//                                        }
//                                    }
//                                    .onFailure { error in
//                                        print("Image loading failed with error: \(error)")
//                                        cell.imgViewUser.image = UIImage(named: "UserPlaceHolderImageForCell")
//                                    }
//                                    .set(to: cell.imgViewUser)
//                            } else {
//                                cell.imgViewUser.image = UIImage(named: "UserPlaceHolderImageForCell")
//                            }

//            if let profileImageURL = usersList.data?[currentIndex].profileImage,
//               let profileImage = URL(string: profileImageURL) {
//
//                if let profileImageURL = URL(string: profileImageURL) {
//                    KF.url(profileImageURL)
//                    //  .downsampling(size: CGSize(width: 200, height: 200))
//                        .cacheOriginalImage()
//                        .onSuccess { result in
//                            DispatchQueue.main.async {
//                                cell.imgViewUserImage.image = result.image
//                            }
//                        }
//                        .onFailure { error in
//                            print("Image loading failed with error: \(error)")
//                            cell.imgViewUserImage.image = UIImage(named: "UserPlaceHolderImageForCell")
//                        }
//                        .set(to: cell.imgViewUserImage)
//                } else {
//                    cell.imgViewUserImage.image = UIImage(named: "UserPlaceHolderImageForCell")
//                }
//            }

//                if let profileImageURL = URL(string: modifiedURLString) {
//                    KF.url(profileImageURL)
//                    //  .downsampling(size: CGSize(width: 200, height: 200))
//                        .cacheOriginalImage()
//                        .onSuccess { result in
//                            DispatchQueue.main.async {
//                                cell.imgView.image = result.image
//                            }
//                        }
//                        .onFailure { error in
//                            print("Image loading failed with error: \(error)")
//                            cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
//                        }
//                        .set(to: cell.imgView)
//                } else {
//                    cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
//                }

//            if let profileImageURL = usersList.data?[currentIndex].profileImage,
//               let profileImage = URL(string: profileImageURL) {
//
//                if let profileImageURL = URL(string: profileImageURL) {
//                    KF.url(profileImageURL)
//                    //  .downsampling(size: CGSize(width: 200, height: 200))
//                        .cacheOriginalImage()
//                        .onSuccess { result in
//                            DispatchQueue.main.async {
//                                cell.imgViewUserProfilePhoto.image = result.image
//                            }
//                        }
//                        .onFailure { error in
//                            print("Image loading failed with error: \(error)")
//                            cell.imgViewUserProfilePhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//                        }
//                        .set(to: cell.imgViewUserProfilePhoto)
//                } else {
//                    cell.imgViewUserProfilePhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//                }
//            }

//             if let imageURL = URL(string: gift.image ?? "") {
//                 KF.url(imageURL)
//                 //  .downsampling(size: CGSize(width: 200, height: 200))
//                     .cacheOriginalImage()
//                     .onSuccess { result in
//                         DispatchQueue.main.async {
//                             cell.imgViewGift.image = result.image
//                         }
//                     }
//                     .onFailure { error in
//                         print("Image loading failed with error: \(error)")
//                         cell.imgViewGift.image = UIImage(named: "UserPlaceHolderImageForCell")
//                     }
//                     .set(to: cell.imgViewGift)
//             } else {
//                 cell.imgViewGift.image = UIImage(named: "UserPlaceHolderImageForCell")
//             }

//            if let profileImageURL = URL(string: UserDefaults.standard.string(forKey: "profilePicture") ?? "") {
//                KF.url(profileImageURL)
//                //  .downsampling(size: CGSize(width: 200, height: 200))
//                    .cacheOriginalImage()
//                    .onSuccess { result in
//                        DispatchQueue.main.async {
//                            cell.imgViewUser.image = result.image
//                        }
//                    }
//                    .onFailure { error in
//                        print("Image loading failed with error: \(error)")
//                        cell.imgViewUser.image = UIImage(named: "UserPlaceHolderImageForCell")
//                    }
//                    .set(to: cell.imgViewUser)
//            } else {
//                cell.imgViewUser.image = UIImage(named: "UserPlaceHolderImageForCell")
//            }

//                if let profileImageURL = usersList.data?[currentIndex].profileImage,
//                   let profileImage = URL(string: profileImageURL) {
//
//                    if let profileImageURL = URL(string: profileImageURL) {
//                        KF.url(profileImageURL)
//                            .cacheOriginalImage()
//                            .onSuccess { result in
//                                DispatchQueue.main.async {
//                                    cell.imgViewUserProfilePhoto.image = result.image
//                                }
//                            }
//                            .onFailure { error in
//                                print("Image loading failed with error: \(error)")
//                                cell.imgViewEndUserDetail.image = UIImage(named: "UserPlaceHolderImageForCell")
//                            }
//                            .set(to: cell.imgViewEndUserDetail)
//                    } else {
//                        cell.imgViewEndUserDetail.image = UIImage(named: "UserPlaceHolderImageForCell")
//                    }
//                }

//    func onRoomExtraInfoUpdate(_ roomExtraInfoList: [ZegoRoomExtraInfo], roomID: String) {
//        print("The extra info we are getting from the Zego is: \(roomExtraInfoList)")
//        print("The extra info room id is: \(roomID)")
//        print("The extra info room details count is: \(roomExtraInfoList.count)")
//
//        guard let firstInfo = roomExtraInfoList.first else {
//            print("Room extra info list is empty.")
//            return
//        }
//
//        // Extracting JSON data from the first room extra info
//        guard let jsonData = firstInfo.value.data(using: .utf8) else {
//            print("Failed to convert room extra info to data.")
//            return
//        }
//
//        // Parsing the JSON data
//        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
//            print("Failed to parse JSON data.")
//            return
//        }
//
//        // Handling JSON data
//        handleJSONData(jsonObject)
//    }
//
//    // Function to handle JSON data
//    func handleJSONData(_ jsonArray: [[String: Any]]) {
//        guard !jsonArray.isEmpty, let pkHost = jsonArray[0]["pkHost"] as? [String: Any] else {
//            print("JSON array is empty or 'pkHost' key is missing.")
//            return
//        }
//
//        // Accessing pkHost data
//        print("The pkHost is: \(pkHost)")
//
//        if let coHost123 = pkHost["coHost123"] as? [String: Any] {
//            // Handling coHost123 data
//            handleCoHost123Data(coHost123)
//        }
//    }
//
//    // Function to handle coHost123 data
//    func handleCoHost123Data(_ coHost123: [String: Any]) {
//        // Iterating over coHost123 data
//        for (_, coHostData) in coHost123 {
//            guard let coHostDataString = coHostData as? String,
//                  let coHostDataJSON = coHostDataString.data(using: .utf8),
//                  let coHostUserData = try? JSONSerialization.jsonObject(with: coHostDataJSON, options: []) as? [String: Any] else {
//                print("Failed to parse coHost data.")
//                return
//            }
//
//            // Accessing coHostUserData
//            handleCoHostUserData(coHostUserData)
//        }
//    }
//
//    // Function to handle coHostUserData
//    func handleCoHostUserData(_ coHostUserData: [String: Any]) {
//        // Accessing individual values from coHostUserData
//        for (key, value) in coHostUserData {
//               print("Key: \(key), Value: \(value)")
//           }
//
//        if let coHostAudioStatus = coHostUserData["coHostAudioStatus"] as? String {
//            print("Co-Host Audio Status: \(coHostAudioStatus)")
//        }
//        if let coHostID = coHostUserData["coHostID"] as? String {
//            print("Co-Host ID: \(coHostID)")
//        }
//        // Access other values as needed
//    }
// If value is of a known type, you can perform type casting and access its properties
//                                                if let valueDict = value as? [String: Any] {
//
//                                                    if let coHostAudioStatus = valueDict["coHostAudioStatus"] as? String {
//                                                        print("Co-Host Audio Status: \(coHostAudioStatus)")
//                                                    }
//                                                    if let coHostID = valueDict["coHostID"] as? String {
//                                                        print("Co-Host ID: \(coHostID)")
//                                                    }
//                                                    if let coHostLevel = valueDict["coHostLevel"] as? String {
//                                                        print("Co-Host Audio Status: \(coHostLevel)")
//                                                    }
//                                                    if let coHostImage = valueDict["coHostUserImage"] as? String {
//                                                        print("Co-Host ID: \(coHostImage)")
//                                                    }
//                                                    if let coHostUserName = valueDict["coHostUserName"] as? String {
//                                                        print("Co-Host ID: \(coHostUserName)")
//                                                    }
//                                                    if let coHostUserStatus = valueDict["coHostUserStatus"] as? String {
//                                                        print("Co-Host ID: \(coHostUserStatus)")
//                                                    }
//                                                }

//        let roomExtraInfoListType = type(of: roomExtraInfoList)
//           let roomIDType = type(of: roomID)
//
//           print("Data type of roomExtraInfoList: \(roomExtraInfoListType)")
//           print("Data type of roomID: \(roomIDType)")
        

//        let room = type(of: firstInfo)
//        print(room)
//
//        let roomType = type(of: firstInfo.value)
//        print(roomType)
//


//                            for (key, value) in coHost123 {
//                                 if let coHostData = value as? String {
//                                     // Assuming `coHostData` is a JSON string, you can parse it to get its values
//                                     if let data = coHostData.data(using: .utf8) {
//                                         do {
//                                             if let coHostUserData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                                                 // Now you have access to the values in coHostUserData for the current key
//                                                 if let coHostAudioStatus = coHostUserData["coHostAudioStatus"] as? String {
//                                                     print("Co-Host Audio Status for key \(key): \(coHostAudioStatus)")
//                                                 }
//                                                 if let coHostID = coHostUserData["coHostID"] as? String {
//                                                     print("Co-Host ID for key \(key): \(coHostID)")
//                                                 }
//                                                 // Access other values in a similar manner
//                                             }
//                                         } catch {
//                                             print("Error parsing JSON: \(error)")
//                                         }
//                                     }
//                                 }
//                             }

//                        if let coHost123 = pkHost["coHost123"] as? [String: Any] {
//                            // Now `coHost123` contains the data you want
//                            for (_, coHostData) in coHost123 {
//                                if let coHostData = coHostData as? [String: Any] {
//                                    let coHostID = coHostData["coHostID"] as? String ?? ""
//                                    let coHostAudioStatus = coHostData["coHostAudioStatus"] as? String ?? ""
//                                    let coHostLevel = coHostData["coHostLevel"] as? String ?? ""
//                                    let coHostUserImage = coHostData["coHostUserImage"] as? String ?? ""
//                                    let coHostUserName = coHostData["coHostUserName"] as? String ?? ""
//                                    let coHostUserStatus = coHostData["coHostUserStatus"] as? String ?? ""
//
//                                    // Now you have access to individual co-host data
//                                    print("Co-Host ID: \(coHostID)")
//                                    print("Co-Host Audio Status: \(coHostAudioStatus)")
//                                    print("Co-Host Level: \(coHostLevel)")
//                                    print("Co-Host User Image: \(coHostUserImage)")
//                                    print("Co-Host User Name: \(coHostUserName)")
//                                    print("Co-Host User Status: \(coHostUserStatus)")
//                                }
//                            }
//                        }


//                            for (_, coHostData) in coHost123 {
//                                if let coHostData = coHostData as? [String: Any] {
//                                    let coHostID = coHostData["coHostID"] as? String ?? ""
//                                    let coHostAudioStatus = coHostData["coHostAudioStatus"] as? String ?? ""
//                                    let coHostLevel = coHostData["coHostLevel"] as? String ?? ""
//                                    let coHostUserImage = coHostData["coHostUserImage"] as? String ?? ""
//                                    let coHostUserName = coHostData["coHostUserName"] as? String ?? ""
//                                    let coHostUserStatus = coHostData["coHostUserStatus"] as? String ?? ""
//
//                                    // Now you have access to individual co-host data
//                                    print("Co-Host ID: \(coHostID)")
//                                    print("Co-Host Audio Status: \(coHostAudioStatus)")
//                                    print("Co-Host Level: \(coHostLevel)")
//                                    print("Co-Host User Image: \(coHostUserImage)")
//                                    print("Co-Host User Name: \(coHostUserName)")
//                                    print("Co-Host User Status: \(coHostUserStatus)")
//                                }
//                            }


//                            let t = type(of: coHost123)
//                            print(t)
//
//                            print(coHost123.keys)
//                            print(coHost123.values)
//
//                            let tk = type(of: coHost123.values)
//                            print(tk)
//


//        print(firstInfo.key)
//        print(firstInfo.value)
//        print(firstInfo.updateUser)
//        print(firstInfo.description)
//        print(firstInfo)
//        let a = firstInfo.value as? [String: Any]
//        print(a)
//
//        // Assuming `jsonString` is your JSON string
//        if let data = firstInfo.value.data(using: .utf8) {
//            do {
//                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
//                    if jsonArray.isEmpty {
//                        print("JSON array is empty.")
//                    } else {
//                        print("The json printing is: \(jsonArray)")
//
//                        guard let pkHost = jsonArray[0]["pkHost"] as? [String: Any] else {
//                            print("pkHost key is missing or invalid.")
//                            return
//                        }
//
//                        print("The pkHost is: \(pkHost)")
//                    }
//                } else {
//                    print("Failed to parse JSON array.")
//                }
//            } catch {
//                print("Error parsing JSON: \(error)")
//            }
//        }

//                        if let coHost123 = pkHostJson["coHost123"] as? [String: Any] {
//                            // Now `coHost123` contains the data you want
//
//                            for (_, value) in coHost123 {
//                                  if let coHostData = value as? String {
//                                      // Assuming `coHostData` is a JSON string, you can parse it to get its values
//                                      if let data = coHostData.data(using: .utf8) {
//                                          do {
//                                              if let coHostUserData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                                                  // Now you have access to the values in coHostUserData
//                                                  for (key, value) in coHostUserData {
//                                                      // Print or use the values as needed
//                                                      print("Key: \(key), Value: \(value)")
//
//                                                  }
//                                              }
//                                          } catch {
//                                              print("Error parsing JSON: \(error)")
//                                          }
//                                      }
//                                  }
//                              }
//                        }

//    func onRoomExtraInfoUpdate(_ roomExtraInfoList: [ZegoRoomExtraInfo], roomID: String) {
//
//        print("The extra info we are getting from Zego is: \(roomExtraInfoList)")
//        print("The extra info room ID is: \(roomID)")
//        print("The extra info room details count is: \(roomExtraInfoList.count)")
//        print("The data is: \(roomExtraInfoList.first?.value)")
//
//        if let jsonString = roomExtraInfoList.first?.value, // Assuming there's at least one item in the list
//            let jsonData = jsonString.data(using: .utf8) {
//
//            do {
//                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
//
//                    // Accessing pkHost
//                    if let pkHostString = jsonObject["pkHost"] as? String,
//                       let pkHostData = pkHostString.data(using: .utf8),
//                       let pkHostDict = try JSONSerialization.jsonObject(with: pkHostData, options: []) as? [String: Any],
//                       let coHostDict = pkHostDict["coHost123"] as? [String: Any] {
//
//                        print("The cohostdict data is: \(coHostDict)")
//
//                        for (coHostID, coHostDetails) in coHostDict {
//                            if let coHostDetailsDict = coHostDetails as? [String: Any],
//                               let coHostLevel = coHostDetailsDict["coHostLevel"] as? String,
//                               let coHostUserImage = coHostDetailsDict["coHostUserImage"] as? String,
//                               let coHostUserName = coHostDetailsDict["coHostUserName"] as? String,
//                               let coHostUserStatus = coHostDetailsDict["coHostUserStatus"] as? String {
//
//                                print("coHostID: \(coHostID)")
//                                print("coHostLevel: \(coHostLevel)")
//                                print("coHostUserImage: \(coHostUserImage)")
//                                print("coHostUserName: \(coHostUserName)")
//                                print("coHostUserStatus: \(coHostUserStatus)")
//                            }
//                        }
//                    }
//                }
//            } catch {
//                print("Error parsing JSON: \(error.localizedDescription)")
//            }
//        } else {
//            print("No JSON data found or unable to parse.")
//        }
//    }

//    func extractTimeComponents(from timestamp: TimeInterval) -> (hour: Int, minute: Int, second: Int)? {
//        // Create a Date object from the timestamp
//        let date = Date(timeIntervalSince1970: timestamp)
//
//        // Create a calendar instance
//        let calendar = Calendar.current
//
//        // Extract hour, minute, and second components from the date
//        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
//
//        // Access the hour, minute, and second values
//        if let hour = components.hour,
//           let minute = components.minute,
//           let second = components.second {
//            return (hour, minute, second)
//        } else {
//            print("Failed to extract hour, minute, and second components from the date.")
//            return nil
//        }
//    }

//    func joinLiveAsCoHost() {
//
//        var infoObj = [String: Any]()
//
//              infoObj["coHostID"] = UserDefaults.standard.string(forKey: "UserProfileId")
//              infoObj["coHostUserName"] = UserDefaults.standard.string(forKey: "UserName")
//              infoObj["coHostUserImage"] = UserDefaults.standard.string(forKey: "profilePicture")
//              infoObj["coHostUserStatus"] = "add"
//              infoObj["coHostLevel"] = UserDefaults.standard.string(forKey: "level")
//
//        var infoStr1 = ""
//          var type = ""
//        type = "CO_HOST"
//        infoStr1 = JSON(infoObj).rawString()!
//
//        var map = [String: String]()
//            map[type] = infoStr1
//        print("The map in here is: \(map)")
//            let infoStr2 = JSON(map).rawString()!
//
//        print("The user type is: \(type)")
//        print("The user infoStr1 is: \(infoStr1)")
//        print("The user infoStr2 is: \(infoStr2)")
//
//        print("The room id is: \(room)")
//        ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: room, callback: { errorCode in
//
//            print(errorCode)
//            print(errorCode.description)
//            if (errorCode == 0) {
//                self.startPublishCoHostStream()
//            } else {
//                print("Message abhi group mai shi se nahi gya hai room extra info wala.")
//            }
//        })
//    }
    
//    func joinLiveAsCoHost() {
//        var infoObj = [String: Any]()
//
//        infoObj["coHostID"] = UserDefaults.standard.string(forKey: "UserProfileId")
//        infoObj["coHostUserName"] = UserDefaults.standard.string(forKey: "UserName")
//        infoObj["coHostUserImage"] = UserDefaults.standard.string(forKey: "profilePicture")
//        infoObj["coHostUserStatus"] = "add"
//        infoObj["coHostLevel"] = UserDefaults.standard.string(forKey: "level")
//
//        var infoStr1 = ""
//        var type = ""
//        type = "coHost123"
//        infoStr1 = JSON(infoObj).rawString()!
//
//        var map = [String: String]()
//        map[type] = infoStr1
//        print("The map in here is: \(map)")
//
//         let infoStr2 = JSON(map).rawString()!
//            print("The user type is: \(type)")
//            print("The user infoStr1 is: \(infoStr1)")
//            print("The user infoStr2 is: \(infoStr2)")
//
//            print("The room id is: \(room)")
//        ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: room, callback: { errorCode in
//
//                print(errorCode)
//                print(errorCode.description)
//                if errorCode == 0 {
//                    self.startPublishCoHostStream()
//                } else {
//                    print("Message abhi group mai shi se nahi gya hai room extra info wala.")
//                }
//            })
//
//    }

//    func joinLiveAsCoHost() {
//
//        let coHostID = "885603440"
//        let coHostLevel = "6"
//        let coHostUserImage = "https://imgzeeplive.oss-ap-south-1.aliyuncs.com/zeepliveProfileImages/2023/09/24/1695500223.jpg"
//        let coHostData: [String: Any] = [
//            "coHostID": coHostID,
//            "coHostLevel": coHostLevel,
//            "coHostUserImage": coHostUserImage
//        ]
//
//        let coHost123: [String: Any] = [
//            coHostID: coHostData
//        ]
//
//        let valueDictionary: [String: Any] = [
//            "coHost123": coHost123
//        ]
//
//        // Convert the dictionary to JSON data
//        if let jsonData = try? JSONSerialization.data(withJSONObject: valueDictionary, options: []) {
//            // Convert the JSON data to a string
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print("JSON String:")
//                print(jsonString)
//
//                ZegoExpressEngine.shared().setRoomExtraInfo(jsonString, forKey: "SYC_USER_INFO", roomID: room, callback: { errorCode in
//
//                        print(errorCode)
//                        print(errorCode.description)
//                        if errorCode == 0 {
//                            self.startPublishCoHostStream()
//                        } else {
//                            print("Message abhi group mai shi se nahi gya hai room extra info wala.")
//                        }
//                    })
//
//                // Now you can send this JSON string wherever you need it
//            } else {
//                print("Error converting JSON data to string")
//            }
//        } else {
//            print("Error creating JSON data")
//        }
//
////        var infoObj = [String: Any]()
////
////           infoObj["coHostID"] = "885603440" // Replace with actual coHostID
////           infoObj["coHostUserName"] = "🍥🦊Naruto🥷🏻"
////           infoObj["coHostUserImage"] = "https://imgzeeplive.oss-ap-south-1.aliyuncs.com/zeepliveProfileImages/2023/09/24/1695500223.jpg"
////           infoObj["coHostUserStatus"] = "add"
////           infoObj["coHostLevel"] = "15" // Replace with actual coHostLevel
////
////           // Create the desired JSON structure
////           let outerObj: [String: Any] = [
////               "coHost123": [
////                   "885603440": infoObj  // Use the desired key "885603440"
////               ]
////           ]
////           let infoStr2 = JSON(outerObj).rawString()!
//
////                ZegoExpressEngine.shared().setRoomExtraInfo(infoStr2, forKey: "SYC_USER_INFO", roomID: room, callback: { errorCode in
////
////                        print(errorCode)
////                        print(errorCode.description)
////                        if errorCode == 0 {
////                            self.startPublishCoHostStream()
////                        } else {
////                            print("Message abhi group mai shi se nahi gya hai room extra info wala.")
////                        }
////                    })
//
//        // Rest of your code for setting room extra info and starting publish co-host stream
//    }

//  ZegoExpressEngine.shared().loginRoom(room1, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
//  ZegoExpressEngine.shared().startPlayingStream(room1, canvas: zegocanvas2,config: config1)
//  ZegoExpressEngine.shared().startPlayingStream(self.room, canvas: zegocanvas, config: config)
  
// }

//                                ZegoExpressEngine.shared().loginRoom(room, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
//                                ZegoExpressEngine.shared().startPlayingStream(room, canvas: zegocanvas2,config: config1)

// ZegoExpressEngine.shared().setEventHandler(self)

//                                ZegoExpressEngine.shared().setRoomExtraInfo("SYC_USER_INFO", forKey: "hi", roomID: room)  this is the function

//                                let extraInfo = "SYC_USER_INFO" //Additional information about the stream"
//                                ZegoExpressEngine.shared().setStreamExtraInfo(extraInfo) { errorCode in
//                                    if errorCode == 0 {
//                                        print("Stream extra info set successfully")
//                                    } else {
//                                        print("Failed to set stream extra info. Error code: \(errorCode)")
//                                    }
//                                }

//            if let receiverChannelName = OneToOneCallData.data?.receiverChannelName?.channelName {
//                print("Receiver Channel Name: \(receiverChannelName)")
//            } else {
//                print("Receiver Channel Name not found")
//            }
//
//            if let senderChannelName = OneToOneCallData.data?.senderChannelName?.channelName {
//                print("Sender Channel Name: \(senderChannelName)")
//            } else {
//                print("Sender Channel Name not found")
//            }

// Access the mic user details at the specified index
//            var user = joinedGroupUserProfile()
//            user.userID = zegoMicUsersList[index].coHostID
//            user.nickName = zegoMicUsersList[index].coHostUserName
//            user.faceURL = zegoMicUsersList[index].coHostUserImage
//            user.richLevel = zegoMicUsersList[index].coHostLevel
//
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
//            nextViewController.messageDetails = user
//            nextViewController.delegate = self
//            nextViewController.viewFrom = "message"
//            nextViewController.hostFollowed = hostFollowed
//            nextViewController.modalPresentationStyle = .overCurrentContext
//
//            present(nextViewController, animated: true, completion: nil)


// Check if the index is within the bounds of the zegoMicUsersList array
//        if zegoMicUsersList.indices.contains(index) {
//            // Access the mic user details at the specified index
//            var user = joinedGroupUserProfile()
//            user.userID = zegoMicUsersList[index].coHostID
//            user.nickName = zegoMicUsersList[index].coHostUserName
//            user.faceURL = zegoMicUsersList[index].coHostUserImage
//            user.richLevel = zegoMicUsersList[index].coHostLevel
//
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "JoinedAudienceDetailsViewController") as! JoinedAudienceDetailsViewController
//            nextViewController.messageDetails = user
//            nextViewController.delegate = self
//            nextViewController.viewFrom = "message"
//            nextViewController.hostFollowed = hostFollowed
//            nextViewController.modalPresentationStyle = .overCurrentContext
//
//            present(nextViewController, animated: true, completion: nil)
//        } else {
//            // Handle the case where the index is out of bounds
//            print("Index out of bounds")
//        }
