//
//  GetBeansExchangeRateListDataModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/06/23.
//

import Foundation

struct BeansDetails: Codable {
    var success: Bool?
    var result: [getBeansExchangeList]?
    var error: String?
}

// MARK: - getBeansExchangeList
struct getBeansExchangeList: Codable {
    var id, beans, diamond: Int?
}
