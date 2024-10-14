//
//  SettingsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/05/23.
//

import UIKit
import Kingfisher
import RealmSwift

class SettingsViewController: UIViewController, delegateSettingsTableViewCell {
  
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var arrOptionName = [String]()
    lazy var isDeleteAccountPressed: Bool = false
    let realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        
//        arrOptionName = ["Privacy Policy", "Clear Cache", "Switch User", "Delete Account"]
        arrOptionName = ["Privacy Policy", "Delete Account"]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View appear hua hai")
        if (isDeleteAccountPressed == true) {
            print("isko home page par bhej do")
            
            guard let navigationController = self.navigationController else { return }
            var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
            let temp = navigationArray.last
            navigationArray.removeAll()
            navigationArray.append(temp!) //To remove all previous UIViewController except the last one
            self.navigationController?.viewControllers = navigationArray
            
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") {
                
                        KingfisherManager.shared.cache.clearDiskCache()
                        KingfisherManager.shared.cache.clearMemoryCache()
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "UserProfileId")
                        UserDefaults.standard.removeObject(forKey: "gender")
                        UserDefaults.standard.removeObject(forKey: "callrate")
                        UserDefaults.standard.removeObject(forKey: "newcallrate")
                        UserDefaults.standard.removeObject(forKey: "level")
                        UserDefaults.standard.removeObject(forKey: "UserName")
                        UserDefaults.standard.removeObject(forKey: "userId")
                        UserDefaults.standard.removeObject(forKey: "profilePicture")
                        UserDefaults.standard.removeObject(forKey: "coins")
                        UserDefaults.standard.removeObject(forKey: "weeklyearning")
                        UserDefaults.standard.synchronize()
                
                        UIApplication.shared.windows.first?.rootViewController = loginVC
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
            
        } else {
            print("Isko pichle page par bhej do")
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    deinit {
        
        tblView.delegate = nil
        tblView.dataSource = nil
        arrOptionName.removeAll()
        tblView = nil
        lblTopHeading = nil
        isDeleteAccountPressed = false
        print("Settings view controller main deinit call hua hai.")
        
    }
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS AND IT'S FUNCTIONALITY

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOptionName.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        cell.lblOptionName.text = arrOptionName[indexPath.row]
        
        if (indexPath.row == 1) {
            
            cell.btnLogoutOutlet.isHidden = false
            
        } else {
            
            cell.btnLogoutOutlet.isHidden = true
            
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if (indexPath.row == 0) {
            
            openWebView(withURL: "https://sites.google.com/view/zeeplive/privacy")
            
        }
        
        if (indexPath.row == 1) {
            print("Delete Account Wala Page Khula hai.")
            
            isDeleteAccountPressed = true
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
            nextViewController.delegate = self
            nextViewController.headingText = "Are you sure you want to Delete Account?"
            nextViewController.buttonName = "Delete"
            nextViewController.backgroundColour = .black.withAlphaComponent(0.4)
            nextViewController.modalPresentationStyle = .overCurrentContext
            
            present(nextViewController, animated: true, completion: nil)
            
//            openWebView(withURL: "https://zeep.live/delete-user-account")
//            isDeleteAccountPressed = true
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 1) {
            
            return 120
        } else {
            
            return 60
            
        }
        
    }
    
    func logoutPressed(isPressed: Bool) {
        print(isPressed)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CommonPopUpViewController") as! CommonPopUpViewController
        nextViewController.delegate = self
        nextViewController.headingText = "Are you sure you want to logout?"
        nextViewController.buttonName = "Logout"
        nextViewController.backgroundColour = .black.withAlphaComponent(0.4)
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
}

extension SettingsViewController: delegateCommonPopUpViewController {
    
    func deleteButtonPressed(isPressed: Bool) {
        
        if (isDeleteAccountPressed == true) {
            openWebView(withURL: "https://zeep.live/delete-user-account")
            isDeleteAccountPressed = true
        } else {
            
            print("Delete OR Close One To One Call Button Is Pressed")
            
            guard let navigationController = self.navigationController else { return }
            var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
            let temp = navigationArray.last
            navigationArray.removeAll()
            navigationArray.append(temp!) //To remove all previous UIViewController except the last one
            self.navigationController?.viewControllers = navigationArray
            
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") {
                
                KingfisherManager.shared.cache.clearDiskCache()
                KingfisherManager.shared.cache.clearMemoryCache()
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "UserProfileId")
                UserDefaults.standard.removeObject(forKey: "gender")
                UserDefaults.standard.removeObject(forKey: "callrate")
                UserDefaults.standard.removeObject(forKey: "newcallrate")
                UserDefaults.standard.removeObject(forKey: "level")
                UserDefaults.standard.removeObject(forKey: "UserName")
                UserDefaults.standard.removeObject(forKey: "userId")
                UserDefaults.standard.removeObject(forKey: "profilePicture")
                UserDefaults.standard.removeObject(forKey: "coins")
                UserDefaults.standard.removeObject(forKey: "weeklyearning")
                UserDefaults.standard.removeObject(forKey: "mobileNumber")
                //   UserDefaults.standard.removeObject(forKey: "uniquedeviceid")
                UserDefaults.standard.synchronize()
                
                UIApplication.shared.windows.first?.rootViewController = loginVC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
            
        }
    }
}
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        
//        if (indexPath.section == 0) {
//            if (indexPath.row == 0) {
//                
//                openWebView(withURL: "https://sites.google.com/view/zeeplive/privacy")
//                
//            }
//            if (indexPath.row == 1) {
//
//                let email = "swastik_tyagi@creativefrenzy.in"
//                if let url = URL(string: "mailto:\(email)") {
//                    UIApplication.shared.open(url)
//                    if(UIApplication.shared.canOpenURL(url)){
//                        print("Mail app khul raha hai . jisse ki aap mail bhej sakte hai aaram se.")
//                }else{
//                        print("Kuch gadbad hai . isliye mail app open nahi ho raha hai")
//                    }
//                }
//            }
//        }
//    }
//}
