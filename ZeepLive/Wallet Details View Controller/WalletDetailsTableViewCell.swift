//
//  WalletDetailsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 09/05/23.
//

import UIKit

class WalletDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblWithdrawDate: UILabel!
    @IBOutlet weak var lblPaymentDate: UILabel!
    @IBOutlet weak var lblUtrNumber: UILabel!
    @IBOutlet weak var lblAccountHeading: UILabel!
    
    
    @IBOutlet weak var viewPaymentStatus: UIView!
    @IBOutlet weak var imgViewPaymentStatus: UIImageView!
    @IBOutlet weak var lblPaymentStatus: UILabel!
    @IBOutlet weak var viewPaymentWidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var lblOrderStatusTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewPaymentStatusTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblUtrNumberHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        viewPaymentStatus.layer.cornerRadius = 15
        viewPaymentStatus.backgroundColor = GlobalClass.sharedInstance.setWalletDetailsBackgroundPaymentStatusColour()
        viewMain.layer.cornerRadius = 10
        viewMain.layer.borderWidth = 0.7
        viewMain.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
