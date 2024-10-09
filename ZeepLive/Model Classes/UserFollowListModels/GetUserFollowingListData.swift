//
//  GetUserFollowingListData.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/23.
//

import Foundation

struct userFollowingList: Codable {
    var success: Bool?
    var result: userFollowingListResult?
    var error: String?
}

// MARK: - Result
struct userFollowingListResult: Codable {
    var currentPage: Int?
    var data: [userFollowingData]?
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
struct userFollowingData: Codable {
    var id, followerID, followingID: Int?
    var followingData: FollowingData?

    enum CodingKeys: String, CodingKey {
        case id
        case followerID = "follower_id"
        case followingID = "following_id"
        case followingData = "following_data"
    }
}

// MARK: - FollowingData
struct FollowingData: Codable {
    var id, profileID: Int?
    var name: String?
    var level: Int?
    var gender, dob: String?
    var profileImages: [FollowingListProfileImage]?
    var isFollowing: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case name, level, gender, dob
        case profileImages = "profile_images"
    }
}

// MARK: - ProfileImage
struct FollowingListProfileImage: Codable {
    var id, userID: Int?
    var imageName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageName = "image_name"
    }
}
