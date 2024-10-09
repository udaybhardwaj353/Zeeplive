//
//  PostMomentImageCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/01/24.
//

import UIKit

protocol delegatePostMomentImageCollectionViewCell: AnyObject {

    func selectedImageIndex(index:Int)
    
}

class PostMomentImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDeleteImageOutlet: UIButton!
    
    weak var delegate: delegatePostMomentImageCollectionViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBAction func btnDeleteImagePressed(_ sender: UIButton) {
        
        print("Button Delete Selected Image Pressed")
        delegate?.selectedImageIndex(index: sender.tag)
        
    }
    
}
