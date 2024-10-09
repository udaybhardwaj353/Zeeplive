//
//  GetFemaleIncomeDetailsModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 22/06/23.
//

import Foundation

struct femaleIncomeDetails: Codable {
    var success: Bool?
    var result: femaleIncomeDetailsResult?
    var error: String?
}

// MARK: - Result
struct femaleIncomeDetailsResult: Codable {
    var currentPage: Int?
    var walletHistory: [femaleIncomeWalletHistory]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL, nextPageURL, path: String?
    var perPage: Int?
    var prevPageURL: String?
    var to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case walletHistory = "wallet_history"
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

// MARK: - WalletHistory
struct femaleIncomeWalletHistory: Codable {
    var id, userID, credit: Int?
    var updatedAt: String?
    var status: Int?
    var razorpayID, transactionDES: String?
    var callerProfileID: Int?
  //  let callerUsername: CallerUsername
    var callerUsername: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case credit
        case updatedAt = "updated_at"
        case status
        case razorpayID = "razorpay_id"
        case transactionDES = "transaction_des"
        case callerProfileID = "caller_profile_id"
        case callerUsername = "caller_username"
    }
}

//enum CallerUsername: String, Codable {
//    case king = "\u{1f451} KING \u{1f451}"
//    case user935940304 = "User935940304"
//}
