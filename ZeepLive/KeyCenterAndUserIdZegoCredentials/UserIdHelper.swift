//
//  UserIdHelper.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/07/23.
//

import Foundation

struct UserIdHelper {
    
    static var userID: String {
        get {
            guard let stored = UserDefaults.standard.string(forKey: "userID") else {
                let random = "user-\(Int.random(in: 100000..<999999))"
                UserDefaults.standard.set(random, forKey: "userID")
                return random
            }
            return stored
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "userID")
        }
    }
}
