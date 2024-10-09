//
//  IncomeDetailsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/05/23.
//

import UIKit

class IncomeDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblIncomeType: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        viewMain.layer.cornerRadius = 15
        viewMain.layer.borderWidth = 2
        viewMain.layer.borderColor = GlobalClass.sharedInstance.setGrayStripColour().cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
