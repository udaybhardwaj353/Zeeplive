//
//  IssueInPurchaseCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 10/01/24.
//

import UIKit

protocol delegateIssueInPurchaseCollectionViewCell: AnyObject {

    func buttonPressed(isPressed:Bool)
    
}

class IssueInPurchaseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnEmailOutlet: UIButton!
    
    weak var delegate: delegateIssueInPurchaseCollectionViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    @IBAction func btnEmailPressed(_ sender: Any) {
        
        print("Button Sent Email Pressed")
        delegate?.buttonPressed(isPressed: true)
        
    }
    
}
