//
//  SearchViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 23/04/24.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var btnCancelOutlet: UIButton!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var tblView: UITableView!
   
    lazy var lastPageNo: Int = 1
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
    lazy var pageNo:Int = 1
    lazy var searchData = searchResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
       hideKeyboardWhenTappedAround()
       tableViewWork()
        
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        
        print("Button Cancel Pressed.")
        navigationController?.popViewController(animated: true)
        
    }
    
    func configureUI() {
    
        tblView.isHidden = true
        viewSearch.layer.cornerRadius = viewSearch.frame.height / 2
        viewSearch.backgroundColor = GlobalClass.sharedInstance.setViewBackgroundColour()
        tabBarController?.tabBar.isHidden = true
        txtFldSearch.delegate = self
        
    }
    
    func tableViewWork() {
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "SearchUserTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchUserTableViewCell")
        
    }
    
    deinit {
        
        print("Search wale page par deinit call hua hai.")
        searchData.data?.removeAll()
        if let tblView = tblView {
               tblView.delegate = nil
               tblView.dataSource = nil
           }
        tblView = nil
        
    }
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS AND THEIR WORKING

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return searchData.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTableViewCell", for: indexPath) as! SearchUserTableViewCell
        
            cell.lblUserName.text = searchData.data?[indexPath.row].name
            cell.lblID.text =  "ID:" + " " + String(searchData.data?[indexPath.row].profileID ?? 0)
            loadImage(from: searchData.data?[indexPath.row].profileImages?.first?.imageName, into: cell.imgViewUser)
        
        if let yearDifference = calculateYearDifferenceForSearchList(from: searchData.data?[indexPath.row].dob ?? "") {
            print("Year difference: \(yearDifference)")
            cell.lblUserAge.text = String(yearDifference)
        } else {
            cell.lblUserAge.text = "0"
            print("Invalid date format")
        }
        
            if (searchData.data?[indexPath.row].gender?.lowercased() == "male") {
            
                cell.lblUserLevel.text = String(searchData.data?[indexPath.row].richLevel ?? 0)
                
                let level = searchData.data?[indexPath.row].richLevel ?? 0
                
                if (level == 0) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv0")
                } else if (level >= 1 && level <= 5) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv1-5")
                } else if (level >= 6 && level <= 10) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv6-10")
                } else if (level >= 11 && level <= 15) {
                    cell.imgViewLevelBackground.image =  UIImage(named: "reach_Lv11-15")
                } else if (level >= 16 && level <= 20) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv16-20")
                } else if (level >= 21 && level <= 25) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv21-25")
                } else if (level >= 26 && level <= 30) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv26-30")
                } else if (level >= 31 && level <= 35) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv31-35")
                } else if (level >= 36 && level <= 40) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv36-40")
                } else if (level >= 41 && level <= 45) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv41-45")
                } else if (level >= 46 ) {
                    cell.imgViewLevelBackground.image = UIImage(named: "reach_Lv45-50")
                }
                
            } else {
                
                cell.lblUserLevel.text = String(searchData.data?[indexPath.row].charmLevel ?? 0)
               
                let level = searchData.data?[indexPath.row].charmLevel ?? 0
                
                if (level == 0) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv0")
                } else if (level >= 1 && level <= 5) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv1-5")
                } else if (level >= 6 && level <= 10) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv6-10")
                } else if (level >= 11 && level <= 15) {
                    cell.imgViewLevelBackground.image =  UIImage(named: "charm_Lv11-15")
                } else if (level >= 16 && level <= 20) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv16-20")
                } else if (level >= 21 && level <= 25) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv21-25")
                } else if (level >= 26 && level <= 30) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv26-30")
                } else if (level >= 31 && level <= 35) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv31-35")
                } else if (level >= 36 && level <= 40) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv36-40")
                } else if (level >= 41 && level <= 45) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv41-45")
                } else if (level >= 46 ) {
                    cell.imgViewLevelBackground.image = UIImage(named: "charm_Lv46-50")
                }
                
            }
            
            cell.selectionStyle = .none
            return cell
        
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        print("The selected index in the search table view cell is: \(indexPath.row)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController

        nextViewController.userID = String(searchData.data?[indexPath.row].profileID ?? 0)
        nextViewController.callForProfileId = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            pageNo += 1
            print(pageNo)
            
            if (pageNo <= lastPageNo) {
                isDataLoading = true
                print("Ab Call Krana Hai")
                getSearchData()
              
            } else {
                print("Ye last page hai ... isliye api call nahi krani hai")
                
            }
        }
    }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM THE SERVER

extension SearchViewController {
    
    func getSearchData() {
        
        let text = txtFldSearch.text ?? ""
        
        let url = "https://zeep.live/api/getSearchWiseUserList?q=\(text)&page=\(pageNo)&per_page_records="
        print("The url we are sending in the search api is: \(url)")
        
        ApiWrapper.sharedManager().getSearchList(url:url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            if (value["success"] as? Bool == true) {
                
                if let result = value["result"] as? [String: Any] {
                    let lastPage = result["last_page"] as? Int
                    print("Last page: \(lastPage)")
                    lastPageNo = lastPage ?? 1
                    print(lastPageNo)
                } else {
                    print("Failed to retrieve the last page.")
                }
                
                if searchData.data == nil {
                    searchData.data = data?.data
                    
                } else {
                    searchData.data?.append(contentsOf: data?.data ?? [])
                    
                }
                
                print("The search data count is: \(searchData.data?.count)")
                
                if (searchData.data?.count == 0) {
                    tblView.isHidden = true
                    viewPlaceholder.isHidden = false
                } else {
                    tblView.isHidden = false
                    viewPlaceholder.isHidden = true
                }
                
                tblView.reloadData()
                
            } else {
                
                print("Image wale data main success false aa rha hai")
                
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {

    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        DispatchQueue.main.asyncDeduped(target: self, after: 0.70) { [weak self] in
//            
//            if (self?.txtFldSearch.text == "") || (self?.txtFldSearch.text == nil) {
//                print("Api ko call nahi krana hai.")
//                self?.tblView.isHidden = true
//                self?.viewPlaceholder.isHidden = false
//                self?.searchData.data?.removeAll()
//                self?.pageNo = 1
//            } else {
//                print("Api ko call krana hai.")
//                self?.getSearchData()
//                
//            }
//        }
//        return true
//        
//    }
    
    // This method is called when the "Return" or "Done" button is pressed
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           // Hide the keyboard
           textField.resignFirstResponder()
           
           // Perform any action when "Return" or "Done" is pressed
           print("Return or Done button pressed")
           
           if (txtFldSearch.text == "") || (txtFldSearch.text == nil) {
                       print("Api ko call nahi krana hai.")
                       tblView.isHidden = true
                       viewPlaceholder.isHidden = false
                       searchData.data?.removeAll()
                       pageNo = 1
                   } else {
                       print("Api ko call krana hai.")
                       pageNo = 1
                       getSearchData()
       
                   }
               
           return true
       }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField.returnKeyType == .done {
//            textField.resignFirstResponder() // Hide the keyboard
//            // Your custom code when "Done" key is pressed
//            print("Done ki button press huyi hai keyboard main.")
//            if (txtFldSearch.text == "") || (txtFldSearch.text == nil) {
//                print("Api ko call nahi krana hai.")
//                tblView.isHidden = true
//                viewPlaceholder.isHidden = false
//                searchData.data?.removeAll()
//                pageNo = 1
//            } else {
//                print("Api ko call krana hai.")
//                pageNo = 1
//                getSearchData()
//                
//            }
//            
//        }
//        return true
//    }
    
}
