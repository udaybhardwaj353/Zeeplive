//
//  GiftCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 06/07/23.
//

import UIKit

class GiftCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewGift: UIImageView!
    @IBOutlet weak var lblNoOfGifts: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        viewMain.layer.cornerRadius = 10
        
    }

    deinit {
    
        NotificationCenter.default.removeObserver(self)
        imgViewGift = nil
        lblNoOfGifts = nil
        
    }
}
