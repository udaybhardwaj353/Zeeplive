//
//  GetSettingsDetailModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/02/24.
//

import Foundation

class SettingsManager {
   
    static let shared = SettingsManager()
    var storeSettingResponse: [settingsResult]?
    
}
    
struct settingResponse: Codable {
    
    var success: Bool?
    var result: [settingsResult]?
    var recharged: Int?
    var error: String?
}

// MARK: - Result
struct settingsResult: Codable {
    var settingKey, settingValue: String?

    enum CodingKeys: String, CodingKey {
        case settingKey = "setting_key"
        case settingValue = "setting_value"
    }
}
