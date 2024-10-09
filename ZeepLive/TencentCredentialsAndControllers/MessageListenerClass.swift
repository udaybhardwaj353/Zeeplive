//
//  MessageListenerClas.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/01/24.
//

import Foundation
import ImSDK_Plus
import UIKit
import RealmSwift
import Kingfisher

class MessageListener: NSObject, V2TIMSimpleMsgListener, V2TIMAdvancedMsgListener, V2TIMGroupListener {
    var c2cTextMessageHandler: ((String, V2TIMUserInfo, String) -> Void)?
    var c2cCustomMessageHandler: ((String, V2TIMUserInfo, Data) -> Void)?
    var imageSentClosure: ((UIImage) -> Void)?
    var offlinePushInfoHandler: ((String, String) -> Void)?
    let realm = try? Realm()
    var groupUserEnter: ((String, [V2TIMGroupMemberInfo]) -> Void)?
    var groupUserLeave: ((String, V2TIMGroupMemberInfo) -> Void)?
    
    // Add an initializer for the class
      override init() {
          super.init() // Call the superclass initializer
          
          // Initialize Realm safely inside the initializer
          do {
              let realm = try Realm()
              // Use the realm instance for database operations
          } catch let error as NSError {
              // Handle the error appropriately
              print("Error initializing Realm: \(error.localizedDescription)")
          }
      }
    
    func onRecvC2CTextMessage(_ msgID: String!, sender info: V2TIMUserInfo!, text: String!) {
        c2cTextMessageHandler?(msgID, info, text)
    }
    
    func onRecvC2CCustomMessage(_ msgID: String!, sender info: V2TIMUserInfo!, customData data: Data!) {
        c2cCustomMessageHandler?(msgID, info, data)
    }
    
    func onRecvGroupTextMessage(_ msgID: String!, groupID: String!, sender info: V2TIMGroupMemberInfo!, text: String!) {
        // Parse the message and display it on the UI
        print(msgID)
        print(groupID)
        print(text)
        print(info)
        print(info.description)
        print(info.nickName)
        print(info.userID)
        print("The group message recieved here is: \(text)")
        
    }
    
    func onRecvGroupCustomMessage(_ msgID: String!, groupID: String!, sender info: V2TIMGroupMemberInfo!, customData data: Data!) {
        NSLog("onRecvGroupCustomMessage, msgID: \(msgID ), groupID: \(groupID ), sender: \(info ), customData: \(data as NSData)")
    }
    
    // Group member notification, group lifecycle notification, group join request notification, topic event listening callback, etc.
    func onMemberEnter(_ groupID: String, memberList: [V2TIMGroupMemberInfo]) {
        // A member joined the group. All the group members can receive the notification.
        print(groupID)
        print(memberList)
        print("The member list number are \(memberList.count)")
        print(memberList[0].userID)
        groupUserEnter?(groupID, memberList)
    }

    func onMemberLeave(_ groupID: String, member: V2TIMGroupMemberInfo) {
        // A member left the group. All the group members can receive the notification.
        
        print(groupID)
        print(member)
        print(member.description)
        print(member.faceURL)
        print(member.userID)
        print("The meber leavign the group is: \(member.description)")
        groupUserLeave?(groupID, member)
        
    }
    
    func onRecvNewMessage(_ msg: V2TIMMessage) {
        print(msg)
        print(msg.description)
        print(msg.sender)
        var imageURL: String = ""
        
        if msg.elemType == .ELEM_TYPE_IMAGE {
            guard let imageElem = msg.imageElem else {
                return
            }
            
            if let imageList = imageElem.imageList {
                for timImage in imageList {
                    // Your image processing code here
                    let uuid = timImage.uuid
                    let type = timImage.type
                    let size = timImage.size
                    let width = timImage.width
                    let height = timImage.height
                    
                    let imagePath = NSTemporaryDirectory() + "testImage\(uuid)"
                    
                    if !FileManager.default.fileExists(atPath: imagePath) {
                        timImage.downloadImage(imagePath, progress: { curSize, totalSize in
                            // Download progress
                            print("Image download progress: curSize: \(curSize), totalSize: \(totalSize)")
                        }, succ: {
                            // Downloaded successfully
                            print("Image downloaded")
                            if let imageData = FileManager.default.contents(atPath: imagePath),
                               let image = UIImage(data: imageData) {
                                // Call a method to handle the received image
                                let message = Messages()
                                message.id = "msg1"
                                message.sender = msg.sender
                                message.timestamp = Date()
                                message.setUserImage(image: image)
                                
                                
                                self.saveImage(userId: msg.sender, message: message)
                                
                                self.imageSentClosure?(image)
                                let notificationData: [String: String] = ["userid": msg.sender ?? "",
                                                                          "body": "notificationBody" ?? ""]
                                
                                NotificationCenter.default.post(name: Notification.Name("OfflinePushNotification"),
                                                                object: nil,
                                                                userInfo: notificationData)
                            }
                            
                        }, fail: { code, msg in
                            // Download failed
                            print("Failed to download the image: code: \(code), msg: \(msg)")
                        })
                    } else {
                        
                        // The image already exists.
                        if let imageData = FileManager.default.contents(atPath: imagePath),
                           let image = UIImage(data: imageData) {
                            // Display the existing image in the UIImageView
                            let message = Messages()
                            message.id = "msg1"
                            message.sender = msg.sender
                            message.timestamp = Date()
                            message.setUserImage(image: image)
                            
                            
                            self.saveImage(userId: msg.sender, message: message)
                            
                            self.imageSentClosure?(image)
                            let notificationData: [String: String] = ["userid": msg.sender ?? "",
                                                                      "body": "notificationBody" ?? ""]
                            
                            NotificationCenter.default.post(name: Notification.Name("OfflinePushNotification"),
                                                            object: nil,
                                                            userInfo: notificationData)
                            
                        }
                        
                    }
                    
                    print("Image information: uuid: \(uuid), type: \(type.rawValue), size: \(size), width: \(width), height: \(height)")
                    break
                }
            }
        }
            
        if let messageList = msg.textElem {
            
            print("The message we are recieving in the message list is: \(messageList)")
            
            if (msg.offlinePushInfo.desc == "") || (msg.offlinePushInfo.desc == nil) {
                print("Offline push khali hai. ismain kch nahi krna hai.")
                print(messageList)
                
                print(msg.textElem)
                print(msg.description)
                
                if let messageList = msg.textElem {
                    // Accessing values inside msg.textElem using optional chaining
                    if let text = messageList.text {
                        // Use text
                        print(text)
                        let host = type(of: text)
                        print(host)
                        
                        if let jsonData = text.data(using: .utf8) {
                            do {
                                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                    // Access data from the jsonDict
                                    print("The json dictionary is: \(jsonDict)")
                                    
                                    let msgType = jsonDict["type"] as? String
                                    print("Type: \(msgType)")
                                    
                                    if (msgType?.lowercased() == "gift") {
                                        
                                        if let url = URL(string: (jsonDict["message"] as? String) ?? "N/A") {
                                                   downloadImage(from: url) { [weak self] image in
                                                    
                                                       print(image)
                                                      
                                                       let message = Messages()
                                                       message.id = "msg1"
                                                       message.sender = msg.sender
                                                       message.timestamp = Date()
                                                       message.setUserImage(image: image ?? UIImage())
                                                       message.text = "Image"
                                                       
                                                       self?.saveImage(userId: msg.sender, message: message)
                                                       
                                                       self?.imageSentClosure?(image ?? UIImage())
                                                       let notificationData: [String: String] = ["userid": msg.sender ?? "",
                                                                                                 "body": "notificationBody" ?? ""]
                                                       
                                                       NotificationCenter.default.post(name: Notification.Name("OfflinePushNotification"),
                                                                                       object: nil,
                                                                                       userInfo: notificationData)
                                                       
                                                   }
                                               }
                                        
                                        
                                    }
                                    if (msgType?.lowercased() == "text") {
                                        
                                        let userId = msg.sender
                                        let message1 = Messages()
                                        message1.id = "msg1"
                                        message1.text = (jsonDict["message"] as? String) ?? "N/A" //"Pehla wala message"
                                        message1.sender = msg.sender
                                        message1.timestamp = Date()
                                        
                                        saveMessage(userId: msg.sender, message: message1, userName: msg.nickName, userImage: (jsonDict["fromImage"] as? String) ?? "N/A")
                                        increaseCounterForUser(userId: msg.sender ?? "")
                                        
                                        let notificationData: [String: String] = ["userid": msg.sender ?? "",
                                                                                  "body": msg.description ?? ""]
                                        
                                        NotificationCenter.default.post(name: Notification.Name("OfflinePushNotification"),
                                                                        object: nil,
                                                                        userInfo: notificationData)
                                        
                                    } else {
                                        
                                        // Assuming textElem is your V2TIMTextElem object
                                        let notificationData: [String: Any] = jsonDict
                                        NotificationCenter.default.post(name: Notification.Name("BroadTencentMessage"),
                                                                        object: nil,
                                                                        userInfo: notificationData)
                                        
                                        if let gender = jsonDict["gender"] as? String {
                                            print("Gender: \(gender)")
                                        }
                                        // Access other fields similarly
                                    }
                                }
                            } catch {
                                print("Error parsing JSON: \(error.localizedDescription)")
                            }
                        }

                        
                    }
                }
                
//                // Assuming textElem is your V2TIMTextElem object
//                let notificationData: [String: Any] = ["textElem": msg.textElem]
//                NotificationCenter.default.post(name: Notification.Name("BroadTencentMessage"),
//                                                object: nil,
//                                                userInfo: notificationData)

                
                
            } else {
                
            if let offlinePushInfo = msg.offlinePushInfo {
                print("The offline push info is: \(offlinePushInfo)")
                let notificationTitle = offlinePushInfo.title ?? "Default Title"
                let notificationBody = offlinePushInfo.desc ?? ""
                
                print(notificationTitle)
                print(notificationBody)
                
                let userId = msg.sender
                let message1 = Messages()
                message1.id = "msg1"
                message1.text = notificationBody//"Pehla wala message"
                message1.sender = msg.sender
                message1.timestamp = Date()
                //   message1.userName = msg.nickName
                
                if (notificationBody == "") {
                    print("Message ko save nahi krana hai local db main.")
                } else {
                    if let faceURL = msg.faceURL {
                        // Use faceURL safely
                        // For example, you can assign it to another variable or use it within this scope
                        print(faceURL)
                        imageURL = faceURL
                    } else {
                        // Handle the case where faceURL is nil
                        print("faceURL is nil")
                    }
                    
                    // addMessage(forUser: msg.sender, message: message1, userName: msg.nickName, userImage: imageURL)
                    saveMessage(userId: msg.sender, message: message1, userName: msg.nickName, userImage: imageURL)
                    increaseCounterForUser(userId: msg.sender ?? "")
                    
                    let notificationData: [String: String] = ["userid": msg.sender ?? "",
                                                              "body": notificationBody ?? ""]
                    
                    NotificationCenter.default.post(name: Notification.Name("OfflinePushNotification"),
                                                    object: nil,
                                                    userInfo: notificationData)
                }
            }
           }
        }
    }
    
//    func increaseCounterForUser(userId: String) {
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

    
    // Function to get Realm configuration for a specific user
    func realmConfiguration(forUser userId: String) -> Realm.Configuration {
        let fileURL = URL(fileURLWithPath: "\(userId)_realm.realm") // Unique file URL for each user
        let config = Realm.Configuration(fileURL: fileURL)
        return config
    }

    // Function to add a message to a user's details
    func addMessage(forUser userId: String, message: Messages, userName: String, userImage: String) {
        // Open Realm with configuration for the specific user
        let realmConfig = realmConfiguration(forUser: userId)
        do {
            let realm = try Realm(configuration: realmConfig)
            let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)

            if userDetails.isEmpty {
                // User details not found, create new details entry
                let newUserDetail = userDataDetail()
                newUserDetail.userId = userId
                newUserDetail.userName = userName
                newUserDetail.profilePhoto = userImage
                newUserDetail.messages.append(message)
                try realm.write {
                    realm.add(newUserDetail)
                }
            } else {
                // User details found, add message to existing entry
                try realm.write {
                    for userDetail in userDetails {
                        userDetail.messages.append(message)
                    }
                }
            }
        } catch let error as NSError {
            print("Error accessing Realm: \(error.localizedDescription)")
        }
    }
    
    func saveMessage(userId: String, message: Messages, userName:String, userImage:String) {
        
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
                    newUserDetail.profilePhoto = userImage
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
    
}



