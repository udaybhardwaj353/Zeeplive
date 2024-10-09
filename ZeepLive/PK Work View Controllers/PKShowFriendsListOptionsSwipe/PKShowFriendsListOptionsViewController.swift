//
//  PKShowFriendsListOptionsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/24.
//

import UIKit
import TYPagerController


protocol delegatePKShowFriendsListOptionsViewController: AnyObject {

        func pkInvitedHostID(id:String, details: liveHostListData)
        func pkID(id:String)
}

class PKShowFriendsListOptionsViewController: UIViewController, delegatePKLiveHostListViewController, delegatePKFollowingListViewController {
   
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewTabPagerBar: TYTabPagerBar!
    @IBOutlet weak var viewShowData: UIView!
    
    lazy var datas: [String] = []
    var pagerController : TYPagerController?
    weak var delegate: delegatePKShowFriendsListOptionsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePageControl()
        loadData()
        setupTabPagerBar()
        configureToClose()
        configureUI()
        
    }
    
    func configureToClose() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewBottom)
        
        // Check if the tap was inside viewBottom or not
        if viewBottom.bounds.contains(location) {
            // The tap occurred inside viewBottom, handle accordingly (if needed)
            // For example, perform an action or do nothing
            print("View bottom par tap hua hai")
            
        } else {
            
            print("View bottom par tap nahi hua hai")
            // The tap occurred outside viewBottom, dismiss the view controller
            dismiss(animated: true, completion: nil)
        }
    }
    
    func configureUI() {
    
        viewBottom.layer.cornerRadius = 20
        
    }
    
}

// MARK: - EXTENSION FOR USING TYPAGER DELEGATES AND DATASOURCE METHODS TO SET THE PAGER VIEW TO SHOW SWIPING DATA AND PASSING VIEW CONTROLLER IN IT.

extension PKShowFriendsListOptionsViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource, TYPagerControllerDelegate {
    
    func configurePageControl() {
    
            pagerController = TYPagerController()
            pagerController?.dataSource = self
            pagerController?.delegate = self
            
            addChild(pagerController!)
            viewShowData.addSubview(pagerController!.view)
            pagerController?.didMove(toParent: self)
            
            pagerController?.view.frame = viewShowData.bounds
            pagerController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    func loadData() {
        self.datas = ["Live Host", "Following Host"]
        self.pagerController?.reloadData()
        self.viewTabPagerBar?.reloadData()
        
    }
    
    func setupTabPagerBar() {

//        self.viewTabPagerBar.layout.barStyle = .progressElasticView
        // Configure other properties as needed

        self.viewTabPagerBar?.layout.barStyle = TYPagerBarStyle.progressElasticView//TYPagerBarStyleProgressElasticView
        self.viewTabPagerBar?.layout.cellSpacing = 0
        self.viewTabPagerBar?.layout.cellEdging = 0
        self.viewTabPagerBar?.layout.normalTextFont = UIFont(name:"HelveticaNeue-Bold", size: 18)!
        self.viewTabPagerBar?.layout.selectedTextFont = UIFont(name:"HelveticaNeue-Bold", size: 23)!
        self.viewTabPagerBar?.layout.normalTextColor = GlobalClass.sharedInstance.setUnSelectedPagerColour()
        self.viewTabPagerBar?.layout.selectedTextColor = .black//GlobalClass.sharedInstance.setSelectedPagerColour()
        self.viewTabPagerBar?.layout.adjustContentCellsCenter = false
        self.viewTabPagerBar?.layout.progressColor = GlobalClass.sharedInstance.setSelectedPagerColourForPKList()
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
            let liveHostVC = sb.instantiateViewController(withIdentifier: "PKLiveHostListViewController") as! PKLiveHostListViewController
            liveHostVC.delegate = self
            return liveHostVC //sb.instantiateViewController(withIdentifier: "PKLiveHostListViewController")
           
        } else {
            
            let followingHostVC = sb.instantiateViewController(withIdentifier: "PKFollowingHostListViewController") as! PKFollowingHostListViewController
            followingHostVC.delegate = self
            return followingHostVC //sb.instantiateViewController(withIdentifier: "PKFollowingHostListViewController")
          
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
    
    func hostpkInviteProfileID(id: String, details: liveHostListData) {
        
        print("In PK LIVE HOST List view controller the profile id of the host invited is: \(id)")
        delegate?.pkInvitedHostID(id: id, details: details)
        
    }
    
    func hostpkInvitePKID(id: String) {
       
        print("In PK LIVE FOLLOWING list view controller the pk id of the host invited is: \(id)")
        delegate?.pkID(id: id)
        
    }
    
    func hostpkFollowingProfileID(id: String, details: liveHostListData) {
        
        print("In PK LIVE FOLLOWING list view controller the profile id of the host invited is: \(id)")
        delegate?.pkInvitedHostID(id: id, details: details)
        
    }
    
    func hostpkFollowingPKID(id: String) {
        
        print("In PK LIVE HOST List view controller the pk id of the host invited is: \(id)")
        delegate?.pkID(id: id)
        
    }
    
}
