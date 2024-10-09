//
//  CoinDetailsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/05/23.
//

import UIKit

protocol delegateCoinDetailsTableViewCell: AnyObject {

    func buttonCoinDetailsPressed(isPressed:Bool)
    
}

class CoinDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var lblTotalCoins: UILabel!
    @IBOutlet weak var btnCoinDetailsOutlet: UIButton!
    
  weak var delegate: delegateCoinDetailsTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        btnCoinDetailsOutlet.layer.cornerRadius = 15
        btnCoinDetailsOutlet.setTitleColor(GlobalClass.sharedInstance.setButtonCoinDetailsColour(), for: .normal)
        btnCoinDetailsOutlet.backgroundColor = .white
        lblTotalCoins.textColor = .white
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCoinDetailsPressed(_ sender: Any) {
        print("Button Coin Details Pressed")
        delegate?.buttonCoinDetailsPressed(isPressed: true)
        
    }
    
    deinit {
    
        imgViewBackground =  nil
        lblTotalCoins = nil
        self.delegate = nil
//        self.removeFromSuperview()
        print("yhn pr deinit par aaya hai")
    }
    
}
