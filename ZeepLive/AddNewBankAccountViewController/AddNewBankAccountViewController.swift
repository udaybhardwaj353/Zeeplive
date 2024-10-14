//
//  AddNewBankAccountViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 18/03/24.
//

import UIKit

class AddNewBankAccountViewController: UIViewController {
  
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var countryName: String = "India"
    lazy var countryImage: String = ""
    lazy var countryCode: String = "+91"
    lazy var countryID: Int = 0
    lazy var phoneNumber: String = ""
    lazy var encryptedData: String = ""
    lazy var userName: String = ""
    lazy var userBankName: String = ""
    lazy var bankIFSCCode: String = ""
    lazy var bankAccountNumber: String = ""
    lazy var emailID: String = ""
    lazy var otp: String = ""
    lazy var sessionUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("The phoneNumber in addnewbank account is: \(phoneNumber)")
        print("The country code in addnewbank account is: \(countryCode)")
        
        setupTableView()
        hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed.")
        navigationController?.popViewController(animated: true)
        
    }
    
    func setupTableView() {
          tblView.delegate = self
          tblView.dataSource = self
          tblView.register(UINib(nibName: "AddNewBankAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewBankAccountTableViewCell")
          tblView.register(UINib(nibName: "AddNewEPayAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewEPayAccountTableViewCell")
        
      }
    
}

extension AddNewBankAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if (countryCode == "+91") {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewBankAccountTableViewCell", for: indexPath) as! AddNewBankAccountTableViewCell
            
            cell.txtFldPhoneNumber.text = countryCode + "-" + " " + phoneNumber
           
            cell.txtFldPhoneNumber.isUserInteractionEnabled = false
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        } else {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewEPayAccountTableViewCell", for: indexPath) as! AddNewEPayAccountTableViewCell
            
            cell.txtFldCountryName.text = countryName
            cell.txtFldPhoneNumber.text = countryCode + "-" + " " + phoneNumber
            
            cell.txtFldPhoneNumber.isUserInteractionEnabled = false
            cell.delegate = self
            cell.selectionStyle = .none
            return cell 
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        if (countryCode == "+91") {
            
            return 600
        } else {
            return 700
        }
    }
    
}

extension AddNewBankAccountViewController: delegateAddNewEPayAccountTableViewCell, delegateAddNewBankAccountTableViewCell, delegateBankListViewController, delegateVerifyPhoneNumberViewController  {
    
    func createEPayAccountButtonClicked(isClicked: Bool) {
        print("Create E-Pay Account Button Clicked: \(isClicked)")
        openWebView(withURL: "https://www.epay.com/epayweb/register?ref=00649567")
        
    }
    
    func showBankList(isClicked: Bool) {
        
        print("Show Bank List View Clicked to show bank list to show.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BankListViewController") as! BankListViewController
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func bankSelected(id: Int, name: String) {
        print("The selected bank id is: \(id)")
        print("The selected bank name is: \(name)")
        
        guard let cell = self.tblView.visibleCells[0] as? AddNewBankAccountTableViewCell else {
            
            return
        }
        cell.txtFldSelectBankName.text = name
        
    }
    
    func saveEpayAccount(name: String, emailid: String) {
        print(name)
        print(emailid)
        if (name == "") {
            print("Epay account main user ne naam nahi dala hai.")
            showAlert(title: "ERROR!", message: "Please enter name!", viewController: self)
        } else if (emailid == "") {
            print("Epay account main user ne email id nahi dali hai.")
            showAlert(title: "ERROR!", message: "Please enter proper email id!", viewController: self)
        } else {
            userName = name
            emailID = emailid
            
            
        }
    }
    
    func saveBankAccountDetails(name: String, bankName: String, ifscCode: String, bankaccountnumber: String) {
        print(name)
        print(bankName)
        print(ifscCode)
        print(bankaccountnumber)
        if (name == "") {
            print("Naam hi nahi dala hai user ne bank account main")
            showAlert(title: "ERROR!", message: "Please enter beneficiary name!", viewController: self)
        } else if (bankName == "") {
            print("User ne bank naem hi nahi select kiya hai.")
            showAlert(title: "ERROR!", message: "Please select a bank name!", viewController: self)
        } else if (ifscCode == "") || (ifscCode.count < 6){
            print("User ne ifsc code nahi dala hai.")
            showAlert(title: "ERROR!", message: "Please enter proper ifsc code!", viewController: self)
        } else if (bankaccountnumber == "") || (bankaccountnumber.count < 6) {
            print("User ne account number shi nahi dala hai.")
            showAlert(title: "ERROR!", message: "Please enter proper bank account number!", viewController: self)
        } else {
            print("Sab kuch shi hai. Ab otp bhejne wala kaam krana hai.")
            
            userName = name
            userBankName = bankName
            bankIFSCCode = ifscCode
            bankAccountNumber = bankaccountnumber
            
            if (countryCode == "+91") {
                print("India ke number ke liye otp bhejna hai.")
                sendToIndiaUser()
            } else {
                print("Foreign number ke liye otp bhejna hai.")
                sendToForeignUser()
            }
            
        }
    }
    
    func submitOtpPressed(isPressed: Bool,otpText:String) {
        
        print("Button Submit OTP Pressed.: \(isPressed)")
        print("The entered otp text is: \(otpText)")
        otp = otpText
        print("The otp entered by user in verify is: \(otp)")
        print("The country code is: \(countryCode)")
        print("The email id is: \(emailID)")
        print("The phone Number is: \(phoneNumber)")
        addAccount()
        
    }
    
}

extension AddNewBankAccountViewController {
    
    func sendToIndiaUser() {
        
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        let params = [
            
            "mobile": phoneNumber,
            "countrycode": countryCode,
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
                    sessionUID = sessionUUID
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyPhoneNumberViewController") as! VerifyPhoneNumberViewController
                    nextViewController.mobileNumber = phoneNumber
                    nextViewController.countryCode = countryCode
                    nextViewController.delegate = self
                    nextViewController.modalPresentationStyle = .overCurrentContext
                    
                    present(nextViewController, animated: true, completion: nil)
                    
                }
            } else {
                showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
                if (countryCode == "+91") {
                    print("India wale ke lie button enable kaenge.")
                    guard let cell = self.tblView.visibleCells[0] as? AddNewBankAccountTableViewCell else {
                        
                        return
                    }
                    cell.btnSaveBankDetailsOutlet.isUserInteractionEnabled = true
                    
                } else {
                    print("Videshion ke liye button enable krenge.")
                    guard let cell = self.tblView.visibleCells[0] as? AddNewEPayAccountTableViewCell else {
                        
                        return
                    }
                    cell.btnSaveEpayAccountOutlet.isUserInteractionEnabled = true
                    
                }
            }
        })
        
    }
    
    func sendToForeignUser() {
        
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        let params = [
            
            "mobile": phoneNumber,
            "countrycode": countryCode,
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
                    
                    sessionUID = sessionUUID
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VerifyPhoneNumberViewController") as! VerifyPhoneNumberViewController
                    nextViewController.mobileNumber = phoneNumber
                    nextViewController.countryCode = countryCode
                    nextViewController.delegate = self
                    nextViewController.modalPresentationStyle = .overCurrentContext
                    
                    present(nextViewController, animated: true, completion: nil)
                    
                }
            } else {
                showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
                if (countryCode == "+91") {
                    print("India wale ke lie button enable kaenge.")
                    guard let cell = self.tblView.visibleCells[0] as? AddNewBankAccountTableViewCell else {
                        
                        return
                    }
                    cell.btnSaveBankDetailsOutlet.isUserInteractionEnabled = true
                    
                } else {
                    print("Videshion ke liye button enable krenge.")
                    guard let cell = self.tblView.visibleCells[0] as? AddNewEPayAccountTableViewCell else {
                        
                        return
                    }
                    cell.btnSaveEpayAccountOutlet.isUserInteractionEnabled = true
                    
                }
            }
        })
    }
    
    func addAccount() {
        
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        var params = [String : Any]()
        
        if (countryCode == "+91") {
            print("India wale user ke liye bank account add karna hai")
            params = [
                
                "countrycode": countryCode,
                "session_uuid": sessionUID,
                "otp": otp,
                "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
                "account_number":bankAccountNumber,
                "bank_name":userBankName,
                "ifsc_code":bankIFSCCode,
                "account_name":userName,
                "mobile":phoneNumber,
                "type": "1"
                
            ]
        } else {
            print("Foreign users ke liye epay karna hai.")
            params = [
                
                "countrycode": countryCode,
                "session_uuid": sessionUID,
                "otp": otp,
                "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
                "email":emailID,
                "mobile":phoneNumber,
                "type":"3"
                
            ]
            
        }
        
        print("The parameters we are sending for add account user is: \(params)")
        
        ApiWrapper.sharedManager().addUserBankAccount(url: AllUrls.getUrl.addHostBankAccount, parameters: params, completion: { [weak self] data in
            guard let self = self else { return }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)
                    //showAlert(title: "SUCCESS!", message: data["message"] as? String ?? "Account Added Successfully!", viewController: self)
                    showAlertwithButtonAction(title: "SUCCESS!", message: data["message"] as? String ?? "Account Added Successfully!", viewController: self)
                
                
            } else {
                if (countryCode == "+91") {
                    print("India wale ke lie button enable kaenge.")
                    guard let cell = self.tblView.visibleCells[0] as? AddNewBankAccountTableViewCell else {
                        
                        return
                    }
                    cell.btnSaveBankDetailsOutlet.isUserInteractionEnabled = true
                    
                } else {
                    print("Videshion ke liye button enable krenge.")
                    guard let cell = self.tblView.visibleCells[0] as? AddNewEPayAccountTableViewCell else {
                        
                        return
                    }
                    cell.btnSaveEpayAccountOutlet.isUserInteractionEnabled = true
                    
                }
                
                showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
                if (countryCode == "+91") {
                    print("India wale ke lie button enable kaenge.")
                    guard let cell = self.tblView.visibleCells[0] as? AddNewBankAccountTableViewCell else {
                        
                        return
                    }
                    cell.btnSaveBankDetailsOutlet.isUserInteractionEnabled = true
                    
                } else {
                    print("Videshion ke liye button enable krenge.")
                    guard let cell = self.tblView.visibleCells[0] as? AddNewEPayAccountTableViewCell else {
                        
                        return
                    }
                    cell.btnSaveEpayAccountOutlet.isUserInteractionEnabled = true
                    
                }
                
            }
        })
        
    }
    
}
