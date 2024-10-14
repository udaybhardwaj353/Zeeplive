//
//  FreeTargetModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 18/06/24.
//

import Foundation

struct FreeTargetData: Codable {
    let success: Bool?
    let result: FreeTargetResult?
    let error: String?
}

struct FreeTargetResult: Codable {
    let userId: Int?
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: Int?
    let totalHours: Int?
    let talent: String?
    let totalStars: Int?
    let earningPerWeek: Int?
    let perDayRemainingTime, perDayCompleteTime, perDayTotalTime: Int?
    let currentDay: String?
    let lastweekdetails: [LastWeekDetail]?

    
}

struct LastWeekDetail: Codable {
    let userId: Int?
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: Int?
    let totalHours: Int?
    let talent: String?
    let totalStars: Int?
    let reward, earningPerWeek: Int?
    let perDayTotalTime: Int?
    let weekName: String?

    
}

