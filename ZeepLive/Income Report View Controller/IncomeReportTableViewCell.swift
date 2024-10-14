//
//  IncomeReportTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/05/23.
//

import UIKit

class IncomeReportTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgViewSideArrow: UIImageView!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewCallIncome: UIView!
    @IBOutlet weak var viewGiftIncome: UIView!
    @IBOutlet weak var viewBonus: UIView!
    @IBOutlet weak var lblTotalIncome: UILabel!
    @IBOutlet weak var lblCallIncome: UILabel!
    @IBOutlet weak var lblGiftIncome: UILabel!
    @IBOutlet weak var lblBonus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        viewMain.layer.cornerRadius = 15
        viewMain.layer.borderWidth = 1
        viewMain.layer.borderColor = GlobalClass.sharedInstance.setGrayStripColour().cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
