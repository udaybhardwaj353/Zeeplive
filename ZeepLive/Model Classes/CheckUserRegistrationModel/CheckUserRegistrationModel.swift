//
//  CheckUserRegistrationModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 22/12/23.
//

import Foundation

struct CheckRegistration: Codable {
    var success: Bool?
    var result: registrationResult?
    var alreadyRegistered, alreadyMobilenoRegistered, isOldfemaleMobile: Int?
    var permanentCountryName: String?
    var isDeleteAccount, isDeleteAccountTime: Int?
    var error: String?

    enum CodingKeys: String, CodingKey {
        case success, result
        case alreadyRegistered = "already_registered"
        case alreadyMobilenoRegistered = "already_mobileno_registered"
        case isOldfemaleMobile = "is_oldfemale_mobile"
        case permanentCountryName = "permanent_country_name"
        case isDeleteAccount = "is_delete_account"
        case isDeleteAccountTime = "is_delete_account_time"
        case error
    }
}

// MARK: - Result
struct registrationResult: Codable {
    var token, name, gender: String?
    var isOnline, profileID: Int?
    var country, userCity, loginType: String?

    enum CodingKeys: String, CodingKey {
        case token, name, gender
        case isOnline = "is_online"
        case profileID = "profile_id"
        case country
        case userCity = "user_city"
        case loginType = "login_type"
    }
}
