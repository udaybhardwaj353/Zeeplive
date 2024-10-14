//
//  WalletDetailsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 09/05/23.
//

import UIKit

class WalletDetailsViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    lazy var userPayoutHistory = [userPayoutDetailsResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "WalletDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletDetailsTableViewCell")
       
        getUserEarningHistory()
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND FUNCTIONS TO SHOW DATA IN THE TABLE VIEW CELL

extension WalletDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPayoutHistory.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "WalletDetailsTableViewCell", for: indexPath) as! WalletDetailsTableViewCell
        
        cell.lblAmount.text = "INR" + " " + String(userPayoutHistory[indexPath.row].amountInr ?? 0)
        cell.lblWithdrawDate.text = userPayoutHistory[indexPath.row].withdrawDate
        cell.lblPaymentDate.text = userPayoutHistory[indexPath.row].paymentDate
        cell.lblUtrNumber.text = userPayoutHistory[indexPath.row].utrNo
        cell.lblPaymentStatus.text = userPayoutHistory[indexPath.row].razorpayStatus
        
        if (userPayoutHistory[indexPath.row].status == 0 || userPayoutHistory[indexPath.row].status == 1 || userPayoutHistory[indexPath.row].status == 2 || userPayoutHistory[indexPath.row].status == 4 || userPayoutHistory[indexPath.row].status == 5) {
            
            cell.imgViewPaymentStatus.image = UIImage(named: "SuccessImage")
            
        } else if (userPayoutHistory[indexPath.row].status == 3 || userPayoutHistory[indexPath.row].status == 6 || userPayoutHistory[indexPath.row].status == 7 || userPayoutHistory[indexPath.row].status == 8) {
            
            cell.imgViewPaymentStatus.image = UIImage(named: "ReversedImage")
            
        }
        
        if (userPayoutHistory[indexPath.row].utrNo == "" || userPayoutHistory[indexPath.row].utrNo == nil) {
            
            cell.lblUtrNumberHeading.isHidden = true
            cell.lblUtrNumber.isHidden = true
            cell.lblOrderStatusTopConstraints.constant = 0
            cell.viewPaymentStatusTopConstraints.constant = -10
        } else {
            
            cell.lblUtrNumberHeading.isHidden = false
            cell.lblUtrNumber.isHidden = false
            cell.lblOrderStatusTopConstraints.constant = 18
            cell.viewPaymentStatusTopConstraints.constant = 10
            
        }
        if (userPayoutHistory[indexPath.row].status == 0) {

            cell.lblPaymentStatus.text = "Applied"
            cell.imgViewPaymentStatus.image = UIImage(named: "SuccessImage")

        } else if (userPayoutHistory[indexPath.row].status == 1) {

            cell.lblPaymentStatus.text = "Queued"
            cell.imgViewPaymentStatus.image = UIImage(named: "SuccessImage")

        } else if (userPayoutHistory[indexPath.row].status == 2) {

            cell.lblPaymentStatus.text = "Pending"
            cell.imgViewPaymentStatus.image = UIImage(named: "SuccessImage")

        } else if (userPayoutHistory[indexPath.row].status == 3) {

            cell.lblPaymentStatus.text = "Rejected"
            cell.imgViewPaymentStatus.image = UIImage(named: "ReversedImage")

        } else if (userPayoutHistory[indexPath.row].status == 4) {

            cell.lblPaymentStatus.text = "Processing"
            cell.imgViewPaymentStatus.image = UIImage(named: "SuccessImage")

        } else if (userPayoutHistory[indexPath.row].status == 5) {

            cell.lblPaymentStatus.text = "Processed"
            cell.imgViewPaymentStatus.image = UIImage(named: "SuccessImage")

        } else if (userPayoutHistory[indexPath.row].status == 6) {

            cell.lblPaymentStatus.text = "Cancelled"
            cell.imgViewPaymentStatus.image = UIImage(named: "ReversedImage")

        } else if (userPayoutHistory[indexPath.row].status == 7) {

            cell.lblPaymentStatus.text = "Reversed"
            cell.imgViewPaymentStatus.image = UIImage(named: "ReversedImage")

        } else if (userPayoutHistory[indexPath.row].status == 8) {

            cell.lblPaymentStatus.text = "Failed"
            cell.imgViewPaymentStatus.image = UIImage(named: "ReversedImage")

        }
        
        if (userPayoutHistory[indexPath.row].paymentRequestAccount?.type == 1) {
            
            cell.lblAccountHeading.text = "Account"
            cell.lblAccountNumber.text = userPayoutHistory[indexPath.row].paymentRequestAccount?.accountNumber
          
            
        } else if (userPayoutHistory[indexPath.row].paymentRequestAccount?.type == 2) {
            
            cell.lblAccountHeading.text = "Upi"
            cell.lblAccountNumber.text = userPayoutHistory[indexPath.row].paymentRequestAccount?.upiID
            
        } else if (userPayoutHistory[indexPath.row].paymentRequestAccount?.type == 3) {
            
            cell.lblAccountHeading.text = "Epay"
            cell.lblAccountNumber.text = userPayoutHistory[indexPath.row].paymentRequestAccount?.email
            
        } else if (userPayoutHistory[indexPath.row].paymentRequestAccount?.type == 5) {
            
            cell.lblAccountHeading.text = "Account"
            let jsonString = userPayoutHistory[indexPath.row].paymentRequestAccount?.epayReceiverInfo

            if let data = jsonString?.data(using: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let accountNo = jsonObject["accountNo"] as? String {
                        // Now, you have the account number
                        print("Account Number: \(accountNo)")
                        cell.lblAccountNumber.text = accountNo
                        
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
           
        }
        
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (userPayoutHistory[indexPath.row].utrNo == "" || userPayoutHistory[indexPath.row].utrNo == nil) {
            
            return 240
            
        } else {
         
            return 260
            
        }
        
    }
    
}

// MARK: - EXTENSION FOR CALLING API AND GETTING DATA

extension WalletDetailsViewController {
   
    func getUserEarningHistory() {
        
        ApiWrapper.sharedManager().getUserEarningDetails(url: AllUrls.getUrl.getUserEarningDetails) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            userPayoutHistory = data ?? userPayoutHistory
            print(userPayoutHistory)
     
            if (userPayoutHistory == nil) || (userPayoutHistory.count == 0) {
                print("data nahi hai ismain")
            } else {
                print(userPayoutHistory[0].paymentRequestAccount?.type)
                tblView.reloadData()
            }
        }
    }
    
}
