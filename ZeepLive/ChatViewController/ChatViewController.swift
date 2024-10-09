//
//  ChatViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 29/12/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import ImSDK_Plus
import RealmSwift
import Lottie
import FittedSheets
import Kingfisher

struct Sender: SenderType {

    var senderId: String
    var displayName: String
}

struct Message: MessageType {

    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Media: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
}


class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, V2TIMConversationListener {
    
  
    let currentUser = Sender(senderId: "userone", displayName: "Prakhar Dixit")
    let otherUser = Sender(senderId: "usertwo", displayName: "Creative Frenzy")
    
    var messages = [MessageType]()
    
    let inputBarAccessoryView = InputBarAccessoryView()
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var messageListener = MessageListener()
    
    lazy var imagePicker = UIImagePickerController()
    lazy var selectedImage = UIImage()
    
    let realm = try? Realm()
    var testUserId = String()
    
    // MARK: - VARIABLE FOR USER ID OF SENDER AND RECIEVER
    var senderUserId = String()
    var recieverUserId = String()
    let backgroundQueue = DispatchQueue.global(qos: .default)
    var recieverUserName = String()
    var recieverUserImage = String()
    
    lazy var index: Int = 10
    weak var sheetController:SheetViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
       // getUserMessageToShow()

        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = GlobalClass.sharedInstance.backButtonColor()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOfflinePushNotification(_:)),
                                               name: Notification.Name("OfflinePushNotification"),
                                               object: nil)
        
        print(recieverUserId)
    
        if let uid = UserDefaults.standard.string(forKey: "UserProfileId"){
            senderUserId = String(uid)
        }
     //   recieverUserId = "1234567"
        print("The reciever id here is \(recieverUserId)")
        print("The sender id is: \(senderUserId)")
        
        if (index == 0) {
            print("Bas message dikhana hai.")
            self.messages.append(Message(sender: self.otherUser,
                                         messageId: "1",
                                         sentDate: Date(),
                                         kind: .text("Welcome to ZeepLive. Enjoy your trip and find your true love here! Do not reveal your personal information , or open any unknown links to avoid information theft and financial loss.")))
            
        } else {
            getUserMessages(id: recieverUserId)
        }
        V2TIMManager.sharedInstance()?.setConversationListener(self)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        configureInputBar()
 
        let image = UIImage(named: "Auto")
        let buttonTitle = "Your Button Title"
        let buttonAction = #selector(leftButtonTapped)
        let buttonImage = UIImage(named: "CallButton")
        
        updateTitleView(image: image, buttonTitle: buttonTitle, buttonAction: buttonAction, buttonImage: buttonImage)
        resetCounterForUser(userId: recieverUserId)
        
    }

    @objc func handleOfflinePushNotification(_ notification: Notification) {
      
        print(notification)
        print(notification.userInfo)
        if let dictionary = notification.userInfo {
            if let userId = dictionary[AnyHashable("userid")] as? String,
               let body = dictionary[AnyHashable("body")] as? String {
                // Now you have safely unwrapped values
                print("User ID: \(userId)")
                print("Body: \(body)")
            } else {
                print("Failed to unwrap values from the dictionary.")
            }
        } else {
            print("The dictionary is nil.")
        }
        
        resetCounterForUser(userId: recieverUserId)
        getUserMessages(id: recieverUserId)
        
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        V2TIMManager.sharedInstance()?.removeSimpleMsgListener(listener: self.messageListener)
        V2TIMManager.sharedInstance()?.removeAdvancedMsgListener(listener: self.messageListener)
        
    }
   
    deinit {

        V2TIMManager.sharedInstance()?.removeSimpleMsgListener(listener: self.messageListener)
        V2TIMManager.sharedInstance()?.removeAdvancedMsgListener(listener: self.messageListener)
        NotificationCenter.default.removeObserver(self,
                                                       name: Notification.Name("OfflinePushNotification"),
                                                       object: nil)
        print("CHat vale view controller par deinit call hua hai")
        
       }
    
}

// MARK: - EXTENSION TO GET , SAVE IMAGES AND MESSAGES IN THE LOCAL DB. AND MESSAGE SENDING FUNCTIONS ARE WRITTEN HERE. FOR TEXT MESSAGE AND IMAGE MESSAGE.

extension ChatViewController {
    
    func getUserMessages(id: String) {
    
        messages.removeAll()
        DispatchQueue.main.async {
    
            if let messages = self.fetchUserMessages(userId: id) {
                for message in messages {
    
                    if (message.userImage != nil) {
    
                            if let imageData = message.userImage {
                                               if let image = UIImage(data: imageData) {
                                                   // Now you have the image in the 'image' variable
                                                   // You can use this image as needed
                                                   print(image)
                                                   if (self.senderUserId == message["sender"] as? String ?? "" ) {
                                                       self.messages.append(Message(sender: self.currentUser,
                                                                                    messageId: "9",
                                                                                    sentDate: Date(),
                                                                                    kind: .photo(Media(url: nil,image: image, placeholderImage: UIImage(named: "UserPlaceHolderImageForCell")!, size: image.size ?? CGSize(width: 250, height: 250)))))
                                                       self.messagesCollectionView.reloadData()
                                                       self.messagesCollectionView.scrollToLastItem(animated: false)
                                                   } else {
    
                                                       self.messages.append(Message(sender: self.otherUser,
                                                                                    messageId: "9",
                                                                                    sentDate: Date(),
                                                                                    kind: .photo(Media(url: nil,image: image, placeholderImage: UIImage(named: "UserPlaceHolderImageForCell")!, size: image.size ?? CGSize(width: 250, height: 250)))))
                                                       self.messagesCollectionView.reloadData()
                                                       self.messagesCollectionView.scrollToLastItem(animated: false)
    
                                                   }
                                               }
                                           }
                    } else {
    
                        if (self.senderUserId == message["sender"] as? String ?? "" ) {
    
                            self.messages.append(Message(sender: self.currentUser,
                                                         messageId: "1",
                                                         sentDate: Date(),
                                                         kind: .text(message["text"] as? String ?? "")))
    
                        } else {
    
                            self.messages.append(Message(sender: self.otherUser,
                                                         messageId: "1",
                                                         sentDate: Date(),
                                                         kind: .text(message["text"] as? String ?? "")))
    
                        }
                    }
                }
    
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: false)
            }
        }
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem(animated: false)
    }
    
    func saveMessage(userId: String, message: Messages, userName:String,profilePhoto:String) {
        
        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return
           }
        
        let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)
        
        if userDetails.isEmpty {
            do {
                try realm.write {
                    let newUserDetail = userDataDetail()
                    newUserDetail.userId = userId
                    newUserDetail.userName = userName
                    newUserDetail.profilePhoto = profilePhoto//UserDefaults.standard.string(forKey: "profilePicture") ?? ""
                    newUserDetail.userMainID = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                    newUserDetail.messages.append(message)
                 //   newUserDetail.lastMessage = message  // Update lastMessage property
                    
                    let main = mainDetail()
                    main.mainID = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
                    
                    realm.add(main)
                    realm.add(newUserDetail)
                }
                
            } catch let error as NSError {
                print("Error creating user details: \(error)")
            }
        } else {
            do {
                try realm.write {
                    for userDetail in userDetails {
                        userDetail.messages.append(message)
                      //  userDetail.lastMessage = message  // Update lastMessage property
                    }
                }
            } catch let error as NSError {
                print("Error saving message: \(error)")
            }
        }
    }


    func fetchLastMessage(userId: String) -> Messages? {
        
        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return nil
           }
        
        let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)

        guard let userDetail = userDetails.first else {
            print("User details not found")
            return nil
        }

        let sortedMessages = userDetail.messages.sorted(byKeyPath: "timestamp", ascending: false)
        return sortedMessages.isEmpty ? nil : sortedMessages[sortedMessages.count - 1]
    }

    func fetchUserMessages(userId: String) -> List<Messages>? {
    
        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return nil
           }
        
        let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)

        guard let userDetail = userDetails.first else {
            print("User details not found")
            return nil
        }

        return userDetail.messages
    }

    func fetchLastMessagesForAllUsers() -> [String: Messages] {
        var lastMessages: [String: Messages] = [:]
        
        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return [:]
           }
        
        let allUserDetails = realm.objects(userDataDetail.self)

        print("Number of user details: \(allUserDetails.count)")

        for userDetail in allUserDetails {
            print("User ID: \(userDetail.userId), Last Message: \(userDetail.lastMessage)")
            if let lastMsg = userDetail.lastMessage {
                lastMessages[userDetail.userId] = lastMsg
                print("User ID: \(userDetail.userId), Last Message: \(lastMsg)")
            }
        }

        
        return lastMessages
    }

    func fetchAllUserDetails() -> [userDataDetail] {
        
        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return []
           }
        
        let userDetails = realm.objects(userDataDetail.self)
        return Array(userDetails)
    }
    
    func downloadImageAndSendUsingTencent() {
        // URL of the image you want to download
        guard let imageURL = URL(string: "https://imgzeeplive.oss-ap-south-1.aliyuncs.com/zeepliveProfileImages/2023/06/17/1687008319.jpg") else {
            print("Invalid image URL.")
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }

            guard let imageData = data, let image = UIImage(data: imageData) else {
                print("Invalid image data.")
                return
            }

            // Save the downloaded image to local storage
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let localURL = documentsDirectory.appendingPathComponent("downloaded_image.png")
                do {
                    try imageData.write(to: localURL)
                    print("Image downloaded and saved to: \(localURL)")

                    // Send the saved image using Tencent Cloud IM
                    self.sendImageUsingTencent(localURL: localURL)
                } catch {
                    print("Error saving image data: \(error)")
                }
            }
        }.resume()
    }

    func sendImageUsingTencent(localURL: URL) {
        // Create an image message
        let imageMessage = V2TIMManager.sharedInstance().createImageMessage(localURL.path)

        // Send the image message
        V2TIMManager.sharedInstance().send(imageMessage,
                                                  receiver: recieverUserId,
                                                  groupID: nil,
                                                  priority: .PRIORITY_DEFAULT,
                                                  onlineUserOnly: false,
                                                  offlinePushInfo: nil,
                                                  progress: { progress in
            // Image upload progress in the range of [0, 100]
            print(progress)

        }, succ: {
            // The image message sent successfully
            print("Image message sent successfully.")
            let image = UIImage(contentsOfFile: localURL.path)
            print(image)
            
            DispatchQueue.main.async {
                
                let message = Messages()
                message.id = self.recieverUserId
                message.sender = self.senderUserId
                message.timestamp = Date()
                if let unwrappedImage = image {
                    message.setUserImage(image: unwrappedImage)
                } else {
                  print("Image nahi hai")
                }
                
                self.saveImage(userId: self.recieverUserId, message: message)
                
                self.messages.append(Message(sender: self.currentUser,
                                             messageId: "9",
                                             sentDate: Date(),
                                             kind: .photo(Media(url: nil,image: image, placeholderImage: UIImage(named: "UserPlaceHolderImageForCell")!, size: image?.size ?? CGSize(width: 250, height: 250)))))
                self.messagesCollectionView.reloadDataAndKeepOffset()
                self.messagesCollectionView.scrollToBottom()
               // self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }, fail: { code, desc in
            // Failed to send the image message
            print("Failed to send image message. Code: \(code), Description: \(desc)")
        })
    }
    
    func sendMessageUsingNewMethod(message:String = "") {
    
        let customElem = V2TIMCustomElem()
        customElem.data = "Custom message".data(using: .utf8)
        
        let pushInfo = V2TIMOfflinePushInfo()
        pushInfo.title = "Prakhar"                        // Offline push display title
        pushInfo.desc = message//"You have a call invitation."   // Offline push display content
        
        
        // Create a V2TIMMessage instance (replace with your message creation logic)
        let sendmessage = V2TIMManager.sharedInstance()?.createTextMessage(UserDefaults.standard.string(forKey: "profilePicture") ?? "")
      //  sendmessage?.imageElem =
        // Set your receiver and/or groupID
        let receiver = "1234567"
        let groupID = ""

        V2TIMManager.sharedInstance()?.send(sendmessage, receiver: recieverUserId, groupID: groupID, priority: .PRIORITY_DEFAULT, onlineUserOnly: false, offlinePushInfo: pushInfo, progress: nil, succ: {
            // Handle success
            print("Message sent successfully")
            DispatchQueue.main.async {
                let userId = self.recieverUserId
                let message1 = Messages()
                message1.id = self.recieverUserId
                message1.text = message//"Pehla wala message"
                message1.sender = self.senderUserId
                message1.timestamp = Date()
                
             //   message1.userName = UserDefaults.standard.string(forKey: "UserName") ?? "N/A"
                
               // self.addMessage(forUser: userId, message: message1, userName: UserDefaults.standard.string(forKey: "UserName") ?? "N/A", userImage: UserDefaults.standard.string(forKey: "profilePicture") ?? "")
                self.saveMessage(userId: userId, message: message1, userName: self.recieverUserName, profilePhoto: self.recieverUserImage)//UserDefaults.standard.string(forKey: "UserName") ?? "N/A")
                
                self.messages.append(Message(sender: self.currentUser,
                                        messageId: "",
                                        sentDate: Date(),
                                        kind: .text("\(message)")))
                print(self.messages.count)
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
                
            }
            
        }, fail: { code, msg in
            // Handle failure
            print("Message sending failed. Code: \(code), Message: \(msg)")
        })
        
    }
    
    func createAndSendMessage( message: String, type:String = "text") {
        // Ensure all necessary values are present
        guard !message.isEmpty else {
            return
        }
        
        // Create the JSON object
        var jsonResult = [String: Any]()
        jsonResult["type"] = type//"text"
        jsonResult["message"] = message
        jsonResult["from"] = UserDefaults.standard.string(forKey: "UserProfileId")
        jsonResult["fromName"] = UserDefaults.standard.string(forKey: "UserName")
        jsonResult["fromImage"] = UserDefaults.standard.string(forKey: "profilePicture")
        jsonResult["time_stamp"] = Int(Date().timeIntervalSince1970 * 1000) // Current time in milliseconds
        
        do {
            // Convert the JSON object to a JSON string
            let jsonData = try JSONSerialization.data(withJSONObject: jsonResult, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                // Send the message
                sendMessageIM(jsonString, toSaveMsg: message, type: type)
            }
        } catch {
            print("Error creating JSON string: \(error.localizedDescription)")
        }
    }

    func sendMessageIM(_ message: String,toSaveMsg:String, type: String = "text") {
        // Implement your sendMessageIM function here
        print("Message to send: \(message)")
        
        V2TIMManager.sharedInstance().sendC2CTextMessage(message, to: recieverUserId, succ: {
               // Success handler
               print("Message sent successfully")
            DispatchQueue.main.async {
                
                if (type == "text") {
                    let userId = self.recieverUserId
                    let message1 = Messages()
                    message1.id = self.recieverUserId
                    message1.text = toSaveMsg//message//"Pehla wala message"
                    message1.sender = self.senderUserId
                    message1.timestamp = Date()
                    
                    //   message1.userName = UserDefaults.standard.string(forKey: "UserName") ?? "N/A"
                    
                    // self.addMessage(forUser: userId, message: message1, userName: UserDefaults.standard.string(forKey: "UserName") ?? "N/A", userImage: UserDefaults.standard.string(forKey: "profilePicture") ?? "")
                    self.saveMessage(userId: userId, message: message1, userName: self.recieverUserName, profilePhoto: self.recieverUserImage)//UserDefaults.standard.string(forKey: "UserName") ?? "N/A")
                    
                    self.messages.append(Message(sender: self.currentUser,
                                                 messageId: "",
                                                 sentDate: Date(),
                                                 kind: .text("\(toSaveMsg)")))
                    print(self.messages.count)
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: true)
                } else {
                
                    DispatchQueue.main.async {
                        
                        let message = Messages()
                        message.id = self.recieverUserId
                        message.sender = self.senderUserId
                        message.timestamp = Date()
                        message.text = "Image"
                        
                        if let url = URL(string: toSaveMsg ?? "N/A") {
                            
                            self.downloadImage(from: url ) { [weak self] image in
                                
                                print(image)
                              
                                if let unwrappedImage = image {
                                    message.setUserImage(image: unwrappedImage)
                                } else {
                                  print("Image nahi hai")
                                }
                                
                                self?.saveImage(userId: self?.recieverUserId ?? "", message: message)
                                
                                self?.messages.append(Message(sender: self?.currentUser ?? Sender(senderId: "", displayName: "N/A"),
                                                             messageId: "9",
                                                             sentDate: Date(),
                                                             kind: .photo(Media(url: nil,image: image, placeholderImage: UIImage(named: "UserPlaceHolderImageForCell")!, size: image?.size ?? CGSize(width: 100, height: 100)))))
                                self?.messagesCollectionView.reloadDataAndKeepOffset()
                                self?.messagesCollectionView.scrollToBottom()
                            }
                            
                        }
                        
                    }
                }
                
            }
            
           }) { (code, error) in
               // Failure handler
               print("Failed to send message, code: \(code), error: \(error ?? "unknown error")")
           }
        
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let downloader = ImageDownloader.default
        let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100)) // Adjust size as needed

        downloader.downloadImage(with: url, options: [.processor(processor)], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                print("Error downloading image: \(error)")
                completion(nil)
            }
        }
    }
    
    // MARK: - FUNCTION TO SAVE IMAGE LOCALLY WHEN THE USER SUCCESSFULLY SENDS THE IMAGE
    
//    func saveImage(userId: String, message: Messages) {
//        do {
//            let realmConfig = realmConfiguration(forUser: userId)
//            let realm = try Realm(configuration: realmConfig)
//            
//            let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)
//            
//            if userDetails.isEmpty {
//                // User details not found, create new details entry
//                let newUserDetail = userDataDetail()
//                newUserDetail.userId = userId
//                newUserDetail.messages.append(message)
//                
//                try realm.write {
//                    realm.add(newUserDetail)
//                }
//            } else {
//                // User details found, add message to existing entry
//                try realm.write {
//                    for userDetail in userDetails {
//                        userDetail.messages.append(message)
//                    }
//                }
//            }
//        } catch let error as NSError {
//            print("Error accessing Realm: \(error.localizedDescription)")
//        }
//    }

    
    func saveImage(userId:String, message: Messages) {
        
        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return
           }
        
        let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)
        print(userDetails)
        
        if userDetails.isEmpty {
            do {
                try realm.write {
                    let newUserDetail = userDataDetail()
                    newUserDetail.userId = userId
                    newUserDetail.messages.append(message)
                    
                    realm.add(newUserDetail)
                }
            } catch let error as NSError {
                print("Error creating user details: \(error)")
            }
        } else {
            do {
                try realm.write {
                    for userDetail in userDetails {
                        userDetail.messages.append(message)
                        
                    }
                }
            } catch let error as NSError {
                print("Error saving message: \(error)")
            }
    }
    }
    
// MARK: - FUNCTION TO INCREASE AND DECREASE COUNTER
    
    func increaseCounterForUser(userId: String) {
        // Safely unwrap 'realm'
        guard let realm = realm else {
            print("Realm not found")
            return
        }

        // Fetch the users (no need to unwrap 'users' as it is not optional)
        let users = realm.objects(userDataDetail.self).filter("userId == %@", userId)
        
        // Safely perform write transaction
        do {
            try realm.write {
                for user in users {
                    user.counter = String((Int(user.counter) ?? 0) + 1)
                    print("jab user counter badhega tab yhn pr \(user.counter)")
                    print("jab user counter badhega tab uski id hai \(userId)")
                }
            }
        } catch {
            print("Error writing to realm: \(error.localizedDescription)")
        }
    }
    
//    func increaseCounterForUser(userId: String) {
//        
//        let users = realm.objects(userDataDetail.self).filter("userId == %@", userId)
//        
//        try! realm.write {
//            for user in users {
//                user.counter = String((Int(user.counter) ?? 0) + 1)
//                print("jab user counter badhega tab yhn pr \(user.counter)")
//                print("jab user counter badhega tab uski id hai \(userId)")
//            }
//        }
//    }
     
    
    func resetCounterForUser(userId: String) {
        
        guard let realm = realm else {
            print("Realm not found")
            return
        }
        
        let users = realm.objects(userDataDetail.self).filter("userId == %@", userId)
        
        do {
            try realm.write {
                for user in users {
                    user.counter = "0"
                    print("Jab user counter nahi badhega tab yhn pr")
                }
            }
        } catch {
            print("the counter is not zero.")
        }
    }
    
}

// MARK: - EXTENSION FOR DESIGNING AND MAKING THE TITLE VIEW AND TO SHOW THE INPUT VIEW OR THE BOTTOM VIEW AND MESSAGE SENDER IMAGE SETTING HERE

extension ChatViewController {
    
    func updateTitleView(image: UIImage?, buttonTitle: String?, buttonAction: Selector?, buttonImage: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // Set the desired size
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        
        let button = UIButton(type: .custom)
        button.setImage(buttonImage, for: .normal) // Set the image for the button
        button.addTarget(self, action: buttonAction!, for: .touchUpInside)
        button.frame = CGRect(x: imageView.frame.size.width + 260, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        label.text = recieverUserName//recieverUserId//"Saurabh Rai"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.frame = CGRect(x: imageView.frame.size.width + 78, y: 0, width: button.frame.origin.x - imageView.frame.size.width - 35 - button.frame.size.width, height: 30)
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30)) // Adjust the width as needed
        
       // titleView.addSubview(imageView)
      //  titleView.addSubview(button)
        titleView.addSubview(label)
        
        imageView.frame.origin.x = 75
        
        navigationItem.titleView = titleView
        
    }


    
    
    func messageForHeaderInSection(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
          return Message(sender: currentUser,
                         messageId: "header",
                         sentDate: Date(),
                         kind: .attributedText(NSAttributedString(string: "Custom Header Text", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.darkGray])))
      }
    
    func configureInputBar() {
           // Create a custom button for the input bar
           let button = InputBarButtonItem()
           button.onKeyboardSwipeGesture { item, gesture in
               if gesture.direction == .left {
                   item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
               } else if gesture.direction == .right {
                   item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
               }
           }
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            button.setSize(CGSize(width: 36, height: 36), animated: false)
            button.setImage(UIImage(named: "giftimagemessage"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = .systemBlue
      
//        let animationView = LottieAnimationView()
//        animationView.contentMode = .scaleToFill
//        animationView.frame = button.bounds
//        button.addSubview(animationView)
//        
//        animationView.animation = LottieAnimation.named("Gift_animation1by1") // Replace with your animation file name
//        animationView.loopMode = .loop
//        animationView.play()
//        animationView.isUserInteractionEnabled = false
//        
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
           // Apply styling to the input text view
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 16)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 20)
           if #available(iOS 13, *) {
               messageInputBar.inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
           } else {
               messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
           }
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
           
         
           messageInputBar.setLeftStackViewWidthConstant(to: 38, animated: false)  // mark: - ye pehle 36 tha. baad mai maine change kia hai
           messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
           
        if (index == 0) {
            messageInputBar.isHidden = true
        } else {
            messageInputBar.isHidden = false
        }
    }

    
    @objc func leftButtonTapped() {
        // Perform your action when the left button is tapped
        print("Left button tapped!")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowGiftViewController") as! ShowGiftViewController
        vc.delegate = self
        vc.cameFrom = "onetoone"
        
        let options = SheetOptions(
            pullBarHeight: 0, useInlineMode: true
        )
        
        
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(480), .fixed(480)], options: options)

        sheetController?.allowPullingPastMaxHeight = false
        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true
        sheetController.dismissOnOverlayTap = true
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = true
        
        sheetController.animateIn(to: view, in: self)
        
//                imagePicker.delegate = self
//                imagePicker.allowsEditing = false
//                imagePicker.sourceType = .photoLibrary
//        
//                present(imagePicker, animated: true, completion: nil)
        
    }
    
    func currentSender() -> MessageKit.SenderType {
        
        return currentUser
    }
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
        switch message.kind {
        case .photo:
            return .clear
        default:
            return isFromCurrentSender(message: message) ?
                   GlobalClass.sharedInstance.userMessageSendColour() :
                   GlobalClass.sharedInstance.setViewBackgroundColour()
        }
    }

    
//    func backgroundColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
//        isFromCurrentSender(message: message) ? GlobalClass.sharedInstance.userMessageSendColour() : GlobalClass.sharedInstance.setViewBackgroundColour()//UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
//    }

    func messageStyle(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MessageStyle {
      let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubble//.bubbleTail(tail, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
        
    }

    func getAvatarFor(sender: SenderType) -> Avatar {
        var initials: String = "??"
        var avatarImage: UIImage?

        switch sender.senderId {
        case currentUser.senderId:
            let name = UserDefaults.standard.string(forKey: "UserName") ?? ""
            if let displayName = name.components(separatedBy: " ").first {
                initials = String(displayName.prefix(2))
            }
        case otherUser.senderId:
            if let displayName = recieverUserName.components(separatedBy: " ").first {
                initials = String(displayName.prefix(2))
            }
        default:
            avatarImage = nil
        }

        return Avatar(image: avatarImage, initials: initials)
    }

}

// MARK: - EXTENSION TO USE INPUT BAR TO SEND THE MESSAGE

extension ChatViewController: InputBarAccessoryViewDelegate {

  func inputBar(_: InputBarAccessoryView, didPressSendButtonWith text: String) {
   
      print("SEnd message button dabi hai")
      print(text)
      messageInputBar.inputTextView.text = ""
    //  sendMessageUsingNewMethod(message: text)
      createAndSendMessage(message: text,type: "text")
      
      
   }
}

// MARK: - EXTENSION FOR USING PICKER VIEW FOR SELECTING IMAGE AND SENDING IMAGE FROM HERE IN THE MESSAGE

extension ChatViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        if let originalImage = info[.originalImage] as? UIImage {
            // Convert the image to data
            if let imageData = originalImage.jpegData(compressionQuality: 1.0) {
               
                // Generate a unique filename
                let filename = UUID().uuidString + ".jpg"
                
                // Get the document directory URL
                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = documentsDirectory.appendingPathComponent(filename)
                    
                    do {
                        // Write the image data to the URL
                        try imageData.write(to: fileURL)
                        
                        // Now you have the URL of the selected image
                        print("Selected image URL: \(fileURL)")
                        sendImageUsingTencent(localURL: fileURL)
                        // You can use this URL to pass it to another view controller or perform other operations
                    } catch {
                        print("Error writing image data to URL: \(error)")
                    }
                }
            }
        }
        
        // Dismiss the image picker
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - EXTENSION FOR USING SHOW GIFTS DELEGATE METHODS AND FUNCTIONS TO SEND GIFT TO HOST OR USER WHILE CHATTING

extension ChatViewController: delegateShowGiftViewController {
    
    func isBalanceLow(isLow: Bool) {
        
        print("Balance low ka function hai chat view controller main.")
        
        if let sheetController = sheetController {
                sheetController.dismiss(animated: true)
            //    sheetController.animateOut()
            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LowBalanceViewController") as! LowBalanceViewController
        
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
    
    func giftSelected(gift: Gift, sendgiftTimes: Int) {
        
        print("Jo gift select kia hai uska function hai chat view controller main.")
        print("This is the main delegate function. we will need this detail to send in gift in custom message in chat view controller.")
        print("The gift selected is: \(gift)")
        print("The gift selected time is: \(sendgiftTimes)")
        
        sendGift(catID: (gift.giftCategoryID ?? 0), giftID: (gift.id ?? 0), giftPrice: (gift.amount ?? 0), recieverID: Int(recieverUserId) ?? 0, gift: gift, count: sendgiftTimes)
        
//        createAndSendMessage(message: gift.image ?? "", type: "gift")
      
        if let sheetController = self.sheetController {
            sheetController.dismiss(animated: true) {
                // The completion block is called after the dismissal animation is completed
                print("Sheet view controller dismissed")
                sheetController.animateOut() // MARK- Comment kia hai isko taaki check kr skain luck gift recieved wala scene.
            }
        } else {
            print("Sheet controller is nil. Unable to dismiss.")
            
        }
        
    }
    
    func showLuckyGift(giftName: String, amount: Int) {
        
        print("Show lucky gift ka function par aaya hai chat view controller main.")
        
    }
    
    func openLowBalanceView(isclicked: Bool) {
        
        print("Open low balance view ke function par aaya hai chat view controller main.")
        
    }
    
    func pkGiftSent(giftAmount: Int, userName: String, userImage: String, userID: String, from: String) {
        
        print("Pk Gift sent ke function par aaya hai chat view controller main.")
        
    }
    
    func giftSentSuccessfully(gift: Gift, sendgiftTimes: Int) {
        
        print("Gift successfully send ho gya hai ke function par aaya hai chat view controller main.")
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND SENDING GIFT TO THE HOST / USER

extension ChatViewController {
    
    func sendGift(catID:Int,giftID:Int,giftPrice:Int,recieverID:Int,gift: Gift, count:Int) {
        
        let currentGiftSendTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        print(currentGiftSendTimestampInMilliseconds)
        
          let params = [
            
            "category_id": catID,
                "receiver_id": recieverID,
                "gift_id": giftID,
                "gift_price": giftPrice,
                "call_start_timestamp": currentGiftSendTimestampInMilliseconds,
                "gift_sending_timestamp": currentGiftSendTimestampInMilliseconds,
                "receive_type": 3
            
        ] as [String : Any]
            
        
        print("The parameters we are sending for sending gift in chat view controller is: \(params)")
        
        ApiWrapper.sharedManager().sendGiftInOneToOneCall(url: AllUrls.getUrl.sendGiftOneToOneCall, parameters: params, completion: { [weak self] data in
            guard let self = self else { return }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)
                   
                createAndSendMessage(message: gift.image ?? "", type: "gift")
                
              //  sendGiftToHost(gift: gift, giftCount: count)
                
                if let coin = data["result"] as? Int {
                 //   UserDefaults.standard.set(coin, forKey: "coins")
                    print("the total coins we have is: \(coin)")
                    UserDefaults.standard.set(coin , forKey: "coins")
                    
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


//            "call_start_timestamp": "",
//            "call_unique_id": "",
//            "category_id": catID,
//            "gift_id": giftID,
//            "gift_price": giftPrice,
//            "gift_sending_timestamp": String(currentGiftSendTimestampInMilliseconds),
//            "receive_type": 3,
//            "receiver_id": recieverID

//    func getUserMessageToShow() {
//
//        if let messages = fetchUserMessages(userId: recieverUserId) {    // agr maine jo sender vala kaam kia hai uske messages chahiye honge tb yhn par senderuserId pass kr denge
//            resetCounterForUser(userId: recieverUserId)
//            for message in messages {
//
//                if (message.userImage != nil) {
//
//                        if let imageData = message.userImage {
//                            if let image = UIImage(data: imageData) {
//                                // Now you have the image in the 'image' variable
//                                // You can use this image as needed
//                                print(image)
//                                if (senderUserId == message["sender"] as? String ?? "" ) {
//                                    self.messages.append(Message(sender: self.currentUser,
//                                                                 messageId: "9",
//                                                                 sentDate: Date(),
//                                                                 kind: .photo(Media(url: nil,image: image, placeholderImage: UIImage(named: "auto")!, size: image.size ?? CGSize(width: 250, height: 250)))))
//                                    self.messagesCollectionView.reloadData()
//                                    self.messagesCollectionView.scrollToLastItem(animated: false)
//                                } else {
//
//                                    self.messages.append(Message(sender: self.otherUser,
//                                                                 messageId: "9",
//                                                                 sentDate: Date(),
//                                                                 kind: .photo(Media(url: nil,image: image, placeholderImage: UIImage(named: "auto")!, size: image.size ?? CGSize(width: 250, height: 250)))))
//                                    self.messagesCollectionView.reloadData()
//                                    self.messagesCollectionView.scrollToLastItem(animated: false)
//
//                                }
//                            }
//                    }
//                } else {
//
//                    if (senderUserId == message["sender"] as? String ?? "" ) {
//
//                        self.messages.append(Message(sender: self.currentUser,
//                                                     messageId: "1",
//                                                     sentDate: Date(),
//                                                     kind: .text(message["text"] as? String ?? "")))
//                        self.messagesCollectionView.reloadData()
//                        self.messagesCollectionView.scrollToLastItem(animated: false)
//                    } else {
//
//                        self.messages.append(Message(sender: self.otherUser,
//                                                     messageId: "1",
//                                                     sentDate: Date(),
//                                                     kind: .text(message["text"] as? String ?? "")))
//                        self.messagesCollectionView.reloadData()
//                        self.messagesCollectionView.scrollToLastItem(animated: false)
//                    }
//                }
//            }
//        }
//
//    }

//func getUserMessages(id: String) {
//
//    DispatchQueue.main.async {
//        
//        if let messages = self.fetchUserMessages(userId: id) {
//            for message in messages {
//                    
//                if (message.userImage != nil) {
//                
//                        if let imageData = message.userImage {
//                                           if let image = UIImage(data: imageData) {
//                                               // Now you have the image in the 'image' variable
//                                               // You can use this image as needed
//                                               print(image)
//                                               if (self.senderUserId == message["sender"] as? String ?? "" ) {
//                                                   self.messages.append(Message(sender: self.currentUser,
//                                                                                messageId: "9",
//                                                                                sentDate: Date(),
//                                                                                kind: .photo(Media(url: nil,image: image, placeholderImage: UIImage(named: "UserPlaceHolderImageForCell")!, size: image.size ?? CGSize(width: 250, height: 250)))))
//                                                   self.messagesCollectionView.reloadData()
//                                                   self.messagesCollectionView.scrollToLastItem(animated: false)
//                                               } else {
//                                                   
//                                                   self.messages.append(Message(sender: self.otherUser,
//                                                                                messageId: "9",
//                                                                                sentDate: Date(),
//                                                                                kind: .photo(Media(url: nil,image: image, placeholderImage: UIImage(named: "UserPlaceHolderImageForCell")!, size: image.size ?? CGSize(width: 250, height: 250)))))
//                                                   self.messagesCollectionView.reloadData()
//                                                   self.messagesCollectionView.scrollToLastItem(animated: false)
//                                                   
//                                               }
//                                           }
//                                       }
//                } else {
//                    
//                    if (self.senderUserId == message["sender"] as? String ?? "" ) {
//                        
//                        self.messages.append(Message(sender: self.currentUser,
//                                                     messageId: "1",
//                                                     sentDate: Date(),
//                                                     kind: .text(message["text"] as? String ?? "")))
//                        
//                    } else {
//                        
//                        self.messages.append(Message(sender: self.otherUser,
//                                                     messageId: "1",
//                                                     sentDate: Date(),
//                                                     kind: .text(message["text"] as? String ?? "")))
//                        
//                    }
//                }
//            }
//            
//            self.messagesCollectionView.reloadData()
//            self.messagesCollectionView.scrollToLastItem(animated: false)
//        }
//    }
//    self.messagesCollectionView.reloadData()
//    self.messagesCollectionView.scrollToLastItem(animated: false)
//}


//    func getAllMessages(forUser userId: String) -> [Messages]? {
//        do {
//            let realmConfig = realmConfiguration(forUser: userId)
//            let realm = try Realm(configuration: realmConfig)
//            let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)
//            if let userDetail = userDetails.first {
//                // Return all messages associated with the user
//                return Array(userDetail.messages)
//            }
//        } catch let error as NSError {
//            print("Error accessing Realm: \(error.localizedDescription)")
//        }
//        return nil
//    }
//
//    func getUserMessages(id: String) {
//        DispatchQueue.main.async {
//            if let messages = self.fetchUserMessages(userId: id) {
//                for message in messages {
//                    if let imageData = message.userImage,
//                       let image = UIImage(data: imageData) {
//                        // Message is an image
//                        self.handleImageMessage(image: image, sender: message.sender)
//                    } else {
//                        // Message is text
//                        self.handleTextMessage(text: message.text, sender: message.sender)
//                    }
//                }
//                // Reload the collectionView
//                self.messagesCollectionView.reloadData()
//                // Scroll to the last item
//                self.messagesCollectionView.scrollToLastItem(animated: false)
//            }
//        }
//    }
//
//    // Helper method to handle image message
//    func handleImageMessage(image: UIImage, sender: String) {
//        let messageSender = (self.senderUserId == sender) ? self.currentUser : self.otherUser
//        let messageId = UUID().uuidString
//        let sentDate = Date()
//        let placeholderImage = UIImage(named: "UserPlaceHolderImageForCell") ?? UIImage()
//        let imageSize = image.size ?? CGSize(width: 250, height: 250)
//        let media = Media(url: nil, image: image, placeholderImage: placeholderImage, size: imageSize)
//        let message = Message(sender: messageSender, messageId: messageId, sentDate: sentDate, kind: .photo(media))
//        self.messages.append(message)
//    }
//
//    // Helper method to handle text message
//    func handleTextMessage(text: String, sender: String) {
//        let messageSender = (self.senderUserId == sender) ? self.currentUser : self.otherUser
//        let messageId = UUID().uuidString
//        let sentDate = Date()
//        let message = Message(sender: messageSender, messageId: messageId, sentDate: sentDate, kind: .text(text))
//        self.messages.append(message)
//    }
//
//
//    // Function to get Realm configuration for a specific user
//    func realmConfiguration(forUser userId: String) -> Realm.Configuration {
//        let fileURL = URL(fileURLWithPath: "\(userId)_realm.realm") // Unique file URL for each user
//        let config = Realm.Configuration(fileURL: fileURL)
//        return config
//    }
//
//    // Function to add a message to a user's details
//    func addMessage(forUser userId: String, message: Messages, userName: String, userImage: String) {
//        // Open Realm with configuration for the specific user
//        let realmConfig = realmConfiguration(forUser: userId)
//        do {
//            let realm = try Realm(configuration: realmConfig)
//            let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)
//
//            if userDetails.isEmpty {
//                // User details not found, create new details entry
//                let newUserDetail = userDataDetail()
//                newUserDetail.userId = userId
//                newUserDetail.userName = userName
//                newUserDetail.profilePhoto = userImage
//                newUserDetail.messages.append(message)
//                try realm.write {
//                    realm.add(newUserDetail)
//                }
//            } else {
//                // User details found, add message to existing entry
//                try realm.write {
//                    for userDetail in userDetails {
//                        userDetail.messages.append(message)
//                    }
//                }
//            }
//        } catch let error as NSError {
//            print("Error accessing Realm: \(error.localizedDescription)")
//        }
//    }

//    func getAvatarFor(sender: SenderType) -> Avatar {
//        let initials: String
//        var avatarImage: UIImage?
//
//        if let displayName = sender.displayName.components(separatedBy: " ").first {
//            initials = String(displayName.prefix(2))
//        } else {
//            initials = "??"
//        }
//
//        switch sender.senderId {
//        case currentUser.senderId:
//            let imageURL = UserDefaults.standard.string(forKey: "profilePicture") ?? ""
//
//            downloadImageFromURL(imageURL) { image in
//                if let downloadedImage = image {
//                    // Use the downloadedImage (e.g., set it to an image view)
//                    DispatchQueue.main.async {
//                        avatarImage = downloadedImage
//                    }
//                } else {
//                    // Handle the case where the image couldn't be downloaded
//                    print("Failed to download image.")
//                }
//            }
//
////            avatarImage = UIImage(named: "Auto")
//        case otherUser.senderId:
//
//            downloadImageFromURL(recieverUserImage) { image in
//
//                if let downloadedImage = image {
//                    // Use the downloadedImage (e.g., set it to an image view)
//                    DispatchQueue.main.async {
//                        avatarImage = downloadedImage
//                    }
//                } else {
//                    // Handle the case where the image couldn't be downloaded
//                    print("Failed to download image.")
//                }
//            }
//
//            //avatarImage = UIImage(named: "UserPlaceHolderImageForCell")
//        // Add more cases for different senders if needed
//        default:
//            avatarImage = nil
//        }
//
//        return Avatar(image: avatarImage, initials: initials)
//    }

//    func configureInputBar() {
//        // Create a custom button for the input bar
//        let button = InputBarButtonItem()
//        button.onKeyboardSwipeGesture { item, gesture in
//            if gesture.direction == .left {
//                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
//            } else if gesture.direction == .right {
//                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
//            }
//        }
//        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
//        button.setSize(CGSize(width: 36, height: 36), animated: false)
//         button.setImage(UIImage(named: "UserPlaceHolderImageForCell"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.tintColor = .systemBlue
//
//        // Create and configure the animation view
//        let animationView = LottieAnimationView()
//        animationView.contentMode = .scaleAspectFit
//        button.addSubview(animationView)
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            animationView.topAnchor.constraint(equalTo: button.topAnchor),
//            animationView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
//            animationView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
//            animationView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
//        ])
//        animationView.animation = LottieAnimation.named("Gift_animation1by1") // Replace with your animation file name
//        animationView.loopMode = .loop
//        animationView.play()
//        animationView.isUserInteractionEnabled = false
//
//        // Add target to the button
//        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
//
//        // Apply styling to the input text view
//        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 16)
//        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 20)
//        if #available(iOS 13, *) {
//            messageInputBar.inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
//        } else {
//            messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
//        }
//        messageInputBar.inputTextView.layer.borderWidth = 1.0
//        messageInputBar.inputTextView.layer.cornerRadius = 16.0
//        messageInputBar.inputTextView.layer.masksToBounds = true
//        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//
//        messageInputBar.setLeftStackViewWidthConstant(to: 38, animated: false)  // mark: - ye pehle 36 tha. baad mai maine change kia hai
//        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
//    }
