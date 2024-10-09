//
//  GetUserFollowersListData.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/23.
//

import Foundation

struct userFollowersList: Codable {
    var success: Bool?
    var result: userFollowersListResult?
    var error: String?
}

// MARK: - Result
struct userFollowersListResult: Codable {
    var currentPage: Int?
    var data: [userFollowersListData]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL, nextPageURL, path: String?
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
struct userFollowersListData: Codable {
    var id, followerID, followingID: Int?
    var userDataFollower: UserDataFollower?

    enum CodingKeys: String, CodingKey {
        case id
        case followerID = "follower_id"
        case followingID = "following_id"
        case userDataFollower = "user_data_follower"
    }
}

// MARK: - UserDataFollower
struct UserDataFollower: Codable {
    var id, profileID: Int?
    var name: String?
    var level: Int?
    var gender: Gender?
    var dob: String?
    var favoriteByYouCount: Int?
    var profileImages: [ProfileImage]?
    var isFollower: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case name, level, gender, dob
        case favoriteByYouCount = "favorite_by_you_count"
        case profileImages = "profile_images"
    }
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    var id, userID: Int?
    var imageName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageName = "image_name"
    }
}
