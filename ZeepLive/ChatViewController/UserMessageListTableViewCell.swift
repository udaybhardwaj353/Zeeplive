//
//  UserMessageListTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/01/24.
//

import UIKit

class UserMessageListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewCounter: UIView!
    @IBOutlet weak var lblCounter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        configureUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        
       // imgViewUserPhoto.layer.borderWidth = 1.0
     //   imgViewUserPhoto.layer.borderColor = UIColor.lightGray.cgColor
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.height / 2
        imgViewUserPhoto.clipsToBounds = true
      
        viewCounter.layer.masksToBounds = false
        viewCounter.layer.cornerRadius = viewCounter.frame.size.height / 2
        
    }
}
