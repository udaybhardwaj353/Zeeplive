//
//  BeansDetailsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/05/23.
//

import UIKit

class BeansDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewDiamond: UIImageView!
    @IBOutlet weak var lblDiamond: UILabel!
    @IBOutlet weak var viewBeansDetails: UIView!
    @IBOutlet weak var imgViewBeans: UIImageView!
    @IBOutlet weak var lblBeans: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        viewBeansDetails.backgroundColor = GlobalClass.sharedInstance.setViewBackgroundColour()
        lblBeans.textColor = GlobalClass.sharedInstance.setTextColour()
        viewBeansDetails.layer.cornerRadius = 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        
           lblDiamond = nil
           lblBeans = nil
           imgViewDiamond = nil
           imgViewBeans = nil
        
       }
    
}
