//
//  NewMyEarningViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 15/03/24.
//

import UIKit
import TYPagerController

class NewMyEarningViewController: UIViewController, delegateExchangeViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnDetailsOutlet: UIButton!
    @IBOutlet weak var viewBalance: UIView!
    @IBOutlet weak var lblBeansAmount: UILabel!
    @IBOutlet weak var lblConversionRate: UILabel!
    @IBOutlet weak var btnRecordOutlet: UIButton!
    @IBOutlet weak var btnQuestionOutlet: UIButton!
    @IBOutlet weak var viewTabPagerBar: TYTabPagerBar!
    @IBOutlet weak var viewMain: UIView!
    
    lazy var datas: [String] = []
    var pagerController : TYPagerController?
    lazy var myBalance: Int = 0
    lazy var earningData = walletHistoryForMyEarningResult()
    lazy var countryName: String = "India"
    lazy var countryImage: String = ""
    lazy var countryCode: String = "+91"
    lazy var countryID: Int = 0
    lazy var payoutFees: Int = 0
    lazy var totalAmountINR: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataToShow()
        configureUI()
        loadData()
        setupTabPagerBar()
        
//        configurePageControl()
//        loadData()
//        setupTabPagerBar()
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed.")
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnDetailsPressed(_ sender: Any) {
        
        print("Button Details Pressed.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WalletDetailsViewController") as! WalletDetailsViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func btnRecordPressed(_ sender: Any) {
        
        print("Button Record Pressed.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IncomeReportViewController") as! IncomeReportViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func btnQuestionPressed(_ sender: Any) {
        
        print("Button Question Pressed.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InSufficientWithdrawalBalanceViewController") as! InSufficientWithdrawalBalanceViewController
      
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
    func configureUI() {
    
        tabBarController?.tabBar.isHidden = true
        btnRecordOutlet.layer.cornerRadius = btnRecordOutlet.frame.height / 2
        lblBeansAmount.text = String(myBalance) + " " + "Beans"
        
    }
    
}

extension NewMyEarningViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate {
    
    func configurePageControl() {
    
            pagerController = TYPagerController()
            pagerController?.dataSource = self
            pagerController?.delegate = self
            
            addChild(pagerController!)
            viewMain.addSubview(pagerController!.view)
            pagerController?.didMove(toParent: self)
            
            pagerController?.view.frame = viewMain.bounds
            pagerController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    func loadData() {
        self.datas = ["Exchange", "CashOut"]
        self.pagerController?.reloadData()
        self.viewTabPagerBar?.reloadData()
        
    }
    
    func setupTabPagerBar() {

//        self.viewTabPagerBar.layout.barStyle = .progressElasticView
        // Configure other properties as needed

        self.viewTabPagerBar?.layout.barStyle = TYPagerBarStyle.progressElasticView//TYPagerBarStyleProgressElasticView
        self.viewTabPagerBar?.layout.cellSpacing = 0
        self.viewTabPagerBar?.layout.cellEdging = 0
        self.viewTabPagerBar?.layout.normalTextFont = UIFont(name:"HelveticaNeue-Bold", size: 22)!
        self.viewTabPagerBar?.layout.selectedTextFont = UIFont(name:"HelveticaNeue-Bold", size: 27)!
        self.viewTabPagerBar?.layout.normalTextColor = GlobalClass.sharedInstance.setUnSelectedPagerColour()
        self.viewTabPagerBar?.layout.selectedTextColor = GlobalClass.sharedInstance.setSelectedPagerColour()
        self.viewTabPagerBar?.layout.adjustContentCellsCenter = false
        self.viewTabPagerBar?.layout.progressColor = GlobalClass.sharedInstance.setSelectedPagerColour()
        self.viewTabPagerBar?.layout.textColorProgressEnable=true
        
        self.viewTabPagerBar.dataSource = self
        self.viewTabPagerBar.delegate = self
        self.viewTabPagerBar.register(TYTabPagerBarCell.self, forCellWithReuseIdentifier: TYTabPagerBarCell.cellIdentifier())
        self.viewTabPagerBar.reloadData()
        
    }
    
    func numberOfControllersInPagerController() -> Int {
        return datas.count
    }

    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        // Instantiate view controllers based on the index
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            let exchangeVC = sb.instantiateViewController(withIdentifier: "ExchangeViewController") as! ExchangeViewController
                exchangeVC.myBalance = myBalance
                exchangeVC.delegate = self
            return exchangeVC//sb.instantiateViewController(withIdentifier: "ExchangeViewController")
           
        } else {
            let cashoutVC = sb.instantiateViewController(withIdentifier: "CashOutViewController") as! CashOutViewController
            cashoutVC.countryID = countryID
            cashoutVC.countryName = countryName
            cashoutVC.countryImage = countryImage
            cashoutVC.countryCode = countryCode
            cashoutVC.payoutFees = payoutFees
            cashoutVC.totalAmountWithdraw = totalAmountINR
            return cashoutVC
            
           // return sb.instantiateViewController(withIdentifier: "CashOutViewController")
          
        }
    }

    // MARK: - TYTabPagerBarDataSource & TYTabPagerBarDelegate

    func numberOfItemsInPagerTabBar() -> Int {
        return datas.count
    }

    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: TYTabPagerBarCell.cellIdentifier(), for: index)
        cell.titleLabel.text = self.datas[index]
        return cell
    }

    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        return self.viewTabPagerBar.cellWidth(forTitle: self.datas[index])
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
     self.viewTabPagerBar?.scrollToItem(from: fromIndex, to: toIndex, animate: true)
 }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
     self.viewTabPagerBar?.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
 }
 
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
     self.pagerController?.scrollToController(at: index, animate: true)
 }
    
}

extension NewMyEarningViewController {
    
    func getDataToShow() {
        
        
        ApiWrapper.sharedManager().getMyEarningData(url: AllUrls.getUrl.getMyEarningPageDataToShow,completion: { [weak self] (data, value) in
            guard let self = self else {
                // The object has been deallocated
               
                return
            }
                print(data)
                print(value)
            earningData = data ?? earningData
            print("The earning data is: \(earningData)")
            myBalance = (earningData.redeemPoint ?? 0)
        
            totalAmountINR = (earningData.amountInr ?? "0")
            print("The total amount is: \(totalAmountINR)")
            
            lblBeansAmount.text = String(earningData.redeemPoint ?? 0) + " " + "Beans"
            lblConversionRate.text = "$" + (earningData.amountDollor ?? "0") + " " + "=" + " " +  "₹" + (earningData.amountInr ?? "0")
            
            let a = value["country_data"] as? [String : Any]
            print(a)
            
            let b = a?["country_details"] as? [String : Any]
            print(b)
            
            let c = value["payoutFees"] as? [String : Any]
            print(c)
            
            countryID = (b?["id"] as? Int ?? 0)
            countryName = (b?["country_name"] as? String ?? "")
            countryImage = (b?["flag"] as? String ?? "")
            countryCode = (b?["country_code"] as? String ?? "")
            payoutFees = (c?["payout_fee"] as? Int ?? 0)
            
            configurePageControl()
            
        })
    }
    
    func balanceAfterExchange(balance: Int) {
        print("The remaining beans are: \(balance)")
        myBalance = balance
        lblBeansAmount.text = String(myBalance) + " " + "Beans"
        
    }
}

//            if let amountInrString = earningData.amountInr {
//                // Convert the string to a double first
//                if let amountInrDouble = Double(amountInrString) {
//                    // Convert the double to an integer (rounding if needed)
//                    let amountInrInt = Int(amountInrDouble.rounded())
//                    print("Amount INR as Integer: \(amountInrInt)")
//                } else {
//                    print("Error: Failed to convert 'amountInr' to a valid number.")
//                }
//            } else {
//                print("Error: 'amountInr' is nil or missing.")
//            }
