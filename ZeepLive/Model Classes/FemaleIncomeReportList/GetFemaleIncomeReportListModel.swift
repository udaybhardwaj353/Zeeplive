//
//  GetFemaleIncomeReportListModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 22/06/23.
//

import Foundation

struct femaleIncomeReport: Codable {
    var success: Bool?
    var result: femaleIncomeReportResult?
    var error: String?
}

// MARK: - Result
struct femaleIncomeReportResult: Codable {
    var weeks: [femaleIncomeReportWeek]?
    var footerData: [femaleIncomeFooterData]?

    enum CodingKeys: String, CodingKey {
        case weeks
        case footerData = "footer_data"
    }
}

// MARK: - FooterDatum
struct femaleIncomeFooterData: Codable {
    var date, totalCoins, totalCallCoins, totalGiftCoins: String?
    var totalRewardCoins: String?

    enum CodingKeys: String, CodingKey {
        case date
        case totalCoins = "total_coins"
        case totalCallCoins = "total_call_coins"
        case totalGiftCoins = "total_gift_coins"
        case totalRewardCoins = "total_reward_coins"
    }
}

// MARK: - Week
struct femaleIncomeReportWeek: Codable {
    var updatedAt, totalCoins, totalCallCoins, totalGiftCoins: String?
    var totalRewardCoins, totalPayout, payoutDollar, settlementCycle: String?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case totalCoins = "total_coins"
        case totalCallCoins = "total_call_coins"
        case totalGiftCoins = "total_gift_coins"
        case totalRewardCoins = "total_reward_coins"
        case totalPayout = "total_payout"
        case payoutDollar = "payout_dollar"
        case settlementCycle = "settlement_cycle"
    }
}
