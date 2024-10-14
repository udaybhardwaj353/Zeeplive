//
//  LiveMessagesTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 15/01/24.
//

import UIKit

class LiveMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewLevel: UIView!
    @IBOutlet weak var imgViewLevel: UIImageView!
    @IBOutlet weak var lblUserLevel: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserMessage: UILabel!
    @IBOutlet weak var viewLevelWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblUserNameLeftConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.layer.cornerRadius = 10
        viewMain.backgroundColor = .black.withAlphaComponent(0.3)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    deinit {
        
        viewMain.removeFromSuperview()
        viewLevel.removeFromSuperview()
        contentView.subviews.forEach { $0.removeFromSuperview() }
        print("Live message table view cell main deinit call huya hai.")
        
    }
}
