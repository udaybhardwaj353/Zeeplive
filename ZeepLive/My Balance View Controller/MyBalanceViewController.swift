//
//  MyBalanceViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/05/23.
//

import UIKit
import StoreKit

class MyBalanceViewController: UIViewController, delegateCoinDetailsTableViewCell, delegateMyBalanceIssuesTableViewCell, delegateDiamondPriceTableViewCell {
   
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
   // var window: UIWindow?
    
    lazy var remainingCoins: Int = 0
    lazy var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "CoinDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinDetailsTableViewCell")
        tblView.register(UINib(nibName: "DiamondPriceTableViewCell", bundle: nil), forCellReuseIdentifier: "DiamondPriceTableViewCell")
        tblView.register(UINib(nibName: "MyBalanceIssuesTableViewCell", bundle: nil), forCellReuseIdentifier: "MyBalanceIssuesTableViewCell")
        
        print(remainingCoins)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard isMovingFromParent else { return }
        
        if let section0Cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CoinDetailsTableViewCell {
            section0Cell.delegate = nil
        }
        if let section1Cell = tblView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DiamondPriceTableViewCell {
            section1Cell.delegate = nil
        }
        if let section2Cell = tblView.cellForRow(at: IndexPath(row: 0, section: 2)) as? MyBalanceIssuesTableViewCell {
            section2Cell.delegate = nil
        }
        tblView = nil
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
       // self.navigationController?.popViewController(animated: true)
           tblView.delegate = nil
           tblView.dataSource = nil
        
        performSegueToReturnBack()
    }
   
    deinit {
        
        self.removeFromParent()
        print("Controller main deinit call hua hai")
        
    }
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS FOR SHOWING DATA IN TABLE VIEW CELL

extension MyBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoinDetailsTableViewCell", for: indexPath) as! CoinDetailsTableViewCell
            
            if (remainingCoins < 0) {
                cell.lblTotalCoins.text = "0"
            } else {
                cell.lblTotalCoins.text = String(remainingCoins)
            }
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        }
        if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiamondPriceTableViewCell", for: indexPath) as! DiamondPriceTableViewCell

            
            cell.frame = tableView.bounds
                       cell.layoutIfNeeded()
                       cell.collectionView.reloadData()
                       cell.collectionViewHeightConstraints.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            print(cell.collectionViewHeightConstraints.constant)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        if (indexPath.section == 2) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBalanceIssuesTableViewCell", for: indexPath) as! MyBalanceIssuesTableViewCell
            
            cell.viewBannerHeightConstraints.constant = 0
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 150
        }
        if (indexPath.section == 1) {
            return UITableView.automaticDimension
        }
        if (indexPath.section == 2) {
            return 130
        }
        return 0
    }

// MARK: - DELEGATE FUNCTION TO PASS DATA TO THE PAYMENT PAGE AND GETTING DATA FROM DIAMOND PRICE TABLE VIEW CELL
    
    func selectedCellIndex(index: Int, price:Float , points:String, planId:Int,inApp:SKPayment) {
        print(index)
        print(price)
        print(points)
        print(planId)
        print(inApp)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectPaymentModeViewController") as! SelectPaymentModeViewController
        nextViewController.price = price
        nextViewController.noOfCoins = points
        nextViewController.planId = planId
        nextViewController.inAppModel = inApp
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }

 // MARK: - DELEGATE FUNCTION FROM DIAMOND PRICE TABLE VIEW CELL TO RELOAD TABLE VIEW WHEN THE PLAN DETAILS DATA IS SET IN THE COLLECTION VIEW
    
    func isDataLoaded(answer: String) {
       
        tblView.reloadData()
        
    }
    
    func diamondPurchased(isPurchased: Bool, message: String) {
        
        print(isPurchased)
        print(message)
        
        if (isPurchased == true) {
            
            let coin = (UserDefaults.standard.string(forKey: "coins") ?? "0")
            remainingCoins = (Int(coin) ?? 0)
            tblView.reloadData()
            showAlert(title: "SUCCESS !", message: message, viewController: self)
            
        } else {
            
            showAlert(title: "ERROR !", message: message, viewController: self)
            
        }
    }
    
// MARK: - DELEGATE FUNCTION FOR COIN DETAILS FROM COIN DETAILS TABLE VIEW CELL
    
    func buttonCoinDetailsPressed(isPressed: Bool) {
        print(isPressed)
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CoinDetailsViewController") as! CoinDetailsViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func viewBannerPressed(isPressed: Bool) {
        print(isPressed)
        userId = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        openWebView(withURL: "https://agencyhosts.com/bigdeals/\(userId)")
    }
// MARK: - DELEGATE FUNCTION FOR GIVING ACTIONS ON THE CLICK OF BUTTONS FROM MY BALANCE ISSUES TABLE VIEW CELL
    
    func buttonsActions(buttonType: String) {
        print(buttonType)
        
        if (buttonType == "TopUp") {
            print("Privacy policy vala page open karna hai")
            
            openWebView(withURL: "https://sites.google.com/view/zeeplive/terms")
            
        }
        
        if (buttonType == "Email") {
            print("Mail bhejna hai vali button dabi hai")
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
    
}
