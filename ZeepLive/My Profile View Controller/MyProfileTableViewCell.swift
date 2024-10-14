//
//  MyProfileTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 28/08/23.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblOptionName: UILabel!
    @IBOutlet weak var lblUserDetail: UILabel!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var imgViewSideArrow: UIImageView!
    @IBOutlet weak var viewMainHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgViewUserPhotoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        //imgViewUserPhoto.layer.borderWidth = 1.0
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.width / 2
        imgViewUserPhoto.clipsToBounds = true
        viewLine.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewContent.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
