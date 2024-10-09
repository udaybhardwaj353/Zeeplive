//
//  BroadJoinCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 23/01/24.
//

import UIKit
import Kingfisher

class BroadJoinCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    deinit {
        
        print("deinit call hua hai broad join collection view cell main.")
        viewMain.removeFromSuperview()
        imgViewUserPhoto = nil
        contentView.subviews.forEach { $0.removeFromSuperview() }
        backgroundView = nil
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearCache() {
            // Completion block (optional)
            print("Saare cache clear hue hai collection broad main")
        }
        
    }
    
    func resetCellState() {
       
        imgViewUserPhoto.image = nil
        imgViewUserPhoto.kf.cancelDownloadTask()
    }
    
}
