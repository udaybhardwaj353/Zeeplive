//
//  DiamondPriceDetailsCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 02/05/23.
//

import UIKit

class DiamondPriceDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNoOfDiamonds: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        viewMain.layer.borderWidth = 1.5
        viewMain.layer.borderColor = GlobalClass.sharedInstance.setGapColour().cgColor
        viewMain.layer.cornerRadius = 10
        lblPrice.textColor = .darkGray//GlobalClass.sharedInstance.setDiamondPriceColor()
        
    }

    override func prepareForReuse() {
      //  self.removeFromSuperview()
    }
    
    deinit {
        
        imgView = nil
        lblNoOfDiamonds = nil
        lblPrice = nil
        
        self.removeFromSuperview()
        print("deinit par aaya hai")
    }
}
