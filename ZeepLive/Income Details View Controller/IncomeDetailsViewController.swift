//
//  IncomeDetailsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/05/23.
//

import UIKit

class IncomeDetailsViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var incomeDetails = femaleIncomeDetailsResult()
   
    lazy var date = String()
    lazy var pageNo: Int = 1
    lazy var lastPageNo = Int()
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "IncomeDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomeDetailsTableViewCell")
      
        print(date)
        
        getUserIncomeDetailsReport()
        
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND IT'S FUNCTIONS FOR SHOWING DATA IN TABLE VIEW CELL

extension IncomeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeDetails.walletHistory?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeDetailsTableViewCell", for: indexPath) as! IncomeDetailsTableViewCell
            
//        lazy var a = "\(incomeDetails.walletHistory?[indexPath.row].updatedAt ?? "") \(incomeDetails.walletHistory?[indexPath.row].callerUsername ?? "") [ID:\(incomeDetails.walletHistory?[indexPath.row].callerProfileID ?? 0)]"

        
        cell.lblAmount.text = "+" + " " + String(incomeDetails.walletHistory?[indexPath.row].credit ?? 0)
        cell.lblTime.text = incomeDetails.walletHistory?[indexPath.row].updatedAt
        cell.lblUserId.text = "\(incomeDetails.walletHistory?[indexPath.row].callerUsername ?? "") [ID:\(incomeDetails.walletHistory?[indexPath.row].callerProfileID ?? 0)]"
        
        
        if (incomeDetails.walletHistory?[indexPath.row].status == 4) {
            
                cell.lblIncomeType.text = "Call Income"
            
        } else if (incomeDetails.walletHistory?[indexPath.row].status == 45) {
            
            cell.lblIncomeType.text = "Bonus Income"
            
        } else {
            
            cell.lblIncomeType.text = "Gift Income"
            
        }
        
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM SERVER

extension IncomeDetailsViewController {
   
    func getUserIncomeDetailsReport() {
        
        let url = "https://zeep.live/api/femaleincomereportDetails1?month=\(date)&page=\(pageNo)"
        print(url)
        
        ApiWrapper.sharedManager().getIncomeReportDetails(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
        
            print(data)
            print(value)
            
            if let result = value["result"] as? [String: Any] {
                let lastPage = result["last_page"] as? Int
                print("Last page: \(lastPage)")
                lastPageNo = lastPage ?? 1
                print(lastPageNo)
            } else {
                print("Failed to retrieve the last page.")
            }
            
            if let userFriendList = data?.walletHistory {
                       print(userFriendList)
                       
                       if incomeDetails.walletHistory == nil {
                           incomeDetails.walletHistory = userFriendList
                           print(incomeDetails.walletHistory?.count)
                           
                       } else {
                           incomeDetails.walletHistory?.append(contentsOf: userFriendList)
                           print(incomeDetails.walletHistory?.count)
                           
                       }
                
                            tblView.reloadData()
                       
                   }
        }
    }
    
}

// MARK: - EXTENSION FOR USING SCROLL VIEW AND IT'S DELEGATE FUNCTIONS TO KNOW ABOUT THE SCROLLING

extension IncomeDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

            print("scrollViewWillBeginDragging")
            isDataLoading = false
        }
    
    
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

                print("scrollViewDidEndDragging")
            
}

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scroll view decelerate ho rha hai")
        
        if ((tblView.contentOffset.y + tblView.frame.size.height + 200) >= tblView.contentSize.height)
            
        {

               if !isDataLoading{
                   if didEndReached == true {
                       print("data load ni krana hai")
                   } else {
                       pageNo += 1
                       print(pageNo)
                       
                       if (pageNo <= lastPageNo) {
                           isDataLoading = true
                           print("Ab Call Krana Hai")
                           getUserIncomeDetailsReport()
                           //tblView.reloadData()
                       } else {
                           print("Ye last page hai ... isliye api call nahi krani hai")
                          
                       }
                   }
               }
        }
    }
}
