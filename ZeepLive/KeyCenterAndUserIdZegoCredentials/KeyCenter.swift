//
//  KeyCenter.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 03/07/23.
//

import Foundation

struct KeyCenter {

    // Developers can get appID from admin console.
    // https://console.zego.im/dashboard
    // for example: 123456789
    static var appID: UInt32 = 36797904 //158770798

    // AppSign only meets simple authentication requirements.
    // If you need to upgrade to a more secure authentication method,
    // please refer to [Guide for upgrading the authentication mode from using the AppSign to Token](https://docs.zegocloud.com/faq/token_upgrade)
    // Developers can get AppSign from admin [console](https://console.zego.im/dashboard)
    // for example: "abcdefghijklmnopqrstuvwxyz0123456789abcdegfhijklmnopqrstuvwxyz01"
    static var appSign: String = "09d97ec36a5cf1835cbb1453c4dcda0466dad6c26506ef24896152460a1db793"  //"5bc8d1a4acd4bb16bf2d1d121cd5b8bb6f61ccee6b3c01cdd6eecb6de336cc62"
    
}
