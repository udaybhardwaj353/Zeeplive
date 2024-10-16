//
//  AccountViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/05/23.
//

import UIKit
import Kingfisher
import SwiftyJSON

class AccountViewController: UIViewController, delegateAccountDetailsTableViewCell {
   
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
   lazy var arrUserOptionName = [String]()
   lazy var arrUserOptionImageName = [String]()
    
   lazy var userName = String()
   lazy var userProfileId = String()
   lazy var userId = String()
    
    lazy var followType: String = "1"
    lazy var gender = String()
    
    lazy var userDetails = userDetailsData()
    lazy var malePointsData = MaleBalance()
    lazy var femalePointsData = FemaleBalance()
    
    lazy var arrHostOptionName = [String]()
    lazy var arrHostOptionImage = [String]()
    
    lazy var userCity: String = ""
    lazy var isLoadImageAgain: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let navigationController = self.navigationController else { return }
//               var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
//               let temp = navigationArray.last
//               navigationArray.removeAll()
//               navigationArray.append(temp!) //To remove all previous UIViewController except the last one
//               self.navigationController?.viewControllers = navigationArray
//        
                isLoadImageAgain = true
                configureTableView()
               configureNavigationBar()
               
               userName = UserDefaults.standard.string(forKey: "UserName") ?? "No Name"
        userProfileId = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        userCity = UserDefaults.standard.string(forKey: "location") ?? ""
        print("The Id of user is \(UserDefaults.standard.string(forKey: "UserId"))")
              //  getUserDetails()
       // getPoints()
        
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
            // Release any other resources or remove additional observers
        }
    
    private func configureTableView() {
           tblView.delegate = self
           tblView.dataSource = self
           tblView.register(UINib(nibName: "AccountOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountOptionsTableViewCell")
           tblView.register(UINib(nibName: "AccountDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountDetailsTableViewCell")
        
    }
       
    private func setDataInArray() {
    
        if (gender == "female") {
            
//            arrHostOptionName = ["My Balance", "My Earning", "Free Target", "My Backpack", "Anchor Center", "My Level", "My Game", "My Profile", "My Agency" ,"Settings"]
//            arrHostOptionImage = ["MyBalance","MyEarning","freetarget","backpack_1@2x", "dollar", "MyLevel", "game@2x" , "MyProfile","MyAgency","MySetting"]
//            arrHostOptionName = ["My Balance", "My Earning", "Free Target", "My Backpack", "Anchor Center", "My Level", "My Profile", "My Agency" ,"Settings"]
//            arrHostOptionImage = ["MyBalance","MyEarning","freetarget","backpack_1@2x", "dollar", "MyLevel", "MyProfile","MyAgency","MySetting"]
            
            arrHostOptionName = ["My Balance", "My Earning", "Free Target", "Anchor Center", "My Level", "My Profile", "My Agency" ,"Settings"]
            arrHostOptionImage = ["MyBalance","MyEarning","freetarget", "dollar", "MyLevel", "MyProfile","MyAgency","MySetting"]
            
        } else {
            
//            arrUserOptionName = ["My Balance", "My Earning", "My Backpack", "My Level", "My Game" ,"My Profile", "Settings"]
//            arrUserOptionImageName = ["MyBalance","MyEarning","backpack_1@2x","MyLevel", "game@2x" , "MyProfile","MySetting"]
//            arrUserOptionName = ["My Balance", "My Earning", "My Backpack", "My Level" ,"My Profile", "Settings"]
//            arrUserOptionImageName = ["MyBalance","MyEarning","backpack_1@2x","MyLevel" , "MyProfile","MySetting"]
            
            arrUserOptionName = ["My Balance", "My Earning", "My Level" ,"My Profile", "Settings"]
            arrUserOptionImageName = ["MyBalance","MyEarning", "MyLevel" , "MyProfile","MySetting"]
            
        }
        
    }
    
       private func configureNavigationBar() {
           UITabBar.appearance().tintColor = UIColor.systemPurple
           UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
       }

    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          
       // isLoadImageAgain = false
            navigationController?.setNavigationBarHidden(true, animated: true)
            tabBarController?.tabBar.isHidden = false
        
            let token = UserDefaults.standard.string(forKey: "token")
            print(token)
        
        getUserDetails()
           // Remove previous view controllers from the navigation stack
           if let navigationController = self.navigationController,
              let lastViewController = navigationController.viewControllers.last {
               navigationController.setViewControllers([lastViewController], animated: false)
           }
       }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        
            // Set the delegate property of AccountDetailsTableViewCell to nil
            if let indexPath = tblView.indexPathForSelectedRow,
                let cell = tblView.cellForRow(at: indexPath) as? AccountDetailsTableViewCell {
                cell.delegate = nil
            }
        }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        
    }
}


// MARK: - EXTENSION FOR USING TABLE VIEW FUNCTIONALITIES AND IT'S WORKING

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            if (gender == "female") {
                return arrHostOptionName.count
            } else {
                return arrUserOptionName.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "AccountDetailsTableViewCell", for: indexPath) as! AccountDetailsTableViewCell
                   
            if (userCity == "") || (userCity == nil) {
               
                print("User ki koi city nahi hai")
                cell.viewCountry.isHidden = true
                
            } else {
                
                print("User ki city hai")
                cell.lblUserCityName.text = userCity
                cell.viewCountry.frame.size.width = cell.lblUserCityName.intrinsicContentSize.width
                cell.viewCountry.isHidden = false
                
            }
            
            if (userDetails.city == "") || (userDetails.city == nil) {
            
                cell.viewCountry.isHidden = true
                
            } else {
                
                cell.lblUserCityName.text = userDetails.city
                cell.viewCountry.frame.size.width = cell.lblUserCityName.intrinsicContentSize.width
                cell.viewCountry.isHidden = false
                
            }
            
                    cell.viewUserID.frame.size.width = cell.lblUserId.intrinsicContentSize.width + 50
                    cell.lblUserName.text = userName
                    cell.lblUserId.text = "ID:" + " " + userProfileId
                    cell.viewUserID.backgroundColor = GlobalClass.sharedInstance.setGapColour()
            
                    cell.imgViewBackground.image = UIImage(named: "AccountBackgroundImage")
                  //  cell.imgViewUserPhoto.image = UIImage(named: "PlaceholderImage")
                    
                    cell.lblFriendCount.text = String(userDetails.friendCount ?? 0)
                    cell.lblFollowingCount.text = String(userDetails.favoriteCount ?? 0)
                    cell.lblFollowersCount.text = String(userDetails.myFollowCount ?? 0)
            
            if (gender.lowercased() == "male") {
            
                cell.lblUserLevel.text = String(userDetails.richLevel ?? 0)
                
            } else {
                
                cell.lblUserLevel.text = String(userDetails.charmLevel ?? 0)
                
            }
            
//                    cell.lblUserLevel.text = String(userDetails.level ?? 0)
                   
            
            if (userDetails.profileImages?.count == 0) || (userDetails.profileImages == nil) {
                print("Profile images vali array khali hai")
                
            } else {
                
                if (isLoadImageAgain == true) {
                    loadImage(from: userDetails.profileImages?[0].imageName ?? " ", into: cell.imgViewUserPhoto)
                    isLoadImageAgain = false
                    print("Profile image ko reload kara denge.")
                    
                }
//                if let imageName = userDetails.profileImages?[0].imageName,
//                   let imageURL = URL(string: imageName) {
//                    downloadImage(from: imageURL, into: cell.imgViewUserPhoto)
//                } else {
//
//                    cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//
//                }
                
//                let imageURL = URL(string: userDetails.profileImages?[0].imageName ?? " ")!
//                             downloadImage(from: imageURL, into: cell.imgViewUserPhoto)
               
                
//                if let profileImageURL = URL(string: userDetails.profileImages?[0].imageName ?? " ") {
//                    KF.url(profileImageURL)
//                       // .downsampling(size: CGSize(width: 200, height: 200))
//                        .cacheOriginalImage()
//                        .onSuccess { result in
//                            DispatchQueue.main.async {
//                                cell.imgViewUserPhoto.image = result.image
//                            }
//                        }
//                        .onFailure { error in
//                            print("Image loading failed with error: \(error)")
//                            cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//                        }
//                        .set(to: cell.imgViewUserPhoto)
//                } else {
//                    cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//                }
                
            }
            
            if (gender.lowercased() == "male") {
                
                print("User ka gender male hai.")
                
                if let userLevel = userDetails.richLevel {
                    if (userLevel == 0) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv0")
                    } else if (userLevel >= 1 && userLevel <= 5) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv1-5")
                    } else if (userLevel >= 6 && userLevel <= 10) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv6-10")
                    } else if (userLevel >= 11 && userLevel <= 15) {
                        cell.imgViewLevel.image =  UIImage(named: "reach_Lv11-15")
                    } else if (userLevel >= 16 && userLevel <= 20) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv16-20")
                    } else if (userLevel >= 21 && userLevel <= 25) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv21-25")
                    } else if (userLevel >= 26 && userLevel <= 30) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv26-30")
                    } else if (userLevel >= 31 && userLevel <= 35) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv31-35")
                    } else if (userLevel >= 36 && userLevel <= 40) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv36-40")
                    } else if (userLevel >= 41 && userLevel <= 45) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv41-45")
                    } else if (userLevel >= 46 ) {
                        cell.imgViewLevel.image = UIImage(named: "reach_Lv45-50")
                    }
                }
            } else {
                
                print("User ka gender female hai.")
                if let userLevel = userDetails.charmLevel {
                    if (userLevel == 0) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv0")
                    } else if (userLevel >= 1 && userLevel <= 5) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv1-5")
                    } else if (userLevel >= 6 && userLevel <= 10) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv6-10")
                    } else if (userLevel >= 11 && userLevel <= 15) {
                        cell.imgViewLevel.image =  UIImage(named: "charm_Lv11-15")
                    } else if (userLevel >= 16 && userLevel <= 20) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv16-20")
                    } else if (userLevel >= 21 && userLevel <= 25) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv21-25")
                    } else if (userLevel >= 26 && userLevel <= 30) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv26-30")
                    } else if (userLevel >= 31 && userLevel <= 35) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv31-35")
                    } else if (userLevel >= 36 && userLevel <= 40) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv36-40")
                    } else if (userLevel >= 41 && userLevel <= 45) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv41-45")
                    } else if (userLevel >= 46 ) {
                        cell.imgViewLevel.image = UIImage(named: "charm_Lv46-50")
                    }
                }
                
            }
                    cell.delegate = self
                    cell.selectionStyle = .none
                   return cell
                   
               } else {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "AccountOptionsTableViewCell", for: indexPath) as! AccountOptionsTableViewCell
                   
                   if (gender == "female") {
                      
                       cell.lblOptionName.text = arrHostOptionName[indexPath.row]
                       cell.imgView.image = UIImage(named: arrHostOptionImage[indexPath.row])
                       
                       if indexPath.row == 0 {
                           cell.imgViewDiamond.image = UIImage(named: "Diamond")
                           if (gender == "female") {
                            
                               if ((femalePointsData.purchasePoints ?? 0) <= 0) {
                                    
                                   cell.lblMyBalanceCount.text = "0"
                                   
                               } else {
                                   
                                   cell.lblMyBalanceCount.text = String(femalePointsData.purchasePoints ?? 0)
                                   
                               }
                               
                           } else {
                             
                               if ((malePointsData.purchasePoints ?? 0) <= 0) {
                                    
                                   cell.lblMyBalanceCount.text = "0"
                                   
                               } else {
                                   
                                   cell.lblMyBalanceCount.text = String(malePointsData.purchasePoints ?? 0)
                               }
                           }
                       }
                       if indexPath.row == 1 {
                           cell.imgViewDiamond.image = UIImage(named: "Bean")
                           if (gender == "female") {
                               
                               if ((femalePointsData.redeemPoint ?? 0) <= 0) {
                                   
                                   cell.lblMyBalanceCount.text = "0"
                               } else {
                                   cell.lblMyBalanceCount.text = String(femalePointsData.redeemPoint ?? 0)
                               }
                           } else {
                               if ((malePointsData.earningRedeemPoint ?? 0) <= 0) {
                                   
                                   cell.lblMyBalanceCount.text = "0"
                               } else {
                                   cell.lblMyBalanceCount.text = String(malePointsData.earningRedeemPoint ?? 0)
                               }
                           }
                       }
                       
                       if indexPath.row > 1 {
                           cell.lblMyBalanceCount.isHidden = true
                           cell.imgViewDiamond.isHidden = true
                       } else {
                           cell.lblMyBalanceCount.isHidden = false
                           cell.imgViewDiamond.isHidden = false
                       }
                       
                       print(cell.lblOptionName.intrinsicContentSize.width)  // CODE TO GET THE WIDTH OF THE LABEL
                       if (indexPath.row == 9) {
                           
                           cell.viewDashLine.isHidden = true
                           
                       } else {
                           
                           cell.viewDashLine.isHidden = false
                           
                       }
                       cell.selectionStyle = .none
                       return cell
                       
                   } else {
                       
                       cell.lblOptionName.text = arrUserOptionName[indexPath.row]
                       cell.imgView.image = UIImage(named: arrUserOptionImageName[indexPath.row])
                       
                       if indexPath.row == 0 {
                           cell.imgViewDiamond.image = UIImage(named: "Diamond")
                           if (gender == "female") {
                               
                               if ((femalePointsData.purchasePoints ?? 0) < 0) {
                                   cell.lblMyBalanceCount.text = "0"
                               } else {
                                   cell.lblMyBalanceCount.text = String(femalePointsData.purchasePoints ?? 0)
                               }
                           } else {
                               if ((malePointsData.purchasePoints ?? 0) < 0) {
                                   cell.lblMyBalanceCount.text = "0"
                               } else {
                                   cell.lblMyBalanceCount.text = String(malePointsData.purchasePoints ?? 0)
                               }
                           }
                       }
                       if indexPath.row == 1 {
                           cell.imgViewDiamond.image = UIImage(named: "Bean")
                           if (gender == "female") {
                               
                               if ((femalePointsData.redeemPoint ?? 0) < 0) {
                                   cell.lblMyBalanceCount.text = "0"
                               } else {
                                   cell.lblMyBalanceCount.text = String(femalePointsData.redeemPoint ?? 0)
                               }
                           } else {
                               if ((malePointsData.earningRedeemPoint ?? 0) < 0) {
                                   cell.lblMyBalanceCount.text = "0"
                               } else {
                                   cell.lblMyBalanceCount.text = String(malePointsData.earningRedeemPoint ?? 0)
                               }
                           }
                       }
                       
                       if indexPath.row > 1 {
                           cell.lblMyBalanceCount.isHidden = true
                           cell.imgViewDiamond.isHidden = true
                       } else {
                           cell.lblMyBalanceCount.isHidden = false
                           cell.imgViewDiamond.isHidden = false
                       }
                       
                       print(cell.lblOptionName.intrinsicContentSize.width)  // CODE TO GET THE WIDTH OF THE LABEL
                       if (indexPath.row == 6) {
                           
                           cell.viewDashLine.isHidden = true
                           
                       } else {
                           
                           cell.viewDashLine.isHidden = false
                           
                       }
                       cell.selectionStyle = .none
                       return cell
                   }
               }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 290
        } else if (indexPath.section == 1){
            return 60
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if (indexPath.section == 1) {
            
            if (gender == "female") {
                
                if (indexPath.row == 0) {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyBalanceViewController") as! MyBalanceViewController
                    if (gender == "female") {
                        nextViewController.remainingCoins = femalePointsData.purchasePoints ?? 0
                    } else {
                        nextViewController.remainingCoins = malePointsData.purchasePoints ?? 0
                    }
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                
                if (indexPath.row == 1) {
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyEarningViewController") as! MyEarningViewController
//                    if (gender == "female") {
//                        nextViewController.myBalance = femalePointsData.redeemPoint ?? 0
//                    } else {
//                        nextViewController.myBalance = malePointsData.earningPoints ?? 0
//                    }
//                    
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewMyEarningViewController") as! NewMyEarningViewController
                    if (gender == "female") {
                        nextViewController.myBalance = femalePointsData.redeemPoint ?? 0
                    } else {
                        nextViewController.myBalance = malePointsData.earningRedeemPoint ?? 0
                        
                    }
                    
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
                if (indexPath.row == 2) {
                    
                    print("Free Target ke liye")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FreeTargetViewController") as! FreeTargetViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
//                if (indexPath.row == 3) {
//                    
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyStoreViewController") as! MyStoreViewController
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
//                    
//                }
                
                if (indexPath.row == 3) {
                    
                    print("My anchor ke liye hai ye")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IncomeReportViewController") as! IncomeReportViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
                if (indexPath.row == 4) {
                    
                    lazy var url = "https://zeep.live/user-level/" + userProfileId
                    print(url)
                    
                    openWebView(withURL: url)
                    
                }
                
//                if (indexPath.row == 6) {
//                    
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
//                    
//                }
                
                if (indexPath.row == 5) {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
                if (indexPath.row == 6) {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyAgencyViewController") as! MyAgencyViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    print("My agency ke liye hai ye")
                    
                }
                
                if (indexPath.row == 7) {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
            } else {
                if (indexPath.row == 0) {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyBalanceViewController") as! MyBalanceViewController
                    if (gender == "female") {
                        nextViewController.remainingCoins = femalePointsData.purchasePoints ?? 0
                    } else {
                        nextViewController.remainingCoins = malePointsData.purchasePoints ?? 0
                    }
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                    
                }
                
                if (indexPath.row == 1) {
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyEarningViewController") as! MyEarningViewController
//                    if (gender == "female") {
//                        nextViewController.myBalance = femalePointsData.redeemPoint ?? 0
//                    } else {
//                        nextViewController.myBalance = malePointsData.earningPoints ?? 0
//                    }
//                    
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
                  
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewMyEarningViewController") as! NewMyEarningViewController
                    if (gender == "female") {
                        nextViewController.myBalance = femalePointsData.redeemPoint ?? 0
                    } else {
                        nextViewController.myBalance = malePointsData.earningRedeemPoint ?? 0
                    }
                    
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
//                if (indexPath.row == 2) {
//                    
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyStoreViewController") as! MyStoreViewController
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
//                    
//                }
                
                if (indexPath.row == 2) {
                    
                    lazy var url = "https://zeep.live/user-level/" + userProfileId
                    print(url)
                    
                    openWebView(withURL: url)
                    
                }
                
//                if (indexPath.row == 4) {
//                    
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
//                    self.navigationController?.pushViewController(nextViewController, animated: true)
//                    
//                }
                
                if (indexPath.row == 3) {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
                if (indexPath.row == 4) {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
            }
        }
    }

// MARK: - DELEGATE FUNCTION TO MOVE TO NEXT VIEW CONTROLLER ON THE BASIS OF VIEW SELECTED FROM ACCOUNT DETAILS TABLE VIEW CELL
    
    func butttonPressed(buttonPressed: String) {
        print(buttonPressed)
        
        if (buttonPressed == "Following") {
              
            followType = "1"
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowListsViewController") as! ShowListsViewController
                    nextViewController.followType = followType
                    self.navigationController?.pushViewController(nextViewController, animated: true)
            
                } else if ( buttonPressed == "Followers"){
                 
                    followType = "2"
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowListsViewController") as! ShowListsViewController
                    nextViewController.followType = followType
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                } else if (buttonPressed == "Friends"){
                   
                    followType = "3"
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowListsViewController") as! ShowListsViewController
                    nextViewController.followType = followType
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                } else if (buttonPressed == "Viewbackground") {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewProfileDetailViewController") as! NewProfileDetailViewController
                    nextViewController.userID = String(userDetails.id ?? 0)
                    
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING

extension AccountViewController {

 // MARK: - FUNCTION TO GET USER BALANCE AND EARNING
    
    func getPoints() {
       
        ApiWrapper.sharedManager().getPointsDetails(url: AllUrls.getUrl.getPoints) { [weak self] (value) in
            guard let self = self else { return }
            
            let jsonData = JSON(value)
            print(jsonData)
            
            if (gender == "female") {
                
                if let decodeData = try? jsonData["result"].rawData() {
                    print(decodeData)
                    if let gaReportData = try? JSONDecoder().decode(femaleResult.self, from: decodeData) {
                        print(gaReportData)
                    }
                }
                
                // Decode and print 'femaleweeklyEarningBeansData' data
                if let decodeData1 = try? jsonData["weeklyEarningBeansData"].rawData() {
                    print(decodeData1)
                    if let gaReportData1 = try? JSONDecoder().decode(femaleWeeklyEarningBeansData.self, from: decodeData1) {
                        UserDefaults.standard.set(gaReportData1.weeklyEarningBeans , forKey: "weeklyearning")
                        print(gaReportData1)
                    }
                }
                
                // Decode and print 'femaleBalance' data
                if let decodeData2 = try? jsonData["femaleBalance"].rawData() {
                    print(decodeData2)
                    if let gaReportData2 = try? JSONDecoder().decode(FemaleBalance.self, from: decodeData2) {
                        print(gaReportData2)
                        femalePointsData = gaReportData2
                        UserDefaults.standard.set(femalePointsData.purchasePoints , forKey: "coins")
                        UserDefaults.standard.set(femalePointsData.redeemPoint , forKey: "earning")
                        let redeemPoint = UserDefaults.standard.string(forKey: "earning") ?? "0"
                        print("The redeem point is: \(redeemPoint)")
                        
                        print(femalePointsData)
                    }
                }
                tblView.reloadData()
            } else {
                // Decode and print 'result' data
                if let decodeData = try? jsonData["result"].rawData() {
                    print(decodeData)
                    if let gaReportData = try? JSONDecoder().decode(maleResult.self, from: decodeData) {
                        print(gaReportData)
                    }
                }
                
                // Decode and print 'weeklyEarningBeansData' data
                if let decodeData1 = try? jsonData["weeklyEarningBeansData"].rawData() {
                    print(decodeData1)
                    if let gaReportData1 = try? JSONDecoder().decode(maleWeeklyEarningBeansData.self, from: decodeData1) {
                        print(gaReportData1)
                    }
                }
                
                // Decode and print 'maleBalance' data
                if let decodeData2 = try? jsonData["maleBalance"].rawData() {
                    print(decodeData2)
                    if let gaReportData2 = try? JSONDecoder().decode(MaleBalance.self, from: decodeData2) {
                        print(gaReportData2)
                        malePointsData = gaReportData2
                        UserDefaults.standard.set(malePointsData.purchasePoints , forKey: "coins")
                        UserDefaults.standard.set(malePointsData.earningRedeemPoint , forKey: "earning")
                        let redeemPoint = UserDefaults.standard.string(forKey: "earning") ?? "0"
                        print("The redeem point is: \(redeemPoint)")
                        print(malePointsData)
                    }
                }
            }
            tblView.reloadData()
        }
    }
  
// MARK: - FUNCTION TO CALL API AND GET USER DETAILS
    
    func getUserDetails() {
        
        ApiWrapper.sharedManager().userDetails(url: AllUrls.getUrl.getUserDetails) { [weak self] (data, value) in
            guard let self = self else { return }
           
            userDetails = data ?? userDetails
            userName = userDetails.name ?? ""
            userProfileId = String(userDetails.profileID ?? 0)
            userId = String(userDetails.id ?? 0)
            print(value)
            let a = value
            print(type(of: a))
            if let successDict = value["success"] as? [String: Any], let mobile = successDict["mobile"] as? Int {
                print("Mobile number:", mobile)
            } else {
                print("Mobile number not found or not of type Int")
            }


            
            print(userDetails)
                print(userDetails.name)
                print(userDetails.id)
                UserDefaults.standard.set(userDetails.profileID , forKey: "UserProfileId")
                UserDefaults.standard.set(userDetails.name , forKey: "UserName")
                UserDefaults.standard.set(userDetails.aboutUser , forKey: "aboutUser")
                UserDefaults.standard.set(userDetails.id , forKey: "userId")
                if let successDict = value["success"] as? [String: Any], let mobile = successDict["mobile"] as? Int {
                print("Mobile number:", mobile)
                UserDefaults.standard.set(mobile, forKey: "mobileNumber")
                } else {
                    UserDefaults.standard.removeObject(forKey: "mobileNumber")
                }
                UserDefaults.standard.set(userDetails.city , forKey: "city")
                UserDefaults.standard.set(userDetails.dob , forKey: "dob")
                UserDefaults.standard.set(userDetails.gender , forKey: "gender")
               // UserDefaults.standard.set(userDetails.level , forKey: "level")
                UserDefaults.standard.set(userDetails.callRate , forKey: "callrate")
                UserDefaults.standard.set(userDetails.newCallRate , forKey: "newcallrate")
                UserDefaults.standard.set(userDetails.countryID , forKey: "countryID")
            
                print(UserDefaults.standard.string(forKey: "UserProfileId"))
            
            if (userDetails.profileImages?.count == 0) || (userDetails.profileImages == nil) {
                print("Image nahi hai")
                
            } else {
                
                print("Profile Image hai")
                UserDefaults.standard.set(userDetails.profileImages?[0].imageName , forKey: "profilePicture")
                print(UserDefaults.standard.string(forKey: "profilePicture"))
                   
            }
            
            gender = userDetails.gender ?? ""
            print(gender)
            
            if (gender.lowercased() == "male") {
            
                UserDefaults.standard.set(userDetails.richLevel , forKey: "level")
                
            } else {
                
                UserDefaults.standard.set(userDetails.charmLevel , forKey: "level")
                
            }
            
            getPoints()
            
            setDataInArray()
            tblView.reloadData()
        }
    }
}
