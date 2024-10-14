//
//  ShowListsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 10/05/23.
//

import UIKit

protocol delegateShowListsTableViewCell: AnyObject {
    
    func buttonClicked(index: Int, isPressed:Bool)
    
}

class ShowListsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var viewAge: UIView!
    @IBOutlet weak var imgViewAge: UIImageView!
    @IBOutlet weak var lblAge: UILabel!
    
    @IBOutlet weak var viewLevel: UIView!
    @IBOutlet weak var imgViewLevel: UIImageView!
    @IBOutlet weak var lblLevel: UILabel!
    
    @IBOutlet weak var btnFollowOutlet: UIButton!
    
    @IBOutlet weak var viewOnlineStatus: UIView!
    
    weak var delegate: delegateShowListsTableViewCell?
    
    var isFollowButtonPressed = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        imgViewUserPhoto.layer.borderWidth = 1.0
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.borderColor = UIColor.white.cgColor
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.width / 2
        imgViewUserPhoto.clipsToBounds = true
        
//        btnFollowOutlet.layer.cornerRadius = 10
//        btnFollowOutlet.layer.borderWidth = 0.5
//        btnFollowOutlet.layer.borderColor = UIColor.darkGray.cgColor
        
        viewOnlineStatus.layer.borderWidth = 1.0
        viewOnlineStatus.layer.masksToBounds = false
        viewOnlineStatus.layer.borderColor = UIColor.white.cgColor
        viewOnlineStatus.layer.cornerRadius = viewOnlineStatus.frame.size.width / 2
        viewOnlineStatus.clipsToBounds = true
        viewOnlineStatus.backgroundColor = .green
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnFollowPressed(_ sender: UIButton) {
        
        print("Button Follow Pressed")
        
        if isFollowButtonPressed
        {
            isFollowButtonPressed = false
        }
        else{
          
            isFollowButtonPressed = true
          
        }
        
        delegate?.buttonClicked(index: sender.tag, isPressed: isFollowButtonPressed)
        
    }
    
}
