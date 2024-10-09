//
//  BlockUsersListModelClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 02/04/24.
//

import Foundation
import RealmSwift


class userBlockList: Object {

@objc dynamic var userId: String = ""
@objc dynamic var profileId: String = ""
@objc dynamic var userName: String = ""
@objc dynamic var isBlocked: Bool = false
@objc dynamic var userBlockSelfId: String = ""
    
}

