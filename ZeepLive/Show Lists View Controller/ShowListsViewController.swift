//
//  ShowListsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 10/05/23.
//

import UIKit
import Kingfisher
import SwiftyJSON

class ShowListsViewController: UIViewController, delegateShowListsTableViewCell {
   
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    lazy var followType: String = "2"
    lazy var pageNo:Int = 1
    lazy var userId = Int()
    
    lazy var userFollowingList = userFollowingListResult()
    lazy var userFollowersList = userFollowersListResult()
    lazy var userFriendsList = userFriendListResult()
    
    lazy var lastPageNo = Int()
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        print(followType)
        getUserFollowersList()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "ShowListsTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowListsTableViewCell")
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        
        print("Back Button Pressed")
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        
    }
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS TO SHOW DATA IN TABLE VIEW CELL

extension ShowListsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (followType == "1") {
         
            return userFollowingList.data?.count ?? 0
            
        } else if (followType == "2") {
            
            return userFollowersList.data?.count ?? 0
            
        } else if (followType == "3") {
            
            return userFriendsList.data?.count ?? 0
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowListsTableViewCell", for: indexPath) as! ShowListsTableViewCell
            
        if (followType == "1") {
            
            cell.btnFollowOutlet.setTitle("Following", for: .normal)
            
            let a: Int = userFollowingList.data?[indexPath.row].followingData?.level ?? 0
            var b : String = String(a)
            
            cell.lblUserName.text = userFollowingList.data?[indexPath.row].followingData?.name
            cell.lblLevel.text = b
            
            if (userFollowingList.data?[indexPath.row].followingData?.profileImages?.count == 0) || (userFollowingList.data?[indexPath.row].followingData?.profileImages == nil) {
                print("Ismain image nahi hai andar nahi jaana hai")
                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                
            } else {
                
            if let profileImageURL = URL(string: userFollowingList.data?[indexPath.row].followingData?.profileImages?[0].imageName ?? "") {
                KF.url(profileImageURL)
                   // .downsampling(size: CGSize(width: 200, height: 200))
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
        }
            if let yearDifference = calculateYearDifference(from: userFollowingList.data?[indexPath.row].followingData?.dob ?? " ") {
                print("Year difference: \(yearDifference)")
                cell.lblAge.text = String(yearDifference)
            } else {
                cell.lblAge.text = "0"
                print("Invalid date format")
            }
            
            if (userFollowingList.data?[indexPath.row].followingData?.isFollowing == true) {
                
                cell.btnFollowOutlet.layer.cornerRadius = 10
                cell.btnFollowOutlet.layer.borderWidth = 0.5
                cell.btnFollowOutlet.layer.borderColor = UIColor.darkGray.cgColor
                cell.btnFollowOutlet.backgroundColor = .white
                cell.btnFollowOutlet.setTitleColor(.darkGray, for: .normal)
                cell.isFollowButtonPressed = true
                cell.btnFollowOutlet.setTitle("Following", for: .normal)
                
            } else {
                
                cell.btnFollowOutlet.layer.cornerRadius = 10
                cell.btnFollowOutlet.backgroundColor = .systemPink
                cell.btnFollowOutlet.setTitleColor(.white, for: .normal)
                cell.btnFollowOutlet.layer.borderWidth = 0
                cell.isFollowButtonPressed = false
                cell.btnFollowOutlet.setTitle("Follow", for: .normal)
                
            }
            
        }  else if (followType == "2") {
            
            cell.btnFollowOutlet.setTitle("Followers", for: .normal)
            
              let a: Int = userFollowersList.data?[indexPath.row].userDataFollower?.level ?? 0
              var b : String = String(a)
          
              cell.lblUserName.text = userFollowersList.data?[indexPath.row].userDataFollower?.name
              cell.lblLevel.text = b
          
            if (userFollowersList.data?[indexPath.row].userDataFollower?.profileImages?.count == 0) || (userFollowersList.data?[indexPath.row].userDataFollower?.profileImages == nil) {
                
                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
            } else {
                if let profileImageURL = URL(string: userFollowersList.data?[indexPath.row].userDataFollower?.profileImages?[0].imageName ?? "") {
                    KF.url(profileImageURL)
                   //     .downsampling(size: CGSize(width: 200, height: 200))
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
            }
          
            if let yearDifference = calculateYearDifference(from: userFollowersList.data?[indexPath.row].userDataFollower?.dob ?? "") {
                print("Year difference: \(yearDifference)")
                cell.lblAge.text = String(yearDifference)
            } else {
                cell.lblAge.text = "0"
                print("Invalid date format")
            }
            
            if (userFollowersList.data?[indexPath.row].userDataFollower?.isFollower == true) {
                
                cell.btnFollowOutlet.layer.cornerRadius = 10
                cell.btnFollowOutlet.layer.borderWidth = 0.5
                cell.btnFollowOutlet.layer.borderColor = UIColor.darkGray.cgColor
                cell.btnFollowOutlet.backgroundColor = .white
                cell.btnFollowOutlet.setTitleColor(.darkGray, for: .normal)
                cell.isFollowButtonPressed = true
                cell.btnFollowOutlet.setTitle("Friend", for: .normal)
                
            } else {
                
                cell.btnFollowOutlet.layer.cornerRadius = 10
                cell.btnFollowOutlet.backgroundColor = .systemPink
                cell.btnFollowOutlet.setTitleColor(.white, for: .normal)
                cell.btnFollowOutlet.layer.borderWidth = 0
                cell.isFollowButtonPressed = false
                cell.btnFollowOutlet.setTitle("Follow Back", for: .normal)
                
                
            }
            
        } else if (followType == "3") {
            
            cell.btnFollowOutlet.setTitle("Friends", for: .normal)
            
              let a: Int = userFriendsList.data?[indexPath.row].userDataFollower?.level ?? 0
               var b : String = String(a)
          
              cell.lblUserName.text = userFriendsList.data?[indexPath.row].userDataFollower?.name
              cell.lblLevel.text = b
         
            if (userFriendsList.data?[indexPath.row].userDataFollower?.profileImages?.count == 0) || (userFriendsList.data?[indexPath.row].userDataFollower?.profileImages == nil) {
                print("Ismain images nahi hai ismain by default vali image dalenge")
                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                
            } else {
                if let profileImageURL = URL(string: userFriendsList.data?[indexPath.row].userDataFollower?.profileImages?[0].imageName ?? "") {
                    KF.url(profileImageURL)
              //          .downsampling(size: CGSize(width: 200, height: 200))
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
            }
            if let yearDifference = calculateYearDifference(from: userFriendsList.data?[indexPath.row].userDataFollower?.dob ?? "") {
                print("Year difference: \(yearDifference)")
                cell.lblAge.text = String(yearDifference)
            } else {
                cell.lblAge.text = "0"
                print("Invalid date format")
            }
            
            if (userFriendsList.data?[indexPath.row].userDataFollower?.isFriend == true) {
                
                cell.btnFollowOutlet.layer.cornerRadius = 10
                cell.btnFollowOutlet.layer.borderWidth = 0.5
                cell.btnFollowOutlet.layer.borderColor = UIColor.darkGray.cgColor
                cell.btnFollowOutlet.backgroundColor = .white
                cell.btnFollowOutlet.setTitleColor(.darkGray, for: .normal)
                cell.isFollowButtonPressed = true
                cell.btnFollowOutlet.setTitle("Friend", for: .normal)
                
                
            } else {
                
                cell.btnFollowOutlet.layer.cornerRadius = 10
                cell.btnFollowOutlet.backgroundColor = .systemPink
                cell.btnFollowOutlet.setTitleColor(.white, for: .normal)
                cell.btnFollowOutlet.layer.borderWidth = 0
                cell.isFollowButtonPressed = false
                cell.btnFollowOutlet.setTitle("Follow Back", for: .normal)
                
            }
            
        }
        
        cell.delegate = self
        cell.btnFollowOutlet.tag = indexPath.row
        
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        if (followType == "1") {
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
            nextViewController.userID = String(userFollowingList.data?[indexPath.row].followingData?.id ?? 0)
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        } else if (followType == "2") {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
            nextViewController.userID = String(userFollowersList.data?[indexPath.row].userDataFollower?.id ?? 0)
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        } else if (followType == "3") {
           
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
            nextViewController.userID = String(userFriendsList.data?[indexPath.row].userDataFollower?.id ?? 0)
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
    }
    
    func buttonClicked(index: Int, isPressed:Bool) {
        
        print(index)
        print(isPressed)
        
        if (followType == "1") {
            
            print("Following")
            userId = (userFollowingList.data?[index].followingData?.id ?? 0)
            
            follow()
           
            if isPressed == true {
                
                userFollowingList.data?[index].followingData?.isFollowing = true
                
            } else {
                
                userFollowingList.data?[index].followingData?.isFollowing = false
                
            }
            
            tblView.reloadData()
            
        } else if (followType == "2") {
            
            print("Followers")
            userId = (userFollowersList.data?[index].userDataFollower?.id ?? 0)
            
            follow()
            
            if isPressed == true {
                
                userFollowersList.data?[index].userDataFollower?.isFollower = true
                
            } else {
                
                userFollowersList.data?[index].userDataFollower?.isFollower = false
                
            }
             
        }  else if (followType == "3") {
            
            print("Friends")
            userId = (userFriendsList.data?[index].userDataFollower?.id ?? 0)
            
            follow()
            
            if isPressed == true {
                
                userFriendsList.data?[index].userDataFollower?.isFriend = true
                
            } else {
                
                userFriendsList.data?[index].userDataFollower?.isFriend = false
                
            }
            
        }
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM SERVER

extension ShowListsViewController {
   
    func getUserFollowersList() {
        let url = AllUrls.baseUrl + "getfollowFollowerCount1?follow_type=\(followType)&page=\(pageNo)"
        print(url)
        
        ApiWrapper.sharedManager().getUserFollowersList(url: url) { [weak self] (value) -> Void in
            guard let self = self else { return }
            
            print(value)
           
            if let result = value["result"] as? [String: Any] {
                let lastPage = result["last_page"] as? Int
                print("Last page: \(lastPage)")
                lastPageNo = lastPage ?? 1
                print(lastPageNo)
            } else {
                print("Failed to retrieve the last page.")
            }
            
            do {
                let jsonData = JSON(value)
                print(jsonData)
                
                if (followType == "1") {
                    lblTopHeading.text = "Following"
                    
                    let decodeData = try jsonData["result"].rawData()
                    let gaReportData = try JSONDecoder().decode(userFollowingListResult.self, from: decodeData)
                    print(gaReportData)     
                    
                    if let userFollowing = gaReportData.data {
                               print(userFollowing)
                               
                               if userFollowingList.data == nil {
                                   userFollowingList.data = userFollowing
                    
                               } else {
                                   userFollowingList.data?.append(contentsOf: userFollowing)
                                  
                               }
                               
                                   print(userFollowingList.data?.count)
                                    tblView.reloadData()
                               
                           }
                    
                 //   userFollowingList = gaReportData
                    print(userFollowingList)
                    
                } else if (followType == "2") {
                    lblTopHeading.text = "Followers"
                    
                    let decodeData = try jsonData["result"].rawData()
                    let gaReportData = try JSONDecoder().decode(userFollowersListResult.self, from: decodeData)
                    print(gaReportData)
                    
                    if let userFollowList = gaReportData.data {
                               print(userFollowList)
                               
                               if userFollowersList.data == nil {
                                   userFollowersList.data = userFollowList
                    
                               } else {
                                   userFollowersList.data?.append(contentsOf: userFollowList)
                                  
                               }
                               
                                   print(userFollowersList.data?.count)
                                    tblView.reloadData()
                               
                           }
                    
                    print(userFollowersList)
                    
                } else if (followType == "3") {
                    lblTopHeading.text = "Friends"
                    
                    let decodeData = try jsonData["result"].rawData()
                    let gaReportData = try JSONDecoder().decode(userFriendListResult.self, from: decodeData)
                    print(gaReportData)
                   
                    if let userFriendList = gaReportData.data {
                               print(userFriendList)
                               
                               if userFriendsList.data == nil {
                                   userFriendsList.data = userFriendList
                    
                               } else {
                                   userFriendsList.data?.append(contentsOf: userFriendList)
                                  
                               }
                               
                                   print(userFriendsList.data?.count)
                                    tblView.reloadData()
                               
                           }
                    
                    print(userFriendsList)
                }
                
                print(value)
                
                tblView.reloadData()
            } catch {
                print("Error: \(error)")
                // Handle the error appropriately
            }
        }
    }
}

// MARK: - EXTENSION FOR API CALLING FOR FOLLOW AND UNFOLLOW

extension ShowListsViewController {
    
    func follow() {
      
      let params = [
          "following_id": userId
         
      ] as [String : Any]
      
      
      ApiWrapper.sharedManager().followUser(url: AllUrls.getUrl.followUser,parameters: params) { [weak self] (data) in
          guard let self = self else { return }
          
          if (data["success"] as? Bool == true) {
              print(data)
           
              let a = data["result"] as! String
              print(a)
              
              let alert = UIAlertController(title: "Success !", message: a , preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            
              self.present(alert, animated: true, completion: nil)
              
              print("sab shi hai. kuch gadbad nahi hai")
         //     showAlertwithButtonAction(title: "SUCCESS !", message: "Your Profile has been updated successfully", viewController: self)
              
          }  else {
              
              print("Kuch gadbad hai")
              
          }
      }
  }
    
}

// MARK: - EXTENSION FOR USING SCROLL VIEW DELEGATES AND METHODS

extension ShowListsViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

            print("scrollViewWillBeginDragging")
            isDataLoading = false
        }
    
    
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

                print("scrollViewDidEndDragging")
            
}

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scroll view decelerate ho rha hai")
        
        if ((tblView.contentOffset.y + tblView.frame.size.height + 200) >= tblView.contentSize.height)
            
        {

               if !isDataLoading{
                   if didEndReached == true {
                       print("data load ni krana hai")
                   } else {
                       pageNo += 1
                       print(pageNo)
                       
                       if (pageNo <= lastPageNo) {
                           isDataLoading = true
                           print("Ab Call Krana Hai")
                           getUserFollowersList()
                           //tblView.reloadData()
                       } else {
                           print("Ye last page hai ... isliye api call nahi krani hai")
                          
                       }
                   }
               }
        }
    }
}

