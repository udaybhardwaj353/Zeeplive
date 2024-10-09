//
//  LoginModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/05/23.
//

import Foundation

struct Login: Codable {
    var success: Bool?
    var result: LoginResult?
    var alreadyRegistered: Int?
    var error: String?

    enum CodingKeys: String, CodingKey {
        case success, result
        case alreadyRegistered = "already_registered"
        case error
    }
}

// MARK: - Result
struct LoginResult: Codable {
    var token, name, gender: String?
    var isOnline, profileID: Int?
    var country, userCity: String?

    enum CodingKeys: String, CodingKey {
        case token, name, gender
        case isOnline = "is_online"
        case profileID = "profile_id"
        case country
        case userCity = "user_city"
    }
}
