//
//  MomentCommentViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/01/24.
//

import UIKit
import Kingfisher

protocol delegateMomentCommentViewController: AnyObject {

    func likeUnlikeUpdate(index:Int, islike:Bool)
    
}

class MomentCommentViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    lazy var momentData = momentDatum()
    lazy var lastPageNo = Int()
    lazy var commentData = momentCommentResult()
    lazy var pageNo: Int = 1
    lazy var cellIndex = Int()
    weak var delegate: delegateMomentCommentViewController?
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnSendCommentOutlet: UIButton!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var txtfldComment: UITextField!
    @IBOutlet weak var viewBottomConstraints: NSLayoutConstraint!
 //   let dateFormatterTest = DateFormatter()
  
    lazy var cameFrom: String = ""
    lazy var hostFollowed: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCommentList(momentid: momentData.id ?? 0)
        registerTableView()
        configureUI()
        hideKeyboardWhenTappedAround()
        print("The moment data which is passsing here is: \(momentData)")
        
    }
    
    func registerTableView() {
    
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
       // tblView.estimatedRowHeight = 120
        tblView.rowHeight = UITableView.automaticDimension
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "MomentTableViewCell", bundle: nil), forCellReuseIdentifier: "MomentTableViewCell")
        tblView.register(UINib(nibName: "MomentCommentListTableViewCell", bundle: nil), forCellReuseIdentifier: "MomentCommentListTableViewCell")
       
    }
    
    func configureUI() {
    
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" 
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
//        dateFormatterTest.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
//        dateFormatterTest.timeZone = TimeZone(identifier: "UTC")

        
        viewComment.layer.cornerRadius = viewComment.frame.size.height / 2
        viewComment.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        txtfldComment.setLeftPaddingPoints(15)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardHeight = keyboardFrame.cgRectValue.height
               
               // Check if the view's bottom is higher than the keyboard top
               let viewBottomY = viewBottom.frame.origin.y + viewBottom.frame.size.height
               let keyboardTopY = self.view.frame.size.height - keyboardHeight
               
               if viewBottomY > keyboardTopY {
                   // Adjust your view's constraints or frame here to move it above the keyboard
                   // For example, if using constraints:
                   UIView.animate(withDuration: 0.3) {
                       self.viewBottomConstraints.constant = (viewBottomY - keyboardTopY)
                       self.viewBottom.frame.origin.y -= (viewBottomY - keyboardTopY)
                   }
               }
           }
       }
    
       @objc func keyboardWillHide(_ notification: Notification) {
           // Reset your view's constraints or frame to the initial position here
           // For example, if using constraints:
           UIView.animate(withDuration: 0.3) {
               self.viewBottomConstraints.constant = 0 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
               self.viewBottom.frame.origin.y = self.view.frame.size.height - self.viewComment.frame.size.height - 30
           }
       }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        if (cameFrom == "profile") {
          
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func btnSendCommentPressed(_ sender: Any) {
        
        print("Button Send Comment Pressed")
        
        if (txtfldComment.text == "") {
            
            print("Moment Post wali api hit nahi krenge")
            
        } else {
            
            momentComment(momentid: momentData.id ?? 0)
            
        }
    }
//    "2024-01-05T09:11:21.000000Z"
}

extension MomentCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            if section == 1 {
                
                if (commentData.data?.count == 0) || (commentData.data?.count == nil) {
                    
                    return 0
                    
                } else {
                    return 60
                }
            }
           
        return 0
        
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
            if (section == 1) {
                
                if (commentData.data?.count == 0) || (commentData.data?.count == nil){
                    
                    return ""
                }  else {
                    return "Comments"
                }
            } else {
                return ""
            }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (section == 1) {
            
        if let headerView = view as? UITableViewHeaderFooterView {
                headerView.contentView.backgroundColor = .white
                headerView.textLabel?.textColor = .black
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return commentData.data?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentTableViewCell", for: indexPath) as! MomentTableViewCell
           
            cell.btnGiftOutlet.tag = indexPath.row
            cell.btnFollowUserOutlet.tag = indexPath.row
            
            let momentType = momentData.type?.lowercased()
            print("The momentType is \(momentType)")
            
            if (momentType == "image") {

                if let momentImages = momentData.momentImages {
                    cell.configure(with: momentImages, at: indexPath.row, of: momentType ?? "")
                    cell.imgViewPlayVideo.isHidden = true
                }
                cell.lblUserMessage.text = momentData.message
            } else {
                if let momentVideo = momentData.momentVideo {
                    cell.configureForVideo(with: momentVideo, at: indexPath.row, of: momentType ?? "")
                    cell.imgViewPlayVideo.isHidden = false
                }
                let formattedString = (momentData.message ?? "N/A")
                let plainString = stripHTMLTags(from: formattedString)
                print(plainString)
                cell.lblUserMessage.text = plainString
            }
            
            if let userData = momentData.userData {
             
                print("User ID: \(userData.id ?? 0)")
                print("User Name: \(userData.name ?? "Unknown")")
                
                cell.lblUserName.text = userData.name ?? "UnKnown"
               // cell.lblUserMessage.text = momentData.message
                
                let commentCount = " " + " " + String(momentData.commentsCount ?? 0)
                cell.btnCommentOutlet.setTitle(commentCount, for: .normal)
                
                let likeCount = " " + " " + String(momentData.likesCount ?? 0)
                cell.btnLikeOutlet.setTitle(likeCount, for: .normal)
                
                let inputDateString = momentData.updatedAt ?? ""
                if let outputDateString = convertDateStringForMoment(inputDateString) {
                    print("Formatted date: \(outputDateString)") // Output: Formatted date: Wed Nov 06 2023
                    cell.lblDateAndTime.text = outputDateString
                    
                } else {
                    print("Failed to convert the date string.")
                }
                
                
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
            
            if momentData.isMomentLiked == true {
                
                cell.btnLikeOutlet.setImage(UIImage(named:  "MomentLike"), for: .normal)
                cell.isLikeButtonPressed = true
            }
            
            if momentData.isMomentLiked == false  {
                
                cell.btnLikeOutlet.setImage(UIImage(named:  "Like"), for: .normal)
                cell.isLikeButtonPressed = false
            }
            
            if (hostFollowed == 0) {
            
                cell.btnFollowUserOutlet.isHidden = false
                
            } else {
                
                cell.btnFollowUserOutlet.isHidden = true
                
            }
            
            let userIdToCheck = String(momentData.userData?.profileID ?? 0)
            let userFollow = GlobalClass.sharedInstance.isUserFollowed(userIdToCheck: userIdToCheck)
            print("User with ID \(userIdToCheck) is followed: \(userFollow)")
            
            if (userFollow == true) {
              
                print("User isko follow karta hai.")
                cell.btnFollowUserOutlet.isHidden = true
                momentData.isFollowed = true
            } else {
                
               print("User isko follow nahi karta hai.")
                cell.btnFollowUserOutlet.isHidden = false
            }
            
            cell.delegate = self
            cell.viewMainBottomConstraints.constant = 0
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentCommentListTableViewCell", for: indexPath) as! MomentCommentListTableViewCell
            
            if let profileImageURL = URL(string: commentData.data?[indexPath.row].profilePic ?? " ") {
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
            
                cell.lblUserName.text = commentData.data?[indexPath.row].name ?? "UnKnown"
                cell.lblUserMessage.text = commentData.data?[indexPath.row].message ?? "No Message"
           
            if let timestampString = commentData.data?[indexPath.row].createdAt {
                let formattedString = formatTimestampForCommentList(timestampString)
                print(formattedString)
                print("The timestamp formatting is: \(formattedString)")
                cell.lblMessageTime.text = formattedString
            } else {
                print("Error: Timestamp string is nil.")
                cell.lblMessageTime.text = "Invalid Date" 
            }
            
               cell.lblUserMessage.sizeToFit()
               cell.lblUserMessage.numberOfLines = 0
               cell.lblUserMessage.adjustsFontSizeToFitWidth = true
               
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 550
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 1) - 1
        if indexPath.row == lastRowIndex {
            pageNo += 1
            print(pageNo)
            
            if (pageNo <= lastPageNo) {
//                isDataLoading = true
                print("Ab Call Krana Hai")
                getCommentList(momentid: momentData.id ?? 0)
              
            } else {
                print("Ye last page hai ... isliye api call nahi krani hai")
                
            }
        }
        
    }
    
}

extension MomentCommentViewController: delegateMomentTableViewCell {
   
    func imageClicked(type: String, index: Int) {
        print(type)
        print("The image clicked index in comment iew controller is: \(index)")
        navigationController?.popViewController(animated: true)
        
    }
    

    func isOptionButtonClicked(isclicked: Bool) {
        
        showOptionsFromBelow(on: self) {
            // Handle the follow action
            print("Handling follow action")
            // Perform actions related to following
        }
        
    }
    
    func likeButtonClicked(isClicked: Bool, index: Int) {
        
        print(isClicked)
        print(index)
        
        momentData.isMomentLiked = isClicked
        print("comment wale model mai hai \(momentData.isMomentLiked)")
        delegate?.likeUnlikeUpdate(index: cellIndex, islike: isClicked)
        
        if isClicked == true {
          
            print("Moment ko like kia hai. ur liked video main add karna hai iskos")
            
            momentLikeUnlike(momentid: momentData.id ?? 0)
            
            let a = (momentData.likesCount ?? 0)  + 1
            momentData.likesCount = a
            
        } else {
            
           print("Moment ko unlike kia hai. Ur liked video se htana hai isko")
           
            momentLikeUnlike(momentid: momentData.id ?? 0)
            let b = (momentData.likesCount ?? 0) - 1
            momentData.likesCount = b
            
        }
        
        let indexSet = IndexSet(integer: 0)
        tblView.reloadSections(indexSet, with: .none)
        
    }
    
    func commentButtonClicked(index: Int) {
        
        print(index)
        
    }
    
    func sendGiftButtonClicked(isClicked: Bool, index: Int) {
        
        print(isClicked)
        print(index)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MomentSendGiftViewController") as! MomentSendGiftViewController
        nextViewController.momentID = (momentData.id ?? 0)
        nextViewController.recieverID = (momentData.userData?.profileID ?? 0)
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
        
        momentData.isGiftSend = isClicked
        
   //     momentData.data?[index].isGiftSend = isClicked
        
        if isClicked == true {
          
            print("Send gift ko like kia hai.")
            
        } else {
            
           print("Send gift ko unlike kia hai.")
           
            
        }
        
//        let indexPath = IndexPath(row: index, section: 0)
//        tblView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func followButtonClicked(index: Int) {
        
        print("The follow button is pressed in moment comment , and index is: \(index)")
        
        momentData.isFollowed = true
        follow(userID: (momentData.userData?.id ?? 0), profileID: (momentData.userData?.profileID ?? 0))
        
    }
    
}

extension MomentCommentViewController {
    
    func getCommentList(momentid:Int = 0) {
        
        let url = "https://zeep.live/api/momentcommentList?page=\(pageNo)"
        
        let params = [
            "moment_id": momentid
        ] as [String : Any]
        
        print("The params for the comment list id is: \(params)")
        
        ApiWrapper.sharedManager().getMomentCommentList(url: url, parameters: params) { [weak self] (data, value) in
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
                
                if commentData.data == nil {
                    commentData.data = data?.data
                    
                } else {
                    commentData.data?.append(contentsOf: data?.data ?? [])
                    
                }
                
                //   momentData = data ?? momentData
                print("The moment data count is: \(commentData.data?.count)")
                
                tblView.reloadData()
                
            } else {
                
                print("Image wale data main success false aa rha hai")
                
            }
        }
    }
}

extension MomentCommentViewController {
    
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
    
    func momentComment(momentid:Int = 0) {
        let params = [
            
            "moment_id": momentid,
              "profile_id": UserDefaults.standard.string(forKey: "UserProfileId") ?? "",
              "name": UserDefaults.standard.string(forKey: "UserName") ?? "",
              "profile_pic": UserDefaults.standard.string(forKey: "profilePicture") ?? "",
            "message": txtfldComment.text ?? ""
            
        ] as [String : Any]
        
        print("The params for moment Comment Sending is: \(params)")
        
        ApiWrapper.sharedManager().commentOnMomentPost(url: AllUrls.getUrl.sendCommentOnMoment, parameters: params, completion: { [weak self] (data) in
            guard let self = self else {
                return // The object has been deallocated
            }
            
            if (data["success"] as? Bool == true) {
                print(data)
                print("Sab kuch sahi hai")
                
                let a = data["result"] as? [String: Any]
                print(a)
                
                var newComment = commentDatum()
                newComment.momentID = params["moment_id"] as? Int
                newComment.profileID = params["profile_id"] as? Int
                newComment.name = params["name"] as? String
                newComment.profilePic = params["profile_pic"] as? String
                newComment.message = params["message"] as? String
//                let currentDateString = dateFormatterTest.string(from: Date())
//                print(currentDateString)
//                newComment.createdAt = currentDateString
                
                print("The new comment is: \(newComment)")
                commentData.data?.append(newComment)
                
                txtfldComment.text = ""
                tblView.reloadData()
                
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
