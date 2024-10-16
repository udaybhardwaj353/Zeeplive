//
//  OneToOneCallViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/03/24.
//

import UIKit
import Lottie
import ZegoExpressEngine
import ToastViewSwift
import FittedSheets

class OneToOneCallViewController: UIViewController, ZegoEventHandler {
    
    @IBOutlet weak var viewUserDetailOutlet: UIButton!
    @IBOutlet weak var imgViewHostProfileImage: UIImageView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblCallTime: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnOpenMessageOutlet: UIButton!
    @IBOutlet weak var btnCloseCallOutlet: UIButton!
    @IBOutlet weak var viewVideoOnOff: UIView!
    @IBOutlet weak var btnVideoOnOffOutlet: UIButton!
    @IBOutlet weak var viewGift: UIView!
    @IBOutlet weak var btnGiftOutlet: UIButton!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnSendMessageOutlet: UIButton!
    @IBOutlet weak var viewMessageTextField: UIView!
    @IBOutlet weak var txtFldMessage: UITextField!
    @IBOutlet weak var viewPlayStreamOutlet: UIButton!
    @IBOutlet weak var imgViewPlayStream: UIImageView!
    @IBOutlet weak var viewLuckyGift: UIView!
    @IBOutlet weak var lblNoOfGift: UILabel!
    @IBOutlet weak var viewLuckyGiftDetails: UIView!
    @IBOutlet weak var viewUserImage: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var viewGiftImage: UIView!
    @IBOutlet weak var imgViewGift: UIImageView!
    @IBOutlet weak var lblSendGiftToHostName: UILabel!
    @IBOutlet weak var viewMessageBottomConstraints: NSLayoutConstraint!
    lazy var lottieAnimationViews: [LottieAnimationView] = []
    @IBOutlet weak var btnFollowHostOutlet: UIButton!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var btnFollowWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewLiveMessages: UIView!
    @IBOutlet weak var tblViewLiveMessages: UITableView!
    @IBOutlet weak var lblSendTo: UILabel!
    @IBOutlet weak var btnShowOptionsOutlet: UIButton!
    @IBOutlet weak var btnSpeakerOutlet: UIButton!
    @IBOutlet weak var viewLiveAnimation: UIView!
    
    lazy var cameFrom: String = ""
    lazy var channelName: String = ""
    lazy var userChannelName: String = ""
    lazy var hostChannelName: String = ""
    lazy var userStreamID: String = ""
    lazy var hostStreamID: String = ""
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
     lazy var hostID: String = ""
     lazy var hostName: String = ""
     lazy var hostImage: String = ""
     lazy var userID: String = ""
     lazy var userName: String = ""
     lazy var userImage: String = ""
     lazy var isMuteMicButtonPressed = false
     lazy var liveMessages: [liveMessageModel] = []
     lazy var liveMessage = liveMessageModel()
     weak var sheetController:SheetViewController!
     lazy var idHost: String = ""
     lazy var hostCallRate: String = ""
   lazy var countdownTimer = Timer()
    lazy var totalTime: Int = 0
    lazy var currentTime = 0
   lazy var countdownTimerForHost = Timer()
    lazy var callStartTimestamp: Int = 0
    lazy var callEndTimestamp: Int = 0
    lazy var uniqueID: String = ""
    lazy var isBroadStarted: Bool = false
    var leftSwipeGesture: UISwipeGestureRecognizer!
    var rightSwipeGesture: UISwipeGestureRecognizer!
    var openedVC = UIViewController()
    lazy var isMuteSpeakerButtonPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationForCallCut(_:)), name: Notification.Name("callcut"), object: nil)
        
        print("Yhn pr idhost jo li hai woh follow mai pass krne ke liye host ki id li hai. \(idHost)")
        
        ZegoExpressEngine.destroy(nil)
        let currentTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        print(currentTimestampInMilliseconds)
        callStartTimestamp = currentTimestampInMilliseconds
        print("The current timestamp is: \(callStartTimestamp)")
        
        addSwipeGestures()
       // startCall()
        createEngine()
        setData()
        configureUI()
        notificationWork()
//        addLottieAnimation()
        tableViewWork()
        
        if (cameFrom == "user") {
          
            calculateTimeToPlayBroad()
            startCall()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallConnectingViewController") as! CallConnectingViewController
            nextViewController.hostImage = hostImage
            nextViewController.hostName = hostName
            nextViewController.channelName = hostChannelName
            self.navigationController?.pushViewController(nextViewController, animated: false)
            
        } else {
            
            print(" host wale ke liye timer chalega.")
            startTimerForHost()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallConnectingViewController") as! CallConnectingViewController
            nextViewController.hostImage = userImage
            nextViewController.hostName = userName
            nextViewController.channelName = userChannelName
            self.navigationController?.pushViewController(nextViewController, animated: false)
            
        }
        
        
//        startCall()
//        calculateTimeToPlayBroad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleNotificationForCallCut(_ notification: Notification) {
        // Handle the notification here
        print("The notification is printed here in one to one call view controller.")
        navigationController?.popViewController(animated: false)
        navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func viewUserDetailPressed(_ sender: Any) {
        
        print("View User Details Pressed")
        
    }
    
    @IBAction func btnOpenMessagePressed(_ sender: Any) {
        
        print("Button Open Message Pressed")
        txtFldMessage.becomeFirstResponder()
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    @IBAction func btnCloseCallPressed(_ sender: Any) {
        
        print("Button Close One To One Call Pressed.")
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
        nextViewController.delegate = self
        nextViewController.headingText = "Are you sure you want to close call?"
        nextViewController.buttonName = "Yes"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
//        let currentTimestampInMillisecondsForEndCall = Int(Date().timeIntervalSince1970 * 1000)
//        print(currentTimestampInMillisecondsForEndCall)
//        
//        callEndTimestamp = currentTimestampInMillisecondsForEndCall
//        print("The call end time stamp is: \(callEndTimestamp)")
//        
//        endCall()
        
//        sendMessageToExit()
      //  startCloseWork()
      
        
    }
    
    @IBAction func btnVideoOnOffPressed(_ sender: Any) {
        
        print("Button Video On Or Off Pressed.")
        
    }
    
    @IBAction func btnGiftPressed(_ sender: Any) {
        
        print("Button Open Gifts Pressed.")
        
        calculateLeftCoins()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowGiftViewController") as! ShowGiftViewController
        vc.delegate = self
        vc.cameFrom = "onetoone"
        
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
    
    @IBAction func btnSendMessagePressed(_ sender: Any) {
        
        print("Button Send Message Pressed.")
        if (txtFldMessage.text == "") || (txtFldMessage.text == nil) {
            
            print("Message nahi bhejenge text field khali hai.")
            let config = ToastConfiguration(
                direction: .bottom
            )
            
            let toast = Toast.text("Please enter your message!",config: config)
            toast.show()
            
        } else {
            let replacedString = replaceNumbersWithAsterisks(txtFldMessage.text ?? "")
            print(replacedString)
            sendMessage(message: replacedString ?? "N/A")
            txtFldMessage.resignFirstResponder()
        }
    }
    
    @IBAction func viewPlayStreamPressed(_ sender: Any) {
        
        print("View Play Stream Video Pressed.")
        
    }
    
    @IBAction func btnFollowHostPressed(_ sender: Any) {
        
        print("Button Follow Host Pressed")
        
    }
    
    @IBAction func btnMicPressed(_ sender: Any) {
        
        print("Button Mic Pressed For mute/ unmute our voice.")
        
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
    
    @IBAction func btnShowOptionsPressed(_ sender: Any) {
        
        print("Button Show Options Pressed. Open Options View Controller.")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneOptionsViewController") as! OneToOneOptionsViewController
      
       // nextViewController.delegate = self
        nextViewController.modalPresentationStyle = .overCurrentContext
        nextViewController.cameFrom = "onetoone"
        present(nextViewController, animated: true, completion: nil)
        
        openedVC = nextViewController
        
    }
    
    @IBAction func btnSpeakerPressed(_ sender: Any) {
        
        print("Button Mute/UnMute Speaker Pressed.")
        
        if isMuteSpeakerButtonPressed
        
        {

            ZegoExpressEngine.shared().muteSpeaker(false)
            isMuteSpeakerButtonPressed = false
          btnSpeakerOutlet.setImage(UIImage(named:"speakeron"), for: .normal)
            
        }
        
        else{
            
            ZegoExpressEngine.shared().muteSpeaker(true)
            isMuteSpeakerButtonPressed = true
          btnSpeakerOutlet.setImage(UIImage(named:"speakeroff"), for: .normal)
            
        }
        
    }
    
    deinit {
        
        print("One to one call view controller main deinit call hua hai.")
        view.subviews.forEach { $0.removeFromSuperview() }
        NotificationCenter.default.removeObserver(self)
        
    }
}

// MARK: - EXTENSION FOR USING DELEGATE FUNCTIONS OF ONE TO ONE OPTIONS VIEW CONTROLLER

extension OneToOneCallViewController: delegateOneToOneOptionsViewController {
    
    func cameraOnOffPressed(isPressed: Bool) {
        
        print("Camera On Off function is being called in publish stream view controller.")
        
    }
    
    func cameraFlipPressed(isPressed: Bool) {
        
        print("Flip Camera function is being called in publish stream view controller.")
        
    }
    
    func openBeautyPressed(isPressed: Bool) {
        
        print("Open Face Unity Options is being called in publish stream view controller.")
      
        dismiss(animated: true, completion: nil)
        
      //  FUDemoManager.shared().removeDemoView()
      //  FUDemoManager.shared().addDemoView(to: self.view, originY: UIScreen.main.bounds.height - FUBottomBarHeight - FUSafaAreaBottomInsets())
        
        if (isPressed == false) {
        
            print("Face Unity Options ko hide krna hai aur nahi dikhana hai.")
            
            FUDemoManager.shared().hideBottomBar()
            
        } else {
            
            print("Face Unity Options ko show karna hai aur dikhana hai.")
            
            FUDemoManager.shared().showBottomBar()
            
        }
        
    }
    
}

extension OneToOneCallViewController {
    
    func addSwipeGestures() {
    
        leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
       leftSwipeGesture.cancelsTouchesInView = false
          leftSwipeGesture.direction = .left
        self.view.addGestureRecognizer(leftSwipeGesture)

           rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
       rightSwipeGesture.cancelsTouchesInView = false
          rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
        
    }
    
    func removeSwipeGestures() {
        if let leftSwipeGesture = leftSwipeGesture, let rightSwipeGesture = rightSwipeGesture,
           leftSwipeGesture is UISwipeGestureRecognizer, rightSwipeGesture is UISwipeGestureRecognizer {
            // Remove the gesture recognizers
            DispatchQueue.main.async {
                self.view.removeGestureRecognizer(leftSwipeGesture)
                self.view.removeGestureRecognizer(rightSwipeGesture)
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
          
              unHideViews()
          //  ZegoExpressEngine.shared().useFrontCamera(true)
        } else if gesture.direction == .right {
            // Handle right swipe
            print("Right swipe detected")
            // ZegoExpressEngine.shared().useFrontCamera(false)
              hideViews()
            
        }
    }
    
    func hideViews() {
    
        viewLiveMessages.isHidden = true
        viewUserDetailOutlet.isHidden = true
        viewPlayStreamOutlet.isHidden = true
        viewVideoOnOff.isHidden = true
        viewGift.isHidden = false
        btnMicOutlet.isHidden = true
        btnOpenMessageOutlet.isHidden = true
        btnSpeakerOutlet.isHidden = true
        btnShowOptionsOutlet.isHidden = true
        
    }
    
    func unHideViews() {
        
        viewLiveMessages.isHidden = false
        viewUserDetailOutlet.isHidden = false
        viewPlayStreamOutlet.isHidden = false
        viewVideoOnOff.isHidden = false
        viewGift.isHidden = false
        btnMicOutlet.isHidden = false
        btnOpenMessageOutlet.isHidden = false
        btnSpeakerOutlet.isHidden = false
        btnShowOptionsOutlet.isHidden = false
        
    }
    
}
// MARK: - EXTENSION FOR DOING THE CALCULATION TO KNOW WHEN TO CLOSE THE BROAD IN ONE TO ONE CALL VIEW CONTROLLER

extension OneToOneCallViewController {

    func calculateTimeToPlayBroad() {
        // Retrieve user coins from UserDefaults and convert to Double
        let userCoinsString = UserDefaults.standard.string(forKey: "coins") ?? "0"
        
        guard let userCoins = Float(userCoinsString) else {
            print("Invalid userCoins value")
            return
        }
        
        // Convert hostCallRate to Double
        guard let hostCallRateValue = Float(hostCallRate), hostCallRateValue != 0 else {
            print("Invalid or zero hostCallRate")
            return
        }
        // Calculate timeCall
        let timeCall = userCoins / hostCallRateValue
        
        // Use the calculated timeCall as needed
        print("Time to play broadcast: \(timeCall)")
        
        let timeinMinSec = (timeFormatted(Int(timeCall)))
        print("The time in minute and second format is: \(timeinMinSec)")
        
        totalTime = Int(timeCall)
        
        let totalCoinOnUser = timeCall * hostCallRateValue
        
        print("The total coin on user is: \(totalCoinOnUser)")
        
        if (cameFrom == "user") {
          
            startTimer()
            
        } else {
            
            print(" host wale ke liye timer chalega.")
            startTimerForHost()
            
        }
        
    }
    
    func startTimer() {
           currentTime = 0 // Start from 0
        countdownTimer.invalidate() // Invalidate any existing timer
           countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
       }

       @objc func updateTime() {
         //  print("The total time user has for call is: \(totalTime)")
           lblCallTime.text = timeFormatted(currentTime)
           
           if currentTime < totalTime {
               currentTime += 1
           } else {
               endTimer()
           }
       }

       func endTimer() {
           
           print("User ki trf se end timer wala kaam chal rha hai.")
           let currentTimestampInMillisecondsForEndCall = Int(Date().timeIntervalSince1970 * 1000)
           print(currentTimestampInMillisecondsForEndCall)
           
           callEndTimestamp = currentTimestampInMillisecondsForEndCall
           print("The call end time stamp is: \(callEndTimestamp)")
           endCall()
          // sendMessageToExit()
           countdownTimer.invalidate()
          // countdownTimer = nil
           
       }
        
    func calculateLeftCoins() {
    
        let a = totalTime - currentTime
        
        print("The time remaining is: \(a)")
        print("The host call rate is: \(hostCallRate)")
        print("The host call rate in integer is: \(Int(hostCallRate))")
        
//        let c: String = hostCallRate
//        var d : Int = Int(c) ?? 0
        
//        let callRateInt = Int(hostCallRate) ?? 0
//        print("The call rate integer is: \(callRateInt)")
        
        let cleanedHostCallRate = hostCallRate.trimmingCharacters(in: .whitespacesAndNewlines)
           print("The host call rate is: \(cleanedHostCallRate)")
        
        let callRateInt = Int(cleanedHostCallRate) ?? 0
        print("The call rate integer is: \(callRateInt)")
        
        guard let hostCallRateValue = Float(hostCallRate), hostCallRateValue != 0 else {
            print("Invalid or zero hostCallRate")
            return
        }
        
        let coinleft = Float(a) * hostCallRateValue//(Int(hostCallRate) ?? 0)
        print("The coin left is: \(coinleft)")
        
        UserDefaults.standard.set(coinleft , forKey: "coins")
        print("The coins left of user stored is: \(UserDefaults.standard.string(forKey: "coins"))")
        
    }
    
    func calculateCoins(amount: Int = 0, count:Int = 1) {
    
        let userCoinsString = UserDefaults.standard.string(forKey: "coins") ?? "0"
        
        guard var userCoins = Float(userCoinsString) else {
            print("Invalid userCoins value")
            return
        }
        
        let giftamount = amount * count
        print("The gift amount is: \(giftamount)")
        
        let remainingAmount = Int(userCoins) - giftamount
       print("The remaining amount is: \(remainingAmount)")
        
        userCoins = Float(remainingAmount)
        
        UserDefaults.standard.set(remainingAmount , forKey: "coins")
        print("The coins left of user stored is: \(UserDefaults.standard.string(forKey: "coins"))")
        
        // Convert hostCallRate to Double
        guard let hostCallRateValue = Float(hostCallRate), hostCallRateValue != 0 else {
            print("Invalid or zero hostCallRate")
            return
        }
        // Calculate timeCall
        let timeCall = userCoins / hostCallRateValue
        
        // Use the calculated timeCall as needed
        print("Time to play broadcast: \(timeCall)")
        
        let timeinMinSec = (timeFormatted(Int(timeCall)))
        print("The time in minute and second format is: \(timeinMinSec)")
        
        totalTime = Int(timeCall)
        print("After sending gifts the remaining total time is: \(totalTime)")
        
    }
    
    func startTimerForHost() {
        
        currentTime = 0 // Start from 0
        countdownTimerForHost.invalidate() // Invalidate any existing timer
        countdownTimerForHost = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeForHost), userInfo: nil, repeats: true)
      
    }

        @objc func updateTimeForHost() {
            totalTime = 7200
            if currentTime < 7200 { // Check if current time is less than 2 hours (2 hours * 60 minutes * 60 seconds)
                currentTime += 1
             //   print("Current Time: \(currentTime) seconds")
                lblCallTime.text = timeFormatted(currentTime)
                // Update your UI or perform any other actions here
            } else {
                countdownTimerForHost.invalidate() // Stop the timer after reaching 2 hours
                print("Timer stopped after reaching 2 hours")
            }
        }
    
    func endTimerForHost() {
        countdownTimerForHost.invalidate()
       
    }
    
}


// MARK: - EXTENSION FOR USING DELEGATES METHODS TO KNOW FOR THE GIFT SELECTED AND IT'S DETAILS

extension OneToOneCallViewController: delegateShowGiftViewController, delegateCommonPopUpViewController {
    
    func deleteButtonPressed(isPressed: Bool) {
        
        print("Delete OR Close One To One Call Button Is Pressed")
        let currentTimestampInMillisecondsForEndCall = Int(Date().timeIntervalSince1970 * 1000)
        print(currentTimestampInMillisecondsForEndCall)
        
        callEndTimestamp = currentTimestampInMillisecondsForEndCall
        print("The call end time stamp is: \(callEndTimestamp)")
        
       // sendMessageToExit()
        endCall()
        removeSwipeGestures()
        
    }
    
    func isBalanceLow(isLow: Bool) {
        
        print("To know balance low in one to one.")
        
    }
    
    func giftSelected(gift: Gift, sendgiftTimes: Int) {
        
        print("This is the main delegate function. we will need this detail to send in gift in custom message.")
        print("The gift selected is: \(gift)")
        print("The gift selected time is: \(sendgiftTimes)")
        
        sendGift(catID: (gift.giftCategoryID ?? 0), giftID: (gift.id ?? 0), giftPrice: (gift.amount ?? 0), recieverID: Int(hostID) ?? 0, gift: gift, count: sendgiftTimes)
       
        // sendGiftToHost(gift: gift, giftCount: sendgiftTimes)
        
    }
    
    func showLuckyGift(giftName: String, amount: Int) {
        
        print("Here we need to show the lucky gift when the user will get it in return.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LuckyGiftCashbackViewController") as! LuckyGiftCashbackViewController
        nextViewController.giftName = giftName
        nextViewController.giftAmount = amount
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func openLowBalanceView(isclicked: Bool) {
        
        print("Code to open low balance view in one to one view controller.")
        
    }
    
    func pkGiftSent(giftAmount: Int, userName: String, userImage: String, userID: String, from: String) {
        
        print("Here we will know if the gift is sent in pk.")
        
    }
    
    func giftSentSuccessfully(gift: Gift, sendgiftTimes: Int) {
        
        print("Here we will know when the gift has been successfully sent.")
        
    }
    
    func playGiftAnimation(gift:Gift,count:Int) {
    
        print("Gift play krne wale function pr kaam krne wale hai one to one view controller mai.")
       
        var sendGiftModel = Gift()
       
        sendGiftModel.id = gift.id
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
            
            viewLuckyGift.isHidden = false
            shakeAnimation(for: viewGiftImage)
            hideViewAfterDelay(viewToHide: viewLuckyGift, duration: 0.80) {
                // This block will be executed when the animation is finished
                print("Animation finished!")
                self.viewLuckyGift.isHidden = true
                
            }
            
            lblNoOfGift.text =  "X" + " " + String(count ?? 1)
            lblSendGiftToHostName.text = hostName//liveMessage.sendGiftTo ?? ""
            
            loadImage(from: gift.image ?? "", into: imgViewGift)
            loadImage(from: ((UserDefaults.standard.string(forKey: "profilePicture") ?? "")), into: imgViewUser)
            
        } else {
            print("Animation play krana hai")
            ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: self)
           
            viewLuckyGift.isHidden = false
            shakeAnimation(for: viewGiftImage)
            hideViewAfterDelay(viewToHide: viewLuckyGift, duration: 0.80) {
                // This block will be executed when the animation is finished
                print("Animation finished!")
                self.viewLuckyGift.isHidden = true
                
            }
            
            lblNoOfGift.text =  "X" + " " + String(count ?? 1)
            lblSendGiftToHostName.text = hostName//liveMessage.sendGiftTo ?? ""
            
            loadImage(from: gift.image ?? "", into: imgViewGift)
            loadImage(from: ((UserDefaults.standard.string(forKey: "profilePicture") ?? "")), into: imgViewUser)
            
//            liveMessage.userName = (UserDefaults.standard.string(forKey: "UserName") ?? "")
//            liveMessage.giftCount = count
//            liveMessage.sendGiftName = gift.giftName
//            liveMessage.sendGiftTo = hostName
//            liveMessage.type = "2"
//            insertNewMsgs(msgs: liveMessage)
      
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
                
                // Call the completion block if provided
                completion?()
            }
        }
    }
    
}
// MARK: - EXTENSION FOR SENDING GIFT IN ONE TO ONE CALL USING ZEGO CUSTOM COMMAND

extension OneToOneCallViewController {
    
    func sendMessageToExit() {
    
        var dic = [String: Any]()
        dic["action_type"] = "end_call"
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Json Ko String main convert kar diya hai.")
                
                var userList = [ZegoUser]()
                
                if (cameFrom == "host") {
                    
                    let newUser = ZegoUser(userID: userID)
                    userList.append(newUser)
                    
                } else {

                    let newUser = ZegoUser(userID: hostID)
                    userList.append(newUser)
                    
                }
                
                ZegoExpressEngine.shared().sendCustomCommand(jsonString, toUserList: userList, roomID: channelName) { errorCode in
                    if errorCode == 0 {
                        // Custom command sent successfully
                        print("Custom command sent successfully to exit one to one")
                        self.startCloseWork()
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
    
    func sendMessage(message: String) {
    
        var dic = [String: Any]()
        dic["action_type"] = "chat_from_app"
        dic["sender_id"] = message
        dic["rec_name"] = (UserDefaults.standard.string(forKey: "UserName") ?? "")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Json Ko String main convert kar diya hai.")
                
                var userList = [ZegoUser]()
                
                if (cameFrom == "host") {
                    
                    let newUser = ZegoUser(userID: userID)
                    userList.append(newUser)
                    
                } else {

                    let newUser = ZegoUser(userID: hostID)
                    userList.append(newUser)
                    
                }
                
                ZegoExpressEngine.shared().sendCustomCommand(jsonString, toUserList: userList, roomID: channelName) { errorCode in
                    if errorCode == 0 {
                        // Custom command sent successfully
                        print("Custom command sent successfully")
                        self.liveMessage.userName =  dic["rec_name"] as? String
                        self.liveMessage.message = message
                        self.liveMessage.type = "0"
                        self.insertNewMsgs(msgs: self.liveMessage)
                        
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
    
    func sendGiftToHost(gift:Gift,giftCount:Int) {
    
        var dic = [String: Any]()
        dic["action_type"] = "gift_send_from_user_from_app"
        dic["sender_id"] = String(gift.id ?? 0)
        dic["rec_name"] = gift.amount //(UserDefaults.standard.string(forKey: "UserName") ?? "") //gift.amount
        dic["gift_Amount"] = gift.amount
        dic["gift_Type"] = gift.animationType
        dic["gift_Url"] = gift.animationFile
        dic["gift_Sound"] = gift.soundFile
        dic["profile_image"] = (UserDefaults.standard.string(forKey: "profilePicture") ?? "")
        dic["gift_img_type"] = gift.imageType
        dic["gift_img"] = gift.image
        dic["gift_count_from_user"] = giftCount
        dic["user_level"] = (UserDefaults.standard.string(forKey: "level") ?? "")
        dic["gift_name"] = gift.giftName
        
        print("The dictionary we are sending in one to one is: \(dic)")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Json Ko String main convert kar diya hai.")
                
                var userList = [ZegoUser]()
                
                if (cameFrom == "host") {
                    
                    let newUser = ZegoUser(userID: userID)
                    userList.append(newUser)
                    
                } else {

                    let newUser = ZegoUser(userID: hostID)
                    userList.append(newUser)
                    
                }
                
                ZegoExpressEngine.shared().sendCustomCommand(jsonString, toUserList: userList, roomID: channelName) { errorCode in
                    if errorCode == 0 {
                        // Custom command sent successfully
                        print("Custom command sent successfully")
                        self.calculateCoins(amount: (gift.amount ?? 0),count: giftCount)
                        self.playGiftAnimation(gift: gift, count: giftCount)
                        if let sheetController = self.sheetController {
                            sheetController.dismiss(animated: true) {
                                // The completion block is called after the dismissal animation is completed
                                print("Sheet view controller dismissed")
                                sheetController.animateOut() // MARK- Comment kia hai isko taaki check kr skain luck gift recieved wala scene.
                            }
                        } else {
                            print("Sheet controller is nil. Unable to dismis0s.")
                            
                        }
                        
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

// MARK: - EXTENSION FOR SETTING DATA AND LOADING IT FOR THE ONE TO ONE CALL TO START OF HOST AND USER

extension OneToOneCallViewController {

    func setData() {
     
        ZegoExpressEngine.shared().muteSpeaker(false)
        
        uniqueID = channelName
        
        if (cameFrom == "appdelegate") {
        
            channelName =  channelName
            
        } else {
            
            channelName =  "Zeeplive" + channelName
        }
        
        hostStreamID = channelName + "_p2pcall_host"
        userStreamID = channelName + "_p2pcall"
     
        print("The channel name for loging is: \(channelName)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
//            ZegoExpressEngine.shared().loginRoom(self.channelName, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
            
            if (self.cameFrom == "user") {
              
                self.lblSendTo.text = "Send To"
                self.btnGiftOutlet.isHidden = false
                self.viewGift.isHidden = false
                self.addLottieAnimation()
                self.lblHostName.text = self.hostName
                self.loadImage(from: self.hostImage, into: self.imgViewHostProfileImage)
                
                ZegoExpressEngine.shared().loginRoom(self.channelName, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
                print("User wala view controller se aaein hai. woh kaam krana hai.")
                
                print("The stream name for publishing is: \(self.userStreamID)")
                
                let zegoMultiConfig = ZegoPublisherConfig()
                zegoMultiConfig.roomID = self.channelName
                
                ZegoExpressEngine.shared().startPublishingStream(self.userStreamID,config: zegoMultiConfig,channel: .main)
                
             //   FUDemoManager.shared().addDemoView(to: self.view, originY: UIScreen.main.bounds.height - FUBottomBarHeight - FUSafaAreaBottomInsets())
                
                let zegocanvas = ZegoCanvas(view: self.view)
                zegocanvas.viewMode = .aspectFill
                let config = ZegoPlayerConfig()
                config.roomID = self.channelName
                
                print("The stream name for playingstream is: \(self.hostStreamID)")
           //     ZegoExpressEngine.shared().loginRoom(self.channelName, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
                
                ZegoExpressEngine.shared().startPlayingStream(self.hostStreamID, canvas: zegocanvas,config: config)
                
            } else {
                
                self.lblSendTo.text = "Send By"
                self.btnGiftOutlet.isHidden = true
                self.viewGift.isHidden = true
                self.lblHostName.text = self.userName
                self.loadImage(from: self.userImage, into: self.imgViewHostProfileImage)
                
                ZegoExpressEngine.shared().loginRoom(self.channelName, user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
                
                print("Host wale view controller se aaein hai. woh kaam krana hai.")
                
                print("The stream name for publishing is: \(self.hostStreamID)")
                
                let zegoMultiConfig = ZegoPublisherConfig()
                zegoMultiConfig.roomID = self.channelName
                
                ZegoExpressEngine.shared().startPublishingStream(self.hostStreamID,config: zegoMultiConfig,channel: .main)
                
               // FUDemoManager.shared().addDemoView(to: self.view, originY: UIScreen.main.bounds.height - FUBottomBarHeight - FUSafaAreaBottomInsets())
                
                let zegocanvas = ZegoCanvas(view: self.view)
                zegocanvas.viewMode = .aspectFill
                let config = ZegoPlayerConfig()
                config.roomID = self.channelName
                
                print("The stream name for playingstream is: \(self.userStreamID)")
                
                ZegoExpressEngine.shared().startPlayingStream(self.userStreamID, canvas: zegocanvas,config: config)
                
            }
        }
    }
    
    func createEngine() {
        
        NSLog(" 🚀 Create ZegoExpressEngine")
        let profile = ZegoEngineProfile()
        profile.appID = KeyCenter.appID
        profile.appSign = KeyCenter.appSign
        
        profile.scenario = .broadcast
        
      //  ZegoExpressEngine.setRoomMode(.multiRoom)
        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)

        ZegoExpressEngine.shared().enableHardwareEncoder(false)

        enableCamera = true
        muteSpeaker = false
        muteMicrophone = false
        
        videoConfig.fps = 30
        videoConfig.bitrate = 2400;
        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
        
        ZegoExpressEngine.shared().setVideoMirrorMode(videoMirrorMode)
        
        previewCanvas.view = self.viewPlayStreamOutlet
        previewCanvas.viewMode = previewViewMode
        print("The preview view shape and size is: \(previewCanvas.view.frame)")
        NSLog(" 🔌 Start preview")
        
        ZegoExpressEngine.shared().startPreview(previewCanvas)
        ZegoExpressEngine.shared().setEventHandler(self)
    }
    
    func destroyEngine() {
        
        print("Yhn live karne vale ka band hua hai")
        NSLog(" 🏳️ Destroy ZegoExpressEngine")
        if (cameFrom == "user") {
            ZegoExpressEngine.shared().stopPlayingStream(userStreamID)
        } else {
            ZegoExpressEngine.shared().stopPlayingStream(hostStreamID)
        }
        
        ZegoExpressEngine.shared().stopPublishingStream()
        ZegoExpressEngine.destroy(nil)
        
    }
    
    func startCloseWork() {
        
        countdownTimerForHost.invalidate()
        countdownTimer.invalidate()
        destroyEngine()
        removeLottieAnimationViews()
        self.navigationController?.popViewController(animated: false)
        
    }
    
}

// MARK: - EXTENSION FOR UI CONFIGURATION AND OTHER WORKS AND THEIR FUNCTIONALITIES

extension OneToOneCallViewController {
    
    func configureUI() {
    
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        viewLuckyGift.isHidden = true
        viewMessage.isHidden = true
        viewMessage.layer.cornerRadius = viewMessage.frame.size.height / 2
        viewMessage.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewUserDetailOutlet.backgroundColor = .black.withAlphaComponent(0.4)
        txtFldMessage.setLeftPaddingPoints(15)
        viewUserDetailOutlet.layer.cornerRadius = viewUserDetailOutlet.frame.size.height / 2
        imgViewHostProfileImage.layer.cornerRadius = imgViewHostProfileImage.frame.size.height / 2
        imgViewHostProfileImage.clipsToBounds = true
       // lblHostName.textColor = UIColor(hexString: "F9B248")
       
        viewLuckyGiftDetails.layer.cornerRadius = viewLuckyGiftDetails.frame.height / 2
        viewLuckyGiftDetails.backgroundColor = .black.withAlphaComponent(0.3)
        viewGiftImage.layer.cornerRadius = viewGiftImage.frame.height / 2
        viewUserImage.layer.cornerRadius = viewUserImage.frame.height / 2
        imgViewGift.layer.cornerRadius = imgViewGift.frame.height / 2
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        viewPlayStreamOutlet.backgroundColor = .black
        view.backgroundColor = .black
        imgViewPlayStream.isHidden = true
       // lblCallTime.isHidden = true
        btnFollowHostOutlet.isHidden = true
        btnFollowWidthConstraints.constant = 0
        btnVideoOnOffOutlet.isHidden = true
     
        ZegoExpressEngine.shared().useFrontCamera(true)
        btnShowOptionsOutlet.backgroundColor = .black.withAlphaComponent(0.4)
        btnShowOptionsOutlet.layer.cornerRadius = btnShowOptionsOutlet.frame.height / 2
        
    }
    
    func notificationWork() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       
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
        animationView1.frame = viewLiveAnimation.bounds
        viewLiveAnimation.addSubview(animationView1)
        
        animationView1.animation = LottieAnimation.named("live_animation") // Replace with your animation file name
        animationView1.loopMode = .loop
        animationView1.play()
        animationView1.isUserInteractionEnabled = false
        
        lottieAnimationViews = [animationView, animationView1]
        
    }
    
    func removeLottieAnimationViews() {
          // Remove Lottie animation views from their superviews
          lottieAnimationViews.forEach { $0.removeFromSuperview() }
      }
    
    @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
              // view.bringSubviewToFront(viewMessage)
               let keyboardHeight = keyboardFrame.cgRectValue.height
              
               let viewBottomY = viewMessage.frame.origin.y + viewMessage.frame.size.height
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
         
         //  view.sendSubviewToBack(viewMessage)
           UIView.animate(withDuration: 0.3) {
               self.viewMessageBottomConstraints.constant = 0 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
               self.viewMessage.frame.origin.y = self.view.frame.size.height - self.viewMessage.frame.size.height
               self.viewMessage.isHidden = true
               self.txtFldMessage.text = ""
               print("jab keyboard hide hoga tb message view ka origin y hai: \(self.viewMessage.frame.origin.y)")
               
           }
       }
    
    @objc func touchTap(tap : UITapGestureRecognizer){
        let tapLocation = tap.location(in: self.view)

        if tapLocation.y < self.view.frame.size.height / 2 {
               view.endEditing(true)
            FUDemoManager.shared().hideBottomBar()
            print("Upar ki screen par tap hua hai.")
            
           } else {
               print("Neeche ki screen par tap hua hai")
               
           }
    }
    
    func tableViewWork() {
        
        tblViewLiveMessages?.register(UINib(nibName: "LiveMessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessagesTableViewCell")
        tblViewLiveMessages.rowHeight = UITableView.automaticDimension
        tblViewLiveMessages.delegate = self
        tblViewLiveMessages.dataSource = self
      //  tblViewLiveMessages.tableHeaderView = headerView
        
    }
    
}

extension OneToOneCallViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return liveMessages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveMessagesTableViewCell", for: indexPath) as! LiveMessagesTableViewCell
      
        cell.viewLevel.isHidden = true
        cell.viewLevelWidthConstraints.constant = 0
        cell.lblUserNameLeftConstraints.constant = 0
        
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
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func insertNewMsgs(msgs: liveMessageModel) {
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
    
}

// MARK: - EXTENSION FOR USING ZEGO DELEGATES FUNCTIONS AND TO KNOW STATE OF THE BROAD AND TO RECEIVE MESSAGE AND OTHER THINGS IN ONE TO ONE

extension OneToOneCallViewController {
    
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
                navigationController?.popViewController(animated: true)
              //  calculateTimeToPlayBroad()
               // startCall()
                
            }
            
            isBroadStarted = true
            
        } else if updateType == ZegoUpdateType.delete {
            // Handle deleted streams
            for stream in streamList {
                let streamID = stream.streamID
                // Use streamID as needed
                print("Deleted stream ID: \(streamID)")
            }
            let currentTimestampInMillisecondsForEndCall = Int(Date().timeIntervalSince1970 * 1000)
            print(currentTimestampInMillisecondsForEndCall)
            
            callEndTimestamp = currentTimestampInMillisecondsForEndCall
            print("The call end time stamp is: \(callEndTimestamp)")
            
//            if (isFirstTime == true) {
//                print("Kuch mat karo. ")
//                isFirstTime = false
//            } else {
//                endCall()
//                print("end call ko call kara do.")
//            }
            
            if (isBroadStarted == true) {
                cameFrom = "host"
                endCall()
                cameFrom = ""
            } else {
                print("Kch nhi krna hai. broad shuru ni hui hai.")
            }
            
           // sendMessageToExit()
            print("Delete stream par aaya hai zego mai")
        }
    }

    
    func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
        NSLog(" 🚩 🚪 Room state update, state: \(state.rawValue), errorCode: \(errorCode), roomID: \(roomID)")
        roomState = state
        print(roomState)

        if state == .connected {
            ZegoExpressEngine.shared().startPreview(previewCanvas)
        }
        
    }
    
    func onPublisherStateUpdate(_ state: ZegoPublisherState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
        NSLog(" 🚩 📤 Publisher state update, state: \(state.rawValue), errorCode: \(errorCode), streamID: \(streamID)")
        publishState = state
        print(publishState)
        if state == .publishRequesting {
            print("Publishing stream: \(streamID)")
        } else if state == .noPublish {
            print("Failed to publish stream: \(streamID), error: \(errorCode)")
        }
        
    }
    
    // Implement the delegate methods
      func onPlayerStateUpdate(_ state: ZegoPlayerState, streamID: String, errorCode: Int) {
          switch state {
          case .noPlay:
              print("Stream \(streamID) is not playing")
              // Handle stream not playing
              break
          case .playing:
              print("Stream \(streamID) is playing")
              // Handle stream playing
              break
          case .playRequesting:
              print("Stream \(streamID) is requesting to play")
              // Handle stream requesting to play
              break
          @unknown default:
              fatalError("Unknown player state")
          }
      }
    
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

        }
        
    }
    
    func onIMRecvCustomCommand(_ command: String, from fromUser: ZegoUser, roomID: String) {
        
        print("The command i am recieving in custom command is: \(command)")
        print("The command from which i am recieving is: \(fromUser)")
        print("The room id in which i am recieving command is: \(roomID)")
        
//        let config = ToastConfiguration(
//            direction: .bottom
//        )
//        
//        let toast = Toast.text(command,config: config)
//        toast.show()
      
        let jsonData = command.data(using: .utf8)!

        do {
            // Deserialize JSON data
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                // Access values from JSON dictionary
                
                   let actionType = json["action_type"] as? String
                   let message = json["sender_id"] as? String
                   let name = json["rec_name"] as? String
                    // Print or use the values as needed
                    print("Action Type: \(actionType)")
                    print("Sender Message: \(message)")
                    print("Name: \(name)")
                    
                if (actionType == "end_call") {
                
                    print("Call bnd krni hai one to one wali. woh kaam shuru kro.")
                    
                    let currentTimestampInMillisecondsForEndCall = Int(Date().timeIntervalSince1970 * 1000)
                    print(currentTimestampInMillisecondsForEndCall)
                    
                    callEndTimestamp = currentTimestampInMillisecondsForEndCall
                    print("The call end time stamp is: \(callEndTimestamp)")
                    
                   // endCall()
                    startCloseWork()
                    
                } else if (actionType == "chat_from_app") {
                
                    print("Message aaya hai . mesage dikhane walal kaam krna hai.")
                    liveMessage.userName = name
                    liveMessage.message = message
                    liveMessage.type = "0"
                    insertNewMsgs(msgs: liveMessage)
                    
                } else if (actionType == "gift_send_from_user_from_app") {
                    
                    print("Gift aaya hai. Gift wala kaam krna hai yhn par.")
                   
                      let giftSenderName = json["rec_name"] as? Int
                      let giftSenderProfilePic = json["profile_image"] as? String
                      let giftSenderLevel = json["user_level"] as? String
                      let giftID = json["sender_id"] as? String
                      let giftAmount = json["gift_Amount"] as? Int
                      let giftType = json["gift_Type"] as? Int
                      let giftUrl = json["gift_Url"] as? String
                      let giftSound = json["gift_Sound"] as? String
                      let giftImageType = json["gift_img_type"] as? String
                      let giftImage = json["gift_img"] as? String
                      let giftCount = json["gift_count_from_user"] as? Int
                      let giftName = json["gift_name"] as? String
                    
                    var sendGiftModel = Gift()
                   
                    sendGiftModel.id = Int(giftID ?? "0")
                    sendGiftModel.giftName = giftName
                    sendGiftModel.image = giftImage
                    sendGiftModel.amount = Int(giftAmount ?? 0)
                    sendGiftModel.animationType = Int(giftType ?? 3)
                    sendGiftModel.animationFile = giftUrl
                    sendGiftModel.soundFile = giftSound
                    sendGiftModel.imageType = giftImageType
                    
                    print("The datat we are recieving for playing gifts is: \(sendGiftModel)")
                    
                    if (sendGiftModel.animationType == 0) {
                        print("Animation play nahi krana hai")
                      
                        viewLuckyGift.isHidden = false
                        shakeAnimation(for: viewGiftImage)
                        hideViewAfterDelay(viewToHide: viewLuckyGift, duration: 0.80) {
                            // This block will be executed when the animation is finished
                            print("Animation finished!")
                            self.viewLuckyGift.isHidden = true
                            
                        }
                        
                        lblNoOfGift.text =  "X" + " " + String(giftCount ?? 1)
                        lblSendGiftToHostName.text = (UserDefaults.standard.string(forKey: "UserName") ?? "") //liveMessage.sendGiftTo ?? ""
                        
                        loadImage(from: giftImage ?? "", into: imgViewGift)
                        loadImage(from: giftSenderProfilePic ?? "", into: imgViewUser)
                     //   ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: self)
                        
                    } else {
                        print("Animation play krana hai")
                        ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: self)
                       
                        viewLuckyGift.isHidden = false
                        shakeAnimation(for: viewGiftImage)
                        hideViewAfterDelay(viewToHide: viewLuckyGift, duration: 0.80) {
                            // This block will be executed when the animation is finished
                            print("Animation finished!")
                            self.viewLuckyGift.isHidden = true
                            
                        }
                        
                        lblNoOfGift.text =  "X" + " " + String(giftCount ?? 1)
                        lblSendGiftToHostName.text = (UserDefaults.standard.string(forKey: "UserName") ?? "") //liveMessage.sendGiftTo ?? ""
                        
                        loadImage(from: giftImage ?? "", into: imgViewGift)
                        loadImage(from: giftSenderProfilePic ?? "", into: imgViewUser)
                        
//                        liveMessage.userName = userName
//                        liveMessage.giftCount = Int(giftCount ?? 0)
//                        liveMessage.sendGiftName = giftName
//                        liveMessage.sendGiftTo = (UserDefaults.standard.string(forKey: "UserName") ?? "")
//                        liveMessage.type = "2"
//                        insertNewMsgs(msgs: liveMessage)
                        
                    }

                    
                }
                
                
            } else {
                print("Failed to deserialize JSON.")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
}

// MARK: - EXTENSION TO CALL API

extension OneToOneCallViewController {
    
    func startCall() {
        
          let params = [
            "duration": [
                "end": callEndTimestamp,
                "start": callStartTimestamp
            ],
            "end_time_duration": totalTime,
            "is_free_call": false,
            "receiver_id": idHost,//(UserDefaults.standard.string(forKey: "UserProfileId") ?? ""),//hostID,
            "unique_id": uniqueID
        ] as [String : Any]
            
        
        print("The parameters we are sending for starting call in one to one is: \(params)")
        
        ApiWrapper.sharedManager().startOneToOneCallHost(url: AllUrls.getUrl.startEndOneToOneCall, parameters: params, completion: { [weak self] data in
            guard let self = self else { return }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)

             //   showAlert(title: "SUCCESS!", message: data["message"] as? String ?? "Your gift has been sent Successfully!", viewController: self)
                
            } else {
                
              //  showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
                
            }
            
           
        })
        
    }
    
    func endCall() {
        
        var params = [String : Any]()
        
        let durationLeft = totalTime - currentTime
        let redeemPoint = UserDefaults.standard.string(forKey: "earning") ?? "0"
        print("The redeem point is: \(redeemPoint)")
        
        if (cameFrom == "user") {
        params = [
                "duration": [
                    "end": callEndTimestamp,
                    "start": ""
                ],
                "end_time_duration": durationLeft,
                "is_free_call": false,
                "receiver_id": idHost,
                "request_points": "0",
                "request_redeem_point": redeemPoint,
                "unique_id": uniqueID
                
            ]
            print("User ke params jaa rhe hai call cut main.")
        } else {
            
             params = [
                "duration": [
                    "end": callEndTimestamp,
                    "start": ""
                ],
                "end_time_duration": "0",
                "is_free_call": false,
                "receiver_id": "",
                "unique_id": uniqueID
                
            ]
            
            print("Host ke params jaa rhe hai call cut main.")
        }
        
        print("The parameters we are sending for ending call in one to one is: \(params)")
        
        ApiWrapper.sharedManager().startOneToOneCallHost(url: AllUrls.getUrl.startEndOneToOneCall, parameters: params, completion: { [weak self] data in
            guard let self = self else { return }
            
            print(data)
            print("the data we are gettign in cutting one to one call is: \(data)")
            
            if let success = data["success"] as? Bool, success {
                print(data)
                    print("Success true wale main aae hai yhn par.")
                sendMessageToExit()
                
             //   showAlert(title: "SUCCESS!", message: data["message"] as? String ?? "Your gift has been sent Successfully!", viewController: self)
                
            } else {
                
                print("Success true wale main nahi aae hai yhn par.")
                                
                let a = data["original"] as? [String : Any]
                print("The value of a is: \(a)")
                print(a?["success"])
                
                let result = a?["success"] as? Bool
                print("the result is: \(result)")
                
                if (result == true) {
                    
                    cameFrom = "host"
                    sendMessageToExit()
                    
                } else {
                    
                    print("Response main false aaya hai.")
                    sendMessageToExit()
                    startCloseWork()
                    
                }
//                if (cameFrom == "user") {
//                    print("User ke case main response shi aa rha hai.")
//                } else {
//                    sendMessageToExit()
//                }
              //  showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)

                
            }
            
           
        })
        
    }

    
    func sendGift(catID:Int,giftID:Int,giftPrice:Int,recieverID:Int,gift: Gift, count:Int) {
        
        let currentGiftSendTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        print(currentGiftSendTimestampInMilliseconds)
        
          let params = [
            "call_start_timestamp": String(callStartTimestamp),
            "call_unique_id": "",
            "category_id": catID,
            "gift_id": giftID,
            "gift_price": giftPrice,
            "gift_sending_timestamp": String(currentGiftSendTimestampInMilliseconds),
            "receive_type": 3,
            "receiver_id": recieverID
            
        ] as [String : Any]
            
        
        print("The parameters we are sending for sending gift in one to one is: \(params)")
        
        ApiWrapper.sharedManager().sendGiftInOneToOneCall(url: AllUrls.getUrl.sendGiftOneToOneCall, parameters: params, completion: { [weak self] data in
            guard let self = self else { return }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)
                   
                sendGiftToHost(gift: gift, giftCount: count)
                
                if let coin = data["result"] as? Int {
                 //   UserDefaults.standard.set(coin, forKey: "coins")
                    print("the total coins we have is: \(coin)")
                    
                }
                
                if let maleCashbackCoins = data["male_lucky_reward_point"] as? Int {
                  print("The cashback coins for male is: \(maleCashbackCoins)")
                    if (maleCashbackCoins > 0) {
                        print("Lucky gift wale ko show karenge")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LuckyGiftCashbackViewController") as! LuckyGiftCashbackViewController
                            nextViewController.giftName = gift.giftName ?? ""
                            nextViewController.giftAmount = maleCashbackCoins
                            nextViewController.modalPresentationStyle = .overCurrentContext
                            
                            self.present(nextViewController, animated: true, completion: nil)
                        }
                    } else {
                        print("Lucky gift wale ko show nahi karenge")
                    }
                    
                } else {
                    // Handle the case where "result" is not an Int or is nil
                   print("Male cashback coins khali hai. Zero kar do inko.")
                    
                }
                
             //   showAlert(title: "SUCCESS!", message: data["message"] as? String ?? "Your gift has been sent Successfully!", viewController: self)
                
            } else {
                
              //  showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
                
            }
            
           
        })
        
    }
    
}

//    func onRoomStateChanged(_ reason: ZegoRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable : Any], roomID: String) {
//        print(roomID)
//        switch reason {
//           case .logining:
//               // logging in
//               // When loginRoom is called to log in to the room or switchRoom is used to switch to the target room, it enters this state, indicating that it is requesting to connect to the server.
//            print(reason)
//            print(errorCode)
//               break
//           case .logined:
//               // login successful
//               // Currently, the loginRoom is successfully called by the developer or the callback triggered by the successful switchRoom. Here, you can handle the business logic for the first successful login to the room, such as fetching chat room and live streaming basic information.
//            print(reason)
//            print(errorCode)
//            print("The room id we are logined for is: \(roomID)")
////            group.leave()
//               break
//           case .loginFailed:
//               // login failed
//               if errorCode == 1002033 {
//                   // When using the login room authentication function, the incoming Token is incorrect or expired.
//                   print(reason)
//                   print(errorCode)
//                   print("The room id we are logined failed for is: \(roomID)")
//               }
//            print("The room id we are logined failed for is: \(roomID)")
//            print(reason)
//            print(errorCode)
//               break
//           case .reconnecting:
//               // Reconnecting
//               // This is currently a callback triggered by successful disconnection and reconnection of the SDK. It is recommended to show some reconnection UI here.
//            print(reason)
//            print(errorCode)
//
//               break
//           case .reconnected:
//               // Reconnection successful
//            print(reason)
//            print(errorCode)
//
//               break
//           case .reconnectFailed:
//               // Reconnect failed
//               // When the room connection is completely disconnected, the SDK will not reconnect. If developers need to log in to the room again, they can actively call the loginRoom interface.
//               // At this time, you can exit the room/live broadcast room/classroom in the business, or manually call the interface to log in again.
//            print(reason)
//            print(errorCode)
//
//               break
//           case .kickOut:
//               // kicked out of the room
//               if errorCode == 1002050 {
//                   // The user was kicked out of the room (because the user with the same userID logged in elsewhere).
//                   print(reason)
//                   print(errorCode)
//               }
//               else if errorCode == 1002055 {
//                   // The user is kicked out of the room (the developer actively calls the background kicking interface).
//                   print(reason)
//                   print(errorCode)
//               }
//               break
//           case .logout:
//               // Logout successful
//               // The developer actively calls logoutRoom to successfully log out of the room.
//               // Or call switchRoom to switch rooms. Log out of the current room successfully within the SDK.
//               // Developers can handle the logic of actively logging out of the room callback here.
//               break
//           case .logoutFailed:
//               // Logout failed
//               // The developer actively calls logoutRoom and fails to log out of the room.
//               // Or call switchRoom to switch rooms. Logout of the current room fails internally in the SDK.
//               // The reason for the error may be that the logout room ID is wrong or does not exist.
//               break
//           @unknown default:
//               break
//           }
//    }

//    @objc func keyboardWillShow(_ notification: Notification) {
//           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//               let keyboardHeight = keyboardFrame.cgRectValue.height
//
//               let viewBottomY = viewMessage.frame.origin.y + viewMessage.frame.size.height + 25
//               let keyboardTopY = self.view.frame.size.height - keyboardHeight
//
//               if viewBottomY > keyboardTopY {
//
//                   UIView.animate(withDuration: 0.3) {
//                       self.viewMessage.isHidden = false
//                       self.txtFldMessage.text = ""
//                       self.viewMessageBottomConstraints.constant = (viewBottomY - keyboardTopY)
//                       self.viewMessage.frame.origin.y -= (viewBottomY - keyboardTopY)
//                       print("The bottom constraints is \(self.viewMessageBottomConstraints.constant)")
//                       print("The message view frame origin y hai: \(self.viewMessage.frame.origin.y )")
//
//                   }
//               }
//           }
//       }
//
//       @objc func keyboardWillHide(_ notification: Notification) {
//
//           UIView.animate(withDuration: 0.3) {
//               self.viewMessageBottomConstraints.constant = 20 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
//               self.viewMessage.frame.origin.y = self.view.frame.size.height - self.viewMessage.frame.size.height
//               self.viewMessage.isHidden = true
//               self.txtFldMessage.text = ""
//               print("jab keyboard hide hoga tb message view ka origin y hai: \(self.viewMessage.frame.origin.y)")
//
//           }
//       }

//    lazy var headerView: UIView = {
//        let v = UIView(frame: CGRect(x: 0, y: 0, width: viewLiveMessages.frame.width, height: 100))
//        v.backgroundColor = UIColor(hexString: "000000")?.withAlphaComponent(0.35)
//        v.layer.cornerRadius = 15
//        v.clipsToBounds = true
//        let lab = UILabel(frame: CGRect(x: 9, y: 8, width: viewLiveMessages.frame.width - 18, height: 100 - 16))
//        lab.backgroundColor = .clear
//        lab.text = "Welcome to ZeepLive!! Please don't share inappropriate content like pornography or violence as it's strictly against our policy. Our AI system continuously monitors content to ensure compliance"
//        lab.textColor = UIColor(hexString: "F9B248")
//        lab.numberOfLines = 0
//        lab.textAlignment = .left
//        lab.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        v.addSubview(lab)
//        v.isUserInteractionEnabled = false
//        return v
//    }()
