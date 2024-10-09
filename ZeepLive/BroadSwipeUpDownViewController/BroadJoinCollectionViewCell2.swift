//
//  BroadJoinCollectionViewCell2.swift
//  ZeepLive
//
//  Created by Creative Franzy 003 on 07/10/24.
//

import UIKit
import Kingfisher

class BroadJoinCollectionViewCell2: UICollectionViewCell {

    @IBOutlet weak var viewMain2: UIView!
    @IBOutlet weak var imgViewUserPhoto2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    deinit {
        
        print("deinit call hua hai broad join collection view cell main.")
        viewMain2.removeFromSuperview()
        imgViewUserPhoto2 = nil
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
       
        imgViewUserPhoto2.image = nil
        imgViewUserPhoto2.kf.cancelDownloadTask()
    }
    
}
