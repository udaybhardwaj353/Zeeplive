//
//  GetMalePointsData.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/23.
//

import Foundation

struct MalePoints: Codable {
    var success: Bool?
    var result: maleResult?
    var weeklyEarningBeansData: maleWeeklyEarningBeansData?
    var maleBalance: MaleBalance?
    var error: String?
}

// MARK: - MaleBalance
struct MaleBalance: Codable {
    var earningRedeemPoint, earningPoints, purchaseRedeemPoint, purchasePoints: Int?

    enum CodingKeys: String, CodingKey {
        case earningRedeemPoint = "earning_redeem_point"
        case earningPoints = "earning_points"
        case purchaseRedeemPoint = "purchase_redeem_point"
        case purchasePoints = "purchase_points"
    }
}

// MARK: - Result
struct maleResult: Codable {
    var totalPoint, redemablePoints: Int?
    var totalPointsTillNow: String?

    enum CodingKeys: String, CodingKey {
        case totalPoint = "total_point"
        case redemablePoints
        case totalPointsTillNow = "total_points_till_now"
    }
}

// MARK: - WeeklyEarningBeansData
struct maleWeeklyEarningBeansData: Codable {
    var weeklyEarningBeans: Int?

    enum CodingKeys: String, CodingKey {
        case weeklyEarningBeans = "weekly_earning_beans"
    }
}
