//
//  GetDataToShowInMyEarning.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 19/03/24.
//

import Foundation

struct WalletHistoryIncomeReportForMyEarning: Codable {
   
    var success: Bool?
    var result: walletHistoryForMyEarningResult?
    var countryData: CountryData?
    var payoutFeesEnabledStatus: PayoutFeesEnabledStatus?
    var payoutFees: PayoutFees?
    var error: String?

    enum CodingKeys: String, CodingKey {
        case success, result
        case countryData = "country_data"
        case payoutFeesEnabledStatus, payoutFees, error
    }
}

// MARK: - CountryData
struct CountryData: Codable {
    var countryID, id: Int?
    var countryDetails: CountryDetails?

    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case id
        case countryDetails = "country_details"
    }
}

// MARK: - CountryDetails
struct CountryDetails: Codable {
    var id: Int?
    var countryName: String?
    var flag: String?
    var countryCode: String?
    var countryPayoutMethods: [CountryPayoutMethod]?

    enum CodingKeys: String, CodingKey {
        case id
        case countryName = "country_name"
        case flag
        case countryCode = "country_code"
        case countryPayoutMethods = "country_payout_methods"
    }
}

// MARK: - CountryPayoutMethod
struct CountryPayoutMethod: Codable {
    var id, countryID, payoutMethodID, status: Int?
    var paymentMethod: PaymentMethod?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case payoutMethodID = "payout_method_id"
        case status
        case paymentMethod = "payment_method"
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    var id: Int?
    var name: String?
    var status: Int?
}

// MARK: - PayoutFees
struct PayoutFees: Codable {
    var payoutFee: Int?

    enum CodingKeys: String, CodingKey {
        case payoutFee = "payout_fee"
    }
}

// MARK: - PayoutFeesEnabledStatus
struct PayoutFeesEnabledStatus: Codable {
    var settingKey, settingValue: String?

    enum CodingKeys: String, CodingKey {
        case settingKey = "setting_key"
        case settingValue = "setting_value"
    }
}

// MARK: - Result
struct walletHistoryForMyEarningResult: Codable {
    var userID, points, redeemPoint: Int?
    var amountInr, amountDollor: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case points
        case redeemPoint = "redeem_point"
        case amountInr = "amount_inr"
        case amountDollor = "amount_dollor"
    }
}
