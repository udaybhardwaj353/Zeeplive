//
//  ShowGiftViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 09/01/24.
//

import UIKit
import Kingfisher
import ImSDK_Plus

protocol delegateShowGiftViewController: AnyObject {

    func isBalanceLow(isLow:Bool)
    func giftSelected(gift:Gift, sendgiftTimes:Int)
    func showLuckyGift(giftName:String, amount: Int)
    func openLowBalanceView(isclicked:Bool)
    func pkGiftSent(giftAmount:Int, userName:String, userImage: String, userID:String, from:String)
    func giftSentSuccessfully(gift:Gift, sendgiftTimes:Int)
    
}

class ShowGiftViewController: UIViewController {
    
    @IBOutlet weak var collectionViewFirst: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewCoinOutlet: UIControl!
    @IBOutlet weak var lblTotalCoins: UILabel!
    @IBOutlet weak var btnSendGiftOutlet: UIButton!
    @IBOutlet weak var viewMultipleButtons: UIView!
    @IBOutlet weak var btnOneOutlet: UIButton!
    @IBOutlet weak var btnElevenOutlet: UIButton!
    @IBOutlet weak var btnThirtyThreeOutlet: UIButton!
    @IBOutlet weak var btnSeventySevenOutlet: UIButton!
    @IBOutlet weak var collectionViewSecond: UICollectionView!
    
    lazy var giftList = [giftResult]()
    lazy var selectedHeaderIndex: Int = 0
    lazy var selectedGiftIndex: Int = 0
    lazy var sendGiftTimes: Int = 1
    weak var delegate: delegateShowGiftViewController?
//    lazy var recieverID: Int = 0
//    lazy var receiverName: String = ""
    lazy var sendUserModel = ListData()
    lazy var cameFrom: String = "live"
    lazy var giftAmountPK: Int = 0
    lazy var groupID: String = ""
    lazy var opponentGroupID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewWork()
        configureUI()
        getGiftsData()
       
    }
    
    func collectionViewWork() {
        
        collectionViewFirst.register(UINib(nibName: "GiftCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftCategoryCollectionViewCell")
        collectionViewSecond.register(UINib(nibName: "ShowGiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowGiftCollectionViewCell")
        collectionViewFirst.delegate = self
        collectionViewFirst.dataSource = self
        collectionViewSecond.delegate = self
        collectionViewSecond.dataSource = self
        
    }
    
    func configureUI() {
        
        //  viewMultipleButtons.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.backgroundColor = GlobalClass.sharedInstance.setGiftViewBackgroundColour()
        viewMultipleButtons.layer.cornerRadius = viewMultipleButtons.frame.height / 2
        viewMultipleButtons.backgroundColor = GlobalClass.sharedInstance.setMultipleButtonBackgroundColour()
        
        addGradient(to: btnSendGiftOutlet, width: btnSendGiftOutlet.frame.width, height: btnSendGiftOutlet.frame.height, cornerRadius: btnSendGiftOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
        
        btnOneOutlet.layer.cornerRadius = btnOneOutlet.frame.size.width / 2
        btnOneOutlet.clipsToBounds = true
        btnElevenOutlet.layer.cornerRadius = btnOneOutlet.frame.size.width / 2
        btnElevenOutlet.clipsToBounds = true
        btnThirtyThreeOutlet.layer.cornerRadius = btnOneOutlet.frame.size.width / 2
        btnThirtyThreeOutlet.clipsToBounds = true
        btnSeventySevenOutlet.layer.cornerRadius = btnOneOutlet.frame.size.width / 2
        btnSeventySevenOutlet.clipsToBounds = true
        
        btnOneOutlet.backgroundColor = UIColor.white
        btnOneOutlet.setTitleColor(UIColor.purple, for: .normal)
        
        let a = UserDefaults.standard.string(forKey: "coins") ?? "0"
        lblTotalCoins.text = a + " " + ">"
        
    }
    
    func calculateCoins() {
    
        DispatchQueue.global(qos: .background).async {
            let giftAmount = (self.giftList[self.selectedHeaderIndex].gifts?[self.selectedGiftIndex].amount ?? 0) * self.sendGiftTimes
            print("The gift amount is:\(giftAmount)")
            
            if let coinString = UserDefaults.standard.string(forKey: "coins"), let coins = Int(coinString) {
                
                if (coins >= giftAmount ) {
                    print("Gift send ho jaega")
                    let coinLeft = coins - giftAmount
                    print("Remaining coins after gift purchase: \(coinLeft)")
              //      UserDefaults.standard.set(String(coinLeft), forKey: "coins")
                    DispatchQueue.main.async {
                        // Update UserDefaults or trigger UI changes using 'coinLeft' (on the main queue)
                        
//                        self.lblTotalCoins.text = String(coinLeft) + " " + ">"
                        // Assuming giftList is an array of optional Gift objects
                        if let selectedGift = self.giftList[self.selectedHeaderIndex].gifts?[self.selectedGiftIndex] {
//                            self.delegate?.giftSelected(gift: selectedGift, sendgiftTimes: self.sendGiftTimes)
                            
                            let user1: [String: Any] = ["user_id": self.sendUserModel.profileID ?? 0, "user_name": self.sendUserModel.name ?? "N/A"]
                            
                            var param = [String: Any]()
                         
                            param["gift_count"] = self.sendGiftTimes
                            param["receiver_id"] = self.sendUserModel.profileID ?? 0
                            param["category_id"] = selectedGift.giftCategoryID
                            param["gift_id"] = selectedGift.id
                            param["gift_price"] = giftAmount//(gift.amount ?? 0) * sendgiftTimes
                            param["call_start_timestamp"] = Date().timeIntervalSince1970 * 1000
                            param["gift_sending_timestamp"] = Date().timeIntervalSince1970 * 1000
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: user1, options: .prettyPrinted)
                                if let jsonString = String(data: jsonData, encoding: .utf8) {
                                    param["user_list"] = [user1]   //jsonString
                                }
                            } catch {
                                print("JSON转换错误: \(error.localizedDescription)")
                            }
                            
                            print("The gift params are: \(param)")
                            
                            if (self.cameFrom == "onetoone") {
                                
                                print("Ye sab ki jrurt nahi hai hmain one to one chalega hmara.")
                                self.delegate?.giftSelected(gift: selectedGift, sendgiftTimes: self.sendGiftTimes)
                                
                            } else {
                                
                                self.sendGift(params: param) { success in
                                    if success {
                                        // Gift sent successfully
                                        print("Gift sent successfully")
                                        self.delegate?.giftSelected(gift: selectedGift, sendgiftTimes: self.sendGiftTimes)
                                        self.sendGiftToFirebase(model: selectedGift)
                                    } else {
                                        // Gift sending failed
                                        print("Gift sending failed")
                                        self.delegate?.isBalanceLow(isLow: true)  // abhi ke liye low gift wala popup dikha do
                                    }
                                }
                            }
                            
                        } else {
                            // Handle the case where the selected gift is nil
                        }

                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        // Update UserDefaults or trigger UI changes using 'coinLeft' (on the main queue)
                        self.delegate?.isBalanceLow(isLow: true)
                        
                    }
                   
                    
                    print("Gift send nahi ho paega balance low hai")
                }
            
                DispatchQueue.main.async {
                    // Update UserDefaults or trigger UI changes using 'coinLeft' (on the main queue)
                    
                }
            } else {
                print("Unable to retrieve or convert 'coins' from UserDefaults")
            }
        }
        
    }
    
    @IBAction func viewCoinPressed(_ sender: Any) {
        
        print("View Total Coin Pressed")
        delegate?.openLowBalanceView(isclicked: true)
        
    }
    
    @IBAction func btnSendGiftPressed(_ sender: Any) {
        
        print("Send Gift Button Pressed")
        calculateCoins()
        
    }
    
    @IBAction func btnOnePressed(_ sender: Any) {
        
        print("Button One Pressed")
        sendGiftTimes = 1
        btnOneOutlet.backgroundColor = UIColor.white
        btnOneOutlet.setTitleColor(UIColor.purple, for: .normal)
        btnElevenOutlet.backgroundColor = .clear
        btnElevenOutlet.setTitleColor(UIColor.white, for: .normal)
        btnThirtyThreeOutlet.backgroundColor = .clear
        btnThirtyThreeOutlet.setTitleColor(UIColor.white, for: .normal)
        btnSeventySevenOutlet.backgroundColor = .clear
        btnSeventySevenOutlet.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    @IBAction func btnElevenPressed(_ sender: Any) {
        
        print("Button Eleven Pressed")
        sendGiftTimes = 11
        btnElevenOutlet.backgroundColor = UIColor.white
        btnElevenOutlet.setTitleColor(UIColor.purple, for: .normal)
        btnThirtyThreeOutlet.backgroundColor = .clear
        btnThirtyThreeOutlet.setTitleColor(UIColor.white, for: .normal)
        btnSeventySevenOutlet.backgroundColor = .clear
        btnSeventySevenOutlet.setTitleColor(UIColor.white, for: .normal)
        btnOneOutlet.backgroundColor = .clear
        btnOneOutlet.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    @IBAction func btnThirtyThreePressed(_ sender: Any) {
        
        print("Button Thirty Three Pressed")
        sendGiftTimes = 33
        btnThirtyThreeOutlet.backgroundColor = UIColor.white
        btnThirtyThreeOutlet.setTitleColor(UIColor.purple, for: .normal)
        btnSeventySevenOutlet.backgroundColor = .clear
        btnSeventySevenOutlet.setTitleColor(UIColor.white, for: .normal)
        btnOneOutlet.backgroundColor = .clear
        btnOneOutlet.setTitleColor(UIColor.white, for: .normal)
        btnElevenOutlet.backgroundColor = .clear
        btnElevenOutlet.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    @IBAction func btnSeventySevenPressed(_ sender: Any) {
        
        print("Button Seventy Seven Pressed")
        sendGiftTimes = 77
        btnSeventySevenOutlet.backgroundColor = UIColor.white
        btnSeventySevenOutlet.setTitleColor(UIColor.purple, for: .normal)
        btnOneOutlet.backgroundColor = UIColor.clear
        btnOneOutlet.setTitleColor(UIColor.white, for: .normal)
        btnElevenOutlet.backgroundColor = UIColor.clear
        btnElevenOutlet.setTitleColor(UIColor.white, for: .normal)
        btnThirtyThreeOutlet.backgroundColor = UIColor.clear
        btnThirtyThreeOutlet.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    
}

// MARK: - EXTENSION FOR SENDING GIFT TO FIREBASE AND SHOWING IT TO ALL THE USERS IN THE LIVE BROAD

extension ShowGiftViewController {
   
    func sendGiftToFirebase(model: Gift) {
        
        var dic = [String: Any]()
        dic["level"] = UserDefaults.standard.string(forKey: "level")
        dic["gender"] = UserDefaults.standard.string(forKey: "gender")
        dic["user_id"] = UserDefaults.standard.string(forKey: "UserProfileId")
        dic["user_name"] = UserDefaults.standard.string(forKey: "UserName")
        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
            dic["user_image"] = picM ?? ""
        }
        
        
        dic["type"] = "2"
        if let giftName = model.giftName, let recipientName = sendUserModel.name {
            let message = "send \(sendGiftTimes) \(giftName) to <font color='#f4c11f'><bold>\(recipientName)</bold></font>"
            // Use the message string
            dic["message"] = message
            print(message)
        } else {
            print("Some required values are nil")
        }

        //dic["message"] =  "send \(sendGiftTimes) \(model.giftName!) to <font color='#f4c11f'><bold>\(sendUserModel.name!)</bold></font>" /*String(format: "Send %ld %@ to %@", sendGiftTimes, model.giftName ?? "", sendUserModel.name ?? "")*/
        dic["ownHost"] = true
        let giftDic = getFireBaseGift(model: model)
        dic["gift"] = giftDic
       // dic["time"] = Date().timeIntervalSince1970
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: giftDic, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                dic["user_list"] = jsonString
            }
        } catch {
            print("JSON转换错误: \(error.localizedDescription)")
        }
                print("THe dictionary we are sending to the firebase message node is: \(dic)")
      
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                V2TIMManager.sharedInstance().sendGroupTextMessage(
                    jsonString,
                    to: groupID,
                    priority: V2TIMMessagePriority(rawValue: 1)!,
                    succ: {
                        // Success closure
                        print("Message sent successfully to first host")
                        print(jsonString)
                        
                   //     if (self.cameFrom == "pk") {
                   //         self.sendMessageToOtherGroup(dic: dic)
                      //  } else {
                            self.delegate?.giftSentSuccessfully(gift: model, sendgiftTimes: self.sendGiftTimes)
                            if (self.cameFrom == "live") {
                                print("Kuch nahi krna hai iss case main.")
                            } else {
                                print("Iss case mai delegate call krenge kyunki gift pk mai bheja hai.")
                                print(model.animationType)
                                self.sendMessageToOtherGroup(dic: dic)
                                if (self.giftList[self.selectedHeaderIndex].id == 3) {
                                    self.delegate?.pkGiftSent(giftAmount: self.giftAmountPK, userName: (UserDefaults.standard.string(forKey: "UserName") ?? ""), userImage:  (UserDefaults.standard.string(forKey: "profilePicture") ?? ""), userID: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), from: self.cameFrom)
                                } else {
                                    self.delegate?.pkGiftSent(giftAmount: (model.amount ?? 0), userName: (UserDefaults.standard.string(forKey: "UserName") ?? ""), userImage:  (UserDefaults.standard.string(forKey: "profilePicture") ?? ""), userID: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), from: self.cameFrom)
                                }
                            }
                     //   }
                            
                    },
                    fail: { (code, desc) in
                        // Failure closure
                        print("Failed to send message with error code: \(code), description: \(desc ?? "Unknown")")
                    }
                )
            } else {
                print("Failed to convert JSON data to string")
            }
        } catch {
            print("Error converting dictionary to JSON: \(error.localizedDescription)")
        }

    }
    
    func getFireBaseGift(model: Gift) -> [String: Any] {
        var gift = [String: Any]()
        
        gift["unit"] = ""
        gift["count"] = sendGiftTimes
        gift["toSeatNo"] = 0
        gift["shakeTime"] = 2
        gift["fromSeatNo"] = 0
        gift["streamerTime"] = 0
        gift["gift_duration"] = String(model.animationDuration ?? 0)
        gift["isCollectiveGift"] = 0
        gift["hideGiftNum"] = false
        
        gift["toName"] = sendUserModel.name
        gift["toUserId"] = sendUserModel.id
        gift["toHeadUrl"] = sendUserModel.profileImage
        
        gift["giftId"] = model.id
        gift["icon"] = model.image
        gift["name"] = model.giftName
        gift["giftCoin"] = String(model.amount ?? 0)
        gift["icon_type"] = model.imageType
        gift["soundFile"] = model.soundFile
        gift["animation"] = model.isAnimated
        gift["animationType"] = model.animationType
        gift["animation_file"] = model.animationFile

        gift["fromName"] = UserDefaults.standard.string(forKey: "UserName")
        gift["fromUserId"] = Int(UserDefaults.standard.string(forKey: "userId") ?? "0")
        gift["fromUserSex"] = 1//UserDefaults.standard.string(forKey: "gender")
        gift["fromUserVlevel"] = UserDefaults.standard.string(forKey: "level")
        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
            gift["fromHeader"] = picM ?? ""
        }
        
        return gift
    }
    
    func sendMessageToOtherGroup(dic: [String: Any] = [:]) {
    
        print("The opponent group id is: \(opponentGroupID)")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                V2TIMManager.sharedInstance().sendGroupTextMessage(
                    jsonString,
                    to: opponentGroupID,
                    priority: V2TIMMessagePriority(rawValue: 1)!,
                    succ: {
                        // Success closure
                        print("Message sent successfully for other group users as well.")
                        print(jsonString)
                    },
                    fail: { (code, desc) in
                        // Failure closure
                        print("Failed to send message to other group with error code: \(code), description: \(desc ?? "Unknown")")
                    }
                )
            } else {
                print("Failed to convert JSON data to string")
            }
        } catch {
            print("Error converting dictionary to JSON: \(error.localizedDescription)")
        }
        
    }
    
}

// MARK: - EXTENSION FOR USING COLLECTION VIEW FUNCTIONALITIES AND IT'S WORKING AND SHOWING GIFT'S

extension ShowGiftViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == collectionViewFirst) {
            
            return giftList.count ?? 0
            
        } else if (collectionView == collectionViewSecond){
            
            if selectedHeaderIndex < giftList.count, let gifts = giftList[selectedHeaderIndex].gifts {
//                let numberOfPages = (gifts.count) / 4 // Assuming 4 cells per page
//                pageControl.numberOfPages = numberOfPages
                setControlPage()
                print("THe total no. of gifts are: \(gifts.count)")
                return gifts.count
            } else {
                return 0
            }

        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == collectionViewFirst) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCategoryCollectionViewCell", for: indexPath) as! GiftCategoryCollectionViewCell
            
            cell.lblName.text = giftList[indexPath.row].name ?? "No Name"
            
            if (indexPath.row == selectedHeaderIndex) {
                
               // cell.lblName.font = UIFont.boldSystemFont(ofSize: 16) // Increase font size
                cell.lblName.textColor = UIColor.white
                
            } else {
            
              //  cell.lblName.font = UIFont.systemFont(ofSize: 16) // Increase font size
                cell.lblName.textColor = UIColor.darkGray
                
            }
            
            return cell
            
        } else if (collectionView == collectionViewSecond){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowGiftCollectionViewCell", for: indexPath) as! ShowGiftCollectionViewCell
            
          //  cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
            if let selectedGift = giftList[selectedHeaderIndex].gifts?[indexPath.row] {
                cell.lblGiftName.text = selectedGift.giftName ?? ""
                cell.lblCoinAmount.text = String(selectedGift.amount ?? 0)
                
                if let profileImageURL = URL(string: giftList[selectedHeaderIndex].gifts?[indexPath.row].image ?? " ") {
                    KF.url(profileImageURL)
                       // .downsampling(size: CGSize(width: 200, height: 200))
                        .cacheOriginalImage()
                        .onSuccess { result in
                            DispatchQueue.main.async {
                                cell.imgView.image = result.image
                            }
                        }
                        .onFailure { error in
                            print("Image loading failed with error: \(error)")
                            cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
                        }
                        .set(to: cell.imgView)
                } else {
                    cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
                }
                
            } else {
                cell.lblGiftName.text = ""
                cell.lblCoinAmount.text = "0"
            }

                    if indexPath.row == selectedGiftIndex {
            
                        cell.viewMain.layer.borderColor = UIColor.purple.cgColor//GlobalClass.sharedInstance.setOrangeBorderColour().cgColor//UIColor.orange.cgColor
                        cell.viewMain.layer.borderWidth = 2.7
                        cell.viewMain.layer.cornerRadius = 5
                        
                    } else {
            
                        cell.viewMain.layer.borderWidth = 0
                        cell.viewMain.layer.cornerRadius = 0
                        
                    }
            
            
            return cell
             
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == collectionViewFirst) {
            
            let width = (collectionView.bounds.size.width ) / 4
            let height = width - 65
            return CGSize(width: width, height: 70)
            
        } else if (collectionView == collectionViewSecond) {
            
            let width = (collectionView.frame.size.width ) / 4 //(372) / 2
                let height = width + 20 //ratio
                return CGSize(width: width, height: height)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if (collectionView == collectionViewFirst) {
            print(giftList[indexPath.row].id)
            print("The top collection view index selected is: \(indexPath.row)")
            selectedHeaderIndex = indexPath.row
            print("The selected header index is: \(selectedHeaderIndex)")
            selectedGiftIndex = 0
            collectionViewFirst.reloadData()
            collectionViewSecond.reloadData()
            print("The selected gift category id is:\(giftList[selectedHeaderIndex].id)")
        } else if (collectionView == collectionViewSecond) {
            print("The below or gift collection view index selected is: \(indexPath.row)")
            selectedGiftIndex = indexPath.row
            print("The selected gift index is: \(selectedGiftIndex)")
            print("The selected gift data is:\(giftList[selectedHeaderIndex].gifts?[indexPath.row])")
            collectionViewSecond.reloadData()
            collectionViewFirst.reloadData()
        }

    }
    
    func setControlPage() {
        if (giftList[selectedHeaderIndex].gifts?.count ?? 0)%8 > 0 {
            pageControl.numberOfPages = (giftList[selectedHeaderIndex].gifts?.count ?? 0)/8 + 1
        } else {
            pageControl.numberOfPages = (giftList[selectedHeaderIndex].gifts?.count ?? 0)/8
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        collectionViewSecond.collectionViewLayout.invalidateLayout()
        collectionViewSecond.setNeedsLayout()
        collectionViewSecond.layoutIfNeeded()
      //  collectionViewSecond.reloadData()
//        collectionViewSecond.setNeedsLayout()
//        collectionViewSecond.layoutIfNeeded()

        
        if scrollView == collectionViewSecond {
            let pageWidth = collectionViewSecond.frame.size.width / 4 // Assuming 4 cells per page
            let currentPage = Int(scrollView.contentOffset.x / pageWidth)
            pageControl.currentPage = currentPage
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        collectionViewSecond.collectionViewLayout.invalidateLayout()
        collectionViewSecond.setNeedsLayout()
        collectionViewSecond.layoutIfNeeded()
      //  collectionViewSecond.reloadData()
        

        
        if scrollView == collectionViewSecond {
            let pageWidth = collectionViewSecond.frame.size.width / 4 // Assuming 4 cells per page
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = currentPage
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           if collectionView == collectionViewSecond {
               return 0
           }
           return 0 // Set the minimum interitem spacing to zero for both collection views
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           if collectionView == collectionViewSecond {
               return 0
           }
           return 0 // Set the minimum line spacing to zero for both collection views
       }

}

// MARK: - EXTENSION FOR API CALLING AND GETTING GIFT'S LIST AND SENDING GIFT API CALLED FROM HERE

extension ShowGiftViewController {
    
    func getGiftsData() {
        
        ApiWrapper.sharedManager().getGiftsList(url: AllUrls.getUrl.getAllGifts) { [weak self] (data, value) in
            guard let self = self else { return }
         
            
            if (value["success"] as? Bool == true) {
                print(data)
                print(value)
                
                print(data?.count)
                giftList = data ?? giftList
                print("The gift list is: \(giftList)")
                print("The data in first category of list is: \(giftList[0].gifts?.count)")
                
            } else {
                
                print("Image wale data main success false aa rha hai")
                
            }
            collectionViewFirst.reloadData()
            collectionViewSecond.reloadData()
        }
    }
    
    func sendGift(params: [String: Any], completion: @escaping (Bool) -> Void) {
        print("The params for gift Sending to host is: \(params)")

        ApiWrapper.sharedManager().sendGiftToHost(url: AllUrls.getUrl.sendGift, parameters: params, completion: { [weak self] (data) in
            guard let self = self else {
                // The object has been deallocated
                completion(false)
                return
            }

            if let success = data["success"] as? Bool, success {
                print(data)
                print("Sab kuch sahi hai")
                print("The coin left in my account is: \(data["result"] as? Int)")
                if let totalCoins = data["result"] as? Int {
                    lblTotalCoins.text = "\(totalCoins) >"
                    UserDefaults.standard.set(String(totalCoins) , forKey: "coins")
                    
                } else {
                    // Handle the case where "result" is not an Int or is nil
                    lblTotalCoins.text = "N/A >"
                }

                if let maleCashbackCoins = data["male_lucky_reward_point"] as? Int {
                  print("The cashback coins for male is: \(maleCashbackCoins)")
                    if (maleCashbackCoins > 0) {
                        print("Lucky gift wale ko show karenge")
                        let name = giftList[selectedHeaderIndex].gifts?[selectedGiftIndex].giftName ?? "N/A"
                        delegate?.showLuckyGift(giftName: name, amount: maleCashbackCoins)
                        
                    } else {
                        print("Lucky gift wale ko show nahi karenge")
                    }
                    
                } else {
                    // Handle the case where "result" is not an Int or is nil
                   print("Male cashback coins khali hai. Zero kar do inko.")
                    
                }
                
                if let femaleCashbackCoins = data["female_lucky_reward_point"] as? Int {
                  print("The cashback coins for female is: \(femaleCashbackCoins)")
                    
                    giftAmountPK = femaleCashbackCoins
                    
                    
                } else {
                    // Handle the case where "result" is not an Int or is nil
                   print("female cashback coins khali hai. Zero kar do inko.")
                    
                }
                
                completion(true)
            } else {
                print(data["error"])
                print("Kuch error hai")
                completion(false)
            }
        })
    }
}


//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == collectionViewSecond {
//            let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
//            pageControl.currentPage = currentPage
//        }
//    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == collectionViewSecond {
//            let pageWidth = collectionViewSecond.frame.size.width / 4 // 4 cells per page
//            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
//            pageControl.currentPage = currentPage
//        }
//    }

//        let nodeName =  ZLFireBaseManager.share.messageRef.childByAutoId().key ?? generateRandomString(length: 20)
////        ZLFireBaseManager.share.messageRef.childByAutoId().key
//
//        ZLFireBaseManager.share.messageRef.child("message").child(String(format: "%d", sendUserModel.profileID ?? 0)).child(nodeName).setValue(dic) { [weak self] (error, reference) in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("Error writing data: \(error)")
//            } else {
//                print("Gift Message post written successfully on firebase.")
//                print(self.cameFrom)
//                if (self.cameFrom == "live") {
//                    print("Kuch nahi krna hai iss case main.")
//                } else {
//                    print("Iss case mai delegate call krenge kyunki gift pk mai bheja hai.")
//                    print(model.animationType)
//                    if (giftList[selectedHeaderIndex].id == 3) {
//                        self.delegate?.pkGiftSent(giftAmount: giftAmountPK, userName: (UserDefaults.standard.string(forKey: "UserName") ?? ""), userImage:  (UserDefaults.standard.string(forKey: "profilePicture") ?? ""), userID: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), from: self.cameFrom)
//                    } else {
//                        self.delegate?.pkGiftSent(giftAmount: (model.amount ?? 0), userName: (UserDefaults.standard.string(forKey: "UserName") ?? ""), userImage:  (UserDefaults.standard.string(forKey: "profilePicture") ?? ""), userID: (UserDefaults.standard.string(forKey: "UserProfileId") ?? ""), from: self.cameFrom)
//                    }
//                }
//            }
//        }
