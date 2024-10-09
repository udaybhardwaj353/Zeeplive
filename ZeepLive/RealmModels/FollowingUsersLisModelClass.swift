//
//  FollowingUsersLisModelClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/04/24.
//

import Foundation
import RealmSwift

class userFollowList: Object {

@objc dynamic var userId: String = ""
@objc dynamic var profileId: String = ""
@objc dynamic var userSelfId: String = ""
    
}

