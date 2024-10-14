//
//  AccountDetailsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/05/23.
//

import UIKit

protocol delegateAccountDetailsTableViewCell: AnyObject {

    func butttonPressed(buttonPressed:String)
    
}

class AccountDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewUserLevel: UIView!
    @IBOutlet weak var imgViewLevel: UIImageView!
    @IBOutlet weak var lblUserLevel: UILabel!
    @IBOutlet weak var lblUserCityName: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var viewFriendOutlet: UIControl!
    @IBOutlet weak var lblFriendCount: UILabel!
    @IBOutlet weak var viewFollowingOutlet: UIControl!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var viewFollowers: UIControl!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewCountry: UIView!
    
   weak var delegate: delegateAccountDetailsTableViewCell?
    @IBOutlet weak var viewUserImageBackgroundOutlet: UIControl!
    @IBOutlet weak var btnUserProfileOutlet: UIButton!
    @IBOutlet weak var viewUserID: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgViewUserPhoto.layer.borderWidth = 1.0
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.borderColor = UIColor.white.cgColor
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.width / 2
        imgViewUserPhoto.clipsToBounds = true
        viewContent.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        
        imgViewBackground.image = UIImage(named: "AccountBackgroundImage")
        viewCountry.layer.cornerRadius = 10
        viewUserID.layer.cornerRadius = viewUserID.frame.size.height / 2
        
    }

    override func prepareForReuse() {
           super.prepareForReuse()
           
           // Reset the cell's state to its default values
           imgViewBackground.image = nil
        //   imgViewUserPhoto.image = nil
           lblUserName.text = nil
           lblUserLevel.text = nil
           lblUserCityName.text = nil
           lblUserId.text = nil
           lblFriendCount.text = nil
           lblFollowingCount.text = nil
           lblFollowersCount.text = nil
       }
    
    deinit {
        
            delegate = nil
            NotificationCenter.default.removeObserver(self)
            imgViewBackground.image = nil
            imgViewUserPhoto.image = nil
           
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func viewUserImageBackgroundPressed(_ sender: Any) {
        
        print("View User Background Pressed")
        delegate?.butttonPressed(buttonPressed: "Viewbackground")
    }
    
    @IBAction func viewFriendPressed(_ sender: Any) {
        
        print("View See Friends List Pressed")
        delegate?.butttonPressed(buttonPressed: "Friends")
        
    }
    
    @IBAction func viewFollowingPressed(_ sender: Any) {
        
        print("View See Following List Pressed")
        delegate?.butttonPressed(buttonPressed: "Following")
        
    }
    
    @IBAction func viewFollowersPressed(_ sender: Any) {
        
        print("View See Followers List Pressed")
        delegate?.butttonPressed(buttonPressed: "Followers")
        
    }
    
    @IBAction func btnUserProfilePressed(_ sender: Any) {
        
        print("Button View User Profile Pressed")
        delegate?.butttonPressed(buttonPressed: "Viewbackground")
        
    }
    
}
