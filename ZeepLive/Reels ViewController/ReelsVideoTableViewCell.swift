//
//  ReelsVideoTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 07/06/24.
//

import UIKit
import AVFoundation

protocol delegateReelsVideoTableViewCell: AnyObject {

    func buttonHostImageClicked(index:Int)
    func buttonSendGiftClicked(index:Int)
    func buttonLikeReelClicked(isClicked:Bool, index:Int)
    func buttonCommentClicked(index:Int)
    
}

class ReelsVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnHostImageOutlet: UIButton!
    @IBOutlet weak var imgViewHostImage: UIImageView!
    @IBOutlet weak var btnSendGiftOutlet: UIButton!
    @IBOutlet weak var lblSendGiftCount: UILabel!
    @IBOutlet weak var btnLikeReelOutlet: UIButton!
    @IBOutlet weak var lblLikeReelCount: UILabel!
    @IBOutlet weak var btnCommentOutlet: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblHostDescriptionMessage: UILabel!
    @IBOutlet weak var viewLuckyGift: UIView!
    @IBOutlet weak var lblNoOfGift: UILabel!
    @IBOutlet weak var viewLuckyGiftDetails: UIView!
    @IBOutlet weak var viewUserImage: UIView!
    @IBOutlet weak var viewGiftImage: UIView!
    @IBOutlet weak var lblSendGiftHostName: UILabel!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var imgViewGift: UIImageView!
    @IBOutlet weak var imgViewReelLike: UIImageView!
    
    var player: AVPlayer?
      var playerLayer: AVPlayerLayer?
    lazy var giftUrl: String = ""
    weak var delegate: delegateReelsVideoTableViewCell?
    lazy var isLikeButtonPressed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        configureUI()
      //  NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configureUI() {
       
        viewLuckyGift.isHidden = true
        viewLuckyGiftDetails.layer.cornerRadius = viewLuckyGiftDetails.frame.height / 2
        viewLuckyGiftDetails.backgroundColor = .black.withAlphaComponent(0.3)
        viewGiftImage.layer.cornerRadius = viewGiftImage.frame.height / 2
        viewUserImage.layer.cornerRadius = viewUserImage.frame.height / 2
        imgViewGift.layer.cornerRadius = imgViewGift.frame.height / 2
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        
        btnHostImageOutlet.layer.cornerRadius = btnHostImageOutlet.frame.height / 2
        imgViewHostImage.layer.cornerRadius = imgViewHostImage.frame.height / 2
        imgViewHostImage.clipsToBounds = true
        imgViewHostImage.layer.masksToBounds = true
        
    }
    
    @IBAction func btnHostImagePressed(_ sender: UIButton) {
        
        print("Button Host Image Pressed.")
        delegate?.buttonHostImageClicked(index: sender.tag)
        
    }
    
    @IBAction func btnSendGiftPressed(_ sender: UIButton) {
        
        print("Button Send Gift Pressed.")
        delegate?.buttonSendGiftClicked(index: sender.tag)
        
    }
    
    @IBAction func btnLikeReelPressed(_ sender: UIButton) {
        
        print("Button Like Reel Pressed.")
        
        if isLikeButtonPressed
       
        {
            imgViewReelLike.image = UIImage(named: "Reellike")
           // btnLikeReelOutlet.setImage(UIImage(named:  "Like"), for: .normal)
            isLikeButtonPressed = false
        }
        else{
            
            imgViewReelLike.image = UIImage(named: "MomentLike")
         //   btnLikeReelOutlet.setImage(UIImage(named:  "MomentLike"), for: .normal)
            isLikeButtonPressed = true
          
        }
        
        delegate?.buttonLikeReelClicked(isClicked: isLikeButtonPressed, index: sender.tag)
        
    }
    
    @IBAction func btnCommentPressed(_ sender: UIButton) {
        
        print("Button Comment On Reel Pressed.")
        delegate?.buttonCommentClicked(index: sender.tag)
        
    }
    
    
}

//extension ReelsVideoTableViewCell {
//    
//    @objc func playerDidFinishPlaying() {
//        player?.seek(to: CMTime.zero)
//        player?.play()
//        print("Video play hona khtm ho gya. ab phir se play hoga.")
//       playAnimation(giftUrl: giftUrl)
//        
//    }
//    
//    func playVideo(videoUrl: String = "") {
//            // Remove existing player and player layer if they exist
//            if let playerLayer = self.playerLayer {
//                playerLayer.removeFromSuperlayer()
//            }
//            self.player?.pause()
//            
//            // Initialize player and player layer
//            let player = AVPlayer()
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = contentView.bounds //UIScreen.main.bounds //contentView.bounds // Use contentView to avoid layout issues
//            playerLayer.videoGravity = .resizeAspectFill
//            contentView.layer.addSublayer(playerLayer)
//            
//            print("THe video player playing layer size is: \(playerLayer.frame)")
//        
//            // Load and play the video
//            if let videoUrl = URL(string: videoUrl) {
//                let mediaItem = AVPlayerItem(url: videoUrl)
//                // Add observer to know when the player item is ready to play
//                mediaItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
//                player.replaceCurrentItem(with: mediaItem)
//                player.play() // Start playing the video
//            } else {
//                print("Invalid video URL")
//            }
//            
//            player.actionAtItemEnd = .pause // Optional: Pause the player when it reaches the end
//            
//            // Assign the player and player layer to the class-level properties
//            self.player = player
//            self.playerLayer = playerLayer
//        }
//    
//    func playAnimation(giftUrl: String = "") {
//        
//        
//        if let results = GiftsManager.shared.giftResults {
//            if let matchingGift = results.first(where: { result in
//                guard let gifts = result.gifts else { return false }
//                return gifts.contains(where: { $0.animationFile == giftUrl })
//            }) {
//                guard let gift = matchingGift.gifts?.first(where: { $0.animationFile == giftUrl }) else {
//                    print("Gift details not found.")
//                    return
//                }
//                
//                // Print the details of the matching gift
//                print("Matching gift details:")
//                print("ID: \(gift.id ?? 0)")
//                print("Name: \(gift.giftName ?? "")")
//                print("Animation File: \(gift.animationFile ?? "")")
//                // Print other properties as needed
//                var sendGiftModel = Gift()
//                sendGiftModel.id = gift.id
//                //     sendGiftModel.giftCategoryID
//                sendGiftModel.giftName = gift.giftName
//                sendGiftModel.image = gift.image
//                sendGiftModel.amount = gift.amount
//                sendGiftModel.animationType = gift.animationType
//                sendGiftModel.isAnimated = gift.isAnimated
//                sendGiftModel.animationFile = gift.animationFile
//                sendGiftModel.soundFile = gift.soundFile
//                sendGiftModel.imageType = gift.imageType
//                
//                if (sendGiftModel.animationType == 0) {
//                    print("Animation play nahi krana hai")
//                } else {
//                    print("Animation play krana hai")
//                    ZLGiftManager.share.playAnimation(gift: sendGiftModel, vc: ReelsViewController())
//                }
//                
//            } else {
//                print("No matching gift found.")
//            }
//        } else {
//            print("Gift results not available.")
//        }
//    }
//    
//    // Observer method for player item status
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "status" {
//            if let playerItem = object as? AVPlayerItem {
//                if playerItem.status == .readyToPlay {
//                    print("Video started playing")
//                    
//                    player?.play()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        self.playAnimation(giftUrl: self.giftUrl)
//                    }
//                } else if playerItem.status == .failed {
//                    print("Failed to load video")
//                }
//            }
//        }
//    }
//    
//}
