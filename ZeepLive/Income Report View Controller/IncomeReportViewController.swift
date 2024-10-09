//
//  IncomeReportViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/05/23.
//

import UIKit
import DropDown
import Kingfisher

class IncomeReportViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    @IBOutlet weak var viewUserDetails: UIView!
    @IBOutlet weak var imgViewBackground: UIImageView!
   
    @IBOutlet weak var viewDateSelectionOutlet: UIControl!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgViewDropDown: UIImageView!
    
  
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    
    @IBOutlet weak var lblNoOfBeans: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var viewIncomeDetails: UIView!
    @IBOutlet weak var viewCallIncome: UIView!
    @IBOutlet weak var viewGiftIncome: UIView!
    @IBOutlet weak var viewBonusIncome: UIView!
    
    @IBOutlet weak var lblCallIncome: UILabel!
    @IBOutlet weak var lblGiftIncome: UILabel!
    @IBOutlet weak var lblBonusIncome: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    
    lazy var dropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDown
        ]
    }()
    
    lazy var arrDropdownDates = [String]()
   
    lazy var userIncomeReport = femaleIncomeReportResult()
    lazy var isDatetaken:Bool = false
    
    lazy var selectedDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "IncomeReportTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeReportTableViewCell")
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
        
        customizeDropDown()
        getUserIncomeReport()
        customizeUI()
    }
    
    private func customizeUI() {
    
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.width / 2
        imgViewUserPhoto.clipsToBounds = true
        viewIncomeDetails.backgroundColor = GlobalClass.sharedInstance.setViewAmountDetailsBackgroundColour()
        viewIncomeDetails.layer.cornerRadius = 20
        viewDateSelectionOutlet.layer.cornerRadius = 15
        viewDateSelectionOutlet.backgroundColor = GlobalClass.sharedInstance.setViewAmountDetailsBackgroundColour()
        
        if (UserDefaults.standard.string(forKey: "profilePicture") == "") || (UserDefaults.standard.string(forKey: "profilePicture") == nil) {
            
            print("Koi image nahi hai")
            
        } else {
        
            if let profileImageURL = URL(string: UserDefaults.standard.string(forKey: "profilePicture") ?? "") {
                KF.url(profileImageURL)
                  //  .downsampling(size: CGSize(width: 200, height: 200))
                    .cacheOriginalImage()
                    .onSuccess { result in
                        DispatchQueue.main.async {
                            self.imgViewUserPhoto.image = result.image
                        }
                    }
                    .onFailure { error in
                        print("Image loading failed with error: \(error)")
                        self.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                    }
                    .set(to: imgViewUserPhoto)
            } else {
                imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
            
//           if let profilePictureURLString = UserDefaults.standard.string(forKey: "profilePicture"),
//                   let imageURL = URL(string: profilePictureURLString) {
//                    downloadImage(from: imageURL, into: imgViewUserPhoto)
//                } else {
//                    
//                    imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//                }
        }
        
        let name = UserDefaults.standard.string(forKey: "UserName")
        let id = UserDefaults.standard.string(forKey: "UserProfileId")
        
        lblUserName.text = name
        lblUserId.text = id
        
    }
    
// MARK: - FUNCTION FOR THE CUSTOMIZATION OF DROPDOWN VIEW
    
    private func customizeDropDown() {
            let appearance = DropDown.appearance()
            appearance.cellHeight = 30
            appearance.backgroundColor = GlobalClass.sharedInstance.setViewAmountDetailsBackgroundColour()
            appearance.cornerRadius = 10
            appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
            appearance.shadowOpacity = 0.9
            appearance.shadowRadius = 25
            appearance.animationduration = 0.2
            appearance.textColor = .white
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                appearance.textFont = .systemFont(ofSize: 12)
            default:
                appearance.textFont = .systemFont(ofSize: 17)
            }
            if #available(iOS 11.0, *) {
                appearance.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
            }
            
            dropDown = DropDown()
            dropDown.dismissMode = .onTap
            dropDown.direction = .bottom
        }
    
// MARK: - BUTTON AND VIEW ACTIONS
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        
        dropDowns.forEach { $0.hide() }
        dropDowns.removeAll()
        
        self.navigationController?.popViewController(animated: true)
        
    }

    // MARK: - VIEW DATE SELECTED ACTION AND DROPDOWN SHOWING AND SELECTING DATE
    
    @IBAction func viewDateSelectionPressed(_ sender: Any) {
        print("View Select Date Pressed")
        
        dropDown.anchorView = viewDateSelectionOutlet
        dropDown.dataSource = arrDropdownDates
        dropDown.bottomOffset = CGPoint(x: 10, y: viewDateSelectionOutlet!.bounds.height)
        
        dropDown.show()
        
        dropDown.selectionAction = { [weak self] (index, item) in
                   print(index)
                   print(item)
                   self?.lblDate.text = item
                 self?.callSelectedDateData(index: index)
               }
    }
    
    deinit {
          
           arrDropdownDates.removeAll()
           dropDown.dataSource = []
           dropDown.selectionAction = nil
        
       }
    
    private func callSelectedDateData(index:Int = 0) {
        
        print(userIncomeReport.weeks?[index].updatedAt)
        selectedDate = userIncomeReport.weeks?[index].updatedAt ?? ""
        getUserIncomeReport()
        
      //  lblDate.text = selectedDate
        lblCallIncome.text = userIncomeReport.weeks?[index].totalCallCoins ?? "0"
        lblGiftIncome.text = userIncomeReport.weeks?[index].totalGiftCoins ?? "0"
        lblBonusIncome.text = userIncomeReport.weeks?[index].totalRewardCoins ?? "0"
        lblNoOfBeans.text = userIncomeReport.weeks?[index].totalCoins ?? "0"
        lblTotalAmount.text = "$ \(userIncomeReport.weeks?[index].payoutDollar ?? "0") / \(userIncomeReport.weeks?[index].totalPayout ?? "0") INR"
        
    }
    
    private func getDateRange() {
    
        for i in 0..<(userIncomeReport.weeks?.count ?? 0) {
            
            print(userIncomeReport.weeks?[i].settlementCycle)
            if let convertedDateRange = convertDateRange(dateRange: userIncomeReport.weeks?[i].settlementCycle ?? " ") {
                print(convertedDateRange) // Output: 19.June - 25.June
                arrDropdownDates.append(convertedDateRange)
                
            } else {
                print("Invalid date range")
            }
        }
        lblDate.text = arrDropdownDates[0]
        lblCallIncome.text = userIncomeReport.weeks?[0].totalCallCoins ?? "0"
        lblGiftIncome.text = userIncomeReport.weeks?[0].totalGiftCoins ?? "0"
        lblBonusIncome.text = userIncomeReport.weeks?[0].totalRewardCoins ?? "0"
        lblNoOfBeans.text = userIncomeReport.weeks?[0].totalCoins ?? "0"
        lblTotalAmount.text = "$ \(userIncomeReport.weeks?[0].payoutDollar ?? "0") / \(userIncomeReport.weeks?[0].totalPayout ?? "0") INR"
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS AND SETTING DATA IN THE TABLE VIEW CELL
    
extension IncomeReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIncomeReport.footerData?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeReportTableViewCell", for: indexPath) as! IncomeReportTableViewCell
            
            cell.lblDate.text = userIncomeReport.footerData?[indexPath.row].date
            cell.lblTotalIncome.text = userIncomeReport.footerData?[indexPath.row].totalCoins
            cell.lblCallIncome.text = userIncomeReport.footerData?[indexPath.row].totalCallCoins
            cell.lblGiftIncome.text = userIncomeReport.footerData?[indexPath.row].totalGiftCoins
            cell.lblBonus.text = userIncomeReport.footerData?[indexPath.row].totalRewardCoins
        
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(userIncomeReport.footerData?[indexPath.row].date)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IncomeDetailsViewController") as! IncomeDetailsViewController
        nextViewController.date = userIncomeReport.footerData?[indexPath.row].date ?? " "
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM SERVER

extension IncomeReportViewController {
   
    func getUserIncomeReport() {
        
        let url = AllUrls.baseUrl + "femaleincomereportList?month=\(selectedDate)"
        print(url)
        
        ApiWrapper.sharedManager().getUserIncomeReportDetails(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
        
            userIncomeReport = data ?? userIncomeReport
            print(userIncomeReport)
            print(userIncomeReport.footerData?.count)
            
            if (userIncomeReport.footerData?.count == 0) || (userIncomeReport.footerData == nil) {
               
                print("footer mai kuch bhi nahi hai")
                
            } else {
                if (isDatetaken == false) {
                    getDateRange()
                    isDatetaken = true
                } else {
                    print("date vala kaam nahi krana hai bhai ismain.. nikal lo")
                }
                print("Footer mai value hai ")
                tblView.reloadData()
                
            }
        }
    }
    
}
