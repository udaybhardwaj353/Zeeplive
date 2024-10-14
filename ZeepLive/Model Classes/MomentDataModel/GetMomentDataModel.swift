//
//  GetMomentDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/01/24.
//

import Foundation


struct userMomentData: Codable {
    var success: Bool?
    var result: MomentResult?
    var isHeartsGlobalByYou: Bool?
    var error: String?

    enum CodingKeys: String, CodingKey {
        case success, result
        case isHeartsGlobalByYou = "is_hearts_global_by_you"
        case error
    }
}

// MARK: - Result
struct MomentResult: Codable {
    var currentPage: Int?
    var data: [momentDatum]?
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
struct momentDatum: Codable {
    var id, userID, profileID, giftType: Int?
    var name: String?
    var profilePic: String?
    var type: String?
    var message: String?
    var giftURL, giftSound: String?
    var giftAmount: Int?
    var giftImgType, giftImg, senderName: String?
    var senderPic: String?
    var giftCount, senderUserLevel, senderID: Int?
    var senderGender: String?
    var updatedAt: String?
    var favoriteCount, favoriteByYouCount, likesCount, likesByYouCount: Int?
    var commentsCount, heartsCount, heartsByYouCount: Int?
    var userData: UserData?
    var momentImages: [MomentImageElement]?
    var momentVideo: [MomentVideo]?
    var isMomentLiked: Bool = false
    var isGiftSend: Bool = false
    var isFollowed: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case profileID = "profile_id"
        case name
        case profilePic = "profile_pic"
        case type, message
        case giftType = "gift_type"
        case giftURL = "gift_url"
        case giftSound = "gift_sound"
        case giftAmount = "gift_amount"
        case giftImgType = "gift_img_type"
        case giftImg = "gift_img"
        case senderName = "sender_name"
        case senderID = "sender_id"
        case senderPic = "sender_pic"
        case giftCount = "gift_count"
        case senderUserLevel = "sender_userLevel"
        case senderGender = "sender_gender"
        case updatedAt = "updated_at"
        case favoriteCount = "favorite_count"
        case favoriteByYouCount = "favorite_by_you_count"
        case likesCount = "likes_count"
        case likesByYouCount = "likes_by_you_count"
        case commentsCount = "comments_count"
        case heartsCount = "hearts_count"
        case heartsByYouCount = "hearts_by_you_count"
        case userData = "user_data"
        case momentImages = "moment_images"
        case momentVideo = "moment_video"
        
    }
}

// MARK: - MomentImageElement
struct MomentImageElement: Codable {
    var id, momentID: Int?
    var imageName: String?
    var imageType: String?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case momentID = "moment_id"
        case imageName = "image_name"
        case imageType = "image_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct MomentVideo: Codable {
    var id, momentID: Int?
    var videoName: String?
    var videoExtension: String?
    var videoURL: String?
    var createdAt, updatedAt: String?
    var videoThumbnail: String?

    enum CodingKeys: String, CodingKey {
        case id
        case momentID = "moment_id"
        case videoName = "video_name"
        case videoExtension = "video_extension"
        case videoURL = "video_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case videoThumbnail = "Video_thumbnail"
    }
}

// MARK: - UserData
struct UserData: Codable {
    var id, profileID: Int?
    var name: String?
    var profileImages: [momentProfileImage]?

    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case name
        case profileImages = "profile_images"
    }
}

// MARK: - ProfileImage
struct momentProfileImage: Codable {
    var id, userID: Int?
    var imageName: String?
    var isProfileImage: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageName = "image_name"
        case isProfileImage = "is_profile_image"
    }
}
