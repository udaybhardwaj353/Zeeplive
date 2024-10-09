//
//  AccountOptionsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/05/23.
//

import UIKit

class AccountOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblOptionName: UILabel!
    @IBOutlet weak var imgViewArrow: UIImageView!
    @IBOutlet weak var lblMyBalanceCount: UILabel!
    @IBOutlet weak var imgViewDiamond: UIImageView!
    @IBOutlet weak var viewDashLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        viewDashLine.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
