//
//  EntranceEffectCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 30/06/23.
//

import UIKit

class EntranceEffectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblGiftName: UILabel!
    @IBOutlet weak var lblGiftPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        viewMain.layer.cornerRadius = 10
        viewMain.backgroundColor = GlobalClass.sharedInstance.setMyStoreOptionsBackgroundColour()
        
    }

    
}
