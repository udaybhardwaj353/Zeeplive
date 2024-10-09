//
//  ExchangeViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 15/03/24.
//

import UIKit

protocol delegateExchangeViewController:AnyObject {

    func balanceAfterExchange(balance:Int)
    
}

class ExchangeViewController: UIViewController {

    @IBOutlet weak var viewBeansDetails: UIView!
    @IBOutlet weak var lblNoOfBeans: UILabel!
    @IBOutlet weak var lblNoOfDiamonds: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnCloseBottomViewOutlet: UIButton!
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
    @IBOutlet weak var btnExchangeNowOutlet: UIButton!
    
    lazy var myBalance: Int = 0
    lazy var beansExchangeRate = [getBeansExchangeList]()
    var tapGesture: UITapGestureRecognizer!
    lazy var isBeansExchanged: Bool = false
    lazy var indexSelected: Int = 0
    weak var delegate: delegateExchangeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        configureUI()
       getBeansRate()
        print(myBalance)
        
    }
    
    @IBAction func btnCloseBottomViewPressed(_ sender: Any) {
        
        print("Button Close Bottom View Pressed.")
        viewBottom.isHidden = true
        viewBeansInformation.isHidden = false
        viewGemsInformation.isHidden = false
        imgViewExchangeImage.isHidden = false
        viewDiamondAmountRecieved.isHidden = true
        removeTapGesture()
        tblView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func btnExchangeNowPressed(_ sender: Any) {
        
        print("Button Exchange Now Pressed.")
      
        btnExchangeNowOutlet.isUserInteractionEnabled = false
        print("Button Exchange Beans Pressed")
        
        if (isBeansExchanged == true) {
            viewBottom.isHidden = true
            removeTapGesture()
            tblView.isUserInteractionEnabled = true
            tblView.reloadData()
            
        } else {
            print("Beans abhi exchange nahi hue hai.")
            exchangeBeans(id: (beansExchangeRate[indexSelected].id ?? 0), beans: (beansExchangeRate[indexSelected].beans ?? 0), diamonds: (beansExchangeRate[indexSelected].diamond ?? 0))
            
          //  btnExchangeBeansOutlet.setTitle("Exchange Now", for: .normal)
        }
        
    }
    
    func setupTableView() {
          tblView.delegate = self
          tblView.dataSource = self
          tblView.register(UINib(nibName: "BeansDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "BeansDetailsTableViewCell")
      }
    
    func configureUI() {
    
        viewLine.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        
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
        
        btnExchangeNowOutlet.layer.cornerRadius = 10
        btnExchangeNowOutlet.backgroundColor = GlobalClass.sharedInstance.buttonBeansExchangeColour()
        
        lblBeansAmount.textColor = GlobalClass.sharedInstance.setBeansExchangeTextColour()
        lblGemsAmount.textColor = GlobalClass.sharedInstance.setBeansExchangeTextColour()
        
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
    
}

extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return beansExchangeRate.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BeansDetailsTableViewCell", for: indexPath) as! BeansDetailsTableViewCell
            
            cell.lblDiamond.text = String(beansExchangeRate[indexPath.row].diamond ?? 0)
            cell.lblBeans.text = String(beansExchangeRate[indexPath.row].beans ?? 0)
            
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        print("Here my balance is: \(myBalance)")
        print("Here the beans exchange rate is: \(beansExchangeRate[indexPath.row].beans ?? 0)")
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
            return 60
        
    }
    
}

extension ExchangeViewController {
   
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
                    delegate?.balanceAfterExchange(balance: myBalance)
                    
                }
                
                btnExchangeNowOutlet.setTitle("Get", for: .normal)
                btnExchangeNowOutlet.isUserInteractionEnabled = true
                isBeansExchanged = true
                
                viewBeansInformation.isHidden = true
                viewGemsInformation.isHidden = true
                imgViewExchangeImage.isHidden = true
                viewDiamondAmountRecieved.isHidden = false
                lblDiamondAmountRecieved.text = String(diamonds)
                
            } else {
                
                print("Api se response mai false aaya hai. matlab kuch gadbad hai.")
                btnExchangeNowOutlet.isUserInteractionEnabled = true
                
            }
                
            btnExchangeNowOutlet.isUserInteractionEnabled = true
            
        })
    }
    
}
 
