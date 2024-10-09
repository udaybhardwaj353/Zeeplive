//
//  LiveMessageHeaderTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 15/01/24.
//

import UIKit

class LiveMessageHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblHeaderMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
