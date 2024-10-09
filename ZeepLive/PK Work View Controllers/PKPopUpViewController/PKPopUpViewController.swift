//
//  PKPopUpViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/24.
//

import UIKit

protocol delegatePKPopUpViewController: AnyObject {

    func buttonRandomMatchPressed(isPressed:Bool)
    func buttonPKWithFriendsPressed(isPressed:Bool)
    
}

class PKPopUpViewController: UIViewController {

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnRandomMatchOutlet: UIButton!
    @IBOutlet weak var btnPKWithFriendsOutlet: UIButton!
    
    weak var delegate: delegatePKPopUpViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureToClose()
       
    }
    
    @IBAction func btnRandomMatchPressed(_ sender: Any) {
        
        print("Button Random Match Pressed For PK.")
        delegate?.buttonRandomMatchPressed(isPressed: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPKWithFriendsPressed(_ sender: Any) {
        
        print("Button PK With Friends Pressed For PK.")
        delegate?.buttonPKWithFriendsPressed(isPressed: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func configureUI() {
    
        viewBottom.layer.cornerRadius = 20
        
    }
    
    func configureToClose() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGesture.cancelsTouchesInView = false
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
