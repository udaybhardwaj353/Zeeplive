//
//  GetMyAgencyData.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 26/09/23.
//

import Foundation

struct getAgencyExists: Codable {
    
    var success: Bool?
    var result: agencyExistsResult?
    var error: String?
}

// MARK: - Result
struct agencyExistsResult: Codable {
  
    var id, profileID: Int?
    var name, username: String?

    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case name, username
    }
}


