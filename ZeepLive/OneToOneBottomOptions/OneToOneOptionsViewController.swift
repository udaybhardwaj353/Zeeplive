//
//  OneToOneOptionsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 24/05/24.
//

import UIKit
import ZegoExpressEngine

protocol delegateOneToOneOptionsViewController: AnyObject {

    func cameraOnOffPressed(isPressed:Bool)
    func cameraFlipPressed(isPressed:Bool)
    func openBeautyPressed(isPressed:Bool)
    
}

class OneToOneOptionsViewController: UIViewController {

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnCameraOutlet: UIControl!
    @IBOutlet weak var btnFlipOutlet: UIControl!
    @IBOutlet weak var btnBeautyOutlet: UIControl!
    @IBOutlet weak var imgViewCamera: UIImageView!
    @IBOutlet weak var btncameraWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnFlipCameraLeftConstraints: NSLayoutConstraint!
    
    lazy var isCameraOnOffButtonPressed = true
    lazy var isFlipCameraButtonPressed = false
    lazy var isBeautyFilterButtonPressed = false
    weak var delegate: delegateOneToOneOptionsViewController?
    lazy var cameFrom: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureToClose()
      //  btnBeautyOutlet.isHidden = true
        
    }
    
    @IBAction func btnCameraPressed(_ sender: Any) {
        
        print("Button Switch On/Off Camera Pressed.")
        
        if isCameraOnOffButtonPressed
        
        {
            isCameraOnOffButtonPressed = false
            ZegoExpressEngine.shared().mutePublishStreamVideo(true)
          //  imgViewCamera.image = UIImage(named: "videocameraon")
            
            print("Camera open karne wali condition mai aaya hai.")
            
        }
        
        else{
            
            isCameraOnOffButtonPressed = true
            ZegoExpressEngine.shared().mutePublishStreamVideo(false)
           // imgViewCamera.image = UIImage(named: "videocameraoff")
            
            print("Camera bnd karne wali condition mai aaya hai.")
            
        }
        
        delegate?.cameraOnOffPressed(isPressed: true)
        
    }
    
    @IBAction func btnFlipPressed(_ sender: Any) {
        
        print("Button Switch Camera Pressed.")
        
        if isFlipCameraButtonPressed
        
        {
            isFlipCameraButtonPressed = false
            ZegoExpressEngine.shared().useFrontCamera(true)
            print("Front Camera Use karne wali condition mai aaya hai.")
            
        }
        
        else{
            
            isFlipCameraButtonPressed = true
            ZegoExpressEngine.shared().useFrontCamera(false)
            print("Front Camera Use nahi karne wali condition mai aaya hai.")
            
        }
        
        delegate?.cameraFlipPressed(isPressed: true)
        
    }
    
    @IBAction func btnBeautyPressed(_ sender: Any) {
        
        print("Button Select Beauty Pressed.")
        
                if isBeautyFilterButtonPressed {
        
                    isBeautyFilterButtonPressed = false
                   // FUDemoManager.shared().hideBottomBar()
                    delegate?.openBeautyPressed(isPressed: isBeautyFilterButtonPressed)
                    
                } else{
        
                    isBeautyFilterButtonPressed = true
                  //  FUDemoManager.shared().showBottomBar()
                    delegate?.openBeautyPressed(isPressed: isBeautyFilterButtonPressed)
                    
                }
        
    }
    
    func configureUI() {
    
          viewBottom.backgroundColor = .white
          viewBottom.layer.cornerRadius = 34
          
          viewBottom.layer.shadowRadius = 5
          viewBottom.layer.shadowOpacity = 0.5
          viewBottom.layer.shadowColor = UIColor.black.cgColor
          viewBottom.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        imgViewCamera.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        imgViewCamera.layer.cornerRadius = imgViewCamera.frame.height / 2
        
        if (cameFrom == "onetoone") {
        
            btnBeautyOutlet.isHidden = true
            
        } else {
            
            btnBeautyOutlet.isHidden = false
            
        }
        
        if (cameFrom == "host") {
        
            btnCameraOutlet.isHidden = true
            btncameraWidthConstraints.constant = 0
            btnFlipCameraLeftConstraints.constant = -30
            
        } else {
            
            btnCameraOutlet.isHidden = false
            btncameraWidthConstraints.constant = 80
            btnFlipCameraLeftConstraints.constant = 25
            
        }
        
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
