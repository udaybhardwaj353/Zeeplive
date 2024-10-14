//
//  GetUserWalletPurchasePoints.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 13/09/23.
//

import Foundation

struct walletPurchasePoints: Codable {
    var success: Bool?
    var result: walletPurchasePointsResult?
    var error: String?
}

// MARK: - Result
struct walletPurchasePointsResult: Codable {
    var purchasePoints: Int?

    enum CodingKeys: String, CodingKey {
        case purchasePoints = "purchase_points"
    }
}
