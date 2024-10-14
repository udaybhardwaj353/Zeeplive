//
//  MyStoreCategoryPricesViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/07/23.
//

import UIKit

class MyStoreCategoryPricesViewController: UIViewController {

    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var lblGiftName: UILabel!
    @IBOutlet weak var lblGiftAmount: UILabel!
    @IBOutlet weak var btnBuyOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var selectedIndex: Int = 0
    lazy var storeplan: [Storeplan]? = []
    lazy var giftName: String = "Gift Name"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBuyOutlet.layer.cornerRadius = 20
        
        viewMain.backgroundColor = GlobalClass.sharedInstance.setMyStoreOptionsBackgroundColour()
        print(storeplan)
        print(giftName)
        
        lblGiftName.text = giftName
        lblGiftAmount.text = String(storeplan?[0].coin ?? 0)
        collectionView.register(UINib(nibName: "MyStoreCategoryPlanDaysCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyStoreCategoryPlanDaysCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        addGradient(to: btnBuyOutlet, width: btnBuyOutlet.frame.width, height: btnBuyOutlet.frame.height, cornerRadius: btnBuyOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
    }
    
    @IBAction func btnBuyPressed(_ sender: Any) {
        
        print("Button Buy Gift Pressed")
        
    }
    
}

extension MyStoreCategoryPricesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
 // MARK: - COLLECTION VIEW FUNCTIONS TO SET VALUES IN THE COLLECTION VIEW CELL AND SHOW DATA TO THE USER
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return storeplan?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyStoreCategoryPlanDaysCollectionViewCell", for: indexPath) as! MyStoreCategoryPlanDaysCollectionViewCell
      
        let a: Int = storeplan?[indexPath.item].validityInDays ?? 0
        var b : String = String(a)
        
        if indexPath.row == selectedIndex {
            
            cell.imgView.image = UIImage(named: "OptionSelected")
        } else {
        
            cell.imgView.image = UIImage(named: "OptionUnselected")
        }
        
        cell.lblNoOfDays.text = b + " Days"
      //  cell.lblNoOfDays.text = String(describing: storeplan?[indexPath.item].validityInDays) + " " + "days"

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (self.collectionView.frame.size.width - 4 * 2 ) / 3 //(372) / 2
            let height = width + 20 //ratio
        print("The width is: \(width)")
        print("The Height is: \(height)")
        if (width <= 0) {
            return CGSize(width: 115, height: 40)
           // return CGSize(width: 100, height: 40)
        } else {
            return CGSize(width: width, height: 40)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numberOfCellsPerRow: CGFloat = 3
//        let spacingBetweenCells: CGFloat = 4
//
//        let totalSpacing = (numberOfCellsPerRow - 1) * spacingBetweenCells
//        let availableWidth = collectionView.frame.width - totalSpacing
//        let cellWidth = availableWidth / numberOfCellsPerRow
//
//        let cellHeight: CGFloat = cellWidth + 20 // Adjust the additional height as needed
//
//        // Ensure the calculated size is always positive
//        let width = max(cellWidth, 0)
//        let height = max(cellHeight, 0)
//
//        return CGSize(width: width, height: height)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        lblGiftAmount.text = String(storeplan?[indexPath.row].coin ?? 0)
        selectedIndex = indexPath.row
        
        collectionView.reloadData()
        
    }

}
