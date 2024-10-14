//
//  MyBalanceIssuesTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/05/23.
//

import UIKit

protocol delegateMyBalanceIssuesTableViewCell: AnyObject {

    func buttonsActions(buttonType:String)
    func viewBannerPressed(isPressed:Bool)
    
}

class MyBalanceIssuesTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnSelectTopUpAgreementOutlet: UIButton!
    @IBOutlet weak var btnTopUpAgreementOutlet: UIButton!
    @IBOutlet weak var btnEmailOutlet: UIButton!
    @IBOutlet weak var viewBannerOutlet: UIControl!
    @IBOutlet weak var imgViewBanner: UIImageView!
    @IBOutlet var viewBannerHeightConstraints: NSLayoutConstraint!
    
   weak var delegate: delegateMyBalanceIssuesTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        btnSelectTopUpAgreementOutlet.isUserInteractionEnabled = false
        viewBannerOutlet.layer.cornerRadius = 10
        imgViewBanner.layer.cornerRadius = 10
        
    }

    override func prepareForReuse() {
           super.prepareForReuse()
           delegate = nil
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSelectTopUpAgreementPressed(_ sender: Any) {
    
        print("Top Up selected Button Pressed")
        
    }
    
    @IBAction func btnTopUpAgreementPressed(_ sender: Any) {
        
        print("Button Top Up Agreement Details Pressed")
        delegate?.buttonsActions(buttonType: "TopUp")
        
    }
    
    @IBAction func btnEmailPressed(_ sender: Any) {
        
        print("Button Email us Pressed")
        delegate?.buttonsActions(buttonType: "Email")
        
    }
    
    @IBAction func viewBannerPressed(_ sender: Any) {
        
        print("Banner View Pressed")
        delegate?.viewBannerPressed(isPressed: true)
        
    }
    
    deinit {
        
        self.delegate = nil
        self.removeFromSuperview()
        print("Yhn  pr deinit mai aaya hai")
    }
    
}
