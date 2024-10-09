//
//  GetUserFriendsListData.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/23.
//

import Foundation

struct userFriendList: Codable {
    var success: Bool?
    var result: userFriendListResult?
    var error: String?
}

// MARK: - Result
struct userFriendListResult: Codable {
    var currentPage: Int?
    var data: [userFriendListData]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL: String?
    var nextPageURL: String?
    var path: String?
    var perPage: Int?
    var prevPageURL: String?
    var to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct userFriendListData: Codable {
    var id, followerID, followingID: Int?
    var userDataFollower: UserFriendListDataFollower?

    enum CodingKeys: String, CodingKey {
        case id
        case followerID = "follower_id"
        case followingID = "following_id"
        case userDataFollower = "user_data_follower"
    }
}

// MARK: - UserDataFollower
struct UserFriendListDataFollower: Codable {
    var id, profileID: Int?
    var name: String?
    var level: Int?
    var gender, dob: String?
    var profileImages: [userFriendProfileImage]?
    var isFriend: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case name, level, gender, dob
        case profileImages = "profile_images"
    }
}

// MARK: - ProfileImage
struct userFriendProfileImage: Codable {
    var id, userID: Int?
    var imageName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageName = "image_name"
    }
}
