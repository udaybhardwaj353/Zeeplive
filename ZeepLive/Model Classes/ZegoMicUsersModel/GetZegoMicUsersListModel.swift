//
//  GetZegoMicUsersListModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/02/24.
//

import Foundation

struct getZegoMicUserListModel: Codable, Hashable {
    
    var coHostLevel: String?
    var coHostUserImage: String?
    var coHostUserName: String?
    var isHostMuted: Bool?
    var coHostUserStatus: String?
    var coHostAudioStatus: String?
    var coHostID: String?
   
}

struct getCoHostInviteUsersDetail: Codable {
    
    var userID: String?
    var userName: String?
    var userImage: String?
    var time: String?
    
}
