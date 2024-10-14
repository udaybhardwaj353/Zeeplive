//
//  CustomAlertViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 16/06/23.
//

import UIKit

class CustomAlertViewController: UIViewController, UITextViewDelegate {
    
    init() {
        super.init(nibName: "CustomAlertViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnIllegalOrViolenceOutlet: UIButton!
    @IBOutlet weak var btnSexualContentOutlet: UIButton!
    @IBOutlet weak var btnEndagerPersonalSafetyOutlet: UIButton!
    @IBOutlet weak var btnIllegalAvatarOutlet: UIButton!
    @IBOutlet weak var btnIllegalPosterOutlet: UIButton!
    @IBOutlet weak var btnBlockthisuserOutlet: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureClick))
         view.addGestureRecognizer(tapGesture)
        textView.delegate = self
        textView.returnKeyType = .done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.addPlaceholder("Other")
        
    }

    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            textView.text = "" // Reset the text view's text to an empty string
        
        }
    
 // MARK: - TAP GESTURE FUNCTION TO CLOSE THE ALERT VIEW IF USER HAS CLICKED ON THE BACK SCREEN OF THE VIEW
    
//    @objc func tapGestureClick(_ gestureRecognizer: UITapGestureRecognizer) {
//        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
//            self.viewContent.alpha = 0
//        }, completion: { _ in
//            self.dismiss(animated: false)
//            self.removeFromParent()
//        })
//       // hide()
//    }
  
    @objc func tapGestureClick(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapLocation = gestureRecognizer.location(in: viewContent)
        if viewContent.bounds.contains(tapLocation) {
            // Tap is within the viewContent, don't dismiss
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
            self.viewContent.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        })
    }

    
 // MARK: - FUNCTION TO CONFIGURE THE CURRENT VIEW
    
    func configView() {
        
        view.backgroundColor = .black.withAlphaComponent(0.6)
        viewContent.alpha = 0
        viewContent.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
  
 // MARK: - FUNCTION TO PRESENT THE ALERT VIEW CONTROLLER TO THE USER
    
    func appear(sender:UIViewController, userId:Int) {
    
        print("The user id is \(userId)")
        sender.present(self, animated: false)
        show()
    }
 
  // MARK: - FUNCTION TO OPEN THE ALERT VIEW CONTROLLER FOR THE USER TO SELECT OPTION
    
    private func show() {
        
        UIView.animate(withDuration: 1, delay: 0.8) {
            
            self.viewContent.alpha = 1
        }
    }
// MARK: - FUNCTION TO CLOSE THE ALERT VIEW CONTROLLER
   
    func hide() {
        let alertController = UIAlertController(title: "SUCCESS!", message: "Your issue has been reported successfully.", preferredStyle: .alert)
        
        // Add action for confirming to hide the view
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.viewContent.alpha = 0
            }, completion: { _ in
                self.dismiss(animated: false)
                self.removeFromParent()
            })
        }
        alertController.addAction(okAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    
//    func hide() {
//        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut) { [unowned self] in
//           
//            viewContent.alpha = 0
//        } completion: { [unowned self] _ in
//            dismiss(animated: false)
//            removeFromParent()
//        }
//    }

    
 // MARK: - BUTTONS ACTIONS AND THEIR WORKINGS FOR DIFFEENT OPTIONS SELECTED BY THE USER
    
    @IBAction func btnIllegalOrViolencePressed(_ sender: Any) {
        
        print("Button Illegal Or Violence Pressed")
        hide()
        
    }
    
    @IBAction func btnSexualContentPressed(_ sender: Any) {
        
        print("Button Sexual Content Pressed")
        hide()
        
    }
    
    @IBAction func btnEndagerPersonalSafetyPressed(_ sender: Any) {
        
        print("Button Endager Personal Safety Pressed")
        hide()
        
    }
    
    @IBAction func btnIllegalAvatarPressed(_ sender: Any) {
        
       print("Button Illegal Avatar Pressed")
        hide()
        
    }
    
    @IBAction func btnIllegalPosterPressed(_ sender: Any) {
        
        print("Button Illegal Poster Pressed")
        hide()
        
    }
    
    @IBAction func btnBlockthisuserPressed(_ sender: Any) {
        
        print("Button Block this User Pressed")
        hide()
        
    }
 
 // MARK: - DEINITIALIZER METHOD TO REMOVE METHODS OR PROPERTIES FROM MEMORY
    deinit {
        
        viewContent = nil
        btnIllegalOrViolenceOutlet = nil
        btnSexualContentOutlet = nil
        btnEndagerPersonalSafetyOutlet = nil
        btnIllegalAvatarOutlet = nil
        btnIllegalPosterOutlet = nil
        btnBlockthisuserOutlet = nil
        textView = nil
        
    }
    
}

//  MARK: - EXTENSION FOR USING THE TEXTVIEW DELEGATE METHOD TO KNOW WHEN THE DONE BUTTON IS CLICKED IN THE KEYBOARD AND FURTHER DO WORK ON THE BASIS OF DONE BUTTON

extension CustomAlertViewController {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder() // Hide the keyboard
            return false
        }
        return true
    }
    
}
