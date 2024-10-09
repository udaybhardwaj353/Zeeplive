//
//  InSufficientWithdrawalBalanceViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 19/03/24.
//

import UIKit

class InSufficientWithdrawalBalanceViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnOKOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
        
    }
    
    @IBAction func btnOKPressed(_ sender: Any) {
        
        print("Button Close Current PopUp Pressed.")
        dismiss(animated: true, completion: nil)
        
    }
    
    func configureUI() {
    
        view.backgroundColor = .black.withAlphaComponent(0.4)
        // btnOKOutlet.layer.cornerRadius = btnOKOutlet.frame.height / 2
        viewMain.layer.cornerRadius = 10
        addGradient(to: btnOKOutlet, width: btnOKOutlet.frame.width, height: btnOKOutlet.frame.height, cornerRadius: btnOKOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
    }
    
}
