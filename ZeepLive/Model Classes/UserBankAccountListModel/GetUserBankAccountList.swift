//
//  GetUserBankAccountList.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/03/24.
//

import Foundation

// MARK: - UserAccountList
struct userAccountList: Codable {
    var success: Bool?
    var result: [userAccountResult]?
    var error: String?
}

// MARK: - Result
struct userAccountResult: Codable {
    var id, userID, mobile: Int?
    var accountNumber, bankName, ifscCode, accountName: String?
    var countryID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case mobile
        case accountNumber = "account_number"
        case bankName = "bank_name"
        case ifscCode = "ifsc_code"
        case accountName = "account_name"
        case countryID = "country_id"
    }
}

struct userAccountEPayResult: Codable {
    var id, userID, mobile: Int?
    var email, accountName: String?
    var countryID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case mobile, email
        case accountName = "account_name"
        case countryID = "country_id"
    }
}

