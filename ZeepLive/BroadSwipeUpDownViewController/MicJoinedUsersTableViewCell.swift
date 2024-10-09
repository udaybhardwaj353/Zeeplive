//
//  MicJoinedUsersTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 26/02/24.
//

import UIKit

class MicJoinedUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewMicUserImage: UIImageView!
    @IBOutlet weak var lblMicUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgViewMicUserImage.layer.cornerRadius = imgViewMicUserImage.frame.height / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
}
