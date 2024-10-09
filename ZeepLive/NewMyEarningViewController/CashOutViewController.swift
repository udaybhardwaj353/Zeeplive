//
//  CashOutViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 15/03/24.
//

import UIKit

class CashOutViewController: UIViewController {

    @IBOutlet weak var viewPayoutDetails: UIView!
    @IBOutlet weak var viewSelectCountryOutlet: UIButton!
    @IBOutlet weak var imgViewCountryImage: UIImageView!
    @IBOutlet weak var imgViewDropDownImage: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var btnBindPhoneNumberOutlet: UIButton!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewBankTransfer: UIView!
    @IBOutlet weak var lblBankTransfer: UILabel!
    @IBOutlet weak var lblBindBankAccount: UILabel!
    @IBOutlet weak var btnAddNewAccountOutlet: UIButton!
    @IBOutlet weak var btnWithdrawOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var countryName: String = "India"
    lazy var countryImage: String = ""
    lazy var countryCode: String = "+91"
    lazy var countryID: Int = 0
    lazy var userBankAccounts: [userAccountResult] = []
    lazy var userEPayAccounts: [userAccountEPayResult] = []
    lazy var selectedIndex: Int = 0
    lazy var phoneNumber: String = ""
    lazy var deleteAccountID: Int = 0
    lazy var payoutFees: Int = 0
    lazy var totalAmountWithdraw: String = "0"
    lazy var selectedDeleteIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("The country code: \(countryCode)")
        print("The country name: \(countryName)")
        print("The country id: \(countryID)")
        print("The country image: \(countryImage)")
        
//        getUserAccountsList()
        configureUI()
    //    loadData()
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
    }
    
    @IBAction func viewSelectCountryPressed(_ sender: Any) {
        
        print("View Select Country Pressed.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowCountryListViewController") as! ShowCountryListViewController
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func btnBindPhoneNumberPressed(_ sender: Any) {
        
        print("Button Bind Phone Number Pressed.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BindPhoneNumberForBankAccountViewController") as! BindPhoneNumberForBankAccountViewController
        nextViewController.countryCode = countryCode
        nextViewController.delegate = self
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnAddNewAccountPressed(_ sender: Any) {
        
        print("Button Add new Bank or E-Pay Account Pressed.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddNewBankAccountViewController") as! AddNewBankAccountViewController
        nextViewController.countryCode = countryCode
        nextViewController.countryID = countryID
        nextViewController.countryName = countryName
        nextViewController.countryImage = countryImage
        nextViewController.phoneNumber = phoneNumber
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func btnWithdrawPressed(_ sender: Any) {
        
        var amountInr = Int()
        
        print("Button Withdraw Money Pressed.")
    
        let amountInrString = totalAmountWithdraw
        if let amountInrDouble = Double(amountInrString) {
           
            let amountInrInt = Int(amountInrDouble)
            print("Amount INR as Integer: \(amountInrInt)")
            amountInr = amountInrInt
        } else {
            print("Error: Failed to convert 'amountInr' to a valid number.")
        }

        
        if (countryCode == "+91") {
            if (userBankAccounts.count <= 0) {
                print("Agle summary wale page par nahi bhejna hai.")
                showAlert(title: "ERROR!", message: "Please add a bank account !", viewController: self)
                
            } else if (amountInr < 1000) {
                
            print("Amount 1000 se kam hai. paise ni niklenge.")
                showAlert(title: "ERROR!", message: "You did not have enough money to withdraw.", viewController: self)
                
            } else {
                print("Agle summary wale page par bhej denge.")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentSummaryViewController") as! PaymentSummaryViewController
                nextViewController.totalAmount = totalAmountWithdraw
                nextViewController.transactionFees = payoutFees
                nextViewController.accountNumber = userBankAccounts[selectedIndex].accountNumber ?? "N/A"
                nextViewController.delegate = self
                nextViewController.modalPresentationStyle = .overCurrentContext
                
                present(nextViewController, animated: true, completion: nil)
                
            }
            
        } else {
            
            if (userEPayAccounts.count <= 0) {
                print("Agle summary wale page par nahi bhejna hai.")
                showAlert(title: "ERROR!", message: "Please add a bank account !", viewController: self)
                
            } else {
                print("Agle summary wale page par bhej denge.")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentSummaryViewController") as! PaymentSummaryViewController
                nextViewController.totalAmount = totalAmountWithdraw
                nextViewController.transactionFees = payoutFees
                nextViewController.accountNumber = userEPayAccounts[selectedIndex].email ?? "N/A"
                nextViewController.delegate = self
                nextViewController.modalPresentationStyle = .overCurrentContext
                
                present(nextViewController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    func setupTableView() {
          tblView.delegate = self
          tblView.dataSource = self
          tblView.register(UINib(nibName: "BankAccountListTableViewCell", bundle: nil), forCellReuseIdentifier: "BankAccountListTableViewCell")
          tblView.register(UINib(nibName: "EPayBankTransferTableViewCell", bundle: nil), forCellReuseIdentifier: "EPayBankTransferTableViewCell")
        
      }
    
    func configureUI() {
    
        viewSelectCountryOutlet.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewLine.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        btnAddNewAccountOutlet.setTitleColor(GlobalClass.sharedInstance.setSelectedPagerColour(), for: .normal)
        btnBindPhoneNumberOutlet.setTitleColor(GlobalClass.sharedInstance.setSelectedPagerColour(), for: .normal)
        btnWithdrawOutlet.layer.cornerRadius = btnWithdrawOutlet.frame.height / 2
        btnBindPhoneNumberOutlet.layer.cornerRadius = btnBindPhoneNumberOutlet.frame.height / 2
        btnAddNewAccountOutlet.layer.cornerRadius = btnAddNewAccountOutlet.frame.height / 2
        btnBindPhoneNumberOutlet.layer.borderWidth = 1.5
        btnBindPhoneNumberOutlet.layer.borderColor = GlobalClass.sharedInstance.setSelectedPagerColour().cgColor
        btnAddNewAccountOutlet.layer.borderWidth = 1.5
        btnAddNewAccountOutlet.layer.borderColor = GlobalClass.sharedInstance.setSelectedPagerColour().cgColor
        addGradient(to: btnWithdrawOutlet, width: btnWithdrawOutlet.frame.width, height: btnWithdrawOutlet.frame.height, cornerRadius: btnWithdrawOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
    }
    
    func loadData() {
        
        if (countryCode == "") || (countryCode.isEmpty) {
            
            countryID = 1
            countryCode = "+91"
            countryName = "India"
            lblCountryName.text = countryName
            imgViewCountryImage.image = UIImage(named: "indialogo")
            lblBankTransfer.text = "Bank Transfer"
            lblBindBankAccount.text = "Please Bind Your Bank Account"
          //  getUserAccountsList()
        } else {
            lblCountryName.text = countryName
            if (countryImage == "") || (countryImage == nil) {
                imgViewCountryImage.image = UIImage(named: "indialogo")
            } else {
                loadImage(from: countryImage, into: imgViewCountryImage)
            }
            if (countryCode == "+91") {
                lblBankTransfer.text = "Bank Transfer"
                lblBindBankAccount.text = "Please Bind Your Bank Account"
            } else {
                lblBankTransfer.text = "EPay"
                lblBindBankAccount.text = "Please Bind Your EPay Bank Account"
            }
          //  getUserAccountsList()
        }
        
        let number = UserDefaults.standard.string(forKey: "mobileNumber")
        print("The mobile number we are trying to print is: \(number)")
        
        if (number == nil || number == "") {
            print("Number nahi hai")
            btnBindPhoneNumberOutlet.isHidden = false
            lblPhoneNumber.text = "Please Bind Phone Number"
            phoneNumber = ""
            btnAddNewAccountOutlet.isHidden = true
        } else {
            print("Phone Number hai")
            btnBindPhoneNumberOutlet.isHidden = true
            lblPhoneNumber.text = countryCode + "-"  + " " + (number ?? "0")
            phoneNumber = number ?? ""
            getUserAccountsList()
            btnAddNewAccountOutlet.isHidden = false
        }
        
    }
    
}

extension CashOutViewController: delegateShowCountryListViewController, delegateEPayBankTransferTableViewCell, delegateBankAccountListTableViewCell, delegateBindNumberForBankAccountViewController, delegateCommonPopUpViewController, delegatePaymentSummaryViewController {

    func selectedCountryDetails(countrycode: String,countryname: String, countryimage:String, countryid:Int) {
        print(countrycode)
        print(countryname)
        print(countryimage)
        print(countryid)
        
        countryName = countryname
        countryImage = countryimage
        countryCode = countrycode
        countryID = countryid
        
        loadData()
      //  getUserAccountsList()
        tblView.reloadData()
        
    }
    
    func openEPayBankTransferClicked(isClicked: Bool) {
        print("Open E-Pay Bank Transfer Account Clicked: \(isClicked)")
        
        if let token = UserDefaults.standard.string(forKey: "token") {
            print(token) // This will print the token without "Optional"
            let url = "https://zeep.live/epay-bank-transfer?countrycode=\(countryCode)&token=\(token)"
            print("The url to send for epay bank transfer is: \(url)")
            
            openWebView(withURL: url)
        }
        
    }
    
    func accountSelected(index: Int) {
        print("The bank account selected for withdraw is: \(index)")
        selectedIndex = index
        
        if (countryCode == "+91") {
           print("India ke user ka account select hua hai. \(userBankAccounts[index])")
        } else {
            print("Foreign ke user ka account select hua hai. \(userEPayAccounts[index])")
        }
        tblView.reloadData()
    }
    
    func deleteAccount(index: Int) {
        print("The bank account selected to delete is: \(index)")
        
        selectedDeleteIndex = index
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
        nextViewController.delegate = self
        nextViewController.headingText = "Are you sure to Delete Current Bank Account?"
        nextViewController.buttonName = "Delete"
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
       
    }
    
    func isOtpVerified(isverified: Bool) {
        
        print("The phone number is successfully verified.")
        loadData()
        
    }
    
    func deleteButtonPressed(isPressed: Bool) {
        print("Delete Added Bank/EPay Account Button Pressed from PopUP View Controller.")
        if (countryCode == "+91") {
           print("India ke user ka account delete karne ke liye select hua hai. \(userBankAccounts[selectedDeleteIndex])")
            print("India ke case mai jo account delete karna hai uski id hai: \(userBankAccounts[selectedDeleteIndex].id)")
            deleteAccountID = (userBankAccounts[selectedDeleteIndex].id ?? 0)
        } else {
            print("Foreign ke user ka account delete karne ke liye select hua hai. \(userEPayAccounts[selectedDeleteIndex])")
            print("Foreign ke case mai jo account delete karna hai uski id hai: \(userEPayAccounts[selectedDeleteIndex].id)")
            deleteAccountID = (userEPayAccounts[selectedDeleteIndex].id ?? 0)
        }
        selectedIndex = 0
        deleteAccount()
    }
    
    func okPressed(isPressed: Bool) {
        
        print("OK Button Pressed to withdraw money.")
        callToWithdrawMoney()
        
    }
    
}

extension CashOutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if (section == 0) {
            if (countryCode == "+91") {
                return userBankAccounts.count
            } else {
                return userEPayAccounts.count
            }
        } else {
            if (countryCode == "+91") {
                return 0
            } else {
                if (phoneNumber == "") || (phoneNumber == nil) {
                    return 0
                } else {
                    return 1
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BankAccountListTableViewCell", for: indexPath) as! BankAccountListTableViewCell
            
            if (countryCode == "+91") {
                cell.lblBankName.text = userBankAccounts[indexPath.row].bankName
                let accountNumber = userBankAccounts[indexPath.row].accountNumber ?? "N/A"
                let accountName = userBankAccounts[indexPath.row].accountName ?? "N/A"
                let labelText = "AC: \(accountNumber), \(accountName)"
                cell.lblAccountDetails.text = labelText
            } else {
                
                cell.lblBankName.text = userEPayAccounts[indexPath.row].accountName
                cell.lblAccountDetails.text = "EPay ID:" + (userEPayAccounts[indexPath.row].email ?? "N/A")
                
            }
            
            if (indexPath.row == selectedIndex) {
            
                cell.btnDeleteBankAccountOutlet.isHidden = true
                cell.btnAccountSelectedOutlet.setImage(UIImage(named: "BankAccountSelected"), for: .normal)
                
            } else {
                
                cell.btnAccountSelectedOutlet.setImage(UIImage(named: "BankAccountUnselected"), for: .normal)
                cell.btnDeleteBankAccountOutlet.isHidden = false
                
            }
            
            cell.delegate = self
            cell.btnAccountSelectedOutlet.tag = indexPath.row
            cell.btnDeleteBankAccountOutlet.tag = indexPath.row
            
            cell.selectionStyle = .none
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EPayBankTransferTableViewCell", for: indexPath) as! EPayBankTransferTableViewCell
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        if (indexPath.section == 0) {
            return 80
        } else {
            return 70
        }
    }
    
}

extension CashOutViewController {
    
    func getUserAccountsList() {
           
        var url = AllUrls.getUrl.getUserBankAccounts
        
        if (countryCode == "+91") {
          url = AllUrls.getUrl.getUserBankAccounts + "1"
            
        } else {
           url = AllUrls.getUrl.getUserBankAccounts + "3"
        }
        
        print("The url here is: \(url)")
        
        ApiWrapper.sharedManager().getUserAccountList(url: url,countryCode: countryCode) { [weak self] (data,data1, value) in
            guard let self = self else { return }
            
            print(data)
            print(data1)
            print(value)
            
            if (countryCode == "+91") {
                userBankAccounts = data ?? []
                print(userBankAccounts)
                print(userBankAccounts.count)
                if (userBankAccounts.count >= 3) {
                    btnAddNewAccountOutlet.isHidden = true
                } else {
                    btnAddNewAccountOutlet.isHidden = false
                }
                
            } else {
                
                userEPayAccounts = data1 ?? []
                print(userEPayAccounts)
                print(userEPayAccounts.count)
                if (userEPayAccounts.count >= 3) {
                    btnAddNewAccountOutlet.isHidden = true
                } else {
                    btnAddNewAccountOutlet.isHidden = false
                }
            }
            
            tblView.reloadData()
        }
    }
    
    func deleteAccount() {
        
          let params = [
                
                "account_id":deleteAccountID
                
            ] as [String : Any]
            
        
        print("The parameters we are sending for add account user is: \(params)")
        
        ApiWrapper.sharedManager().removeUserBankAccount(url: AllUrls.getUrl.deleteHostBankAccount, parameters: params, completion: { [weak self] data in
            guard let self = self else { return }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)
                   
                showAlert(title: "SUCCESS!", message: data["message"] as? String ?? "Account Removed Successfully!", viewController: self)
                if (countryCode == "+91") {
                    print("India ke users ek liye delete krna hai.")
                    if let indexToDelete = userBankAccounts.firstIndex(where: { $0.id == self.deleteAccountID }) {
                        userBankAccounts.remove(at: indexToDelete)
                        print("Element at index \(indexToDelete) deleted successfully")
                    } else {
                        print("Account ID \(deleteAccountID) not found in the array")
                    }
                } else {
                    print("Bahar ke users ke liye delete karna hai.")
                    if let indexToDelete = userEPayAccounts.firstIndex(where: { $0.id == self.deleteAccountID }) {
                        userEPayAccounts.remove(at: indexToDelete)
                        print("Element at index \(indexToDelete) deleted successfully")
                    } else {
                        print("Account ID \(deleteAccountID) not found in the array")
                    }
                }
                
            } else {
                
                showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
            }
            
            tblView.reloadData()
        })
        
    }
    
        func callToWithdrawMoney() {
            
            var params = [String: Any]()
            
            let number = UserDefaults.standard.string(forKey: "mobileNumber")
            
            if (countryCode == "+91") {
               
                params = [
                    "type": "1",//"229792703",
                    "account_number": userBankAccounts[selectedIndex].accountNumber ?? "",//"1710137930578",
                    "bank_name": userBankAccounts[selectedIndex].bankName ?? "",
                    "ifsc_code": userBankAccounts[selectedIndex].ifscCode ?? "",//"1.5",
                    "account_name": userBankAccounts[selectedIndex].accountName ?? "",
                    "mobile": number ?? "",
                    "country_id":countryID
                    
                ]
            } else {
                
                params = [
                    "type": "3",//"229792703",
                    "email": userEPayAccounts[selectedIndex].email ?? "",//"1710137930578",
                    "country_id": countryID,
                    "mobile": number ?? "",//"1.5",
                    "account_name": userEPayAccounts[selectedIndex].accountName ?? "",
                    
                ]
                
            }
            
            print("The params we are sending for withdraw money is: \(params)")
            
            ApiWrapper.sharedManager().withdrawRequestForMoney(url: AllUrls.getUrl.withdrawMoney,parameters: params ,completion: { [weak self] ( value) in
                guard let self = self else {
                    // The object has been deallocated
                   
                    return
                }
                
                    print(value)
                
                    let a = value["success"] as? Bool
                    print(a)
                
                if (a == true) {
                    showAlert(title: "SUCCESS!", message: "The payment is being processed it will be transferred to your bank account very soon.", viewController: self)
                } else {
                    showAlert(title: "ERROR!", message: value["error"] as? String ??  "Something went wrong! Please try again", viewController: self)
                }
            })
        }
    
}


//        let url = "https://zeep.live/epay-bank-transfer?countrycode=\(countryCode) &token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjU5NTUzMWE4YmUwYTIzNDY4OTMyYzEyNmMyYjExMzRiYzhlNDRhZDkxYzQ2YmMxM2RmZjQ5OTU0ZWIzMzY0YWZlZmFjYjM4YTYxYzM2M2YiLCJpYXQiOjE3MTA4NDg4MzMsIm5iZiI6MTcxMDg0ODgzMywiZXhwIjoxNzQyMzg0ODMzLCJzdWIiOiIxMzEyMDIwIiwic2NvcGVzIjpbXX0.oBn-nd-nqUkocHbftyknoUoi5c9qCiZa0y3oM0CMeKJV-uyjEBVKfRDWIdo3wFprVDYlMgrBTOX9aiQEzb7_hOVtd4YsFDPdHFHtva7RyKhoI66sOAIKsVWezfDwJvSo1W0aD8CXi2fXDaNczv20IJSXj7N7PHUB-Y3h2lt4Ki8Q-XnJWikENvLyhoBPploYotx0tNFVrKmwFZLuf8Smo41YpRj_nlRgAiU-TpWqjBxL3K4sRpRkTgwPUDWv8CtASTMPu8zgeQRSX-RS3at0vz-aXG6p_PmIiECmAOEpfNLCjldDBu4nCRL-rJtR2LsOYGgVa2_qK0OmeMoCOVmRQS-uXMUz13IVAHmSGJdj3ObFGNQy6oMftezjWXs3CXJCybVpdxYXWybClvPMqFLcAmUmQ7CCCxaLFD4NcP0dZnpaz7T980wvciXcjqkbXLXpwoPSfWedUSHAdJ9J7LnNEarLCO1HP7gCEFd4iFImzdYAKA1jnb3Xa9AZ0XHkopkOTsG4MQ6YSqB1Z70rbMquvpm9PfD1eV7AJyzOUApmJQEfiYB7I1ZXudgF5G_KOonVY2EUJrXi7b8WxGdFVvCS-exdBFTi5h_U7AI0X-nxvPDRYXqYZtr8lwREFq7lWN7SX6Ms7-V1YoJ82DIyj_o0t9Gsll_MmNjy0Ch0-s0qw8k"
//        print("The url to send for epay bank transfer is: \(url)")

//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentSummaryViewController") as! PaymentSummaryViewController
//        nextViewController.totalAmount = totalAmountWithdraw
//        nextViewController.transactionFees = payoutFees
//        if (countryCode == "+91") {
//            nextViewController.accountNumber = userBankAccounts[selectedIndex].accountNumber ?? "N/A"
//        } else {
//            nextViewController.accountNumber = userEPayAccounts[selectedIndex].email ?? "N/A"
//        }
//
//        nextViewController.modalPresentationStyle = .overCurrentContext
//
//        present(nextViewController, animated: true, completion: nil)
