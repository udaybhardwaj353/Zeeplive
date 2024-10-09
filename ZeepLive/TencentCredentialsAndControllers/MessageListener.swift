//
//  MessageListener.swift
//  TencantOneToOneChat
//
//  Created by Creative Frenzy on 09/08/23.
//

import Foundation
import ImSDK_Plus
import UIKit
import RealmSwift

//class MessageListener: NSObject, V2TIMSimpleMsgListener {
//
//    func onRecvC2CTextMessage(_ msgID: String!, sender info: V2TIMUserInfo!, text: String!) {
//        // Handle received one-to-one text message
//        print("Received C2C text message from \(info.nickName ?? info.userID): \(text ?? "")")
//    }
//
//    func onRecvC2CCustomMessage(_ msgID: String!, sender info: V2TIMUserInfo!, customData data: Data!) {
//        // Handle received one-to-one custom message
//        print("Received C2C custom message from \(info.nickName ?? info.userID)")
//        // Handle the custom data
//    }
//
//    // Implement other methods as needed...
//}

class MessageListener: NSObject, V2TIMSimpleMsgListener, V2TIMAdvancedMsgListener {
    var c2cTextMessageHandler: ((String, V2TIMUserInfo, String) -> Void)?
    var c2cCustomMessageHandler: ((String, V2TIMUserInfo, Data) -> Void)?
    var imageSentClosure: ((UIImage) -> Void)?
    var offlinePushInfoHandler: ((String, String) -> Void)?
    let realm = try! Realm()
    
    func onRecvC2CTextMessage(_ msgID: String!, sender info: V2TIMUserInfo!, text: String!) {
        c2cTextMessageHandler?(msgID, info, text)
    }
    
    func onRecvC2CCustomMessage(_ msgID: String!, sender info: V2TIMUserInfo!, customData data: Data!) {
        c2cCustomMessageHandler?(msgID, info, data)
    }
    
    func onRecvNewMessage(_ msg: V2TIMMessage) {
        print(msg)
        print(msg.description)
        print(msg.sender)
        
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
            
            if let offlinePushInfo = msg.offlinePushInfo {
                let notificationTitle = offlinePushInfo.title ?? "Default Title"
                let notificationBody = offlinePushInfo.desc ?? "Default Body"
                
                print(notificationTitle)
                print(notificationBody)
                
                let userId = msg.sender
                let message1 = Messages()
                message1.id = "msg1"
                message1.text = notificationBody//"Pehla wala message"
                message1.sender = msg.sender
                message1.timestamp = Date()
                
                saveMessage(userId: msg.sender, message: message1)
                increaseCounterForUser(userId: msg.sender ?? "")
                
                let notificationData: [String: String] = ["userid": msg.sender ?? "",
                                                          "body": notificationBody ?? ""]
                
                NotificationCenter.default.post(name: Notification.Name("OfflinePushNotification"),
                                                object: nil,
                                                userInfo: notificationData)
                
            }
        }
        
    }
    
    func increaseCounterForUser(userId: String) {
        let users = realm.objects(userDataDetail.self).filter("userId == %@", userId)
        
        try! realm.write {
            for user in users {
                user.counter = String((Int(user.counter) ?? 0) + 1)
                print("jab user counter badhega tab yhn pr \(user.counter)")
                print("jab user counter badhega tab uski id hai \(userId)")
            }
        }
    }
    
    func saveMessage(userId: String, message: Messages) {
        let userDetails = realm.objects(userDataDetail.self).filter("userId == %@", userId)
        
        if userDetails.isEmpty {
            do {
                try realm.write {
                    let newUserDetail = userDataDetail()
                    newUserDetail.userId = userId
                    newUserDetail.messages.append(message)
                    //   newUserDetail.lastMessage = message  // Update lastMessage property
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
    
    func saveImage(userId:String, message: Messages) {
        
        
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
    
}


