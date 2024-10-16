//
//  PKLiveHostListTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/06/24.
//

import UIKit

protocol delegatePKLiveHostListTableViewCell: AnyObject {

    func buttonInvitePressed(index:Int)
    
}

class PKLiveHostListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var btnInviteOutlet: UIButton!
    
    weak var delegate: delegatePKLiveHostListTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func btnInvitePressed(_ sender: UIButton) {
        
        print("Button Invite Live Host Pressed.")
        btnInviteOutlet.isUserInteractionEnabled = false
        delegate?.buttonInvitePressed(index: sender.tag)
        
    }
    
    func configureUI() {
    
        viewMain.layer.cornerRadius = viewMain.frame.height / 2
        imgView.layer.cornerRadius = imgView.frame.height / 2
        imgView.clipsToBounds = true
        
    }
    
}
