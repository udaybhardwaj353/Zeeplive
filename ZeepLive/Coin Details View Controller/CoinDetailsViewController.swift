//
//  CoinDetailsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/05/23.
//

import UIKit
import DropDown

class CoinDetailsViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewFilterOptions: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var txtFldFrom: UITextField!
    @IBOutlet weak var txtFldTo: UITextField!
    @IBOutlet weak var txtFldAll: UITextField!
    
    lazy var walletHistory = walletHistoryResult()
    lazy var lastPageNo = Int()
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
    lazy var pageNo: Int = 1
    
    lazy var datePicker = UIDatePicker()
    lazy var selectedDate = String()
    
    lazy var datePickerFrom = UIDatePicker()
    lazy var dateFrom: String = ""
    lazy var dateTo: String = ""
    
    lazy var dropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDown
        ]
    }()
    
    lazy var arrDropdownOptions = [String]()
    lazy var listOptionSelected: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrDropdownOptions = ["All" , "TopUp"]
    
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "CoinsDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinsDetailsTableViewCell")
      
        getWalletHistory()
        datePickerFromView()
        datePickerToView()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
        
        customizeDropDown()
        
        setupDropDown()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped))
              txtFldAll.addGestureRecognizer(tapGesture)
    }
    
    @objc func textFieldTapped() {
            dropDown.show()
        }
    
    func setupDropDown() {
           dropDown.anchorView = txtFldAll
           dropDown.dataSource = ["All", "Topup"]

           dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               txtFldAll.text = item
               print(index)
               if (index == 1) {
                   
                   walletHistory.walletHistory?.removeAll()
                   pageNo = 1
                   getWalletTopupHistory()
                   listOptionSelected = "topup"
               } else {
                   walletHistory.walletHistory?.removeAll()
                   pageNo = 1
                   txtFldFrom.text = ""
                   txtFldTo.text = ""
                   dateFrom = ""
                   dateTo = ""
                   getWalletHistory()
                   listOptionSelected = "all"
               }
               // Handle the selected option if needed
           }
       }
    
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func viewFromPressed(_ sender: Any) {
        
        print("View From Pressed")
        
    }
    
    @IBAction func viewToPressed(_ sender: Any) {
        
        print("View To Pressed")
        
    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
        
        print("View All Pressed")
        
    }
    
    private func customizeDropDown() {
        let appearance = DropDown.appearance()
        appearance.cellHeight = 40
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = #colorLiteral(red: 0.2523537278, green: 0.7503452897, blue: 0.9989678264, alpha: 0.3048821075)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.2
        appearance.textColor = .black
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
    
}

extension CoinDetailsViewController {
    
    func datePickerFromView() {
    
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue//UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        datePickerFrom.datePickerMode = .date
        datePickerFrom.maximumDate = Date()
        datePickerFrom.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePickerFrom.frame.size = CGSize(width: 0, height: 300)
        if #available(iOS 13.4, *) {
            datePickerFrom.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        txtFldFrom.inputView = datePickerFrom
        txtFldFrom.inputAccessoryView = toolBar
        
    }
    
    @objc func donePicker() {

        txtFldFrom.resignFirstResponder()
        txtFldFrom.text = formatDate(date: datePickerFrom.date)
        dateFrom = txtFldFrom.text ?? ""
        print(dateFrom)
        
        if (dateTo == "") {
            
            print("Donon tareekh nahi hai")
            
        } else {
           
            let result = compareDates(date1: datePickerFrom.date, date2: datePicker.date)
                
                if result == .orderedAscending {
                    print("date1 is earlier than date2")
                    txtFldAll.text = "All"
                    listOptionSelected = "All"
                    walletHistory.walletHistory?.removeAll()
                    pageNo = 1
                    getWalletHistory()
                    
                } else if result == .orderedDescending {
                   
                    print("date1 is later than date2")
                    showAlert(title: "Alert", message: "To Date should be less than From Date", viewController: self)
                } else {
                    print("date1 is equal to date2")
                    txtFldAll.text = "All"
                    listOptionSelected = "All"
                    walletHistory.walletHistory?.removeAll()
                    pageNo = 1
                    getWalletHistory()
                    
                }
        }
    }
    
    @objc func dateChange(datePicker:UIDatePicker) {
        txtFldFrom.text = formatDate(date: datePicker.date)
        dateFrom = txtFldFrom.text ?? ""
        print(dateFrom)
        if (dateTo == "") {
            
            print("Donon tareekh nahi hai")
            
        } else {
            
            let result = compareDates(date1: datePickerFrom.date, date2: datePicker.date)
                
                if result == .orderedAscending {
                    txtFldFrom.resignFirstResponder()
                    print("date1 is earlier than date2")
                    txtFldAll.text = "All"
                    listOptionSelected = "All"
                    
                    walletHistory.walletHistory?.removeAll()
                    pageNo = 1
                    getWalletHistory()
                    
                } else if result == .orderedDescending {
                    print("date1 is later than date2")
                    showAlert(title: "Alert", message: "To Date should be less than From Date", viewController: self)
                    
                } else {
                    txtFldFrom.resignFirstResponder()
                    print("date1 is equal to date2")
                    txtFldAll.text = "All"
                    listOptionSelected = "All"
                    walletHistory.walletHistory?.removeAll()
                    pageNo = 1
                    getWalletHistory()
                }
        }
    }
    
    func formatDate(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }

// MARK: - FUNCTION FOR PICKER VIEW TO SELECT THE TO DATE
    
    func datePickerToView() {

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneToPicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
       
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChangeTo(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        txtFldTo.inputView = datePicker
        txtFldTo.inputAccessoryView = toolBar
        
    }

// MARK: - FUNCTION TO CLICK ON DONE BUTTON ON SELECTING DATE FROM TO FIELD
    
    @objc func doneToPicker() {

        txtFldTo.resignFirstResponder()
        dateTo = formatDate(date: datePicker.date)
        txtFldTo.text = " " + " " + " " + formatDate(date: datePicker.date)
     //   dateTo = txtFldTo.text ?? ""
        print(dateTo)
        
        if (dateFrom == "" ) {
            
            print("Donon tareekh nahi hai")
            
        } else {

            let result = compareDates(date1: datePickerFrom.date, date2: datePicker.date)
                
                if result == .orderedAscending {
                    txtFldTo.resignFirstResponder()
                    print("date1 is earlier than date2")
                    txtFldAll.text = "All"
                    listOptionSelected = "All"
                    walletHistory.walletHistory?.removeAll()
                    pageNo = 1
                    getWalletHistory()
                    
                } else if result == .orderedDescending {
                    print("date1 is later than date2")
                    showAlert(title: "Alert", message: "To Date should be less than From Date", viewController: self)
                    
                } else {
                    print("date1 is equal to date2")
                    txtFldAll.text = "All"
                    listOptionSelected = "All"
                    txtFldTo.resignFirstResponder()
                    walletHistory.walletHistory?.removeAll()
                    pageNo = 1
                    getWalletHistory()
                }
        }

    }
    
    @objc func dateChangeTo(datePicker:UIDatePicker) {
        dateTo = formatDate(date: datePicker.date)
        txtFldTo.text = " " + " " + " " + formatDate(date: datePicker.date)
       // dateTo = txtFldTo.text ?? ""
        print(dateTo)
        if (dateFrom == "" ) {
            
            print("Donon tareekh nahi hai")
            
        } else {
            
            let result = compareDates(date1: datePickerFrom.date, date2: datePicker.date)
                
                if result == .orderedAscending {
                    txtFldTo.resignFirstResponder()
                    print("date1 is earlier than date2")
                    print("date choti hai api call hogi")
                    txtFldAll.text = "All"
                    listOptionSelected = "All"
                    walletHistory.walletHistory?.removeAll()
                    pageNo = 1
                    getWalletHistory()
                    
                } else if result == .orderedDescending {
                    print("date1 is later than date2")
                    showAlert(title: "Alert", message: "To Date should be less than From Date", viewController: self)
                    
                } else {
                    print("date1 is equal to date2")
                    txtFldTo.resignFirstResponder()
                    txtFldAll.text = "All"
                    listOptionSelected = "All"
                    walletHistory.walletHistory?.removeAll()
                    pageNo = 1
                    getWalletHistory()
                }
        }
    }
}
// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS TO SHOW DATA TO THE USER

extension CoinDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletHistory.walletHistory?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoinsDetailsTableViewCell", for: indexPath) as! CoinsDetailsTableViewCell
            
            cell.lblCoinDetail.text = walletHistory.walletHistory?[indexPath.row].transactionDES
            cell.lblDateAndTime.text = walletHistory.walletHistory?[indexPath.row].createdAt
        
        if (walletHistory.walletHistory?[indexPath.row].credit ?? 0 <= 0) {
        
            cell.lblAmount.text = "-" + " " + String(walletHistory.walletHistory?[indexPath.row].debit ?? 0)
            
        } else {
            
            cell.lblAmount.text = "+" + " " + String(walletHistory.walletHistory?[indexPath.row].credit ?? 0)
            
        }
        
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM SERVER

extension CoinDetailsViewController {
    
    func getWalletHistory() {
        
        let url =  "https://zeep.live/api/wallet-history-latest-new?start_date=\(dateFrom)&end_date=\(dateTo)&page=\(pageNo)"
        print(url)
        
        ApiWrapper.sharedManager().getWalletHistoryList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
        
            lastPageNo = data?.lastPage ?? 0
            print("The lasst page is: \(lastPageNo)")
            print(lastPageNo)
            
            if let walletData = data {
                print(walletData)
                
                if let walletHistoryData = walletData.walletHistory {
                    if walletHistory.walletHistory == nil {
                       walletHistory.walletHistory = walletHistoryData
                        
                       } else {
                          walletHistory.walletHistory?.append(contentsOf: walletHistoryData)
                           
                       }
                       
                       tblView.reloadData()
                   }
            }
        }
    }
    
    func getWalletTopupHistory() {
        
        let url =  "https://zeep.live/api/wallet-history-latest-new?type=topup&page=\(pageNo)"
        print(url)
        
        ApiWrapper.sharedManager().getWalletHistoryList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
        
            lastPageNo = data?.lastPage ?? 0
            print("The lasst page is: \(lastPageNo)")
            print(lastPageNo)
            
            if let walletData = data {
                print(walletData)
                
                if let walletHistoryData = walletData.walletHistory {
                    if walletHistory.walletHistory == nil {
                       walletHistory.walletHistory = walletHistoryData
                        
                       } else {
                          walletHistory.walletHistory?.append(contentsOf: walletHistoryData)
                           
                       }
                       
                       tblView.reloadData()
                   }
            }
        }
    }
}

// MARK: - EXTENSION FOR USING SCROLL VIEW TO CALL TO KNOW ABOUT THE SCROLLING

extension CoinDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

            print("scrollViewWillBeginDragging")
            isDataLoading = false
        }
    
    
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

                print("scrollViewDidEndDragging")
            
}

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scroll view decelerate ho rha hai")
        
        if ((tblView.contentOffset.y + tblView.frame.size.height + 100) >= tblView.contentSize.height)
            
        {

               if !isDataLoading{
                   if didEndReached == true {
                       print("data load ni krana hai")
                   } else {
                       pageNo += 1
                       print("THe page number is ;\(pageNo)")
                       print(pageNo)
                       
                       if (pageNo <= lastPageNo) {
                           isDataLoading = true
                           print("Ab Call Krana Hai")
                           if (listOptionSelected == "topup") {
                               getWalletTopupHistory()
                           } else {
                               getWalletHistory()
                           }
                       } else {
                           print("Ye last page hai ... isliye api call nahi krani hai")
                          
                       }
                   }
               }
        }
    }
}
