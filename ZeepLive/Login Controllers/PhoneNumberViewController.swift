//
//  PhoneNumberViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 13/04/23.
//

import UIKit

class PhoneNumberViewController: UIViewController, delegateShowCountryListViewController {
   
    
    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var imgViewLogo: UIImageView!
    @IBOutlet weak var viewSelectCountryCodeOutlet: UIControl!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var txtfldPhoneNumber: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtfldEnterPassword: UITextField!
    @IBOutlet weak var btnLoginOutlet: UIButton!
    @IBOutlet weak var btnLoginVerificationCodeOutlet: UIButton!
    @IBOutlet weak var lblCountryCode: UILabel!
    
    lazy var selectedcountryCode: String = "+91"
    lazy var encryptedData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        configureUI()
        
    }
    
    func configureUI() {
        
        viewSelectCountryCodeOutlet.isUserInteractionEnabled = true
        viewPhoneNumber.layer.cornerRadius = 25
        viewPassword.layer.cornerRadius = 25
        
        btnLoginOutlet.layer.cornerRadius = 25
        btnLoginOutlet.backgroundColor = GlobalClass.sharedInstance.buttonEnableColor()
        
     //   txtfldPhoneNumber.setLeftPaddingPoints(15)
      //  txtfldPassword.setLeftPaddingPoints(15)
        txtfldPhoneNumber.delegate = self
        txtfldEnterPassword.delegate = self
        
    }
//MARK: - BUTTONS ACTIONS AND FUNCTIONS
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func viewSelectCountryCodePressed(_ sender: Any) {
        
        print("View select country code pressed")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowCountryListViewController") as! ShowCountryListViewController
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        
        print("Button login pressed")
        if (txtfldPhoneNumber.text == "") || (txtfldPhoneNumber.text == nil) {
            
            showAlert(title: "ALERT !", message: "Please enter phone number", viewController: self)
            
        } else if (txtfldEnterPassword.text == "") || (txtfldEnterPassword.text == nil) {
            
            showAlert(title: "ALERT !", message: "Please enter passowrd ", viewController: self)
            
        }  else if (txtfldPhoneNumber.text != "") && (txtfldEnterPassword.text != "") {
            
            callManualLogin()
            
        }
    }
    
    @IBAction func btnLoginWithVerificationCodePressed(_ sender: Any) {
        
        if (selectedcountryCode == "+91") {
            
            print("India ke liye hai aur Otp khud se hi generate karna hai")
            
            if (txtfldPhoneNumber.text == "") {
                
                showAlert(title: "ALERT !", message: "Please enter valid phone number", viewController: self)
                
            } else {
            
                sendToIndiaUser()
                
            }
        } else {
            
            print("Bhr ke countries ke liye hai aur yhn par otp ke liye api call karenge jismain otp milega jisse ki hum verify karenge otp ke liye. Phir update mobile number vali api call karaenge")
            
            if (txtfldPhoneNumber.text == "") {
                
                showAlert(title: "ALERT !", message: "Please enter valid number", viewController: self)
                
            } else {
             
              
                sendToForeignUser()
                
            }
        }
        
        print("Button login with verification code pressed")

    }
    
    func selectedCountryDetails(countrycode: String,countryname: String, countryimage:String, countryid:Int) {
        
        print(countrycode)
        print(countryname)
        print(countryimage)
        print(countryid)
        
        print("The contry code selected is: \(countrycode)")
        
        selectedcountryCode = countrycode
        print("The selected code is :\(selectedcountryCode)")
        lblCountryCode.text = countrycode
        
    }
    
}

extension PhoneNumberViewController {
    
    func sendToIndiaUser() {
        
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
                // Handle the case when 'uniquedeviceid' is nil
                return
            }
        
        let params = [
         
            "mobile": txtfldPhoneNumber.text!,
            "countrycode": selectedcountryCode,
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
            "unique_device_id": uniqueId

        ] as [String : Any]
        
        print("The parameters we are sending for india user is: \(params)")
        
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
               guard let self = self else { return }
               
               print(data)
               
               if let success = data["success"] as? Bool, success {
                   print(data)
                   
                   if let sessionUUID = data["session_uuid"] as? String {
                       print(sessionUUID)
                       
                       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                       let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
                       nextViewController.sessionId = sessionUUID
                       nextViewController.countryCode = selectedcountryCode
                       nextViewController.phoneNumber = txtfldPhoneNumber.text ?? ""
                       navigationController?.pushViewController(nextViewController, animated: true)
                   }
               } else {
                   showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
               }
           })
       
    }
    
    func sendToForeignUser() {
        
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
                // Handle the case when 'uniquedeviceid' is nil
                return
            }
        
        let params = [
         
            "mobile": txtfldPhoneNumber.text!,
            "countrycode": selectedcountryCode,
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
            "unique_device_id": uniqueId

        ] as [String : Any]
        
          print("The parameters we are sending for foreign user is: \(params)")
        
        do {
            let encryptedString = try EncryptionUtils.encrypt(data: params, key: GlobalClass.sharedInstance.keyName , iv: GlobalClass.sharedInstance.keyIV )
            print("Encrypted String: \(encryptedString)")
            encryptedData = ""
            encryptedData = encryptedString
        } catch {
            print("Encryption failed with error: \(error)")
        }

        
        let parameter = ["encryptedData": encryptedData] as [String : Any]
        print("The parameter sending is: \(parameter)")
        
        
        ApiWrapper.sharedManager().sendOtpToForeignUser(url: AllUrls.getUrl.sendOtpForForeignUser, parameters: parameter, completion: { [weak self] data in
               guard let self = self else { return }
               
               print(data)
               
               if let success = data["success"] as? Bool, success {
                   print(data)
                   
                   if let sessionUUID = data["session_uuid"] as? String {
                       print(sessionUUID)
                       
                       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                       let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
                       nextViewController.sessionId = sessionUUID
                       nextViewController.countryCode = selectedcountryCode
                       nextViewController.phoneNumber = txtfldPhoneNumber.text ?? ""
                       navigationController?.pushViewController(nextViewController, animated: true)
                   }
               } else {
                   showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
               }
           })
    }

// MARK: - FUNCTION FOR MANUAL LOGIN API CALLING
    
    func callManualLogin() {
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
                // Handle the case when 'uniquedeviceid' is nil
                return
            }
        let hashkey = GlobalClass.sharedInstance.bundleId?.data(using: .utf8)?.sha256.lowercased()
        
        let params = [
            "username": txtfldPhoneNumber.text ?? "",
            "password": txtfldEnterPassword.text ?? "",
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
            "device_id": GlobalClass.sharedInstance.MYUUID ?? "",
            "unique_device_id": uniqueId
        ] as [String : Any]
        
        print("The params we are sending in the device manual login is: \(params)")
        
        ApiWrapper.sharedManager().userLogin(url: AllUrls.getUrl.manualLogin, parameters: params, completion: { [weak self] data in
            guard let self = self else { return }
            
            if let success = data["success"] as? Bool, success {
                print(data)
                
                if let a = data as? [String: Any],
                   let b = a["result"] as? [String: Any],
                   let token = b["token"] as? String,
                   let profileId = b["profile_id"] as? Int,
                   let navigationController = self.navigationController {
                    
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(b["name"] as? String ?? "No Name", forKey: "UserName")
                    UserDefaults.standard.set(profileId, forKey: "UserProfileId")
                    
                    var navigationArray = navigationController.viewControllers
                    if let temp = navigationArray.last {
                        navigationArray.removeAll()
                        navigationArray.append(temp)
                        self.navigationController?.viewControllers = navigationArray
                    }
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    navigationController.pushViewController(nextViewController, animated: true)
                }
            } else {
                
                let a = data["error"] as? String
                
                showAlert(title: "ERROR!", message: a ?? "You Cannot Login in the ZeepLive. Please Contact Admin!", viewController: self)
            }
        })
    }

    
}

// MARK: - EXTENSION FOR TEXTFIELD DELEGATES AND FUNCTIONS TO CHECK FOR CHARACTERS AND CONDITIONS


extension PhoneNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtfldPhoneNumber) {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            print("The count is : \(count)")
            
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if (selectedcountryCode == "+91") {
                return count <= 10 && allowedCharacters.isSuperset(of: characterSet)
            } else {
                return count <= 15 && allowedCharacters.isSuperset(of: characterSet)
            }
            
        } else if (textField == txtfldEnterPassword) {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            print("The count in phone number password is : \(count)")
            
            return count <= 30
            
        }
        
        return true
    }
}

///
///
//extension PhoneNumberViewController: UITextFieldDelegate {
//    
////    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        
////        if (textField == txtfldPhoneNumber) {
////            guard let textFieldText = textField.text,
////                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
////                return false
////            }
////            let substringToReplace = textFieldText[rangeOfTextToReplace]
////            let count = textFieldText.count - substringToReplace.count + string.count
////            print("The count is : \(count)")
//////            if count >= 10 {
//////                print("Number 10 ke 10 pde hai")
//////                btnNextOutlet.isUserInteractionEnabled = true
//////                btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonEnableColor()
//////                btnNextOutlet.tintColor = .white
//////             //   btnNextOutlet.applyGradient(colours: [GlobalClass.sharedInstance.buttonEnableColor(), GlobalClass.sharedInstance.buttonEnableSecondColour()])
//////            } else {
//////                print("Abhi 10 digit nahi dale hai textfield main.")
//////                btnNextOutlet.isUserInteractionEnabled = false
//////                btnNextOutlet.backgroundColor = GlobalClass.sharedInstance.buttonDisableColor()
//////                btnNextOutlet.tintColor = .white
//////            }
////            
////            let allowedCharacters = CharacterSet.decimalDigits
////            let characterSet = CharacterSet(charactersIn: string)
////            return count <= 10 && allowedCharacters.isSuperset(of: characterSet)
////            
////        }
////        return true
////    }
//// MARK: - FUNCTION TO HIDE KEYBOARD WHEN USER CLICKED ON THE SCREEN
//    
//   func initializeHideKeyboard(){
//    
//   let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//    target: self,
//    action: #selector(dismissMyKeyboard))
//    view.addGestureRecognizer(tap)
//    
//   }
//    
//   @objc func dismissMyKeyboard(){
//    
//    view.endEditing(true)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//        {
//                textField.resignFirstResponder()
//                return true
//        }
//}

