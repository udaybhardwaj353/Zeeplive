//
//  ReelsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 06/06/24.
//

import UIKit
import AVFoundation

class ReelsViewController: UIViewController, delegateMomentCommentViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
   // lazy var videoUrl: String = ""
  //  lazy var giftUrl: String = ""
    lazy var previousIndex: Int = 0
    lazy var currentIndex: Int = 0
    lazy var newIndex: Int = 0
    lazy var momentData = MomentResult()
    let offsetY =  100
    lazy var lastPageNo: Int = 1
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
    lazy var pageNo:Int = 1
    lazy var momentType: String = ""
    lazy var cameFrom: String = ""
    lazy var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // playVideo()
        tableViewWork()
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Button Back Pressed.")
        
        ZLGiftManager.share.remove()
        navigationController?.popViewController(animated: false)
        
    }
    
    deinit {
        print("Deinit call hua hai reels view controller main.")
        momentData.data?.removeAll()
        cleanUpPlayer()
        NotificationCenter.default.removeObserver(self)
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
        player?.replaceCurrentItem(with: nil) // Release current item
        player = nil // Set player to nil to release the player instance
    }
    
}

// MARK: - EXTENSION FOR PLAYING VIDEO AND PLAYING ANIMATION AND VIDEO PLAYER CALLBACK FUNCTIONS ARE DEFINED HERE TO KNOW WHEN PLAYER ENDED AND GIFT STARTED PLAYING
    
extension ReelsViewController {
    
    func tableViewWork() {
        
        tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "ReelsVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "ReelsVideoTableViewCell")
        tblView.register(UINib(nibName: "ReelsImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReelsImageTableViewCell")
        
       setData()
        
    }
    
    func setData() {
        
        let type = momentData.data?[currentIndex].type?.lowercased()
        print("The momentType is \(type)")
        momentType = type ?? ""
        
        if (momentType == "giftvideo") || (momentType == "video") {
            
            let index = IndexPath(row: currentIndex, section: 0)
            tblView?.scrollToRow(at: index , at: UITableView.ScrollPosition.top, animated: false)
            playVideo(videoUrl: momentData.data?[currentIndex].momentVideo?.first?.videoURL ?? "")
            
        } else {
            
            let index = IndexPath(row: currentIndex, section: 0)
            tblView?.scrollToRow(at: index , at: UITableView.ScrollPosition.top, animated: false)
            
        }
    }
    
    func playVideo(videoUrl: String = "") {
           showLoader()
           
           // Remove existing player and player layer if they exist
           if let playerLayer = self.playerLayer {
               playerLayer.removeFromSuperlayer()
               self.playerLayer = nil
           }

           if let player = self.player {
               player.pause()
               player.replaceCurrentItem(with: nil)
               self.player = nil
           }

           // Initialize player and player layer
           let player = AVPlayer()
           let playerLayer = AVPlayerLayer(player: player)
           playerLayer.frame = self.view.bounds
           playerLayer.videoGravity = .resizeAspectFill
           self.view.layer.addSublayer(playerLayer)
           self.view.addSubview(tblView)
           self.view.addSubview(viewTop)
       
        guard let cell = tblView.visibleCells.first as? ReelsVideoTableViewCell else {
            // Handle the case where the cell cannot be cast to ReelsVideoTableViewCell
            return
        }
            self.view.addSubview(cell.viewLuckyGift)
           
        // Set constraints to center the view in the cell's contentView
            cell.viewLuckyGift.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                //cell.viewLuckyGift.centerXAnchor.constraint(equalTo: self.view.leadingAnchor),
                cell.viewLuckyGift.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                cell.viewLuckyGift.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                cell.viewLuckyGift.widthAnchor.constraint(equalToConstant: 300), // Set your desired width
                cell.viewLuckyGift.heightAnchor.constraint(equalToConstant: 50) // Set your desired height
            ])
        
           // Load and play the video
           guard let url = URL(string: videoUrl) else {
               print("Invalid video URL")
               hideLoader()
               return
           }
           
           let asset = AVURLAsset(url: url)
           let keys = ["playable"]
           
           asset.loadValuesAsynchronously(forKeys: keys) {
               DispatchQueue.main.async {
                   var error: NSError? = nil
                   let status = asset.statusOfValue(forKey: "playable", error: &error)
                   switch status {
                   case .loaded:
                       let mediaItem = AVPlayerItem(asset: asset)
                       mediaItem.preferredForwardBufferDuration = 5.0 // Buffer 5 seconds ahead
                       mediaItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
                       player.replaceCurrentItem(with: mediaItem)
                       player.play()
                   case .failed:
                       print("Failed to load video: \(error?.localizedDescription ?? "Unknown error")")
                       self.hideLoader()
                   case .cancelled:
                       print("Cancelled loading video")
                       self.hideLoader()
                   default:
                       print("Unknown status")
                       self.hideLoader()
                   }
               }
           }

           player.actionAtItemEnd = .pause // Optional: Pause the player when it reaches the end
           
           // Assign the player and player layer to the class-level properties
           self.player = player
           self.playerLayer = playerLayer
       }
    
    func playAnimation(giftUrl: String = "") {
    
        
        if let results = GiftsManager.shared.giftResults {
            if let matchingGift = results.first(where: { result in
                guard let gifts = result.gifts else { return false }
                return gifts.contains(where: { $0.animationFile == giftUrl })
            }) {
                guard let gift = matchingGift.gifts?.first(where: { $0.animationFile == giftUrl }) else {
                    print("Gift details not found.")
                    return
                }
                
                // Print the details of the matching gift
                print("Matching gift details:")
                print("ID: \(gift.id ?? 0)")
                print("Name: \(gift.giftName ?? "")")
                print("Animation File: \(gift.animationFile ?? "")")
                // Print other properties as needed
                var sendGiftModel = Gift()
                sendGiftModel.id = gift.id
                //     sendGiftModel.giftCategoryID
                sendGiftModel.giftName = gift.giftName
                sendGiftModel.image = gift.image
                sendGiftModel.amount = gift.amount
                sendGiftModel.animationType = gift.animationType
                sendGiftModel.isAnimated = gift.isAnimated
                sendGiftModel.animationFile = gift.animationFile
                sendGiftModel.soundFile = gift.soundFile
                sendGiftModel.imageType = gift.imageType
                
                if (sendGiftModel.animationType == 0) {
                    print("Animation play nahi krana hai")
                } else {
                    print("Animation play krana hai")
                    ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: self)
                }
                
            } else {
                print("No matching gift found.")
            }
        } else {
            print("Gift results not available.")
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "status" {
                if let playerItem = object as? AVPlayerItem {
                    switch playerItem.status {
                    case .readyToPlay:
                        print("Video is ready to play")
                        DispatchQueue.main.async {
                            guard let cell = self.tblView.visibleCells.first as? ReelsVideoTableViewCell else {
                                // Handle the case where the cell cannot be cast to ReelsVideoTableViewCell
                                return
                            }
                            self.player?.rate = 1.0 // Ensure the playback rate is set to normal
                            self.player?.play()
                            self.hideLoader()
                            if (self.momentType == "video") {
                                print("Lucky gift play nahi krana hai.")
                            } else {
                                self.playLuckyGift(giftCount: (self.momentData.data?[self.currentIndex].giftCount ?? 0), giftImage: (self.momentData.data?[self.currentIndex].giftImg ?? ""), giftSenderProfilePic: (self.momentData.data?[self.currentIndex].senderPic ?? ""))
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.playAnimation(giftUrl: self.momentData.data?[self.currentIndex].giftURL ?? "")
                            }
                        }
                    case .failed:
                        print("Failed to load video")
                        if let error = playerItem.error {
                            print("Error: \(error.localizedDescription)")
                        }
                        self.hideLoader()
                    default:
                        break
                    }
                }
            }
        }
    
    @objc func playerDidFinishPlaying() {
        player?.seek(to: CMTime.zero)
        player?.play()
        if (momentType == "video") {
            print("Lucky gift wala animation nahi chalaenge.")
        } else {
            self.playLuckyGift(giftCount: (self.momentData.data?[self.currentIndex].giftCount ?? 0), giftImage: (self.momentData.data?[self.currentIndex].giftImg ?? ""), giftSenderProfilePic: (self.momentData.data?[self.currentIndex].senderPic ?? ""))
        }
        print("Video play hona khtm ho gya. ab phir se play hoga.Video play hona khtm ho gya. ab phir se play hoga.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playAnimation(giftUrl: self.momentData.data?[self.currentIndex].giftURL ?? "")
        }
    }
    
    // Properly remove observer when no longer needed
    func removePlayerItemObserver() {
        if let currentItem = self.player?.currentItem {
            currentItem.removeObserver(self, forKeyPath: "status")
        }
    }
    
    // Call this function to clean up resources when done with the player
    func cleanUpPlayer() {
        removePlayerItemObserver()
        if let playerLayer = self.playerLayer {
            playerLayer.removeFromSuperlayer()
            self.playerLayer = nil
        }
        
        if let player = self.player {
            player.pause()
            player.replaceCurrentItem(with: nil)
            self.player = nil
        }
    }
    
    func playLuckyGift(giftCount:Int, giftImage:String, giftSenderProfilePic:String) {
    
        guard let cell = tblView.visibleCells.first as? ReelsVideoTableViewCell else {
            // Handle the case where the cell cannot be cast to ReelsVideoTableViewCell
            return
        }
        
        cell.viewLuckyGift.isHidden = false
        shakeAnimation(for: cell.viewGiftImage)
        hideViewAfterDelay(viewToHide: cell.viewLuckyGift, duration: 0.40) { //0.80 pehle ye tha.
            // This block will be executed when the animation is finished
            print("Animation finished!")
            cell.viewLuckyGift.isHidden = true
            
        }
        
        cell.lblNoOfGift.text =  "X" + " " + String(giftCount ?? 1)
        cell.lblSendGiftHostName.text = momentData.data?[currentIndex].senderName ?? "N/A"//(UserDefaults.standard.string(forKey: "UserName") ?? "") //liveMessage.sendGiftTo ?? ""
        
        loadImage(from: giftImage ?? "", into: cell.imgViewGift)
        loadImage(from: giftSenderProfilePic ?? "", into: cell.imgViewUser)
        
    }
    
    func hideViewAfterDelay(viewToHide: UIView, duration: TimeInterval, completion: (() -> Void)? = nil) {
        // Store the original x-axis position
        let originalX = self.view.frame.origin.x

        // Set the delay duration (in seconds)
        let delayInSeconds: TimeInterval = 0.80

        // Use DispatchQueue to execute code after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            // Perform the animation to move the view to the right
            UIView.animate(withDuration: duration, animations: {
                // Apply a translation transformation to move the view to the right
                viewToHide.transform = CGAffineTransform(translationX: self.view.frame.width / 2.5, y: 0)
                
            }) { _ in
                // Once the animation is complete, reset the x-axis position
                viewToHide.transform = CGAffineTransform(translationX: originalX - 10, y: 0)
                
                // Call the completion block if provided
                completion?()
            }
        }
    }
    
    func hideLuckGiftAnimation() {
        
        guard let cell = tblView.visibleCells.first as? ReelsVideoTableViewCell else {
            // Handle the case where the cell cannot be cast to ReelsVideoTableViewCell
            return
        }
        
        cell.viewLuckyGift.layer.removeAllAnimations()
        cell.viewLuckyGift.isHidden = true
        cell.viewLuckyGift.transform = CGAffineTransform.identity
        
        // cell.viewLuckyGift.layer.removeAllAnimations()
       // cell.viewLuckyGift.removeFromSuperview()
//        if let viewLuckyGift = cell.viewLuckyGift, viewLuckyGift.superview != nil {
//            viewLuckyGift.removeFromSuperview()
//        }


    }
    
}

// MARK: - EXTENSION FOR DOING SCROLLING WORK AND PLAYING VIDEO

extension ReelsViewController {
    

    // MARK: - SCROLL VIEW SWIPE UP AND DOWN FUNCTIONALITY FUNCTION WORKING

            func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
    
                    let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
                    scrollView.panGestureRecognizer.isEnabled = false
    
                    self.previousIndex = self.currentIndex
    
                    var isRun = false
                    if translatedPoint.y < CGFloat(-offsetY) && self.currentIndex < ((self.momentData.data?.count ?? 1) - 1) {
                        self.currentIndex += 1
                        NSLog("向下滑动索引递增")
                        print("after translating it means Index increases as you scroll down.")
                        isRun = true
                        self.newIndex = self.currentIndex + 1
                        print("The new index here jab scroll upar ki trf karenge tb hai: \(self.newIndex)")
                    }
    
                    if translatedPoint.y > CGFloat(offsetY) && self.currentIndex > 0 {
                        self.currentIndex -= 1
                        self.newIndex = self.currentIndex - 1
                        NSLog("向上滑动索引递减")
                        print("After translating it means Index decreases as you scroll up.")
                        isRun = true
                        print("The new index jab scroll neeche ki trf karenge tab hai: \(self.newIndex)")
                    }
    
                    if (self.momentData.data?.count ?? 0) > 0 {
                        UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
                            guard let self = self else { return }
                            let index = IndexPath(row: self.currentIndex, section: 0)
                            self.tblView?.scrollToRow(at: index, at: .top, animated: false)
                        } completion: { [weak self] finish in
                            guard let self = self else { return }
                            scrollView.panGestureRecognizer.isEnabled = true
                        }
                       // scrollView.panGestureRecognizer.isEnabled = true
                        if isRun {
    
                            let type = momentData.data?[currentIndex].type?.lowercased()
                            print("The momentType is \(type)")
                            momentType = type ?? ""
                            cleanUpPlayer()
                            
                            if (momentType == "giftvideo") || (momentType == "video") {
                                
                                hideLuckGiftAnimation()
                                hideLoader()
                                tblView.reloadData()
                                ZLGiftManager.share.remove()
                                playVideo(videoUrl: momentData.data?[currentIndex].momentVideo?.first?.videoURL ?? "")
                                
                            } else {
                                
                                tblView.reloadData()
                                playerLayer?.removeFromSuperlayer()
                                playerLayer = nil
                            }
                            
                            print("滑动完成")
                            print("After converted it means Slide Completed")
                            UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
                                guard let self = self else { return }
                                let index = IndexPath(row: self.currentIndex, section: 0)
                                self.tblView?.scrollToRow(at: index, at: .top, animated: false)
                            } completion: { [weak self] finish in
                                guard let self = self else { return }
                                scrollView.panGestureRecognizer.isEnabled = true
                            }
                        }
                    }
                }
            }
    
}

// MARK: - EXTENSION FOR USING DELEGATE FUNCTIONS AND METHODS TO USE IT ACCORDING TO OUR REQUIREMENT

extension ReelsViewController: delegateReelsVideoTableViewCell {
    
    func buttonHostImageClicked(index: Int) {
        
        print("THe host image button clicked in reels view controller with index: \(index)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
        nextViewController.userID = String(momentData.data?[index].userData?.id ?? 0)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func buttonSendGiftClicked(index: Int) {
        
        print("The send gift button clicked in reels view controller with index: \(index)")
      
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MomentSendGiftViewController") as! MomentSendGiftViewController
        nextViewController.momentID = (momentData.data?[index].id ?? 0)
        nextViewController.recieverID = (momentData.data?[index].userData?.profileID ?? 0)
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
        momentData.data?[index].isGiftSend = true
        
        
    }
    
    func buttonLikeReelClicked(isClicked:Bool,index: Int) {
        
        print("The like reel button clicked in reels view controller with index: \(index)")
        momentData.data?[index].isMomentLiked = isClicked
        
        guard let cell = tblView.visibleCells.first as? ReelsVideoTableViewCell else {
            // Handle the case where the cell cannot be cast to ReelsVideoTableViewCell
            return
        }
        
        if isClicked == true {
          
            print("Moment ko like kia hai. ur liked video main add karna hai iskos")
            
            momentLikeUnlike(momentid: momentData.data?[index].id ?? 0)
            
            let a = (momentData.data?[index].likesCount ?? 0)  + 1
            momentData.data?[index].likesCount = a
            cell.lblLikeReelCount.text = String(momentData.data?[index].likesCount ?? 0)
            
        } else {
            
           print("Moment ko unlike kia hai. Ur liked video se htana hai isko")
           
            momentLikeUnlike(momentid: momentData.data?[index].id ?? 0)
            
            let b = (momentData.data?[index].likesCount ?? 0) - 1
            momentData.data?[index].likesCount = b
            cell.lblLikeReelCount.text = String(momentData.data?[index].likesCount ?? 0)
            
        }
        
    }
    
    func buttonCommentClicked(index: Int) {
        
        print("The comment button clicked in reels view controller with index: \(index)")
        
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
        
        momentData.data?[index].isMomentLiked = islike
      
        if islike == true {
            
            let a = (momentData.data?[index].likesCount ?? 0)  + 1
            momentData.data?[index].likesCount = a
            
        } else {
            
            let b = (momentData.data?[index].likesCount ?? 0) - 1
            momentData.data?[index].likesCount = b
            
        }
    }
    
}

// MARK: - EXTENSION FOR USING DELEGATE FUNCTIONS AND METHODS FROM REELS IMAGE VIEW CONTROLLER AS PER OUR REQUIREMENT

extension ReelsViewController: delegateReelsImageTableViewCell {
    
    func buttonHostImageClickedInImageCell(index: Int) {
        
        print("The host image button clicked in reels view controller for image cell with index: \(index)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
        nextViewController.userID = String(momentData.data?[index].userData?.id ?? 0)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func buttonSendGiftClickedInImageCell(index: Int) {
        
        print("The send gift button clicked in reels view controller for image cell with index: \(index)")
      
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MomentSendGiftViewController") as! MomentSendGiftViewController
        nextViewController.momentID = (momentData.data?[index].id ?? 0)
        nextViewController.recieverID = (momentData.data?[index].userData?.profileID ?? 0)
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
        momentData.data?[index].isGiftSend = true
        
    }
    
    func buttonLikeImageClickedInImageCell(isClicked: Bool, index: Int) {
        
        print("The like button is clicked in reels view controller for image cell with index: \(index)")
        
        momentData.data?[index].isMomentLiked = isClicked
        
        guard let cell = tblView.visibleCells.first as? ReelsImageTableViewCell else {
            // Handle the case where the cell cannot be cast to ReelsVideoTableViewCell
            return
        }
        
        if isClicked == true {
          
            print("Moment ko like kia hai. ur liked video main add karna hai iskos")
            
            momentLikeUnlike(momentid: momentData.data?[index].id ?? 0)
            
            let a = (momentData.data?[index].likesCount ?? 0)  + 1
            momentData.data?[index].likesCount = a
            cell.lblLikeImageCount.text = String(momentData.data?[index].likesCount ?? 0)
            
        } else {
            
           print("Moment ko unlike kia hai. Ur liked video se htana hai isko")
           
            momentLikeUnlike(momentid: momentData.data?[index].id ?? 0)
            
            let b = (momentData.data?[index].likesCount ?? 0) - 1
            momentData.data?[index].likesCount = b
            cell.lblLikeImageCount.text = String(momentData.data?[index].likesCount ?? 0)
            
        }
        
    }
    
    func buttonCommentClickedInImageCell(index: Int) {
        
        print("The comment button clicked in reels view controller for image cell with index: \(index)")
        
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
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS AND THEIR WORKING FOR PLAYING REELS AND GIFT VIDEO

extension ReelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return momentData.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (momentType == "giftvideo") || (momentType == "video"){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReelsVideoTableViewCell", for: indexPath) as! ReelsVideoTableViewCell
            
            let momentType = momentData.data?[indexPath.row].type?.lowercased()
            print("The momentType is \(momentType)")
            
            if let userData = momentData.data?[currentIndex].userData {
                
                print("User ID: \(userData.id ?? 0)")
                print("User Name: \(userData.name ?? "Unknown")")
                cell.lblHostName.text = userData.name
                cell.lblSendGiftCount.text = String(momentData.data?[indexPath.row].giftCount ?? 0)
                cell.lblLikeReelCount.text = String(momentData.data?[indexPath.row].likesCount ?? 0)
                cell.lblCommentCount.text = String(momentData.data?[indexPath.row].commentsCount ?? 0)
                
                let senderName = (momentData.data?[indexPath.row].senderName ?? "N/A")
                let giftCount = String(momentData.data?[indexPath.row].giftCount ?? 1)
                let formattedString = momentData.data?[indexPath.row].message ?? ""
                
                let plainString = stripHTMLTags(from: formattedString)
                
                print(plainString) // Output: "send 1 Sea Monster to Riya"
                
                if (momentType?.lowercased() == "video") {
                 //   cell.lblUserMessage.isHidden = true
                    cell.lblHostDescriptionMessage.text = momentData.data?[indexPath.row].message
                } else {
                    cell.lblHostDescriptionMessage.text = "Wow \(senderName)" + " " + ","  + " " + plainString //plainString//"Wow," + senderName + "sent me" + giftCount + ""
                }
                if let profileImages = userData.profileImages {
                    
                    if let firstProfileImage = profileImages.first {
                        let profileImageUrlString = firstProfileImage.imageName ?? ""
                        if let profileImageUrl = URL(string: profileImageUrlString) {
                            
                            print("THe profile image url is: \(profileImageUrl)")
                            cell.imgViewHostImage.kf.setImage(with: profileImageUrl) { result in
                                switch result {
                                case .success(let value):
                                    print("Profile Image downloaded: \(value.image)")
                                    
                                case .failure(let error):
                                    print("Error downloading profile image: \(error)")
                                    cell.imgViewHostImage.image = UIImage(named: "UserPlaceHolderImageForCell")
                                    
                                }
                            }
                        }
                    }
                } else {
                    print("No profile images found.")
                    cell.imgViewHostImage.image = UIImage(named: "UserPlaceHolderImageForCell")
                }
            }
            
            cell.viewLuckyGift.isHidden = true
            cell.delegate = self
            cell.btnHostImageOutlet.tag = indexPath.row
            cell.btnSendGiftOutlet.tag = indexPath.row
            cell.btnLikeReelOutlet.tag = indexPath.row
            cell.btnCommentOutlet.tag = indexPath.row
            
            cell.selectionStyle = .none
            return cell
            
        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReelsImageTableViewCell", for: indexPath) as! ReelsImageTableViewCell
            
            if let momentImages = momentData.data?[indexPath.row].momentImages {
                cell.configure(with: momentImages, at: indexPath.row, of: "image")
            }
            
            if let userData = momentData.data?[currentIndex].userData {
                
                print("User ID: \(userData.id ?? 0)")
                print("User Name: \(userData.name ?? "Unknown")")
                cell.lblHostName.text = userData.name
                cell.lblSendGiftCount.text = String(momentData.data?[indexPath.row].giftCount ?? 0)
                cell.lblLikeImageCount.text = String(momentData.data?[indexPath.row].likesCount ?? 0)
                cell.lblCommentCount.text = String(momentData.data?[indexPath.row].commentsCount ?? 0)
                
                let senderName = (momentData.data?[indexPath.row].senderName ?? "N/A")
                let giftCount = String(momentData.data?[indexPath.row].giftCount ?? 1)
                let formattedString = momentData.data?[indexPath.row].message ?? ""
                
                let plainString = stripHTMLTags(from: formattedString)

                print(plainString) // Output: "send 1 Sea Monster to Riya"
                
                cell.lblHostDescriptionMessage.text = plainString//"Wow," + senderName + "sent me" + giftCount + ""
                
                if let profileImages = userData.profileImages {
                    
                    if let firstProfileImage = profileImages.first {
                        let profileImageUrlString = firstProfileImage.imageName ?? ""
                        if let profileImageUrl = URL(string: profileImageUrlString) {
                            
                            print("THe profile image url is: \(profileImageUrl)")
                            cell.imgViewHostImage.kf.setImage(with: profileImageUrl) { result in
                                switch result {
                                case .success(let value):
                                    print("Profile Image downloaded: \(value.image)")
                                    
                                case .failure(let error):
                                    print("Error downloading profile image: \(error)")
                                    cell.imgViewHostImage.image = UIImage(named: "UserPlaceHolderImageForCell")
                                    
                                }
                            }
                        }
                    }
                } else {
                    print("No profile images found.")
                    cell.imgViewHostImage.image = UIImage(named: "UserPlaceHolderImageForCell")
                }
            }
            
            cell.delegate = self
            cell.btnHostImageOutlet.tag = indexPath.row
            cell.btnSendGiftOutlet.tag = indexPath.row
            cell.btnLikeImageOutlet.tag = indexPath.row
            cell.btnCommentOutlet.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("the cell width and height in reel view controller is: \(GlobalClass.sharedInstance.SCREEN_HEIGHT)")
        return GlobalClass.sharedInstance.SCREEN_HEIGHT
        
    }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            print("the indexpath in will display method in reels view controller is: \(indexPath.row)")
            let lastRowIndex = tableView.numberOfRows(inSection: 0) - 2
            print("the last row indexpath in will display method in reels view controller is: \(lastRowIndex)")
            print(lastPageNo)
            if indexPath.row == lastRowIndex {
                pageNo += 1
                print(pageNo)
    
                if (pageNo <= lastPageNo) {
                    isDataLoading = true
                    print("Ab Call Krana Hai")
                    if (cameFrom == "video") {
                        getListDataForVideo()
                    } else if (cameFrom == "image") {
                        getListDataForImage()
                    } else if (cameFrom == "profile") {
                        getListDataForProfile()
                    } else {
                        getListDataForFollowing()
                    }
    
                } else {
                    print("Ye last page hai ... isliye api call nahi krani hai reels view controller main.")
    
                }
            }
        }
    
}

// MARK: - EXTENSION FOR API CALLING FOR MOMENT LIKE AND UNLIKE AND GETTING DATA FROM SERVER FOR MOMENT DATA 

extension ReelsViewController {
    
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
    
    func getListDataForVideo() {
        
        let url = "https://zeep.live/api/momentListLatest?type=2&page=\(pageNo)"
        
        print("The url we are passing in the reels swipe up and down is: \(url)")
        
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
                
                print("Video wali api main response main success false aaya hai.")
                
            }
        }
    }
    
    func getListDataForImage() {
        
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
    
    func getListDataForFollowing() {
        
        let url = "https://zeep.live/api/momentListLatest?type=3&page=\(pageNo)"
        
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
                
                print("Moment following wale main success false aaya hai")
                
            }
        }
    }
    
    func getListDataForProfile() {
        
        let url = "https://zeep.live/api/viewprofilemomentList?id=\(userID)&page=\(pageNo)"
        
        print("The url in the profile moment is: \(url)")
        
        ApiWrapper.sharedManager().getMomentList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
          
            if (value["success"] as? Bool == true) {
                
                tblView.isHidden = false
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
                
                print("Moment following wale main success false aaya hai")
                if (momentData.data?.count == 0) || (momentData.data == nil) {
                    tblView.isHidden = true
                } else {
                    tblView.isHidden = false
                }
            }
        }
    }
}

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
//        if indexPath.row == lastRowIndex {
//            pageNo += 1
//            print(pageNo)
//            
//            if (pageNo <= lastPageNo) {
//                isDataLoading = true
//                print("Ab Call Krana Hai")
//                getSearchData()
//              
//            } else {
//                print("Ye last page hai ... isliye api call nahi krani hai")
//                
//            }
//        }
//    }


//        if let results = GiftsManager.shared.giftResults {
//            let matchingGifts = results.filter { result in
//                guard let gifts = result.gifts else { return false }
//                return gifts.contains(where: { $0.animationFile == giftUrl })
//            }
//
//            if !matchingGifts.isEmpty {
//                for gift in matchingGifts {
//                    print(gift)
//                    // Uncomment the line below to print the message with URL and animation file
//                    // print("Matching gift with URL '\(GiftsManager.shared.giftUrl)' and animation file '\(gift.animationFile ?? "")': \(gift)")
//                }
//            } else {
//                print("No matching gifts found.")
//            }
//        } else {
//            print("Gift results not available.")
//        }

//        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//
//                let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
//                scrollView.panGestureRecognizer.isEnabled = false
//
//                self.previousIndex = self.currentIndex
//
//                var isRun = false
//                if translatedPoint.y < CGFloat(-offsetY) && self.currentIndex < ((self.momentData.data?.count ?? 1) - 1) {
//                    self.currentIndex += 1
//                    NSLog("向下滑动索引递增")
//                    print("after translating it means Index increases as you scroll down.")
//                    isRun = true
//                    self.newIndex = self.currentIndex + 1
//                    print("The new index here jab scroll upar ki trf karenge tb hai: \(self.newIndex)")
//                }
//
//                if translatedPoint.y > CGFloat(offsetY) && self.currentIndex > 0 {
//                    self.currentIndex -= 1
//                    self.newIndex = self.currentIndex - 1
//                    NSLog("向上滑动索引递减")
//                    print("After translating it means Index decreases as you scroll up.")
//                    isRun = true
//                    print("The new index jab scroll neeche ki trf karenge tab hai: \(self.newIndex)")
//                }
//
//                if (self.momentData.data?.count ?? 0) > 0 {
//                    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
//                        guard let self = self else { return }
//                        let index = IndexPath(row: self.currentIndex, section: 0)
//                        self.tblView?.scrollToRow(at: index, at: .top, animated: false)
//                    } completion: { [weak self] finish in
//                        guard let self = self else { return }
//                        scrollView.panGestureRecognizer.isEnabled = true
//                    }
//                   // scrollView.panGestureRecognizer.isEnabled = true
//                    if isRun {
//
//                        ZLGiftManager.share.remove()
//                        playVideo(videoUrl: momentData.data?[currentIndex].momentVideo?.first?.videoURL ?? "")
//
//                        print("滑动完成")
//                        print("After converted it means Slide Completed")
//                        UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
//                            guard let self = self else { return }
//                            let index = IndexPath(row: self.currentIndex, section: 0)
//                            self.tblView?.scrollToRow(at: index, at: .top, animated: false)
//                        } completion: { [weak self] finish in
//                            guard let self = self else { return }
//                            scrollView.panGestureRecognizer.isEnabled = true
//                        }
//                    }
//                }
//            }
//        }

//    func playVideo(videoUrl: String = "") {
//
//        let player = AVPlayer()
//        let playerLayer = AVPlayerLayer(player: player)
//               playerLayer.frame = tblView.bounds
//               tblView.layer.addSublayer(playerLayer)
//
//               // Load and play the video
//               let videoUrlString = videoUrl //"https://zeeplivesg.oss-ap-southeast-1.aliyuncs.com/zeepliveMomentVidos.mp4"
//               if let videoUrl = URL(string: videoUrlString) {
//                   let mediaItem = AVPlayerItem(url: videoUrl)
//                   // Add observer to know when the player item is ready to play
//                      mediaItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
//
//
//                   player.replaceCurrentItem(with: mediaItem)
//                   player.play()
//               } else {
//                   print("Invalid video URL")
//               }
//
//        player.actionAtItemEnd = .pause // Optional: Pause the player when it reaches the end
//
//               // Assign the player to the class-level property
//               self.player = player // Optional: Pause the player when it reaches the end
//
//        print("The number of gifts in the giftsmanager store is: \(GiftsManager.shared.giftResults?.count)")
//
//    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//
//            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
//            scrollView.panGestureRecognizer.isEnabled = false
//
//            self.previousIndex = self.currentIndex
//
//            var isRun = false
//            if translatedPoint.y < CGFloat(-offsetY) && self.currentIndex < ((self.momentData.data?.count ?? 1) - 1) {
//                self.currentIndex += 1
//                NSLog("向下滑动索引递增") // Scrolling down, index increases
//                print("Index increases as you scroll down.")
//                isRun = true
//                self.newIndex = self.currentIndex + 1
//                print("New index when scrolling up: \(self.newIndex)")
//            }
//
//            if translatedPoint.y > CGFloat(offsetY) && self.currentIndex > 0 {
//                self.currentIndex -= 1
//                self.newIndex = self.currentIndex - 1
//                NSLog("向上滑动索引递减") // Scrolling up, index decreases
//                print("Index decreases as you scroll up.")
//                isRun = true
//                print("New index when scrolling down: \(self.newIndex)")
//            }
//
//            if (self.momentData.data?.count ?? 0) > 0 {
//                UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
//                    guard let self = self else { return }
//                    let index = IndexPath(row: self.currentIndex, section: 0)
//                    self.tblView?.scrollToRow(at: index, at: .top, animated: false)
//                } completion: { [weak self] finish in
//                    guard let self = self else { return }
//                    scrollView.panGestureRecognizer.isEnabled = true
//                }
//
//                if isRun {
//                    ZLGiftManager.share.remove()
//                  //  playVideo(videoUrl: momentData.data?[currentIndex].momentVideo?.first?.videoURL ?? "")
//
//                    print("滑动完成") // Slide completed
//                    print("Slide completed.")
//                    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
//                        guard let self = self else { return }
//                        let index = IndexPath(row: self.currentIndex, section: 0)
//                        self.tblView?.scrollToRow(at: index, at: .top, animated: false)
//                    } completion: { [weak self] finish in
//                        guard let self = self else { return }
//                        scrollView.panGestureRecognizer.isEnabled = true
//                    }
//                }
//            }
//        }
//    }

//    func playVideo(videoUrl: String = "") {
//        // Remove existing player and player layer if they exist
//        if let playerLayer = self.playerLayer {
//            playerLayer.removeFromSuperlayer()
//        }
//        self.player?.pause()
//
//        guard let cell = tblView.visibleCells.first as? ReelsVideoTableViewCell else {
//            // Handle the case where the cell cannot be cast to ReelsVideoTableViewCell
//            return
//        }
//
//        // Initialize player and player layer if not already initialized
//        if self.player == nil {
//            let player = AVPlayer()
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.videoGravity = .resizeAspectFill
//            cell.viewMain.layer.addSublayer(playerLayer)
//
//            self.player = player
//            self.playerLayer = playerLayer
//        }
//
//        // Update player layer frame
//        self.playerLayer?.frame = cell.contentView.bounds
//
//        // Load and play the video
//        if let videoUrl = URL(string: videoUrl) {
//            let mediaItem = AVPlayerItem(url: videoUrl)
//            // Add observer to know when the player item is ready to play
//            mediaItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
//            player?.replaceCurrentItem(with: mediaItem)
//            player?.play()
//        } else {
//            print("Invalid video URL")
//        }
//
//        player?.actionAtItemEnd = .pause // Optional: Pause the player when it reaches the end
//
//        print("The number of gifts in the gifts manager store is: \(GiftsManager.shared.giftResults?.count ?? 0)")
//    }

//  cell.playVideo(videoUrl: momentData.data?[currentIndex].momentVideo?.first?.videoURL ?? "")
//   cell.giftUrl = (momentData.data?[currentIndex].giftURL ?? "")
  // cell.bringSubviewToFront(cell.viewMain)
  // cell.viewMain.isHidden = false
    
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MomentCommentViewController") as! MomentCommentViewController
//        nextViewController.delegate = self
//        nextViewController.cameFrom = "profile"
//      //  nextViewController.hostFollowed = hostFollowed
//        if let selectedMoment = momentData.data?[index] {
//            nextViewController.momentData = selectedMoment
//        } else {
//            print("Error: Moment data at index \(index) is nil.")
//        }
//        //self.navigationController?.pushViewController(nextViewController, animated: true)
//        self.present(nextViewController, animated: true, completion: nil)

//    func playVideo(videoUrl: String = "") {
//        showLoader()
//        // Remove existing player and player layer if they exist
//        if let playerLayer = self.playerLayer {
//            playerLayer.removeFromSuperlayer()
//            self.playerLayer = nil
//        }
//
//        if let player = self.player {
//                player.pause()
//                player.replaceCurrentItem(with: nil)
//                self.player = nil // Clear reference to player
//            }
//
//       // self.player?.pause()
//     //   self.player = nil
//
//        // Ensure there is at least one visible cell
////        guard let cell = tblView.visibleCells.first as? ReelsVideoTableViewCell else {
////            // Handle the case where the cell cannot be cast to ReelsVideoTableViewCell
////            return
////        }
//
//        // Initialize player and player layer
//        let player = AVPlayer()
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds // Use contentView to avoid layout issues
//        playerLayer.videoGravity = .resizeAspectFill
//        self.view.layer.addSublayer(playerLayer)
//        self.view.addSubview(tblView)
//        self.view.addSubview(viewTop)
//
//
////        // Convert cell's viewMain to a CALayer
////        let viewMainLayer = cell.viewMain.layer
////       // tblView.layer.addSublayer(viewMainLayer)
////        // Add cell's viewMain to the table view's content view
////        tblView.addSubview(cell.viewMain)
////        print("The video player playing layer size is: \(playerLayer.frame)")
////        // Create a view to display content above the player layer
////        let overlayView = UIView(frame: tblView.bounds)
////        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Example background color
////
////        // Add other subviews or content to the overlayView
////        // For example:
////        let titleLabel = UILabel(frame: CGRect(x: 20, y: 300, width: 200, height: 30))
////        titleLabel.text = "Overlay Content"
////        titleLabel.textColor = UIColor.red
//////        overlayView.addSubview(cell.viewMain)
////        overlayView.addSubview(titleLabel)
////
////        // Add the overlay view above the player layer
////        tblView.addSubview(overlayView)
//
//
//        // Load and play the video
//        if let videoUrl = URL(string: videoUrl) {
//            let mediaItem = AVPlayerItem(url: videoUrl)
//            // Add observer to know when the player item is ready to play
//            mediaItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
//            player.replaceCurrentItem(with: mediaItem)
//            player.rate = 1.0
//            player.play() // Start playing the video
//        } else {
//            print("Invalid video URL")
//        }
//
//        player.actionAtItemEnd = .pause // Optional: Pause the player when it reaches the end
//
//        // Assign the player and player layer to the class-level properties
//        self.player = player
//        self.playerLayer = playerLayer
//
//    }

// Observer method for player item status
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "status" {
//            if let playerItem = object as? AVPlayerItem {
//                if playerItem.status == .readyToPlay {
//                    print("Video started playing")
//                    hideLoader()
//               //     player?.rate = 1.0
//                 //   player?.play()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                      //  self.playAnimation(giftUrl: self.momentData.data?[self.currentIndex].giftURL ?? "")
//                    }
//
//                } else if playerItem.status == .failed {
//                    print("Failed to load video")
//                }
//            }
//        }
//    }
