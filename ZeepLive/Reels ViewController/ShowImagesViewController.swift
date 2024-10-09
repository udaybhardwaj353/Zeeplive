//
//  ShowImagesViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 12/06/24.
//

import UIKit

class ShowImagesViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    lazy var momentData = MomentResult()
    lazy var previousIndex: Int = 0
    lazy var currentIndex: Int = 0
    lazy var newIndex: Int = 0
    let offsetY =  100
    lazy var lastPageNo: Int = 1
    lazy var isDataLoading:Bool=false
    lazy var didEndReached:Bool=false
    lazy var pageNo:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewWork()
       
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed in the Reels Image View Conroller.")
        navigationController?.popViewController(animated: true)
        
    }
    
    func tableViewWork() {
        
        tabBarController?.tabBar.isHidden = true
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "ReelsImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ReelsImageTableViewCell")
       
        let index = IndexPath(row: currentIndex, section: 0)
        tblView?.scrollToRow(at: index , at: UITableView.ScrollPosition.top, animated: false)
        
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND METHODS AND THEIR WORKING FOR PLAYING REELS AND GIFT VIDEO

extension ShowImagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return momentData.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReelsImageTableViewCell", for: indexPath) as! ReelsImageTableViewCell
        
        if let momentImages = momentData.data?[indexPath.row].momentImages {
            cell.configure(with: momentImages, at: indexPath.row, of: "image")
        }
        
        if let userData = momentData.data?[currentIndex].userData {
            
            print("User ID: \(userData.id ?? 0)")
            print("User Name: \(userData.name ?? "Unknown")")
            cell.lblHostName.text = userData.name
            cell.lblSendGiftCount.text = String(momentData.data?[indexPath.row].giftCount ?? 0)
            cell.lblLikeImageCount.text = String(momentData.data?[indexPath.row].likesCount ?? 0)
            cell.lblCommentCount.text = String(momentData.data?[indexPath.row].commentsCount ?? 0)
            
            let senderName = (momentData.data?[indexPath.row].senderName ?? "N/A")
            let giftCount = String(momentData.data?[indexPath.row].giftCount ?? 1)
            let formattedString = momentData.data?[indexPath.row].message ?? ""
            
            let plainString = stripHTMLTags(from: formattedString)

            print(plainString) // Output: "send 1 Sea Monster to Riya"
            
            cell.lblHostDescriptionMessage.text = plainString//"Wow," + senderName + "sent me" + giftCount + ""
            
            if let profileImages = userData.profileImages {
                
                if let firstProfileImage = profileImages.first {
                    let profileImageUrlString = firstProfileImage.imageName ?? ""
                    if let profileImageUrl = URL(string: profileImageUrlString) {
                        
                        print("THe profile image url is: \(profileImageUrl)")
                        cell.imgViewHostImage.kf.setImage(with: profileImageUrl) { result in
                            switch result {
                            case .success(let value):
                                print("Profile Image downloaded: \(value.image)")
                                
                            case .failure(let error):
                                print("Error downloading profile image: \(error)")
                                cell.imgViewHostImage.image = UIImage(named: "UserPlaceHolderImageForCell")
                                
                            }
                        }
                    }
                }
            } else {
                print("No profile images found.")
                cell.imgViewHostImage.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("the cell width and height in show images view controller is: \(GlobalClass.sharedInstance.SCREEN_HEIGHT)")
        return GlobalClass.sharedInstance.SCREEN_HEIGHT
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("the indexpath in will display method in reels view controller is: \(indexPath.row)")
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 2
        print("the last row indexpath in will display method in reels view controller is: \(lastRowIndex)")
        print(lastPageNo)
        if indexPath.row == lastRowIndex {
            pageNo += 1
            print(pageNo)

            if (pageNo <= lastPageNo) {
                isDataLoading = true
                print("Ab Call Krana Hai")
                getListData()

            } else {
                print("Ye last page hai ... isliye api call nahi krani hai reels view controller main.")

            }
        }
    }
    
    
}

// MARK: - EXTENSION FOR DOING SCROLLING WORK AND PLAYING VIDEO

extension ShowImagesViewController {
    

    // MARK: - SCROLL VIEW SWIPE UP AND DOWN FUNCTIONALITY FUNCTION WORKING

            func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
    
                    let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
                    scrollView.panGestureRecognizer.isEnabled = false
    
                    self.previousIndex = self.currentIndex
    
                    var isRun = false
                    if translatedPoint.y < CGFloat(-offsetY) && self.currentIndex < ((self.momentData.data?.count ?? 1) - 1) {
                        self.currentIndex += 1
                        NSLog("向下滑动索引递增")
                        print("after translating it means Index increases as you scroll down.")
                        isRun = true
                        self.newIndex = self.currentIndex + 1
                        print("The new index here jab scroll upar ki trf karenge tb hai: \(self.newIndex)")
                    }
    
                    if translatedPoint.y > CGFloat(offsetY) && self.currentIndex > 0 {
                        self.currentIndex -= 1
                        self.newIndex = self.currentIndex - 1
                        NSLog("向上滑动索引递减")
                        print("After translating it means Index decreases as you scroll up.")
                        isRun = true
                        print("The new index jab scroll neeche ki trf karenge tab hai: \(self.newIndex)")
                    }
    
                    if (self.momentData.data?.count ?? 0) > 0 {
                        UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
                            guard let self = self else { return }
                            let index = IndexPath(row: self.currentIndex, section: 0)
                            self.tblView?.scrollToRow(at: index, at: .top, animated: false)
                        } completion: { [weak self] finish in
                            guard let self = self else { return }
                            scrollView.panGestureRecognizer.isEnabled = true
                        }
                       // scrollView.panGestureRecognizer.isEnabled = true
                        if isRun {
    
                            tblView.reloadData()
    
                            print("滑动完成")
                            print("After converted it means Slide Completed")
                            UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
                                guard let self = self else { return }
                                let index = IndexPath(row: self.currentIndex, section: 0)
                                self.tblView?.scrollToRow(at: index, at: .top, animated: false)
                            } completion: { [weak self] finish in
                                guard let self = self else { return }
                                scrollView.panGestureRecognizer.isEnabled = true
                            }
                        }
                    }
                }
            }
    
}

extension ShowImagesViewController {
    
    func getListData() {
        
        let url = "https://zeep.live/api/momentListLatest?type=1&page=\(pageNo)"
        
        ApiWrapper.sharedManager().getMomentList(url: url) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
            if (value["success"] as? Bool == true) {
                
                if let result = value["result"] as? [String: Any] {
                    let lastPage = result["last_page"] as? Int
                    print("Last page: \(lastPage)")
                    lastPageNo = lastPage ?? 1
                    print(lastPageNo)
                } else {
                    print("Failed to retrieve the last page.")
                }
                
                if momentData.data == nil {
                    momentData.data = data?.data
                    
                } else {
                    momentData.data?.append(contentsOf: data?.data ?? [])
                    
                }
                
                //   momentData = data ?? momentData
                print("The moment data count is: \(momentData.data?.count)")
                
                tblView.reloadData()
                
            } else {
                
                print("Image wale data main success false aa rha hai")
                
            }
        }
    }
    
}
