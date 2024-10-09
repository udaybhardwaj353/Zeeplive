//
//  ChooseGenderViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 26/12/23.
//

import UIKit

protocol delegateChooseGenderViewController: AnyObject {

    func genderSelectedByUser(gender:String)
    
}

class ChooseGenderViewController: UIViewController {

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnSelectMaleOutlet: UIButton!
    @IBOutlet weak var btnSelectFemaleOutlet: UIButton!
    @IBOutlet weak var btnSubmitOutlet: UIButton!
    lazy var genderSelected: String = ""
    weak var delegate: delegateChooseGenderViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureToClose()
        configureUI()
        configureGenderSelection()
        print("The genderSelected is \(genderSelected)")
        
    }
    
    @IBAction func btnSelectMalePressed(_ sender: Any) {
        
        print("Button Select Male Pressed")
        btnSelectMaleOutlet.setImage(UIImage(named: "GenderSelect"), for: .normal)
        btnSelectFemaleOutlet.setImage(UIImage(named: "GenderUnSelect"), for: .normal)
        genderSelected = "Male"
        
    }
    
    @IBAction func btnSelectFemalePressed(_ sender: Any) {
        
        print("Button Select Female Pressed")
        btnSelectFemaleOutlet.setImage(UIImage(named: "GenderSelect"), for: .normal)
        btnSelectMaleOutlet.setImage(UIImage(named: "GenderUnSelect"), for: .normal)
        genderSelected = "Female"
        
    }
    
    @IBAction func btnSubmitPressed(_ sender: Any) {
        print("Button Submit Pressed")
        
        delegate?.genderSelectedByUser(gender: genderSelected)
        viewBottom.removeFromSuperview()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func configureUI() {
    
          viewBottom.backgroundColor = .white
          viewBottom.layer.cornerRadius = 34
          
          viewBottom.layer.shadowRadius = 5
          viewBottom.layer.shadowOpacity = 0.5
          viewBottom.layer.shadowColor = UIColor.black.cgColor
          viewBottom.layer.shadowOffset = CGSize(width: 1, height: 1)
        
       // view.addSubview(viewBottom)
        addGradient(to: btnSubmitOutlet, width: btnSubmitOutlet.frame.width, height: btnSubmitOutlet.frame.height, cornerRadius: 22, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
    }
    
    func configureGenderSelection() {
    
        if (genderSelected == "Male") {
             
            btnSelectMaleOutlet.setImage(UIImage(named: "GenderSelect"), for: .normal)
            btnSelectFemaleOutlet.setImage(UIImage(named: "GenderUnSelect"), for: .normal)
            
        } else if (genderSelected == "Female") {
            
            btnSelectFemaleOutlet.setImage(UIImage(named: "GenderSelect"), for: .normal)
            btnSelectMaleOutlet.setImage(UIImage(named: "GenderUnSelect"), for: .normal)
            
        } else {
            
            btnSelectMaleOutlet.setImage(UIImage(named: "GenderUnSelect"), for: .normal)
            btnSelectFemaleOutlet.setImage(UIImage(named: "GenderUnSelect"), for: .normal)
            
        }
        
    }
    
    func configureToClose() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewBottom)
        
        // Check if the tap was inside viewBottom or not
        if viewBottom.bounds.contains(location) {
            // The tap occurred inside viewBottom, handle accordingly (if needed)
            // For example, perform an action or do nothing
            print("View bottom par tap hua hai")
            
        } else {
            
            print("View bottom par tap nahi hua hai")
            // The tap occurred outside viewBottom, dismiss the view controller
            dismiss(animated: true, completion: nil)
        }
    }
    
}
