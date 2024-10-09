//
//  VerifyPhoneNumberViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 18/03/24.
//

import UIKit

protocol delegateVerifyPhoneNumberViewController: AnyObject {

    func submitOtpPressed(isPressed:Bool,otpText:String)
    
}

class VerifyPhoneNumberViewController: UIViewController {

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var viewInputOtp: UIView!
    @IBOutlet weak var btnGetOtpOutlet: UIButton!
    @IBOutlet weak var txtFldOtp: UITextField!
    @IBOutlet weak var btnSubmitOtpOutlet: UIButton!
    @IBOutlet weak var viewBottomConstraints: NSLayoutConstraint!
    
    var tapGesture = UITapGestureRecognizer()
    lazy var mobileNumber: String = ""
    lazy var countryCode: String = "+91"
    var countdownTimer: Timer?
    lazy var totalTime = 120
    lazy var sessionId: String = ""
    lazy var encryptedData: String = ""
    lazy var url = String()
    weak var delegate: delegateVerifyPhoneNumberViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTapGesture()
        loadData()
        txtFldOtp.delegate = self
        
    }
    
    @IBAction func btnGetOtpPressed(_ sender: Any) {
        
        print("Button Get Otp Pressed.In Verify Otp View Controller.")
        totalTime = 120
        startTimer()
        
    }
    
    @IBAction func btnSubmitOtpPressed(_ sender: Any) {
        
        print("Button Submit Otp To Verify Pressed. In Verify View Controller.")
        let text = txtFldOtp.text
        if (text == "") || ((text?.count ?? 0) < 6) {
            print("User ne otp sahi nahi dala hai.")
            showAlert(title: "ERROR!", message: "Please enter proper otp!", viewController: self)
        } else {
            print("User ne otp sahi dala hai. bank account add karne wala kaam krna hai.")
            delegate?.submitOtpPressed(isPressed: true, otpText: (txtFldOtp.text ?? ""))
            dismiss(animated: true, completion: nil)
        }
    }
    
    func loadData() {
    
        lblPhoneNumber.text = countryCode + "-" + " " + mobileNumber
        
    }
    
}

extension VerifyPhoneNumberViewController {
    
    func configureUI() {
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewBottom.backgroundColor = .white
        viewBottom.layer.cornerRadius = 34
        viewBottom.layer.shadowRadius = 1
        viewBottom.layer.shadowOpacity = 0.5
        viewBottom.layer.shadowColor = UIColor.black.cgColor
        viewBottom.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewBottom.layer.borderWidth = 0.5
        viewBottom.layer.borderColor = UIColor.lightGray.cgColor
        viewBottom.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewBottom.layer.masksToBounds = true // Ensure that the masked corners are displayed correctly

        
        viewInputOtp.backgroundColor = GlobalClass.sharedInstance.setGapColour()
      //  btnSubmitOtpOutlet.layer.cornerRadius = btnSubmitOtpOutlet.frame.height / 2
        addGradient(to: btnSubmitOtpOutlet, width: btnSubmitOtpOutlet.frame.width, height: btnSubmitOtpOutlet.frame.height, cornerRadius: btnSubmitOtpOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
    }
    
    func configureTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
}

extension VerifyPhoneNumberViewController {
    
    func startTimer() {
        btnGetOtpOutlet.isUserInteractionEnabled = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        btnGetOtpOutlet.setTitle(NSLocalizedString("Resend : \(timeFormatted(totalTime))", comment: ""), for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer?.invalidate()
        btnGetOtpOutlet.isUserInteractionEnabled = true
        btnGetOtpOutlet.setTitle("Resend", for: .normal)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewBottom)
       
        if self.view.bounds.contains(location) {
            print("View bottom par tap hua hai")
            
        } else {
            
            print("View bottom par tap nahi hua hai")
            dismiss(animated: true, completion: nil)
        }
    }
    
    func removeTapGesture() {
        if tapGesture != nil {
            view.removeGestureRecognizer(tapGesture)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardHeight = keyboardFrame.cgRectValue.height
               
               let viewBottomY = viewBottom.frame.origin.y + viewBottom.frame.size.height
               let keyboardTopY = self.view.frame.size.height - keyboardHeight
               
               if viewBottomY > keyboardTopY {
                   UIView.animate(withDuration: 0.3) {
                       self.viewBottomConstraints.constant = (viewBottomY - keyboardTopY)
                       self.viewBottom.frame.origin.y -= (viewBottomY - keyboardTopY)
                       self.removeTapGesture()
                       self.hideKeyboardWhenTappedAround()
                   }
               }
           }
       }
    
       @objc func keyboardWillHide(_ notification: Notification) {
           // Reset your view's constraints or frame to the initial position here
           // For example, if using constraints:
           UIView.animate(withDuration: 0.3) {
               self.viewBottomConstraints.constant = 0 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
               self.viewBottom.frame.origin.y = self.view.frame.size.height - self.viewBottom.frame.size.height - 30
               self.configureTapGesture()
           }
       }
    
}

extension VerifyPhoneNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtFldOtp) {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            print("The count is : \(count)")
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return count <= 10 && allowedCharacters.isSuperset(of: characterSet)
            
        } 
        
        return true
    }
}
