//
//  GetGiftsDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 09/01/24.
//

import Foundation

class GiftsManager {
   
  static let shared = GiftsManager()
    var giftResults: [giftResult]?
    
}

struct GetGift: Codable {
    var success: Bool?
    var result: [giftResult]?
    var error: String?
}

// MARK: - Result
struct giftResult: Codable {
    var id: Int?
    var name: String?
    var status: Int?
    var createdAt, updatedAt: String?
    var gifts: [Gift]?

    enum CodingKeys: String, CodingKey {
        case id, name, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case gifts
    }
}

// MARK: - Gift
struct Gift: Codable {
    var id, giftCategoryID: Int?
    var giftName: String?
    var image: String?
    var amount: Int?
    var percentageAmount: String?
    var animationType, isAnimated: Int?
    var animationFile: String?
    var soundFile: String?
    var imageType: String?
    var fullScreen, animationDuration, status: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case giftCategoryID = "gift_category_id"
        case giftName = "gift_name"
        case image, amount
        case percentageAmount = "percentage_amount"
        case animationType = "animation_type"
        case isAnimated = "is_animated"
        case animationFile = "animation_file"
        case soundFile = "sound_file"
        case imageType = "image_type"
        case fullScreen = "full_screen"
        case animationDuration = "animation_duration"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
