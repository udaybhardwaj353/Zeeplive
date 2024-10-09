//
//  AddNewEPayAccountTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 18/03/24.
//

import UIKit

protocol delegateAddNewEPayAccountTableViewCell: AnyObject {

    func createEPayAccountButtonClicked(isClicked: Bool)
    func saveEpayAccount(name: String, emailid: String)
    
}

class AddNewEPayAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewEPayAccountName: UIView!
    @IBOutlet weak var viewTxtFldEPayAccountName: UIView!
    @IBOutlet weak var txtFldAccountName: UITextField!
    @IBOutlet weak var viewEPayEmailID: UIView!
    @IBOutlet weak var viewTxtFldEPayID: UIView!
    @IBOutlet weak var txtFldEMailID: UITextField!
    @IBOutlet weak var viewEPayCountryName: UIView!
    @IBOutlet weak var viewTxtFldEPayCountryName: UIView!
    @IBOutlet weak var txtFldCountryName: UITextField!
    @IBOutlet weak var viewEPayPhoneNumber: UIView!
    @IBOutlet weak var viewTxtFldEPayNumber: UIView!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var btnCreateEPayAccountOutlet: UIButton!
    @IBOutlet weak var btnSaveEpayAccountOutlet: UIButton!
    
    weak var delegate: delegateAddNewEPayAccountTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        configureUI()
        txtFldPhoneNumber.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCreateEPayAccountPressed(_ sender: Any) {
        
        print("Button Create E- Pay Account Pressed.")
        delegate?.createEPayAccountButtonClicked(isClicked: true)
        
     //   openWebView(withURL: "https://www.epay.com/epayweb/register?ref=00649567")
        
    }
    
    @IBAction func btnSaveEpayAccountPressed(_ sender: Any) {
        
        print("Button Save E-Pay Account Details Pressed.")
        btnSaveEpayAccountOutlet.isUserInteractionEnabled = false
        delegate?.saveEpayAccount(name: (txtFldAccountName.text ?? ""), emailid: (txtFldEMailID.text ?? ""))
        
    }
    
    func configureUI() {
    
        viewTxtFldEPayAccountName.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewTxtFldEPayID.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewTxtFldEPayCountryName.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewTxtFldEPayNumber.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        txtFldCountryName.isUserInteractionEnabled = false
       // btnSaveEpayAccountOutlet.layer.cornerRadius = btnSaveEpayAccountOutlet.frame.height / 2
        
        addGradient(to: btnSaveEpayAccountOutlet, width: btnSaveEpayAccountOutlet.frame.width, height: btnSaveEpayAccountOutlet.frame.height, cornerRadius: btnSaveEpayAccountOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
    }
    
}

extension AddNewEPayAccountTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtFldPhoneNumber) {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            print("The count is : \(count)")
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return count <= 10 && allowedCharacters.isSuperset(of: characterSet)
            
        }
        
        return true
    }
}
