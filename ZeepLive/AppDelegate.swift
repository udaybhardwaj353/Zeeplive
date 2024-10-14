//
//  AppDelegate.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 13/04/23.
//

import UIKit
import GoogleSignIn
//import FirebaseCore
import ImSDK_Plus
import UserNotifications
import Kingfisher
import Firebase
import FirebaseCrashlytics
import FirebaseMessaging
//import FirebaseMessaging
import FirebaseCore
//import FirebaseAuth
import ZegoExpressEngine

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate, delegateCallNotificationViewController {
   
    var window: UIWindow?
    var rootVC: TabBarViewController?
    var _deviceToken: Data?
    var unreadNumber: UInt64 = 0
    var messageListener = MessageListener()
    lazy var callSenderID: String = ""
    lazy var callSenderName: String = ""
    lazy var callChannelName: String = ""
    lazy var callSenderImage: String = ""
    lazy var uniqueID: Int = 0
    lazy var channelName: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        if let url = Bundle.main.appStoreReceiptURL, let _ = try? Data(contentsOf: url) {
//           // The receipt exists. Do something.
//            print(url)
//        }
//        else {
//           // Validation fails. The receipt does not exist.
//           exit(173)
//        }
        
#if DEBUG
print("Running in Debug environment")
#else
print("Running in Release environment")
#endif
       // UserDefaults.standard.removeObject(forKey: "uniquedeviceid")
       // ZegoManager.shared.initializeEngine()
        registerForFirebaseToken()
        registerNotification()
        registerForGoogleSignIn()
        registerListener()
        initializeTencentSdk()
        setStorageLimit()
        checkForShumoiGeneration()
        ZLGiftManager.share.getGiftFromServer()
//        ZLFaceUnity.share.initSDK()
        
        return true
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }
      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }

}

@available(iOS 13.0, *)
extension AppDelegate {
    
    func setShuMei(){
        //shumei
        let option = SmOption()
        option.organization = GlobalClass.sharedInstance.orgString //"DbUXaHY4DwXi0MnXDEiD"
           option.appId = "default"
           option.publicKey = GlobalClass.sharedInstance.publicKey
           option.area = .AREA_XJP

//        option.appId = GlobalClass.sharedInstance.appId //"50000133"
//        option.organization = GlobalClass.sharedInstance.orgString //"DbUXaHY4DwXi0MnXDEiD"
//        option.publicKey = GlobalClass.sharedInstance.publicKey 
//        option.url = "http://fp-it.fengkongcloud.com/deviceprofile/v4"
        
        //"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPSI+pLS+n4NXE6oTA0LLBaVCtNfIHWGmPAxnHmjxzf5vRCwtXJ4VaiSL2qIPCVfhPCwyLkTF9/BEKUb2PJDw4YkmeK/E4LuKlRkZDKvnkwtX5hBL9BQht1HIIX9gXdMlWg7PmzW5BBRG+lH9KjGMT4lXojIvSa6HEb1TWmJxjxQIDAQAB"
        option.delegate = self
        
//        SmAntiFraud.shareInstance().create(option)
//        let deviceId = SmAntiFraud.shareInstance().getDeviceId()
        let sdk = SmAntiFraud.shareInstance()!
        sdk.create(option)
        let deviceId = sdk.getDeviceId()
        print("The device id after the shumei is: \(deviceId)")
        UserDefaults.standard.set(deviceId , forKey: "uniquedeviceid")
        print("The unique device id stored is: \(UserDefaults.standard.string(forKey: "uniquedeviceid"))")
     //   ZLUserManager.share.deviceId = deviceId
        
    }
    
    func setRootViewController() {
        let token = UserDefaults.standard.string(forKey: "token")
        print(token)
        if token == nil || token == "" {
            // User is not logged in, so set the login view controller as the root
            let logVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NavigationViewController")
            self.window?.rootViewController = logVc
            
        } else {
            // User is logged in, so set the main tab bar controller as the root
            let mainVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController") as TabBarViewController
            self.rootVC = mainVc
            self.window?.rootViewController = rootVC
        }
    }
    
    func registerListener() {
        
        UNUserNotificationCenter.current().delegate = self
         
        V2TIMManager.sharedInstance()?.setAPNSListener(self)
        V2TIMManager.sharedInstance()?.setConversationListener(self)
        V2TIMManager.sharedInstance().addAdvancedMsgListener(listener: messageListener)
        
    }
    
    func registerForGoogleSignIn() {
        
        let config = GIDConfiguration(clientID: "685817877008-7eoc0ueolpakm9bfum59c18nrh8te0il.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
               print("Abhi user login nahi hai")
            } else {
                print("Abhi bhi user logged in hai")
            }
          }
       // FirebaseApp.configure()
    }
    
    func setStorageLimit() {
        
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024 // Limit memory cache to 100 MB
        cache.diskStorage.config.sizeLimit = 50 * 1024 * 1024 // Limit disk cache to 300 MB
        cache.memoryStorage.config.expiration = .seconds(30) // Cache images for 60 seconds
        cache.diskStorage.config.expiration = .seconds(30)
        
    }
    
    func checkForShumoiGeneration() {
    
        let a = UserDefaults.standard.string(forKey: "uniquedeviceid")
        if (a == "") || (a ==  nil) {
            
            print("shumoi generate krni hai")
            setShuMei()
            
        } else {
            
            print("Shumoi id jo pele generate hui hai woh hai \(a)")
            print("shumoi generate nahi krni hai")
            
        }
        
        
    }
    
}

@available(iOS 13.0, *)
extension AppDelegate: ServerSmidProtocol {
    
    func sm(onSuccess serverId: String!) {
        print("on shumoi success the server id is: \(serverId)")
    }
    
    func sm(onError errorCode: Int) {
        
        print("on shumoi failure or error the error code is : \(errorCode)")
        
    }
}

@available(iOS 13.0, *)
extension AppDelegate: V2TIMSDKListener, V2TIMAPNSListener, V2TIMConversationListener {
    
    func initializeTencentSdk() {
        
        let sdkAppID:Int32 =  50000133
        let config = V2TIMSDKConfig()
        let timManager = V2TIMManager.sharedInstance()
        let initSuccess = timManager?.initSDK(sdkAppID, config: config, listener: self)
        if initSuccess == true {
            print("SDK initialization successful.")
            let identifier = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""//"123456"
            let testUserSig = GenerateTestUserSig.genTestUserSig(identifier: identifier)
            print("Test User Signature: \(testUserSig)")

        
            V2TIMManager.sharedInstance()?.login(identifier, userSig: testUserSig, succ: {
                // Login success block
                print("Login success")
                    
            }) { (code, desc) in
                print(code)
                print(desc)
            
                print("Login failure, code: \(code), desc: \(desc)")
                
            }
        } else {
            print("SDK initialization failed.")
        }
        
    }
    
    func push_registerIfLogined(userID: String) {
           print("[PUSH] \(#function), \(userID)")

           if let deviceToken = _deviceToken {
               let confg = V2TIMAPNSConfig()
               /* Configure your APNS settings */
               confg.businessID = Int32(29072) //sdkBusiId  YHN pr koi business id hogi woh pass karni hai hmain
               confg.token = deviceToken
               V2TIMManager.sharedInstance()?.setAPNS(confg, succ: {
                   print("\(#function), succ")
                   print(confg)
               }, fail: { code, msg in
                   print("\(#function), fail, \(code), \(msg)")
               })
           }
       }
}

// MARK - Extension For Firebase FCM Token Work

extension AppDelegate: MessagingDelegate {
    
    func registerForFirebaseToken() {
  
      FirebaseApp.configure()
     Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
      Messaging.messaging().delegate = self
      Messaging.messaging().isAutoInitEnabled = true
    
    }
        
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken
                   fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                print("Remote FCM registration token: \(token)")
            }
            UserDefaults.standard.set(token, forKey: "Firebasetoken")
            print(UserDefaults.standard.string(forKey: "Firebasetoken"))
            
            let token = UserDefaults.standard.string(forKey: "token")
            print(token)
            
            if token == nil || token == "" {
                print("User Login nahi hai. isliye token update nahi karwaenge")
            } else {
              //  ZLGiftManager.share.sendFCMToken()
            }
        }
    }
}

@available(iOS 13.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    

    
    func registerNotification() {
            let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().requestAuthorization(options: notificationOptions) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    
    func onTotalUnreadMessageCountChanged(_ totalUnreadCount: UInt64) {
       
        unreadNumber = totalUnreadCount
        print(unreadNumber)
        
    }
    
    func onSetAPPUnreadCount() -> UInt32 {
        
        var customBadgeNumber: UInt32 = 0
        
        customBadgeNumber += UInt32(unreadNumber)
        
        return customBadgeNumber
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        let customBadgeNumber = onSetAPPUnreadCount()
        application.applicationIconBadgeNumber = Int(customBadgeNumber)
      
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//           let token = tokenParts.joined()
//           print("Device Token: \(token)")
        
        Messaging.messaging().apnsToken = deviceToken
        print(deviceToken)
        
        _deviceToken = deviceToken
        
        UserDefaults.standard.set(deviceToken , forKey: "Firebasetoken")
        
        push_registerIfLogined(userID: UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error)")
            } else if let token = token {
                print("FCM Token: \(token)")
                UserDefaults.standard.set(token , forKey: "Firebasetoken")
                ZLGiftManager.share.sendFCMToken(token: token)
                // Use the FCM token for notifications
            }
        }

    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM Token Refreshed: \(fcmToken)")
        // Use the refreshed FCM token for notifications
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
       
        let userInfo = notification.request.content.userInfo

        // Print full message.
        print(userInfo)
            
            guard
                let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
                let alert = aps["alert"] as? NSDictionary,
                let body = alert["body"] as? String,
                let title = alert["title"] as? String
                else {
                    // handle any error here
                    return UNNotificationPresentationOptions()
                }

            handleRemoteNotification(userInfo: userInfo)
        
            print("TitleNotification: \(title) \nBody:\(body)")
            
        // Change this to your preferred presentation option
      //  return [[.alert, .sound, .badge]]
        
        // Return an empty set to prevent the notification from being shown
            return []
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        
        handleRemoteNotification(userInfo: userInfo)
        
    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//           // Handle incoming data message
//           print("Received data message: \(remoteMessage.appData)")
//       }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        print(userInfo)  // iss wale function main notification aaya tha ki hmain kisi ne follow kiya hai.
        print("The cloud notification in this function coming is: \(userInfo)")
        
        handleRemoteNotificationForRemote(userInfo: userInfo)
        
    }
    
    // Define the new function to handle the remote notification payload
     func handleRemoteNotificationForRemote(userInfo: [AnyHashable: Any]) {
        
         // Force unwrap values from the userInfo dictionary
             let googleFid = userInfo["google.c.fid"] as? String ?? ""
             print("Firebase Instance ID: \(googleFid)")
             
             let profileImage = userInfo["profile_image"] as? String ?? ""
             print("Profile Image URL: \(profileImage)")
             
             let messageId = userInfo["gcm.message_id"] as? String ?? ""
             print("Message ID: \(messageId)")
             
             let title = userInfo["title"] as? String ?? ""
             print("Title: \(title)")
             
             let timestamp = userInfo["timestamp"] as? String ?? ""
             print("Timestamp: \(timestamp)")
             
             let channelName = userInfo["channel_name"] as? String ?? ""
             print("Channel Name: \(channelName)")
             
             let tokenReceiver = userInfo["token_receiver"] as? String ?? ""
             print("Token Receiver: \(tokenReceiver)")
             
             let outgoingTime = userInfo["outgoing_time"] as? String ?? ""
             print("Outgoing Time: \(outgoingTime)")
             
             let senderId = userInfo["sender_id"] as? String ?? ""
             print("Sender ID: \(senderId)")
             
             let userName = userInfo["user_name"] as? String ?? ""
             print("User Name: \(userName)")
         
         self.channelName = channelName ?? ""
         self.callSenderName = userName ?? ""
         self.callSenderImage = profileImage ?? ""
         self.callSenderID = senderId ?? ""
         
         if  (title.lowercased() == "zegocall") {
             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallNotificationViewController") as! CallNotificationViewController
             
             nextViewController.imageUrl = profileImage ?? ""
             nextViewController.userName = userName ?? ""
             nextViewController.delegate = self
             
             nextViewController.modalPresentationStyle = .overCurrentContext
             
             if let rootVC = GlobalClass.sharedInstance.window?.rootViewController { //window?.rootViewController {
                 rootVC.present(nextViewController, animated: true, completion: nil)
             } else {
                 print("Root view controller is nil, cannot present CallNotificationViewController")
             }
         }
         
         
    }
        
    private func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
        guard let aps = userInfo["aps"] as? [String: AnyObject],
              let alert = aps["alert"] as? [String: AnyObject],
              let title = alert["title"] as? String,
              let body = alert["body"] as? String else {
            return
        }
        
        let senderID = userInfo["sender_id"] as? String
        let uniqueID = userInfo["unique_id"] as? String
        let userName = userInfo["user_name"] as? String
        let tokenReceiver = userInfo["token_receiver"] as? String
        let timestamp = userInfo["timestamp"] as? String
        let profileImage = userInfo["profile_image"] as? String
        let outgoingTime = userInfo["outgoing_time"] as? String
        let channelName = userInfo["channel_name"] as? String
        
        // Handle the notification data as needed
        print("Title: \(title)")
        print("Body: \(body)")
        print("Sender ID: \(senderID ?? "0")")
        print("Unique ID: \(uniqueID ?? "0")")
        print("User Name: \(userName ?? "")")
        print("Token Receiver: \(tokenReceiver ?? "")")
        print("Timestamp: \(timestamp ?? "")")
        print("Profile Image: \(profileImage ?? "")")
        print("Outgoing Time: \(outgoingTime ?? "")")
        print("Channel Name: \(channelName ?? "")")
        
        self.channelName = channelName ?? ""
        self.callSenderName = userName ?? ""
        self.callSenderImage = profileImage ?? ""
        
        if (body.lowercased() == "zegocall") || (title.lowercased() == "zegocall") {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallNotificationViewController") as! CallNotificationViewController
            
            nextViewController.imageUrl = profileImage ?? ""
            nextViewController.userName = userName ?? ""
            nextViewController.delegate = self
            
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            if let rootVC = GlobalClass.sharedInstance.window?.rootViewController { //window?.rootViewController {
                rootVC.present(nextViewController, animated: true, completion: nil)
            } else {
                print("Root view controller is nil, cannot present CallNotificationViewController")
            }
        }
        
    }


    func buttonRecieveCallPressed(isPressed: Bool) {
        
        print("Call button recieve call pressed in the app delegate we get to know it.")
        
        print("The Call Sender Id in app delegate is:The Call Sender Id in app delegate is: \(self.callSenderID)")
        
        startOneToOneWork()
        
   //     ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: String(uniqueID)), config: config)
        
//        ZegoExpressEngine.shared().loginRoom(channelName, user: ZegoUser(userID: String(uniqueID)))
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//           
//            self.sendMessageUsingZego()
//            
//        }
        
    }
    
    func startOneToOneWork() {
    
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneCallViewController") as! OneToOneCallViewController
        nextViewController.channelName = self.channelName
        nextViewController.cameFrom = "appdelegate"
        nextViewController.userName = self.callSenderName
        nextViewController.userImage = self.callSenderImage
        nextViewController.userID = self.callSenderID
        nextViewController.uniqueID = String(self.uniqueID)
        
        
        // Accessing the navigation controller from the root view controller
        if let tabBarController = GlobalClass.sharedInstance.window?.rootViewController as? UITabBarController {
               if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                   navigationController.pushViewController(nextViewController, animated: true)
               } else {
                   print("NavigationController not found in the selected view controller of UITabBarController")
               }
        } else if let navigationController = GlobalClass.sharedInstance.window?.rootViewController as? UINavigationController {
               navigationController.pushViewController(nextViewController, animated: true)
           } else {
               print("NavigationController not found")
           }
        
    }
    
}

// MARK: - EXTENSION FOR SENDING CUSTOM MESSAGE THROUGH ZEGO TO KNOW THE USER THAT ONE TO ONE CALL IS ACCEPTED.

extension AppDelegate {

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
                let hostID = callSenderID //UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
                
                let newUser = ZegoUser(userID: String(hostID))
                userList.append(newUser)
                
                ZegoExpressEngine.shared().sendCustomCommand(jsonString, toUserList: userList, roomID: channelName) { errorCode in
                    if errorCode == 0 {
                        // Custom command sent successfully
                        // Custom command sent successfully
                        print("Custom command sent successfully to the user to start call process.")
                        
                        self.startOneToOneWork()
                        
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

//    private func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
//        guard let aps = userInfo["aps"] as? [String: AnyObject],
//              let alert = aps["alert"] as? [String: AnyObject],
//              let title = alert["title"] as? String,
//              let body = alert["body"] as? String else {
//            return
//        }
//
//        let senderID = userInfo["sender_id"] as? String
//        let uniqueID = userInfo["unique_id"] as? String
//        let userName = userInfo["user_name"] as? String
//        let tokenReceiver = userInfo["token_receiver"] as? String
//        let timestamp = userInfo["timestamp"] as? String
//        let profileImage = userInfo["profile_image"] as? String
//        let outgoingTime = userInfo["outgoing_time"] as? String
//        let channelName = userInfo["channel_name"] as? String
//
//        // Handle the notification data as needed
//        print("Title: \(title)")
//        print("Body: \(body)")
//        print("Sender ID: \(senderID ?? "0")")
//        print("Unique ID: \(uniqueID ?? "0")")
//        print("User Name: \(userName ?? "")")
//        print("Token Receiver: \(tokenReceiver ?? "")")
//        print("Timestamp: \(timestamp ?? "")")
//        print("Profile Image: \(profileImage ?? "")")
//        print("Outgoing Time: \(outgoingTime ?? "")")
//        print("Channel Name: \(channelName ?? "")")
//
//        if (body.lowercased() == "zegocall") {
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CallNotificationViewController") as! CallNotificationViewController
//
//            nextViewController.imageUrl = profileImage ?? ""
//            nextViewController.userName = userName ?? ""
//            nextViewController.delegate = self
//
//            nextViewController.modalPresentationStyle = .overCurrentContext
//
//            present(nextViewController, animated: true, completion: nil)
//
//        }
//
//    }


//        if let rootViewController = window?.rootViewController {
//               let navigationController = UINavigationController(rootViewController: rootViewController)
//
//               // Replace the root view controller with the navigation controller
//               window?.rootViewController = navigationController
//               window?.makeKeyAndVisible()
//
//               navigationController.pushViewController(nextViewController, animated: true)
//           } else {
//               print("Root view controller not found")
//           }

//                       // ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), status: "busy")
//
//                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OneToOneCallViewController") as! OneToOneCallViewController
//                        nextViewController.channelName = self.callChannelName
//                        nextViewController.cameFrom = "host"
//                        nextViewController.userName = self.callSenderName
//                        nextViewController.userImage = self.callSenderImage
//                        nextViewController.userID = self.callSenderID
//                        nextViewController.uniqueID = String(self.uniqueID)
//
//                        self.navigationController?.pushViewController(nextViewController, animated: true)

