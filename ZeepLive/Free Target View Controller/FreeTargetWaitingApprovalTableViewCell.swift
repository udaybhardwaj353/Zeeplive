//
//  FreeTargetWaitingApprovalTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 28/09/23.
//

import UIKit

class FreeTargetWaitingApprovalTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgViewVideoThumbnail: UIImageView!
    @IBOutlet weak var viewWaitingForApproval: UIView!
    @IBOutlet weak var lblUploadOn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        viewImage.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
