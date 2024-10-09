//
//  PKRequestListTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 25/06/24.
//

import UIKit

class PKRequestListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgViewHostImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        configureUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
    
        viewImage.layer.cornerRadius = viewImage.frame.height / 2
        imgViewHostImage.layer.cornerRadius = imgViewHostImage.frame.height / 2
        imgViewHostImage.clipsToBounds = true
        
    }
    
}
