//
//  FreeTargetTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 26/09/23.
//

import UIKit

protocol delegateFreeTargetTableViewCell: AnyObject {

    func answer(isSelected: Bool)
    
}

class FreeTargetTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgViewBackgroundImage: UIImageView!
    @IBOutlet weak var btnRulesAcceptedOutlet: UIButton!
    @IBOutlet weak var btnApplyNowOutlet: UIButton!
    var isRulesSelectedButtonPressed = false
    weak var delegate: delegateFreeTargetTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        btnApplyNowOutlet.layer.cornerRadius = 20
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func btnRulesAcceptedPressed(_ sender: Any) {
        
        print("Button Rules Accepted pressed")
      
        if isRulesSelectedButtonPressed
        {
            isRulesSelectedButtonPressed = false
            btnRulesAcceptedOutlet.setImage(UIImage(named:  "FreeTargetUnTickImage"), for: .normal)
            
        }
        else{
            
            isRulesSelectedButtonPressed = true
            btnRulesAcceptedOutlet.setImage(UIImage(named:  "FreeTargetTickImage"), for: .normal)
        
        }
        
    }
    
    @IBAction func btnApplyNowPressed(_ sender: Any) {
        
        print("Button Apply Now Pressed")
        print(isRulesSelectedButtonPressed)
        
        if (isRulesSelectedButtonPressed == true) {
        
            print("Agle page par jaega")
            delegate?.answer(isSelected: isRulesSelectedButtonPressed)
            
        } else {
            
            print("Agle page par nahi jaega")
            delegate?.answer(isSelected: isRulesSelectedButtonPressed)
            
        }
        
    }
    
}
