//
//  HomeScreenUsersListCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/05/23.
//

import UIKit

protocol delegateHomeScreenUsersListCollectionViewCell: AnyObject {
    
    func reportProfileButtonPressed(selectedIndex: Int)
    func callHost(selectedIndex:Int)
    
}

class HomeScreenUsersListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var imgViewLocation: UIImageView!
    @IBOutlet weak var lblUserCountryName: UILabel!
    
    @IBOutlet weak var viewUserStatus: UIView!
    @IBOutlet weak var lblUserStatus: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!

    
    @IBOutlet weak var lblUserNameWidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var btnReportProfileOutlet: UIButton!
    
    weak var delegate: delegateHomeScreenUsersListCollectionViewCell?
   
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var btnCallHostOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
      //  viewMain.layer.cornerRadius = 2.5
      //  imgViewUserPhoto.layer.cornerRadius = 2.5
        viewCountry.layer.cornerRadius = 10
        viewUserStatus.layer.cornerRadius = 10
        btnReportProfileOutlet.isHidden = true
        gradientLayer()
        
    }
    
    @IBAction func btnReportProfilePressed(_ sender: UIButton) {
        
        print("Button Report Profile Pressed")
        print(sender.tag)
        delegate?.reportProfileButtonPressed(selectedIndex: sender.tag)
        
    }
    
    func gradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.viewGradient.bounds
        let startColor = UIColor.black.withAlphaComponent(0.0) .cgColor
        let endColor = UIColor.black.withAlphaComponent(0.8) .cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.viewGradient.layer.insertSublayer(gradientLayer, at: 1)
    }
    
    @IBAction func btnCallHostPressed(_ sender: UIButton) {
        
        print("Button Call Host Pressed.")
        delegate?.callHost(selectedIndex: sender.tag)
      //  sender.isUserInteractionEnabled = false
        
    }
    
}
