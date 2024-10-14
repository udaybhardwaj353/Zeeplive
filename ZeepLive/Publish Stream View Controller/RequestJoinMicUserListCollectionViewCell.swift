//
//  RequestJoinMicUserListCollectionViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 08/04/24.
//

import UIKit

protocol delegateRequestJoinMicUserListCollectionViewCell: AnyObject {

    func acceptClicked(index:Int)
    func rejectClicked(index:Int)
    
}

class RequestJoinMicUserListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnAcceptRequestOutlet: UIButton!
    @IBOutlet weak var btnRejectRequestOutlet: UIButton!
    
    weak var delegate: delegateRequestJoinMicUserListCollectionViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.layer.cornerRadius = 20
        btnAcceptRequestOutlet.layer.cornerRadius = 10
        imgViewUser.layer.cornerRadius = imgViewUser.frame.height / 2
        imgViewUser.clipsToBounds = true
        
    }
    
    @IBAction func btnAcceptRequestPressed(_ sender: UIButton) {
        
        print("Button Accept Request Pressed.")
        delegate?.acceptClicked(index: sender.tag)
        
    }
    
    @IBAction func btnRejectRequestPressed(_ sender: UIButton) {
        
        print("Button Reject Request Pressed.")
        delegate?.rejectClicked(index: sender.tag)
        
    }
    
}
