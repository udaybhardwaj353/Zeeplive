//
//  LoginViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 02/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var imgViewLogo: UIImageView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var txtfldPhoneNoOrEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtfldPassword: UITextField!
    @IBOutlet weak var btnLoginOutlet: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewPhoneNumber.layer.cornerRadius = 25
        viewPassword.layer.cornerRadius = 25
        btnLoginOutlet.layer.cornerRadius = 25
        btnLoginOutlet.backgroundColor = GlobalClass.sharedInstance.buttonLoginColour()
        self.hideKeyboardWhenTappedAround()
        txtfldPassword.delegate = self
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeFromParent()
        
    }
 // MARK: - BUTTONS ACTIONS AND THEIR FUNCTIONALITIES
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        print("Button Login Pressed")
        
        if (txtfldPhoneNoOrEmail.text == "") || (txtfldPassword.text == "") {
            print("Text field abhi khali hai")
            
            showAlert(title: "ERROR !", message: "Please enter proper credentials !", viewController: self)
            
        } else {
            userLogin()
        }
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    deinit {
      
        NotificationCenter.default.removeObserver(self)
        imgViewBackground = nil
        imgViewLogo = nil
        viewPhoneNumber.removeFromSuperview()
        viewPassword.removeFromSuperview()
        
        print("Login View Controller mai deinit call hua hai")
    }
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA FROM THE SERVER

extension LoginViewController {
    
    func userLogin() {
        
//        let params = [
//            "username": txtfldPhoneNoOrEmail.text, //"guest847216383",
//            "password": txtfldPassword.text , //"460939",
//            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
////            "device_id": "2b75f3f9ef230acf",
////            "fixed_device_id": "ffffffff-d6e4-8e24-ffff-ffffdc8ff18d",
//        ] as [String : Any]
        let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid")!
        let hashkey = GlobalClass.sharedInstance.bundleId?.data(using: .utf8)?.sha256.lowercased()
        
        let params = [
            "username": txtfldPhoneNoOrEmail.text!, //"guest847216383",
            "password": txtfldPassword.text! , //"460939",
            "myhaskey":  "/dGr/7cUOEQ2nhPIF176za7y5Rg=", //hashkey! ,  //"/dGr/7cUOEQ2nhPIF176za7y5Rg=",
            "device_id": GlobalClass.sharedInstance.MYUUID!,
            "unique_device_id": uniqueId
        ] as [String : Any]
        
        print("The params we are sending in the device manual login is: \(params)")
        
        ApiWrapper.sharedManager().userLogin(url:AllUrls.getUrl.manualLogin ,parameters: params, completion: {(data) in
            
            if (data["success"] as? Bool == true) {
                print(data)
                
                let a = data as? [String:Any]
                print(a)
                
                let b = a?["result"] as? [String:Any]
                print(b)
                
                UserDefaults.standard.set(b?["token"] as? String , forKey: "token")
                UserDefaults.standard.set(b?["name"] as? String ?? "No Name", forKey: "UserName")
                UserDefaults.standard.set(b?["profile_id"] as! Int, forKey: "UserProfileId")
                
                guard let navigationController = self.navigationController else { return }
                var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
                let temp = navigationArray.last
                navigationArray.removeAll()
                navigationArray.append(temp!) //To remove all previous UIViewController except the last one
                self.navigationController?.viewControllers = navigationArray
                
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)

            }
              else {
            
                  self.showAlert(title: "ERROR !", message: "You Cannot Login in the ZeepLive. Please Contact Admin!", viewController: self)

                
            }
        })
       
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtfldPassword) {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            print("The count in verify otp textfield is : \(count)")
            
            return count <= 30
            
        }
        
        return true
    }
}
