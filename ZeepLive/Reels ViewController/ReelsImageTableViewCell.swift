//
//  ReelsImageTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/06/24.
//

import UIKit
import Kingfisher

protocol delegateReelsImageTableViewCell: AnyObject {

    func buttonHostImageClickedInImageCell(index:Int)
    func buttonSendGiftClickedInImageCell(index:Int)
    func buttonLikeImageClickedInImageCell(isClicked:Bool, index:Int)
    func buttonCommentClickedInImageCell(index:Int)
    
}

class ReelsImageTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnHostImageOutlet: UIButton!
    @IBOutlet weak var imgViewHostImage: UIImageView!
    @IBOutlet weak var btnSendGiftOutlet: UIButton!
    @IBOutlet weak var lblSendGiftCount: UILabel!
    @IBOutlet weak var btnLikeImageOutlet: UIButton!
    @IBOutlet weak var lblLikeImageCount: UILabel!
    @IBOutlet weak var btnCommentOutlet: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblHostDescriptionMessage: UILabel!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var imgViewReelLike: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblHostDescriptionMessageBottomConstraints: NSLayoutConstraint!
    
    lazy var getProductImage: [MomentImageElement] = []
    lazy var count: Int = 0
    weak var delegate: delegateReelsImageTableViewCell?
    lazy var isLikeButtonPressed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        configureUI()
        collectionViewWork()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnHostImagePressed(_ sender: UIButton) {
        
        print("Button Host image clicked in image view controller.")
        delegate?.buttonHostImageClickedInImageCell(index: sender.tag)
        
    }
    
    @IBAction func btnSendGiftPressed(_ sender: UIButton) {
        
        print("Button Send Gift Pressed in image view controller.")
        delegate?.buttonSendGiftClickedInImageCell(index: sender.tag)
        
    }
    
    @IBAction func btnLikeImagePressed(_ sender: UIButton) {
        
        print("Button Like Image Pressed in image view controller.")
        
        if isLikeButtonPressed
       
        {
            imgViewReelLike.image = UIImage(named: "Reellike")
            isLikeButtonPressed = false
        }
        else{
            
            imgViewReelLike.image = UIImage(named: "MomentLike")
            isLikeButtonPressed = true
          
        }
        
        delegate?.buttonLikeImageClickedInImageCell(isClicked: isLikeButtonPressed, index: sender.tag)
        
        
    }
    
    @IBAction func btnCommentPressed(_ sender: UIButton) {
        
        print("Button Comment pressed in image view controller.")
        delegate?.buttonCommentClickedInImageCell(index: sender.tag)
        
    }
    
    func collectionViewWork() {
    
        collectionView.register(UINib(nibName: "ReelImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReelImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func configure(with images: [MomentImageElement], at index: Int, of type: String) {
       
        count = images.count
        print("The images are: \(images)")
        print("The index of the images are: \(index)")
        print("The images count are: \(images.count)")
        self.getProductImage = images
        collectionView.tag = index
        collectionView.reloadData()
        setupPageControl()
        
    }
    
    func configureUI() {
        
        btnHostImageOutlet.layer.cornerRadius = btnHostImageOutlet.frame.height / 2
        imgViewHostImage.layer.cornerRadius = imgViewHostImage.frame.height / 2
        imgViewHostImage.clipsToBounds = true
        imgViewHostImage.layer.masksToBounds = true
        
    }
    
    func setupPageControl() {
    
        if (count <= 1) {
            pageControl.isHidden = true
            lblHostDescriptionMessageBottomConstraints.constant = -20
            
        } else {
            lblHostDescriptionMessageBottomConstraints.constant = 2
            pageControl.isHidden = false
            pageControl.currentPage = 0
            pageControl.numberOfPages = count
            pageControl.pageIndicatorTintColor = .lightGray
            pageControl.currentPageIndicatorTintColor = .white
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
           pageControl.currentPage = Int(pageIndex)
        
       }
    
    deinit {
        
        print("deinit call huya hai reels image table view cell main.")
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearCache() {
            
            print("Saare cache clear hue hai reels image table view cell main.")
        }
        
    }
    
}

// MARK: - EXTENSION FOR USING COLLECTION VIEW DELEGATES AND METHODS TO SHOW DATA AND IT'S FUNCTIONALITIES

extension ReelsImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelImageCollectionViewCell", for: indexPath) as! ReelImageCollectionViewCell
            
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
            
        }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = contentView.frame.width//UIScreen.main.bounds.width
        let screenHeight = contentView.frame.height//UIScreen.main.bounds.height
        return CGSize(width: screenWidth, height: screenHeight)
        
    }
    
}
    

   
