//
//  GetLiveMessageModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 17/01/24.
//

import Foundation

struct liveMessageModel: Codable {
    
    var emoji:Int?
    var emojiName:String?
    var gender: String?
    var level: String?
    var message: String?
    var ownHost: Bool?
    var type: String?
    var userID:String?
    var userImage:String?
    var userName: String?
    var giftCount: Int?
    var sendGiftName:String?
    var sendGiftTo:String?
    
//    init(dictionary: [String: Any]) {
//         emoji = dictionary["emoji"] as? Int
//         emojiName = dictionary["emojiName"] as? String
//         gender = dictionary["gender"] as? String
//         level = dictionary["level"] as? String
//         message = dictionary["message"] as? String
//         ownHost = dictionary["ownHost"] as? Bool
//         type = dictionary["type"] as? String
//         userID = dictionary["user_id"] as? String
//         userImage = dictionary["user_image"] as? String
//         userName = dictionary["user_name"] as? String
//     }
    
}

