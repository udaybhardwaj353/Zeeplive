//
//  BasicInformationViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 22/12/23.
//

import UIKit

class BasicInformationViewController: UIViewController {
   
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var userName = String()
    lazy var userAge = String()
    lazy var userGender: String = ""
    lazy var userAgencyID = String()
    lazy var imagePicker = UIImagePickerController()
    lazy var selectedImage = UIImage()
    lazy var userID = String()
    lazy var imageURL = String()
    lazy var emailID = String()
    lazy var loginType: String = ""
    lazy var phoneNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("The image url is: \(imageURL)")
        downloadGoogleImage()
        
        imagePicker.delegate = self
        hideKeyboardWhenTappedAround()
        registerTableView()
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed on Basic Information Page")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func registerTableView() {
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "BasicInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "BasicInformationTableViewCell")
        
    }
    
    func downloadGoogleImage() {
        

        guard let imageURL = URL(string: imageURL) else {
              print("Invalid URL")
              // Handle the case where the URL is invalid
              return
          }
        
        downloadImageLocal(from: imageURL) { [weak self] image in
            guard let self = self else { return }

            if let downloadedImage = image {
                selectedImage = downloadedImage
                print("The selected image is: \(selectedImage)")
                tblView.reloadData()
                
            } else {
                // Handle failure to download image
            }
        }
    }
    
}

// MARK: - EXTENSION FOR TABLE VIEW DELEGATES AND DATASOURCE METHODS AND THEIR FUNCTIONALITY

extension BasicInformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInformationTableViewCell", for: indexPath) as! BasicInformationTableViewCell
      
        addGradient(to: cell.btnContinueOutlet, width: cell.btnContinueOutlet.frame.width, height: cell.btnContinueOutlet.frame.height, cornerRadius: cell.btnContinueOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
        if (selectedImage.cgImage == nil) {

                cell.imgViewUserPhoto.image = UIImage(named: "UserByDefaultPhoto")
            
                 } else {

                     cell.imgViewUserPhoto.image = selectedImage
                 }
        
        if (userGender == "Female") {
            
            cell.viewAgencyID.isHidden = false
            
        } else {
            
            cell.viewAgencyID.isHidden = true
            
        }
            cell.txtfldGender.text = userGender
            cell.txtfldAge.text = userAge
            cell.txtfldAgencyID.text = userAgencyID
            cell.txtfldName.text = userName
        
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 750//self.tblView.frame.height
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
      
    }
    
}

// MARK: - EXTENSION FOR DELEGATES FUNCTIONS TO GET DATA ENTERED BY THE USER

extension BasicInformationViewController: delegateBasicInformationTableViewCell, delegateChooseGenderViewController, delegateCalendarViewController {

    func selectImagePressed() {
        
        print("Select Image wala press hua hai")
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
      
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func selectGenderPressed() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChooseGenderViewController") as! ChooseGenderViewController
      
        nextViewController.genderSelected = userGender
        nextViewController.delegate = self
        nextViewController.modalPresentationStyle = .overCurrentContext
        
        present(nextViewController, animated: true, completion: nil)
        
        print("Gender select karne ke liye view press hua hai")
        
    }
    
    func buttonSubmitDetailsPressed(name: String, agencyid: String) {
        
        print("Details submit karne wali button press hui hai")
        
        userName = name
        userAgencyID = agencyid
        
            print("User ka gender male hai uske according condition lgengi")
        print("User ka name hai : \(userName)")
        print("User ka agency id hai: \(userAgencyID)")
        
        
            if (userName == "" || userAge == "" || userGender == "") {
                
                print("Message dikhao saari details daalni hai")
                showAlert(title: "ERROR!", message: "Please Enter All Details.", viewController: self)
                
            } else {
                
                if let visibleCells = self.tblView?.visibleCells, visibleCells.count > 0 {
                    if let cell = visibleCells[0] as? BasicInformationTableViewCell {
                        // Work with cell
                        cell.btnContinueOutlet.isUserInteractionEnabled = false
                    }
                }
                // Example usage:
                let inputString = userName

                if inputString.containsEmoji() {
                    print("String contains an emoji.")
                    showAlert(title: "ERROR!", message: "Please enter proper name without any special characters or emoji.", viewController: self)
                } else {
                    print("String is a valid phone number or email.")
                    registerUser()
                }
                
                print("User ka registration karva do gender chahein jo bhi ho")

            }
        
        //                else if inputString.containsNonPhoneOrEmailCharacters() {
        //                    print("String contains something other than a phone number or email.")
        //                }
        
    }
    
    func nameEntered(name: String) {
        
        print("The user name entered in textfield is: \(name)")
            userName = name
        print("User ka naam hai : \(userName)")
        
    }
    
    func agencyEntered(agencyid: String) {
        
        print("User ki agency id hai: \(agencyid)")
        userAgencyID = agencyid
        print("User ki agency id hai: \(userAgencyID)")
        
    }
    
    func selectAgePressed() {
        
        print("Age select karne ke liye button press hui hai")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: false)
        
    }
    
    func dobOfUser(date: String) {
        
        print("The date of birth of user is: \(date)")
        userAge = date
        print("The user age is: \(userAge)")
        tblView.reloadData()
        
    }
    
    func genderSelectedByUser(gender: String) {
        
        print("The selected gender is: \(gender)")
        
        userGender = gender
        print("The user gender is: \(userGender)")
        tblView.reloadData()
        
    }
    
}

// MARK: - EXTENSION FOR IMAGE PICKER VIEW FUNCTIONALITY AND IT'S WORKING FOR SELECTING IMAGE FROM GALLERY

extension BasicInformationViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        if let editedImage = info[.editedImage] as? UIImage {
    
            selectedImage = editedImage
            
            } else if let originalImage = info[.originalImage] as? UIImage {
              
                selectedImage = originalImage
                
            }
                
        dismiss(animated: true, completion: nil)
        tblView.reloadData()
    }
    
}

// MARK: - EXTENSION FOR API CALLING

extension BasicInformationViewController {
    
    private func registerUser() {
        
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
                // Handle the case when 'uniquedeviceid' is nil
                return
            }
        
        let url = URL(string: "https://zeep.live/api/deviceregistration")!
        let parameters: [String: Any] = [
            "login_type": loginType,
                "device_id": GlobalClass.sharedInstance.MYUUID!,
                "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
                "username": userID,
                "name": userName,
                "agency_id": userAgencyID,
                "dob": userAge,
                "gender": userGender,
                "unique_device_id": uniqueId,
                "email": emailID,
                "mobile":phoneNumber,
                "device_type":"ios"
        ]

        print("The params we are sending for the user registration is: \(parameters)")
        
        ApiWrapper.sharedManager().uploadImageToServer(image: selectedImage, url: url, parameters: parameters) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let dictionary):
                
                print(dictionary)
                  
                
                let a = dictionary as? [String:Any]
                
                let b = a?["result"] as? [String:Any]
                print(b)
                
                if (a?["success"] as? Bool == true) {
                    
                    UserDefaults.standard.set(b?["token"] as? String , forKey: "token")
                    UserDefaults.standard.set(b?["name"] as? String ?? "No Name", forKey: "UserName")
                    UserDefaults.standard.set(b?["profile_id"] as? Int, forKey: "UserProfileId")
                    
                    
                    guard let navigationController = navigationController else { return }
                    var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
                    let temp = navigationArray.last
                    navigationArray.removeAll()
                    navigationArray.append(temp!) //To remove all previous UIViewController except the last one
                    navigationController.viewControllers = navigationArray
                        
                        print("Phir isse home page par bhej do")
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                        navigationController.pushViewController(nextViewController, animated: true)
                    
                } else {
                    
                    if let visibleCells = self.tblView?.visibleCells, visibleCells.count > 0 {
                        if let cell = visibleCells[0] as? BasicInformationTableViewCell {
                            // Work with cell
                            cell.btnContinueOutlet.isUserInteractionEnabled = true
                        }
                    }
                    showAlert(title: "ERROR !", message: b?["error"] as? String ?? "Something Went Wrong !", viewController: self)
                    
                }
                    
                    
            case .failure(let error):

                showAlert(title: "ERROR !", message: "Something Went Wrong !", viewController: self)
                print(error)
                if let visibleCells = self.tblView?.visibleCells, visibleCells.count > 0 {
                    if let cell = visibleCells[0] as? BasicInformationTableViewCell {
                        // Work with cell
                        cell.btnContinueOutlet.isUserInteractionEnabled = true
                    }
                }
                
            }
        }
    }
    
}

//                guard let cell = self.tblView?.visibleCells[0] as? BasicInformationTableViewCell else {
//                // Handle the case where the cell cannot be cast to BasicInformationTableViewCell
//                return
//            }
