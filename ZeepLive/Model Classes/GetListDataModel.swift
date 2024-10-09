//
//  GetListDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/05/23.
//

import Foundation


struct Listing: Codable {
    var success: Bool?
    var result: ListResult?
    var error: String?
}

// MARK: - Result
struct ListResult: Codable {
    var currentPage: Int? {
        didSet {
            ListResultManager.shared.listResult = self
        }
    }
    var data: [ListData]? {
        didSet {
            ListResultManager.shared.listResult = self
        }
    }
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

// MARK: - ListData
struct ListData: Codable {
    var id: Int?
    var name: String?
    var profileID, callRate, isOnline: Int?
    var dob: String?
    var isBusy: Int?
    var city: String?
    var level: Int?
    var profileImage: String?
    var broadstatus: Int?
    var broadChannelName: String?
    var userStatus: String?
    var newCallRate: Float?
    var groupID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profileID = "profile_id"
        case callRate = "call_rate"
        case isOnline = "is_online"
        case dob
        case isBusy = "is_busy"
        case city, level
        case profileImage = "profile_image"
        case broadstatus
        case broadChannelName = "broad_channel_name"
        case groupID = "group_id"
        case newCallRate = "new_call_rate"
    }
}

// MARK: - ListResultManager
class ListResultManager {
    static let shared = ListResultManager()
    var listResult: ListResult? {
        didSet {
            // Perform any additional actions when the listResult is updated
            print("ListResult has been updated")
        }
    }

    private init() {}
}
