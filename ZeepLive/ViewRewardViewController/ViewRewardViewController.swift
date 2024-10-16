//
//  ViewRewardViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/01/24.
//

import UIKit
import Kingfisher

class ViewRewardViewController: UIViewController, delegateViewRewardNewHeaderTableViewCell {
 
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btnDailyOutlet: UIButton!
    @IBOutlet weak var btnWeeklyOutlet: UIButton!
    @IBOutlet weak var viewDaily: UIView!
    @IBOutlet weak var viewWeekly: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var dailyWeeeklyList = [dailyWeeklyResult]()
    lazy var interval: String = "daily"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        registerTableView()
        getDailyWeeklyData()
       
    }
    
    func registerTableView() {
        
        tblView.delegate = self
        tblView.dataSource = self
//        tblView.register(UINib(nibName: "ViewRewardHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewRewardHeaderTableViewCell")
        tblView.register(UINib(nibName: "DailyListTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyListTableViewCell")
        tblView.register(UINib(nibName: "ViewRewardNewHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewRewardNewHeaderTableViewCell")
        
    }
    
    func configureUI() {
    
        viewWeekly.isHidden = true
        viewDaily.isHidden = false
        
        viewWeekly.layer.cornerRadius = viewWeekly.frame.height / 2
        viewWeekly.clipsToBounds = true
        viewDaily.layer.cornerRadius = viewDaily.frame.height / 2
        viewDaily.clipsToBounds = true
        
        viewDaily.backgroundColor = GlobalClass.sharedInstance.setSelectedPagerColour()
        viewWeekly.backgroundColor = GlobalClass.sharedInstance.setSelectedPagerColour()
        
        self.btnDailyOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.btnWeeklyOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.btnDailyOutlet.setTitleColor(.black, for: .normal)
        self.btnWeeklyOutlet.setTitleColor(.darkGray, for: .normal)
        
    }
    
    @IBAction func btnDailyPressed(_ sender: Any) {
        
        print("Daily List Button Pressed")
        interval = "daily"
        getDailyWeeklyData()
        
        UIView.animate(withDuration: 0.5) {
          
            self.viewWeekly.isHidden = true
            self.viewDaily.isHidden = false
        
            self.btnDailyOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            self.btnWeeklyOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.btnDailyOutlet.setTitleColor(.black, for: .normal)
            self.btnWeeklyOutlet.setTitleColor(.darkGray, for: .normal)
            
        }
        
    }
    
    @IBAction func btnWeeklyPressed(_ sender: Any) {
        
        print("Weekly List Button Pressed")
        interval = "weekly"
        getDailyWeeklyData()
        
        UIView.animate(withDuration: 0.5) {
          
            self.viewDaily.isHidden = true
            self.viewWeekly.isHidden = false
            
            self.btnWeeklyOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            self.btnDailyOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.btnWeeklyOutlet.setTitleColor(.black, for: .normal)
            self.btnDailyOutlet.setTitleColor(.darkGray, for: .normal)
            
        }
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS TO SHOW DATA IN TABLE VIEW CELL

extension ViewRewardViewController: UITableViewDelegate, UITableViewDataSource, delegateViewRewardHeaderTableViewCell {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Display the first 3 elements in section 0
            //return min(3, dailyWeeeklyList.count)
            return 1
        } else {
            // Display the rest of the elements in section 1
            return max(0, dailyWeeeklyList.count - 3)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewRewardNewHeaderTableViewCell", for: indexPath) as! ViewRewardNewHeaderTableViewCell

            let usersToShow = Array(dailyWeeeklyList.prefix(3))
            cell.configure(with: usersToShow, interval: interval)
            
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyListTableViewCell", for: indexPath) as! DailyListTableViewCell

            let item = dailyWeeeklyList[indexPath.row + 3] // Adjust index for section 1

            if let profileImageURL = URL(string: item.profileImages?[0].imageName ?? " ") {
                KF.url(profileImageURL)
                    .cacheOriginalImage()
                    .onSuccess { result in
                        DispatchQueue.main.async {
                            cell.imgViewUserPhoto.image = result.image
                        }
                    }
                    .onFailure { error in
                        print("Image loading failed with error: \(error)")
                        cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                    }
                    .set(to: cell.imgViewUserPhoto)
            } else {
                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
            }

            cell.lblCountNumber.text = String(indexPath.row + 4)
            cell.lblUserName.text = item.name ?? "No Name"
            cell.lblUserLevel.text = String(format: "Lv%i", item.charmLevel ?? 0)//String(item.charmLevel ?? 0)
            if (interval == "daily") {
                cell.lblTotalBeans.text = String(item.dailyEarningBeans ?? 0)
            } else {
                cell.lblTotalBeans.text = String(item.weeklyEarningBeans ?? 0)
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 215
        } else {
            return 60
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if indexPath.section == 0 {
            
               print("Selected row in section 0: \(indexPath.row)")
                
           } else {
           
               let selectedRowIndex = indexPath.row + 3
               print("Selected row in section 1: \(selectedRowIndex)")
               let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
               let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
               nextViewController.userID = String(dailyWeeeklyList[selectedRowIndex].id ?? 0)
               self.navigationController?.pushViewController(nextViewController, animated: true)
               
           }
    }
    
    func viewClicked(index: Int) {
        
        print("The index for first section is: \(index)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
        nextViewController.userID = String(dailyWeeeklyList[index].id ?? 0)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
}

extension ViewRewardViewController {
    
    func getDailyWeeklyData() {
        
        let url = AllUrls.baseUrl + "getDailyWeeklyEarningBeansUserList?interval=\(interval)"
        print("The url is \(url )")
        
        ApiWrapper.sharedManager().getDailyWeekly(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            
            if let userList = data {
                print(userList)
                
            dailyWeeeklyList = userList
                
                print("The count in the model is: \(dailyWeeeklyList.count)")

            }
            
            tblView.reloadData()
        }
    }
    
}
