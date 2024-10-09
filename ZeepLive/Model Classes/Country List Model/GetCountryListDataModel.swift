//
//  GetCountryListDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 30/08/23.
//

import Foundation

struct getCountryList: Codable {
    var success: Bool?
    var result: getCountryListResult?
    var error: String?
}

// MARK: - Result
struct getCountryListResult: Codable {
    var currentPage: Int?
    var data: [getCountryListData]?
    var firstPageURL: String?
    var from: Int?
    var nextPageURL, path: String?
    var perPage: Int?
    var prevPageURL: String?
    var to: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
    }
}

// MARK: - Datum
struct getCountryListData: Codable {
    var id: Int?
    var countryName: String?
    var flag: String?
    var countryCode: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryName = "country_name"
        case flag
        case countryCode = "country_code"
    }
}
