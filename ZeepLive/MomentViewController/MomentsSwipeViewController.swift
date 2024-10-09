//
//  MomentsSwipeViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 02/01/24.
//

import UIKit
import TYPagerController
import Kingfisher
import PhotosUI

class MomentsSwipeViewController: UIViewController {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewTabPagerBar: TYTabPagerBar!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnUploadMomentOutlet: UIButton!
    
    lazy var datas: [String] = []
    var pagerController : TYPagerController?
    var selectedImages = [UIImage]()
    lazy var optionSelected: String = ""
    lazy var indexToOpen: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnUploadMomentOutlet.isHidden = true
        configurePageControl()
        loadData()
        setupTabPagerBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        guard let navigationController = navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!) //To remove all previous UIViewController except the last one
        navigationController.viewControllers = navigationArray
        pagerController?.scrollToController(at: indexToOpen, animate: true)
        print("The index To Open is: \(indexToOpen)")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        selectedImages.removeAll()
        
    }
    
    deinit {
        
        print("Moments swipe main deinit call hua hai")
                
               viewTop = nil
               viewTabPagerBar = nil
               viewMain = nil
               datas.removeAll()
               pagerController?.removeFromParent()
               pagerController = nil
        
    }
    
    @IBAction func btnUploadMomentPressed(_ sender: Any) {
        
        print("Buton Upload Moment Pressed.")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UploadMomentOptionsViewController") as! UploadMomentOptionsViewController
      
        nextViewController.delegate = self
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
    }
    
}

extension MomentsSwipeViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate {
    
    func configurePageControl() {
    
            pagerController = TYPagerController()
            pagerController?.dataSource = self
            pagerController?.delegate = self
            
            addChild(pagerController!)
            viewMain.addSubview(pagerController!.view)
            pagerController?.didMove(toParent: self)
            
            pagerController?.view.frame = viewMain.bounds
            pagerController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    func loadData() {
      
        //self.datas = ["Video", "Image", "Following"]
        self.datas = ["Video", "Following"]
        
        self.pagerController?.reloadData()
        self.viewTabPagerBar?.reloadData()
        
    }
    
    func setupTabPagerBar() {

//        self.viewTabPagerBar.layout.barStyle = .progressElasticView
        // Configure other properties as needed

        self.viewTabPagerBar?.layout.barStyle = TYPagerBarStyle.progressElasticView//TYPagerBarStyleProgressElasticView
        self.viewTabPagerBar?.layout.cellSpacing = 0
        self.viewTabPagerBar?.layout.cellEdging = 0
        self.viewTabPagerBar?.layout.normalTextFont = UIFont(name:"HelveticaNeue-Bold", size: 22)!
        self.viewTabPagerBar?.layout.selectedTextFont = UIFont(name:"HelveticaNeue-Bold", size: 27)!
        self.viewTabPagerBar?.layout.normalTextColor = GlobalClass.sharedInstance.setUnSelectedPagerColour()
        self.viewTabPagerBar?.layout.selectedTextColor = GlobalClass.sharedInstance.setSelectedPagerColour()
        self.viewTabPagerBar?.layout.adjustContentCellsCenter = false
        self.viewTabPagerBar?.layout.progressColor = GlobalClass.sharedInstance.setSelectedPagerColour()
        self.viewTabPagerBar?.layout.textColorProgressEnable=true
        
        self.viewTabPagerBar.dataSource = self
        self.viewTabPagerBar.delegate = self
        self.viewTabPagerBar.register(TYTabPagerBarCell.self, forCellWithReuseIdentifier: TYTabPagerBarCell.cellIdentifier())
        self.viewTabPagerBar.reloadData()
        
    }
    
    func numberOfControllersInPagerController() -> Int {
        return datas.count
    }

    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        // Instantiate view controllers based on the index
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        if index == 0 {
//            return sb.instantiateViewController(withIdentifier: "MomentVideoViewController")
//           
//        } else if index == 1 {
//            return sb.instantiateViewController(withIdentifier: "MomentImageViewController")
//          
//        } else {
//            
//            return sb.instantiateViewController(withIdentifier: "MomentFollowingViewController")
//        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            return sb.instantiateViewController(withIdentifier: "MomentVideoViewController")
           
        } else {
            
            return sb.instantiateViewController(withIdentifier: "MomentFollowingViewController")
        }
        
    }

    // MARK: - TYTabPagerBarDataSource & TYTabPagerBarDelegate

    func numberOfItemsInPagerTabBar() -> Int {
        return datas.count
    }

    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: TYTabPagerBarCell.cellIdentifier(), for: index)
        cell.titleLabel.text = self.datas[index]
        return cell
    }

    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        return self.viewTabPagerBar.cellWidth(forTitle: self.datas[index])
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        print("The from index in transition animated is: \(fromIndex)")
        print("The to index in transition animated is: \(toIndex)")
        indexToOpen = toIndex
        print("The index To Open is: \(indexToOpen)")
        
     self.viewTabPagerBar?.scrollToItem(from: fromIndex, to: toIndex, animate: true)
 }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        
     self.viewTabPagerBar?.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
 }
 
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
     self.pagerController?.scrollToController(at: index, animate: true)
 }
    
}

extension MomentsSwipeViewController: delegateUploadMomentOptionsViewController {
    
    func buttonClicked(pressedButton: String) {
        
        print("The option button pressed is: \(pressedButton)")
        
        if (pressedButton == "recordvideo") {
            
            optionSelected = pressedButton
            
            print("Camera se video record karne wala page open kar dena hai")
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RecordVideoViewController") as! RecordVideoViewController
           
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        } else if (pressedButton == "image") {
            
            optionSelected = pressedButton
            
            print("Phone ke gallery se image select karwani hai.")
            if #available(iOS 14.0, *) {
                presentPhotoPicker()
            } else {
               print("Purana version hai phone ke os ka")
            }
            
        } else if (pressedButton == "video") {
            
            optionSelected = pressedButton
            
            print("Phone ke gallery se video select karwani hai.")
            chooseVideoFromGallery()
            
        }
    }
    
}

extension MomentsSwipeViewController: PHPickerViewControllerDelegate {
    
    @available(iOS 14.0, *)
    func presentPhotoPicker() {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 9
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }

    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let dispatchGroup = DispatchGroup()

        for result in results {
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()

                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    defer {
                        dispatchGroup.leave()
                    }

                    if let image = image as? UIImage {
                        self.selectedImages.append(image)
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            // All images are loaded
//            self.collectionView.reloadData() // Refresh collection view to show all the images
            // yhn se pta chalega ki saari images array mai aa gyi hai aur aane ke bad notify kraega ye hmain
            print("The selected images are: \(self.selectedImages)")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PostMomentViewController") as! PostMomentViewController
            nextViewController.selectedImages = self.selectedImages
            nextViewController.optionName = self.optionSelected
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }

        picker.dismiss(animated: true, completion: nil)
    }

    @available(iOS 14, *)
    func pickerDidCancel(_ picker: PHPickerViewController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
}

extension MomentsSwipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseVideoFromGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum//.photoLibrary//.savedPhotosAlbum
        imagePicker.mediaTypes = ["public.movie"]
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }

        if mediaType == "public.movie" {
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                // Use the videoURL here for further processing
                print("Selected video URL: \(videoURL) ")
                
                if let thumbnail = generateThumbnail(from: videoURL) {
                           // Use the thumbnail image for display or further processing
                           print("Thumbnail image generated")
                    print("The thumbnail image generated is: \(thumbnail)")
                    selectedImages.append(thumbnail)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PostMomentViewController") as! PostMomentViewController
                    nextViewController.selectedImages = self.selectedImages
                    nextViewController.optionName = self.optionSelected
                    nextViewController.videoUrl = videoURL
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                }
                
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("Cancel ki button dabai hai. Video Select nahi karna hai")
        // Handle cancellation, if needed
    }
    
}
