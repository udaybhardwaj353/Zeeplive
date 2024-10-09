//
//  EnterUserDetailViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 29/08/23.
//

import UIKit

class EnterUserDetailViewController: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnDoneOutlet: UIButton!
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var txtView: UITextView!
    
    var heading = String()
    var text = String()
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        initialiseUI()
        
    }
    
    private func initialiseUI() {
    
        txtView.delegate = self
        
        viewDetails.layer.cornerRadius = 10
        viewDetails.layer.borderWidth = 1
        viewDetails.layer.borderColor = UIColor.lightGray.cgColor//GlobalClass.sharedInstance.setGrayStripColour().cgColor
       
        print(heading)
        lblHeading.text = heading ?? "Heading"
        btnDoneOutlet.setTitleColor(GlobalClass.sharedInstance.setButtonColour(), for: .normal)
        
        txtView.text = text
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnDonePressed(_ sender: Any) {
        
        print("Done Button Pressed")
        print("The textView text is: \(txtView.text)")
        
        if (txtView.text == "") {
            
            print("Api hit nahi kraenge")
            
        } else {
         
            print("Api hit kraenge")
            
            let replacedString = replaceNumbersWithAsterisks(txtView.text ?? "")
                print(replacedString)
            
            if (index == 2) {
                
                updateUserDetails(name: replacedString, about: "")
                
            } else {
                
                updateUserDetails(name: "", about: replacedString)
                
            }
            
        }
    }
    

}

extension EnterUserDetailViewController {
    
    private func updateUserDetails(name:String, about:String) {
        
        let params = [
            "name": name, //"guest847216383",
            "city": "" , //"460939",
            "dob": "",
            "about_user": about
        ] as [String : Any]
       
        print(params)
        
        ApiWrapper.sharedManager().updateUserDetails(url: AllUrls.getUrl.updateUserProfile,parameters: params) { [weak self] (data) in
            guard let self = self else { return }
            
            if (data["success"] as? Bool == true) {
                print(data)
             
                if (index == 2) {
                    
                    print("Naam save kra do yhn pr")
                    UserDefaults.standard.set(name , forKey: "UserName")
                    showAlertwithButtonAction(title: "SUCCESS !", message: "Your name has been updated successfully", viewController: self)
                    
                } else {
                    
                    print("self introduction save kara do yhn pr")
                    UserDefaults.standard.set(about , forKey: "aboutUser")
                    showAlertwithButtonAction(title: "SUCCESS !", message: "Your self introduction has been updated successfully", viewController: self)
                    
                }
                
            }
            
            else {
                
                print("Kuch gadbad hai")
                
            }
        }
    }
    
}

extension EnterUserDetailViewController: UITextViewDelegate {
    
    // Disable copy, paste, and other text actions
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)) ||
            action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
            return false // Disable these actions
        }
        
        return super.canPerformAction(action, withSender: sender)
        
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == txtView {
            // Limit the number of characters
            guard let textViewText = textView.text,
                  let rangeOfTextToReplace = Range(range, in: textViewText) else {
                return false
            }
            let substringToReplace = textViewText[rangeOfTextToReplace]
            let count = textViewText.count - substringToReplace.count + text.count
            print("The count in text view is: \(count)")

            // Check if the character count exceeds the limit
            if count > 25 {
                return false
            }

            // Prevent numbers from being entered
            let numberRegEx = "[0-9]"
            let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
            
            for char in text {
                if numberTest.evaluate(with: String(char)) {
                    return false
                }
            }

            return true // Allow the change if no numbers are found and count is within the limit
        }
        
        return true
    }
    
}
