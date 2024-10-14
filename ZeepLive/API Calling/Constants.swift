//
//  Constants.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 03/05/23.
//

import Foundation

struct AllUrls {
    
    static let baseUrl =   "https://zeep.live/api/"
    
    struct getUrl {
        
        static let callForUserRegistration = AllUrls.baseUrl + "aaoregistrationkare"
        static let callForUserLogin = AllUrls.baseUrl + "loginLatest"
        static let getUsersList = AllUrls.baseUrl + "getDiscoverPopularNearbyList?type=&page=1"
        static let getPoints = AllUrls.baseUrl + "points"
        static let getPlansList = AllUrls.baseUrl + "planlist"
        static let getexchangeBeansRateList = AllUrls.baseUrl + "exchangeBeansToDiamondList"
        static let getUserDetails = AllUrls.baseUrl + "details"
        static let getUserIncomeReportList = AllUrls.baseUrl + "femaleincomereportList"
      //  static let getUserEarningDetails = AllUrls.baseUrl + "payoutRequestByUser" // MARK: - PURANI WALI API KA URL HAI YE
        static let getUserEarningDetails = AllUrls.baseUrl + "payoutRequestByUserNew"
        static let updateUserProfile = AllUrls.baseUrl + "update-profile-new-review"
        //static let getStoreCategoryList = AllUrls.baseUrl + "getcategoryStores"  // MARK: - PURANI WALI API KA URL HAI YE
        static let followUser = AllUrls.baseUrl + "follow"
        static let getStoreCategoryList = AllUrls.baseUrl + "getcategoryStoresNew"
        static let getuserWalletPoints = AllUrls.baseUrl + "wallet-purchase-points"
        static let bindMobileNumber = AllUrls.baseUrl + "updatemobilenoexitsHostnew"
        static let sendOtpToNewUser = AllUrls.baseUrl + "sendOTPToUserNew"
        static let checkForAgency = AllUrls.baseUrl + "checkfemaleagencyexits"
        static let saveAgencyId = AllUrls.baseUrl + "updatefemaleagency"
        static let checkForFreeTarget = AllUrls.baseUrl + "checkFreeTarget"
        static let createPaymentFromPaytm = AllUrls.baseUrl + "createpaymentpaytm"
        static let checkPaymentConfirmationForPaytm = AllUrls.baseUrl + "paytmPaymentCheck"
        static let manualLogin = AllUrls.baseUrl + "device-manual-login"
//        static let sendOtpForIndiaUser = AllUrls.baseUrl + "sendOTPToUserInLocalnew"
        static let sendOtpForIndiaUser = AllUrls.baseUrl + "send-otp-domestic"
        static let verifyOtpForIndiaUser = AllUrls.baseUrl + "verifyOTPToUserInLocal"
//        static let sendOtpForForeignUser = AllUrls.baseUrl + "sendOTPToUserLatestnew"
        static let sendOtpForForeignUser = AllUrls.baseUrl + "send-otp-foreign"
        static let verifyOtpForForeignUser = AllUrls.baseUrl + "verifyOTPToUserLatest"
        static let checkUserRegistration = AllUrls.baseUrl + "deviceregistrationcheck"
        static let uploadMoment = AllUrls.baseUrl + "addmomenttesting"
        static let likeUnlikeMoment = AllUrls.baseUrl + "addmomentlike"
        static let sendCommentOnMoment = AllUrls.baseUrl + "addmomentcomment"
        static let getAllGifts = AllUrls.baseUrl + "getcategoryGiftsauth"
        static let sendGift = AllUrls.baseUrl + "send_lucky_gift_new"
        static let getSettings = AllUrls.baseUrl + "appsettings"
        static let createLiveBroadcast = AllUrls.baseUrl + "createlivebroadcastLatest"
        static let startCensorVideo = AllUrls.baseUrl + "startCensorVideo"
        static let endLiveBroadcastForHost = AllUrls.baseUrl + "deletelivebroadcast"
        static let createLive = AllUrls.baseUrl + "createlivebroadcast"
        static let currentTimeFromServer = AllUrls.baseUrl + "pk/current_time.php"
        static let updateFcmToken = AllUrls.baseUrl + "updateFCMToken"
        static let exchangeBeansWithDiamond = AllUrls.baseUrl + "exchangeBeansToDiamondInUser"
        static let oneToOneCallSendNotification = AllUrls.baseUrl + "dialCallZegoSendNotification"
        static let getMyEarningPageDataToShow = AllUrls.baseUrl + "wallet-history-incomereport-new"
        static let getBankList = AllUrls.baseUrl + "bankList"
        static let getUserBankAccounts = AllUrls.baseUrl + "getUserAccountDetails?type="
        static let addHostBankAccount = AllUrls.baseUrl + "addNewAccountLatest"
        static let deleteHostBankAccount = AllUrls.baseUrl + "deleteUserAccountHistory"
        static let withdrawMoney = AllUrls.baseUrl + "payoutRequestsnew" 
        static let sendGiftInMoment = AllUrls.baseUrl + "addmomentheart"
        static let oneToOneCallDialCallZego = AllUrls.baseUrl + "dialCallZego"
        static let startEndOneToOneCall = AllUrls.baseUrl + "coin-per-second-user-busy-new-latest"
        static let sendGiftOneToOneCall = AllUrls.baseUrl + "send_lucky_gift"
        static let getFreeTarget = AllUrls.baseUrl + "getFreeTargetDetails"
        static let blockUser = AllUrls.baseUrl + "block-in-host-user-side"
        static let recharge = AllUrls.baseUrl + "apple-coin-recharge"
        
    }
}
