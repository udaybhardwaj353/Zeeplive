//
//  GetBankListModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/03/24.
//

import Foundation

struct BankList: Codable {
    var success: Bool?
    var result: bankListResult?
    var error: String?
}

// MARK: - Result
struct bankListResult: Codable {
    var currentPage: Int?
    var data: [bankListData]?
    var firstPageURL: String?
    var from: Int?
    var nextPageURL: String?
    var path: String?
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
struct bankListData: Codable {
    var id: Int?
    var bankName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case bankName = "bank_name"
    }
}
