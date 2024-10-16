//
//  MessageViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/01/24.
//

import UIKit
import RealmSwift

class MessageViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    let realm = try? Realm()
    
   lazy var arrUserNames = [String]()
   lazy var arrLastMessages = [String]()
   lazy var arrMessageTime = [String]()
   lazy var arrUserCounter = [String]()
   lazy var arrUserID = [String]()
   lazy var arrUserImage = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       registerTableView()
        
    }
    
    func registerTableView() {
        
       // tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "UserMessageListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserMessageListTableViewCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        
        arrUserNames.removeAll()
        arrLastMessages.removeAll()
        arrUserCounter.removeAll()
        arrMessageTime.removeAll()
        arrUserImage.removeAll()
        arrUserID.removeAll()
        
        arrUserNames.append("System Message")
        arrLastMessages.append("Welcome to ZeepLive. Enjoy your trip and find your true love here! Do not reveal your personal information , or open any unknown links to avoid information theft and financial loss.")
        arrUserCounter.append("0")
        arrMessageTime.append("12:00 AM")
        arrUserImage.append("systemmessageimage")
        arrUserID.append("1")
        
        let userDetailsWithLastMessages = fetchAllUserDetailsWithLastMessages()

        for (userId, userDetail) in userDetailsWithLastMessages {
            print("User ID: \(userId), Last Message: \(userDetail.lastMessage?.text ?? "No last message")")
            print(userId)
            print(userDetail)
            print(userDetail.lastMessage)
            print(userDetail.lastMessage?["text"])
            arrUserNames.append(userDetail["userName"] as? String ?? "N/A")
            arrUserID.append(userDetail["userId"] as? String ?? "N/A")
            arrLastMessages.append(userDetail.lastMessage?["text"] as? String ?? " ")
            arrUserImage.append(userDetail["profilePhoto"] as? String ?? "")
        
            if (userDetail["counter"] as? String == "") {
                arrUserCounter.append("0")
            } else {
                arrUserCounter.append(userDetail["counter"] as? String ?? " ")
            }
        
            let date = userDetail.lastMessage?["timestamp"] as! Date
            let dateFormatter = DateFormatter()
        
            // Set the desired date format
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
            // Convert the date to a string
            let dateString = dateFormatter.string(from: date)
        
            print(dateString)
        
            if let formattedDate = dateFormatter.date(from: dateString) {
        
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
        
                let formattedTimeString = timeFormatter.string(from: formattedDate)
                print("Formatted Time: \(formattedTimeString)")
                arrMessageTime.append(formattedTimeString)
        
            } else {
                arrMessageTime.append("")
                print("Error formatting date")
            }
        }

       
        print("VIew will appear call hua hai. chat listing main")
        arrUserImage.reversed()
        tblView.reloadData()
        
    }
    
//    func fetchAllUserDetailsWithLastMessages() -> [String: (userDataDetail, String)] {
//        var userDetailsWithLastMessages: [String: (userDataDetail, String)] = [:]
//
//        let allUserDetails = realm.objects(userDataDetail.self)
//
//        for userDetail in allUserDetails {
//            if let lastMsg = userDetail.lastMessage?.text {
//                userDetailsWithLastMessages[userDetail.userId] = (userDetail, lastMsg)
//            }
//        }
//
//        return userDetailsWithLastMessages
//    }

    func fetchAllUserDetailsWithLastMessages() -> [String: userDataDetail] {
        
        var userDetailsWithLastMessages: [String: userDataDetail] = [:]

        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return [:]
           }
        
        // Fetch the UserProfileId from UserDefaults
        guard let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId") else {
            print("UserProfileId not found in UserDefaults")
            return userDetailsWithLastMessages
        }

        // Fetch mainDetail objects with specific mainID
        let mainDetails = realm.objects(mainDetail.self).filter("mainID == %@", userProfileId)
        print(mainDetails)
        
        if mainDetails.isEmpty {
            print("Messages wali detail nahi dikhani hai. Main ID nil hai ismain.")
            return userDetailsWithLastMessages
        }

        // Fetch userDataDetail objects where userMainID matches the UserProfileId
        let filteredUserDetails = realm.objects(userDataDetail.self).filter("userMainID == %@", userProfileId)
        
        print("Number of filtered user details: \(filteredUserDetails.count)")
        
        // Iterate through filtered user details and add those with last messages to the dictionary
        for userDetail in filteredUserDetails {
            if let _ = userDetail.lastMessage {
                userDetailsWithLastMessages[userDetail.userId] = userDetail
            }
        }
        
        return userDetailsWithLastMessages
    }

    
//    func fetchAllUserDetailsWithLastMessages() -> [String: userDataDetail] {
//        var userDetailsWithLastMessages: [String: userDataDetail] = [:]
//
//        // Fetch mainDetail objects with specific mainID
//           let mainDetails = realm.objects(mainDetail.self).filter("mainID == %@", UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
//            print(mainDetails)
//        
//        if (mainDetails.isEmpty) {
//            
//            print("Messages wali detail nahi dikhani hai. Main ID nil hai ismain.")
//            
//        } else {
//            let allUserDetails = realm.objects(userDataDetail.self)
//            
//            for userDetail in allUserDetails {
//                if let lastMsg = userDetail.lastMessage {
//                    userDetailsWithLastMessages[userDetail.userId] = userDetail
//                }
//            }
//        }
//        return userDetailsWithLastMessages
//    }
    
    func fetchAllUserDetails() -> [userDataDetail] {
        
        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return []
           }
        
        let userDetails = realm.objects(userDataDetail.self)
        return Array(userDetails)
    }

    func fetchLastMessagesForAllUsers() -> [String: Messages] {
        var lastMessages: [String: Messages] = [:]
        
        // Safely unwrap 'realm'
           guard let realm = realm else {
               print("Realm not found")
               return [:]
           }
        
        // Fetch the UserProfileId from UserDefaults
        guard let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId") else {
            print("UserProfileId not found in UserDefaults")
            return lastMessages
        }
        
        // Fetch userDataDetail objects where userMainID matches the UserProfileId
        let filteredUserDetails = realm.objects(userDataDetail.self).filter("userMainID == %@", userProfileId)
        
        // Check if mainDetails is empty
        let mainDetails = realm.objects(mainDetail.self).filter("mainID == %@", userProfileId)
        
        if mainDetails.isEmpty {
            print("Messages wali detail nahi dikhani hai. Main ID nil hai ismain.")
            return lastMessages
        }
        
        // Iterate through filtered user details and populate the dictionary
        print("Number of filtered user details: \(filteredUserDetails.count)")
        
        for userDetail in filteredUserDetails {
            if let lastMsg = userDetail.lastMessage {
                lastMessages[userDetail.userId] = lastMsg
                print("User ID: \(userDetail.userId), Last Message: \(lastMsg)")
            }
        }
        
        return lastMessages
    }

    
//    func fetchLastMessagesForAllUsers() -> [String: Messages] {
//        var lastMessages: [String: Messages] = [:]
//        let allUserDetails = realm.objects(userDataDetail.self)
//
//        // Fetch mainDetail objects with specific mainID
//           let mainDetails = realm.objects(mainDetail.self).filter("mainID == %@", UserDefaults.standard.string(forKey: "UserProfileId") ?? "")
//            print(mainDetails)
//        
//        if (mainDetails.isEmpty) {
//            
//            print("Messages wali detail nahi dikhani hai. Main ID nil hai ismain.")
//            return lastMessages
//        } else {
//            
//            print("Number of user details: \(allUserDetails.count)")
//            
//            for userDetail in allUserDetails {
//                print("User ID: \(userDetail.userId), Last Message: \(userDetail.lastMessage)")
//                if let lastMsg = userDetail.lastMessage {
//                    lastMessages[userDetail.userId] = lastMsg
//                    print("User ID: \(userDetail.userId), Last Message: \(lastMsg)")
//                }
//            }
//            
//            
//            return lastMessages
//        }
//    }
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return arrUserNames.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageListTableViewCell", for: indexPath) as! UserMessageListTableViewCell
        
        print("Message main array ki jo image hai woh hai: \(arrUserImage[indexPath.row])")
        
        if (arrUserImage[indexPath.row] == "") {
            cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
           
        } else {
            
            if (indexPath.row == 0) {
                cell.imgViewUserPhoto.image = UIImage(named: "systemmessageimage")
            } else {
                loadImage(from: arrUserImage[indexPath.row], into: cell.imgViewUserPhoto)
            }
        }
        cell.lblUserName.text = arrUserNames[indexPath.row]//"Prakhar Dixit"
        cell.lblMessage.text = arrLastMessages[indexPath.row]
        cell.lblTime.text = arrMessageTime[indexPath.row]
        cell.lblCounter.text = arrUserCounter[indexPath.row]
       // cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The indexpath.row selected is \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Chatting"
        vc.recieverUserId = arrUserID[indexPath.row]
        vc.recieverUserName = arrUserNames[indexPath.row]
        vc.recieverUserImage = arrUserImage[indexPath.row]
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
}


//let userDetailsWithLastMessages = fetchAllUserDetailsWithLastMessages()
//
//for (userId, userDetail) in userDetailsWithLastMessages {
//    print("User ID: \(userId), Last Message: \(userDetail.lastMessage?.text ?? "No last message")")
//    print(userId)
//    print(userDetail)
//    print(userDetail.lastMessage)
//    print(userDetail.lastMessage?["text"])
//    arrUserNames.append(userDetail["userName"] as? String ?? "N/A")
//    arrUserID.append(userDetail["userId"] as? String ?? "N/A")
//    arrLastMessages.append(userDetail.lastMessage?["text"] as? String ?? " ")
//    arrUserImage.append(userDetail["profilePhoto"] as? String ?? "")
//    
//    if (userDetail["counter"] as? String == "") {
//        arrUserCounter.append("0")
//    } else {
//        arrUserCounter.append(userDetail["counter"] as? String ?? " ")
//    }
//    
//    let date = userDetail.lastMessage?["timestamp"] as! Date
//    let dateFormatter = DateFormatter()
//
//    // Set the desired date format
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//    // Convert the date to a string
//    let dateString = dateFormatter.string(from: date)
//
//    print(dateString)
//    
//    if let formattedDate = dateFormatter.date(from: dateString) {
//
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "h:mm a"
//
//        let formattedTimeString = timeFormatter.string(from: formattedDate)
//        print("Formatted Time: \(formattedTimeString)")
//        arrMessageTime.append(formattedTimeString)
//
//    } else {
//        arrMessageTime.append("")
//        print("Error formatting date")
//    }
//}
