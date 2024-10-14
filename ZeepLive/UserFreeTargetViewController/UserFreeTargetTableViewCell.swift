//
//  UserFreeTargetTableViewCell.swift
//  ZeepLive
//
//  Created by Fahad Nasar on 22/04/24.
//

import UIKit

class UserFreeTargetTableViewCell: UITableViewCell {

   
    
    @IBOutlet var timeCompletedLabel: UILabel!
    @IBOutlet var timeReaminingLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    
    @IBOutlet var currentWeekView: UIView!
    @IBOutlet var allWeeksView: UIView!
    
    
    @IBOutlet var zeroPositionProgressImageView: UIImageView!
    @IBOutlet var firstPositionProgressImageView: UIImageView!
    
    @IBOutlet var secondPositionProgressImageView: UIImageView!
    
    @IBOutlet var thirdPositionProgressImageView: UIImageView!
    
    @IBOutlet var finalPositionProgressImageView: UIImageView!
    
    @IBOutlet var showRemainingDaysLeftLabel: UILabel!
    @IBOutlet var mondayImageView: UIImageView!
    
    @IBOutlet var tuesdayImageView: UIImageView!
    
    @IBOutlet var wednessImageView: UIImageView!
    
    @IBOutlet var thursdayImageView: UIImageView!
    
    @IBOutlet var fridayImageView: UIImageView!
    
    @IBOutlet var saturdayImageView: UIImageView!
    
    @IBOutlet var sundayImageView: UIImageView!
    
    @IBOutlet var currentWeekMondayStarRating: UIImageView!
    
    @IBOutlet var currentWeekTuesdayStarRating: UIImageView!
    
    @IBOutlet var currentWeekWednesdayStarRating: UIImageView!
    
    @IBOutlet var currentweekThursdaystarRating: UIImageView!
    
    @IBOutlet var currentWeekFridayStarRating: UIImageView!
    
    @IBOutlet var currentWeekSaturdayStarRating: UIImageView!
    
    @IBOutlet var currentWeekSundayStarRating: UIImageView!
    @IBOutlet var weekNameLAbel: UILabel!
    
    @IBOutlet var totalBeanDisplayLabel: UILabel!
    
    
    @IBOutlet var lastWeekMondayImageView: UIImageView!
    @IBOutlet var lastWeekTuesdayImageView: UIImageView!
    @IBOutlet var lastWeekWednessDayImageView: UIImageView!
    @IBOutlet var lastWeekThursdayImageView: UIImageView!
    @IBOutlet var lastWeekFridayImageView: UIImageView!
    @IBOutlet var lastWeekSaturdayImageView: UIImageView!
    @IBOutlet var lastWeekSundayImageView: UIImageView!
    
    @IBOutlet var lastWeekMondayStarRating: UIImageView!
    
    @IBOutlet var lastWeekTuesdayStarRating: UIImageView!
    
    @IBOutlet var lastweekWednesdayStarRating: UIImageView!
    
    @IBOutlet var lastWeekThursdayStarRating: UIImageView!
    
    @IBOutlet var lastweekFridayStarRating: UIImageView!
    
    @IBOutlet var lastWeekSaturdayStarRating: UIImageView!
    
    @IBOutlet var lastweekSundayStarRating: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   /* func addLabelToImageView(withText text: String, imageView: UIImageView,constant: CGFloat) {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14) // Set desired font size
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label as a subview of the UIImageView
        imageView.addSubview(label)
        
        // Add constraints to center the label horizontally and vertically within the UIImageView
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: constant), // Adjust constant as needed
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        // If you want to set the width and height of the label
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: imageView.frame.size.width),
            label.heightAnchor.constraint(equalToConstant: imageView.frame.size.height)
        ])
    }*/
    
    
    func convertMsToHMS(value: Double)-> String{
        
        let date = NSDate(timeIntervalSince1970: Double(value) / 1000)
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        formatter.dateFormat = "HH:mm:ss"
//"HH:mm:ss SSS"
        print(formatter.string(from: date as Date))
        return formatter.string(from: date as Date)
    }
    
  /*func millisecondsToHoursMinutesSeconds(milliseconds: Int) -> (Int, Int, Int) {
        let seconds = milliseconds / 1000
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = (seconds % 3600) % 60
        print(hours, minutes, remainingSeconds)
        return (hours, minutes, remainingSeconds)
    }*/
}

