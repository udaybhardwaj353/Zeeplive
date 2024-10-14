//
//  BankAccountListTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 15/03/24.
//

import UIKit

protocol delegateBankAccountListTableViewCell: AnyObject {

    func accountSelected(index:Int)
    func deleteAccount(index:Int)
    
}

class BankAccountListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccountDetails: UILabel!
    @IBOutlet weak var btnAccountSelectedOutlet: UIButton!
    @IBOutlet weak var btnDeleteBankAccountOutlet: UIButton!
    
    weak var delegate: delegateBankAccountListTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAccountSelectedPressed(_ sender: UIButton) {
        
        print("Button Account Selected Pressed.")
        delegate?.accountSelected(index: sender.tag)
        
    }
    
    @IBAction func btnDeleteBankAccountPressed(_ sender: UIButton) {
        
        print("Button Delete Bank Account Pressed.")
        delegate?.deleteAccount(index: sender.tag)
        
    }
    
}
