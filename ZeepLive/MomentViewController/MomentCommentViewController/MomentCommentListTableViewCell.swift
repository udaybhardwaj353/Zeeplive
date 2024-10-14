//
//  MomentCommentListTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/01/24.
//

import UIKit

class MomentCommentListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnOptionOutlet: UIButton!
    @IBOutlet weak var lblUserMessage: UILabel!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        
    }

    func configureUI () {
    
        viewContent.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.height / 2
        imgViewUserPhoto.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnOptionPressed(_ sender: Any) {
        
        print("Button Option Pressed")
        
    }
    
}
