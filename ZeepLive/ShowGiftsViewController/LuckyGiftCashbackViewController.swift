//
//  LuckyGiftCashbackViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 02/02/24.
//

import UIKit

class LuckyGiftCashbackViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblGiftName: UILabel!
    @IBOutlet weak var viewWonAmount: UIView!
    @IBOutlet weak var lblWonAmount: UILabel!
    @IBOutlet weak var viewAwesomeOutlet: UIButton!
    lazy var giftName: String = "N/A"
    lazy var giftAmount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.2)
        lblWonAmount.textColor = GlobalClass.sharedInstance.setLuckyGiftAmountColour()
        lblGiftName.textColor = GlobalClass.sharedInstance.setLuckyGiftAmountColour()
        lblWonAmount.text = "Won" + " " + String(giftAmount)
        lblGiftName.text = "by sending" + " " + giftName
        
    }
    
    @IBAction func viewAwesomePressed(_ sender: Any) {
        
        print("View Awesome Pressed For Closing the lucky gift page.")
        dismiss(animated: false, completion: nil)
        
    }
    
}
