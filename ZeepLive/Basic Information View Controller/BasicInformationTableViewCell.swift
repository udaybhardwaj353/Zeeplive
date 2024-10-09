//
//  BasicInformationTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 22/12/23.
//

import UIKit

protocol delegateBasicInformationTableViewCell: AnyObject {
    
    func selectImagePressed()
    func selectGenderPressed()
    func buttonSubmitDetailsPressed(name:String,agencyid:String)
    func selectAgePressed()
    func nameEntered(name:String)
    func agencyEntered(agencyid:String)
    
}

class BasicInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewImageOutlet: UIControl!
    @IBOutlet weak var imgViewUserPhoto: UIImageView!
    @IBOutlet weak var btnSelectImageOutlet: UIButton!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var txtfldName: UITextField!
    @IBOutlet weak var viewAgeOutlet: UIControl!
    @IBOutlet weak var txtfldAge: UITextField!
    @IBOutlet weak var viewSelectGenderOutlet: UIControl!
    @IBOutlet weak var txtfldGender: UITextField!
    @IBOutlet weak var btnSelectGenderDropDownOutlet: UIButton!
    @IBOutlet weak var viewAgencyID: UIView!
    @IBOutlet weak var txtfldAgencyID: UITextField!
    @IBOutlet weak var btnContinueOutlet: UIButton!
    
    weak var delegate: delegateBasicInformationTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       configureUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        
        viewImageOutlet.isUserInteractionEnabled = true
        viewAgeOutlet.isUserInteractionEnabled = true
        viewSelectGenderOutlet.isUserInteractionEnabled = true
       
        txtfldName.setUnderLineOfColor(color: .lightGray, width: 1)
        txtfldAge.setUnderLineOfColor(color: .lightGray, width: 1)
        txtfldGender.setUnderLineOfColor(color: .lightGray, width: 1)
        txtfldAgencyID.setUnderLineOfColor(color: .lightGray, width: 1)
       // btnContinueOutlet.layer.cornerRadius = 20
//        addGradient(button: btnContinueOutlet, width: btnContinueOutlet.frame.width, height: btnContinueOutlet.frame.height, cornerRadius: btnContinueOutlet.frame.height / 2)
        imgViewUserPhoto.layer.masksToBounds = false
        imgViewUserPhoto.layer.cornerRadius = imgViewUserPhoto.frame.size.width / 2
        imgViewUserPhoto.clipsToBounds = true
        
        txtfldName.delegate = self
        txtfldAgencyID.delegate = self
        
    }
    
    @IBAction func viewImagePressed(_ sender: Any) {
        
        print("View Image Pressed for selecting image by the user")
        delegate?.selectImagePressed()
        
    }
    
    @IBAction func btnSelectImagePressed(_ sender: Any) {
        
        print("Button Select Image pressed for select image by the user")
        delegate?.selectImagePressed()
        
    }
    
    @IBAction func viewSelectGenderPressed(_ sender: Any) {
        
        print("View select gender pressed by the user")
        delegate?.selectGenderPressed()
        
    }
    
    @IBAction func btnSelectGenderPressed(_ sender: Any) {
        
        print("Button DropDown for selecting gender by the user pressed")
        delegate?.selectGenderPressed()
        
    }
    
    @IBAction func btnContinuePressed(_ sender: Any) {
        
        print("Button Continue Pressed for registering new user ")
        delegate?.buttonSubmitDetailsPressed(name: txtfldName.text ?? "No Name", agencyid: txtfldAgencyID.text ?? "No Agency ID")
        
    }
    
    @IBAction func viewAgePressed(_ sender: Any) {
        
        print("View Age Pressed")
        delegate?.selectAgePressed()
        
    }
    
}

extension BasicInformationTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtfldName {
            // Perform actions when name text field finishes editing
            if let name = textField.text {
                // Handle the entered name here
                print("Name entered: \(name)")
                delegate?.nameEntered(name: name)
                
            }
        } else if textField == txtfldAgencyID {
            // Perform actions when agency ID text field finishes editing
            if let agencyID = textField.text {
                // Handle the entered agency ID here
                print("Agency ID entered: \(agencyID)")
                delegate?.agencyEntered(agencyid: agencyID)
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // You can handle the return key press if needed
        // For example, moving to the next field or dismissing the keyboard
        textField.resignFirstResponder()
        return true
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == txtfldName {
               // Allow only letters and spaces (if spaces are allowed) in the text field
               let allowedCharacters = CharacterSet.letters.union(.whitespaces)
               let characterSet = CharacterSet(charactersIn: string)
               
               // Get the current text and the proposed updated text
               let currentText = textField.text ?? ""
               guard let stringRange = Range(range, in: currentText) else { return false }
               let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
               
               // Ensure the updated text is within the length limit and contains only allowed characters
               return updatedText.count <= 100 && allowedCharacters.isSuperset(of: characterSet)
           }
           return true
       }
    
}
