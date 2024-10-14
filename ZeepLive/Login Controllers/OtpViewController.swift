//
//  OtpViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 14/04/23.
//

import UIKit

class OtpViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var viewVerificationCode: UIView!
    @IBOutlet weak var txtfldVerificationCode: UITextField!
    @IBOutlet weak var viewDashLine: UIView!
    @IBOutlet weak var btnResendOtpOutlet: UIButton!
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtfldPassword: UITextField!
    @IBOutlet weak var btnPasswordShowHideOutlet: UIButton!
    @IBOutlet weak var btnNextOutlet: UIButton!
    
    @IBOutlet weak var btnTermsAndConditionOutlet: UIButton!
    @IBOutlet weak var btnPrivacyPolicyOutlet: UIButton!
    
    
    var showPasswordButtonPressed = false
    var verificationCodeCount = Int()
    var passwordCount = Int()
    
    var countdownTimer: Timer?
    var totalTime = 30
    var phoneNumber: String = "No Phone Number Entered"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        initializeHideKeyboard()
        
        btnNextOutlet.isUserInteractionEnabled = false
        txtfldPassword.isSecureTextEntry = true
        txtfldVerificationCode.delegate = self
        txtfldPassword.delegate = self
        
        designing()
        print(phoneNumber)
        lblPhoneNumber.text = phoneNumber
    }
    
    func startTimer() {
        btnResendOtpOutlet.isUserInteractionEnabled = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        btnResendOtpOutlet.setTitle(NSLocalizedString("Re-get \(timeFormatted(totalTime))", comment: ""), for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer?.invalidate()
        btnResendOtpOutlet.isUserInteractionEnabled = true
        btnResendOtpOutlet.setTitle("Get", for: .normal)
    }
    
//    func timeFormatted(_ totalSeconds: Int) -> String {
//        let seconds: Int = totalSeconds % 60
//        let minutes: Int = (totalSeconds / 60) % 60
//        //     let hours: Int = totalSeconds / 3600
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
    
    // MARK: - FUNCTION FOR BUTTONS AND VIEWS DESIGNING AND LABELS ACTING AS BUTTON CODE WRITTEN HERE
    
    func designing() {
        
        viewVerificationCode.layer.cornerRadius = 20
        viewVerificationCode.backgroundColor = GlobalClass.sharedInstance.textfieldBackgroundColor()
        btnResendOtpOutlet.setTitle("Get", for: .normal)
        
        viewPassword.layer.cornerRadius = 20
        viewPassword.backgroundColor = GlobalClass.sharedInstance.textfieldBackgroundColor()
        btnNextOutlet.layer.cornerRadius = 20
        btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonDisableColor()
        btnNextOutlet.tintColor = .white
        btnResendOtpOutlet.tintColor = GlobalClass.sharedInstance.buttonEnableColor()
        btnResendOtpOutlet.setTitleColor(GlobalClass.sharedInstance.buttonEnableColor(), for: .normal)
        
      //  btnPasswordShowHideOutlet.tintColor = GlobalClass.sharedInstance.buttonEnableColor()
        
        viewVerificationCode.layer.borderWidth = 0.5
        viewPassword.layer.borderWidth = 0.5
        viewVerificationCode.layer.borderColor = GlobalClass.sharedInstance.backButtonColor().cgColor
        viewPassword.layer.borderColor = GlobalClass.sharedInstance.backButtonColor().cgColor
        
        txtfldVerificationCode.setLeftPaddingPoints(15)
        txtfldPassword.setLeftPaddingPoints(15)
        
    }

 // MARK: - BUTTONS ACTIONS AND FUNCTIONS
    
    @IBAction func btnBackPressed(_ sender: Any) {
      
        self.navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func btnResendOtpPressed(_ sender: Any) {
        print("Resend OTP Button Pressed")
        totalTime = 30
        startTimer()
    }
    
    @IBAction func btnShowHidePasswordPressed(_ sender: Any) {
       
        if showPasswordButtonPressed
        {
            showPasswordButtonPressed = false
            btnPasswordShowHideOutlet.setImage(UIImage(named:  "show"), for: .normal)
            txtfldPassword.isSecureTextEntry = true
            txtfldPassword.clearsOnInsertion = false
            txtfldPassword.clearsOnBeginEditing = false
          
        }
        else{
            showPasswordButtonPressed = true
            btnPasswordShowHideOutlet.setImage(UIImage(named:  "hide"), for: .normal)
            txtfldPassword.isSecureTextEntry = false
            txtfldPassword.clearsOnInsertion = false
            txtfldPassword.clearsOnBeginEditing = false
        }

    }

    // MARK: - BUTTONS ACTIONS AND FUNCTIONS AND THEIR FUNCTIONALITIES
    
    @IBAction func btnNextPressed(_ sender: Any) {
        print("Button Next Pressed")
        let alert = UIAlertController(title: "Successfull !", message: NSLocalizedString("You have successfully logged in to the ZeepLive", comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
      
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnTermsAndConditionsPressed(_ sender: Any) {
        print("Button Terms And Conditions Pressed")
        
        openWebView(withURL: "https://sites.google.com/view/zeeplive/terms")
        
    }
    
    @IBAction func btnPrivacyPolicyPressed(_ sender: Any) {
        print("Button Privacy Policy Pressed")
        
        openWebView(withURL: "https://sites.google.com/view/zeeplive/privacy")
        
    }
    
}

// MARK: - EXTENSION FOR USING TEXTFIELD DELEGATES AND METHODS AND USING IT TO CHECK CONDITIONS

extension OtpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtfldVerificationCode) {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
    
            verificationCodeCount = count
          
            if (verificationCodeCount >= 6) {
             
                if (passwordCount >= 8) {
                   
                    btnNextOutlet.isUserInteractionEnabled = true
                    btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonEnableColor()
                    btnNextOutlet.tintColor = .white
                } else {
                    
                    btnNextOutlet.isUserInteractionEnabled = false
                    btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonDisableColor()
                    btnNextOutlet.tintColor = .white
                }
            } else {
               
                btnNextOutlet.isUserInteractionEnabled = false
                btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonDisableColor()
                btnNextOutlet.tintColor = .white
            }
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return count <= 6 && allowedCharacters.isSuperset(of: characterSet)
            
        }
            if (textField == txtfldPassword) {
             
                let nsString:NSString? = textField.text as NSString?
                   let updatedString = nsString?.replacingCharacters(in:range, with:string);

                   textField.text = updatedString;

                passwordCount = textField.text?.count ?? 0
                
                   //Setting the cursor at the right place
                   let selectedRange = NSMakeRange(range.location + string.count, 0)
                   let from = textField.position(from: textField.beginningOfDocument, offset:selectedRange.location)
                   let to = textField.position(from: from!, offset:selectedRange.length)
                   textField.selectedTextRange = textField.textRange(from: from!, to: to!)

                   //Sending an action
                textField.sendActions(for: UIControl.Event.editingChanged)

                if (passwordCount >= 8) {
            
                    if (verificationCodeCount >= 6) {
                       
                        btnNextOutlet.isUserInteractionEnabled = true
                        btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonEnableColor()
                        btnNextOutlet.tintColor = .white
                    } else {
                     
                        btnNextOutlet.isUserInteractionEnabled = false
                        btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonDisableColor()
                        btnNextOutlet.tintColor = .white
                    }
                } else {
                   
                    btnNextOutlet.isUserInteractionEnabled = false
                    btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonDisableColor()
                    btnNextOutlet.tintColor = .white
                }
                   return false;
        }
        return true
    }

 // MARK: - FUNCTION TO HIDE KEYBOARD BY CLICKING ON THE SCREEN
    
   func initializeHideKeyboard(){
    
   let tap: UITapGestureRecognizer = UITapGestureRecognizer(
    target: self,
    action: #selector(dismissMyKeyboard))
    view.addGestureRecognizer(tap)
    
   }
    
   @objc func dismissMyKeyboard(){
    
    view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
                textField.resignFirstResponder()
                return true
        }
}

