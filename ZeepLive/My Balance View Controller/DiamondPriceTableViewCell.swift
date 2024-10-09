//
//  DiamondPriceTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 02/05/23.
//

import UIKit
import StoreKit

protocol delegateDiamondPriceTableViewCell: AnyObject {

    func selectedCellIndex(index:Int, price:Float , points:String , planId:Int, inApp:SKPayment)
    func isDataLoaded(answer:String)
    func diamondPurchased(isPurchased: Bool, message: String)
    
}

class DiamondPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraints: NSLayoutConstraint!
    
   private var selectedCellIndex = Int()
   weak var delegate: delegateDiamondPriceTableViewCell?
   lazy var plansDetails = getPlanList()
    lazy var arrInAppProductID: [String] = []
    lazy var models = [SKProduct]()
    
    lazy var planID: Int = 0
    lazy var receiptData: String = ""
    lazy var envirmnet: String = ""
    lazy var transactionID: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        SKPaymentQueue.default().add(self)
        fetchProducts()
        showLoader()
        
        collectionView.register(UINib(nibName: "DiamondPriceDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiamondPriceDetailsCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        //getPlansDetails()
        setData()
        getInAppPurchaseBundleName()
        
    }

    func setData() {
        
        plansDetails = PlanListManager.shared.storePlanListResponse ?? plansDetails
        
    }
    
    override func prepareForReuse() {
           super.prepareForReuse()
           delegate = nil
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        
        arrInAppProductID.removeAll()
           delegate = nil
        plansDetails = getPlanList()
           collectionView.removeFromSuperview()
           removeFromSuperview()
           print("Deinit called")
       }
}

// MARK: - EXTENSION FOR USING COLLECTION VIEW DELEGATES AND METHODS FOR SETTING DATA IN COLLECTION VIEW CELL FOR DIAMOND RECHARGE

extension DiamondPriceTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plansDetails.inrData?.count ?? 0 // models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiamondPriceDetailsCollectionViewCell", for: indexPath) as! DiamondPriceDetailsCollectionViewCell
        
     //   let products = models[indexPath.row]
        
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

        
        if indexPath.row == selectedCellIndex {
        
            cell.viewMain.backgroundColor = GlobalClass.sharedInstance.setDiamondPriceBackgroundColour()
            cell.viewMain.layer.borderColor = GlobalClass.sharedInstance.setOrangeBorderColour().cgColor//UIColor.orange.cgColor
            cell.viewMain.layer.borderWidth = 2.7
        } else {
            
            cell.viewMain.backgroundColor = .white
            cell.viewMain.layer.borderColor = GlobalClass.sharedInstance.setGapColour().cgColor
            cell.viewMain.backgroundColor = GlobalClass.sharedInstance.setDiamondPriceUnselectBackgroundColour()
            cell.viewMain.layer.borderWidth = 0
        }
       
        let a: Int = plansDetails.inrData?[indexPath.item].points ?? 0
      lazy var b : String = String(a)
        let c: Int = plansDetails.inrData?[indexPath.item].amount ?? 0
       lazy var d : String = String(c)
        
        cell.lblNoOfDiamonds.text = b
        cell.lblPrice.text = "₹" + "" + d
      
//            let priceString = String(describing: products.price)
//         //   cell.lblPrice.text = "$" + priceString
//            
//        let diamondCount = String(describing: products.localizedTitle)
//       // cell.lblNoOfDiamonds.text = diamondCount
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 6 * 6 ) / 2
        let height = width - 65
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        showLoader()
        selectedCellIndex = indexPath.item
        print("The selected plans details are: \(plansDetails.inrData?[selectedCellIndex])")
        
        planID = (plansDetails.inrData?[selectedCellIndex].id ?? 0)
        print("The plan id here is: \(planID)")

        collectionView.reloadData()
        
        if let product = models.indices.contains(indexPath.row) ? models[indexPath.row] : nil {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            print(models[indexPath.row])
        } else {
            print("Index out of range: \(indexPath.row)")
        }

#if DEBUG
let environment = "Debug"
#elseif STAGING
let environment = "Staging"
#else
let environment = "Production"
#endif

print("Running in \(environment) environment")

    }
    
}

// MARK: - EXTENSION FOR API CALLING

extension DiamondPriceTableViewCell {
   
    func getPlansDetails() {
        
        ApiWrapper.sharedManager().getPlansList(url: AllUrls.getUrl.getPlansList) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            plansDetails = data ?? plansDetails
            print(plansDetails.inrData?.count)
            print(plansDetails.dollarData?.count)
            
//            delegate?.isDataLoaded(answer: "Yes")
            getInAppPurchaseBundleName()
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
                
                delegate?.diamondPurchased(isPurchased: true, message: "Diamonds has been successfully added into your account.")
           //     showAlertwithButtonAction(title: "SUCCESS !", message: "Your Profile has been updated successfully", viewController: self)
                
            }  else {
                
                hideLoader()
                print("Kuch gadbad hai coins abhi add nahi hue hai user ke balance main shi se.")
                
                delegate?.diamondPurchased(isPurchased: false, message: data["error"] as? String ?? "Something went wrong.")
                
            }
        }
    }
    
    private func fetchProducts() {
        
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
        print("The request is: \(request)")
        request.delegate = self
        request.start()
        
    }
    
    enum Product: String, CaseIterable {
    
        case removeAds = "com.zeeplive.in.225_second_plan"
        case unlockEverything = "com.zeeplive.in.400_second_plan"
        case getGems = "com.zeeplive.in.900_second_plan"
        case getFeatures = "com.zeeplive.in.1800_second_plan"
        case fifth = "com.zeeplive.in.4500_second_plan"
        case sixth = "com.zeeplive.in.9900_second_plan"
        
    }
    
}

// MARK: - EXTENSION FOR USING STORE KIT / IN APP PURCAHSE FUNCTIONS AND THEIR WORKING

extension DiamondPriceTableViewCell:  SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        DispatchQueue.main.async {
            self.hideLoader()
            print("count is: \(response.products.count)")
            self.models = response.products
            print(self.models)
            self.models.sort { $0.price.compare($1.price) == .orderedAscending }
            self.delegate?.isDataLoaded(answer: "Yes")
            self.collectionView.reloadData()
        }
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
          print("Product request failed with error: \(error.localizedDescription)")
          // Handle the error appropriately
      }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("The transactions is: \(transactions)")
        print("The queue is: \(queue)")
     
        hideLoader()
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
                
                delegate?.diamondPurchased(isPurchased: false, message: "User has cancelled the purchase.")
                
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

//    private func fetchProducts() {
//
//        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
//        request.delegate = self
//        request.start()
//
//    }
//
//    enum Product: String, CaseIterable {
//
//        case firstPlan = "com.zeeplive.in.225_second_plan"
//        case secondPlan = "com.zeeplive.in.400_second_plan"
//        case thirdPlan = "com.zeeplive.in.900_second_plan"
//        case fourthPlan = "com.zeeplive.in.1800_second_plan"
//        case fifthPlan = "com.zeeplive.in.4500_second_plan"
//        case sixthPlan = "com.zeeplive.in.9900_second_plan"
//
//    }
//        let products = models[indexPath.item]
//        let priceAsInteger = Float(products.price.doubleValue)
//        let diamondRecieves = products.localizedTitle
      //  let payment = SKPayment(product: models[indexPath.row])
        
     //   delegate?.selectedCellIndex(index: selectedCellIndex, price: priceAsInteger ?? 0, points: diamondRecieves ?? "0", planId: plansDetails.inrData?[indexPath.item].id ?? 0, inApp: payment)
       
//    func getReceiptData() -> Data? {
//        // Get the URL for the receipt
//        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
//            return nil // No receipt available (usually means the app is not installed from the App Store)
//        }
//
//        // Read the receipt data from the file
//        do {
//            let receiptData = try Data(contentsOf: receiptURL)
//            return receiptData
//        } catch {
//            print("Error reading receipt data: \(error)")
//            return nil
//        }
//    }

//                // Example usage
//                if let receiptData = getReceiptData() {
//                    print("Base64-encoded receipt data: \(receiptData)")
//                }
//
//                if let receiptData = getReceiptData(), let transaction = transactions.first {
//                   print("The reciept data we are gettign is:\(receiptData)")
//
//                }

//        let request = SKProductsRequest(productIdentifiers: Set(arrInAppProductID))
//        request.delegate = self
//        request.start()
      //  fetchProducts()
        
//        print(models[indexPath.row])
//        let payment = SKPayment(product: models[indexPath.row])
//        SKPaymentQueue.default().add(payment)
        
//                // Example usage
//                if let receiptData = getReceiptData() {
//                    print("Base64-encoded receipt data: \(receiptData)")
//                }
