//
//  NewProfileDetailTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 01/04/24.
//

import UIKit
import TYPagerController

class NewProfileDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var viewUserDetails: UIView!
    @IBOutlet weak var imgViewUserProfilePhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewUserID: UIView!
    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var viewUserStatus: UIView!
    @IBOutlet weak var lblUserStatus: UILabel!
    @IBOutlet weak var viewUserAge: UIView!
    @IBOutlet weak var imgViewUserGender: UIImageView!
    @IBOutlet weak var lblUserAge: UILabel!
    @IBOutlet weak var viewUserCountry: UIView!
    @IBOutlet weak var lblUserCountry: UILabel!
    @IBOutlet weak var viewFollowingDetails: UIView!
    @IBOutlet weak var viewFriendOutlet: UIButton!
    @IBOutlet weak var lblFriendCount: UILabel!
    @IBOutlet weak var viewFollowingOutlet: UIButton!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var viewFollowersOutlet: UIButton!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var viewHeadingNames: UIView!
    @IBOutlet weak var viewTabPagerBar: TYTabPagerBar!
    @IBOutlet weak var viewShowData: UIView!
    @IBOutlet weak var viewShowDataBottomConstraints: NSLayoutConstraint!
    
    lazy var datas: [String] = []
    var pagerController : TYPagerController?
   lazy var userID: String = ""
    lazy var richLevel: Int = 0
    lazy var charmLevel: Int = 0
    lazy var hostFollowed: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        configureUI()
        loadData()
        setupTabPagerBar()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewFriendPressed(_ sender: Any) {
        
        print("View Friends Pressed.")
        
    }
    
    @IBAction func viewFollowingPressed(_ sender: Any) {
        
        print("View Following Pressed.")
        
    }
    
    @IBAction func viewFollowersPressed(_ sender: Any) {
        
        print("View Followers Pressed.")
        
    }
    
    func setData() {
        
        configurePageControl()
        
    }
}

extension NewProfileDetailTableViewCell {
    
    func configureUI() {
    
        viewShowDataBottomConstraints.constant = 0
        viewMain.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        imgViewUserProfilePhoto.layer.cornerRadius = imgViewUserProfilePhoto.frame.height / 2
        imgViewUserProfilePhoto.clipsToBounds = true
        viewUserStatus.layer.cornerRadius = viewUserStatus.frame.height / 2
        viewUserCountry.layer.cornerRadius = viewUserCountry.frame.height / 2
        viewUserDetails.layer.cornerRadius = 10
        viewUserDetails.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
}

extension NewProfileDetailTableViewCell: TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate {
    
    func configurePageControl() {
           pagerController = TYPagerController()
           pagerController?.dataSource = self
           pagerController?.delegate = self

        if let pagerView = pagerController?.view {
            
            viewShowData.addSubview(pagerView)
            pagerController?.view.frame = viewShowData.bounds
            pagerController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            pagerController?.didMove(toParent: NewProfileDetailViewController())
        }
       }
    
    func loadData() {
        self.datas = ["Info", "Moments"]
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
            let infoVC = sb.instantiateViewController(withIdentifier: "NewProfileInfoViewController") as! NewProfileInfoViewController
            infoVC.userID = userID
            infoVC.richLevel = richLevel
            infoVC.charmLevel = charmLevel
            
            return infoVC
           
        } else {
            let followVC = sb.instantiateViewController(withIdentifier: "ShowUserMomentsListViewController") as! ShowUserMomentsListViewController
            followVC.userID = userID
            followVC.hostFollowed = hostFollowed
            
            return followVC
            
           // return sb.instantiateViewController(withIdentifier: "CashOutViewController")
          
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
     self.viewTabPagerBar?.scrollToItem(from: fromIndex, to: toIndex, animate: true)
 }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
     self.viewTabPagerBar?.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
 }
 
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
     self.pagerController?.scrollToController(at: index, animate: true)
 }
    
}
