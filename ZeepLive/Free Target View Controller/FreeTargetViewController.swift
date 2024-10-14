//
//  FreeTargetViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 26/09/23.
//

import UIKit

class FreeTargetViewController: UIViewController, delegateFreeTargetTableViewCell {
  
    @IBOutlet weak var imgViewTop: UIImageView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var isFreeTarget = Int()
    @IBOutlet weak var imgViewTopHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblViewTopConstraints: NSLayoutConstraint!
    lazy var imageUrl = String()
    lazy var updatedAt = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialise()
        checkForFreeTarget()
        tabBarController?.tabBar.isHidden = true
        
    }

    private func initialise() {
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "FreeTargetTableViewCell", bundle: nil), forCellReuseIdentifier: "FreeTargetTableViewCell")
        tblView.register(UINib(nibName: "FreeTargetWaitingApprovalTableViewCell", bundle: nil), forCellReuseIdentifier: "FreeTargetWaitingApprovalTableViewCell")
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW METHODS AND FUNCTIONS

extension FreeTargetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if (isFreeTarget == 0) {
            
            tblView.backgroundColor = .systemPurple
            tblViewTopConstraints.constant = 0
            imgViewTopHeightConstraint.constant = 230
            let cell = tableView.dequeueReusableCell(withIdentifier: "FreeTargetTableViewCell", for: indexPath) as! FreeTargetTableViewCell
            
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
            
        }   else if (isFreeTarget == 2) {
            
            
            let viewController = storyboard?.instantiateViewController(withIdentifier: "UserFreeTargetVC") as! UserFreeTargetViewController
           // maleViewController.tabBarItem = UITabBarItem(title: "Male", image: UIImage(named: "male_icon"), tag: 0)
            viewController.hidesBottomBarWhenPushed = true
            addChild(viewController)
            viewController.view.frame = view.bounds
            view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
           
            
            
        }  else {
             
            tblView.backgroundColor = .white
            tblViewTopConstraints.constant = 150
            imgViewTopHeightConstraint.constant = 0
            let cell = tableView.dequeueReusableCell(withIdentifier: "FreeTargetWaitingApprovalTableViewCell", for: indexPath) as! FreeTargetWaitingApprovalTableViewCell
            
            let imageURL = URL(string: imageUrl)!
                         downloadImage(from: imageURL, into: cell.imgViewVideoThumbnail)
            
            cell.lblUploadOn.text = "Upload On:" + " " + updatedAt
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (isFreeTarget == 0) {
            
            return 600
            
        } else {
        
            return 350
            
        }
        
    }

 // MARK: - DELEGATE METHOD TO KNOW ABOUT THE BUTTON SELECTED OR NOT
    
    func answer(isSelected: Bool) {
        print(isSelected)
    
        if (isSelected == true) {
            
            print("agle page par jaega")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FreeTargetSubmitDetailsViewController") as! FreeTargetSubmitDetailsViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        } else {
            
            print("Agle page par nahi jaega")
            showAlert(title: "ERROR !", message: "Please agree to our rules and instructions", viewController: self)
            
        }
        
    }
    
  }

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA

extension FreeTargetViewController {
    
    func checkForFreeTarget() {
        
        ApiWrapper.sharedManager().checkForFreeTarget(url:AllUrls.getUrl.checkForFreeTarget , completion: {(data) in
            
            if (data["success"] as? Bool == true) {
                print(data)
                print(data["result"])
                let a = data["result"] as? [String: Any]
                print(a)
              
                self.isFreeTarget = (a?["is_free_target"] as? Int ?? 0)
                print(self.isFreeTarget)
                
                if let videoThumbnail = a?["Video_thumbnail"] as? String {
                        
                    print("Video Thumbnail URL: \(videoThumbnail)")
                    self.imageUrl = videoThumbnail
                    print("The image url is: \(self.imageUrl)")
                    
                } else {
                    
                    print("No 'Video_thumbnail' key in 'result'")
                    
                }
                  
                let dateTime = a?["updated_at"] as? String
                print(dateTime)
                self.updatedAt = dateTime ?? ""
                print(self.updatedAt)
                
              //  self.isFreeTarget = 0
                self.tblView.reloadData()
                
            } else {
                
                self.showAlert(title: "ERROR !", message: "Something Went Wrong !", viewController: self)
                
            }
   
        })
       
    }
}
