//
//  GameViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/09/23.
//

import UIKit

class GameViewController: UIViewController, delegateGameCollectionViewCell {
 
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgViewTopBackground: UIImageView!
    @IBOutlet weak var viewHeaderTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var lblTopHeading: UILabel!
    
    @IBOutlet weak var viewUserInformation: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserCoins: UILabel!
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var arrGameNames = [String]()
    lazy var arrGameImages = [String]()
    lazy var arrGameBackgroundImages = [String]()
    lazy var arrNextPageBackgroundImage = [String]()
    lazy var userWalletPoints = walletPurchasePointsResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        configureUI()
        registerCollectionView()
        getWalletPoints()
        
    }
    
    func configureUI() {
        
        lblUserName.text = (UserDefaults.standard.string(forKey: "UserName") ?? "")
        
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.width / 2
        imgViewUserPhoto.clipsToBounds = true
        
        viewUserInformation.roundCorners(corners: [.topRight, .bottomRight], radius: viewUserInformation.frame.height/2)
        viewUserInformation.backgroundColor = .white.withAlphaComponent(0.3)
        
        arrGameNames = ["Thimbles", "ZEEPLIVE RACE", "LUCKY WHEEL", "HORSE RACE"]
        arrGameImages = ["Group 956", "zeep_live_race", "lucky_wheel", "horse_race"]
        arrGameBackgroundImages = ["ludo bg", "zeeplive_race_bg", "lucky_wheel_bg", "horse_race_bg"]
        arrNextPageBackgroundImage = ["Thimbles_bg", "ZeepLive_race", "Mask Group 14", "Mask Group 13"]
        
        if let profilePictureURLString = UserDefaults.standard.string(forKey: "profilePicture"),
                let imageURL = URL(string: profilePictureURLString) {
            downloadImage(from: imageURL, into: imgViewUserPhoto)
             } else {
                 
                 imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
             }
    }
    
    func registerCollectionView() {
    
        collectionView.register(UINib(nibName: "GameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GameCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderViewIdentifier")
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

// MARK: - EXTENSION FOR USING COLLECTION VIEW DELEGATES AND METHODS TO SHOW DATA AND TO SHOW HEADER LABEL

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - FUNCTION TO GIVE HEIGHT OF HEADER VIEW
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            
                return CGSize(width: collectionView.bounds.width, height: 50.0)
           
        }
     
     // MARK: - FUNCTION TO SHOW HEADER VIEW AND REGISTER IT
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
                if kind == UICollectionView.elementKindSectionHeader {
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderViewIdentifier", for: indexPath)
                    
                    // Customize the section header view
                    headerView.backgroundColor = UIColor.white
                    
                    // Create a label and set the title for the section header
                    let titleLabel = UILabel(frame: headerView.bounds)
                    titleLabel.text = "ALL GAMES"
                    titleLabel.textAlignment = .left
                    titleLabel.textColor = UIColor.darkGray
                    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
                    // Add the label to the section header view
                    headerView.addSubview(titleLabel)
                    
                    return headerView
                }
                
                return UICollectionReusableView()
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
       
        cell.lblGameName.text = arrGameNames[indexPath.row]
        cell.imgViewBackground.image = UIImage(named: arrGameBackgroundImages[indexPath.row])
        cell.imgViewGame.image = UIImage(named: arrGameImages[indexPath.row])
        
        cell.delegate = self
        cell.btnPlayNowOutlet.tag = indexPath.row
        return cell
        
        }
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 8 * 2 ) / 2 //(372) / 2
            let height = width  + 40 //ratio
            return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PlayGameViewController") as! PlayGameViewController
        nextViewController.imageName = arrNextPageBackgroundImage[indexPath.item]
        nextViewController.index = indexPath.item
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
 
  // MARK: - DELEGATE FUNCTION TO KNOW WHICH BUTTON IS PRESSED FOR PLAYING GAME
    
    func buttonClicked(index: Int) {
        print(index)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PlayGameViewController") as! PlayGameViewController
        nextViewController.imageName = arrNextPageBackgroundImage[index]
        nextViewController.index = index
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
}


extension GameViewController {
    
    func getWalletPoints() {
           
        
        ApiWrapper.sharedManager().getUserWalletPurchasePoints(url: AllUrls.getUrl.getuserWalletPoints) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            userWalletPoints = data ?? userWalletPoints
            print("The user wallet details are: \(userWalletPoints)")
            print("The user wallet points details are: \(userWalletPoints.purchasePoints)")
            lblUserCoins.text = String(userWalletPoints.purchasePoints ?? 0)
        }
    }
    
}
