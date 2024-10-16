//
//  EditProfileTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 19/06/23.
//

import UIKit

protocol delegateEditProfileTableViewCell: AnyObject {
    
    func imageViewSelected(isSelected:Bool)
    func saveButtonPressed(name:String,city:String,introduction:String)
    
}

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewUserImageOutlet: UIControl!
    @IBOutlet weak var imgViewUserImage: UIImageView!
    
    @IBOutlet weak var viewAddAlbumOutlet: UIControl!
    @IBOutlet weak var viewImageOne: UIView!
    @IBOutlet weak var viewImageTwo: UIView!
    @IBOutlet weak var viewImageThree: UIView!
    
    @IBOutlet weak var imgViewOne: UIImageView!
    @IBOutlet weak var imgViewTwo: UIImageView!
    @IBOutlet weak var imgViewThree: UIImageView!
    
    @IBOutlet weak var viewUsersDetails: UIView!
    
    @IBOutlet weak var txtfldUserName: UITextField!
    @IBOutlet weak var txtfldUserCity: UITextField!
    @IBOutlet weak var txtfldUserBirthdayDate: UITextField!
    @IBOutlet weak var txtfldYourIntroduction: UITextField!
    
    @IBOutlet weak var btnSaveOutlet: UIButton!
    
    weak var delegate: delegateEditProfileTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgViewUserImage.layer.borderWidth = 1.0
        imgViewUserImage.layer.masksToBounds = false
        imgViewUserImage.layer.borderColor = UIColor.white.cgColor
        imgViewUserImage.layer.cornerRadius = imgViewUserImage.frame.size.width / 2
        imgViewUserImage.clipsToBounds = true
        
        btnSaveOutlet.layer.cornerRadius = 20
        
        txtfldUserName.setUnderLineOfColor(color: .darkGray, width: 0)
        txtfldUserCity.setUnderLineOfColor(color:.darkGray, width: 0)
        txtfldUserBirthdayDate.setUnderLineOfColor(color: .darkGray, width: 0)
        txtfldYourIntroduction.setUnderLineOfColor(color: .darkGray, width: 0)
        
        txtfldUserName.setPlaceholderColor(placeholder: "Name", textField: txtfldUserName)
        txtfldUserCity.setPlaceholderColor(placeholder: "City", textField: txtfldUserCity)
        txtfldUserBirthdayDate.setPlaceholderColor(placeholder: "Date of birth", textField: txtfldUserBirthdayDate)
        txtfldYourIntroduction.setPlaceholderColor(placeholder: "Tell us about yourself", textField: txtfldYourIntroduction)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    @IBAction func viewAddAlbumPressed(_ sender: Any) {
        
        print("View add album pressed for adding images")
        
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        
        print("Button save user details pressed")
        print(txtfldUserName.text)
        print(txtfldUserCity.text)
        print(txtfldYourIntroduction.text)
        delegate?.saveButtonPressed(name: (txtfldUserName.text ?? ""), city: (txtfldUserCity.text ?? ""), introduction: (txtfldYourIntroduction.text ?? ""))
        
    }
    
    @IBAction func viewUserImagePressed(_ sender: Any) {
        
        print("View User Image Pressed")
        delegate?.imageViewSelected(isSelected: true)
        
    }
    
    deinit {
        
        imgViewOne = nil
        imgViewTwo = nil
        imgViewThree = nil
        delegate = nil
        txtfldUserCity = nil
        txtfldUserName = nil
        txtfldYourIntroduction = nil
        txtfldUserBirthdayDate = nil
        NotificationCenter.default.removeObserver(self)
        
    }
    
}
