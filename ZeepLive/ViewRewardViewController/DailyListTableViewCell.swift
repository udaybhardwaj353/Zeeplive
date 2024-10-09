//
//  DailyListTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/01/24.
//

import UIKit

class DailyListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCountNumber: UILabel!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserLevel: UILabel!
    @IBOutlet weak var lblTotalBeans: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.height / 2
        imgViewUserPhoto.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
