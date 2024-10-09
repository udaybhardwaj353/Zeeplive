//
//  PaymentOptionsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 09/05/23.
//

import UIKit

class PaymentOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblOptionsName: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        viewContent.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
