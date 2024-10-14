//
//  PaymentDetailsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 09/05/23.
//

import UIKit

class PaymentDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewDashLine: UIView!
    @IBOutlet weak var imgViewCoin: UIImageView!
    @IBOutlet weak var lblNoOfCoins: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lblItemHeading: UILabel!
    @IBOutlet weak var lblPriceHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        viewDashLine.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewContent.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        lblItemHeading.textColor = GlobalClass.sharedInstance.setTextColour()
        lblPriceHeading.textColor = GlobalClass.sharedInstance.setTextColour()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
