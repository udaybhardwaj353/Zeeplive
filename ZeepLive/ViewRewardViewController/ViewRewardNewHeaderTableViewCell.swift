//
//  ViewRewardNewHeaderTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 23/01/24.
//

import UIKit
import Lottie


protocol delegateViewRewardNewHeaderTableViewCell: AnyObject {

    func viewClicked(index:Int)
    
}

class ViewRewardNewHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewFirstUserOutlet: UIButton!
    @IBOutlet weak var viewSecondUserOutlet: UIButton!
    @IBOutlet weak var viewThirdUserOutlet: UIButton!
    @IBOutlet weak var imgViewFirstUser: UIImageView!
    @IBOutlet weak var imgViewSecondUser: UIImageView!
    @IBOutlet weak var imgViewThirdUser: UIImageView!
    @IBOutlet weak var viewFirstUserName: UIView!
    @IBOutlet weak var viewSecondUserName: UIView!
    @IBOutlet weak var viewThirdUserName: UIView!
    @IBOutlet weak var lblFirstUserName: UILabel!
    @IBOutlet weak var lblSecondUserName: UILabel!
    @IBOutlet weak var lblThirdUserName: UILabel!
    @IBOutlet weak var viewFirstUserBeans: UIView!
    @IBOutlet weak var viewSecondUserBeans: UIView!
    @IBOutlet weak var viewThirdUserBeans: UIView!
    @IBOutlet weak var lblFirstUserBeans: UILabel!
    @IBOutlet weak var lblSecondUserBeans: UILabel!
    @IBOutlet weak var lblThirdUserBeans: UILabel!
    @IBOutlet weak var viewFirstUserLevel: UIView!
    @IBOutlet weak var viewSecondUserLevel: UIView!
    @IBOutlet weak var viewThirdUserLevel: UIView!
    @IBOutlet weak var lblFirstUserLevel: UILabel!
    @IBOutlet weak var lblSecondUserLevel: UILabel!
    @IBOutlet weak var lblThirdUserLevel: UILabel!
    
    weak var delegate:delegateViewRewardNewHeaderTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        configureUI()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        
        imgViewFirstUser.layer.cornerRadius = imgViewFirstUser.frame.height / 2
        imgViewSecondUser.layer.cornerRadius = imgViewSecondUser.frame.height / 2
        imgViewThirdUser.layer.cornerRadius = imgViewThirdUser.frame.height / 2
        
        imgViewFirstUser.clipsToBounds = true
        imgViewSecondUser.clipsToBounds = true
        imgViewThirdUser.clipsToBounds = true
        
        setupLottieAnimation(view: viewFirstUserOutlet, animationFileName: "Lv3")
        setupLottieAnimation(view: viewSecondUserOutlet, animationFileName: "Rank 2")
        setupLottieAnimation(view: viewThirdUserOutlet, animationFileName: "Lv3 - 1")
        
    }
    
    func setupLottieAnimation(view: UIView, animationFileName: String) {
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.frame = view.bounds
        view.addSubview(animationView)

        animationView.animation = LottieAnimation.named(animationFileName)
        animationView.loopMode = .loop
        animationView.play()
        animationView.isUserInteractionEnabled = false
        
    }
    
    @IBAction func viewFirstUserPressed(_ sender: Any) {
        
        print("First User Button Pressed")
        delegate?.viewClicked(index: 0)
        
    }
    
    @IBAction func viewSecondUserPressed(_ sender: Any) {
      
        print("Second User Button Pressed")
        delegate?.viewClicked(index: 1)
        
    }
    
    @IBAction func viewThirdUserPressed(_ sender: Any) {
        
        print("Third User Button Pressed")
        delegate?.viewClicked(index: 2)
        
    }
    
    func configure(with users: [dailyWeeklyResult], interval:String) {
        guard users.count >= 3 else {
            // Handle the case where the array does not have enough elements
            return
        }

        for (index, user) in users.prefix(3).enumerated() {
            // Configure UI elements based on index (0, 1, 2)
            if let profileImages = user.profileImages, !profileImages.isEmpty {
                let profileImageModel = profileImages[0] as dailyWeeklyProfileImage
                let imageView = [imgViewFirstUser, imgViewSecondUser, imgViewThirdUser][index]

                // Assuming you are using Kingfisher for image loading
                imageView?.kf.setImage(with: URL(string: profileImageModel.imageName ?? ""))
            }

            let levelLabel = [lblFirstUserLevel, lblSecondUserLevel, lblThirdUserLevel][index]
            let nameLabel = [lblFirstUserName, lblSecondUserName, lblThirdUserName][index]
            let totalBeansLabel = [lblFirstUserBeans, lblSecondUserBeans, lblThirdUserBeans][index]

            levelLabel?.text = String(format: "Lv%i", user.charmLevel ?? 0)
      //      levelLabel?.text = String(user.charmLevel ?? 0)
            nameLabel?.text = user.name

            let format = NumberFormatter()
            format.numberStyle = .decimal
            if (interval == "daily") {
                let dailyCoin = format.string(from: NSNumber(value: user.dailyEarningBeans ?? 0))
                totalBeansLabel?.text = dailyCoin
            } else {
                let dailyCoin = format.string(from: NSNumber(value: user.weeklyEarningBeans ?? 0))
                totalBeansLabel?.text = dailyCoin
            }
            
        }
    }
    
}
