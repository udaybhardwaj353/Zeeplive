//
//  FreeTargetSubmitDetailsViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 27/09/23.
//

import UIKit
import MobileCoreServices
import Alamofire

class FreeTargetSubmitDetailsViewController: UIViewController, delegateFreeTargetSubmitDetailsTableViewCell {
   
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    lazy var userName = String()
    lazy var userID = String()
    lazy var userTalent = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialise()
        hideKeyboardWhenTappedAround()
        userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
        userID = UserDefaults.standard.string(forKey: "userId") ?? ""
        print("The username is: \(userName)")
        print("The userID is: \(userID)")
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func initialise() {
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "FreeTargetSubmitDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FreeTargetSubmitDetailsTableViewCell")
    }
    
}

// MARK: - EXTENSION FOR USING TABLE VIEW METHHODS AND IT'S WORKING

extension FreeTargetSubmitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeTargetSubmitDetailsTableViewCell", for: indexPath) as! FreeTargetSubmitDetailsTableViewCell
        
        cell.txtfldUserName.text = userName
        cell.txtfldUserID.text = userID
        
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
        
    }
    
    func uploadVideo(isPressed: Bool,Name:String, ID:String, talent:String) {
        print(isPressed)
        print(Name)
        print(ID)
        print(talent)
        
        if (isPressed == true) {
        
            print("VIdeo wala kaam krna hai")
            
            userName = Name
            userID = ID
            userTalent = talent
            
            showOptionsFromBelow()
            
        } else {
            
            print("Video wala kaam nahi karna hai")
            
        }
        
    }
}

// MARK: - EXTENSION FOR USING IMAGE PICKER VIEW DELEGATE METHODS AND WORKING AND GETTING SELECTED VIDEO URL

extension FreeTargetSubmitDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickVideo() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            present(imagePicker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                // Handle the selected video URL here
                print("Selected video URL: \(url)")
                uploadVideo(videoURL: url)
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    func recordVideo() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .camera
           imagePicker.mediaTypes = [kUTTypeMovie as String]
           present(imagePicker, animated: true, completion: nil)
       }
    
    private func showOptionsFromBelow() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

           let galleryButton = UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
               print("Follow button tapped")
          
               self.pickVideo()
            
           })

        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Follow button tapped")
          
            self.recordVideo()
        
        })
        
//           let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
//               print("Cancel button tapped")
//           })

           alertController.addAction(galleryButton)
           alertController.addAction(cameraButton)

        self.navigationController?.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension FreeTargetSubmitDetailsViewController {
    
    func uploadVideo(videoURL: URL) {
        
        let uploadURL = "https://zeep.live/api/applyFreeTargetVideo"
            
        let parameters: [String: Any] = [
            "full_name": userName,
            "user_id": userID,//UserDefaults.standard.string(forKey: "userId") ?? "",
            "talent": userTalent//"I am a singer"
        ]
        
        print("The parameters we are sending is \(parameters)")
        
        // Define the headers within the multipartFormData closure
        AF.upload(
            multipartFormData: { multipartFormData in
                // Append the video file to the request
                multipartFormData.append(videoURL, withName: "free_target_video", fileName: "video.mov", mimeType: "video/quicktime")
                
                // Append parameters from the dictionary
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: uploadURL,
            method: .post, // Specify the HTTP method if needed
            headers: HTTPHeaders(["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: "token") ?? ""),
                                 "Content-type": "multipart/form-data",
                                 "Content-Disposition" : "form-data"])
        )
        .response { response in
            switch response.result {
            case .success(let data):
                // Handle the success case
                print("Upload successful: \(data)")
                
                if let responseData = data {
                    let responseString = String(data: responseData, encoding: .utf8)
                    print("Upload successful. Response data: \(responseString ?? "")")
                    do {
                        if let responseData = data {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                                if let success = jsonResponse["success"] as? Bool {
                                    print("Success value: \(success)")
                                    if (success == true) {
                                        
                                        self.showAlertwithButtonAction(title: "SUCCESS !", message: "Successfully Updated", viewController: self)
                                        
                                    } else {
                                        
                                        self.showAlert(title: "ERROR !", message: "Something went wrong! Please try again", viewController: self)
                                        
                                    }
                                    
                                } else {
                                    print("No 'success' key in JSON response")
                                }
                            } else {
                                print("Failed to parse JSON response")
                            }
                        } else {
                            print("Upload successful. No response data received.")
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                    
                } else {
                    print("Upload successful. No response data received.")
                }
                
            case .failure(let error):
                // Handle the failure case
                print("Upload failed: \(error)")
            }
        }
    }
}

