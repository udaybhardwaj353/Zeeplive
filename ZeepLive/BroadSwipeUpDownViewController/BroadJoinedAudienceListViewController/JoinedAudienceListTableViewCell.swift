//
//  JoinedAudienceListTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 19/01/24.
//

import UIKit

class JoinedAudienceListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewUserLevel: UIView!
    @IBOutlet weak var imgViewUserLevel: UIImageView!
    @IBOutlet weak var lblUserLevel: UILabel!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var imgViewGender: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        configureUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configureUI() {
    
        viewImage.layer.cornerRadius = viewImage.frame.height / 2
        viewImage.clipsToBounds = true
        viewGender.layer.cornerRadius = viewGender.frame.height / 2
        viewGender.clipsToBounds = true
        viewGender.layer.borderWidth = 1
        viewGender.layer.borderColor = UIColor.gray.cgColor
        
    }
    
}
