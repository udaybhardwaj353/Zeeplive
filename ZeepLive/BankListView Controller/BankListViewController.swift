//
//  BankListViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 20/03/24.
//

import UIKit

protocol delegateBankListViewController: AnyObject {
    
    func bankSelected(id: Int ,name: String)
    
}

class BankListViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    lazy var bankList = bankListResult()
    weak var delegate: delegateBankListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getBanksList()
        setupTableView()
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Button Back Pressed.")
        navigationController?.popViewController(animated: true)
        
    }
    
    func setupTableView() {
          tblView.delegate = self
          tblView.dataSource = self
          tblView.register(UINib(nibName: "BankNameListTableViewCell", bundle: nil), forCellReuseIdentifier: "BankNameListTableViewCell")
        
      }
    
}

extension BankListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return bankList.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "BankNameListTableViewCell", for: indexPath) as! BankNameListTableViewCell
            
            cell.lblBankName.text = bankList.data?[indexPath.row].bankName ?? "N/A"
        
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 60
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("The selected bank index path is: \(indexPath.row)")
        delegate?.bankSelected(id: (bankList.data?[indexPath.row].id ?? 0), name: (bankList.data?[indexPath.row].bankName ?? ""))
        navigationController?.popViewController(animated: true)
        
    }
}


extension BankListViewController {
    
    func getBanksList() {
           
        ApiWrapper.sharedManager().getBankList(url: AllUrls.getUrl.getBankList) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            bankList = data ?? bankList
            print("The bank list data is: \(bankList)")
            
            tblView.reloadData()
        }
    }
    
}
