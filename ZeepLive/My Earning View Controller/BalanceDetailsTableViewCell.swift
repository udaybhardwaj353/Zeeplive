//
//  BalanceDetailsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/05/23.
//

import UIKit

protocol delegateBalanceDetailsTableViewCell: AnyObject {

    func buttonViewRecordPressed(isPressed:Bool)
    
}


class BalanceDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewBalance: UIView!
    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var imgViewBean: UIImageView!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnRecordOutlet: UIButton!
    @IBOutlet weak var viewBeansDetails: UIView!
    @IBOutlet weak var lblNoOfBeans: UILabel!
    @IBOutlet weak var lblNoOfDiamond: UILabel!
    
  weak var delegate:delegateBalanceDetailsTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        contentView.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        btnRecordOutlet.backgroundColor = GlobalClass.sharedInstance.setButtonRecordBackgroundColour()
       // btnRecordOutlet.setTitleColor(GlobalClass.sharedInstance.setButtonRecordTextColor(), for: .normal)
        btnRecordOutlet.setTitleColor(UIColor.black, for: .normal)
        btnRecordOutlet.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnRecordPressed(_ sender: Any) {
        
        print("Button Record Pressed")
        delegate?.buttonViewRecordPressed(isPressed: true)
        
    }
    
    deinit {
        
            delegate = nil
            imgViewBackground = nil
            imgViewBean = nil
            lblBalance = nil
        }
    
}
