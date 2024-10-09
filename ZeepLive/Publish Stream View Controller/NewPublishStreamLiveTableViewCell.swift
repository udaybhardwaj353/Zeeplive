//
//  NewPublishStreamLiveTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 28/06/24.
//

import UIKit
import ImSDK_Plus
import Kingfisher
import Lottie


protocol delegateNewPublishStreamLiveTableViewCell: AnyObject {

        func giftButton(isPressed:Bool)
        func userDetailsPressed(selectedIndex: Int)
        func closeBroad(isPressed:Bool)
        func distributionClicked(openWebView:Bool)
        func viewRewardClicked(isClicked:Bool)
        func buttonAudienceList(isClicked:Bool)
        func cellIndexClicked(index:Int)
        func messageClicked(userImage:String , userName:String , userLevel:String, userID:String)
        func gameButtonClicked(isClicked:Bool)
        func micJoinedUserClicked(userID:String,userName:String, userImage:String)
        func buttonOneToOneCallPressed(isPressed:Bool)
        func buttonFollowPressed(isPressed:Bool)
        func buttonJoinMicPressed(isPressed:Bool)
        func buttonMicPressed(isPressed:Bool)
        func muteMic(isPressed:String)
    
}

class NewPublishStreamLiveTableViewCell: UITableViewCell {

    lazy var headerView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: viewLiveMessage.frame.width, height: 100))
        v.backgroundColor = UIColor(hexString: "000000")?.withAlphaComponent(0.35)
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        let lab = UILabel(frame: CGRect(x: 9, y: 8, width: viewLiveMessage.frame.width - 18, height: 100 - 16))
        lab.backgroundColor = .clear
        lab.text = "Welcome to ZeepLive!! Please don't share inappropriate content like pornography or violence as it's strictly against our policy. Our AI system continuously monitors content to ensure compliance"
        lab.textColor = UIColor(hexString: "F9B248")
        lab.numberOfLines = 0
        lab.textAlignment = .left
        lab.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        v.addSubview(lab)
        v.isUserInteractionEnabled = false
        return v
    }()
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewUserDetailsOutlet: UIButton!
    @IBOutlet weak var imgViewUserProfilePhoto: UIImageView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblViewersCount: UILabel!
    @IBOutlet weak var btnCloseBroadOutlet: UIButton!
    @IBOutlet weak var btnViewAudienceOutlet: UIButton!
    @IBOutlet weak var collectionViewBroadList: UICollectionView!
    @IBOutlet weak var viewDistributionOutlet: UIButton!
    @IBOutlet weak var imgViewContributionTrophy: UIImageView!
    @IBOutlet weak var lblDistributionAmount: UILabel!
    @IBOutlet weak var viewRewardOutlet: UIButton!
    @IBOutlet weak var viewRewardRankOutlet: UIButton!
    @IBOutlet weak var lblRewardRank: UILabel!
    @IBOutlet weak var viewLuckyGift: UIView!
    @IBOutlet weak var lblNoOfGift: UILabel!
    @IBOutlet weak var viewLuckyGiftDetails: UIView!
    @IBOutlet weak var viewUserImage: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var viewGiftImage: UIView!
    @IBOutlet weak var imgViewGift: UIImageView!
    @IBOutlet weak var lblSendGiftHostName: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var viewOneToOneCall: UIView!
    @IBOutlet weak var btnOneToOneCallOutlet: UIButton!
    @IBOutlet weak var viewGift: UIView!
    @IBOutlet weak var btnGiftOutlet: UIButton!
    @IBOutlet weak var btnMicOutlet: UIButton!
    @IBOutlet weak var btnOpenMessageOutlet: UIButton!
    @IBOutlet weak var btnGameOutlet: UIButton!
    @IBOutlet weak var btnPKOutlet: UIButton!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var btnSendMessageOutlet: UIButton!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var txtFldMessage: UITextField!
    @IBOutlet weak var viewUserRoomStatus: UIView!
    @IBOutlet weak var lblRoomUserName: UILabel!
    @IBOutlet weak var lblRoomUserStatus: UILabel!
    @IBOutlet weak var viewLiveMessage: UIView!
    @IBOutlet weak var tblViewLiveMessage: UITableView!
    @IBOutlet weak var viewMicJoinedUsers: UIView!
    @IBOutlet weak var tblViewMicJoinedUsers: UITableView!
    @IBOutlet weak var tblViewPKRequest: UITableView!
    @IBOutlet weak var collectionViewJoinMic: UICollectionView!
    @IBOutlet weak var viewMessageBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnGameWidthConstraints: NSLayoutConstraint!
    
    lazy var liveMessages: [liveMessageModel] = []
    lazy var pkRequestsHostList: [getPKRequestHostsModel] = []
    lazy var pkRequestHostDetail = getPKRequestHostsModel()
    lazy var zegoMicUsersList: [getZegoMicUserListModel] = []
    lazy var micUser = getZegoMicUserListModel()
    lazy var coHostRequestList: [getCoHostInviteUsersDetail] = []
    lazy var lottieAnimationViews: [LottieAnimationView] = []
    lazy var timer = Timer()
    lazy var dailyEarningBeans: String = ""
    lazy var weeklyEarningBeans:String = ""
    lazy var isMuteMicButtonPressed = false
    lazy var bottomConst: Int = 0
    
    var userInfoList: [V2TIMUserFullInfo]?
    var delegate: delegateNewPublishStreamLiveTableViewCell?
    var totalMsgData = liveMessageModel()
    var countdownTimer: Timer?
    var groupUsers = [joinedGroupUserProfile]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        configureUI()
        addLottieAnimation()
        timerAndNotification()
        tableViewWork()
        tableViewWorkOfPKRequestHosts()
        tableViewWorkOfJoinMicUsers()
        collectionViewWork()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
    
        imgView.isHidden = true
        viewGift.isHidden = true
        btnGiftOutlet.isHidden = true
        viewLuckyGift.isHidden = true
        viewUserDetailsOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        
        if (gender.lowercased() == "male") {
        
            viewOneToOneCall.isHidden = false
        } else {
            
            viewOneToOneCall.isHidden = true
            
        }
        
        btnGameWidthConstraints.constant = 0
        btnGameOutlet.isHidden = true
       // btnMuteMicOutlet.isUserInteractionEnabled = false
        viewMessage.isHidden = true
        viewMessage.layer.cornerRadius = viewMessage.frame.size.height / 2
        viewMessage.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        txtFldMessage.setLeftPaddingPoints(15)
        viewUserDetailsOutlet.layer.cornerRadius = viewUserDetailsOutlet.frame.size.height / 2
        imgViewUserProfilePhoto.layer.cornerRadius = imgViewUserProfilePhoto.frame.size.height / 2
        imgViewUserProfilePhoto.clipsToBounds = true
        
        viewDistributionOutlet.layer.cornerRadius = viewDistributionOutlet.frame.size.height / 2
        viewDistributionOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
     
        viewRewardOutlet.layer.cornerRadius = viewRewardOutlet.frame.size.height / 2
        viewRewardOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tblViewLiveMessage?.register(UINib(nibName: "LiveMessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessagesTableViewCell")
        tblViewLiveMessage?.register(UINib(nibName: "LiveMessageHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessageHeaderTableViewCell")
        tblViewLiveMessage.rowHeight = UITableView.automaticDimension
        tblViewLiveMessage.delegate = self
        tblViewLiveMessage.dataSource = self
        tblViewLiveMessage.tableHeaderView = headerView
        
        viewLuckyGiftDetails.layer.cornerRadius = viewLuckyGiftDetails.frame.height / 2
        //viewLuckyGiftDetails.layer.borderWidth = 1
       // viewLuckyGiftDetails.layer.borderColor = UIColor.purple.withAlphaComponent(0.3).cgColor
        viewLuckyGiftDetails.backgroundColor = .black.withAlphaComponent(0.3)
        
        viewGiftImage.layer.cornerRadius = viewGiftImage.frame.height / 2
        viewUserImage.layer.cornerRadius = viewUserImage.frame.height / 2
        
        imgViewGift.layer.cornerRadius = imgViewGift.frame.height / 2
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        
        viewUserRoomStatus.layer.cornerRadius = viewUserRoomStatus.frame.height / 2
        viewUserRoomStatus.backgroundColor = UIColor(hexString: "000000")?.withAlphaComponent(0.35)//.black.withAlphaComponent(0.6)
        lblRoomUserName.textColor = UIColor(hexString: "F9B248")
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(handleTap), userInfo: nil, repeats: true)
       
        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 2)
        widthConstraint.isActive = true
        
        let userNameWidthConstraint = NSLayoutConstraint(item: lblRoomUserName, attribute: .width, relatedBy: .lessThanOrEqual, toItem: viewUserRoomStatus, attribute: .width, multiplier: 0.5, constant: viewUserRoomStatus.frame.width / 2) // Adjust the multiplier and constant as needed
        userNameWidthConstraint.isActive = true
        
    }
    
    @IBAction func viewUserDetailsPressed(_ sender: UIButton) {
        
        print("View User Details Pressed to open view for host.")
        delegate?.userDetailsPressed(selectedIndex: sender.tag)
        
    }
    
    @IBAction func btnCloseBroadPressed(_ sender: Any) {
        
        print("Button Close Broad Pressed.")
        timer.invalidate()
        delegate?.closeBroad(isPressed: true)
        
    }
    
    @IBAction func btnViewAudiencePressed(_ sender: Any) {
        
        print("Button View Audience List Preesed.")
        delegate?.buttonAudienceList(isClicked: true)
        
    }
    
    @IBAction func viewDistributionOutletPressed(_ sender: Any) {
        
        print("View Distribution Outlet Pressed.")
        delegate?.distributionClicked(openWebView: true)
        
    }
    
    @IBAction func viewRewardPressed(_ sender: Any) {
        
        print("View Reward Pressed in new publish stream.")
        delegate?.viewRewardClicked(isClicked: true)
        
    }
    
    @IBAction func viewRewardRankPressed(_ sender: Any) {
        
        print("View Reward Rank Pressed in new publish stream.")
        delegate?.viewRewardClicked(isClicked: true)
        
    }
    
    @IBAction func btnOneToOneCallPressed(_ sender: Any) {
        
        print("Button One To One Call Pressed.")
        viewOneToOneCall.isHidden = true
        delegate?.buttonOneToOneCallPressed(isPressed: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) {
            self.viewOneToOneCall.isHidden = false
        }
        
    }
    
    @IBAction func btnGiftPressed(_ sender: Any) {
        
        print("Button Gift Pressed in new publish stream.")
        delegate?.giftButton(isPressed: true)
        
    }
    
    @IBAction func btnMicPressed(_ sender: Any) {
        
        print("Button Mic Pressed in new publish stream.")
       
        if isMuteMicButtonPressed
        
        {
            delegate?.buttonMicPressed(isPressed: isMuteMicButtonPressed)
            isMuteMicButtonPressed = false
          btnMicOutlet.setImage(UIImage(named:"micon"), for: .normal)
            
        }
        
        else{
            
            delegate?.buttonMicPressed(isPressed: isMuteMicButtonPressed)
            isMuteMicButtonPressed = true
          btnMicOutlet.setImage(UIImage(named:"micoff"), for: .normal)
            
        }
        
    }
    
    @IBAction func btnOpenMessagePressed(_ sender: Any) {
        
        print("Button Open Message Pressed in new publish stream.")
        txtFldMessage.becomeFirstResponder()
        
    }
    
    @IBAction func btnGamePressed(_ sender: Any) {
        
        print("Button Game Pressed in new publish stream.")
        delegate?.gameButtonClicked(isClicked: true)
        
    }
    
    @IBAction func btnPKPressed(_ sender: Any) {
        
        print("Button PK Pressed in new publish stream.")
        
    }
    
    @IBAction func btnSendMessagePressed(_ sender: Any) {
        
        print("Button Send Message Pressed in new publish stream.")
        
        if (txtFldMessage.text == "") || (txtFldMessage.text == nil) {
            print("Firebase par message post nahi karenge.")
        } else {
            print("Firebase par message post kar denge")
            let replacedString = GlobalClass.sharedInstance.replaceNumbersWithAsterisks(txtFldMessage.text ?? "")
                print(replacedString)
          //  sendMessage(message: replacedString ?? "N/A")
            txtFldMessage.resignFirstResponder()
        }
        
    }
    
}

// MARK: - EXTENSION FOR USING DELEGATE METHODS AND FUNCTIONS AND FOR TABLE VIEW AND COLLECTION VIEW  WORK FUNCTIONS

extension NewPublishStreamLiveTableViewCell: delegateRequestJoinMicUserListCollectionViewCell {
    
    func tableViewWorkOfPKRequestHosts() {
    
        tblViewPKRequest?.register(UINib(nibName: "PKRequestListTableViewCell", bundle: nil), forCellReuseIdentifier: "PKRequestListTableViewCell")
        tblViewPKRequest.delegate = self
        tblViewPKRequest.dataSource = self
        
    }
    
    func tableViewWorkOfJoinMicUsers() {
    
        tblViewMicJoinedUsers?.register(UINib(nibName: "MicJoinedUsersTableViewCell", bundle: nil), forCellReuseIdentifier: "MicJoinedUsersTableViewCell")
        tblViewMicJoinedUsers.delegate = self
        tblViewMicJoinedUsers.dataSource = self
        
    }
    
    func tableViewWork() {
        
        tblViewLiveMessage?.register(UINib(nibName: "LiveMessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessagesTableViewCell")
        tblViewLiveMessage?.register(UINib(nibName: "LiveMessageHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveMessageHeaderTableViewCell")
        tblViewLiveMessage.rowHeight = UITableView.automaticDimension
        tblViewLiveMessage.delegate = self
        tblViewLiveMessage.dataSource = self
        tblViewLiveMessage.tableHeaderView = headerView
        
    }
    
    func collectionViewWork() {
    
        collectionViewBroadList.register(UINib(nibName: "BroadJoinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BroadJoinCollectionViewCell")
        collectionViewBroadList.delegate = self
        collectionViewBroadList.dataSource = self
        collectionViewBroadList.isUserInteractionEnabled = true

        collectionViewJoinMic.register(UINib(nibName: "RequestJoinMicUserListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RequestJoinMicUserListCollectionViewCell")
        collectionViewJoinMic.delegate = self
        collectionViewJoinMic.dataSource = self
        collectionViewJoinMic.isUserInteractionEnabled = true
        
    }
    
    func acceptClicked(index: Int) {
       
        print("The index clicked for the accept button is: \(index)")

        ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (coHostRequestList[index].userID ?? ""), status: "accept")
        coHostRequestList.remove(at: index)
        print(coHostRequestList)
        print(coHostRequestList.count)
        collectionViewJoinMic.reloadData()
        
    }
    
    func rejectClicked(index: Int) {
        
        print("The index clicked for the reject button is: \(index)")
       
        ZLFireBaseManager.share.updateCoHostInviteStatusToFirebase(userid: (coHostRequestList[index].userID ?? ""), status: "decline")
        coHostRequestList.remove(at: index)
        print(coHostRequestList)
        print(coHostRequestList.count)
        collectionViewJoinMic.reloadData()
        
    }
    
}

// MARK: - EXTENSION FOR USING FUNCTIONS FOR TIMER, LOTTIE ANIMATION AND OTHER FUNCTIONS AS WELL

extension NewPublishStreamLiveTableViewCell {

    func timerAndNotification() {
       
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(handleTap), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        let widthConstraint = NSLayoutConstraint(item: viewUserRoomStatus, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.contentView.frame.width - 20)
        widthConstraint.isActive = true
       
        let userNameWidthConstraint = NSLayoutConstraint(item: lblRoomUserName, attribute: .width, relatedBy: .lessThanOrEqual, toItem: viewUserRoomStatus, attribute: .width, multiplier: 0.5, constant: viewUserRoomStatus.frame.width / 2) // Adjust the multiplier and constant as needed
        userNameWidthConstraint.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchTap))
        tapGesture.cancelsTouchesInView = false
        self.contentView.addGestureRecognizer(tapGesture)
        
    }
    
    func addLottieAnimation() {
        
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.frame = viewGift.bounds
        viewGift.addSubview(animationView)
        viewGift.addSubview(btnGiftOutlet)
        
        animationView.animation = LottieAnimation.named("Gift_animation1by1") // Replace with your animation file name
        animationView.loopMode = .loop
        animationView.play()
        animationView.isUserInteractionEnabled = false
        
        let animationView1 = LottieAnimationView()
        animationView1.contentMode = .scaleAspectFit
        animationView1.frame = imgViewContributionTrophy.bounds
        imgViewContributionTrophy.addSubview(animationView1)
        
        animationView1.animation = LottieAnimation.named("contribution_icon") // Replace with your animation file name
        animationView1.loopMode = .loop
        animationView1.play()
        animationView1.isUserInteractionEnabled = false
        
        let animationView2 = LottieAnimationView()
        animationView2.contentMode = .scaleAspectFit
        animationView2.frame = viewOneToOneCall.bounds
        viewOneToOneCall.addSubview(animationView2)
        
        animationView2.animation = LottieAnimation.named("Call2") // Replace with your animation file name
        animationView2.loopMode = .loop
        animationView2.play()
        animationView2.isUserInteractionEnabled = false
        
        lottieAnimationViews = [animationView, animationView1, animationView2]
        
    }
   
    func removeLottieAnimationViews() {
          // Remove Lottie animation views from their superviews
          lottieAnimationViews.forEach { $0.removeFromSuperview() }
      }
    
    @objc func touchTap(tap : UITapGestureRecognizer){
       // view.endEditing(true)
        let tapLocation = tap.location(in: self.contentView)

        if tapLocation.y < self.contentView.frame.size.height / 2 {
               contentView.endEditing(true)
          //  removeMessageView()
          //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
           } else {
               print("Neeche ki screen par tap hua hai")
               
           }
    }
    
    @objc func handleTap() {
       
        lblRewardRank.text = "Daily" + " " + dailyEarningBeans
        let originalFrame = viewRewardRankOutlet.frame
        let newFrame = CGRect(x: originalFrame.origin.x,
                              y: originalFrame.origin.y - 4, // Adjust the value as needed
                              width: originalFrame.size.width,
                              height: originalFrame.size.height)

        UIView.animate(withDuration: 0.5, animations: {
            self.viewRewardRankOutlet.frame = newFrame
        })
        animateView()
    }
    
    func animateView() {
           // Calculate the new frame for the view
           let originalFrame = viewRewardRankOutlet.frame
           let newFrame = CGRect(x: originalFrame.origin.x,
                                 y: originalFrame.origin.y - 4, // Adjust the value as needed
                                 width: originalFrame.size.width,
                                 height: originalFrame.size.height)

           UIView.animate(withDuration: 0.5, animations: {
               self.viewRewardRankOutlet.frame = newFrame
           }) { (finished) in
               self.lblRewardRank.text = "Weekly" + " " + self.weeklyEarningBeans
           }
       }
    

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.contentView.bringSubviewToFront(viewMessage)
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let keyboardTopY = self.contentView.frame.size.height - keyboardHeight

            UIView.animate(withDuration: 0.3) {
                self.viewMessage.isHidden = false
                self.txtFldMessage.text = ""
                self.viewMessageBottomConstraints.constant = keyboardHeight + 15 // Adjusting the constant to ensure visibility
                self.contentView.layoutIfNeeded()
                print("The bottom constraints is \(self.viewMessageBottomConstraints.constant)")
            }
        }
    }

    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.viewMessageBottomConstraints.constant = 0
            self.contentView.layoutIfNeeded()
            self.viewMessage.isHidden = true
            self.txtFldMessage.text = ""
            print("When keyboard hides, message view origin y is: \(self.viewMessage.frame.origin.y)")
            print("The bottom constraints at close is \(self.viewMessageBottomConstraints.constant)")
        }
    }

    
    func removeMessageView() {
    
        self.viewMessageBottomConstraints.constant = 0
        self.viewMessage.frame.origin.y = self.contentView.frame.size.height - self.viewMessage.frame.size.height
        self.viewMessage.isHidden = true
        self.txtFldMessage.text = ""
        
    }
    
    func insertNewMsgs(msgs: liveMessageModel) {
        totalMsgData  = msgs
        liveMessages.append(msgs)
        print("The live message count here is: \(liveMessages.count)")
        print("The total message count here is: \(msgs.message?.count)")
        tblViewLiveMessage.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          
            if self.tblViewLiveMessage.numberOfRows(inSection: 0) > 0 {
                let lastRowIndex = self.tblViewLiveMessage.numberOfRows(inSection: 0) - 1
                let indexPath = IndexPath(row: lastRowIndex, section: 0)
                print("Scrolling to indexPath: \(indexPath)")
                self.tblViewLiveMessage.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
        // tblViewLiveMessage.reloadData()
    }
    
    func insertUserName(name:String,status:String) {
        print(name)
        print(status)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Assuming name and status are your variables
            self.lblRoomUserName.text = name + ":"
            
            if (status == "4") {
                self.lblRoomUserStatus.text = "has entered the room"
            } else {
                self.lblRoomUserStatus.text = "has left the room"
            }
            
        }
    }
    
    func usersOnMic(data: [getZegoMicUserListModel] = []) {
        zegoMicUsersList.removeAll()
        
        zegoMicUsersList = data
        
        if (zegoMicUsersList.count == 0) {
            viewMicJoinedUsers.isHidden = true
        } else {
            viewMicJoinedUsers.isHidden = false
        }
        
        let userid = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        let containsUser = zegoMicUsersList.contains { $0.coHostID == userid }
        print("Did user joined mic list contains himself: \(containsUser)")
       
        if (containsUser == true) {
            countdownTimer?.invalidate()
          
        } else {
        
           print("User nahi hai list main.")
            
        }
        
        tblViewMicJoinedUsers.reloadData()
    }
    
    func showJoinedUser(users: [V2TIMUserFullInfo]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            print(users.count)
            self.userInfoList?.removeAll()
            self.userInfoList = users
            self.collectionViewBroadList.reloadData()
        }
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW DELEGATES AND THEIR FUNCTION'S WORKING

extension NewPublishStreamLiveTableViewCell : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tblViewLiveMessage) {
            return liveMessages.count
        } else if (tableView == tblViewPKRequest) {
            return pkRequestsHostList.count
        } else {
            return zegoMicUsersList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == tblViewLiveMessage) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveMessagesTableViewCell", for: indexPath) as! LiveMessagesTableViewCell
            
            
            //   cell.lblUserLevel.text = liveMessages[indexPath.row].level ?? "N/A"
            cell.lblUserLevel.text = " Lv." + (liveMessages[indexPath.row].level ?? "N/A")
            cell.lblUserName.text = liveMessages[indexPath.row].userName ?? "N/A"
            
            if (liveMessages[indexPath.row].type == "2") {
                
                let count = String(liveMessages[indexPath.row].giftCount ?? 0)
                let giftName = liveMessages[indexPath.row].sendGiftName ?? "N/A"
                let sendTo = liveMessages[indexPath.row].sendGiftTo ?? "N/A"
                
                let formattedAttributedString = formatAttributedString(giftCount: count , sendGiftName: giftName, sendGiftTo: sendTo, sendGiftToColor: GlobalClass.sharedInstance.setLiveMessageColour())
                
                cell.lblUserMessage.attributedText = formattedAttributedString
                
            } else {
                
                cell.lblUserMessage.text = liveMessages[indexPath.row].message ?? " N/A"
                
            }
            
            if let gender = liveMessages[indexPath.row].gender {
                if let levelString = liveMessages[indexPath.row].level, let level = Int(levelString) {
                    if (gender.lowercased() == "male") {
                        print("Gender male hai")
                        if (level == 0) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv0")
                        } else if (level >= 1 && level <= 5) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv1-5")
                        } else if (level >= 6 && level <= 10) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv6-10")
                        } else if (level >= 11 && level <= 15) {
                            cell.imgViewLevel.image =  UIImage(named: "reach_Lv11-15")
                        } else if (level >= 16 && level <= 20) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv16-20")
                        } else if (level >= 21 && level <= 25) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv21-25")
                        } else if (level >= 26 && level <= 30) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv26-30")
                        } else if (level >= 31 && level <= 35) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv31-35")
                        } else if (level >= 36 && level <= 40) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv36-40")
                        } else if (level >= 41 && level <= 45) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv41-45")
                        } else if (level >= 46 ) {
                            cell.imgViewLevel.image = UIImage(named: "reach_Lv45-50")
                        }
                        
                    } else {
                        print("Gender female hai")
                        if (level == 0) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv0")
                        } else if (level >= 1 && level <= 5) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv1-5")
                        } else if (level >= 6 && level <= 10) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv6-10")
                        } else if (level >= 11 && level <= 15) {
                            cell.imgViewLevel.image =  UIImage(named: "charm_Lv11-15")
                        } else if (level >= 16 && level <= 20) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv16-20")
                        } else if (level >= 21 && level <= 25) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv21-25")
                        } else if (level >= 26 && level <= 30) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv26-30")
                        } else if (level >= 31 && level <= 35) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv31-35")
                        } else if (level >= 36 && level <= 40) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv36-40")
                        } else if (level >= 41 && level <= 45) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv41-45")
                        } else if (level >= 46 ) {
                            cell.imgViewLevel.image = UIImage(named: "charm_Lv46-50")
                        }
                    }
                }
            }
            
            cell.selectionStyle = .none
            return cell
            
        } else if (tableView == tblViewPKRequest) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PKRequestListTableViewCell", for: indexPath) as! PKRequestListTableViewCell
            
            cell.lblHostName.text = pkRequestsHostList[indexPath.row].name ?? "N/A"
            GlobalClass.sharedInstance.loadImageForCell(from: pkRequestsHostList[indexPath.row].userImage, into: cell.imgViewHostImage)
            
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MicJoinedUsersTableViewCell", for: indexPath) as! MicJoinedUsersTableViewCell
            
            cell.lblMicUserName.text = zegoMicUsersList[indexPath.row].coHostUserName
            GlobalClass.sharedInstance.loadImageForCell(from: zegoMicUsersList[indexPath.row].coHostUserImage, into: cell.imgViewMicUserImage)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == tblViewMicJoinedUsers) {
            
            print("Table view mic joined user wale main click hua hai. iska index path hai \(indexPath.row)")
            // Check if the index is within the bounds of the zegoMicUsersList array
            if zegoMicUsersList.indices.contains(indexPath.row) {
                // Access the mic user details at the specified index
                let userID = zegoMicUsersList[indexPath.row].coHostID ?? ""
                let userName = zegoMicUsersList[indexPath.row].coHostUserName ?? "N/A"
                let userImage = zegoMicUsersList[indexPath.row].coHostUserImage ?? ""
                
                // Call the delegate method with the mic user details
                delegate?.micJoinedUserClicked(userID: userID, userName: userName, userImage: userImage)
            } else {
                // Handle the case where the index is out of bounds
                print("Index out of bounds")
            }

            
        } else if (tableView == tblViewLiveMessage) {
            print("The selected message indexPath is: \(indexPath.row)")
            let image = liveMessages[indexPath.row].userImage ?? ""
            let name = liveMessages[indexPath.row].userName ?? ""
            let level = liveMessages[indexPath.row].level ?? ""
            let id = liveMessages[indexPath.row].userID ?? ""
            
            delegate?.messageClicked(userImage: image, userName: name, userLevel: level, userID: id)
        }
    }
    
}

// MARK: - EXXTENSION FOR USING COLLECTION VIEW DELEGATES AND FUNCTIONS AND THEIR WORKING

extension NewPublishStreamLiveTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == collectionViewBroadList) {
            
            return userInfoList?.count ?? 0
            
        } else {
            
            return coHostRequestList.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == collectionViewBroadList) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BroadJoinCollectionViewCell", for: indexPath) as! BroadJoinCollectionViewCell
            
            
            cell.resetCellState()
            cell.isUserInteractionEnabled = true
            cell.imgViewUserPhoto.layer.cornerRadius = cell.imgViewUserPhoto.frame.height / 2
            cell.imgViewUserPhoto.clipsToBounds = true
            
            // Clear the image first
            cell.imgViewUserPhoto.image = nil
            
            if let imageURL = URL(string: userInfoList?[indexPath.row].faceURL ?? "") {
                KF.url(imageURL)
                    .cacheOriginalImage()
                    .onSuccess { [weak cell] result in
                        DispatchQueue.main.async {
                            cell?.imgViewUserPhoto.image = result.image
                        }
                    }
                    .onFailure { error in
                        print("Image loading failed with error: \(error)")
                        cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                    }
                    .set(to: cell.imgViewUserPhoto)
            } else {
                cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
            
            cell.imgViewUserPhoto.isUserInteractionEnabled = true
            cell.viewMain.isUserInteractionEnabled = true
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestJoinMicUserListCollectionViewCell", for: indexPath) as! RequestJoinMicUserListCollectionViewCell
            
            cell.delegate = self
            cell.btnAcceptRequestOutlet.tag = indexPath.row
            cell.btnRejectRequestOutlet.tag = indexPath.row
            
            cell.lblUserName.text = coHostRequestList[indexPath.row].userName
          
            if let imageURL = URL(string: coHostRequestList[indexPath.row].userImage ?? "") {
                KF.url(imageURL)
                    .cacheOriginalImage()
                    .onSuccess { [weak cell] result in
                        DispatchQueue.main.async {
                            cell?.imgViewUser.image = result.image
                        }
                    }
                    .onFailure { error in
                        print("Image loading failed with error: \(error)")
                        cell.imgViewUser.image = UIImage(named: "UserPlaceHolderImageForCell")
                    }
                    .set(to: cell.imgViewUser)
            } else {
                cell.imgViewUser.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
            
           // loadImage(from: coHostRequestList[indexPath.row].userImage, into: cell.imgViewUser)
            
            return cell
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == collectionViewBroadList) {
            
            let width = (collectionView.bounds.size.width ) / 4
            let height = width - 65
            return CGSize(width: width, height: 40)
            
        } else {
            
            //            let width = (collectionView.bounds.size.width ) / 4
            //            let height = width - 65
            return CGSize(width: 155, height: 110)
            
        }
        
    }
}

//    @objc func keyboardWillShow(_ notification: Notification) {
//           if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//              // self.contentView.bringSubviewToFront(viewMessage)
//               let keyboardHeight = keyboardFrame.cgRectValue.height
//
//               let viewBottomY = viewMessage.frame.origin.y + viewMessage.frame.size.height + 40
//               let keyboardTopY = self.contentView.frame.size.height - keyboardHeight
//
//               if viewBottomY > keyboardTopY {
//
//                   UIView.animate(withDuration: 0.3) {
//                       self.viewMessage.isHidden = false
//                       self.txtFldMessage.text = ""
//                       self.viewMessageBottomConstraints.constant = (viewBottomY - keyboardTopY)
//                       self.viewMessage.frame.origin.y -= (viewBottomY - keyboardTopY)
//                       print("The bottom constraints is \(self.viewMessageBottomConstraints.constant)")
//                       print("The message view frame origin y hai: \(self.viewMessage.frame.origin.y )")
//
//                   }
//               }
//           }
//       }
    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            let viewBottomY = viewMessage.frame.origin.y + viewMessage.frame.size.height + 40
//            let keyboardTopY = self.contentView.frame.size.height - keyboardHeight
//
//            if viewBottomY > keyboardTopY {
//                UIView.animate(withDuration: 0.3) {
//                    self.viewMessage.isHidden = false
//                    self.txtFldMessage.text = ""
//                    self.viewMessageBottomConstraints.constant = keyboardHeight - 15
//                    self.contentView.layoutIfNeeded()
//                    print("The bottom constraints is \(self.viewMessageBottomConstraints.constant)")
//                }
//            }
//        }
//    }

//    @objc func keyboardWillHide(_ notification: Notification) {
//        UIView.animate(withDuration: 0.3) {
//            self.viewMessageBottomConstraints.constant = 0
//            self.contentView.layoutIfNeeded()
//            self.viewMessage.isHidden = true
//            self.txtFldMessage.text = ""
//            print("When keyboard hides, message view origin y is: \(self.viewMessage.frame.origin.y)")
//            print("The bottom constraints at close is \(self.viewMessageBottomConstraints.constant)")
//        }
//    }

    
//       @objc func keyboardWillHide(_ notification: Notification) {
//
//           UIView.animate(withDuration: 0.3) {
//               self.viewMessageBottomConstraints.constant = 0 //self.view.frame.size.height - self.viewComment.frame.size.height - 30
//               self.viewMessage.frame.origin.y = self.contentView.frame.size.height - self.viewMessage.frame.size.height
//               self.viewMessage.isHidden = true
//               self.txtFldMessage.text = ""
//               print("jab keyboard hide hoga tb message view ka origin y hai: \(self.viewMessage.frame.origin.y)")
//               print("The bottom constraints at close is \(self.viewMessageBottomConstraints.constant)")
//
//           }
//       }

