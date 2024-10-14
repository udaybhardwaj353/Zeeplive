//
//  NewProfileInfoViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/04/24.
//

import UIKit
import Kingfisher

class NewProfileInfoViewController: UIViewController {

    @IBOutlet weak var viewLevels: UIView!
    @IBOutlet weak var viewRichLevel: UIView!
    @IBOutlet weak var imgViewRichLevel: UIImageView!
    @IBOutlet weak var lblRichLevel: UILabel!
    @IBOutlet weak var viewCharmLevel: UIView!
    @IBOutlet weak var imgViewCharmLevel: UIImageView!
    @IBOutlet weak var lblCharmLevel: UILabel!
    @IBOutlet weak var viewStarFans: UIView!
    @IBOutlet weak var btnViewAllGiftRecievedOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblGiftRecieved: UILabel!
    
    lazy var giftDetails = [giftRecievedResult]()
    lazy var userID = String()
    lazy var richLevel: Int = 0
    lazy var charmLevel: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("The user id we are gettign is: \(userID)")
        getGiftDetails()
       collectionViewWork()
        setData()
    }
    
    @IBAction func btnViewAllGiftRecievedPressed(_ sender: Any) {
        
        print("Button View All Gift Recieved List Pressed.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShowAllGiftsViewController") as! ShowAllGiftsViewController
        nextViewController.userID = userID
    //    nextViewController.modalPresentationStyle = .fullScreen
        
        self.present(nextViewController, animated: true, completion: nil)
        
       // self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    func collectionViewWork() {
    
        collectionView.register(UINib(nibName: "GiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func setData() {
    
        lblRichLevel.text = "Lv." + " " + String(richLevel)
        lblCharmLevel.text = "Lv." + " " + String(charmLevel)
        
    }
    
    func hideViews() {
    
        lblGiftRecieved.isHidden = true
        btnViewAllGiftRecievedOutlet.isHidden = true
        
    }
    
    func unHideViews() {
    
        lblGiftRecieved.isHidden = false
        btnViewAllGiftRecievedOutlet.isHidden = false
        
    }
    
}

extension NewProfileInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return giftDetails.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCollectionViewCell", for: indexPath) as! GiftCollectionViewCell
            
            
            cell.lblNoOfGifts.text = "x" + " " + String(giftDetails[indexPath.row].total ?? 0)
            cell.viewMain.backgroundColor = GlobalClass.sharedInstance.setGiftsBackgroundColour()
        
            loadImage(from: giftDetails[indexPath.row].giftDetails?.image ?? "", into: cell.imgViewGift)
            
            return cell
            
        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.size.width ) / 3
            let height : CGFloat = 120
        print("Calculated Cell Width: \(width)")
            return CGSize(width: width, height: height)
            
        
    }
   
    
extension NewProfileInfoViewController {
    
       func getGiftDetails() {
           
           let url = AllUrls.baseUrl + "get-gift-count-latest?id=\(userID)" //"https://zeep.live/api/get-gift-count-latest?id=32314422"//AllUrls.baseUrl + "get-gift-count?id=\(userId)"
           print(url)
           
           ApiWrapper.sharedManager().getGiftRecievedList(url: url) { [weak self] (data, value) in
               guard let self = self else { return }
           
               giftDetails = data ?? []
               print(giftDetails)
               collectionView.reloadData()
               
               if (giftDetails.count <= 0) {
                   hideViews()
               } else {
                   unHideViews()
               }
           }
       }
    
}

//            if let profileImageURL = URL(string: giftDetails[indexPath.row].giftDetails?.image ?? "") {
//                KF.url(profileImageURL)
//                    .downsampling(size: CGSize(width: 300, height: 300))
//                    .cacheOriginalImage()
//                    .onSuccess { result in
//                        DispatchQueue.main.async {
//                            cell.imgViewGift.image = result.image
//                        }
//                    }
//                    .onFailure { error in
//                        print("Image loading failed with error: \(error)")
//                        cell.imgViewGift.image = UIImage(named: "GiftImage")
//                    }
//                    .set(to: cell.imgViewGift)
//            } else {
//                cell.imgViewGift.image = UIImage(named: "GiftImage")
//            }
