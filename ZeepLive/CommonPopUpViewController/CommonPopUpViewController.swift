//
//  CommonPopUpViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 19/03/24.
//

import UIKit

protocol delegateCommonPopUpViewController: AnyObject {

    func deleteButtonPressed(isPressed:Bool)
    
}

class CommonPopUpViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBOutlet weak var btnCancelOutlet: UIButton!
  
    weak var delegate: delegateCommonPopUpViewController?
    lazy var headingText: String = "Are you sure to Delete Current Bank Account?"
    lazy var buttonName: String = "Delete"
    lazy var backgroundColour: UIColor = .clear
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    @IBAction func btnDeletePressed(_ sender: Any) {
        
        print("Button Delete Pressed.")
        delegate?.deleteButtonPressed(isPressed: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        
        print("Button Cancel Pressed.")
        dismiss(animated: true, completion: nil)
        
    }
    
    func configureUI() {
    
        btnCancelOutlet.setTitleColor(GlobalClass.sharedInstance.setSelectedPagerColour(), for: .normal)
        btnCancelOutlet.layer.cornerRadius = btnCancelOutlet.frame.height / 2
        btnCancelOutlet.layer.borderWidth = 1.5
        btnCancelOutlet.layer.borderColor = GlobalClass.sharedInstance.setSelectedPagerColour().cgColor
        btnDeleteOutlet.layer.cornerRadius = btnDeleteOutlet.frame.height / 2
        addGradient(to: btnDeleteOutlet, width: btnDeleteOutlet.frame.width, height: btnDeleteOutlet.frame.height, cornerRadius: btnDeleteOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        viewMain.layer.cornerRadius = 20
        view.backgroundColor = backgroundColour //.clear//.black.withAlphaComponent(0.4)
        
        lblHeading.text = headingText
        btnDeleteOutlet.setTitle(buttonName, for: .normal)
        
    }
    
}
