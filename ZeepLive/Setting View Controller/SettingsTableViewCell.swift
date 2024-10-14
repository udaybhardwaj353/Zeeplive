//
//  SettingsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/05/23.
//

import UIKit

protocol delegateSettingsTableViewCell: AnyObject {

    func logoutPressed(isPressed:Bool)
    
}

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblOptionName: UILabel!
    @IBOutlet weak var imgViewArrow: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewMainBottomHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewMainTopHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnLogoutOutlet: UIButton!
    @IBOutlet weak var viewDashLine: UIView!
    weak var delegate: delegateSettingsTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        //viewContent.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        btnLogoutOutlet.layer.cornerRadius = 18
        viewDashLine.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnLogoutPressed(_ sender: Any) {
        
        delegate?.logoutPressed(isPressed: true)
        
        print("Logout button pressed")
        
    }
    
}
