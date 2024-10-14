//
//  GameCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/09/23.
//

import UIKit

protocol delegateGameCollectionViewCell: AnyObject {
    
    func buttonClicked(index:Int)
    
}

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var imgViewGame: UIImageView!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var btnPlayNowOutlet: UIButton!
    
    weak var delegate: delegateGameCollectionViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        btnPlayNowOutlet.layer.cornerRadius = 5
        btnPlayNowOutlet.layer.borderWidth = 1
        btnPlayNowOutlet.layer.borderColor = UIColor.white.cgColor
        btnPlayNowOutlet.backgroundColor = .white.withAlphaComponent(0.3)
        
    }
    
    @IBAction func btnPlayNowPressed(_ sender: UIButton) {
        
        print("Button Play Now Pressed")
        delegate?.buttonClicked(index: sender.tag)
        print("The button pressed is: \(sender.tag)")
        
    }
    
}
