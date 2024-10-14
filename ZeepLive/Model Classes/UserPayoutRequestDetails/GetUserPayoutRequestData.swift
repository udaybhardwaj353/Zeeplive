//
//  GetUserPayoutRequestData.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/23.
//

import Foundation

struct userPayoutDetails: Codable {
    var success: Bool?
    var result: [userPayoutDetailsResult]?
    var error: String?
}

// MARK: - Result
struct userPayoutDetailsResult: Codable {
    var id, userID, accountID, status: Int?
    var amountInr: Double?
    var payoutID: String?
    var razorpayStatus: String?
    var utrNo: String?
    var withdrawDate:String
    var paymentDate: String?
    var paymentRequestAccount: userPaymentRequestAccount?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case accountID = "account_id"
        case status
        case amountInr = "amount_inr"
        case payoutID = "payout_id"
        case razorpayStatus = "razorpay_status"
        case utrNo = "utr_no"
        case withdrawDate = "withdraw_date"
        case paymentDate = "payment_date"
        case paymentRequestAccount = "payment_request_account"
    }
}

// MARK: - PaymentRequestAccount
struct userPaymentRequestAccount: Codable {
    var id: Int?
    var email, accountNumber, bankName, ifscCode: String?
    var type: Int?
    var upiID: String?
    var paymentRequestID: Int?
    var epayReceiveCurrency, epayTransactionType, epayReceiverInfo: String?

    enum CodingKeys: String, CodingKey {
        case id, email
        case accountNumber = "account_number"
        case bankName = "bank_name"
        case ifscCode = "ifsc_code"
        case type
        case upiID = "upi_id"
        case paymentRequestID = "payment_request_id"
        case epayReceiveCurrency = "epay_receive_currency"
        case epayTransactionType = "epay_transaction_type"
        case epayReceiverInfo = "epay_receiver_info"
    }
}

//enum RazorpayStatus: String, Codable {
//    case processed = "processed"
//    case rejected = "rejected"
//    case reversed = "reversed"
//}
