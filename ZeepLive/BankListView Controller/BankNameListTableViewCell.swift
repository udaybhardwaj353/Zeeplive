//
//  BankNameListTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/03/24.
//

import UIKit

class BankNameListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblBankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
