//
//  EPayBankTransferTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/03/24.
//

import UIKit

protocol delegateEPayBankTransferTableViewCell: AnyObject {

    func openEPayBankTransferClicked(isClicked:Bool)
    
}

class EPayBankTransferTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMainOutlet: UIButton!
    @IBOutlet weak var viewEPayBankTransferOutlet: UIButton!
    @IBOutlet weak var btnBindEPayBankTransferOutlet: UIButton!
    weak var delegate: delegateEPayBankTransferTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnBindEPayBankTransferOutlet.layer.cornerRadius = btnBindEPayBankTransferOutlet.frame.height / 2
        btnBindEPayBankTransferOutlet.layer.borderWidth = 1.5
        btnBindEPayBankTransferOutlet.layer.borderColor = GlobalClass.sharedInstance.setSelectedPagerColour().cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewMainPressed(_ sender: Any) {
        
        print("View Main is Pressed to open the web view.")
        delegate?.openEPayBankTransferClicked(isClicked: true)
        
    }
    
    @IBAction func viewEPayBankTransferPressed(_ sender: Any) {
        
        print("View Bank Transfer is Pressed to open the web view.")
        delegate?.openEPayBankTransferClicked(isClicked: true)
        
    }
    
    @IBAction func btnBindEPayBankTransferPressed(_ sender: Any) {
        
        print("Button EPay Bank Transfer Bind Pressed.")
        delegate?.openEPayBankTransferClicked(isClicked: true)
        
    }
    
}
