//
//  UserFreeTargetViewController.swift
//  ZeepLive
//
//  Created by Fahad Nasar on 22/04/24.
//

import UIKit

class UserFreeTargetViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    
    @IBOutlet var emptyView: UIView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var freeTargetTableView: UITableView!
    
    @IBOutlet var userProfileImageView: UIImageView!
    
    @IBOutlet var userNameLAbel: UILabel!
    @IBOutlet var userTalentView: UIView!
    @IBOutlet var userTalentLabel: UILabel!
    @IBOutlet var earningPerWeekBeanValueLabel: UILabel!
    //@IBOutlet var professionView: UIView!

    @IBOutlet var usernameLabelXpostionConstraints: NSLayoutConstraint!
    var per : Float =  0.0
    var freeTargetResult : FreeTargetResult?
    var lastWeekDetails : [LastWeekDetail] = []
    
    var weekEmptyArray: [Any] = []
    var beanValueArray:[Any] = []
    var ratingStarArray : [Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBarController?.tabBar.isHidden = true
        Connectivity.shared.startMonitoring()
        getFreeTargetData()
         updateui()
        navigationController?.navigationBar.isHidden = true
       
       
        
  }
   
    
    func updateui(){
        // Check if the userImage URL is stored in UserDefaults
               if let userImageURLString = UserDefaults.standard.string(forKey: "profilePicture") {
                   // Check if the URL is valid
                   if let userImageURL = URL(string: userImageURLString) {
                       // Try to fetch the image data from the URL
                       if let imageData = try? Data(contentsOf: userImageURL) {
                           // Create an image from the data
                           if let image = UIImage(data: imageData) {
                               // Update the UI on the main thread
                               DispatchQueue.main.async {
                                   self.userProfileImageView.image = image
                               }
                           } else {
                               print("Unable to create image from data")
                           }
                       } else {
                           print("Unable to fetch image data from URL")
                       }
                   } else {
                       print("Invalid URL")
                   }
               } else {
                   print("User image URL not found in UserDefaults")
               }
           
       
        
        
        if let userName = UserDefaults.standard.object(forKey: "UserName") as? String {
            // Do something with userId
            print("User name: \(userName)")
            userNameLAbel.text = userName
        } else {
            // Handle the case where the value doesn't exist or isn't of the expected type
            print("User name not found or of unexpected type")
        }

        
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.width / 2
        userProfileImageView.clipsToBounds = true
        
        
        userTalentView.layer.cornerRadius = 10
        userTalentView.clipsToBounds = true
            freeTargetTableView.contentInsetAdjustmentBehavior = .never
        freeTargetTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        freeTargetTableView.layer.cornerRadius = 15 // Set your desired corner radius
        freeTargetTableView.layer.masksToBounds = true
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        else {
            return "Free Target Of All Weeks"
        }
    }
  
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        
        // Set text color
        headerView.textLabel?.textColor = UIColor(red: 256/256, green: 88/256, blue: 222/256, alpha: 1.0) // Change it to your desired color
        
        // Center-align text
        headerView.textLabel?.textAlignment = .center
        // Set font size and type bold
          let fontSize: CGFloat = 18 // Adjust the font size as needed
          let font = UIFont.boldSystemFont(ofSize: fontSize)
          headerView.textLabel?.font = font
        headerView.textLabel?.sizeToFit()
      
    }
   
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if freeTargetResult?.lastweekdetails?.count == 0{
            emptyView.isHidden = false
        }else{
            emptyView.isHidden = true
            if section == 0 {
                return 1
            }else{
                return (lastWeekDetails.count)
            }
        }
            
        return 3
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! UserFreeTargetTableViewCell
           
          
            let tC = cell.convertMsToHMS(value: Double(Int(freeTargetResult?.perDayCompleteTime ?? 1200)))
            //let normaltC = cell.millisecondsToHoursMinutesSeconds(milliseconds:45296789)
           
            cell.timeCompletedLabel.text = "Time Completed - " + tC
            let tR = cell.convertMsToHMS(value: Double(Int(freeTargetResult?.perDayRemainingTime ?? 1200)))
            //let normaltR = cell.millisecondsToHoursMinutesSeconds(milliseconds:5296789)
           
            cell.timeReaminingLabel.text = "Time Remaining - " + tR
            cell.currentWeekView.layer.cornerRadius = 15.0
            cell.currentWeekView.clipsToBounds = true
            
            if let talentValue = freeTargetResult?.talent {
                userTalentView.isHidden = false
                usernameLabelXpostionConstraints.constant = 5
                userTalentLabel.text = talentValue
            }
            else{
                usernameLabelXpostionConstraints.constant = 20
                userTalentView.isHidden = true
            }
            
          //  let ratingValue = freeTargetResult?.totalStars
            
          
            

            let value = freeTargetResult?.currentDay

            switch value?.lowercased() {
                case "monday":
                    // Handle Monday
                cell.mondayImageView.image = UIImage(named: "m")
                cell.tuesdayImageView.image = UIImage(named: "un_t")
                cell.wednessImageView.image = UIImage(named: "un_w")
                cell.thursdayImageView.image = UIImage(named: "un_t")
                cell.fridayImageView.image = UIImage(named: "un_f")
                cell.saturdayImageView.image = UIImage(named: "un_s")
                cell.sundayImageView.image = UIImage(named: "un_s")
                
                cell.showRemainingDaysLeftLabel.text = "6 Days Left"
                    print("It's Monday!")
                if Int(freeTargetResult?.monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekMondayStarRating.image = UIImage(named: "iv_honor_star")
              }
               
                case "tuesday":
                    // Handle Tuesday
                cell.mondayImageView.image = UIImage(named: "m")
                cell.tuesdayImageView.image = UIImage(named: "t")
                cell.wednessImageView.image = UIImage(named: "un_w")
                cell.thursdayImageView.image = UIImage(named: "un_t")
                cell.fridayImageView.image = UIImage(named: "un_f")
                cell.saturdayImageView.image = UIImage(named: "un_s")
                cell.sundayImageView.image = UIImage(named: "un_s")
                cell.showRemainingDaysLeftLabel.text = "5 Days Left"
                    print("It's Tuesday!")
                if Int(freeTargetResult?.monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekMondayStarRating.image = UIImage(named: "iv_honor_star")
                    
                }
                if Int(freeTargetResult?.tuesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekTuesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                
                case "wednesday":
                    // Handle Wednesday
                cell.mondayImageView.image = UIImage(named: "m")
                cell.tuesdayImageView.image = UIImage(named: "t")
                cell.wednessImageView.image = UIImage(named: "w")
                cell.thursdayImageView.image = UIImage(named: "un_t")
                cell.fridayImageView.image = UIImage(named: "un_f")
                cell.saturdayImageView.image = UIImage(named: "un_s")
                cell.sundayImageView.image = UIImage(named: "un_s")
                cell.showRemainingDaysLeftLabel.text = "4 Days Left"
                    print("It's Wednesday!")
                if Int(freeTargetResult?.monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekMondayStarRating.image = UIImage(named: "iv_honor_star")
                    
                }
                if Int(freeTargetResult?.tuesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekTuesdayStarRating.image = UIImage(named: "iv_honor_star")
                    
                }
                if Int(freeTargetResult?.wednesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
                   
                }
               
                case "thursday":
                    // Handle Thursday
                cell.mondayImageView.image = UIImage(named: "m")
                cell.tuesdayImageView.image = UIImage(named: "t")
                cell.wednessImageView.image = UIImage(named: "w")
                cell.thursdayImageView.image = UIImage(named: "t")
                cell.fridayImageView.image = UIImage(named: "un_f")
                cell.saturdayImageView.image = UIImage(named: "un_s")
                cell.sundayImageView.image = UIImage(named: "un_s")
                cell.showRemainingDaysLeftLabel.text = "3 Days Left"
                    print("It's Thursday!")
                if Int(freeTargetResult?.monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekMondayStarRating.image = UIImage(named: "iv_honor_star")
                    
                }
                if Int(freeTargetResult?.tuesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekTuesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.wednesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.thursday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentweekThursdaystarRating.image = UIImage(named: "iv_honor_star")
                }
                
                
                case "friday":
                    // Handle Friday
                cell.mondayImageView.image = UIImage(named: "m")
                cell.tuesdayImageView.image = UIImage(named: "t")
                cell.wednessImageView.image = UIImage(named: "w")
                cell.thursdayImageView.image = UIImage(named: "t")
                cell.fridayImageView.image = UIImage(named: "f")
                cell.saturdayImageView.image = UIImage(named: "un_s")
                cell.sundayImageView.image = UIImage(named: "un_s")
                cell.showRemainingDaysLeftLabel.text = "2 Days Left"
                    print("It's Friday!")
                if Int(freeTargetResult?.monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekMondayStarRating.image = UIImage(named: "iv_honor_star")
                    
                }
                if Int(freeTargetResult?.tuesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekTuesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.wednesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.thursday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.friday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekFridayStarRating.image = UIImage(named: "iv_honor_star")
                }
                
                case "saturday":
                    // Handle Saturday
                cell.mondayImageView.image = UIImage(named: "m")
                cell.tuesdayImageView.image = UIImage(named: "t")
                cell.wednessImageView.image = UIImage(named: "w")
                cell.thursdayImageView.image = UIImage(named: "t")
                cell.fridayImageView.image = UIImage(named: "f")
                cell.saturdayImageView.image = UIImage(named: "s")
                cell.sundayImageView.image = UIImage(named: "un_s")
                cell.showRemainingDaysLeftLabel.text = "1 Days Left"
                if Int(freeTargetResult?.monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekMondayStarRating.image = UIImage(named: "iv_honor_star")
                    
                }
                if Int(freeTargetResult?.tuesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekTuesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.wednesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.thursday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.friday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekFridayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.saturday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekSaturdayStarRating.image = UIImage(named: "iv_honor_star")
                }
          
                    print("It's Saturday!")
                case "sunday":
                    // Handle Sunday
                cell.mondayImageView.image = UIImage(named: "m")
                cell.tuesdayImageView.image = UIImage(named: "t")
                cell.wednessImageView.image = UIImage(named: "w")
                cell.thursdayImageView.image = UIImage(named: "t")
                cell.fridayImageView.image = UIImage(named: "f")
                cell.saturdayImageView.image = UIImage(named: "s")
                cell.sundayImageView.image = UIImage(named: "s")
                cell.showRemainingDaysLeftLabel.text = ""
                if Int(freeTargetResult?.monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    
                    
                }
                if Int(freeTargetResult?.monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekMondayStarRating.image = UIImage(named: "iv_honor_star")
                    
                }
                if Int(freeTargetResult?.tuesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekTuesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.wednesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.thursday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.friday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekFridayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.saturday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekSaturdayStarRating.image = UIImage(named: "iv_honor_star")
                }
                if Int(freeTargetResult?.sunday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                    cell.currentWeekSundayStarRating.image = UIImage(named: "iv_honor_star")
                }
                    print("It's Sunday!")
                default:
                    // Handle other cases
                    print("Invalid day of the week")
                }
         
         print("progress value;\(per)")
        cell.progressBar.progress = per / 100
        
    
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)as! UserFreeTargetTableViewCell
            
            cell.allWeeksView.layer.cornerRadius = 15.0
            cell.allWeeksView.clipsToBounds = true
            
            cell.weekNameLAbel.text = lastWeekDetails[indexPath.item].weekName
            
            cell.totalBeanDisplayLabel.text = String(lastWeekDetails[indexPath.item].reward ?? 1)
            
            if Int(lastWeekDetails[indexPath.row].monday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                cell.lastWeekMondayStarRating.image = UIImage(named: "iv_honor_star")
                
            }
            if Int(lastWeekDetails[indexPath.row].tuesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                cell.lastWeekTuesdayStarRating.image = UIImage(named: "iv_honor_star")
            }
            if Int(lastWeekDetails[indexPath.row].wednesday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                cell.lastweekWednesdayStarRating.image = UIImage(named: "iv_honor_star")
            }
            if Int(lastWeekDetails[indexPath.row].thursday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                cell.lastWeekThursdayStarRating.image = UIImage(named: "iv_honor_star")
            }
            if Int(lastWeekDetails[indexPath.row].friday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                cell.lastweekFridayStarRating.image = UIImage(named: "iv_honor_star")
            }
            if Int(lastWeekDetails[indexPath.row].saturday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                cell.lastWeekSaturdayStarRating.image = UIImage(named: "iv_honor_star")
            }
            if Int(lastWeekDetails[indexPath.row].sunday ?? 1) >= Int(freeTargetResult?.perDayTotalTime ?? 10){
                cell.lastweekSundayStarRating.image = UIImage(named: "iv_honor_star")
            }
            if  indexPath.row == 0{
                
            
            let value = freeTargetResult?.currentDay
            
            switch value?.lowercased() {
            case "monday":
                // Handle Monday
                cell.lastWeekMondayImageView.image = UIImage(named: "m")
                cell.lastWeekTuesdayImageView.image = UIImage(named: "un_t")
                cell.lastWeekWednessDayImageView.image = UIImage(named: "un_w")
                cell.lastWeekThursdayImageView.image = UIImage(named: "un_t")
                cell.lastWeekFridayImageView.image = UIImage(named: "un_f")
                cell.lastWeekSaturdayImageView.image = UIImage(named: "un_s")
                cell.lastWeekSundayImageView.image = UIImage(named: "un_s")
                
        
                print("It's Monday!")
                
                
            case "tuesday":
                // Handle Tuesday
                cell.lastWeekMondayImageView.image = UIImage(named: "m")
                cell.lastWeekTuesdayImageView.image = UIImage(named: "t")
                cell.lastWeekWednessDayImageView.image = UIImage(named: "un_w")
                cell.lastWeekThursdayImageView.image = UIImage(named: "un_t")
                cell.lastWeekFridayImageView.image = UIImage(named: "un_f")
                cell.lastWeekSaturdayImageView.image = UIImage(named: "un_s")
                cell.lastWeekSundayImageView.image = UIImage(named: "un_s")
   
                print("It's Tuesday!")
                
                
            case "wednesday":
                // Handle Wednesday
                cell.lastWeekMondayImageView.image = UIImage(named: "m")
                cell.lastWeekTuesdayImageView.image = UIImage(named: "t")
                cell.lastWeekWednessDayImageView.image = UIImage(named: "w")
                cell.lastWeekThursdayImageView.image = UIImage(named: "un_t")
                cell.lastWeekFridayImageView.image = UIImage(named: "un_f")
                cell.lastWeekSaturdayImageView.image = UIImage(named: "un_s")
                cell.lastWeekSundayImageView.image = UIImage(named: "un_s")
           
                print("It's Wednesday!")
                
                
            case "thursday":
                // Handle Thursday
                cell.lastWeekMondayImageView.image = UIImage(named: "m")
                cell.lastWeekTuesdayImageView.image = UIImage(named: "t")
                cell.lastWeekWednessDayImageView.image = UIImage(named: "w")
                cell.lastWeekThursdayImageView.image = UIImage(named: "t")
                cell.lastWeekFridayImageView.image = UIImage(named: "un_f")
                cell.lastWeekSaturdayImageView.image = UIImage(named: "un_s")
                cell.lastWeekSundayImageView.image = UIImage(named: "un_s")
       
                print("It's Thursday!")
                
                
                
            case "friday":
                // Handle Friday
                cell.lastWeekMondayImageView.image = UIImage(named: "m")
                cell.lastWeekTuesdayImageView.image = UIImage(named: "t")
                cell.lastWeekWednessDayImageView.image = UIImage(named: "w")
                cell.lastWeekThursdayImageView.image = UIImage(named: "t")
                cell.lastWeekFridayImageView.image = UIImage(named: "f")
                cell.lastWeekSaturdayImageView.image = UIImage(named: "un_s")
                cell.lastWeekSundayImageView.image = UIImage(named: "un_s")
      
                print("It's Friday!")
                
                
            case "saturday":
                // Handle Saturday
                cell.lastWeekMondayImageView.image = UIImage(named: "m")
                cell.lastWeekTuesdayImageView.image = UIImage(named: "t")
                cell.lastWeekWednessDayImageView.image = UIImage(named: "w")
                cell.lastWeekThursdayImageView.image = UIImage(named: "t")
                cell.lastWeekFridayImageView.image = UIImage(named: "f")
                cell.lastWeekSaturdayImageView.image = UIImage(named: "s")
                cell.lastWeekSundayImageView.image = UIImage(named: "un_s")
              
                
                print("It's Saturday!")
            case "sunday":
                // Handle Sunday
                cell.lastWeekMondayImageView.image = UIImage(named: "m")
                cell.lastWeekTuesdayImageView.image = UIImage(named: "t")
                cell.lastWeekWednessDayImageView.image = UIImage(named: "w")
                cell.lastWeekThursdayImageView.image = UIImage(named: "t")
                cell.lastWeekFridayImageView.image = UIImage(named: "f")
                cell.lastWeekSaturdayImageView.image = UIImage(named: "s")
                cell.lastWeekSundayImageView.image = UIImage(named: "s")
               
                
                print("It's Sunday!")
            default:
                // Handle other cases
                print("Invalid day of the week")
            }
        }
       return  cell
            
            
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//
//    }
    
   
   
   //MARK: Call API
    
    
    func getFreeTargetData(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var token = ""
        
        if let uToken = UserDefaults.standard.object(forKey: "token") as? String {
            // Do something with userId
            print("User token: \(uToken)")
            token = uToken
        } else {
            // Handle the case where the value doesn't exist or isn't of the expected type
            print("User token not found or of unexpected type")
        }
        var userID = 0
       
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int {
            // Do something with userId
            print("User ID: \(userId)")
            userID = userId
        } else {
            // Handle the case where the value doesn't exist or isn't of the expected type
            print("User ID not found or of unexpected type")
        }
        
        
        let parameter = [
            
            "user_id": userID
            
            
        ]
        
        ApiWrapper.sharedManager().getFreeTargetData(url: AllUrls.getUrl.getFreeTarget, parameter: parameter, token: token) { response in
            //            print("receide Value :.....................\(response)")
            
            let res = response?.result
            self.freeTargetResult = res
           
            
            //            self.emptyView.isHidden = false
            
            //DispatchQueue.main.async {
                if let data = response{
                    if let res = data.result{
                        self.freeTargetResult = res
                        self.lastWeekDetails = self.freeTargetResult?.lastweekdetails ?? []
                        print("free:\(res)")
                        
                        var beanValue =  0
                        beanValue =  self.freeTargetResult?.earningPerWeek ?? 1
                        self.earningPerWeekBeanValueLabel.text = String(beanValue)
                        
                        let earnings = self.freeTargetResult?.perDayCompleteTime
                        let total = self.freeTargetResult?.perDayTotalTime
                        self.setUpProgressBar(earning: earnings ?? 1, total: total ?? 1)
                        print(" beanValue:\( beanValue)")
                       
                    }
                    self.freeTargetTableView.reloadData()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            //}
            else{
                print("Error")
                if let error = response?.error{
                    print("Error:\(error)")
                }
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                
            }
        }
        
    }
    
    
    func setUpProgressBar(earning : Int, total : Int){
        
        
//       var  earning = 15000
        if (total != 0){
            per = Float((earning) * 100 / (total))
            print("Total value to increase step progress:\(per)")
        }
        
        
        
        //          currentProgress += 0.125
        //          if currentProgress > 1.0 {
        //              currentProgress = 1.0
        //          }
        // Update the progress view in the first cell
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = freeTargetTableView.cellForRow(at: indexPath) as? UserFreeTargetTableViewCell {
            
            
            if (per > 0.0 && per <= 25) {
                print(per)
                
                cell.zeroPositionProgressImageView.image = UIImage(named: "0")
                
                
            }else if (per > 25 && per <= 50) {
                print(per)
                cell.zeroPositionProgressImageView.image = UIImage(named: "0")
                cell.firstPositionProgressImageView.image = UIImage(named: "1")
                
                
            }else if (per > 50 && per <= 75) {
                print(per)
                cell.zeroPositionProgressImageView.image = UIImage(named: "0")
                cell.firstPositionProgressImageView.image = UIImage(named: "1")
                cell.secondPositionProgressImageView.image = UIImage(named: "2")
                
                
            }else if (per > 75 && per <= 100) {
                print(per)
                cell.zeroPositionProgressImageView.image = UIImage(named: "0")
                cell.firstPositionProgressImageView.image = UIImage(named: "1")
                cell.secondPositionProgressImageView.image = UIImage(named: "2")
                cell.thirdPositionProgressImageView.image = UIImage(named: "3")
                cell.finalPositionProgressImageView.image = UIImage(named: "pending_star")
                
            }
            else if (per > 100)
            {
                print(per)
                cell.zeroPositionProgressImageView.image = UIImage(named: "0")
                cell.firstPositionProgressImageView.image = UIImage(named: "1")
                cell.secondPositionProgressImageView.image = UIImage(named: "2")
                cell.thirdPositionProgressImageView.image = UIImage(named: "3")
                cell.finalPositionProgressImageView.image = UIImage(named: "pending_star")
            }
//            cell.progressBar.progress = per / 100
        }
        
    }
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
        
        
        
}

