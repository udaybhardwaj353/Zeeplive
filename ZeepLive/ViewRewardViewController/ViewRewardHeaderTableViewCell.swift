//
//  ViewRewardHeaderTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/01/24.
//

import UIKit
import Lottie

protocol delegateViewRewardHeaderTableViewCell: AnyObject {

    func viewClicked(index:Int)
    
}

class ViewRewardHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewFirstPlace: UIImageView!
    @IBOutlet weak var imgViewSecondPlace: UIImageView!
    @IBOutlet weak var imgViewThirdPlace: UIImageView!
    @IBOutlet weak var lblFirstUserLevel: UILabel!
    @IBOutlet weak var lblSecondUserLevel: UILabel!
    @IBOutlet weak var lblThirdUserLevel: UILabel!
    @IBOutlet weak var viewFirstUser: UIView!
    @IBOutlet weak var viewSecondUser: UIView!
    @IBOutlet weak var viewThirdUser: UIView!
    @IBOutlet weak var lblFirstUserName: UILabel!
    @IBOutlet weak var lblSecondUserName: UILabel!
    @IBOutlet weak var lblThirdUserName: UILabel!
    @IBOutlet weak var viewFirstUserTotalBeans: UIView!
    @IBOutlet weak var viewSecondUserTotalBeans: UIView!
    @IBOutlet weak var viewThirdUserTotalBeans: UIView!
    @IBOutlet weak var lblFirstUserTotalBeans: UILabel!
    @IBOutlet weak var lblSecondUserTotalBeans: UILabel!
    @IBOutlet weak var lblThirdUserTotalBeans: UILabel!
//    @IBOutlet weak var viewFirstAnimation: UIButton!
//    @IBOutlet weak var viewSecondAnimation: UIButton!
//    @IBOutlet weak var viewThirdAnimation: UIButton!
    @IBOutlet weak var viewLevelFirst: UIView!
    @IBOutlet weak var viewLevelSecond: UIView!
    @IBOutlet weak var viewLevelThird: UIView!
    @IBOutlet weak var viewFirstAnimation: UIButton!
    @IBOutlet weak var viewSecondAnimation: UIButton!
    @IBOutlet weak var viewThirdAnimation: UIButton!
    
    weak var delegate: delegateViewRewardHeaderTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        viewFirstAnimation.isUserInteractionEnabled = true
        viewSecondAnimation.isUserInteractionEnabled = true
        viewThirdAnimation.isUserInteractionEnabled = true
        viewFirstAnimation.isEnabled = true
        viewSecondAnimation.isEnabled = true
        viewThirdAnimation.isEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewFirstAnimationPressed(_ sender: UIButton) {
        
        print("Pehla Wale user ka index click hua hai")
        delegate?.viewClicked(index: 0)
        
    }
    
    @IBAction func viewSecondAnimationPressed(_ sender: UIButton) {
        
        print("Doosre wale user ka index click hua hai")
        delegate?.viewClicked(index: 1)
        
    }
    
    @IBAction func viewThirdAnimationPressed(_ sender: UIButton) {
        
        print("Teesra wale user ka index click hua hai")
        delegate?.viewClicked(index: 2)
        
    }
    
    func configureUI() {
        
        imgViewFirstPlace.layer.cornerRadius = imgViewFirstPlace.frame.height / 2
        imgViewSecondPlace.layer.cornerRadius = imgViewSecondPlace.frame.height / 2
        imgViewThirdPlace.layer.cornerRadius = imgViewThirdPlace.frame.height / 2
        
        imgViewFirstPlace.clipsToBounds = true
        imgViewSecondPlace.clipsToBounds = true
        imgViewThirdPlace.clipsToBounds = true
        
        configureAnimationUI(animationName: "Lv3", in: viewFirstAnimation, increaseSize: 40.0, xOffset: 19.0)
        configureAnimationUI(animationName: "Rank 2", in: viewSecondAnimation, increaseSize: 40.0, xOffset: 19.0)
        configureAnimationUI(animationName: "Lv3 - 1", in: viewThirdAnimation, increaseSize: 40.0, xOffset: 19.0)
        
        //        configureAnimationUI(animationName: "Lv3 - 1", in: viewThirdAnimation, width: 100, height: 100)
        //        configureAnimationUI(animationName: "Lv3", in: viewFirstAnimation, width: 100, height: 100)
        //        configureAnimationUI(animationName: "Rank 2", in: viewSecondAnimation, width: 100, height: 100)
                
        //        configureAnimationUI(animationName: "Lv3 - 1", in: viewThirdAnimation)
        //        configureAnimationUI(animationName: "Lv3", in: viewFirstAnimation)
        //        configureAnimationUI(animationName: "Rank 2", in: viewSecondAnimation)
                
             //   configureAnimationUI(animationName: "Lv3", in: viewFirstAnimation, increaseSize: 50.0)
        
    }

    func configureAnimationUI(animationName: String, in animationView: UIView, increaseSize: CGFloat = 0.0, xOffset: CGFloat = 0.0) {
        let lottieAnimationView = LottieAnimationView()
        lottieAnimationView.contentMode = .scaleToFill

        // Calculate the new frame with an increase in size and leftward shift
        let newSize = CGSize(width: animationView.bounds.width + increaseSize,
                             height: animationView.bounds.height + increaseSize)
        
        let newX = animationView.bounds.origin.x - xOffset
        lottieAnimationView.frame = CGRect(origin: CGPoint(x: newX, y: animationView.bounds.origin.y - 18),
                                           size: newSize)
        
        animationView.addSubview(lottieAnimationView)

        lottieAnimationView.animation = LottieAnimation.named(animationName)
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
        lottieAnimationView.isUserInteractionEnabled = false

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
                let imageView = [imgViewFirstPlace, imgViewSecondPlace, imgViewThirdPlace][index]

                // Assuming you are using Kingfisher for image loading
                imageView?.kf.setImage(with: URL(string: profileImageModel.imageName ?? ""))
            }

            let levelLabel = [lblFirstUserLevel, lblSecondUserLevel, lblThirdUserLevel][index]
            let nameLabel = [lblFirstUserName, lblSecondUserName, lblThirdUserName][index]
            let totalBeansLabel = [lblFirstUserTotalBeans, lblSecondUserTotalBeans, lblThirdUserTotalBeans][index]

//            levelLabel?.text = String(format: "Lv%i", user.charmLevel ?? 0)
            levelLabel?.text = String(user.charmLevel ?? 0)
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
//            let dailyCoin = format.string(from: NSNumber(value: user.dailyEarningBeans ?? 0))
//            totalBeansLabel?.text = dailyCoin
            
//            let width = (nameLabel?.intrinsicContentSize.width ?? 0) + 100
//                   let userView = [viewFirstUser, viewSecondUser, viewThirdUser][index]
//            userView?.widthAnchor.constraint(equalToConstant: width ?? 90).isActive = true
            
        }
    }

    
}


//    func configureAnimationUI(animationName: String, in animationView: UIView) {
//        let lottieAnimationView = LottieAnimationView()
//        lottieAnimationView.contentMode = .scaleToFill
//        lottieAnimationView.frame = animationView.bounds
//        animationView.addSubview(lottieAnimationView)
//
//        lottieAnimationView.animation = LottieAnimation.named(animationName)
//        lottieAnimationView.loopMode = .loop
//        lottieAnimationView.play()
//    }

//    func configureAnimationUI(animationName: String, in animationView: UIView, width: CGFloat, height: CGFloat) {
//        let lottieAnimationView = LottieAnimationView()
//        lottieAnimationView.contentMode = .scaleToFill
//        lottieAnimationView.frame = CGRect(x: 0, y: 0, width: width, height: height)
//        animationView.addSubview(lottieAnimationView)
//
//        lottieAnimationView.animation = LottieAnimation.named(animationName)
//        lottieAnimationView.loopMode = .loop
//        lottieAnimationView.play()
//    }


//    func configureAnimationUI(animationName: String, in animationView: UIView, increaseSize: CGFloat = 0.0) {
//        let lottieAnimationView = LottieAnimationView()
//        lottieAnimationView.contentMode = .scaleToFill
//
//        // Calculate the new frame with an increase in size
//        let newSize = CGSize(width: animationView.bounds.width + increaseSize,
//                             height: animationView.bounds.height + increaseSize)
//
//        lottieAnimationView.frame = CGRect(origin: animationView.bounds.origin, size: newSize)
//        animationView.addSubview(lottieAnimationView)
//
//        lottieAnimationView.animation = LottieAnimation.named(animationName)
//        lottieAnimationView.loopMode = .loop
//        lottieAnimationView.play()
//    }
