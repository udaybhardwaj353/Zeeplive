//
//  JoinedAudienceListViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 19/01/24.
//

import UIKit
import Kingfisher
import ImSDK_Plus

protocol delegateJoinedAudienceListViewController: AnyObject {

    func userData(selectedUserIndex:Int)
    
}

class JoinedAudienceListViewController: UIViewController {

    @IBOutlet weak var lblViewersCount: UILabel!
    @IBOutlet weak var viewDashLine: UIView!
    @IBOutlet weak var tblView: UITableView!
  //  var groupUsers = [joinedGroupUserProfile]()
    weak var delegate: delegateJoinedAudienceListViewController?
    var userInfoList: [V2TIMUserFullInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
       tableViewWork()
    //    print("The group join users count is: \(groupUsers.count)")
        
    }

    func tableViewWork() {
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "JoinedAudienceListTableViewCell", bundle: nil), forCellReuseIdentifier: "JoinedAudienceListTableViewCell")
        
    }
    
    func configureUI() {
    
        viewDashLine.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        lblViewersCount.text = "Viewers" + " " + String(userInfoList?.count ?? 0)
     //   lblViewersCount.text = "Viewers" + " " + String(groupUsers.count)
        // Add this observer, usually in viewDidLoad or viewWillAppear
        NotificationCenter.default.addObserver(self, selector: #selector(handleGroupJoinUsersUpdate(_:)), name: Notification.Name("groupJoinUsersUpdated"), object: nil)

    }
    
    @objc func handleGroupJoinUsersUpdate(_ notification: Notification) {
        // Assuming userInfoList is a property of your class
        if let userInfoListFromNotification = notification.object as? [V2TIMUserFullInfo] {
            userInfoList?.removeAll()
            userInfoList = userInfoListFromNotification
            print("The groupUsers count in view controller is: \(userInfoList?.count)")
            lblViewersCount.text = "Viewers" + " " + String(userInfoList?.count ?? 0)
            tblView.reloadData()
        } else {
            print("Invalid or missing userInfoList in the notification.")
        }
      //  tblView.reloadData()
    }

    deinit {
        
        tblView.delegate = nil
        tblView.dataSource = nil
        tblView = nil
       // groupUsers.removeAll()
        userInfoList?.removeAll()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("groupJoinUsersUpdated"), object: nil)
         print("Joined audience list view controller main deinit par aaya hai")
        
    }
}

extension JoinedAudienceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return userInfoList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "JoinedAudienceListTableViewCell", for: indexPath) as! JoinedAudienceListTableViewCell
        
        cell.lblUserName.text = userInfoList?[indexPath.row].nickName ?? "N/A"
        cell.lblUserLevel.text = String(format: "Lv%i", userInfoList?[indexPath.row].level ?? 0) //String(groupUsers[indexPath.row].level ?? 0)
        
        if (userInfoList?[indexPath.row].gender.rawValue == 1) {
            cell.imgViewGender.image = UIImage(named: "maleimage")
        } else {
            cell.imgViewGender.image = UIImage(named: "femaleimage")
        }
        
        if let imageURL = URL(string: userInfoList?[indexPath.row].faceURL ?? "") {
            KF.url(imageURL)
              //  .downsampling(size: CGSize(width: 200, height: 200))
                .cacheOriginalImage()
                .onSuccess { result in
                    DispatchQueue.main.async {
                        cell.imgViewUserPhoto.image = result.image
                    }
                }
                .onFailure { error in
                    print("Image loading failed with error: \(error)")
                    cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                }
                .set(to: cell.imgViewUserPhoto)
        } else {
            cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
        }
        
        
            cell.selectionStyle = .none
            return cell
        
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 78
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The selected index in user watching broad is: \(indexPath.row)")
//        print("The selected index data in user watching broad is: \(groupUsers[indexPath.row])")
        delegate?.userData(selectedUserIndex: indexPath.row)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileDetailsViewController") as! ProfileDetailsViewController
//        nextViewController.userId = groupUsers[indexPath.row].userID ?? ""
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
}

//    func showJoinedUser(users: [joinedGroupUserProfile]) {
//        print(users.count)
//        groupUsers.removeAll()
//        groupUsers = users
//        print("The groupUsers count in view controller is: \(groupUsers.count)")
//        tblView.reloadData()
//        lblViewersCount.text = "Viewers" + " " + String(groupUsers.count)
//
//    }
