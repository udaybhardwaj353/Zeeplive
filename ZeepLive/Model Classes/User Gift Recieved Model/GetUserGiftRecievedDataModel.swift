//
//  GetUserGiftRecievedDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 07/07/23.
//

import Foundation

struct getUserGiftRecieved: Codable {
    var success: Bool?
    var result: [giftRecievedResult]?
    var rating: [Rating]?
    var error: String?
}

// MARK: - Rating
struct Rating: Codable {
    var countTag: Int?
    var rate, tag: String?

    enum CodingKeys: String, CodingKey {
        case countTag = "count_tag"
        case rate, tag
    }
}

// MARK: - Result
struct giftRecievedResult: Codable {
    var total, giftID, status, credit: Int?
    var transactionDES: String?
    var giftDetails: GiftDetails?

    enum CodingKeys: String, CodingKey {
        case total
        case giftID = "gift_id"
        case status, credit
        case transactionDES = "transaction_des"
        case giftDetails = "gift_details"
    }
}

// MARK: - GiftDetails
struct GiftDetails: Codable {
    var id: Int?
    var image: String?
    var amount: Int?
}
