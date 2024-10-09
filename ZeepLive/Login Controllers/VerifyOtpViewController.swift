//
//  VerifyOtpViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/12/23.
//

import UIKit

class VerifyOtpViewController: UIViewController {

    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var imgViewLogo: UIImageView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var viewInputOtp: UIView!
    @IBOutlet weak var txtfldEnterOtp: UITextField!
    @IBOutlet weak var btnResendOtpOutlet: UIButton!
    @IBOutlet weak var btnLoginOutlet: UIButton!
    var countdownTimer: Timer?
    lazy var totalTime = 120
    lazy var sessionId: String = ""
    lazy var countryCode: String = ""
    lazy var phoneNumber: String = ""
    lazy var checkRegistrationModel = registrationResult()
    lazy var url = String()
    lazy var encryptedData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        configureUI()
        startResendTimer()
        print("The session uuid is: \(sessionId)")
        print("The country code here is: \(countryCode)")
        print("The phone number of the user is: \(phoneNumber)")
        
    }
   
    func configureUI() {
    
        viewInputOtp.layer.cornerRadius = 25
        btnLoginOutlet.layer.cornerRadius = 25
        btnLoginOutlet.backgroundColor = GlobalClass.sharedInstance.buttonEnableColor()
        
        txtfldEnterOtp.setLeftPaddingPoints(15)
        lblPhoneNumber.text = countryCode  + phoneNumber
        txtfldEnterOtp.delegate = self
        
    }
    
    func startResendTimer() {
        
        totalTime = 120
        startTimer()
        btnResendOtpOutlet.isUserInteractionEnabled = false
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back button pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnResendOtpPressed(_ sender: Any) {
        
        print("Button resend otp pressed")
      //  totalTime = 300
        startResendTimer()
        
        if (countryCode == "+91") {
            
            print("Bharat ke user ke liye otp resend hoga")
            sendToIndiaUser()
            
        }  else {
            
           print("angrejo ke liye otp resend hoga")
            sendToForeignUser()
            
        }
        
    }
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        
        print("Button login button pressed")
        if (txtfldEnterOtp.text == "") || (txtfldEnterOtp.text == nil) {
            
            print("otp verify nahi hoga text field khali hai")
            showAlert(title: "ERROR !", message: "Please enter the Otp!", viewController: self)
            
        } else {
         
            verifyOtpOfUser()
        }
    }
    
}

extension VerifyOtpViewController {
    
    func startTimer() {
        btnResendOtpOutlet.isUserInteractionEnabled = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        btnResendOtpOutlet.setTitle(NSLocalizedString("Resend : \(timeFormatted(totalTime))", comment: ""), for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer?.invalidate()
        btnResendOtpOutlet.isUserInteractionEnabled = true
        btnResendOtpOutlet.setTitle("Resend", for: .normal)
    }
    
}

extension VerifyOtpViewController {
    
    func verifyOtpOfUser() {
            
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        let params = [
            "session_uuid": sessionId,
            "otp": txtfldEnterOtp.text!,
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
                
                checkForUserRegistration(number: phoneNumber)
                
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

}

extension VerifyOtpViewController {
    
    func sendToIndiaUser() {
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        let params = [
            "mobile": phoneNumber, // txtfldPhoneNumber.text!,
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
            "mobile": phoneNumber, // txtfldPhoneNumber.text!,
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
            } else {
                
                showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
            }
        })
    }

    
}

// MARK: - EXTENSION FOR API CALLING AND CHECKING IF USER IS ALREADY REGISTERED OR NOT

extension VerifyOtpViewController {   // Added on 22 December
    
    func checkForUserRegistration(number:String) {
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
                // Handle the case when 'uniquedeviceid' is nil
                return
            }
        
        let hashkey = GlobalClass.sharedInstance.bundleId?.data(using: .utf8)?.sha256.lowercased()
        
        let params = [
            
            "mobile": number,
            "login_type": "mobile_otp",
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
            "device_id": GlobalClass.sharedInstance.MYUUID ?? "",
            "unique_device_id": uniqueId
            
        ] as [String : Any]
        
        print("The params we are sending in the device manual login is: \(params)")
        
        ApiWrapper.sharedManager().checkUserRegistration(url: AllUrls.getUrl.checkUserRegistration, parameters: params, completion: { [weak self] data, value in
            guard let self = self else { return }
            
            
            print(data)
            print(value)
            print(value["success"] as? Bool)
            print(value["already_registered"] as? Bool)
            
            checkRegistrationModel = data ?? checkRegistrationModel
            print("The model data for check registration is : \(checkRegistrationModel)")
            
            if (value["success"] as? Bool == true) {
                
                print(checkRegistrationModel.token)
                
                UserDefaults.standard.set(checkRegistrationModel.token, forKey: "token")
                UserDefaults.standard.set(checkRegistrationModel.name ?? "No Name", forKey: "UserName")
                UserDefaults.standard.set(checkRegistrationModel.profileID, forKey: "UserProfileId")
                UserDefaults.standard.set(checkRegistrationModel.userCity, forKey: "location")
                
                guard let navigationController = self.navigationController else { return }
                var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
                let temp = navigationArray.last
                navigationArray.removeAll()
                navigationArray.append(temp!) //To remove all previous UIViewController except the last one
                self.navigationController?.viewControllers = navigationArray
                
                
                if (value["already_registered"] as? Bool) == true {
                    
                    print("Phir isse home page par bhej do")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    navigationController.pushViewController(nextViewController, animated: true)
                    
                } else {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BasicInformationViewController") as! BasicInformationViewController
                    nextViewController.loginType = "mobile_otp"
                    nextViewController.phoneNumber = phoneNumber
                    navigationController.pushViewController(nextViewController, animated: true)
                    print("Nahi to isko user registraion wale page par bhej do")
                    
                }
                

            } else {
          
                let a = value["error"] as? String
           
                showAlert(title: "ERROR!", message: a ?? "Something went wrong. Please try again!", viewController: self)
                
                }
        })
       
    }
    }


extension VerifyOtpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtfldEnterOtp) {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            print("The count in verify otp textfield is : \(count)")
            
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return count <= 20 && allowedCharacters.isSuperset(of: characterSet)
            
        }
        
        return true
    }
}

