//
//  GetMomentListDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/01/24.
//

import Foundation

struct momentComment: Codable {
    var success: Bool?
    var result: momentCommentResult?
    var error: String?
}

// MARK: - Result
struct momentCommentResult: Codable {
    var currentPage: Int?
    var data: [commentDatum]?
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
struct commentDatum: Codable {
    var id, momentID, userID, profileID: Int?
    var name: String?
    var profilePic: String?
    var message, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case momentID = "moment_id"
        case userID = "user_id"
        case profileID = "profile_id"
        case name
        case profilePic = "profile_pic"
        case message
        case createdAt = "created_at"
    }
}
