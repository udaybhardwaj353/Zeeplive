//
//  SelectPaymentModeViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 09/05/23.
//

import UIKit
import AppInvokeSDK
import StoreKit

class SelectPaymentModeViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
   lazy var arrPaymentOptionName = [String]()
   lazy var arrPaymentOptionImageName = [String]()
    
   lazy var noOfCoins = String()
   lazy var price = Float()
    
    // MARK: - VARIABLES FOR PAYTM PAYMENT INTEGRATION
        
    lazy var appInvoke = AIHandler()
    lazy var paytmMerchantId = "tMqhJe94775996465382"
    lazy var paytmTxnToken: String = ""
    lazy var amount : String = ""
    lazy var paytmCallBackURL : String = ""
    lazy var orderId: String = ""
    lazy var deepLinkUrl: String = ""
    lazy var planId: Int = 0
    
    lazy var inAppModel = SKPayment()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let url = NSURL(string: "upi://pay?pa=paytm-74191808@paytm&pn=GOMEDICOS%20HEALTHCARE%20SOLUTIONS%20PRIV&mc=5912&tid=PYTM3042624715213503521&tr=3042624715213503521&am=1.8&cu=INR") else {
//               return
//           }
//
//           UIApplication.shared.open(url as URL)
        
//        if let paytmURL = URL(string: "upi://pay?pa=paytm-74191808@paytm&pn=GOMEDICOS%20HEALTHCARE%20SOLUTIONS%20PRIV&mc=5912&tid=PYTM3042624715213503521&tr=3042624715213503521&am=1.8&cu=INR") {
//            if UIApplication.shared.canOpenURL(paytmURL) {
//                UIApplication.shared.open(paytmURL, options: [:], completionHandler: nil)
//            } else {
//                // Handle the case where Paytm app is not installed
//                print("Paytm app is not installed.")
//            }
//        } else {
//            // Handle the case where the URL is not valid
//            print("Invalid URL for Paytm.")
//        }
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "PaymentDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentDetailsTableViewCell")
        tblView.register(UINib(nibName: "PaymentOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentOptionsTableViewCell")
        
        arrPaymentOptionName = ["Google Pay", "PhonePe", "Paytm", "In-App Purchase"]
        arrPaymentOptionImageName = ["GooglePayImage","PhonePeImage", "PaytmImage", "InAppPurchase"]
       
        print("JO paise milenge woh hai \(price)")
        print("JO coins milenge vh hai \(noOfCoins)")
        
        print("The plan id is: \(planId)")
        
        
//        if isPaytmInstalled() {
//            print("Paytm is installed on the device.")
//            openUPIPayment()
//
//        } else {
//            print("Paytm is not installed on the device.")
//        }
        
    }

    func isPaytmInstalled() -> Bool {
        if let url = URL(string: "paytm://") {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
  // MARK: - FUNCTION TO CHECK IF THE UPI APP IS INSTALLED IN THE PHONE OR NOT
    
    func openUPIPayment(url:String = "") {
        if let upiURL = URL(string: url) {

                UIApplication.shared.open(upiURL, options: [:]) { (success) in
                    if success {
                        // The UPI app was successfully opened
                        print("UPI payment app was opened.")
                    } else {
                        // Handle the case where opening the UPI app failed
                        print("Failed to open UPI payment app.")
                    }
                }
           
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    deinit {
      
                tblView.delegate = nil
                tblView.dataSource = nil

                arrPaymentOptionName.removeAll()
                arrPaymentOptionImageName.removeAll()
                noOfCoins = ""
                price = 0

                print("SelectPaymentModeViewController is being deallocated")
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS TO SHOW DATA IN TABLE VIEW CELL

extension SelectPaymentModeViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - FUNCTIONS FOR SETTING HEADER IN TABLE VIEW SECOND SECTION FOR HEADING
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) {
            return "Select Payment Method"
        } else {
            return nil
        }
    }
  
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1 {
        if let headerView = view as? UITableViewHeaderFooterView {
                headerView.contentView.backgroundColor = .white
                headerView.textLabel?.textColor = .black
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            }
        }
    }

// MARK: - TABLE VIEW FUNCTION FOR SHOWING SECTIONS AND ROWS IN IT AND SHOWING DATA IN IT
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return 1//arrPaymentOptionName.count
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailsTableViewCell", for: indexPath) as! PaymentDetailsTableViewCell
            
            cell.lblNoOfCoins.text = String(noOfCoins)
            cell.lblPrice.text = "$" + " " +  String(price)
            
            cell.selectionStyle = .none
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionsTableViewCell", for: indexPath) as! PaymentOptionsTableViewCell
            
            cell.lblOptionsName.text = "In-App Purchase"//arrPaymentOptionName[indexPath.row]
            cell.imgView.image = UIImage(named: "InAppPurchase")//UIImage(named: arrPaymentOptionImageName[indexPath.row])
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 105
        } else {
            return 80
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
               // let payment = SKPayment(product: models[indexPath.row])
                SKPaymentQueue.default().add(inAppModel)
            }
            
//            if (indexPath.row == 2) {
//                
//                getPaytmDetails()
//                
//            }
            
        }
    }
}

extension SelectPaymentModeViewController {
    
    func getPaytmDetails() {
        let params = [
            "plan_id": planId
        ] as [String : Any]

        print("The params for the plan id is: \(params)")

        ApiWrapper.sharedManager().createPaymentPaytm(url: AllUrls.getUrl.createPaymentFromPaytm, parameters: params, completion: { [weak self] (data) in
            guard let self = self else {
                return // The object has been deallocated
            }

            if (data["success"] as? Bool == true) {
                print(data)
                print("Sab kuch sahi hai")
                
                let a = data["result"] as? [String: Any]
                print(a)
                
                orderId = a?["order_id"] as? String ?? ""
                paytmTxnToken = data["txnToken"] as? String ?? ""
                amount = a?["amount"] as? String ?? ""
                paytmCallBackURL = "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=\(orderId)"
                deepLinkUrl = data["deepLink"] as? String ?? ""
                
                print(orderId)
                print(paytmTxnToken)
                print(amount)
                print(paytmCallBackURL)
                print(deepLinkUrl)
                
                if isPaytmInstalled() {
                    print("Paytm is installed on the device.")
                    openUPIPayment(url: deepLinkUrl)
                    
                } else {
                    print("Paytm is not installed on the device.")
                    hitInitiateTransaction(.production)
                }
            } else {
                print(data["error"])
                print("Kuch error hai")
            }
        })
    }


    // MARK: - Function to call after the payment has been done by the user
    func validatePaytmPayment() {
        let params = [
            "order_id": orderId
        ] as [String : Any]

        print("The params for the order id is: \(params)")

        ApiWrapper.sharedManager().confirmPaymentPaytm(url: AllUrls.getUrl.checkPaymentConfirmationForPaytm, parameters: params, completion: { [weak self] (data) in
            guard let self = self else {
                return // The object has been deallocated
            }

            if (data["success"] as? Bool == true) {
                print(data)
                print("Sab kuch sahi hai")
            } else {
                print(data["error"])
                print("Kuch error hai")
            }
        })
    }

}

// MARK: - EXTENSION TO GET THE RESPONSE FROM PAYTM AFTER OPENING IT FOR THE PAYMENT

extension SelectPaymentModeViewController: AIDelegate {
   
    func didFinish(with status: AIPaymentStatus, response: [String : Any]) {
        print("🔶 Paytm Callback Response: ", response)

        guard let a = response["STATUS"] as? String else {
            let alert = UIAlertController(title: "ERROR!", message: response["response"] as? String ?? "Something went Wrong!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }

        let b = response["RESPMSG"] as! String
        print(b)

        if a.contains("FAILURE") {
            print("Payment failed")
            let alert = UIAlertController(title: "ERROR!", message: b, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        } else if a.contains("SUCCESS") {
            print("Payment successful")
            self.validatePaytmPayment()
        } else {
            let alert = UIAlertController(title: "ERROR!", message: "Something went Wrong!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }


    
    func openPaymentWebVC(_ controller: UIViewController?) {
        if let vc = controller {
            DispatchQueue.main.async {[weak self] in
                self?.present(vc, animated: true, completion: nil)
            }
        }
        self.dismiss(animated: true)
    }
    
}

private extension SelectPaymentModeViewController {
    
    func hitInitiateTransaction(_ env: AIEnvironment) {
            
        self.appInvoke.openPaytm(merchantId: self.paytmMerchantId, orderId: String(self.orderId), txnToken: self.paytmTxnToken, amount: self.amount, callbackUrl:self.paytmCallBackURL, delegate: self, environment: env, urlScheme: "")
        }
    
    }
