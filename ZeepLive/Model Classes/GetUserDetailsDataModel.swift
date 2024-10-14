//
//  GetUserDetailsDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/06/23.
//

import Foundation

struct UserDetails: Codable {
    var success: userDetailsData?
}

// MARK: - Success
struct userDetailsData: Codable {
    var id, profileID: Int?
    var name: String?
    var firebaseStatus, aboutUser: String?
    var isOnline: Int?
    var dob: String?
    var city: String?
    var callRate: Int?
    var email: String?
    var mobile: Any?
    var username, loginType: String?
    var level, charmLevel, richLevel: Int?
    var gender: String?
    var myFollowCount, favoriteCount, friendCount, freeTargetStar: Int?
    var profileImages: [userProfileImage]?
    var inReviewProfileImages: Bool?
    var newCallRate: Float?
    var countryID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case name
        case firebaseStatus = "firebase_status"
        case aboutUser = "about_user"
        case isOnline = "is_online"
        case dob, city
        case callRate = "call_rate"
        case email, username
        case loginType = "login_type"
        case level
        case charmLevel = "charm_level"
        case richLevel = "rich_level"
        case gender
        case myFollowCount = "my_follow_count"
        case favoriteCount = "favorite_count"
        case friendCount = "friend_count"
        case freeTargetStar = "free_target_star"
        case profileImages = "profile_images"
        case inReviewProfileImages = "in_review_profile_images"
        case newCallRate = "new_call_rate"
        case countryID = "country_id"
        
    }
    
}

// MARK: - ProfileImage
struct userProfileImage: Codable {
    var id, userID: Int?
    var imageName: String?
    var isProfileImage: Int?
    var imageType, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageName = "image_name"
        case isProfileImage = "is_profile_image"
        case imageType = "image_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}
