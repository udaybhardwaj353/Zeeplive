//
//  LowBalanceViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 10/01/24.
//

import UIKit
import StoreKit

class LowBalanceViewController: UIViewController {
   
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTotalCoins: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var selectedCellIndex: Int = 0
    lazy var plansDetails = getPlanList()
    lazy var arrInAppProductID: [String] = []
    lazy var models = [SKProduct]()
    
    lazy var planID: Int = 0
    lazy var receiptData: String = ""
    lazy var envirmnet: String = ""
    lazy var transactionID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
      //  getPlansDetails()
        setData()
        getInAppPurchaseBundleName()
       collectionViewWork()
        
    }
    
    func collectionViewWork() {
        
        collectionView.register(UINib(nibName: "DiamondPriceDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiamondPriceDetailsCollectionViewCell")
        collectionView.register(UINib(nibName: "IssueInPurchaseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IssueInPurchaseCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let coin = UserDefaults.standard.string(forKey: "coins")
        lblTotalCoins.text = coin ?? "0"
        
    }

    func setData() {
    
        plansDetails = PlanListManager.shared.storePlanListResponse ?? plansDetails
        
    }
    
}

extension LowBalanceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, delegateIssueInPurchaseCollectionViewCell {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (section == 0) {
            
            return plansDetails.inrData?.count ?? 0
            
        } else {
            
            return 1
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.section == 0) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiamondPriceDetailsCollectionViewCell", for: indexPath) as! DiamondPriceDetailsCollectionViewCell
            
//            if indexPath.row == selectedCellIndex {
//            
//                cell.viewMain.backgroundColor = GlobalClass.sharedInstance.setDiamondPriceBackgroundColour()
//                cell.viewMain.layer.borderColor = GlobalClass.sharedInstance.setOrangeBorderColour().cgColor//UIColor.orange.cgColor
//                cell.viewMain.layer.borderWidth = 2.7
//            } else {
//                
//                cell.viewMain.backgroundColor = .white
//                cell.viewMain.layer.borderColor = GlobalClass.sharedInstance.setGapColour().cgColor
//                cell.viewMain.backgroundColor = GlobalClass.sharedInstance.setDiamondPriceUnselectBackgroundColour()
//                cell.viewMain.layer.borderWidth = 0
//            }
           
            let a: Int = plansDetails.inrData?[indexPath.item].points ?? 0
          lazy var b : String = String(a)
            let c: Int = plansDetails.inrData?[indexPath.item].amount ?? 0
           lazy var d : String = String(c)
            
            cell.lblNoOfDiamonds.text = b
           cell.lblPrice.text = "₹" + "" + d

            if indexPath.row < models.count {
                let products = models[indexPath.row]
                // Use the 'product' safely here
                let priceString = String(describing: products.price)
             //   cell.lblPrice.text = "$" + priceString
                
            let diamondCount = String(describing: products.localizedTitle)
           // cell.lblNoOfDiamonds.text = diamondCount
            } else {
                print("Index out of range: \(indexPath.row)")
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueInPurchaseCollectionViewCell", for: indexPath) as! IssueInPurchaseCollectionViewCell
            
            cell.delegate = self
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (indexPath.section == 0) {
            let width = (collectionView.bounds.size.width - 6 * 6 ) / 2
            let height = width - 65
            return CGSize(width: width, height: height)
            
        } else {
            
            let width = (collectionView.bounds.size.width )
            return CGSize(width: width, height: 80)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if (section == 0) {
            return 10
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if (section == 0) {
            return 4
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        if (indexPath.section == 0) {
            
            print("Pehle plan wale cell ka index hai: \(indexPath.row)")
         
            selectedCellIndex = indexPath.item
            
            planID = (plansDetails.inrData?[selectedCellIndex].id ?? 0)
            print("The plan id here is: \(planID)")
            
            if let product = models.indices.contains(indexPath.row) ? models[indexPath.row] : nil {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
            } else {
                print("Index out of range: \(indexPath.row)")
            }

            
        } else {
            
            print("Doosre wale cell ka index click hua hai: \(indexPath.row)")
            
        }
    }
    
    func buttonPressed(isPressed: Bool) {
        
        print("Email Button Pressed: \(isPressed)")
        let email = "zeepliveofficial@gmail.com"//"swastik_tyagi@creativefrenzy.in"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
            if(UIApplication.shared.canOpenURL(url)){
               
                print("Mail app khul raha hai . jisse ki aap mail bhej sakte hai aaram se.")
        } else{
                print("Kuch gadbad hai . isliye mail app open nahi ho raha hai")
                
        }
    }
        
    }
    
}
    
extension LowBalanceViewController {
   
    func getPlansDetails() {
        
        ApiWrapper.sharedManager().getPlansList(url: AllUrls.getUrl.getPlansList) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            plansDetails = data ?? plansDetails
            print(plansDetails.inrData?.count)
            print(plansDetails.dollarData?.count)
            getInAppPurchaseBundleName()
         //   collectionView.reloadData()
        }
    }
    
    func getInAppPurchaseBundleName() {
    
        print("The inr data count is: \(plansDetails.inrData?.count)")
        plansDetails.inrData?.forEach{
            print($0.name)
            let id = (GlobalClass.sharedInstance.bundleId ?? "") + "." + ($0.name ?? "")
            print("The final id is: \(id)")
            arrInAppProductID.append(id)
            print("The array with in app product bundle id is: \(arrInAppProductID)")
            
        }
        
        print("The array count with in app purchase id is: \(arrInAppProductID.count)")

        let request = SKProductsRequest(productIdentifiers: Set(arrInAppProductID))
        request.delegate = self
        request.start()
        
        showLoader()
      //  fetchProducts()
        
    }
    
    // MARK: - FUNCTION FOR CALLING API TO ADD DIAMONDS IN THE USER ACCOUNT
    
      func addDiamonds() {
        
          showLoader()
          
        let params = [
            "plan_id": planID,
            "receipt_data": receiptData,
            "transaction_id": transactionID,
            "environment": "debug"
            
        ] as [String : Any]
        
        print("The param data we are sending to add diamonds in our account is: \(params)")
          
        ApiWrapper.sharedManager().addCoins(url: AllUrls.getUrl.recharge,parameters: params) { [weak self] (data) in
            guard let self = self else { return }
            
            if (data["success"] as? Bool == true) {
                print(data)
             
                hideLoader()
                
                print("sab shi hai. kuch gadbad nahi hai. user ke account main diamond add kar diya hai shi se.")
                
                let balance = data["result"] as? Int ?? 0
                print("The balance of the user is: \(balance)")
                
                UserDefaults.standard.set(balance, forKey: "coins")
               
                lblTotalCoins.text = String(balance ?? 0)
                
            }  else {
                
                hideLoader()
                print("Kuch gadbad hai coins abhi add nahi hue hai user ke balance main shi se.")
                
            }
        }
    }
    
}
    
extension LowBalanceViewController:  SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
           
            self.hideLoader()
            
            print("count is: \(response.products.count)")
            self.models = response.products
            print(self.models)
            self.models.sort { $0.price.compare($1.price) == .orderedAscending }
            self.collectionView.reloadData()
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("The transactions is: \(transactions)")
        print("The queue is: \(queue)")
        transactions.forEach({
            
            switch $0.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                if let transactionIdentifier = $0.transactionIdentifier {
                                print("Transaction Identifier: \(transactionIdentifier)")
                                transactionID = transactionIdentifier
                        print("The transaction id to send is: \(transactionIdentifier)")
                                // Here you can handle the purchase completion and provide access to the content or features the user purchased based on the identifier
                            }
                 let productIdentifier = $0.payment.productIdentifier
                               // Pass productIdentifier to your backend
                               // Your backend will process the purchase and return a unique identifier
                               print("Product Identifier: \(productIdentifier)")
                           
                if let receiptData = getReceiptData(), let transaction = transactions.first {
                   print("The reciept data we are gettign is:\(receiptData)")
                    self.receiptData = receiptData
                    print("The global receipt data is: \(self.receiptData)")
                    
                }
                
                addDiamonds()
                
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("did not purchased")
                if let transactionIdentifier = $0.transactionIdentifier {
                                print("Transaction Identifier: \(transactionIdentifier)")
                                // Here you can handle the purchase completion and provide access to the content or features the user purchased based on the identifier
                            }
                
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        print(queue)
        print(payment)
        print(product)
        print(product.productIdentifier)
        return true
    }
    
    func getReceiptData() -> String? {
        // Get the URL of the receipt
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            return nil
        }

        do {
            // Read the receipt data
            let receiptData = try Data(contentsOf: receiptURL)
            
            // Convert the receipt data to a Base64 encoded string
            let receiptString = receiptData.base64EncodedString(options: [])
            
            return receiptString
        } catch {
            print("Failed to read receipt data: \(error)")
            return nil
        }
    }
    
}

//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymentModeViewController") as! SelectPaymentModeViewController
//            nextViewController.price = Float(plansDetails.inrData?[indexPath.row].amount ?? 0)
//            nextViewController.noOfCoins = String(plansDetails.inrData?[indexPath.item].points ?? 0)
//            nextViewController.planId = plansDetails.inrData?[indexPath.item].id ?? 0
//
//            self.navigationController?.pushViewController(nextViewController, animated: true)
            //collectionView.reloadData()
//            print(models[indexPath.row])
//            let payment = SKPayment(product: models[indexPath.row])
//            SKPaymentQueue.default().add(payment)
