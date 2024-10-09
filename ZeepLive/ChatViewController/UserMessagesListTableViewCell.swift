//
//  UserMessagesListTableViewCell.swift
//  TencantOneToOneChat
//
//  Created by Creative Frenzy on 21/08/23.
//

import UIKit

class UserMessagesListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewCounter: UIView!
    @IBOutlet weak var lblCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        imgViewUserPhoto.layer.borderWidth = 1.0
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.borderColor = UIColor.lightGray.cgColor
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.width / 2
        imgViewUserPhoto.clipsToBounds = true
      
        viewCounter.layer.masksToBounds = false
        viewCounter.layer.cornerRadius = viewCounter.frame.size.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
