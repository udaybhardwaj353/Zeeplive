//
//  MyProfileViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 19/06/23.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {
  
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    lazy var datePicker = UIDatePicker()
    lazy var toolBar = UIToolbar()
    lazy var selectedDate = String()
    
    lazy var imagePicker = UIImagePickerController()
    lazy var selectedImage = UIImage()
    
    lazy var userName: String = ""
    lazy var dateOfBirth: String = ""
    lazy var aboutUser: String = ""
    
    // MARK: - VARIABLE FOR TEXT DETECTION IN AN IMAGE THROUGH ML KIT
    
   // var textRecognizer: VisionTextRecognizer!
   
    // MARK: - VARIABLES FOR FACE DETECTION IN AN IMAGE THROUGH ML KIT
    
   // let options = VisionFaceDetectorOptions()
  //  lazy var vision = Vision.vision()
    
    // MARK: - VARIABLES FOR SHOWING OPTIONS IN NEW MY PROFILE PAGE
    
   lazy var arrOptionName = [String]()
   lazy var age = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
       calculateUserAge()
      initialiseData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
    
        print("The name of user is \(UserDefaults.standard.string(forKey: "UserName"))")
        
        calculateUserAge()
        tblView.reloadData()
        
    }
    
    private func calculateUserAge() {
       
        let userAgeString = UserDefaults.standard.string(forKey: "dob") ?? ""
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        if let userAgeDate = dateFormatter.date(from: userAgeString) {
        
            let formattedUserAge = formatDate(date: userAgeDate)
            
            if let yearDifference = calculateYearDifference(from: formattedUserAge) {
                print("Year difference: \(yearDifference)")
                age = String(yearDifference)
                
            } else {
                age = "0"
                print("Invalid date format")
                
            }
        } else {
            age = "0"
            print("Invalid date format")
            
        }
    }
    
    private func initialiseData() {
        
        imagePicker.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
//        tblView.register(UINib(nibName: "EditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileTableViewCell")
        tblView.register(UINib(nibName: "MyProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "MyProfileTableViewCell")
        
        datePickerFromView()
        dismissKeyboard()
        
     //  configureMLKit()
      arrOptionName = ["My Avatar", "ID", "Nick Name" , "Gender" , "Age", "Region", "Language", "Self- Introduction"]
        
    }
    
 // MARK: - FUNCTION TO CALL FUNCTIONALITIES AND USE PROPERTIES OF ML KIT FOR TEXT AND FACE DETECTION
    
//    private func configureMLKit() {
//        
//        textRecognizer = vision.onDeviceTextRecognizer()
//
//        options.performanceMode = .accurate
//        options.landmarkMode = .all
//        options.classificationMode = .all
//        options.minFaceSize = CGFloat(0.1)
//        
//    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    deinit {

        datePicker.removeTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        toolBar.setItems(nil, animated: false)
        tblView.delegate = nil
        tblView.dataSource = nil
        
    }
    
}

// MARK: - EXTENSION FOR USING DATE SELECT AND SET IT IN THE TEXTFIELD FOR THE USER TO DISPLAY AND SELECT IT

extension MyProfileViewController {
    
    func datePickerFromView() {
        weak var weakSelf = self
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(weakSelf, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
    }
    
    @objc func doneButtonClicked() {
          let dateFormatter = DateFormatter()
          dateFormatter.dateStyle = .medium
          
        selectedDate = formatDate(date: datePicker.date)
        print(selectedDate)
        
        if let yearDifference = calculateYearDifference(from: selectedDate) {
            print("Year difference: \(yearDifference)")
           age = String(yearDifference)
        //    UserDefaults.standard.set(age , forKey: "dob")
            updateUserDetails()
            tblView.reloadData()
        } else {
            age = "0"
            print("Invalid date format")
        //    UserDefaults.standard.set(age , forKey: "dob")
            tblView.reloadData()
        }
        
//        tblView.reloadData()
      }

    
    @objc func dateChange(datePicker:UIDatePicker) {
        
        selectedDate = formatDate(date: datePicker.date)
        print(selectedDate)
        
    }
    
    func formatDate(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd" //"dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func changeDateFormat(inputDate: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy" // Input date format

        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd-MM-yyyy" // Desired output date format

            return outputFormatter.string(from: date)
        } else {
            return nil // Return nil if the input date string is not in the expected format
        }
    }
    
}

// MARK: - EXTENSION FOR TABLE VIEW DELEGATES AND DATASOURCE METHODS FOR THEIR USAGE

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return arrOptionName.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileTableViewCell", for: indexPath) as! MyProfileTableViewCell
            
//            if (indexPath.row == 0) {
//
//                cell.imgViewUserPhoto.isHidden = false
//                cell.imgViewUserPhotoWidthConstraint.constant = 40
//                cell.lblUserDetail.isHidden = true
//                if (selectedImage.cgImage == nil) {
//
//                    if let profilePictureURLString = UserDefaults.standard.string(forKey: "profilePicture"),
//                            let imageURL = URL(string: profilePictureURLString) {
//                        downloadImage(from: imageURL, into: cell.imgViewUserPhoto)
//                         } else {
//
//                             cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
//                         }
//
//                   // cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceholderImage")
//
//                } else {
//
//                    cell.imgViewUserPhoto.image = selectedImage
//
//                }
//
//            } else {
//
//                cell.imgViewUserPhoto.isHidden = true
//                cell.imgViewUserPhotoWidthConstraint.constant = 0
//
//            }
//
//            if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6) {
//
//                cell.imgViewSideArrow.isHidden = true
//                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//
//            } else {
//
//                cell.imgViewSideArrow.isHidden = false
//
//            }
//
//            if (indexPath.row == 7) {
//
//                cell.viewLine.isHidden = true
//                cell.viewMainHeightConstraints.constant = 10
//                cell.lblUserDetail.isHidden = true
//                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//
//            } else {
//
//                cell.viewLine.isHidden = false
//                cell.viewMainHeightConstraints.constant = 0
//
//            }
//
//            if (indexPath.row == 6) {
//
//                cell.lblUserDetail.text = "English"
//                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//
//            }
//
//            if (indexPath.row == 5) {
//
//                cell.lblUserDetail.text = "India"
//                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//            }
//
//            if (indexPath.row == 4) {
//
//                if let yearDifference = calculateYearDifference(from: selectedDate) {
//                    print("Year difference: \(yearDifference)")
//                    cell.lblUserDetail.text = String(yearDifference)
//                    cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//                } else {
//                    cell.lblUserDetail.text = "0"
//                    print("Invalid date format")
//                }
//
//            }
//
//            if (indexPath.row == 3) {
//
//                cell.lblUserDetail.text = "Male"
//                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//            }
//
//            if (indexPath.row == 2) {
//
//                let name = UserDefaults.standard.string(forKey: "UserName")
//
//                cell.lblUserDetail.text = name
//                cell.lblUserDetail.font = UIFont.boldSystemFont(ofSize: 17)
//
//            }
//
//            if (indexPath.row == 1) {
//
//                let id = UserDefaults.standard.string(forKey: "UserProfileId")
//
//                cell.lblUserDetail.text = id//"User ID"
//                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14)
//
//            }
//
            cell.lblOptionName.text = arrOptionName[indexPath.row]
            if (indexPath.row == 4) {
                
                              cell.lblUserDetail.text = age
                              cell.imgViewUserPhoto.isHidden = true
                              cell.lblUserDetail.isHidden = false
                              cell.imgViewUserPhotoWidthConstraint.constant = 0
                              cell.viewLine.isHidden = false
                              cell.viewMainHeightConstraints.constant = 0
                              cell.imgViewSideArrow.isHidden = false
                
                      } else if (indexPath.row == 5) {
                        
                          let city = UserDefaults.standard.string(forKey: "city")
                          
                              cell.lblUserDetail.text = city//"India"
                              cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                              cell.imgViewUserPhoto.isHidden = true
                              cell.lblUserDetail.isHidden = false
                              cell.imgViewUserPhotoWidthConstraint.constant = 0
                              cell.viewLine.isHidden = false
                              cell.viewMainHeightConstraints.constant = 0
                              cell.imgViewSideArrow.isHidden = true
                          
                        }  else if (indexPath.row == 6) {
                        
                                cell.lblUserDetail.text = "English"
                                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                                cell.imgViewUserPhoto.isHidden = true
                                cell.lblUserDetail.isHidden = false
                                cell.imgViewUserPhotoWidthConstraint.constant = 0
                                cell.viewLine.isHidden = false
                                cell.viewMainHeightConstraints.constant = 0
                                cell.imgViewSideArrow.isHidden = true
                            
                    }  else if (indexPath.row == 3) {
                        
                        let gender = UserDefaults.standard.string(forKey: "gender")
                        
                                cell.lblUserDetail.text = gender//"Male"
                                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                                cell.imgViewUserPhoto.isHidden = true
                                cell.lblUserDetail.isHidden = false
                                cell.imgViewUserPhotoWidthConstraint.constant = 0
                                cell.viewLine.isHidden = false
                                cell.viewMainHeightConstraints.constant = 0
                                cell.imgViewSideArrow.isHidden = true
                        
                    } else  if (indexPath.row == 2) {
                        
                            let name = UserDefaults.standard.string(forKey: "UserName")
                        
                                cell.lblUserDetail.text = name
                                cell.lblUserDetail.font = UIFont.boldSystemFont(ofSize: 17)
                                cell.imgViewUserPhoto.isHidden = true
                                cell.lblUserDetail.isHidden = false
                                cell.imgViewUserPhotoWidthConstraint.constant = 0
                                cell.viewLine.isHidden = false
                                cell.viewMainHeightConstraints.constant = 0
                                cell.imgViewSideArrow.isHidden = true
                                cell.imgViewSideArrow.isHidden = false
                        
                    } else  if (indexPath.row == 1) {
                        
                            let id = UserDefaults.standard.string(forKey: "UserProfileId")
                        
                                cell.lblUserDetail.text = id//"User ID"
                                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14)
                                cell.imgViewUserPhoto.isHidden = true
                                cell.lblUserDetail.isHidden = false
                                cell.imgViewUserPhotoWidthConstraint.constant = 0
                                cell.viewLine.isHidden = false
                                cell.viewMainHeightConstraints.constant = 0
                                cell.imgViewSideArrow.isHidden = true
                        
                    } else if (indexPath.row == 7) {
                        
                                cell.viewLine.isHidden = true
                                cell.viewMainHeightConstraints.constant = 10
                                cell.lblUserDetail.isHidden = true
                                cell.lblUserDetail.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                                cell.imgViewUserPhoto.isHidden = true
                                cell.imgViewSideArrow.isHidden = false
                            
                    } else if (indexPath.row == 0) {
                        
                                    cell.imgViewSideArrow.isHidden = false
                                    cell.viewLine.isHidden = false
                                    cell.viewMainHeightConstraints.constant = 0
                                    cell.imgViewUserPhoto.isHidden = false
                                    cell.lblUserDetail.isHidden = true
                        
                                        cell.imgViewUserPhotoWidthConstraint.constant = 40
                                       
                                        if (selectedImage.cgImage == nil) {
                        
                                            if let profilePictureURLString = UserDefaults.standard.string(forKey: "profilePicture"),
                                                    let imageURL = URL(string: profilePictureURLString) {
                                                downloadImage(from: imageURL, into: cell.imgViewUserPhoto)
                                                 } else {
                        
                                                     cell.imgViewUserPhoto.image = UIImage(named: "UserPlaceHolderImageForCell")
                                                 }
                                        } else {
                        
                                            cell.imgViewUserPhoto.image = selectedImage
                        
                                        }
                        
                                    }
            
            
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileTableViewCell", for: indexPath) as! MyProfileTableViewCell
//
         
            cell.viewMainHeightConstraints.constant = 0
            cell.imgViewUserPhotoWidthConstraint.constant = 15
            cell.imgViewUserPhoto.contentMode = .scaleAspectFit

            cell.lblOptionName.text = "Phone"
            cell.lblUserDetail.text = "Bind Phone Number"
            cell.imgViewUserPhoto.image = UIImage(named: "TickImage")

            let number = UserDefaults.standard.string(forKey: "mobileNumber")

            if (number == "") || (number == nil) {

                cell.lblUserDetail.text = "Bind Phone Number"
                cell.imgViewUserPhoto.isHidden = true
                cell.imgViewSideArrow.isHidden = false
                
            } else {

                cell.lblUserDetail.text = number
                cell.imgViewUserPhoto.isHidden = false
                cell.imgViewSideArrow.isHidden = true
                
            }
            
            cell.selectionStyle = .none
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
     return 55
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
       
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
            
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
              
                present(imagePicker, animated: true, completion: nil)
                
            } else if (indexPath.row == 4){
                
                showDatePicker()
                
            } else if ( indexPath.row == 7) || (indexPath.row == 2 ) { /*if ( indexPath.row == 2 || indexPath.row == 7) {*/
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EnterUserDetailViewController") as! EnterUserDetailViewController
                nextViewController.heading = arrOptionName[indexPath.row]
                if (indexPath.row == 2) {
                    
                    nextViewController.text = (UserDefaults.standard.string(forKey: "UserName") ?? "")
                    nextViewController.index = indexPath.row
                    
                } else {
                    
                    nextViewController.text = (UserDefaults.standard.string(forKey: "aboutUser") ?? "")
                    nextViewController.index = indexPath.row
                    
                }
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
            }
            
        } else {
            let number = UserDefaults.standard.string(forKey: "mobileNumber")
            
            if (number == "") || (number == nil) {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BindPhoneNumberViewController") as! BindPhoneNumberViewController
                nextViewController.number = (UserDefaults.standard.string(forKey: "mobileNumber") ?? "")
                self.navigationController?.pushViewController(nextViewController, animated: true)
            } else {
                print("User ka phone number pehle se hi bind hai.")
            }
            
        }
        
    }
    
    func showDatePicker() {
        // Set up and show the date picker
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(datePicker)
        alertController.view.addSubview(toolBar)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            // Handle the selection of the date
            self.doneButtonClicked()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

//extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       return 1
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as! EditProfileTableViewCell
//
//
//            cell.viewImageOne.isHidden = true
//            cell.viewImageTwo.isHidden = true
//            cell.viewImageThree.isHidden = true
//
//            cell.txtfldUserBirthdayDate.inputView = datePicker
//            cell.txtfldUserBirthdayDate.inputAccessoryView = toolBar
//            cell.txtfldUserBirthdayDate.text = selectedDate
//
//            cell.delegate = self
//
//            if (selectedImage.cgImage == nil) {
//
//                if let profilePictureURLString = UserDefaults.standard.string(forKey: "profilePicture"),
//                        let imageURL = URL(string: profilePictureURLString) {
//                    downloadImage(from: imageURL, into: cell.imgViewUserImage)
//                     } else {
//
//                         cell.imgViewUserImage.image = UIImage(named: "UserPlaceholderImage")
//
//                     }
//
//            } else {
//
//                cell.imgViewUserImage.image = selectedImage
//
//            }
//            cell.selectionStyle = .none
//            return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 620
//
//    }

//// MARK: - DELEGATE FUNCTION OF EDIT PROFILE TABLE VIEW CELL TO KNOW WHEN THE IMAGE VIEW IS BEING CLICKED
//
//    func imageViewSelected(isSelected: Bool) {
//
//        print(isSelected)
//        print("Upload image view is selected. And Delegate method is being called")
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = .photoLibrary

//        present(imagePicker, animated: true, completion: nil)
//
//    }

// // MARK: - DELEGATE FUNCTION OF EDIT PROFILE TABLE VIEW CELL TO KNOW WHEN THE SAVE USER DATA BUTTON IS CLICKED
//
//    func saveButtonPressed(name: String, city: String, introduction: String) {
//
//        print(name)
//        print(city)
//        print(introduction)
//        updateUserDetails(name: name, city: city, aboutUser: introduction)
//
//    }
    

// MARK: - EXTENSION FOR USING UIIMAGE PICKERVIEW CONTROL DELEGATE AND HANDLE IMAGE SELECTION AND SENDING IMAGE TO THE SERVER FOR UPDATION

extension MyProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        if let editedImage = info[.editedImage] as? UIImage {
    
            selectedImage = editedImage
            
            uploadImageToServer()
            
            } else if let originalImage = info[.originalImage] as? UIImage {
              
                selectedImage = originalImage
                
                uploadImageToServer()

                
            }
                
        dismiss(animated: true, completion: nil)
        tblView.reloadData()
    }
    
}

// MARK: - EXTENSION FOR API CALLING

extension MyProfileViewController {
    
    // MARK: - FUNCTION TO UPLOAD IMAGE SELECTED BY THE USER TO THE SERVER
    
    private func uploadImageToServer() {
        let url = URL(string: "https://zeep.live/api/update-profile-new-review")!
        let parameters: [String: Any] = [
            "is_album": false
        ]

        ApiWrapper.sharedManager().uploadImageToServer(image: selectedImage, url: url, parameters: parameters) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let dictionary):

                print(dictionary)
                print(dictionary["data"])

                let a = dictionary["data"] as? [String: Any]
                print(a)
                print(a?["image_name"])  // isse image name milega jo server se response aa rha hai image upload ke success hone par
                UserDefaults.standard.set(a?["image_name"] as? String , forKey: "profilePicture")
                print(UserDefaults.standard.string(forKey: "profilePicture"))

                dismiss(animated: true, completion: nil)
                tblView.reloadData()

            case .failure(let error):

                dismiss(animated: true, completion: nil)
                showAlert(title: "ERROR !", message: "This image cannot be uploaded. Please select another image", viewController: self)
                print(error)
            }
        }
    }

// MARK: - FUNCTION TO UPDATE USER DETAILS AND SEND DATA TO THE SERVER
    
    private func updateUserDetails() {
        
         let formattedDate = changeDateFormat(inputDate: selectedDate)
            print(formattedDate) // Output: "25-01-1997"
      
        
        let params = [
            "name": "", //"guest847216383",
            "city": "" , //"460939",
            "dob": formattedDate,
            "about_user": ""
        ] as [String : Any]
        print("The params for date are \(params)")
        ApiWrapper.sharedManager().updateUserDetails(url: AllUrls.getUrl.updateUserProfile,parameters: params) { [weak self] (data) in
            guard let self = self else { return }
            
            if (data["success"] as? Bool == true) {
                print(data)
                UserDefaults.standard.set(selectedDate , forKey: "dob")
                print("sab shi hai. kuch gadbad nahi hai")
               // showAlertwithButtonAction(title: "SUCCESS !", message: "Your Profile has been updated successfully", viewController: self)
                
            }
            
            else {
                
                print("Kuch gadbad hai")
                
            }
        }
    }
}

//// MARK: - EXTENSION FOR USING FIREBASE ML KIT TO RECOGNIZE THE TEXT IN A IMAGE
//
//extension MyProfileViewController {
//
//    func runTextRecognition(with image: UIImage) {
//        let visionImage = VisionImage(image: image)
//        
//        textRecognizer.process(visionImage) { [weak self] (features, error) in
//            guard let self = self else { return }
//            
//            if error == nil, let result = features {
//                print("text hai image mai")
//                dismiss(animated: true, completion: nil)
//                showAlert(title: "ERROR !", message: "This image cannot be uploaded. Please select another image", viewController: self)
//            } else {
//                print("Koi error nahi hai .. sab shi hai.. koi bhi text nahi hai image main")
//                runFaceRecognition(with: self.selectedImage)
//            }
//        }
//    }
//
//}
//
//// MARK: - EXTENSION FOR USING FIREBASE ML KIT TO RECOGNIZE THE FACE IN THE IMAGE
//
//extension MyProfileViewController {
//
//    func runFaceRecognition(with image: UIImage) {
//        let faceDetector = vision.faceDetector(options: options)
//        let visionImage = VisionImage(image: image)
//
//        faceDetector.process(visionImage) { [weak self] (faces, error) in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Error in face detection:", error.localizedDescription)
//                return
//            }
//
//            if let faces = faces, !faces.isEmpty {
//                print("chehra hai")
//                print(faces.count)
//
//                if faces.count == 1 {
//                    print("Image shi hai server pr bhej do isko")
//                    uploadImageToServer()
//                } else {
//                    print("Image shi nhi hai server pr mat bhejo isko")
//                    dismiss(animated: true, completion: nil)
//                    showAlert(title: "ERROR !", message: "This image cannot be uploaded as there are multiple faces in it. Please select another photo.", viewController: self)
//                }
//            } else {
//                print("Koi bhi chehra nahi hai")
//                dismiss(animated: true, completion: nil)
//                showAlert(title: "ERROR !", message: "This image cannot be uploaded. Please select another image", viewController: self)
//            }
//        }
//    }
//
//}
