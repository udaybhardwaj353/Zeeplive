//
//  MyAgencyViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 25/09/23.
//

import UIKit


class MyAgencyViewController: UIViewController {

    @IBOutlet weak var imgViewBackground: UIImageView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var lblAgencyName: UILabel!
    @IBOutlet weak var btnAddAgencyOutlet: UIButton!
    @IBOutlet weak var viewAddAgency: UIView!
    @IBOutlet weak var txtfldAgencyID: UITextField!
    @IBOutlet weak var btnSubmitAgencyIdOutlet: UIButton!
    lazy var agencyData = agencyExistsResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        initialiseUI()
        callToCheckAgencyExists()
        
    }
    
    private func initialiseUI() {
    
//        setGradientBackground(for: btnAddAgencyOutlet, colorLeft: GlobalClass.sharedInstance.setButtonLeftColour(), colorMiddle: GlobalClass.sharedInstance.setButtonMiddleColour(), colorRight: GlobalClass.sharedInstance.setButtonRightColour())
        
        btnAddAgencyOutlet.layer.cornerRadius = 20
        txtfldAgencyID.setLeftPaddingPoints(15)
        btnSubmitAgencyIdOutlet.layer.cornerRadius = 20
        
        viewAddAgency.isHidden = true
        btnAddAgencyOutlet.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnAddAgencyPressed(_ sender: Any) {
        
        print("Button Add Agency Pressed")
        viewAddAgency.isHidden = false
        
    }
    
    @IBAction func btnSubmitAgencyIDPressed(_ sender: Any) {
        
        print("Submit Agency Id button pressed")
        if (txtfldAgencyID.text == "") || (txtfldAgencyID.text == nil) {
        
            showAlert(title: "ERROR !", message: "Please enter Agency ID", viewController: self)
            print("agency id textfield khali hai")
            
        } else {
            
            saveAgencyId()
            
        }
        
    }
    
}

// MARK: - EXTENSION FOR API CALLING

extension MyAgencyViewController {
    
    func callToCheckAgencyExists() {
        
        ApiWrapper.sharedManager().checkForAgency(url: AllUrls.getUrl.checkForAgency) { [weak self] (data, value) in
            guard let self = self else { return }
            
            print(data)
            print(value)
            
          agencyData = data ?? agencyData
           print(agencyData)
           
            if (agencyData.name == "") || (agencyData.name == nil) {
                
                print("agency nahi hai")
                btnAddAgencyOutlet.isHidden = false
                lblAgencyName.isHidden = true
                
            } else {
                
                btnAddAgencyOutlet.isHidden = true
                lblAgencyName.isHidden = false
                lblAgencyName.text = "You have associated with" + " " +  (agencyData.name ?? "")
                
            }
        }
    }

 // function to update agency id to the server
    
    func saveAgencyId() {
        
        let params = [
          
            "agency_id": txtfldAgencyID.text!
         
        ] as [String : Any]
        
        print("The params for the agency id is: \(params)")
        
        ApiWrapper.sharedManager().updateHostAgencyID(url:AllUrls.getUrl.saveAgencyId ,parameters: params, completion: {(data) in
            
            if (data["success"] as? Bool == true) {
                print(data)
                
                self.showAlertwithButtonAction(title: "SUCCESS !", message: "Agency ID has been updated successfully.", viewController: self)

            } else {
                
                self.showAlert(title: "ERROR !", message: "Something Went Wrong !", viewController: self)
            }
   
        })
       
    }
    
}
