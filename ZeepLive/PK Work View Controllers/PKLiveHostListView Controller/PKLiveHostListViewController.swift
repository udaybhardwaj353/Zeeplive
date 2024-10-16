//
//  PKLiveHostListViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/24.
//

import UIKit
import Kingfisher

protocol delegatePKLiveHostListViewController: AnyObject {

    func hostpkInviteProfileID(id:String, details: liveHostListData)
    func hostpkInvitePKID(id:String)
    
}

class PKLiveHostListViewController: UIViewController {

    @IBOutlet weak var lblLiveHostCount: UILabel!
    @IBOutlet weak var btnRefreshOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var hideButtonForRow: Int? = 20000
    lazy var pageNo: Int = 1
    lazy var lastPage: Int = 2
    lazy var hostsList = liveHostListResult()
    lazy var pkID: String = ""
    weak var delegate: delegatePKLiveHostListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getHostsList()
       tableViewWork()
        
    }
    
    @IBAction func btnRefreshPressed(_ sender: Any) {
        
        print("Button Refresh Live Host List Pressed.")
        showLoader()
        hostsList.data?.removeAll()
        tblView.reloadData()
        pageNo = 1
        getHostsList()
        
    }
    
    func tableViewWork() {
        
        tabBarController?.tabBar.isHidden = true
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "PKLiveHostListTableViewCell", bundle: nil), forCellReuseIdentifier: "PKLiveHostListTableViewCell")
        tblView.isMultipleTouchEnabled = false
        
    }
    
    deinit {
        
        print("PK Live Host List main deinit call hua hai.")
        hostsList.data?.removeAll()
        tblView.delegate = nil
        tblView.dataSource = nil
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearCache() {
            // Completion block (optional)
            print("Saare cache clear hue hai pk live host list view controller main.")
        }
    }
}

// MARK: - EXTENSION FOR TABLE VIEW DELEGATES AND DATASOURCE METHODS TO SHOW DATA TO THE USER

extension PKLiveHostListViewController: UITableViewDelegate, UITableViewDataSource, delegatePKLiveHostListTableViewCell {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return hostsList.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "PKLiveHostListTableViewCell", for: indexPath) as! PKLiveHostListTableViewCell
        
        
        if let imageURL = URL(string: hostsList.data?[indexPath.row].profileImage ?? "") {
            KF.url(imageURL)
              //  .downsampling(size: CGSize(width: 200, height: 200))
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
        
        // Hide button for the specific row
               if let hideRow = hideButtonForRow, indexPath.row == hideRow {
                   cell.btnInviteOutlet.isHidden = true
               } else {
                   cell.btnInviteOutlet.isHidden = false
                  
                   let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId")
                   let userId = UserDefaults.standard.string(forKey: "UserId")
                   
                   if (userId == String(hostsList.data?[indexPath.row].id ?? 0)) || (userProfileId == String(hostsList.data?[indexPath.row].profileID ?? 0)) {
                       
                       cell.btnInviteOutlet.isHidden = true
                       
                   } else {
                       
                       cell.btnInviteOutlet.isHidden = false
                       
                   }
                   
               }
        
            cell.lblHostName.text = hostsList.data?[indexPath.row].name ?? "N/A"
            
//        let userProfileId = UserDefaults.standard.string(forKey: "UserProfileId")
//        let userId = UserDefaults.standard.string(forKey: "UserId")
//        
//        if (userId == String(hostsList.data?[indexPath.row].id ?? 0)) || (userProfileId == String(hostsList.data?[indexPath.row].profileID ?? 0)) {
//            
//            cell.btnInviteOutlet.isHidden = true
//            
//        } else {
//            
//            cell.btnInviteOutlet.isHidden = false
//            
//        }
            
            cell.delegate = self
            cell.btnInviteOutlet.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("The selected index in user watching broad is: \(indexPath.row)")
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            pageNo += 1
            print(pageNo)
            
            if (pageNo <= lastPage) {
                print("Ab api Call Krana Hai pagination ke liye pk live host list view controller main.")
                getHostsList()
              
            } else {
                print("Ye last page hai ... isliye api call nahi krani hai")
                
            }
        }
        
    }
    
    func buttonInvitePressed(index: Int) {
    
        print("The index on which button invide pressed is: \(index)")
        
        if let hostData = hostsList.data?[index] {
            delegate?.hostpkInviteProfileID(id: String(hostData.profileID ?? 0), details: hostData)
        } else {
            // Handle the case where data is nil
            print("Host data is nil")
        }

        sendUserPKRequestDetails(hostProfileID: String(hostsList.data?[index].profileID ?? 0))
        sendUserPKRequest(hostProfileID: String(hostsList.data?[index].profileID ?? 0))
        
            hideButtonForRow = index
            let indexPath = IndexPath(row: index, section: 0)
            tblView.reloadRows(at: [indexPath], with: .automatic)
        
        
    }
    
}

// MARK: - EXTENSION FOR USING FIREBASE TO SEND PK REQUEST TO THE FIREBASE TO THE HOST

extension PKLiveHostListViewController {
    
    func sendUserPKRequest(hostProfileID: String = "") {
        
        let currentTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        print(currentTimestampInMilliseconds)
        
        var dic = [String: Any]()
        dic["invitelog_userid"] = UserDefaults.standard.string(forKey: "UserProfileId")
        dic["name"] = UserDefaults.standard.string(forKey: "UserName")
        dic["pk_id"] = pkID //(UserDefaults.standard.string(forKey: "UserProfileId") ?? "") + String(currentTimestampInMilliseconds)
        dic["pk_is_one_more"] = false
        dic["pk_time"] = currentTimestampInMilliseconds
        if let picM = UserDefaults.standard.string(forKey: "profilePicture") {
            dic["profile"] = picM ?? ""
        }
        
        print("The dictionary we are uploading in the pk for pk request is: \(dic)")
        
        let id =  UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        
        ZLFireBaseManager.share.pkRequestRef.child("pk-invite-list").child(hostProfileID).child(id).setValue(dic) { [weak self] (error, reference) in
            
            guard let self = self else {
                // self is nil, probably deallocated
                return
            }
            
            if let error = error {
                print("Error writing data: \(error)")
            } else {
                print("PK request sent and written successfully on firebase.")
            }
        }
        
    }
    
    func sendUserPKRequestDetails(hostProfileID: String = "") {
    
        let currentTimestampInMilliseconds = Int(Date().timeIntervalSince1970 * 1000)
        let pkid = (UserDefaults.standard.string(forKey: "UserProfileId") ?? "") + String(currentTimestampInMilliseconds)
        pkID = pkid
        
        var dic = [String: Any]()
        dic["status"] = "pk_request"
        dic["pk_id"] = pkID
        
        let id =  UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        
        ZLFireBaseManager.share.pkRequestRef.child("pk-invite-details").child(hostProfileID).child(id).setValue(dic) { [weak self] (error, reference) in
            
            guard let self = self else {
                // self is nil, probably deallocated
                return
            }
            
            if let error = error {
                print("Error writing data: \(error)")
            } else {
                print("PK request sent and written successfully on firebase in pk invite details.")
                delegate?.hostpkInvitePKID(id: pkID)
                
            }
        }
        
    }
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM THE BACKEND

extension PKLiveHostListViewController {
    
    func getHostsList() {
        
        let url = AllUrls.baseUrl + "getLiveFollowList?type=&page=\(pageNo)"
        print("The url is \(url )")
        
        ApiWrapper.sharedManager().getLiveHostsListPK(url: url) { [weak self] (data, value) in
            
            guard let self = self else { return }
            
            lastPage = data?.lastPage ?? 0
            print(lastPage)
            
            if let hostList = data?.data {
                print(hostList)
                
                if hostsList.data == nil {
                    hostsList.data = hostList
                    
                } else {
                    hostsList.data?.append(contentsOf: hostList)
                    
                }
                
                if let count = hostsList.data?.count {
                    lblLiveHostCount.text = "Invite Friends's (\(count))"
                } else {
                    lblLiveHostCount.text = "Invite Friends's (0)" // Or handle it in a way that fits your use case
                }

            }
            hideLoader()
            tblView.reloadData()
        }
    }
}
