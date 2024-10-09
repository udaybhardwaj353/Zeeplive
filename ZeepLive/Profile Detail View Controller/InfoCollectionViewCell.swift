//
//  InfoCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 06/07/23.
//

import UIKit

protocol delegateInfoCollectionViewCell: AnyObject {

    func buttonFollowPressed(isPressed: Bool)
    
}

class InfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewUserDetails: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewUserStatus: UIView!
    @IBOutlet weak var lblUserStatus: UILabel!
    @IBOutlet weak var viewUserAge: UIView!
    @IBOutlet weak var imgViewUserAge: UIImageView!
    @IBOutlet weak var lblUserAge: UILabel!
    @IBOutlet weak var btnFollowOutlet: UIButton!
    
    @IBOutlet weak var viewUserCountry: UIView!
    @IBOutlet weak var lblUserCountry: UILabel!
    
    @IBOutlet weak var viewUserId: UIView!
    @IBOutlet weak var lblUserId: UILabel!
    
    @IBOutlet weak var viewUserLevel: UIView!
    @IBOutlet weak var imgViewUserLevel: UIImageView!
    @IBOutlet weak var lblLevelName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    
    weak var delegate: delegateInfoCollectionViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        imgViewUserPhoto.layer.borderWidth = 1.0
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.borderColor = UIColor.white.cgColor
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.width / 2
        imgViewUserPhoto.clipsToBounds = true
        
        viewUserStatus.layer.cornerRadius = 7
        viewUserAge.layer.cornerRadius = 10
        viewUserCountry.layer.cornerRadius = 10
        viewUserId.layer.cornerRadius = 10
        
    }
    
    @IBAction func btnFollowPressed(_ sender: Any) {
        
        print("Button Follow User Pressed")
        delegate?.buttonFollowPressed(isPressed: true)
        
    }
    
    deinit {
        
        imgViewUserAge = nil
        imgViewUserLevel = nil
        imgViewUserPhoto = nil
        delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
}
