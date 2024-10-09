//
//  BindPhoneNumberForBankAccountViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 15/03/24.
//

import UIKit

protocol delegateBindNumberForBankAccountViewController:AnyObject {

    func isOtpVerified(isverified:Bool)
    
}

class BindPhoneNumberForBankAccountViewController: UIViewController {
  
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewCountryCodeOutlet: UIControl!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var txtFldOtp: UITextField!
    @IBOutlet weak var btnSendOtpOutlet: UIButton!
    @IBOutlet weak var btnSubmitOtpOutlet: UIButton!
    @IBOutlet weak var viewBottomConstraints: NSLayoutConstraint!
    
    var tapGesture = UITapGestureRecognizer()
    lazy var countryCode: String = "+91"
    var countdownTimer: Timer?
    lazy var totalTime = 120
    lazy var sessionId: String = ""
    lazy var encryptedData: String = ""
    lazy var url = String()
    lazy var mobileNumber: String = ""
    weak var delegate: delegateBindNumberForBankAccountViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        loadData()
        configureTapGesture()
        txtFldPhoneNumber.delegate = self
        txtFldOtp.delegate = self
        //configureToClose()
       // hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func viewCountryCodePressed(_ sender: Any) {
        
        print("View Country Code Pressed")
        
    }
    
    @IBAction func btnSendOtpPressed(_ sender: Any) {
        
        print("Button Send Otp Pressed.")
        print(txtFldPhoneNumber.text)
        print(txtFldPhoneNumber.text?.count)
        if let phoneNumber = txtFldPhoneNumber.text, !phoneNumber.isEmpty, phoneNumber.count >= 10 {
            print("text has valid length")
            mobileNumber = txtFldPhoneNumber.text!
            totalTime = 120
            startTimer()
            if (countryCode == "+91") {
                print("India walon ke liye otp bhejna hai.")
                sendToIndiaUser()
                txtFldOtp.isUserInteractionEnabled = true
                btnSubmitOtpOutlet.isUserInteractionEnabled = true
            } else {
                print("Angrejon ke liye otp bhejna hai")
                sendToForeignUser()
                txtFldOtp.isUserInteractionEnabled = true
            }
        } else {
            print("text is empty or has invalid length")
            showAlert(title: "ERROR!", message: "Please enter proper phone number.", viewController: self)
            txtFldOtp.isUserInteractionEnabled = false
            btnSubmitOtpOutlet.isUserInteractionEnabled = true
        }

//        totalTime = 120
//        startTimer()
        
    }
    
    @IBAction func btnSubmitOtpPressed(_ sender: Any) {
        
        print("Button Submit Otp Pressed.")
        
        if (txtFldPhoneNumber.text == "") || ((txtFldPhoneNumber.text?.count ?? 0) < 10) {
            print("Otp sahi se nahi daala hai.")
            showAlert(title: "ERROR!", message: "Please enter proper phone number!", viewController: self)
            
        } else {
            
            if (txtFldOtp.text == "") || ((txtFldOtp.text?.count ?? 0) < 4) {
                print("Otp sahi se nahi daala hai.")
                showAlert(title: "ERROR!", message: "Please enter proper otp!", viewController: self)
            } else {
                print("Otp shi se dala hai.")
                verifyOtpOfUser()
                btnSubmitOtpOutlet.isUserInteractionEnabled = false
            }
        }
    }
    
    func loadData() {
    
        lblCountryCode.text = countryCode
        
    }
    
    func configureUI() {
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        txtFldOtp.isUserInteractionEnabled = false
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

        
        viewPhoneNumber.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewOtp.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        btnSubmitOtpOutlet.layer.cornerRadius = btnSubmitOtpOutlet.frame.height / 2
        addGradient(to: btnSubmitOtpOutlet, width: btnSubmitOtpOutlet.frame.width, height: btnSubmitOtpOutlet.frame.height, cornerRadius: btnSubmitOtpOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
    }
    
    func configureTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

}

extension BindPhoneNumberForBankAccountViewController {
    
    func sendToIndiaUser() {
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        let params = [
            "mobile": txtFldPhoneNumber.text, // txtfldPhoneNumber.text!,
            "countrycode": countryCode,
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
            "unique_device_id": uniqueId
        ] as [String: Any]
        
        print(params)
        
        do {
            let encryptedString = try EncryptionUtils.encrypt(data: params, key: GlobalClass.sharedInstance.keyName, iv: GlobalClass.sharedInstance.keyIV)
            print("Encrypted String: \(encryptedString)")
            encryptedData = ""
            encryptedData = encryptedString
        } catch {
            print("Encryption failed with error: \(error)")
        }

        
        let parameter = ["encryptedData": encryptedData] as [String : Any]
        print("The parameter sending is: \(parameter)")
        
        ApiWrapper.sharedManager().sendOtpToIndianUser(url: AllUrls.getUrl.sendOtpForIndiaUser, parameters: parameter, completion: { [weak self] data in
                
            guard let self = self else {
                // Handle the case where 'self' is deallocated
                return
            }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)

                if let a = data as? [String: Any] {
                    print(a)
                }
                
                let sid = data["session_uuid"] as? String
                print(sid)
                
                sessionId = sid ?? ""
                
                print("On resending api for the otp the session Id is: \(self.sessionId)")
                txtFldOtp.isUserInteractionEnabled = true
            } else {
                
                showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
                txtFldOtp.isUserInteractionEnabled = false
            }
        })
    }

    
    func sendToForeignUser() {
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        let params = [
            "mobile": txtFldPhoneNumber.text, // txtfldPhoneNumber.text!,
            "countrycode": countryCode, // selectedcountryCode,
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
            "unique_device_id": uniqueId
        ] as [String: Any]
        
        print(params)
        
        do {
            let encryptedString = try EncryptionUtils.encrypt(data: params, key: GlobalClass.sharedInstance.keyName, iv: GlobalClass.sharedInstance.keyIV)
            print("Encrypted String: \(encryptedString)")
            encryptedData = ""
            encryptedData = encryptedString
        } catch {
            print("Encryption failed with error: \(error)")
        }

        
        let parameter = ["encryptedData": encryptedData] as [String : Any]
        print("The parameter sending is: \(parameter)")
        
        ApiWrapper.sharedManager().sendOtpToForeignUser(url: AllUrls.getUrl.sendOtpForForeignUser, parameters: parameter, completion: { [weak self] data in
            
            guard let self = self else {
                // Handle the case where 'self' is deallocated
                return
            }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)

                if let a = data as? [String: Any] {
                    print(a)
                }
                
                let sid = data["session_uuid"] as? String
                print(sid)
                
                sessionId = sid ?? ""
                print("on resending otp for the foreign user the session id here is \(sessionId)")
                txtFldOtp.isUserInteractionEnabled = true
            } else {
                
                showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
                txtFldOtp.isUserInteractionEnabled = false
            }
        })
    }
    
}

extension BindPhoneNumberForBankAccountViewController {
    
    func verifyOtpOfUser() {
            
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        let params = [
            "session_uuid": sessionId,
            "otp": txtFldOtp.text!,
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
        ] as [String : Any]
        
        print(params)
        
        if (countryCode == "+91") {
            
            print("Bharat ke user ke liye otp resend hoga")
            url = AllUrls.getUrl.verifyOtpForIndiaUser
            
        }  else {
            
           print("angrejo ke liye otp resend hoga")
           url = AllUrls.getUrl.verifyOtpForForeignUser
            
        }
        
        ApiWrapper.sharedManager().verifyOtpForUser(url: url , parameters: params , completion: { [weak self] data in
                
            guard let self = self else {
                // Handle the case where 'self' is deallocated
                return
            }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)
                print("The otp is successfully verified")
                UserDefaults.standard.set(mobileNumber, forKey: "mobileNumber")
                let number = UserDefaults.standard.string(forKey: "mobileNumber")
                print("The mobile number we are trying to print is: \(number)")
//                checkForUserRegistration(number: phoneNumber)
                userBindNumber()
                if let a = data as? [String: Any] {
                    print(a)
                }
            } else {
                if let error = data["error"] as? String {
                    showAlert(title: "ERROR !", message: error, viewController: self)
                } else {
                    showAlert(title: "ERROR !", message: "Something Went Wrong!", viewController: self)
                }
            }
        })
    }

    func userBindNumber() {
        
        let params = [
         
            "mobile": mobileNumber,
            "country_id": countryCode

        ] as [String : Any]
        
        print(params)
        
        ApiWrapper.sharedManager().bindUserMobileNumber(url: AllUrls.getUrl.bindMobileNumber, parameters: params , completion: {(data) in
            
            print(data)
            
            if (data["success"] as? Bool == true) {
                print(data)

                self.showAlertwithButtonAction(title: "SUCCESS !", message: "Your mobile number has been binded successfully", viewController: self)
                self.delegate?.isOtpVerified(isverified: true)
                self.dismiss(animated: true, completion: nil)
                
            }
              else {
            
                  self.showAlert(title: "ERROR !", message: "Something Went Wrong!", viewController: self)
                  
            }
        })
    }
    
}

extension BindPhoneNumberForBankAccountViewController {
    
    func startTimer() {
        btnSendOtpOutlet.isUserInteractionEnabled = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        btnSendOtpOutlet.setTitle(NSLocalizedString("Resend : \(timeFormatted(totalTime))", comment: ""), for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer?.invalidate()
        btnSendOtpOutlet.isUserInteractionEnabled = true
        btnSendOtpOutlet.setTitle("Resend", for: .normal)
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

extension BindPhoneNumberForBankAccountViewController: UITextFieldDelegate {
    
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
            
        } else if (textField == txtFldPhoneNumber) {
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
