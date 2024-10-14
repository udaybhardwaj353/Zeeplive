//
//  GetFemalePointsData.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/23.
//

import Foundation

struct FemalePoints: Codable {
    var success: Bool?
    var result: femaleResult?
    var weeklyEarningBeansData: femaleWeeklyEarningBeansData?
    var femaleBalance: FemaleBalance?
    var error: String?
}

// MARK: - FemaleBalance
struct FemaleBalance: Codable {
    var redeemPoint, points, purchaseRedeemPoint, purchasePoints: Int?

    enum CodingKeys: String, CodingKey {
        case redeemPoint = "redeem_point"
        case points
        case purchaseRedeemPoint = "purchase_redeem_point"
        case purchasePoints = "purchase_points"
    }
}

// MARK: - Result
struct femaleResult: Codable {
    var totalPoint, redemablePoints: String?

    enum CodingKeys: String, CodingKey {
        case totalPoint = "total_point"
        case redemablePoints
    }
}

// MARK: - WeeklyEarningBeansData
struct femaleWeeklyEarningBeansData: Codable {
    var weeklyEarningBeans: Int?

    enum CodingKeys: String, CodingKey {
        case weeklyEarningBeans = "weekly_earning_beans"
    }
}
