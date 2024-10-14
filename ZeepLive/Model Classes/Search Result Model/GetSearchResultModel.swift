//
//  GetSearchResultModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 23/04/24.
//

import Foundation

struct Search: Codable {
    var success: Bool?
    var result: searchResult?
    var error: String?
}

// MARK: - Result
struct searchResult: Codable {
    var currentPage: Int?
    var data: [searchResultData]?
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
struct searchResultData: Codable {
    var id: Int?
    var name: String?
    var profileID: Int?
    var gender: String?
    var dob: String?
    var level, charmLevel, richLevel: Int?
    var profileImages: [searchProfileImage]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case profileID = "profile_id"
        case gender, dob, level
        case charmLevel = "charm_level"
        case richLevel = "rich_level"
        case profileImages = "profile_images"
    }
}

// MARK: - ProfileImage
struct searchProfileImage: Codable {
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
