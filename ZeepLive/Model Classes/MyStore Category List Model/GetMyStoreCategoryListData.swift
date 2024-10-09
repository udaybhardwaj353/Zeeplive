//
//  GetMyStoreCategoryListData.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 30/06/23.
//

import Foundation

// MARK: - Welcome
struct myStoreCategoryData: Codable {
    var success: Bool?
    var result: [myStoreCategoryResult]?
    var error: String?
}

// MARK: - Result
struct myStoreCategoryResult: Codable {
    var id: Int?
    var name: String?
    var stores: [StoreCategory]?
}

// MARK: - Store
struct StoreCategory: Codable {
    var id, storeCategoryID: Int?
    var storeName: String?
    var image: String?
    var animationFile: String?
    var soundFile: String?
    var type: String?
    var storeplan: [Storeplan]?

    enum CodingKeys: String, CodingKey {
        case id
        case storeCategoryID = "store_category_id"
        case storeName = "store_name"
        case image
        case animationFile = "animation_file"
        case soundFile = "sound_file"
        case type, storeplan
    }
}

// MARK: - Storeplan
struct Storeplan: Codable {
    var id, storeID, validityInDays, coin: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case storeID = "store_id"
        case validityInDays = "validity_in_days"
        case coin
    }
}
