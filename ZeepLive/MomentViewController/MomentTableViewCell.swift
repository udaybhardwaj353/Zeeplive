//
//  MomentTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/01/24.
//

import UIKit
import Kingfisher

protocol delegateMomentTableViewCell: AnyObject {

    func isOptionButtonClicked(isclicked:Bool)
    func likeButtonClicked(isClicked:Bool, index:Int)
    func commentButtonClicked(index:Int)
    func sendGiftButtonClicked(isClicked:Bool, index:Int)
    func imageClicked(type:String,index:Int)
    func followButtonClicked(index:Int)
    
}

class MomentTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnOptionOutlet: UIButton!
    @IBOutlet weak var btnFollowUserOutlet: UIButton!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var lblUserMessage: UILabel!
    @IBOutlet weak var btnCommentOutlet: UIButton!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var btnGiftOutlet: UIButton!
    @IBOutlet weak var collectionViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var imgViewPlayVideo: UIImageView!
    @IBOutlet weak var collectionViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewMainBottomConstraints: NSLayoutConstraint!
    
    
    lazy var momentData = MomentResult()
    weak var delegate: delegateMomentTableViewCell?
    var getProductImage: [MomentImageElement] = []
    lazy var count: Int = 0
    lazy var momentType: String = ""
    var getMomentVideo: [MomentVideo] = []
    lazy var momentIndex: Int = 0
    
   lazy var isLikeButtonPressed = true
   lazy var isSendGiftButtonPressed = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        configureUI()
        registerCollectionView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configureUI () {
    
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.height / 2
        imgViewUserPhoto.clipsToBounds = true
        
    }
    
    func registerCollectionView() {
    
        collectionView.register(UINib(nibName: "MomentImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MomentImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
    }
    
    func configure(with images: [MomentImageElement], at index: Int, of type: String) {
        momentIndex = index
        momentType = type
        count = images.count
        print("The images are: \(images)")
        print("The index of the images are: \(index)")
        print("The images count are: \(images.count)")
        self.getProductImage = images
        collectionView.tag = index 
        collectionView.reloadData()
        
    }
    
    func configureForVideo(with video: [MomentVideo], at index: Int, of type: String) {
        momentIndex = index
        momentType = type
        count = video.count
       
        self.getMomentVideo = video
        collectionView.tag = index
        print("The moment type is: \(momentType)")
        print("The moment video data is: \(self.getMomentVideo)")
        collectionView.reloadData()
        
    }
    
    @IBAction func btnOptionPressed(_ sender: Any) {
        
        print("Button Option Pressed")
        delegate?.isOptionButtonClicked(isclicked: true)
        
    }
    
    @IBAction func btnFollowUserPressed(_ sender: UIButton) {
        
        print("Button Follow User Pressed")
        delegate?.followButtonClicked(index: sender.tag)
        btnFollowUserOutlet.isHidden = true
        
    }
    
    @IBAction func btnCommentPressed(_ sender: UIButton) {
        
        print("Button Comment Pressed")
        delegate?.commentButtonClicked(index: sender.tag)
        
    }
    
    @IBAction func btnLikePressed(_ sender: UIButton) {
        
        print("Button Like Post Pressed")
       
        if isLikeButtonPressed
        {
            isLikeButtonPressed = false
        }
        else{
          
            isLikeButtonPressed = true
          
        }
        
        delegate?.likeButtonClicked(isClicked: isLikeButtonPressed, index: sender.tag)
    }
    
    @IBAction func btnGiftPressed(_ sender: UIButton) {
        
        print("Button Send Gift Pressed")
       
        if isSendGiftButtonPressed
        {
            isSendGiftButtonPressed = false
        }
        else{
          
            isSendGiftButtonPressed = true
          
        }
        
        delegate?.sendGiftButtonClicked(isClicked: isSendGiftButtonPressed, index: sender.tag)
    }
    
}

extension MomentTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentImageCollectionViewCell", for: indexPath) as! MomentImageCollectionViewCell
        
        if (momentType == "image") {
            // Check if index is valid within getProductImage array
            guard indexPath.row < getProductImage.count else {
                return cell
            }
            
            cell.imgView.image = nil
            let imageUrl = getProductImage[indexPath.row].imageName!
            if let profileImageURL = URL(string: imageUrl) {
                print("THe image in collection view url is: \(imageUrl)")
                KF.url(profileImageURL)
                //  .downsampling(size: CGSize(width: 200, height: 200))
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
            
            return cell
        } else {
            
            guard indexPath.row < getMomentVideo.count else {
                return cell
            }
            
            cell.imgView.image = nil
            let imageUrl = getMomentVideo[indexPath.row].videoThumbnail!
            if let profileImageURL = URL(string: imageUrl) {
                print("THe image in video collection view url is: \(imageUrl)")
                KF.url(profileImageURL)
                //  .downsampling(size: CGSize(width: 200, height: 200))
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
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if count == 3 {
            if indexPath.item < 2 {
                // For the first two cells in the top half
               // let totalWidth = collectionView.frame.size.width
                let width = collectionView.frame.size.width / 2 // Adjust the cell width as needed (70% of the total width divided by 2 cells)
                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            } else {
                // For the third cell covering the rest of the collection view
                let width = collectionView.frame.size.width - 2 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            }
        } else if count == 4 {
            if indexPath.item < 2 {
                // For the first two cells in the top half
                let width = collectionView.frame.size.width / 2 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            } else {
                // For the remaining two cells covering the rest of the collection view
                let width = collectionView.frame.size.width / 2 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            }
        } else if count == 5 {
            if indexPath.item < 3 {
                // For the first three cells in the top half
                let width = (collectionView.frame.size.width - 1 * 3 ) / 3 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            } else {
                // For the remaining two cells covering the rest of the collection view
                let width = collectionView.frame.size.width / 2 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            }
            
        }  else if count == 6 {
            if indexPath.item < 3 {
                // For the first three cells in the top half
                let width = collectionView.frame.size.width / 3 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            } else {
                // For the remaining three cells covering the rest of the collection view
                let width = collectionView.frame.size.width / 3 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            }
        }  else if count == 7 {
            if indexPath.item < 3 {
                // For the first three cells in the top half
                let width = collectionView.frame.size.width / 3 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 3 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            } else {
                // For the remaining three cells covering the rest of the collection view
                let width = collectionView.frame.size.width / 3 // Adjust the cell width as needed
                let height = collectionView.frame.size.height / 3 // Adjust the cell height as needed
                return CGSize(width: width, height: height)
            }
        }  else if count == 8 {
            if indexPath.item < 3 {
                // For the first 6 cells in the 3x3 grid
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 3
                return CGSize(width: width, height: height)
            } else {
                // For the last 2 cells in the bottom row
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 3
                return CGSize(width: width, height: height)
            }
            
        }   else if count == 9 {
            if indexPath.item < 9 {
                // For all 9 cells in the 3x3x3 grid
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 3
                return CGSize(width: width, height: height)
            }
        } else {
            // For other counts, apply your existing logic
            let width = (Int(collectionView.frame.size.width) - 1 * count) / count // Adjust the cell width as needed
            let height = Int(collectionView.frame.size.height)  // Adjust the cell height as needed
            return CGSize(width: width, height: height)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at indexPath: \(indexPath.section), \(indexPath.row)")
        // Handle selection as needed
        print(getProductImage)
        print("THe images count is: \(getProductImage.count)")
        print("The count is: \(count)")
        delegate?.imageClicked(type: momentType, index: momentIndex)
    }
    
}

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if count == 3 {
//            if indexPath.item < 2 {
//                // For the first two cells in the top half
//               // let totalWidth = collectionView.frame.size.width
//                let width = collectionView.frame.size.width / 2 // Adjust the cell width as needed (70% of the total width divided by 2 cells)
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            } else {
//                // For the third cell covering the rest of the collection view
//                let width = collectionView.frame.size.width - 2 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            }
//        } else if count == 4 {
//            if indexPath.item < 2 {
//                // For the first two cells in the top half
//                let width = collectionView.frame.size.width / 2 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            } else {
//                // For the remaining two cells covering the rest of the collection view
//                let width = collectionView.frame.size.width / 2 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            }
//        } else if count == 5 {
//            if indexPath.item < 3 {
//                // For the first three cells in the top half
//                let width = (collectionView.frame.size.width - 1 * 3 ) / 3 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            } else {
//                // For the remaining two cells covering the rest of the collection view
//                let width = collectionView.frame.size.width / 2 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            }
//            
//        }  else if count == 6 {
//            if indexPath.item < 3 {
//                // For the first three cells in the top half
//                let width = collectionView.frame.size.width / 3 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            } else {
//                // For the remaining three cells covering the rest of the collection view
//                let width = collectionView.frame.size.width / 3 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            }
//        }  else if count == 7 {
//            if indexPath.item < 3 {
//                // For the first three cells in the top half
//                let width = collectionView.frame.size.width / 3 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 2 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            } else {
//                // For the remaining three cells covering the rest of the collection view
//                let width = collectionView.frame.size.width / 3 // Adjust the cell width as needed
//                let height = collectionView.frame.size.height / 3 // Adjust the cell height as needed
//                return CGSize(width: width, height: height)
//            }
//        }  else {
//            // For other counts, apply your existing logic
//            let width = (Int(collectionView.frame.size.width) - 1 * count) / count // Adjust the cell width as needed
//            let height = Int(collectionView.frame.size.height)  // Adjust the cell height as needed
//            return CGSize(width: width, height: height)
//        }
//    }
    
 
