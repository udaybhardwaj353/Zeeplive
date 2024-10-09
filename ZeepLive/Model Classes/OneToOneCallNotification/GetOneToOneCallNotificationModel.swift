//
//  GetOneToOneCallNotificationModel.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/03/24.
//

import Foundation

struct GetOneToOneNotificationData: Codable {
    var error: String?
    var result: GetOneToOneNotificationDataResult?
    var success: Int?
}

// MARK: - GetOneToOneNotificationDataResult
struct GetOneToOneNotificationDataResult: Codable {
    var data: DataClass?
    var points: Points?
}

// MARK: - DataClass
struct DataClass: Codable {
    var notification: oneToOneNotification?
    var receiverChannelName: ReceiverChannelName?
    var receiverID: Int?
    var senderChannelName: SenderChannelName?
    var uniqueID: String?

    enum CodingKeys: String, CodingKey {
        case notification
        case receiverChannelName = "receiver_channel_name"
        case receiverID = "receiver_id"
        case senderChannelName = "sender_channel_name"
       // case uniqueID = "unique_id"
    }
}

// MARK: - Notification
struct oneToOneNotification: Codable {
    var canonicalIDS, failure: Int?
    var multicastID: Int?
    var results: [ResultElement]?
    var success: Int?

    enum CodingKeys: String, CodingKey {
        case canonicalIDS = "canonical_ids"
        case failure
        case multicastID = "multicast_id"
        case results, success
    }
}

// MARK: - ResultElement
struct ResultElement: Codable {
    var messageID: String?

    enum CodingKeys: String, CodingKey {
        case messageID = "message_id"
    }
}

// MARK: - ReceiverChannelName
struct ReceiverChannelName: Codable {
    var channelName: String?
    var token: Token?

    enum CodingKeys: String, CodingKey {
        case channelName = "channel_name"
        case token
    }
}

// MARK: - Token
struct Token: Codable {
    var code: Int?
    var message, token: String?
    var uniqueID: Int?

    enum CodingKeys: String, CodingKey {
        case code, message, token
        case uniqueID = "unique_id"
    }
}

// MARK: - SenderChannelName
struct SenderChannelName: Codable {
    var channelName: String?
    var token: Token?
    var uniqueID: String?

    enum CodingKeys: String, CodingKey {
        case channelName = "channel_name"
        case token
        case uniqueID = "unique_id"
    }
}

// MARK: - Points
struct Points: Codable {
    var totalPoint: Int?

    enum CodingKeys: String, CodingKey {
        case totalPoint = "total_point"
    }
}

