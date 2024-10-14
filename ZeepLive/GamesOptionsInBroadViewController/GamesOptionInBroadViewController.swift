//
//  GamesOptionInBroadViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/02/24.
//

import UIKit

protocol delegateGamesOptionInBroadViewController: AnyObject {
    
    func gameClicked(url:String)
    
}

class GamesOptionInBroadViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    lazy var arrGameNames = [String]()
    lazy var arrGameImages = [String]()
    lazy var arrGameUrl: [String] = []
    lazy var url: String = ""
    weak var delegate: delegateGamesOptionInBroadViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = GlobalClass.sharedInstance.setGameBelowViewBackgroundColour()
        checkForGames()
        registerCollectionView()
        
    }
    
    func registerCollectionView() {
    
        collectionView.register(UINib(nibName: "GamesOptionInBroadCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GamesOptionInBroadCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func checkForGames() {
        let id = UserDefaults.standard.string(forKey: "userId")
        
        if let settings = SettingsManager.shared.storeSettingResponse {
            let masterGameSetting = getSettingValue(forKey: "master_game", settings: settings)
            let horseRaceSetting = getSettingValue(forKey: "horse_race", settings: settings)
            let luckyWheelSetting = getSettingValue(forKey: "lucky_wheel", settings: settings)
            let zeepliveRaceSetting = getSettingValue(forKey: "zeeplive_race", settings: settings)
            let thimblesGameSetting = getSettingValue(forKey: "thimbles_game", settings: settings)

            // You can now use the returned values as needed
            if (masterGameSetting.value == "1") {
                print("Saare game dikhane hai.")
                
                if (horseRaceSetting.value == "1") {
                    print("Horse race wale game ko dikhana hai.")
                    arrGameNames.append("HORSE RACE")
                    arrGameImages.append("horse_race")
                    arrGameUrl.append("https://d1qiq0tjxfnegh.cloudfront.net/games/race_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=102")
                }
                if (luckyWheelSetting.value == "1") {
                    print("Lucky wheel wale game ko dikhana hai ")
                    arrGameNames.append("LUCKY WHEEL")
                    arrGameImages.append("lucky_wheel")
                    arrGameUrl.append("https://d1qiq0tjxfnegh.cloudfront.net/games/wheel_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=103")
                }
                if (zeepliveRaceSetting.value == "1") {
                    print("Zeep Live Car Race wala game dikhana hai")
                    arrGameNames.append("ZEEPLIVE RACE")
                    arrGameImages.append("zeep_live_race")
                    arrGameUrl.append("https://d1qiq0tjxfnegh.cloudfront.net/games/racep_chamet_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=101")
                }
                if (thimblesGameSetting.value == "1") {
                    print("Thimbles wala game dikhana hai")
                    arrGameNames.append("Thimbles")
                    arrGameImages.append("Group 956")
                    arrGameUrl.append("https://d1qiq0tjxfnegh.cloudfront.net/games/thimbles_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=104")
                }
                
            } else {
                print("Ek bhi game nahi dikhane hai.")
            }
            
        } else {
            print("Settings are not available.")
        }
    }
    
}

// MARK: - EXTENSION FOR USING COLLECTION VIEW DELEGATES AND METHODS TO SHOW DATA AND TO SHOW HEADER LABEL

extension GamesOptionInBroadViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrGameNames.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamesOptionInBroadCollectionViewCell", for: indexPath) as! GamesOptionInBroadCollectionViewCell
       
        cell.lblGameName.text = arrGameNames[indexPath.row]
        cell.imgViewGame.image = UIImage(named: arrGameImages[indexPath.row])
        
        return cell
        
        }
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 8 * 2 ) / 4 //(372) / 2
        let height = width + 10 //ratio
        
        if (width <= 0) {
            return CGSize(width: 50, height: 60)
           // return CGSize(width: 100, height: 40)
        } else {
            return CGSize(width: width, height: height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        delegate?.gameClicked(url: arrGameUrl[indexPath.row])
        
    }
    
}


//func checkForGames() {
//
//    if let settings = SettingsManager.shared.storeSettingResponse {
//       
//        let containsMasterGame = settings.contains { $0.settingKey == "master_game" }
//        let containsHorseRace = settings.contains { $0.settingKey == "horse_race" }
//        let containsLuckyWheel = settings.contains { $0.settingKey == "lucky_wheel" }
//        let containsCarRaceGame = settings.contains { $0.settingKey == "zeeplive_race" }
//        let containsThimbleGame = settings.contains { $0.settingKey == "thimbles_game" }
//        
//        if containsMasterGame {
//            print("The setting 'master_game' is present.")
//            
//        } else {
//            print("The setting 'master_game' is not present.")
//        }
//        
//        if containsHorseRace {
//            print("The setting 'horse_race' is present.")
//        } else {
//            print("The setting 'horse_race' is not present.")
//        }
//
//        if containsLuckyWheel {
//            print("The setting 'lucky_wheel' is present.")
//        } else {
//            print("The setting 'lucky_wheel' is not present.")
//        }
//        
//        if containsCarRaceGame {
//            print("The setting 'zeeplive_race' is present.")
//        } else {
//            print("The setting 'zeeplive_race' is not present.")
//        }
//
//        if containsThimbleGame {
//            print("The setting 'thimbles_game' is present.")
//        } else {
//            print("The setting 'thimbles_game' is not present.")
//        }
//        
//    } else {
//        print("Settings are not available.")
//    }
//
//    
//}

//            print("Is 'master_game' present: \(masterGameSetting.isPresent), Value: \(masterGameSetting.value ?? "N/A")")
//            print("Is 'horse_race' present: \(horseRaceSetting.isPresent), Value: \(horseRaceSetting.value ?? "N/A")")
//            print("Is 'lucky_wheel' present: \(luckyWheelSetting.isPresent), Value: \(luckyWheelSetting.value ?? "N/A")")
//            print("Is 'zeeplive_race' present: \(zeepliveRaceSetting.isPresent), Value: \(zeepliveRaceSetting.value ?? "N/A")")
//            print("Is 'thimbles_game' present: \(thimblesGameSetting.isPresent), Value: \(thimblesGameSetting.value ?? "N/A")")

//        arrGameNames = ["Thimbles", "ZEEPLIVE RACE", "LUCKY WHEEL", "HORSE RACE"]
//        arrGameImages = ["Group 956", "zeep_live_race", "lucky_wheel", "horse_race"]
//        arrGameBackgroundImages = ["ludo bg", "zeeplive_race_bg", "lucky_wheel_bg", "horse_race_bg"]
//        arrNextPageBackgroundImage = ["Thimbles_bg", "ZeepLive_race", "Mask Group 14", "Mask Group 13"]

//    func setUrlForWebView(index:Int) -> String {
//        let id = UserDefaults.standard.string(forKey: "userId")
//
//         if index == 0 {
//             url = "https://d1qiq0tjxfnegh.cloudfront.net/games/thimbles_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=104"
//         } else if index == 1 {
//             url = "https://d1qiq0tjxfnegh.cloudfront.net/games/racep_chamet_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=101"
//         } else if index == 2 {
//             url = "https://d1qiq0tjxfnegh.cloudfront.net/games/wheel_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=103"
//         } else if index == 3 {
//             url = "https://d1qiq0tjxfnegh.cloudfront.net/games/race_half/index.html?uid=\(id!)&token=324915792a9d31b633d989a89b83e023&time=1690892591557&gameid=102"
//         }
//        return url
//     }
