//
//  HomeScreenViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/05/23.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import Lottie
import ZegoExpressEngine
import ToastViewSwift
import SwiftyJSON

class HomeScreenViewController: UIViewController, delegateHomeScreenUsersListCollectionViewCell {

//    @IBOutlet weak var viewTop: UIView!
//    @IBOutlet weak var btnLiveOutlet: UIButton!
//    @IBOutlet weak var btnFollowOutlet: UIButton!
//    @IBOutlet weak var btnDiscoverOutlet: UIButton!
//    @IBOutlet weak var btnGoLiveOutlet: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
       lazy var usersList = ListResult()
       private let cache = ImageCache.default
    
    lazy var listType: String = ""
    lazy var pageNo: Int = 1
    
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
     
    lazy var lastPage = Int()
    lazy var overLayer: CustomAlertViewController? = nil
    var userId = ""
    var ref: DatabaseReference!
    var arrUserIds = [String]()
    lazy var userDetails = userDetailsData()
    lazy var isRefreshing = false
    lazy var indexSelected: Int = 0
    lazy var malePointsData = MaleBalance()
    lazy var femalePointsData = FemaleBalance()
    lazy var OneToOneCallData = GetOneToOneNotificationDataResult()
    lazy var oneToOneUniqueID: String = ""
    var isOneToOneStarted: Bool = false
    var isCallConnectingStarted: Bool = false
    lazy var isApiInProgress: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let navigationController = navigationController else {
            
            navigationController?.setNavigationBarHidden(true, animated: true)
           configureUI()
           getUsersList()
            getUserDetails()
            createEngine()
            return
            
        }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!) //To remove all previous UIViewController except the last one
        navigationController.viewControllers = navigationArray
        
        
        
       configureUI()
       getUsersList()
       getUserDetails()
        createEngine()
        
        print(UserDefaults.standard.string(forKey: "token"))
        ref = Database.database().reference()
        navigationController.setNavigationBarHidden(true, animated: true)
        
    }
    
    private func configureUI() {
        
//            btnDiscoverOutlet.isHidden = true
          
            collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingFooterView")
        
            collectionView.register(UINib(nibName: "HomeScreenUsersListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeScreenUsersListCollectionViewCell")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .white
            
            if let token = UserDefaults.standard.string(forKey: "token") {
                print(token)
            }
            
            // Configure image cache settings
            cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
            cache.memoryStorage.config.countLimit = 150
            cache.diskStorage.config.sizeLimit =  100 * 1024 * 1024
            cache.memoryStorage.config.expiration = .seconds(60)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        isApiInProgress = false
        guard let navigationController = navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!) //To remove all previous UIViewController except the last one
        navigationController.viewControllers = navigationArray
        
        if (isOneToOneStarted == true) {
            
            createEngine()
            
            if (isCallConnectingStarted == true) {
                isOneToOneStarted = true
                isCallConnectingStarted = false
            } else {
                isOneToOneStarted = false
            }
            print("One to one start hua hai. isliye engine bnaenge hum nearby View Controller main.")
            
        } else {
            
            print("One to one start nahi hua hai. isliye engine nahi bnaenge phirse hum.")
            
        }
        
//        if (isOneToOneStarted == true) {
//            
//            createEngine()
//            
//            isOneToOneStarted = false
//            print("One to one start hua hai. isliye engine bnaenge hum nearby View Controller main.")
//            
//        } else {
//            
//            print("One to one start nahi hua hai. isliye engine nahi bnaenge phirse hum.")
//            
//        }
        
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        overLayer = nil
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
// MARK: - BUTTONS ACTIONS AND THEIR WORKING
    
//    @IBAction func btnLivePressed(_ sender: Any) {
//        
//        print("Button Live Pressed")
//        btnLiveOutlet.setTitleColor(.systemPurple, for: .normal)
//        btnFollowOutlet.setTitleColor(.darkGray, for: .normal)
//        btnDiscoverOutlet.setTitleColor(.darkGray, for: .normal)
//        listType = ""
//        pageNo = 1
//        usersList.data?.removeAll()
//        getUsersList()
//        KingfisherManager.shared.cache.clearDiskCache()
//        KingfisherManager.shared.cache.clearMemoryCache()
//    }
//    
//    @IBAction func btnFollowPressed(_ sender: Any) {
//        
//        print("Button Follow Pressed")
//        btnFollowOutlet.setTitleColor(.systemPurple, for: .normal)
//        btnLiveOutlet.setTitleColor(.darkGray, for: .normal)
//        btnDiscoverOutlet.setTitleColor(.darkGray, for: .normal)
//        listType = "follow"
//        pageNo = 1
//         usersList.data?.removeAll()
//        getUsersList()
//        KingfisherManager.shared.cache.clearDiskCache()
//        KingfisherManager.shared.cache.clearMemoryCache()
//    }
//    
//    @IBAction func btnDiscoverPressed(_ sender: Any) {
//        
//        print("Button Discover Pressed")
//        btnDiscoverOutlet.setTitleColor(.systemPurple, for: .normal)
//        btnLiveOutlet.setTitleColor(.darkGray, for: .normal)
//        btnFollowOutlet.setTitleColor(.darkGray, for: .normal)
//        KingfisherManager.shared.cache.clearDiskCache()
//        KingfisherManager.shared.cache.clearMemoryCache()
//    }
    
//    @IBAction func btnGoLivePressed(_ sender: Any) {
//        
//        print("Button Go Live Pressed")
//        print(userDetails)
//        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PublishStreamViewController") as! PublishStreamViewController
//        nextViewController.roomId = "Zeeplive" + String(userDetails.id ?? 0)
//        nextViewController.streamId = String(userDetails.id ?? 0)
//        
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//        
//    }
    
}

// MARK: - EXTENSION FOR DOING WORK FOR ONE TO ONE CALL WITH HOST AND ZEGO FUNCTIONS AND WORKING ARE HERE MENTIONED

extension HomeScreenViewController: ZegoEventHandler {
    
    func createEngine() {
        
        NSLog(" 🚀 Create ZegoExpressEngine Nearby Controller.")
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
        
    }
    
    func startOneToOneCallWork() {
      
        let userCoins = UserDefaults.standard.string(forKey: "coins")
        print("The User Coins is: \(userCoins)")
        
        let hostCallRate = usersList.data?[indexSelected].newCallRate ?? 0
        print("The host call rate is: \(hostCallRate)")
        
        let coinForHostCall = (hostCallRate * 60)
        print("The coin required for calling host is: \(coinForHostCall)")
        
        if ((Int(userCoins ?? "0") ?? 0) >= (Int(coinForHostCall))) {
            
            print("User ke wallet main balance hai. Call lga lenge hum log")
            print("The User Coins in integer is: \(Int(userCoins ?? "0") ?? 0)")
        
            isApiInProgress = true
            oneToOneCallDial()
          //  oneToOneCallDialInBroad()
            
        } else {
            
            print("User ke wallet main balance nahi hai. Call nahi lgegi.")
            
            let config = ToastConfiguration(
                direction: .bottom
            )
            
            let toast = Toast.text("Sorry, you don't have enough balance to initiate call",config: config)
            toast.show()
           
            isApiInProgress = false
            
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
                let hostID = usersList.data?[indexSelected].profileID ?? 0
                
                let newUser = ZegoUser(userID: String(hostID))
                userList.append(newUser)
                
                ZegoExpressEngine.shared().sendCustomCommand(jsonString, toUserList: userList, roomID: usersList.data?[indexSelected].broadChannelName ?? "") { errorCode in
                    if errorCode == 0 {
                        // Custom command sent successfully
                        print("Custom command sent successfully")
                       
                        self.isOneToOneStarted = true
                        self.isCallConnectingStarted = true
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallConnectingViewController") as! CallConnectingViewController
                        nextViewController.hostImage = self.usersList.data?[self.indexSelected].profileImage ?? ""
                        nextViewController.hostName = self.usersList.data?[self.indexSelected].name ?? ""
                        nextViewController.channelName = self.usersList.data?[self.indexSelected].broadChannelName ?? ""
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
        
    func onIMRecvCustomCommand(_ command: String, from fromUser: ZegoUser, roomID: String) {
        print(command)  // Check the structure of the received JSON string
        print(fromUser)
        print(roomID)
        print(command.description)
        
        print("The command we are getting in the IMRECV Custom Command in NearBy View Controller is: \(command)")
        
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
                        
                        // Find and pop the `CallConnectingViewController`
                        if let navigationController = self.navigationController {
                            // Find the index of `CallConnectingViewController` in the navigation stack
                            if let viewControllerToPopIndex = navigationController.viewControllers.firstIndex(where: { $0 is CallConnectingViewController }) {
                                // Remove `CallConnectingViewController` from the navigation stack
                                var viewControllers = navigationController.viewControllers
                                viewControllers.remove(at: viewControllerToPopIndex)
                                navigationController.setViewControllers(viewControllers, animated: false)
                            }
                        }
                        
                        isOneToOneStarted = true
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneCallViewController") as! OneToOneCallViewController
                        nextViewController.channelName = oneToOneUniqueID
                        nextViewController.cameFrom = "user"
                        nextViewController.hostName = usersList.data?[indexSelected].name ?? ""
                        nextViewController.hostImage = usersList.data?[indexSelected].profileImage ?? ""
                        nextViewController.hostID = String(usersList.data?[indexSelected].profileID ?? 0)
                        nextViewController.idHost = String(usersList.data?[indexSelected].id ?? 0)
                        nextViewController.hostCallRate = String(usersList.data?[indexSelected].newCallRate ?? 0)
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
           // startOneToOneCallWork()
            getPoints()
            
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
    
}

// MARK: - EXTENSION FOR COLLECTION VIEW DELEGATES AND METHODS FOR SHOWING DATA TO THE USER

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

 // MARK: - COLLECTION VIEW FOOTER FUNCTIONS TO SHOW LOADER WHEN SCROLLING
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingFooterView", for: indexPath) as! LoadingFooterView
            
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // Return the desired size for the footer view
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
 
 // MARK: - COLLECTION VIEW FUNCTIONS TO SET VALUES IN THE COLLECTION VIEW CELL AND SHOW DATA TO THE USER
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersList.data?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenUsersListCollectionViewCell", for: indexPath) as! HomeScreenUsersListCollectionViewCell
       
        cell.layer.cornerRadius = 5
        cell.viewCountry.frame.size.width = cell.lblUserCountryName.intrinsicContentSize.width
      //  cell.lblUserNameWidthConstraints.constant = -40
     //   cell.viewUserStatus.backgroundColor = .black.withAlphaComponent(0.2)
        
        if (usersList.data?.count == 0) || (usersList.data == nil) {
            print("ye khali hai andar mat jaana")
        } else {
            if let user = usersList.data?[indexPath.row] {
                cell.lblUserName.text = user.name ?? ""
                cell.lblUserCountryName.text = user.city ?? ""
                
                print("The status in the cell is \(usersList.data?[indexPath.item].userStatus)")
                print("The index of the cell is \(indexPath.row)")
                
//                cell.lblUserStatus.text = usersList.data?[indexPath.row].userStatus
                
                if (user.broadstatus == 1) {
                    
                    cell.viewUserStatus.subviews.forEach { subview in
                           if subview is LottieAnimationView {
                               subview.removeFromSuperview()
                           }
                       }
                    
                    cell.lblUserStatus.text = "Live"//"Online"
                    cell.viewUserStatus.backgroundColor = GlobalClass.sharedInstance.setStatusViewBackgroundColour()
                    cell.lblUserStatus.isHidden = false
                    
                } else if (user.broadstatus == 2 || user.broadstatus == 3) {
                 //   cell.lblUserStatus.text = "PK"//"Live"
                  
                    // Remove any existing animation view before adding a new one
                       cell.viewUserStatus.subviews.forEach { subview in
                           if subview is LottieAnimationView {
                               subview.removeFromSuperview()
                           }
                       }

                       // Add Lottie animation view when broadstatus == 2
                       let animationView = LottieAnimationView()
                       animationView.contentMode = .scaleAspectFit
                       animationView.frame = cell.viewUserStatus.bounds
                       cell.viewUserStatus.addSubview(animationView)

                       animationView.animation = LottieAnimation.named("PkkkK") // Replace with your animation file name
                       animationView.loopMode = .loop
                       animationView.play()
                    
                    
                    cell.lblUserStatus.isHidden = true
                    cell.viewUserStatus.backgroundColor = GlobalClass.sharedInstance.setPKStatusBackgroundViewColour()
                    
                }  else if (user.broadstatus == 0) {
                    
                    cell.viewUserStatus.subviews.forEach { subview in
                           if subview is LottieAnimationView {
                               subview.removeFromSuperview()
                           }
                       }
                 
                    cell.lblUserStatus.text = "Offline"
                    cell.viewUserStatus.backgroundColor = GlobalClass.sharedInstance.setStatusViewBackgroundColour()
                    cell.lblUserStatus.isHidden = false
                    
                }
                  
                if let profileImageURL = URL(string: user.profileImage ?? "") {
                    KF.url(profileImageURL)
                       // .downsampling(size: CGSize(width: 200, height: 200))
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
                
            }
            
            cell.delegate = self
            cell.btnReportProfileOutlet.tag = indexPath.row
            cell.btnCallHostOutlet.tag = indexPath.row
            
            //        print(cell.lblUserName.intrinsicContentSize.width)
            //        print(cell.lblUserCountryName.intrinsicContentSize.width)
            //
            //        print("The Indexpath is: \(indexPath.row)")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 3 * 2 ) / 2 //(372) / 2
            let height = width  + 60 //ratio
            return CGSize(width: width, height: height)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        if (usersList.data?[indexPath.item].userStatus == "0")  {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
            nextViewController.userID = String(usersList.data?[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(nextViewController, animated: true)

        } else {
            
            ZegoExpressEngine.shared().logoutRoom()
            ZegoExpressEngine.destroy(nil)
            
            isOneToOneStarted = true
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipeUpDownTestingViewController") as! SwipeUpDownTestingViewController
            nextViewController.room = usersList.data?[indexPath.item].broadChannelName ?? ""
            nextViewController.broad = ((usersList.data?[indexPath.item].broadChannelName)!) + "_stream"
            nextViewController.usersList = usersList
            nextViewController.currentIndex = indexPath.row
            nextViewController.pageNo = pageNo
            nextViewController.apiType = "live"
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PlayLiveStreamingViewController") as! PlayLiveStreamingViewController
//            nextViewController.roomId = usersList.data?[indexPath.item].broadChannelName ?? ""
//            nextViewController.streamId = ((usersList.data?[indexPath.item].broadChannelName)!) + "_stream"
//            self.navigationController?.pushViewController(nextViewController, animated: true)
            
//        }
        
    }
  
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.item == lastIndex {
            pageNo += 1
            print(pageNo)
            
            if (pageNo <= lastPage) {
                isDataLoading = true
                print("Ab Call Krana Hai")
                LoadingIndicatorManager.shared.showLoadingIndicator(collectionView: collectionView)
                getUsersList()
             
            } else {
                print("Ye last page hai ... isliye api call nahi krani hai")
                LoadingIndicatorManager.shared.hideLoadingIndicator(collectionView: collectionView)
            }
        }
    }
    
    func reportProfileButtonPressed(selectedIndex: Int) {
        print(selectedIndex)
        print(usersList.data?[selectedIndex].id)
        print(usersList.data?[selectedIndex].profileID)
        overLayer = CustomAlertViewController()
        overLayer?.appear(sender: self, userId: usersList.data?[selectedIndex].profileID ?? 0)
        
    }
    
    func callHost(selectedIndex: Int) {
        
        indexSelected = selectedIndex
        
        print(selectedIndex)
        print("The index on the call host in nearby controller is: \(selectedIndex)")
        print("The channel name here of the host is: \(usersList.data?[selectedIndex].broadChannelName)")
       
        if (isApiInProgress == true) {
            print("Abhi phir se api hit nahi hogi.")
        } else {
            print("Abhi phir se api hit hogi.")
            isApiInProgress = true
            getPoints()
        }
        
      //  getPoints()
        
       // createEngine()
//        ZegoExpressEngine.shared().logoutRoom()
//        ZegoExpressEngine.shared().loginRoom(usersList.data?[selectedIndex].broadChannelName ?? "", user: ZegoUser(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? ""))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        print("The offset y is: \(offsetY)")
        
        if offsetY < 0 && !isRefreshing {
            
            LoadingIndicatorManager.shared.showRefreshLoadingIndicator(on: self.view)
            
            pageNo = 1
            getUsersList()
            isRefreshing = true
            
        }
        
        if offsetY >= 0 {
            isRefreshing = false
            
        }
    }
    
}
// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM SERVER

extension HomeScreenViewController {
   
    func getUsersList() {
        
        let url = AllUrls.baseUrl + "livebroadcastList?type=\(listType)&page=\(pageNo)"
        
        ApiWrapper.sharedManager().getUsersList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            lastPage = data?.lastPage ?? 0
            print(lastPage)
       //     arrUserIds.removeAll()
//            usersList.data?.removeAll()
            
            if (isRefreshing == true) {
                
                print("Userlist ko khali krna hai kyunki refresh krna hai isko.")
                usersList.data?.removeAll()
                
            } else {
                
                print("Userlist ko khali krne ki jrurt ni hai")
            }
            
            if let userList = data?.data {
                       print(userList)
                       
                       if usersList.data == nil {
                           usersList.data = userList
            
                       } else {
                           usersList.data?.append(contentsOf: userList)
                          
                       }
//                for i in 0..<(usersList.data?.count ?? 0) {
//                    
//                    arrUserIds.append(String(usersList.data?[i].profileID ?? 0))
//                    
//                }
                           print(usersList.data?.count)
                        //    collectionView.reloadData()
                LoadingIndicatorManager.shared.hideLoadingIndicator(collectionView: collectionView)
                LoadingIndicatorManager.shared.hideRefreshLoadingIndicator()
                
            }
           
          //  print(arrUserIds)
          //  observeChangesinFirebase()
          //  observeChangesSingleTimeInFirebase()
            collectionView.reloadData()
        }
      
    }
    
    func getUserDetails() {
        
        ApiWrapper.sharedManager().userDetails(url: AllUrls.getUrl.getUserDetails) { [weak self] (data, value) in
            guard let self = self else { return }
           
            userDetails = data ?? userDetails
                print(userDetails)
                print(userDetails.name)
                print(userDetails.id)
                UserDefaults.standard.set(userDetails.id , forKey: "UserId")
                print(UserDefaults.standard.string(forKey: "UserId"))
            
            if (userDetails.profileImages?.count == 0) || (userDetails.profileImages == nil) {
                print("Image nahi hai")
                
            } else {
                
                print("Profile Image hai")
                UserDefaults.standard.set(userDetails.profileImages?[0].imageName , forKey: "profilePicture")
                print(UserDefaults.standard.string(forKey: "profilePicture"))
                   
            }
            
        }
        
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
       // isApiInProgress = false
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
    
    func oneToOneCallDialInBroad() {
        
        let connectingUserId = String(usersList.data?[indexSelected].profileID ?? 0)
        let hostCallRate = usersList.data?[indexSelected].newCallRate ?? 0//String(usersList.data?[currentIndex].newCallRate ?? 0)
        
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

        })
  
    }
    
    func oneToOneCallDial() {
        
        showLoader()
        isApiInProgress = true
        
        let connectingUserId = String(usersList.data?[indexSelected].profileID ?? 0) //String(usersList.data?[currentIndex].profileID ?? 0)
        let hostCallRate = String(usersList.data?[indexSelected].newCallRate ?? 1) //callRate//String(usersList.data?[currentIndex].newCallRate ?? 0)
        
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
                    nextViewController.hostName = usersList.data?[indexSelected].name ?? ""
                    nextViewController.hostImage = usersList.data?[indexSelected].profileImage ?? ""
                    nextViewController.hostID = String(usersList.data?[indexSelected].profileID ?? 0)
                    nextViewController.idHost = String(usersList.data?[indexSelected].id ?? 0) //String(usersList.data?[currentIndex].id ?? 0)
                    nextViewController.hostCallRate = String(usersList.data?[indexSelected].newCallRate ?? 0)
                    nextViewController.uniqueID = uniqueID ?? ""
            
                    self.navigationController?.pushViewController(nextViewController, animated: true)
            hideLoader()
            isApiInProgress = false
            
        })
        isApiInProgress = false
    }
    
}

//// MARK: - SCROLL VIEW DELEGATE FUNCTION TO CALL THE API WHEN THE USER SCROLLED DOWN IN THE LIST WHILE SCROLLING
//
//extension HomeScreenViewController: UIScrollViewDelegate {
//    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
//            print("scrollViewWillBeginDragging")
//            isDataLoading = false
//        }
//    
//    
//        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//                print("scrollViewDidEndDragging")
//            
//}
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scroll view decelerate ho rha hai")
//        
//        if ((collectionView.contentOffset.y + collectionView.frame.size.height + 200) >= collectionView.contentSize.height)
//            
//        {
//
//               if !isDataLoading{
//                   if didEndReached == true {
//                       print("data load ni krana hai")
//                   } else {
//                       pageNo += 1
//                       print(pageNo)
//                       
//                       if (pageNo <= lastPage) {
//                           isDataLoading = true
//                           print("Ab Call Krana Hai")
//                           LoadingIndicatorManager.shared.showLoadingIndicator(collectionView: collectionView)
//                           getUsersList()
//                           collectionView.reloadData()
//                       } else {
//                           print("Ye last page hai ... isliye api call nahi krani hai")
//                           LoadingIndicatorManager.shared.hideLoadingIndicator(collectionView: collectionView)
//                       }
//                   }
//               }
//        }
//    }
//}

extension HomeScreenViewController {
    
    func observeChangesinFirebase() {
        let databaseRef = Database.database().reference()
        let parentNodeRef = databaseRef.child("UserStatus")
        
        for (index, userId) in arrUserIds.enumerated() {
            let query = parentNodeRef.child(userId)
            
            let observer = query.observe(.childChanged) { [weak self] snapshot, _ in
                guard let self = self else { return }
                
                if snapshot.exists() {
                    let updatedKey = snapshot.key
                    let updatedValue = snapshot.value as? String ?? ""
                    let keyName = String(updatedKey)
                    let keyValue = String(updatedValue)
                    
                    // Find the matching user index in the data source
                    guard let userIndex = self.usersList.data?.firstIndex(where: { $0.profileID == Int(userId) }) else {
                        print("User not found in the data source")
                        print("The user id that has not been found is \(userId)")
                        print("Jab User ID nahi mili tab userlist mai data hai \(usersList.data?.count)")
                        
                        return
                    }
                    
                    print("The userId that has been found is \(userId)")
                    print("Jab userid mila tha tb model main data hai \(usersList.data?.count)")
                    
                    switch keyName.lowercased() {
                    case "level":
                        // Update the appropriate property in the data source array
                        self.usersList.data?[userIndex].level = Int(keyValue)
                        
                    case "name":
                        // Update the appropriate property in the data source array
                        self.usersList.data?[userIndex].name = keyValue
                        
                    case "pid":
                        // Update the appropriate property in the data source array
                        self.usersList.data?[userIndex].profileID = Int(keyValue)
                        
                    case "status":
                        // Update the appropriate property in the data source array
                        switch keyValue.lowercased() {
                        case "online":
                            self.usersList.data?[userIndex].userStatus = keyValue
                        case "offline":
                            self.usersList.data?[userIndex].userStatus = keyValue
                        case "live":
                            self.usersList.data?[userIndex].userStatus = keyValue
                        case "busy":
                            self.usersList.data?[userIndex].userStatus = keyValue
                        case "pk":
                            self.usersList.data?[userIndex].userStatus = keyValue
                        default:
                            break
                        }
                    default:
                        break
                    }
                    
                    // Reload the collection view for the updated item
                    let indexPath = IndexPath(item: userIndex, section: 0)
                    DispatchQueue.main.async {
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                } else {
                    print("No data exists for the snapshot")
                }
            }
        }
    }
    
    func observeChangesSingleTimeInFirebase() {
     
        var observers: [String: DatabaseHandle] = [:]
        
        observers.removeAll()
        
        for (index, userId) in arrUserIds.enumerated() {
            ref = Database.database().reference()
            
            let query = ref.child("UserStatus").child(userId)
            
            let handle = query.observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else { return }
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["status"] as? String ?? ""
                
                // Call a separate function to process the data with the index
                self.processData(snapshot: snapshot, index: index)
            } withCancel: { error in
                print(error.localizedDescription)
            }
            
            observers[userId] = DatabaseHandle(index)
            print(observers[userId])
        }
    }
    
    func processData(snapshot: DataSnapshot, index: Int) {
        // Access the snapshot data and process it using the provided index
        // You can perform any desired operations here
        // For example:
        let value = snapshot.value as? NSDictionary
        let username = value?["status"] as? String ?? ""
        
        print("The value is:\(value)")
        print("The Index is: \(index)")
        print("Index: \(index), status: \(username)")
        
        if let usersData = self.usersList.data, usersData.indices.contains(index) {
            // Access the array element at the given index
            self.usersList.data?[index].userStatus = username
            
            // Reload the collection view for the updated item
            let indexPath = IndexPath(item: index, section: 0)
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [indexPath])
            }
        } else {
            print("Invalid index: \(index)")
        }
    }
}
