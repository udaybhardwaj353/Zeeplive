//
//  GlobalClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 14/04/23.
//

import Foundation
import UIKit
import CommonCrypto
import Kingfisher
import RealmSwift

class GlobalClass: NSObject {
    
    static let sharedInstance = GlobalClass()
    
    var window: UIWindow?
    
    let bundleId = Bundle.main.bundleIdentifier
    let info = Bundle.main.infoDictionary
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
// For Shumai Credentials
    let orgString = "DbUXaHY4DwXi0MnXDEiD"
    let appId = "50000133"
    let publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPSI+pLS+n4NXE6oTA0LLBaVCtNfIHWGmPAxnHmjxzf5vRCwtXJ4VaiSL2qIPCVfhPCwyLkTF9/BEKUb2PJDw4YkmeK/E4LuKlRkZDKvnkwtX5hBL9BQht1HIIX9gXdMlWg7PmzW5BBRG+lH9KjGMT4lXojIvSa6HEb1TWmJxjxQIDAQAB"
    let MYUUID = UIDevice.current.identifierForVendor?.uuidString
    let keyName = "D9L6ef024KKwX99DbZjLhQHEx9QiDdXZ"
    let keyIV = "DOOKYd2LIZ2ET4AZ"
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    let realm = try? Realm()

    
    func replaceNumbersWithAsterisks(_ string: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[0-9]")
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "*")
    }
    
    func addGradientToLeftAndRight(to view: UIView, cornerRadius: CGFloat, leftColor: UIColor, rightColor: UIColor) {
        // Calculate the frame for left and right gradients
        let leftFrame = CGRect(x: 0, y: 0, width: view.bounds.width / 2, height: view.bounds.height)
        let rightFrame = CGRect(x: view.bounds.width / 2, y: 0, width: view.bounds.width / 2, height: view.bounds.height)
        
        // Create gradient layers for left and right sides
        let leftGradientLayer = CAGradientLayer()
        leftGradientLayer.frame = leftFrame
        leftGradientLayer.colors = [leftColor.cgColor, leftColor.cgColor] // Set the same color for the left side
        leftGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        leftGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        leftGradientLayer.cornerRadius = cornerRadius
        
        let rightGradientLayer = CAGradientLayer()
        rightGradientLayer.frame = rightFrame
        rightGradientLayer.colors = [rightColor.cgColor, rightColor.cgColor] // Set the same color for the right side
        rightGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        rightGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        rightGradientLayer.cornerRadius = cornerRadius
        
        // Adding the gradient layers to the view's layer
        view.layer.insertSublayer(leftGradientLayer, at: 0)
        view.layer.insertSublayer(rightGradientLayer, at: 1)
    }
    
    func isUserFollowed(userIdToCheck: String) -> Bool {
        // Get the current userSelfId from UserDefaults
        guard let currentUserSelfId = UserDefaults.standard.string(forKey: "UserProfileId"), !currentUserSelfId.isEmpty else {
            // Return false if no userSelfId is found in UserDefaults
            return false
        }

        guard let realm = realm else {
            print("Realm not found")
            return false
        }
        
        // Query objects where userSelfId matches the value from UserDefaults
        let userFollowListsForSelfId = realm.objects(userFollowList.self)
            .filter("userSelfId == %@", currentUserSelfId)

        // Check if any objects exist for the current user
        guard !userFollowListsForSelfId.isEmpty else {
            // If no object matches userSelfId, return false
            return false
        }

        // If userSelfId matches, check for the profileId (userIdToCheck)
        let userFollowListsWithUserId = userFollowListsForSelfId
            .filter("profileId == %@", userIdToCheck)

        // Return true if an object with the specified profileId exists, false otherwise
        return !userFollowListsWithUserId.isEmpty
    }

    
//    func isUserFollowed(userIdToCheck: String) -> Bool {
//        
//        // Query objects based on userId
//        let userFollowListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", userIdToCheck)
//
//        // Check if any objects match the criteria
//        if userFollowListsWithUserId.isEmpty {
//            // No object with the specified userId exists
//            return false
//        } else {
//            // An object with the specified userId exists
//            return true
//        }
//    }
    
    func saveUserToFollowList(profileID:String = "") {
        
        guard let realm = realm else {
            print("Realm not found")
            return
        }
        
        let userFollowListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", profileID)

        // Check if any objects match the criteria
        if userFollowListsWithUserId.isEmpty {
            do {
                try realm.write {
                    let followList = userFollowList()
                    
                    // Set the properties of the object
                    followList.userId = ""
                    followList.profileId = profileID
                    followList.userSelfId = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
                    realm.add(followList)
                }
                
            } catch let error as NSError {
                print("Error creating user details: \(error)")
            }
        } else {
            print("User Follow List main pehle se hi hai. Phir se Add karne ki jrurat nahi hai.")
        }
        
    }
    
    func removeUserFromFollowList(userIdToRemove: String) {
        // Get the default Realm instance
       // let realm = try! Realm()

        guard let realm = realm else {
            print("Realm not found")
            return
        }
        
        do {
            // Begin a write transaction
            try realm.write {
                // Query the object to remove based on userId
                let userBlockListsWithUserId = realm.objects(userFollowList.self).filter("profileId == %@", userIdToRemove)
                
                // Check if any objects match the criteria
                if let userToRemove = userBlockListsWithUserId.first {
                    // Delete the object from the Realm database
                    realm.delete(userToRemove)
                    print("User with ID \(userIdToRemove) removed from block list.")
                } else {
                    print("User with ID \(userIdToRemove) not found in block list.")
                }
            }
        } catch {
            print("User Not Removed From Follow List in global class.")
        }
    }
    
    func loadImageForCell(from urlString: String?, into imageView: UIImageView) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "UserPlaceHolderImageForCell")
            return
        }

        KF.url(url)
            .cacheOriginalImage()
            .onSuccess { result in
                DispatchQueue.main.async {
                    imageView.image = result.image
                }
            }
            .onFailure { error in
                print("Image loading failed with error: \(error)")
                imageView.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
            .set(to: imageView)
    }
    
    func currentUTCms() -> Int64 {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let utcTime = dateFormatter.string(from: Date())
        
        if let date = dateFormatter.date(from: utcTime) {
            let milliseconds = Int64(date.timeIntervalSince1970 * 1000)
            return milliseconds
        } else {
            return 0
        }
    }

    func millisecondsToUniversalTime(milliseconds: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcDateString = dateFormatter.string(from: date)
        return utcDateString
    }
    
    func buttonOutlineColour() -> UIColor {
        return UIColor.init(hexString: "#ec80ff")!;
    }
    
    func buttonEnableColor() -> UIColor {
        return UIColor.init(hexString: "#ea55ff")!;
    }
    
    func buttonDisableColor() -> UIColor {
        return UIColor.init(hexString: "#cfb0ff")!;
    }
    
    func textfieldBackgroundColor() -> UIColor {
        return UIColor.init(hexString: "#F7F6FB")!;
    }
    
    func backButtonColor() -> UIColor {
        return UIColor.init(hexString: "#EA55FF")!;
    }
    
    func buttonEnableSecondColour() -> UIColor {
        return UIColor.init(hexString: "#a659fd")!;
    }
    
    func setGapColour() -> UIColor {
        return UIColor.init(hexString: "#F3F3F3")!;
    }
    
    func setButtonRecordBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#FFEAAE")!;
    }
    
    func buttonLoginColour() -> UIColor {
        return UIColor.init(hexString: "#C833F4")!;
    }
    
    func setDiamondPriceBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#fff9f0")!;
    }
    
    func setDiamondPriceUnselectBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#F6F2F2")!;
    }
    
    func setDiamondPriceColor() -> UIColor {
        return UIColor.init(hexString: "#ef9b45")!;
    }
    
    func setButtonCoinDetailsColour() -> UIColor {
        return UIColor.init(hexString: "ffb531")!;
    }
    
    func setButtonRecordTextColor() -> UIColor {
        return UIColor.init(hexString: "fcba44")!;
    }
    
    func setViewBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#f6f6f6")!;
    }
    
    func setTextColour() -> UIColor {
        return UIColor.init(hexString: "#4f4f4f")!;
    }
    
    func setGrayStripColour() -> UIColor {
        return UIColor.init(hexString: "#e8e8e8")!;
    }
    
    func setAmountCreditColour() -> UIColor {
        return UIColor.init(hexString: "#47d19c")!;
    }
    
    func setAmountDebitColour() -> UIColor {
        return UIColor.init(hexString: "#ef596f")!;
    }
    
    func setViewAmountDetailsBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#7E0EAE")!;
    }
    
    func setWalletDetailsBackgroundPaymentStatusGreenColour() -> UIColor {
        return UIColor.init(hexString: "#e1ffbb")!;
    }
    
    func setWalletDetailsBackgroundPaymentStatusRedColour() -> UIColor {
        return UIColor.init(hexString: "#ffc0c0")!;
    }
    
    func setWalletDetailsBackgroundPaymentStatusColour() -> UIColor {
        return UIColor.init(hexString: "#E9E9E9")!;
    }
    
    func setLabelColour() -> UIColor {
        return UIColor.init(hexString: "#868585")!;
    }
    
    func setMyStoreViewColour() -> UIColor {
        return UIColor.init(hexString: "#201D30")!;
    }
    
    func setMyStoreOptionsBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#312E43")!;
    }
    
    func setMyStoreSelectedOptionColour() -> UIColor {
        return UIColor.init(hexString: "#A39FB8")!;
    }
    
    func setButtonColour() -> UIColor {
        return UIColor.init(hexString: "#545454")!;
    }
    
    func setButtonLeftColour() -> UIColor {
        return UIColor.init(hexString: "#F07C91")!;
    }
    
    func setButtonMiddleColour() -> UIColor {
        return UIColor.init(hexString: "#FF3688")!;
    }
    
    func setButtonRightColour() -> UIColor {
        return UIColor.init(hexString: "#FF7335")!;
    }
    func setOrangeBorderColour() -> UIColor {       // Added 19 December
        return UIColor.init(hexString: "#FFC027")!;
    }
    func setSelectedPagerColour() -> UIColor {       // Added 19 December
        return UIColor.init(hexString: "#FE339F")!;
    }
    func setUnSelectedPagerColour() -> UIColor {       // Added 19 December
        return UIColor.init(hexString: "#7E7E7E")!;
    }
    
    func setStatusViewBackgroundColour() -> UIColor {       // Added 19 December
        return UIColor.init(hexString: "#DF1C9F")!;
    }
    
    func setPKStatusBackgroundViewColour() -> UIColor {
        return UIColor.init(hexString: "#370468")!;  // #500092
    }
    func setPostMomentBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#dbdbdb")!;
    }
    func setMultipleButtonBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#2D232E")!;
    }
    func setGiftViewBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#000000")!;
    }
    func setLiveMessageColour() -> UIColor {
        return UIColor.init(hexString: "#f4c11f")!;
    }
    func setGameBelowViewBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#302C43")!;
    }
    func setLuckyGiftAmountColour() -> UIColor {
        return UIColor.init(hexString: "#816405")!;
    }
    func setPKControllerBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#4D325A")!;
    }
    func setPKLeftViewColour() -> UIColor {
        return UIColor.init(hexString: "#ED368E")!;
    }
    func setPKRightViewColour() -> UIColor {
        return UIColor.init(hexString: "#1EB1EB")!;
    }
    func buttonVideoCallFirstColour() -> UIColor {
        return UIColor.init(hexString: "#FF6C71")!;
    }
    func buttonVideoCallSecondColour() -> UIColor {
        return UIColor.init(hexString: "#FF07BE")!;
    }
    func buttonBeansExchangeColour() -> UIColor {
        return UIColor.init(hexString: "#7F40FF")!;
    }
    func setBeansExchangeTextColour() -> UIColor {
        return UIColor.init(hexString: "#666666")!;
    }
    func setGiftsBackgroundColour() -> UIColor {
        return UIColor.init(hexString: "#F3F6FF")!;
    }
    func userOptionsDashLineColour() -> UIColor {
        return UIColor.init(hexString: "#707070")!;
    }
    func userOptionsTextColour() -> UIColor {
        return UIColor.init(hexString: "#D2D2D2")!;
    }
    func userMessageSendColour() -> UIColor {
        return UIColor.init(hexString: "#B83EFA")!;
    }
    func hostMessageSendColour() -> UIColor {
        return UIColor.init(hexString: "#B83EFA")!;
    }
    func setSelectedPagerColourForPKList() -> UIColor {
        return UIColor.init(hexString: "#629FE5")!;
    }
}

// MARK: - CLASS TO SHOW LOADER IN THE BOTTOM OF THE COLLECTION VIEW

class LoadingFooterView: UICollectionReusableView {
    let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Customize the loading indicator view if needed
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}

class LoadingIndicatorManager {
    static let shared = LoadingIndicatorManager()
    
    private init() {}
    
    func showLoadingIndicator(collectionView: UICollectionView) {
        if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: 0)) as? LoadingFooterView {
            footerView.startAnimating()
        }
    }
    
    func hideLoadingIndicator(collectionView: UICollectionView) {
        if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: 0)) as? LoadingFooterView {
            footerView.stopAnimating()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .gray
            indicator.hidesWhenStopped = true
            return indicator
        } else {
            return UIActivityIndicatorView()
        }
        
    }()
    
    //    func showLoadingIndicator(on view: UIView) {
    //        DispatchQueue.main.async {
    //            self.activityIndicator.startAnimating()
    //            self.activityIndicator.center = view.center
    //            view.addSubview(self.activityIndicator)
    //        }
    //    }
    
    func showRefreshLoadingIndicator(on view: UIView) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.minY + self.activityIndicator.frame.height / 2)
            view.addSubview(self.activityIndicator)
        }
    }
        func hideRefreshLoadingIndicator() {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
        }
        
}

class CircularProgressView: UIView {
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    
    var progressColor: UIColor = .orange {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor: UIColor = .lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var lineWidth: CGFloat = 10.0 {
        didSet {
            progressLayer.lineWidth = lineWidth
            trackLayer.lineWidth = lineWidth
            updatePaths()
        }
    }
    
    var progress: CGFloat = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    private func setupLayers() {
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
        
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressLayer)
        
        updatePaths()
    }
    
    private func updatePaths() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 3 * CGFloat.pi / 2,
                                        clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.lineWidth = lineWidth
        
        progressLayer.path = circularPath.cgPath
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = progress
    }
    
    private func updateProgress() {
        progressLayer.strokeEnd = progress
    }
}

// Added on 11 January for encrypting the data and sending it to backend for otp sending
class EncryptionUtils {

    static func encrypt(data: [String: Any], key: String, iv: String) throws -> String {
        // Convert the dictionary to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: data)

        // Call the existing encrypt function with the JSON data
        return try encrypt(data: jsonData, key: key, iv: iv)
    }

    private static func encrypt(data: Data, key: String, iv: String) throws -> String {
        let keyData = key.data(using: .utf8)!
        let ivData = iv.data(using: .utf8)!

        var encryptedBytes = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128)
        var encryptedLength: Int = 0

        let status = keyData.withUnsafeBytes { keyBytes in
            ivData.withUnsafeBytes { ivBytes in
                data.withUnsafeBytes { dataBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress,
                        keyData.count,
                        ivBytes.baseAddress,
                        dataBytes.baseAddress,
                        data.count,
                        &encryptedBytes,
                        encryptedBytes.count,
                        &encryptedLength
                    )
                }
            }
        }

        if status == kCCSuccess {
            let encryptedData = Data(bytes: encryptedBytes, count: encryptedLength)
            return encryptedData.base64EncodedString()
        } else {
            throw EncryptionError.encryptionFailed
        }
    }
}

enum EncryptionError: Error {
    case encryptionFailed
}

// MARK: - EXTENSION FOR DELAYING THE API CALLING AFTER ENTERING TEXT IN SEARCH TEXT FIELD

extension DispatchQueue {

    /**
     - parameters:
        - target: Object used as the sentinel for de-duplication.
        - delay: The time window for de-duplication to occur
        - work: The work item to be invoked on the queue.
     Performs work only once for the given target, given the time window. The last added work closure
     is the work that will finally execute.
     Note: This is currently only safe to call from the main thread.
     Example usage:
     ```
     DispatchQueue.main.asyncDeduped(target: self, after: 1.0) { [weak self] in
         self?.doTheWork()
     }
     ```
     */
    public func asyncDeduped(target: AnyObject, after delay: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
        let dedupeIdentifier = DispatchQueue.dedupeIdentifierFor(target)
        if let existingWorkItem = DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier) {
            existingWorkItem.cancel()
            NSLog("Deduped work item: \(dedupeIdentifier)")
        }
        let workItem = DispatchWorkItem {
            DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier)

            for ptr in DispatchQueue.weakTargets.allObjects {
                if dedupeIdentifier == DispatchQueue.dedupeIdentifierFor(ptr as AnyObject) {
                    work()
                    NSLog("Ran work item: \(dedupeIdentifier)")
                    break
                }
            }
        }

        DispatchQueue.workItems[dedupeIdentifier] = workItem
        DispatchQueue.weakTargets.addPointer(Unmanaged.passUnretained(target).toOpaque())

        asyncAfter(deadline: .now() + delay, execute: workItem)
    }

}

// MARK: - Static Properties for De-Duping
private extension DispatchQueue {

    static var workItems = [AnyHashable : DispatchWorkItem]()

    static var weakTargets = NSPointerArray.weakObjects()

    static func dedupeIdentifierFor(_ object: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(object).toOpaque())." + String(describing: object)
    }

}

