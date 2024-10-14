//
//  AddNewBankAccountTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 18/03/24.
//

import UIKit

protocol delegateAddNewBankAccountTableViewCell: AnyObject {

    func showBankList(isClicked:Bool)
    func saveBankAccountDetails(name: String, bankName: String, ifscCode: String, bankaccountnumber: String)
    
}

class AddNewBankAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewBeneficiaryName: UIView!
    @IBOutlet weak var viewTxtFldBeneficiaryName: UIView!
    @IBOutlet weak var txtFldBeneficiaryName: UITextField!
    @IBOutlet weak var viewBankName: UIView!
    @IBOutlet weak var viewSelectBankNameOutlet: UIButton!
    @IBOutlet weak var txtFldSelectBankName: UITextField!
    @IBOutlet weak var viewBankIfscCode: UIView!
    @IBOutlet weak var viewTxtFldBankIfscCode: UIView!
    @IBOutlet weak var txtFldIfscCode: UITextField!
    @IBOutlet weak var viewBankAccountNumber: UIView!
    @IBOutlet weak var viewtxtFldAccountNumber: UIView!
    @IBOutlet weak var txtFldAccountNumber: UITextField!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewTxtfldPhoneNumber: UIView!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var btnSaveBankDetailsOutlet: UIButton!
    
    weak var delegate: delegateAddNewBankAccountTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
       configureUI()
        txtFldPhoneNumber.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewSelectBankNamePressed(_ sender: Any) {
        
        print("View Select Bank Name Pressed.")
        delegate?.showBankList(isClicked: true)
        
    }
    
    @IBAction func btnSaveBankDetailsPressed(_ sender: Any) {
        
        print("Button Save Bank Details Pressed.")
        print("India bank account holder name: \(txtFldBeneficiaryName.text)")
        print("India bank name is: \(txtFldSelectBankName.text)")
        print("India bank account number: \(txtFldAccountNumber.text)")
        print("India bank user phone number: \(txtFldPhoneNumber.text)")
        btnSaveBankDetailsOutlet.isUserInteractionEnabled = false
        delegate?.saveBankAccountDetails(name: (txtFldBeneficiaryName.text ?? ""), bankName: (txtFldSelectBankName.text ?? ""), ifscCode: (txtFldIfscCode.text ?? ""), bankaccountnumber: (txtFldAccountNumber.text ?? ""))
        
    }
    
    func configureUI() {
    
        viewTxtFldBeneficiaryName.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewSelectBankNameOutlet.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewTxtFldBankIfscCode.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewtxtFldAccountNumber.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        viewTxtfldPhoneNumber.backgroundColor = GlobalClass.sharedInstance.setGapColour()
        btnSaveBankDetailsOutlet.layer.cornerRadius = btnSaveBankDetailsOutlet.frame.height / 2
        addGradient(to: btnSaveBankDetailsOutlet, width: btnSaveBankDetailsOutlet.frame.width, height: btnSaveBankDetailsOutlet.frame.height, cornerRadius: btnSaveBankDetailsOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        txtFldSelectBankName.isUserInteractionEnabled = false
        
    }
    
}

extension AddNewBankAccountTableViewCell: UITextFieldDelegate {
    
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
