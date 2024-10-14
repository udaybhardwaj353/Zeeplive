//
//  ShowAllGiftsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 03/04/24.
//

import UIKit

class ShowAllGiftsViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var giftDetails = [giftRecievedResult]()
    lazy var userID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewWork()
        getGiftDetails()
        
    }
    
    func collectionViewWork() {
    
        collectionView.register(UINib(nibName: "GiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GiftCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed In Show All Gift View Controller.")
       // navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension ShowAllGiftsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

extension ShowAllGiftsViewController {
    
       func getGiftDetails() {
           
           let url = AllUrls.baseUrl + "get-gift-count?id=\(userID)" //"https://zeep.live/api/get-gift-count-latest?id=32314422"//AllUrls.baseUrl + "get-gift-count?id=\(userId)"
           print(url)
           
           ApiWrapper.sharedManager().getGiftRecievedList(url: url) { [weak self] (data, value) in
               guard let self = self else { return }
           
               giftDetails = data ?? []
               print(giftDetails)
               collectionView.reloadData()
               
           }
       }
    
}
