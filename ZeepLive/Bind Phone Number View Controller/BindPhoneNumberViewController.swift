//
//  BindPhoneNumberViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 30/08/23.
//

import UIKit

class BindPhoneNumberViewController: UIViewController, delegateShowCountryListViewController {
   
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    @IBOutlet weak var viewPhoneNumberDetails: UIView!
    @IBOutlet weak var viewCountryCodeOutlet: UIControl!
    @IBOutlet weak var txtfldPhoneNumber: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtfldVerificationCode: UITextField!
    
    @IBOutlet weak var viewDashLine: UIView!
    @IBOutlet weak var btnSendOtpOutlet: UIButton!
    
    @IBOutlet weak var btnUpdateNumberOutlet: UIButton!
    
    var countdownTimer: Timer?
    var totalTime = 60
    lazy var selectedcountryCode: String = "+91"

    // 22 September Working
    var number = String()
    var otp = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        hideKeyboardWhenTappedAround()
        btnSendOtpOutlet.setTitle("Send", for: .normal)
        viewDashLine.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        btnUpdateNumberOutlet.layer.cornerRadius = 20
        txtfldPhoneNumber.delegate = self
        txtfldVerificationCode.delegate = self
        print("The number is: \(number)")
        txtfldPhoneNumber.text = number
        
    }
    
    @IBAction func btnUpdateNumberPressed(_ sender: Any) {
        
        print("Button Bind Mobile Number Pressed")
        print("Yhn pr update user status vala kaam krenge")
        
        if (selectedcountryCode == "+91") {

            print("India ke liye hai aur Otp khud se hi generate karna hai")
           
            if (String(otp) == txtfldVerificationCode.text) {
                print("Number update kara do")
                
                userBindNumber()
                
//                showAlert(title: "SUCCESS !", message: "NUMBER UPDATE KARA DO", viewController: self)
            } else {
            
                print("Number update mat krao bs alert dikha do wrong ka")
                
                showAlert(title: "ERROR !", message: "Please enter correct Verification Code", viewController: self)
                
            }
            
        } else {

            print("Bhr ke countries ke liye hai aur yhn par otp ke liye api call karenge jismain otp milega jisse ki hum verify karenge otp ke liye. Phir update mobile number vali api call karaenge")

        }
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewCountryCodePressed(_ sender: Any) {
        
        print("View Country code ko select kiya hai")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowCountryListViewController") as! ShowCountryListViewController
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func btnSendOtpPressed(_ sender: Any) {
        
        print("Send Otp vali button dabi hai")
        totalTime = 60
        startTimer()
        if (selectedcountryCode == "+91") {
            
            print("India ke liye hai aur Otp khud se hi generate karna hai")
            
            if (txtfldPhoneNumber.text == "") {
                
                showAlert(title: "ALERT !", message: "Please enter valid phone number", viewController: self)
                
            } else {
              //  userForeignsendOtp()
                sendOtp2Factor(phone: txtfldPhoneNumber.text ?? "")
                
            }
        } else {
            
            print("Bhr ke countries ke liye hai aur yhn par otp ke liye api call karenge jismain otp milega jisse ki hum verify karenge otp ke liye. Phir update mobile number vali api call karaenge")
            
            if (txtfldPhoneNumber.text == "") {
                
                showAlert(title: "ALERT !", message: "Please enter valid number", viewController: self)
                
            } else {
             
                userForeignsendOtp()
                
            }
        }
        
    }
    
    func startTimer() {
        
        btnSendOtpOutlet.isUserInteractionEnabled = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        btnSendOtpOutlet.setTitle(NSLocalizedString("Re-send \(timeFormatted(totalTime))", comment: ""), for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer?.invalidate()
        btnSendOtpOutlet.isUserInteractionEnabled = true
        btnSendOtpOutlet.setTitle("Send", for: .normal)
    }
    
}

// MARK: - EXTENSION FOR WORKING OF DIFFERENT FUNCTIONS AND DELEGATE METHOD

extension BindPhoneNumberViewController {
    
//    func timeFormatted(_ totalSeconds: Int) -> String {
//        let seconds: Int = totalSeconds % 60
//        let minutes: Int = (totalSeconds / 60) % 60
//        //     let hours: Int = totalSeconds / 3600
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
    
    private func sendOtp2Factor(phone: String) {
        let randomNumber = Int.random(in: 0..<999999)
        otp = randomNumber
        print("The otp generated is: \(otp)")
       sendOtp()
        
    }
        
    func selectedCountryDetails(countrycode: String,countryname: String, countryimage:String, countryid:Int) {
            print(countrycode)
            print(countryname)
            print(countryimage)
            print(countryid)
        
            selectedcountryCode = countrycode
            print(selectedcountryCode)
            lblCountryCode.text = countrycode
            
        }
    
}

// MARK: - EXTENSION FOR API CALLING

extension BindPhoneNumberViewController {
    // api post method ki hai sms vali
    
    func sendOtp() {
        
        let url = "https://2factor.in/API/V1/2084a5d9-c0a0-11eb-8089-0200cd936042/SMS/\(txtfldPhoneNumber.text!)/\(otp)"
        
        print(url)
        
        ApiWrapper.sharedManager().callOtpMessageSendingApi(url: url , completion: {(data) in
            
            print(data)
            
            if (data["Status"] as? String == "Success") {
                print(data)

            }
              else {
            
                  self.showAlert(title: "ERROR !", message: "Something Went Wrong!", viewController: self)
                  
            }
        })
       
    }
    
    func userBindNumber() {
        
        let params = [
         
            "mobile": txtfldPhoneNumber.text!,
            "country_id": selectedcountryCode

        ] as [String : Any]
        
        print(params)
        
        ApiWrapper.sharedManager().bindUserMobileNumber(url: AllUrls.getUrl.bindMobileNumber, parameters: params , completion: {(data) in
            
            print(data)
            
            if (data["success"] as? Bool == true) {
                print(data)

                self.showAlertwithButtonAction(title: "SUCCESS !", message: "Your mobile number has been binded successfully", viewController: self)
                
            }
              else {
            
                  self.showAlert(title: "ERROR !", message: "Something Went Wrong!", viewController: self)
                  
            }
        })
    }
    
    
    func userForeignsendOtp() {
        
        let params = [
         
            "mobile": txtfldPhoneNumber.text!,
            "countrycode": selectedcountryCode,
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg="

        ] as [String : Any]
        
        print(params)
        
        ApiWrapper.sharedManager().sendOtpToForeignUser(url: AllUrls.getUrl.sendOtpToNewUser, parameters: params , completion: {(data) in
            
            print(data)
            
            if (data["success"] as? Bool == true) {
                print(data)

                let a = data as? [String:Any]
                print(a)
                
                let b = a?["otp"] as? Int
                print(b)
                self.otp = b ?? 0
                print(self.otp)
                
            }
              else {
            
                  self.showAlert(title: "ERROR !", message: "Something Went Wrong!", viewController: self)
                  
            }
        })
    }
    
}

// MARK: - EXTENSION FOR USING TEXT FIELD DELEGATES AND DATASOURCE METHODS FOR THE TEXTFIELD

extension BindPhoneNumberViewController: UITextFieldDelegate {
    
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
            
          //  return count <= 10 && allowedCharacters.isSuperset(of: characterSet)
            
        } else if (textField == txtfldVerificationCode) {
            
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
            // return count <= 6 && allowedCharacters.isSuperset(of: characterSet)
            
        }
        
        return true
    }
}
