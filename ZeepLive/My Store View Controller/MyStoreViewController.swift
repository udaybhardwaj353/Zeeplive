//
//  MyStoreViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 30/06/23.
//

import UIKit
import Kingfisher
import FittedSheets
import BDAlphaPlayer
import Alamofire

class MyStoreViewController: UIViewController, BDAlphaPlayerMetalViewDelegate {

    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnStoreOutlet: UIButton!
    @IBOutlet weak var btnMineOutlet: UIButton!
    @IBOutlet weak var viewEntranceEffectOutlet: UIControl!
    @IBOutlet weak var viewThemeOutlet: UIControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblEntranceEffect: UILabel!
    @IBOutlet weak var lblTheme: UILabel!
    
    lazy var storesCategory = [myStoreCategoryResult]()
    lazy var storeCategory: String = "Store"
    lazy var storeType: String = "Entrance Effect"
    
    weak var sheetController:SheetViewController!
    
    var metalView: BDAlphaPlayerMetalView?
//    let fileURLString = "https://imgzeeplive.oss-ap-south-1.aliyuncs.com/zeepliveStoreImagesAnimation/2023/06/05/1685917898.mp4"
    let configurations = BDAlphaPlayerMetalConfiguration.default()
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let group = DispatchGroup()
    var fileURLString: String =  "https://imgzeeplive.oss-ap-south-1.aliyuncs.com/zeepliveStoreImagesAnimation/2023/06/05/1685917898.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
      //  let configuration = BDAlphaPlayerMetalConfiguration.default()
//        configurations.renderSuperViewFrame = self.view.frame
//        configurations.orientation = .landscape
//        metalView = BDAlphaPlayerMetalView(delegate: self)
//
      //  downloadFile()
        configureUI()
        getStoreCategories()
       
        let token = UserDefaults.standard.string(forKey: "token")
        print(token)
        
        let currentTimestamp = Date().timeIntervalSince1970
        print("Current timestamp: \(currentTimestamp)")
       
    }
    
    private func configureUI() {
    
        viewEntranceEffectOutlet.layer.cornerRadius = 13
        viewThemeOutlet.layer.cornerRadius = 13
        
        viewMain.backgroundColor = GlobalClass.sharedInstance.setMyStoreViewColour()
        viewEntranceEffectOutlet.backgroundColor = GlobalClass.sharedInstance.setMyStoreOptionsBackgroundColour()
        viewThemeOutlet.backgroundColor = GlobalClass.sharedInstance.setMyStoreOptionsBackgroundColour()
        
        collectionView.register(UINib(nibName: "EntranceEffectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EntranceEffectCollectionViewCell")
        collectionView.delegate = self  
        collectionView.dataSource = self
        
        btnMineOutlet.setTitleColor(GlobalClass.sharedInstance.setMyStoreSelectedOptionColour(), for: .normal)
        btnStoreOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        btnMineOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        lblTheme.textColor = GlobalClass.sharedInstance.setMyStoreSelectedOptionColour()
        viewThemeOutlet.isHidden = true
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        
        print("Back Button Pressed")
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    @IBAction func btnStorePressed(_ sender: Any) {
        
        print("Button Store Pressed")
        btnStoreOutlet.setTitleColor(.white, for: .normal)
        btnMineOutlet.setTitleColor(GlobalClass.sharedInstance.setMyStoreSelectedOptionColour(), for: .normal)
        btnStoreOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        btnMineOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        storeCategory = "Store"
        collectionView.reloadData()
        
    }
    
    @IBAction func btnMinePressed(_ sender: Any) {
        
        print("Button Mine Pressed")
        btnMineOutlet.setTitleColor(.white, for: .normal)
        btnStoreOutlet.setTitleColor(GlobalClass.sharedInstance.setMyStoreSelectedOptionColour(), for: .normal)
        btnMineOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        btnStoreOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        storeCategory = "Mine"
        collectionView.reloadData()
        
    }
    
    @IBAction func viewEntranceEffectPressed(_ sender: Any) {
        
        print("View Entrance Effect Pressed")
        lblEntranceEffect.textColor = .white
        lblTheme.textColor = GlobalClass.sharedInstance.setMyStoreSelectedOptionColour()
        storeType = "Entrance Effect"
        collectionView.reloadData()
    }
    
    @IBAction func viewThemePressed(_ sender: Any) {
        
        print("View Theme Pressed")
        lblTheme.textColor = .white
        lblEntranceEffect.textColor = GlobalClass.sharedInstance.setMyStoreSelectedOptionColour()
        storeType = "Theme"
        collectionView.reloadData()
    }
    
}


extension MyStoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - COLLECTION VIEW FUNCTIONS TO SET VALUES IN THE COLLECTION VIEW CELL AND SHOW DATA TO THE USER
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (storesCategory.count == 0) || (storesCategory == nil) {
            
            print("kch bhi nahi hai")
            return 0
        } else {
            if (storeCategory == "Store") {
                if (storeType == "Entrance Effect" ) {
                    return storesCategory[0].stores?.count ?? 0
                } else {
                    
                    if storesCategory.indices.contains(1), let stores = storesCategory[1].stores {
                        
                        return storesCategory[1].stores?.count ?? 0
                        
                    } else {
                        
                        return 0
                        
                    }
                    
                }
            } else {
                
                return 0
                // return storesCategory[1].stores?.count ?? 0
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if storeCategory == "Store" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EntranceEffectCollectionViewCell", for: indexPath) as! EntranceEffectCollectionViewCell
            
            if storeType == "Entrance Effect" {
                cell.lblGiftName.text = storesCategory[0].stores?[indexPath.row].storeName
                cell.lblGiftPrice.text = String(storesCategory[0].stores?[indexPath.row].storeplan?[0].coin ?? 0)
                
                //                let imageURL = URL(string: storesCategory[0].stores?[indexPath.row].image ?? " ")!
                //                downloadImage(from: imageURL, into: cell.imgView)
                
                if let profileImageURL = URL(string: storesCategory[0].stores?[indexPath.row].image ?? " ") {
                    KF.url(profileImageURL)
                       // .downsampling(size: CGSize(width: 400, height: 400))
                        .cacheOriginalImage()
                        .onSuccess { result in
                            DispatchQueue.main.async {
                                cell.imgView.image = result.image
                            }
                        }
                        .onFailure { error in
                            print("Image loading failed with error: \(error)")
                            cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
                        }
                        .set(to: cell.imgView)
                } else {
                    cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
                }
                
            } else {
                
                print("dekhte hai")
                cell.lblGiftName.text = storesCategory[1].stores?[indexPath.row].storeName
                cell.lblGiftPrice.text = String(storesCategory[1].stores?[indexPath.row].storeplan?[0].coin ?? 0)
                
                //                let imageURL = URL(string: storesCategory[1].stores?[indexPath.row].image ?? " ")!
                //                downloadImage(from: imageURL, into: cell.imgView)
                
                if let profileImageURL = URL(string: storesCategory[1].stores?[indexPath.row].image ?? " ") {
                    KF.url(profileImageURL)
                      //  .downsampling(size: CGSize(width: 400, height: 400))
                        .cacheOriginalImage()
                        .onSuccess { result in
                            DispatchQueue.main.async {
                                cell.imgView.image = result.image
                            }
                        }
                        .onFailure { error in
                            print("Image loading failed with error: \(error)")
                            cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
                        }
                        .set(to: cell.imgView)
                } else {
                    cell.imgView.image = UIImage(named: "UserPlaceHolderImageForCell")
                }
                
            }
            return cell
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (storeCategory == "Store") {
            
            if storeType == "Entrance Effect" {
                
                let width = (collectionView.frame.size.width - 5 * 2 ) / 2 //(372) / 2
                let height = width  + 60 //ratio
                return CGSize(width: width, height: height)
            } else {
                
                let width = (collectionView.frame.size.width - 5 * 2 ) / 2 //(372) / 2
                let height = width  + 160 //ratio
                return CGSize(width: width, height: height)
                
            }
            
            
        } else {
            
            let width = (collectionView.frame.size.width - 6 * 2 ) / 2 //(372) / 2
            let height = width  + 160 //ratio
            return CGSize(width: width, height: height)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let mp4Path = documentsUrl.appendingPathComponent(String(format: "gift/%d/", storesCategory[0].stores?[indexPath.row].id ?? 0))
        print("The mp4Path is : \(mp4Path)")
        
        metalView = BDAlphaPlayerMetalView(delegate: self)
        
        metalView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(metalView!)
        
        let configuration = BDAlphaPlayerMetalConfiguration()
        configuration.directory = mp4Path.path
        configuration.renderSuperViewFrame = self.view.frame
        configuration.orientation = .portrait;
        
        metalView?.play(with: configuration)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyStoreCategoryPricesViewController") as! MyStoreCategoryPricesViewController
        if (storeCategory == "Store") {
          
            if (storeType == "Entrance Effect") {
                
                vc.storeplan = storesCategory[0].stores?[indexPath.row].storeplan
                vc.giftName = storesCategory[0].stores?[indexPath.row].storeName ?? "No Name"
                
            } else {
                
                vc.storeplan = storesCategory[1].stores?[indexPath.row].storeplan
                vc.giftName = storesCategory[1].stores?[indexPath.row].storeName ?? "No Name"
                
            }
            
        }
        
        
        let options = SheetOptions(
            useInlineMode: true
        )
        
        sheetController = SheetViewController(controller: vc, sizes: [.fixed(200), .fixed(200)], options: options)
//        sheetController.shouldDismiss = { _ in
//        // This is called just before the sheet is dismissed. Return false to prevent the build in dismiss events
//            print("Sheet ko bnd ho jaana chahiye")
//            return true
//        }
//        sheetController.didDismiss = { _ in
//            // This is called after the sheet is dismissed
//            print("sheet band ho gayi hai")
//        }
        
       // sheetController.cornerRadius = 40
        
        sheetController?.allowPullingPastMaxHeight = false

        sheetController.allowGestureThroughOverlay = false
        sheetController.dismissOnPull = true

        sheetController.animateIn(to: view, in: self)
        
    }

    func metalView(_ metalView: BDAlphaPlayerMetalView, didFinishPlayingWithError error: Error?) {
           if let error = error {
               print(error.localizedDescription)
           } else {
               metalView.removeFromSuperview()
           }
        metalView.removeFromSuperview()
       }
    
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM THE SERVER

extension MyStoreViewController {
    
    func getStoreCategories() {
        
        ApiWrapper.sharedManager().getStoreCategories(url: AllUrls.getUrl.getStoreCategoryList) { [weak self] (data, value) in
            guard let self = self else { return }
        
            storesCategory = data ?? storesCategory
            print(storesCategory)
            print(storesCategory.count)
          
            print("THe stores category count is: \(storesCategory[0].stores?.count)")
            
            DispatchQueue.main.async {
                
                for i in 0..<(self.storesCategory[0].stores?.count ?? 0) {
                    
                    self.fileURLString = self.storesCategory[0].stores?[i].animationFile ?? ""
                    print("THe file url is: \(self.fileURLString)")
                    print("The gift id is: \(self.storesCategory[0].stores?[i].id ?? 0)")
                    let giftId = self.storesCategory[0].stores?[i].id ?? 0
                    self.animation(fileUrl: self.fileURLString, id: giftId)
                }
            }
            collectionView.reloadData()
            
        }
    }
}

extension MyStoreViewController {
    
    
    func animation(fileUrl:String , id:Int) {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        var giftFilePath = documentsUrl.appendingPathComponent(String(format: "gift/%d", id))
        
        do{
            if !FileManager.default.fileExists(atPath: giftFilePath.path) {
               try FileManager.default.createDirectory(at: giftFilePath, withIntermediateDirectories: true, attributes: nil)
            }
        }catch{
            
        }
        
        giftFilePath = giftFilePath.appendingPathComponent(String(format: "%d.%@", id, "mp4"))
        print("The gift file path is: \(giftFilePath)")
        
       downloadFile(fileURL: URL(string: fileURLString)!, destinationURL: giftFilePath) { result in
                print(result)
            
           let fileName = String(format: "%d.mp4", id)
           let portMap = ["align" : 2,"path":fileName] as [String : Any]
           let landMap = ["align" : 8,"path":fileName] as [String : Any]
           let map = ["portrait":portMap,"landscape":landMap]
           
           if let jsonData = try? JSONSerialization.data(withJSONObject: map, options: []) {
               let jsonString = String(data: jsonData, encoding: .utf8)
               print("The json string is: \(jsonString)")
               
               var configFilePath = documentsUrl.appendingPathComponent(String(format: "gift/%d/config.json", id))
               do {
                   
                   try jsonString!.write(to: configFilePath, atomically: false, encoding: .utf8)
                   print(configFilePath)
                   print("The config file path is: \(configFilePath)")
                   
                   }catch {
                       print("Error: \(error)")
                   }
           }
           
            }
    }
    
}

extension MyStoreViewController {
    
    func isFileExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    func isDirectoryExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        return fileManager.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    
    
    func downloadFile(fileURL: URL, destinationURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(fileURL, to: destination).response { response in
            if let error = response.error {
                completion(.failure(error))
            } else if let destinationURL = response.fileURL {
                print("the distination url is: \(destinationURL)")
                completion(.success(destinationURL))
            } else {
                completion(.failure(NSError(domain: "Download Error", code: 0, userInfo: nil)))
            }
        }
    }
    
}
