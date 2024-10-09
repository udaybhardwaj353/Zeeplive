//
//  GetDailyWeeklyDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/01/24.
//

import Foundation

struct DailyWeekly: Codable {
    var success: Bool?
    var result: [dailyWeeklyResult]?
    var error: String?
}

// MARK: - Result
struct dailyWeeklyResult: Codable {
    var id, profileID: Int?
    var name: String?
    var charmLevel, dailyEarningBeans, weeklyEarningBeans: Int?
    var gender: String?
    var profileImages: [dailyWeeklyProfileImage]?

    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case name
        case charmLevel = "charm_level"
        case dailyEarningBeans = "daily_earning_beans"
        case gender
        case profileImages = "profile_images"
        case weeklyEarningBeans = "weekly_earning_beans"
    }
}

// MARK: - ProfileImage
struct dailyWeeklyProfileImage: Codable {
    var id, userID: Int?
    var imageName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageName = "image_name"
    }
}
