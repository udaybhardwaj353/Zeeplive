//
//  GetPKGiftModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/02/24.
//

import Foundation

struct pkUsersGiftModel: Codable {
    
    var totalGift: Int?
    var type: Int?
    var userID: Int?
    var userImage: String?
    var userName: String?
   
    func toDictionary() -> [String: Any] {
         return [
             "totalGift": totalGift,
             "type": type,
             "userID": userID,
             "userImage": userImage,
             "userName": userName
         ]
     }
    
}
