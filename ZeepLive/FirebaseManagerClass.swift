//
//  FirebaseManagerClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 15/01/24.
//

import Foundation
import Firebase
import FirebaseDatabase

class ZLFireBaseManager: NSObject {
    
    static let share = ZLFireBaseManager()
    
    var userRef: DatabaseReference!
    var messageRef: DatabaseReference!
    var rankRef: DatabaseReference!
    var coHostRef: DatabaseReference!
    var pkRequestRef: DatabaseReference!
    var pkRef: DatabaseReference!
    
    override init() {
        super.init()
        
            userRef = Database.database(url: "https://zeeplivechat-dcacf-6fe47.firebaseio.com").reference()
            messageRef = Database.database(url: "https://zeeplive-rtchat.asia-southeast1.firebasedatabase.app").reference()
            rankRef = Database.database(url: "https://zeeplive-hourly-rewards.asia-southeast1.firebasedatabase.app").reference()
            coHostRef = Database.database(url: "https://zeeplive-co-host-invite.asia-southeast1.firebasedatabase.app").reference()
            pkRequestRef = Database.database(url: "https://zeeplive-pk-invite.asia-southeast1.firebasedatabase.app/").reference()
            pkRef = Database.database(url: "https://zeeplive-pk-request.asia-southeast1.firebasedatabase.app/").reference()
        
    }
    
    func writeDataToFirebaseEndPK(data: [String : Any],id:String) {
        
        let pID = UserDefaults.standard.string(forKey: "UserProfileId")
        
//        guard !id.isEmpty, id == nil else {
//            print("Error: The id is either empty or contains invalid characters.")
//            return
//        }
        
     //   if let pID = pID {
            ZLFireBaseManager.share.userRef.child("UserStatus").child(id).updateChildValues(data) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Online Details written successfully on firebase.")
                }
            }
            
       // }
    }
    
    func writeDataToFirebaseForPK(data: [String : Any], id:String) {
     
     //   let pID = UserDefaults.standard.string(forKey: "UserProfileId")
        
       // if let pID = pID {
        print("the id pk is: \(id)")
        print("the data pk is: \(data)")
        
//        guard !id.isEmpty, id == nil else {
//            print("Error: The id is either empty or contains invalid characters.")
//            return
//        }
            ZLFireBaseManager.share.userRef.child("UserStatus").child(id).setValue(data) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Online Details written successfully on firebase.")
                }
            }
            
     //   }
    }
    
    func updateUserStatusToPKRequestFirebase(status: String,pkid:String) {
        
      //  let pID = UserDefaults.standard.string(forKey: "UserProfileId")
        
      //  if let pID = pID {
        
//        guard !pkid.isEmpty, pkid == nil else {
//            print("Error: The id is either empty or contains invalid characters.")
//            return
//        }
        
            ZLFireBaseManager.share.pkRef.child(pkid).child("status").setValue(status) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Online Details written successfully on firebase.")
                }
            }
            
       // }
    }
    
    func writeDataToPKFirebase(data: [String : Any],pkid:String) {
        
        print("The write data to pk firebase data is: \(data)")
        print("THe write daata pkid is: \(pkid)")
      //  let pID = UserDefaults.standard.string(forKey: "UserProfileId")
        
       // if let pID = pID {
        // Use guard to ensure the `pkid` is not empty and doesn't contain invalid characters
           guard !pkid.isEmpty, pkid == nil else {
               print("Error: The pkid is either empty or contains invalid characters.")
               return
           }
        
            ZLFireBaseManager.share.pkRef.child(pkid).setValue(data) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("Data written successfully on firebase in PK Request Node.")
                }
            }
            
      //  }
    }
    
    
    func writeDataToFirebase(data: [String : Any]) {
        
        let pID = UserDefaults.standard.string(forKey: "UserProfileId")
        
        if let pID = pID {
            ZLFireBaseManager.share.userRef.child("UserStatus").child(pID).setValue(data) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Online Details written successfully on firebase.")
                }
            }
            
        }
    }
    
    func updateUserStatusToFirebase(status: String) {
        
        let pID = UserDefaults.standard.string(forKey: "UserProfileId")
        
        if let pID = pID {
            ZLFireBaseManager.share.userRef.child("UserStatus").child(pID).child("status").setValue(status) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Online Details written successfully on firebase.")
                }
            }
            
        }
    }
 
    // Mark - Function to update my host total coins on firebase node in pk
    func updateMyUserPKGiftCoinsToFirebase(hostid: String, totalAmount:Int) {
        
        print("The host id is: \(hostid)")
        
//        guard !hostid.isEmpty, hostid == nil, hostid == "0" else {
//            print("Error: The id is either empty or contains invalid characters.")
//            return
//        }
        
            ZLFireBaseManager.share.userRef.child("UserStatus").child(String(hostid)).child("pk_myside_gift_coins").setValue(totalAmount) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User PK GIFT Details written successfully on firebase.")
                }
            }
    }
   
    // Mark - Function to update opponent host total coins on firbase node in pk
    func updateOpponentUserPKGiftCoinsToFirebase(hostid: Int, totalAmount:Int) {
        
            ZLFireBaseManager.share.userRef.child("UserStatus").child(String(hostid)).child("pk_opponent_gift_coins").setValue(totalAmount) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Online Details written successfully on firebase.")
                }
            }
    }
   
    // Mark - Function to update the my user detail to firebase who has sent the gift
    func updatePKGiftUserDetailToFirebase(hostid: String,updateTo:String = "User3", value:[String:Any]) {
        
        print("The host id is: \(hostid)")
        
//        guard !hostid.isEmpty, hostid == nil, hostid == "0" else {
//            print("Error: The id is either empty or contains invalid characters.")
//            return
//        }
        
        ZLFireBaseManager.share.userRef.child("UserStatus").child(String(hostid)).child("pk_my_side_gifted_users").child(updateTo).setValue(value) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User PK Gift  Details written successfully on firebase.")
                }
            }
    }
    
    // Mark - Function to update the opponent user detail to firebase qho has sent gift from opponent side
    func updateOpponentPKGiftUserDetailToFirebase(hostid: Int, updateTo:String = "User3",value:[String:Any]) {
        
        ZLFireBaseManager.share.userRef.child("UserStatus").child(String(hostid)).child("pk_opponent_side_gifted_users").child("User1").setValue(value) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Online Details written successfully on firebase.")
                }
            }
    }
    
   // Mark - Function to update the user invite request status to the firebase
    func updateCoHostInviteStatusToFirebase(userid: String,status:String) {
        
        guard let hostid = UserDefaults.standard.string(forKey: "UserProfileId") else {
            // Handle the case where currentUserProfileID is nil
            return
        }
        
        ZLFireBaseManager.share.coHostRef.child("sub-cohost-invite-details").child(String(hostid)).child(userid).child("status").setValue(status) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Invite Status written successfully on firebase.")
                }
            }
    }
    
   // MARK - Function to send data to the firebase for sending the invitation to the host for join mic in Broad
    
    func sendCoHostInviteToFirebase(userid: String,parameter:[String:Any],hostid:Int) {
        
//        guard let hostid = UserDefaults.standard.string(forKey: "UserProfileId") else {
//            // Handle the case where currentUserProfileID is nil
//            return
//        }
        
//        guard !userid.isEmpty, userid == nil, userid == "0" else {
//            print("Error: The id is either empty or contains invalid characters.")
//            return
//        }
        
        ZLFireBaseManager.share.coHostRef.child("sub-cohost-invite-list").child(String(hostid)).child(userid).setValue(parameter) { [weak self] (error, reference) in
                
                guard let self = self else {
                    // self is nil, probably deallocated
                    return
                }
                
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("User Invite Status written successfully on firebase.")
                }
            }
    }
    
    // Mark - Function to update the user invite request status to the firebase
     func updateCoHostInviteStatusToFirebaseForUser(hostid: String,status:String) {
         
         guard let userid = UserDefaults.standard.string(forKey: "UserProfileId") else {
             // Handle the case where currentUserProfileID is nil
             return
         }
         
         ZLFireBaseManager.share.coHostRef.child("sub-cohost-invite-details").child(String(hostid)).child(userid).child("status").setValue(status) { [weak self] (error, reference) in
                 
                 guard let self = self else {
                     // self is nil, probably deallocated
                     return
                 }
                 
                 if let error = error {
                     print("Error writing data: \(error)")
                 } else {
                     print("User Invite Status written successfully on firebase.")
                 }
             }
     }
    
    
    
//    ------------------------------------>
    
    // writeUserStatusData
    func writeUserStatusData(userStatus: [String: Any]) {
        let pid = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        userRef.child("UserStatus").child(pid).setValue(userStatus) { (error, reference) in
            if let error = error {
                print("Error writing data: \(error)")
            } else {
                print("First post data written successfully")
            }
        }
    }
    
    // writeUserLiveData
    func writeUserLiveData(liveStatus: [String: Any]) {
        userRef.child("UserStatus").setValue(liveStatus) { (error, reference) in
            if let error = error {
                print("Error writing data: \(error)")
            } else {
                print("First post data written successfully")
            }
        }
    }
    
    func writeMessageData(message: [String: Any]) {
        let pid = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        messageRef.child("message").child(pid).setValue(message) { (error, reference) in
            if let error = error {
                print("Error writing data: \(error)")
            } else {
                print("First post data written successfully")
            }
        }
    }
    
    
    // updateUserStatusData
    func updateUserStatusData(dic: [String: Any]) {
        ZLFireBaseManager.share.userRef.child("UserStatus").child(UserDefaults.standard.string(forKey: "UserProfileId") ?? "").updateChildValues(dic) { (error, ref) in
            if let error = error {
                print("Error updating data: \(error.localizedDescription)")
            } else {
                print("Multiple fields updated successfully")
            }
        }
    }
    
    func updateMessageData(dic: [String: Any]) {
        ZLFireBaseManager.share.userRef.child("UserStatus").child(UserDefaults.standard.string(forKey: "UserProfileId") ?? "").updateChildValues(dic) { (error, ref) in
            if let error = error {
                print("Error updating data: \(error.localizedDescription)")
            } else {
                print("Multiple fields updated successfully")
            }
        }
    }
    
    
    // changeUserStatus
//    func changeUserStatus(status: String) {
//        if ZLUserManager.share.isLogin ?? false {
//            ZLFireBaseManager.share.userRef.child("UserStatus").child(UserDefaults.standard.string(forKey: "UserProfileId") ?? "").child("status").setValue(status) { (error, reference) in
//                if let error = error {
//                    print("Error writing data: \(error)")
//                } else {
//                    print("First post data written successfully")
//                }
//            }
//        }
//    }
    
    
    
    func startSteamWrite(broadId : String,channelName : String){
        var userStatus = [String: Any]()
        var dic = [String: Any]()
        dic["broadId"] = broadId
        dic["channelName"] = channelName
        dic["status"] = "Live"
        dic["weeklyPoints"] = "0"
        updateUserStatusData(dic: dic)
    }
    
    func writePKMessageData(message: [String: Any],pid : String) {
        userRef.child("PKmessage").child(pid).child(UUID().uuidString).setValue(message) { (error, reference) in
            if let error = error {
                print("Error writing data: \(error)")
            } else {
                print("First post data written successfully")
            }
        }
    }
}
