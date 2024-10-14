//
//  GetUserProfileDetailsModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 06/07/23.
//

import Foundation

struct getUserProfileDetails: Codable {
    var success: Bool?
    var result: [userProfileDetailsResult]?
    var error: String?
}

// MARK: - Result
struct userProfileDetailsResult: Codable {
    var ratingsAverage: String?
    var id: Int?
    var name: String?
    var profileID, callRate, audioCallRate, isOnline: Int?
    var dob: String?
    var isBusy: Int?
    var city, gender: String?
    var level, charmLevel, richLevel, followerCount: Int?
    var followingCount, friendCount, favoriteCount, favoriteByYouCount: Int?
    var usergiftByYouCount: Int?
    var femaleImages: [FemaleImage]?
  //  var femaleVideo, femaleWallet: [JSONAny]?
    var getBroadCastAvailable: GetBroadCastAvailable?
    var getRatingTag: [GetRatingTag]?

    enum CodingKeys: String, CodingKey {
        case ratingsAverage = "ratings_average"
        case id, name
        case profileID = "profile_id"
        case callRate = "call_rate"
        case audioCallRate = "audio_call_rate"
        case isOnline = "is_online"
        case dob
        case isBusy = "is_busy"
        case city, gender, level
        case charmLevel = "charm_level"
        case richLevel = "rich_level"
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case friendCount = "friend_count"
        case favoriteCount = "favorite_count"
        case favoriteByYouCount = "favorite_by_you_count"
        case usergiftByYouCount = "usergift_by_you_count"
        case femaleImages = "female_images"
     //   case femaleVideo = "female_video"
     //   case femaleWallet = "female_wallet"
        case getBroadCastAvailable = "get_broad_cast_available"
        case getRatingTag = "get_rating_tag"
    }
}

// MARK: - GetRatingTag
struct GetRatingTag: Codable {
    var id, hostID: Int?
    var tag: String?
    var totalCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case hostID = "host_id"
        case tag, totalCount
    }
}

// MARK: - FemaleImage
struct FemaleImage: Codable {
    var userID, isProfileImage: Int?
    var imageName: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case isProfileImage = "is_profile_image"
        case imageName = "image_name"
    }
}

// MARK: - GetBroadCastAvailable
struct GetBroadCastAvailable: Codable {
    var id, userID: Int?
    var uniqueToken, token: String?
    var isHost: Int?
    var uniqueID, channelName: String?
    var status: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case uniqueToken = "unique_token"
        case token
        case isHost = "is_host"
        case uniqueID = "unique_id"
        case channelName = "channel_name"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
