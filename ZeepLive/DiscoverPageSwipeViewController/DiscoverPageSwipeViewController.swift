//
//  DiscoverPageSwipeViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 29/12/23.
//

import UIKit
import TYPagerController
import Kingfisher
import ZegoExpressEngine

class DiscoverPageSwipeViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnRankListOutlet: UIButton!
    @IBOutlet weak var btnSearchOutlet: UIButton!
    @IBOutlet weak var viewTabPagerBar: TYTabPagerBar!
    @IBOutlet weak var viewMain: UIView!
    
    lazy var datas: [String] = []
    var pagerController : TYPagerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        
    }
    
    @IBAction func btnRankListPressed(_ sender: Any) {
        
        print("Button Show Rank List Pressed")
       
        let id = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        
        openWebView(withURL: "https://zeep.live/female-weekly-rewards?userid=\(id)")
        
    }
    
    @IBAction func btnSearchPressed(_ sender: Any) {
        
        print("Button Search Pressed")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController

        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    deinit {
        
        print("Discover swipe main deinit call hua hai")
    }
}

extension DiscoverPageSwipeViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate {
    
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
        self.datas = ["Discover", "Popular", "Nearby"]
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
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if index == 0 {
            return sb.instantiateViewController(withIdentifier: "DiscoverViewController")
           
        } else if index == 1 {
            return sb.instantiateViewController(withIdentifier: "PopularViewController")
          
        } else {
            
            return sb.instantiateViewController(withIdentifier: "NearByViewController")
        }
    }

    // MARK: - TYTabPagerBarDataSource & TYTabPagerBarDelegate

    func numberOfItemsInPagerTabBar() -> Int {
        return datas.count
    }

    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
       
        ZegoExpressEngine.shared().logoutRoom()
        ZegoExpressEngine.destroy(nil)
        
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: TYTabPagerBarCell.cellIdentifier(), for: index)
        cell.titleLabel.text = self.datas[index]
        return cell
        
    }

    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        return self.viewTabPagerBar.cellWidth(forTitle: self.datas[index])
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
     self.viewTabPagerBar?.scrollToItem(from: fromIndex, to: toIndex, animate: true)
 }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
     self.viewTabPagerBar?.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
 }
 
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
     self.pagerController?.scrollToController(at: index, animate: true)
 }
    
}
