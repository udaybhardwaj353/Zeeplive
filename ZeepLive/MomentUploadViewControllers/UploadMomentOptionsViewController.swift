//
//  UploadMomentOptionsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 03/01/24.
//

import UIKit

protocol delegateUploadMomentOptionsViewController: AnyObject {

    func buttonClicked(pressedButton: String)
    
}

class UploadMomentOptionsViewController: UIViewController {

    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var stackViewLabels: UIStackView!
    
    @IBOutlet weak var btnRecordVideoOutlet: UIButton!
    @IBOutlet weak var btnSelectImageOulet: UIButton!
    @IBOutlet weak var btnSelectVideoOutlet: UIButton!
    
    weak var delegate: delegateUploadMomentOptionsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
       configureToClose()
        
    }
   
    @IBAction func btnRecordVideoPressed(_ sender: Any) {
        
        print("Button Record Video Option Clicked")
        delegate?.buttonClicked(pressedButton: "recordvideo")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnSelectImagePressed(_ sender: Any) {
        
        print("Button Upload Image Option Clicked")
        delegate?.buttonClicked(pressedButton: "image")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnSelectVideoPressed(_ sender: Any) {
        
        print("Button Upload Video Pressed")
        delegate?.buttonClicked(pressedButton: "video")
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension UploadMomentOptionsViewController {
    
    func configureUI() {
    
          viewOptions.backgroundColor = .white
          viewOptions.layer.cornerRadius = 34
          
          viewOptions.layer.shadowRadius = 5
          viewOptions.layer.shadowOpacity = 0.5
          viewOptions.layer.shadowColor = UIColor.black.cgColor
          viewOptions.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    
    func configureToClose() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewOptions)
        
        if viewOptions.bounds.contains(location) {
           
            print("View Opions par tap hua hai")
            
        } else {
            
            print("View Options par tap nahi hua hai")
          
            dismiss(animated: true, completion: nil)
        }
    }
    
}
