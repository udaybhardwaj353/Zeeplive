//
//  MomentImageViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/01/24.
//

import UIKit

class MomentImageViewController: UIViewController {
   
    @IBOutlet weak var tblView: UITableView!
  
    lazy var momentData = MomentResult()
    lazy var lastPageNo = Int()
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
    lazy var pageNo:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

       getListData()
       registerTableView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblView.reloadData()
    }
    
    func registerTableView() {
    
        self.navigationController?.navigationBar.isHidden = true
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "MomentTableViewCell", bundle: nil), forCellReuseIdentifier: "MomentTableViewCell")
        
    }
    
//    func showOptionsFromBelow() {
//       
//       let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//          let followButton = UIAlertAction(title: "Follow", style: .default, handler: { (action) -> Void in
//              print("Follow button tapped")
//             
//          })
//
//          let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
//              print("Cancel button tapped")
//          })
//
//          alertController.addAction(followButton)
//          alertController.addAction(cancelButton)
//
//        
//       self.navigationController?.present(alertController, animated: true, completion: nil)
//       
//   }
   
    deinit {
        
        tblView.dataSource = nil
        tblView.delegate = nil
        tblView = nil
        momentData = MomentResult()
        lastPageNo = 0
        isDataLoading = false
        didEndReached = false
        pageNo = 0
        
        self.removeFromParent()
        print("Moment Image main deinit call hua hai")
        
    }
    
}

extension MomentImageViewController: UITableViewDelegate, UITableViewDataSource, delegateMomentTableViewCell, delegateMomentCommentViewController {
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return momentData.data?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentTableViewCell", for: indexPath) as! MomentTableViewCell
        
        cell.btnGiftOutlet.tag = indexPath.row
        cell.btnCommentOutlet.tag = indexPath.row
        cell.btnLikeOutlet.tag = indexPath.row
        cell.btnFollowUserOutlet.tag = indexPath.row
        cell.delegate = self
        cell.imgViewPlayVideo.isHidden = true
        
        if (momentData.data?[indexPath.row].message == nil) || (momentData.data?[indexPath.row].message == "") {
            
            cell.collectionViewTopConstraints.constant = -20
            cell.collectionViewBottomConstraints.constant = 10
            
        } else {
        
            cell.collectionViewTopConstraints.constant = 10
            cell.collectionViewBottomConstraints.constant = 10
            
        }
        
        let momentType = momentData.data?[indexPath.row].type?.lowercased()
        print("The momentType is \(momentType)")
        
        if (momentType == "image") {

            if let momentImages = momentData.data?[indexPath.row].momentImages {
                cell.configure(with: momentImages, at: indexPath.row, of: momentType ?? "")
            }
        } else {
            if let momentVideo = momentData.data?[indexPath.row].momentVideo {
                cell.configureForVideo(with: momentVideo, at: indexPath.row, of: momentType ?? "")
            }
        }
        
//        if let momentImages = momentData.data?[indexPath.row].momentImages {
//            cell.configure(with: momentImages, at: indexPath.row, of: momentType ?? "")
//        }
            
        cell.lblUserName.text = momentData.data?[indexPath.row].userData?.name
        cell.lblUserMessage.text = momentData.data?[indexPath.row].message
        
        let commentCount = " " + " " + String(momentData.data?[indexPath.row].commentsCount ?? 0)
        cell.btnCommentOutlet.setTitle(commentCount, for: .normal)
        
        let likeCount = " " + " " + String(momentData.data?[indexPath.row].likesCount ?? 0)
        cell.btnLikeOutlet.setTitle(likeCount, for: .normal)
        
        let inputDateString = momentData.data?[indexPath.row].updatedAt ?? ""
        if let outputDateString = convertDateStringForMoment(inputDateString) {
            print("Formatted date: \(outputDateString)") // Output: Formatted date: Wed Nov 06 2023
            cell.lblDateAndTime.text = outputDateString
            
        } else {
            print("Failed to convert the date string.")
        }

        if let userData = momentData.data?[indexPath.row].userData {
         
            print("User ID: \(userData.id ?? 0)")
            print("User Name: \(userData.name ?? "Unknown")")
            
            if let profileImages = userData.profileImages {
            
                if let firstProfileImage = profileImages.first {
                    let profileImageUrlString = firstProfileImage.imageName ?? ""
                    if let profileImageUrl = URL(string: profileImageUrlString) {
                     
                        print("THe profile image url is: \(profileImageUrl)")
                        cell.imgViewUserPhoto.kf.setImage(with: profileImageUrl) { result in
                            switch result {
                            case .success(let value):
                                print("Profile Image downloaded: \(value.image)")
                              
                            case .failure(let error):
                                print("Error downloading profile image: \(error)")
                                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                                
                            }
                        }
                    }
                }
            } else {
                print("No profile images found.")
                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
        } else {
            print("No userData found.")
        }
        
//        if (momentData.data?[indexPath.row].likesByYouCount == 0) {
//          
//            momentData.data?[indexPath.row].isMomentLiked == false
//            
//        } else if(momentData.data?[indexPath.row].likesByYouCount == 1) {
//            
//            momentData.data?[indexPath.row].isMomentLiked == true
//        }
        
        if momentData.data?[indexPath.row].isMomentLiked == true {
            
            cell.btnLikeOutlet.setImage(UIImage(named:  "MomentLike"), for: .normal)
            cell.isLikeButtonPressed = true
            print("\(indexPath.row) moment ka result hai like condition mai \(momentData.data?[indexPath.row].isMomentLiked)")
        }
        
        if momentData.data?[indexPath.row].isMomentLiked == false  {
            
            cell.btnLikeOutlet.setImage(UIImage(named:  "Like"), for: .normal)
            cell.isLikeButtonPressed = false
            print("\(indexPath.row) moment ka result hai nahi like condition mai\(momentData.data?[indexPath.row].isMomentLiked)")
        }
        
        if (momentData.data?[indexPath.row].isFollowed == true) {
            
            cell.btnFollowUserOutlet.isHidden = true
            
        }
        
        let userIdToCheck = String(momentData.data?[indexPath.row].userData?.profileID ?? 0)
        let userFollow = GlobalClass.sharedInstance.isUserFollowed(userIdToCheck: userIdToCheck)
        print("User with ID \(userIdToCheck) is followed: \(userFollow)")
        
        if (userFollow == true) {
          
            print("User isko follow karta hai.")
            cell.btnFollowUserOutlet.isHidden = true
            momentData.data?[indexPath.row].isFollowed = true
        } else {
            
           print("User isko follow nahi karta hai.")
            cell.btnFollowUserOutlet.isHidden = false
        }
        
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if momentData.data?[indexPath.row].momentImages?.count == 0 {
            
            return 170
            
        } else {
            return 600
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            pageNo += 1
            print(pageNo)
            
            if (pageNo <= lastPageNo) {
                isDataLoading = true
                print("Ab Call Krana Hai")
                getListData()
              
            } else {
                print("Ye last page hai ... isliye api call nahi krani hai")
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The selected table view cell index is: \(indexPath.row)")
        print("The id of the selected cell is: \(momentData.data?[indexPath.row].userData?.id)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
        nextViewController.userID = String(momentData.data?[indexPath.row].userData?.id ?? 0)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func isLoadingComplete(isCompleted: Bool) {
        print(isCompleted)
        
    }
    
    func isOptionButtonClicked(isclicked: Bool) {
        print("the option button clicked is: \(isclicked)")
        showOptionsFromBelow(on: self) {
            // Handle the follow action
            print("Handling follow action")
            // Perform actions related to following
        }
        
    }
    
    func likeButtonClicked(isClicked: Bool, index: Int) {
        
        print(isClicked)
        print(index)
        
        momentData.data?[index].isMomentLiked = isClicked
        
        if isClicked == true {
          
            print("Moment ko like kia hai. ur liked video main add karna hai iskos")
            
            momentLikeUnlike(momentid: momentData.data?[index].id ?? 0)
            
            let a = (momentData.data?[index].likesCount ?? 0)  + 1
            momentData.data?[index].likesCount = a
            
        } else {
            
           print("Moment ko unlike kia hai. Ur liked video se htana hai isko")
           
            momentLikeUnlike(momentid: momentData.data?[index].id ?? 0)
            let b = (momentData.data?[index].likesCount ?? 0) - 1
            momentData.data?[index].likesCount = b
            
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        tblView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func commentButtonClicked(index: Int) {
        
        print("The selected comment index is: \(index)")
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MomentCommentViewController") as! MomentCommentViewController
        nextViewController.delegate = self
        if let selectedMoment = momentData.data?[index] {
            nextViewController.momentData = selectedMoment
        } else {
            print("Error: Moment data at index \(index) is nil.")
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func likeUnlikeUpdate(index: Int, islike: Bool) {
        
        print("comment view controller par like unlike hua hai")
        momentData.data?[index].isMomentLiked = islike
      
        if islike == true {
            
            let a = (momentData.data?[index].likesCount ?? 0)  + 1
            momentData.data?[index].likesCount = a
            
        } else {
            
            let b = (momentData.data?[index].likesCount ?? 0) - 1
            momentData.data?[index].likesCount = b
            
        }
    }
    
    func sendGiftButtonClicked(isClicked: Bool, index: Int) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MomentSendGiftViewController") as! MomentSendGiftViewController
        nextViewController.momentID = (momentData.data?[index].id ?? 0)
        nextViewController.recieverID = (momentData.data?[index].userData?.profileID ?? 0)
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
        momentData.data?[index].isGiftSend = isClicked
        print("The moment id here is: \(momentData.data?[index].id)")
    //    print("The moment reciever id here is: \(momentData.data?[index].userData?.id)")
        print("The moment reciever profile id here is: \(momentData.data?[index].userData?.profileID)")
        
        if isClicked == true {
          
            print("Moment ko like kia hai. ur liked video main add karna hai iskos")
            
        } else {
            
           print("Moment ko unlike kia hai. Ur liked video se htana hai isko")
           
            
        }
        
//        let indexPath = IndexPath(row: index, section: 0)
//        tblView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func followButtonClicked(index: Int) {
        
        print("The follow button is pressed in moment image , and index is: \(index)")
        
        momentData.data?[index].isFollowed = true
        follow(userID: (momentData.data?[index].userData?.id ?? 0), profileID: (momentData.data?[index].userData?.profileID ?? 0))
        
    }
    
    func imageClicked(type: String, index: Int) {
        print(type)
        print("The image clicked index in image view controller is: \(index)")
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowImagesViewController") as! ShowImagesViewController
//        nextViewController.momentData = momentData
//        nextViewController.currentIndex = index
//        nextViewController.lastPageNo = lastPageNo
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReelsViewController") as! ReelsViewController
        nextViewController.momentData = momentData
        nextViewController.currentIndex = index
        nextViewController.pageNo = pageNo
        nextViewController.lastPageNo = lastPageNo
        nextViewController.cameFrom = "image"
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
}

extension MomentImageViewController {
    
    func getListData() {
        
        let url = "https://zeep.live/api/momentListLatest?type=1&page=\(pageNo)"
        
        ApiWrapper.sharedManager().getMomentList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            if (value["success"] as? Bool == true) {
                
                if let result = value["result"] as? [String: Any] {
                    let lastPage = result["last_page"] as? Int
                    print("Last page: \(lastPage)")
                    lastPageNo = lastPage ?? 1
                    print(lastPageNo)
                } else {
                    print("Failed to retrieve the last page.")
                }
                
                if momentData.data == nil {
                    momentData.data = data?.data
                    
                } else {
                    momentData.data?.append(contentsOf: data?.data ?? [])
                    
                }
                
                //   momentData = data ?? momentData
                print("The moment data count is: \(momentData.data?.count)")
                
                tblView.reloadData()
                
            } else {
                
                print("Image wale data main success false aa rha hai")
                
            }
        }
    }
}

extension MomentImageViewController {
    
    func momentLikeUnlike(momentid:Int = 0) {
        let params = [
            "moment_id": momentid
        ] as [String : Any]
        
        print("The params for the plan id is: \(params)")
        
        ApiWrapper.sharedManager().likeMoment(url: AllUrls.getUrl.likeUnlikeMoment, parameters: params, completion: { [weak self] (data) in
            guard let self = self else {
                return // The object has been deallocated
            }
            
            if (data["success"] as? Bool == true) {
                print(data)
                print("Sab kuch sahi hai")
                
                let a = data["result"] as? [String: Any]
                print(a)
                
            } else {
                print(data["error"])
                print("Kuch error hai")
            }
        })
    }
    
    func follow(userID:Int,profileID:Int) {
      
      let params = [
          "following_id": userID//usersList.data?[currentIndex].id ?? 0
         
      ] as [String : Any]
      
      print("The parameter for following user is: \(params)")
        
      ApiWrapper.sharedManager().followUser(url: AllUrls.getUrl.followUser,parameters: params) { [weak self] (data) in
          guard let self = self else { return }
          
          if (data["success"] as? Bool == true) {
              print(data)
              
              GlobalClass.sharedInstance.saveUserToFollowList(profileID:String(profileID ?? 0))
              
          }  else {
                
              print("Follow karne mai koi dikkat hai.")
             
          }
      }
  }
    
}

extension MomentImageViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblView {
            // Get all visible cells
            let visibleCells = tblView.visibleCells

            // Get the index paths of visible items
            if let visibleIndexPaths = tblView.indexPathsForVisibleRows {
                // Loop through the visible cells and their index paths
                for (index, cell) in visibleCells.enumerated() {
                    if index < visibleIndexPaths.count {
                        let indexPath = visibleIndexPaths[index]
                        // Now you can access the indexPath
                        let sectionIndex = indexPath.section
                        let rowIndex = indexPath.row
                        // Print section index and row index
                        print("Visible cell at indexPath: [\(sectionIndex), \(rowIndex)] is \(cell)")
                    }
                }
            }
        }
    }
}




// MARK: - EXTENSION FOR USING SCROLL VIEW DELEGATES AND METHODS

//extension MomentImageViewController: UIScrollViewDelegate {
//    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
//            print("scrollViewWillBeginDragging")
//            isDataLoading = false
//        }
//    
//    
//        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//                print("scrollViewDidEndDragging")
//            
//}
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scroll view decelerate ho rha hai")
//        
//        if ((tblView.contentOffset.y + tblView.frame.size.height + 200) >= tblView.contentSize.height)
//            
//        {
//
//               if !isDataLoading{
//                   if didEndReached == true {
//                       print("data load ni krana hai")
//                   } else {
//                       pageNo += 1
//                       print(pageNo)
//                       
//                       if (pageNo <= lastPageNo) {
//                           isDataLoading = true
//                           print("Ab Call Krana Hai")
//                          getListData()
//                           //tblView.reloadData()
//                       } else {
//                           print("Ye last page hai ... isliye api call nahi krani hai")
//                          
//                       }
//                   }
//               }
//        }
//    }
//}

