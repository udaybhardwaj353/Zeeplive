//
//  GetLiveHostListForPK.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/24.
//

import Foundation

// MARK: - Welcome
struct liveHostList: Codable {
    var success: Bool?
    var result: liveHostListResult?
    var error: String?
}

// MARK: - Result
struct liveHostListResult: Codable {
    var currentPage: Int?
    var data: [liveHostListData]?
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
struct liveHostListData: Codable {
    var id, profileID: Int?
    var name: String?
    var profileImage: String?
    var city: String?
    var level, broadstatus: Int?
    var broadChannelName, groupID: String?
    var callRate, isOnline: Int?
    var dob: String?
    var isBusy: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case name
        case profileImage = "profile_image"
        case city, level, broadstatus
        case broadChannelName = "broad_channel_name"
        case groupID = "group_id"
        case callRate = "call_rate"
        case isOnline = "is_online"
        case dob
        case isBusy = "is_busy"
    }
}

