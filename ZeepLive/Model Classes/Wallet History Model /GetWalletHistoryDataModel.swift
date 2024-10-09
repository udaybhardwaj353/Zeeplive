//
//  GetWalletHistoryDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 23/06/23.
//

import Foundation

struct getWalletHistory: Codable {
    var success: Bool?
    var result: walletHistoryResult?
    var error: String?
}

// MARK: - Result
struct walletHistoryResult: Codable {
    var lastPage: Int?
    var currentPage:String?
    var nextPageAvailable: Bool?
    var walletHistory: [WalletHistory]?
    var walletBalance: WalletBalance?

    enum CodingKeys: String, CodingKey {
        case lastPage = "last_page"
        case currentPage = "current_page"
        case nextPageAvailable = "next_page_available"
        case walletHistory, walletBalance
    }
}

// MARK: - WalletBalance
struct WalletBalance: Codable {
    var totalPoint, redemablePoints: String?

    enum CodingKeys: String, CodingKey {
        case totalPoint = "total_point"
        case redemablePoints
    }
}

// MARK: - WalletHistory
struct WalletHistory: Codable {
    var id, credit, debit: Int?
    var createdAt: String?
    var status: Int?
    var day: String?
    var razorpayID: String?
    var storeplanID,storeplanValidity: Int?
    var callReceiverID, rechargeAmount: Int?
    var transactionDES: String?

    enum CodingKeys: String, CodingKey {
        case id, credit, debit
        case createdAt = "created_at"
        case status, day
        case razorpayID = "razorpay_id"
        case storeplanID = "storeplan_id"
        case storeplanValidity = "storeplan_validity"
        case callReceiverID = "call_receiver_id"
        case rechargeAmount = "recharge_amount"
        case transactionDES = "transaction_des"
    }
}
