//
//  RealmModelClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/01/24.
//

import Foundation
import RealmSwift


class mainDetail: Object {
    
    @objc dynamic var mainID: String = ""
    
}

class userDataDetail: Object {

@objc dynamic var userMainID: String = ""
@objc dynamic var userId: String = ""
@objc dynamic var profileId: String = ""
@objc dynamic var profilePhoto: String = ""
@objc dynamic var recentChat: String = ""
@objc dynamic var counter: String = "0"
@objc dynamic var userName: String = ""

let messages = List<Messages>()
//var lastMessage = LinkingObjects(fromType: Messages.self, property: "sender").sorted(byKeyPath: "timestamp", ascending: false).first
    var lastMessage: Messages? {
            return messages.sorted(byKeyPath: "timestamp", ascending: false).first
        }
    
}

class Messages: Object {
   
    @objc dynamic var id: String = ""
    @objc var text: String = ""
    @objc var sender: String = ""
    @objc var timestamp: Date = Date()
    @objc dynamic var userImage: Data? = nil
  //  @objc dynamic var userName: String = ""
    
    func setUserImage(image: UIImage) {
           if let imageData = image.pngData() {
               userImage = imageData
           }
       }
    
}
