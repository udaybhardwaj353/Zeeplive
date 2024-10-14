//
//  GetPlanListDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/06/23.
//

import Foundation

class PlanListManager {
   
    static let shared = PlanListManager()
    var storePlanListResponse: getPlanList?
    
}

struct PlanList: Codable {
    var success: Bool?
    var result: getPlanList?
    var error: String?
}

// MARK: - Result
struct getPlanList: Codable {
    var inrData, dollarData: [PlanDetailsData]?

    enum CodingKeys: String, CodingKey {
        case inrData = "inr_data"
        case dollarData = "dollar_data"
    }
}

// MARK: - RDatum
struct PlanDetailsData: Codable {
    var id: Int?
    var name: String?
    var amount, points: Int?
    var image: String?
    var status, validityInDays, type, giftLimit: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, amount, points, image, status
        case validityInDays = "validity_in_days"
        case type
        case giftLimit = "gift_limit"
    }
}
