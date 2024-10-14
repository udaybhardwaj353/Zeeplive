//
//  ShowCountryListViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 30/08/23.
//

import UIKit

protocol delegateShowCountryListViewController: AnyObject {

    func selectedCountryDetails(countrycode: String, countryname: String, countryimage:String, countryid:Int)
    
}

class ShowCountryListViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var countryList = getCountryListResult()
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
    lazy var pageNo: Int = 1
    
    weak var delegate: delegateShowCountryListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCountriesList()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "ShowCountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowCountryListTableViewCell")
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ShowCountryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCountryListTableViewCell", for: indexPath) as! ShowCountryListTableViewCell
        
        cell.lblCountryName.text = countryList.data?[indexPath.row].countryName
        cell.lblCountryCode.text = countryList.data?[indexPath.row].countryCode
        
        if let imageName = countryList.data?[indexPath.row].flag,
                    let imageURL = URL(string: imageName) {
                    downloadImage(from: imageURL, into: cell.imgView)
            
        } else {
       
                    cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
       
                }
        
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
      
        delegate?.selectedCountryDetails(countrycode: countryList.data?[indexPath.row].countryCode ?? "",countryname: countryList.data?[indexPath.row].countryName ?? "", countryimage: countryList.data?[indexPath.row].flag ?? "", countryid: (countryList.data?[indexPath.row].id ?? 0))
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension ShowCountryListViewController {
    
    func getCountriesList() {
           
        let url = AllUrls.baseUrl + "countryListnew?page=\(pageNo)"
        
        ApiWrapper.sharedManager().getCountryNameList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            if let countriesList = data?.data {
                       print(countriesList)
                       
                       if countryList.data == nil {
                           countryList.data = countriesList
            
                       } else {
                           countryList.data?.append(contentsOf: countriesList)
                          
                       }
        
                
                           print(countryList.data?.count)
                       
                   }
            
            tblView.reloadData()
        }
    }
    
}

// MARK: - SCROLL VIEW DELEGATE FUNCTION TO CALL THE API WHEN THE USER SCROLLED DOWN IN THE LIST WHILE SCROLLING

extension ShowCountryListViewController: UIScrollViewDelegate {
    
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
                       
                           isDataLoading = true
                           print("Ab Call Krana Hai")
                          
                           getCountriesList()
                        
                       
                   }
               }
        }
    }
}
