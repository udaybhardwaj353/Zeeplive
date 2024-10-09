//
//  SearchUserTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 23/04/24.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewID: UIView!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var viewAge: UIView!
    @IBOutlet weak var imgViewGenderBackground: UIImageView!
    @IBOutlet weak var lblUserAge: UILabel!
    @IBOutlet weak var viewLevel: UIView!
    @IBOutlet weak var imgViewLevelBackground: UIImageView!
    @IBOutlet weak var lblUserLevel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        configureUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
    
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        imgViewUser.clipsToBounds = true
        viewID.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewID.layer.cornerRadius = viewID.frame.height / 2
        
    }
    
}
