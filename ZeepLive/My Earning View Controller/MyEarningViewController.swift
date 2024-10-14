//
//  MyEarningViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/05/23.
//

import UIKit

class MyEarningViewController: UIViewController, delegateBalanceDetailsTableViewCell {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnDetailsOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnCloseBottomViewOutlet: UIButton!
    @IBOutlet weak var btnExchangeBeansOutlet: UIButton!
    @IBOutlet weak var viewConversionDetails: UIView!
    @IBOutlet weak var viewDiamondAmountRecieved: UIView!
    @IBOutlet weak var lblDiamondAmountRecieved: UILabel!
    @IBOutlet weak var imgViewExchangeImage: UIImageView!
    @IBOutlet weak var viewBeansInformation: UIView!
    @IBOutlet weak var viewBeansAmount: UIView!
    @IBOutlet weak var lblBeansAmount: UILabel!
    @IBOutlet weak var viewGemsInformation: UIView!
    @IBOutlet weak var viewGemsAmount: UIView!
    @IBOutlet weak var lblGemsAmount: UILabel!
    @IBOutlet weak var lblBeans: UILabel!
    @IBOutlet weak var lblGems: UILabel!
    
    lazy var myBalance: Int = 0
    lazy var beansExchangeRate = [getBeansExchangeList]()
    var tapGesture: UITapGestureRecognizer!
    lazy var isBeansExchanged: Bool = false
    lazy var indexSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        configureUI()
        setupTableView()
       print(myBalance)
        getBeansRate()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           guard isMovingFromParent else { return }
           
           if let sectionCell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BalanceDetailsTableViewCell {
               sectionCell.delegate = nil
           }
       }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnDetailsPressed(_ sender: Any) {
        print("Button View Details Pressed")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)  
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WalletDetailsViewController") as! WalletDetailsViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func btnCloseBottomViewPressed(_ sender: Any) {
        
        print("Button Close Bottom View Pressed")
        viewBottom.isHidden = true
        viewBeansInformation.isHidden = false
        viewGemsInformation.isHidden = false
        imgViewExchangeImage.isHidden = false
        viewDiamondAmountRecieved.isHidden = true
        removeTapGesture()
        tblView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func btnExchangeBeansPressed(_ sender: Any) {
        
        exchangeBeans(id: (beansExchangeRate[indexSelected].id ?? 0), beans: (beansExchangeRate[indexSelected].beans ?? 0), diamonds: (beansExchangeRate[indexSelected].diamond ?? 0))
        
        btnExchangeBeansOutlet.isUserInteractionEnabled = false
        print("Button Exchange Beans Pressed")
        
        if (isBeansExchanged == true) {
            viewBottom.isHidden = true
            removeTapGesture()
            tblView.isUserInteractionEnabled = true
            tblView.reloadData()
            
        } else {
            print("Beans abhi exchange nahi hue hai.")
          //  btnExchangeBeansOutlet.setTitle("Exchange Now", for: .normal)
        }
    }
    
    func setupTableView() {
          tblView.delegate = self
          tblView.dataSource = self
          tblView.register(UINib(nibName: "BalanceDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "BalanceDetailsTableViewCell")
          tblView.register(UINib(nibName: "BeansDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "BeansDetailsTableViewCell")
      }
    
    func configureUI() {
    
        viewBottom.isHidden = true
        viewDiamondAmountRecieved.isHidden = true
        viewBottom.backgroundColor = .white
        viewBottom.layer.cornerRadius = 34
        viewBottom.layer.shadowRadius = 1
        viewBottom.layer.shadowOpacity = 0.5
        viewBottom.layer.shadowColor = UIColor.black.cgColor
        viewBottom.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewBottom.layer.borderWidth = 0.5
        viewBottom.layer.borderColor = UIColor.lightGray.cgColor
        
        viewConversionDetails.layer.cornerRadius = 10
        viewConversionDetails.backgroundColor = GlobalClass.sharedInstance.setViewBackgroundColour()
        lblBeansAmount.textColor = GlobalClass.sharedInstance.setBeansExchangeTextColour()
        
        btnExchangeBeansOutlet.layer.cornerRadius = 10
        btnExchangeBeansOutlet.backgroundColor = GlobalClass.sharedInstance.buttonBeansExchangeColour()
        
        lblBeans.textColor = GlobalClass.sharedInstance.setBeansExchangeTextColour()
        lblGems.textColor = GlobalClass.sharedInstance.setBeansExchangeTextColour()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchTap))
//        tapGesture.cancelsTouchesInView = false
      //  view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func touchTap(tap: UITapGestureRecognizer) {
        let tapLocation = tap.location(in: view)
        
        // Check if the tap is in the top half of the screen
        if tapLocation.y < view.frame.size.height / 2 {
            view.endEditing(true)
            viewBottom.isHidden = true
            tblView.isUserInteractionEnabled = true
            print("Neeche ki screen par tap nahi hua hai")
            removeTapGesture()
            // Handle tap in the top half of the screen
        } else {
            view.endEditing(true)
            viewBottom.isHidden = false
            tblView.isUserInteractionEnabled = false
            print("Neeche ki screen par tap hua hai")
            // Handle tap in the bottom half of the screen if needed
        }
    }

    func setupDataInBottomView(index:Int) {
       
        viewBeansInformation.isHidden = false
        viewGemsInformation.isHidden = false
        imgViewExchangeImage.isHidden = false
        viewDiamondAmountRecieved.isHidden = true
        lblBeansAmount.text = String(beansExchangeRate[index].beans ?? 0)
        lblGemsAmount.text = String(beansExchangeRate[index].diamond ?? 0)
        lblDiamondAmountRecieved.text = String(beansExchangeRate[index].diamond ?? 0)
        
    }
    
    func addTapGesture() {
    
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchTap))
               tapGesture.cancelsTouchesInView = false
               // Add tap gesture recognizer to the view
               view.addGestureRecognizer(tapGesture)
        
    }
    
    func removeTapGesture() {
    
        // Remove tap gesture recognizer from the view
        self.view.removeGestureRecognizer(self.tapGesture)

    }
    
    deinit {
        
        print("My Earning main deinit call hua hai")
        self.removeFromParent()
        beansExchangeRate.removeAll()
    }
}

// MARK: - EXTENSIONS FOR USING TABLE VIEW DELEGATES AND DATASOURCE FUNCTIONS TO SHOW DATA IN TABLE VIEW CELLS

extension MyEarningViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return beansExchangeRate.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceDetailsTableViewCell", for: indexPath) as! BalanceDetailsTableViewCell
            cell.lblBalance.text = String(myBalance)
            
            if (beansExchangeRate.count >= 2) {
            
                cell.lblNoOfBeans.text = String(beansExchangeRate[1].beans ?? 0) + " " + " " + " " + "=" + " "
                cell.lblNoOfDiamond.text = String(beansExchangeRate[1].diamond ?? 0)
            } else {
                
                cell.lblNoOfBeans.text = "0"
                cell.lblNoOfDiamond.text = "0"
                
            }
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        }  else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BeansDetailsTableViewCell", for: indexPath) as! BeansDetailsTableViewCell
            
            cell.lblDiamond.text = String(beansExchangeRate[indexPath.row].diamond ?? 0)
            cell.lblBeans.text = String(beansExchangeRate[indexPath.row].beans ?? 0)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("The indexpath selected to exchange bean is: \(indexPath.row)")
        print("The indexpath selected bean amount is: \(beansExchangeRate[indexPath.row].beans)")
        print("The indexpath selected diamond amount is: \(beansExchangeRate[indexPath.row].diamond)")
        print("The indexpath selected id is: \(beansExchangeRate[indexPath.row].id)")
        
        if (indexPath.section == 0) {
            print("Koi pop up nahi kholna hai.")
            
        } else {
            
            if (myBalance >= (beansExchangeRate[indexPath.row].beans ?? 0)) {
                indexSelected = indexPath.row
                addTapGesture()
                setupDataInBottomView(index: indexPath.row)
                tblView.isUserInteractionEnabled = false
                viewBottom.isHidden = false
            } else {
                showAlert(title: "ERROR!", message: "You don't have sufficient beans to convert into diamonds.", viewController: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 280
        } else {
            return 60
        }
       
    }

// MARK: - DELEGATE FUNCTION TO  OPEN THE INCOME REPORT PAGE OF THE USER ON CLICK OF RECORD BUTTON ON BALANCE DETAILS TABLE VIEW CELL
    
    func buttonViewRecordPressed(isPressed: Bool) {
        print(isPressed)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IncomeReportViewController") as! IncomeReportViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}

// MARK: - EXTENSION FOR API CALLING

extension MyEarningViewController {
   
    func getBeansRate() {
        
        ApiWrapper.sharedManager().getBeansPriceList(url: AllUrls.getUrl.getexchangeBeansRateList) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            beansExchangeRate = data ?? beansExchangeRate
            print(beansExchangeRate)
          
            tblView.reloadData()
            
        }
    }
    
    func exchangeBeans(id:Int , beans:Int , diamonds:Int) {
        
        let params = [
            "exchangebean_id": id,
            "beans": beans,
            "diamond": diamonds
           
        ] as [String : Any]
        
        print("The params we are sending for fcm token is: \(params)")
        
        ApiWrapper.sharedManager().exchangeBeansWithDiamonds(url: AllUrls.getUrl.exchangeBeansWithDiamond,parameters: params ,completion: { [weak self] (data) in
            guard let self = self else {
                // The object has been deallocated
               
                return
            }
                print(data)
                
            if (data["success"] as? Bool == true) {
                
                print("Api se response true aaya hai. matlab data aaya hai.")
               
                let a = data["result"] as? [String: Any]
                print(a)
                
                if let balance = a?["earning_redeem_point"] as? Int {
                    
                    print("The balance is: \(balance)")
                    myBalance = balance
                }
                
                btnExchangeBeansOutlet.setTitle("Get", for: .normal)
                btnExchangeBeansOutlet.isUserInteractionEnabled = true
                isBeansExchanged = true
                
                viewBeansInformation.isHidden = true
                viewGemsInformation.isHidden = true
                imgViewExchangeImage.isHidden = true
                viewDiamondAmountRecieved.isHidden = false
               // lblDiamondAmountRecieved.text = String(myBalance)
                
            } else {
                
                print("Api se response mai false aaya hai. matlab kuch gadbad hai.")
                btnExchangeBeansOutlet.isUserInteractionEnabled = true
                
            }
                
            btnExchangeBeansOutlet.isUserInteractionEnabled = true
            
        })
    }
    
}
 
