//
//  PostMomentViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/01/24.
//

import UIKit
import Alamofire
import UniformTypeIdentifiers

class PostMomentViewController: UIViewController, delegatePostMomentImageCollectionViewCell {
 
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnPostMomentOutlet: UIButton!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var viewMain: UIView!
    
   lazy var selectedImages = [UIImage]()
    lazy var count: Int = 0
    lazy var optionName: String = ""
     var videoUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        configureUI()
        registerCollectionView()
       // returnToHomePage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        selectedImages.removeAll()
        videoUrl = nil
        
    }
    
    func returnToHomePage() {
      
        if let viewControllers = self.navigationController?.viewControllers {
            // Define a variable to hold the view controllers to keep
            var viewControllersToKeep: [UIViewController] = []

            // Loop through the view controllers to find MomentsSwipeViewController and construct viewControllersToKeep
            for viewController in viewControllers {
                if viewController is MomentsSwipeViewController {
                    viewControllersToKeep.append(viewController)
                    break
                }
                // Only keep MomentsSwipeViewController and dismiss the others
                viewControllersToKeep.append(viewController)
            }

            // Set the updated stack with only MomentsSwipeViewController and pop back to it
            self.navigationController?.setViewControllers(viewControllersToKeep, animated: true)
        }
        
        //        // Get a reference to the view controllers currently on the navigation stack
        //        if let viewControllers = self.navigationController?.viewControllers {
        //            // Loop through the view controllers to find MomentsSwipeViewController
        //            for viewController in viewControllers {
        //                if viewController is MomentsSwipeViewController {
        //                    // Pop back to MomentsSwipeViewController
        //                    self.navigationController?.popToViewController(viewController, animated: true)
        //                    break
        //                }
        //            }
        //        }
        
    }
    
    func configureUI() {
    
        tabBarController?.tabBar.isHidden = true
        txtViewMessage.delegate = self
        txtViewMessage.addPlaceholder("Say Something...")
        
        viewMain.backgroundColor = GlobalClass.sharedInstance.setPostMomentBackgroundColour()
        print("The Selected Images count are: \(selectedImages.count)")
        count = selectedImages.count
        
    }
    
    func registerCollectionView() {
        
        collectionView.register(UINib(nibName: "PostMomentImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostMomentImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnPostMomentPressed(_ sender: Any) {
        
        print("Button Post Moment For Upload Pressed")
        print("The moment type is: \(optionName)")
        
        showLoader()
        btnPostMomentOutlet.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        
        if (optionName == "recordvideo") {
        
            print("Jo video record hui hai woh bhejni hai.")
            if let url = videoUrl {
                if (selectedImages.count == 0) {
                    
                    print("Image upload nahi hogi")
                    btnPostMomentOutlet.isUserInteractionEnabled = true
                    self.view.isUserInteractionEnabled = true
                    hideLoader()
                    showAlert(title: "ERROR!", message: "Select atleast one image/video to upload", viewController: self)
                    
                } else {
                    btnPostMomentOutlet.isUserInteractionEnabled = false
                    self.view.isUserInteractionEnabled = false
                    uploadVideo(videoURL: url)
                }
            } else {
                print("The video URL is nil.")
                hideLoader()
                self.view.isUserInteractionEnabled = true
                btnPostMomentOutlet.isUserInteractionEnabled = true
                
            }
            
        } else if (optionName == "image") {
            
            print("User ne jo images select ki hai usko bhejna hai")
            if (selectedImages.count == 0) {
                
                print("Image upload nahi hogi")
                btnPostMomentOutlet.isUserInteractionEnabled = true
                self.view.isUserInteractionEnabled = true
                hideLoader()
                showAlert(title: "ERROR!", message: "Select atleast one image/video to upload", viewController: self)
                
            } else {
                btnPostMomentOutlet.isUserInteractionEnabled = false
                self.view.isUserInteractionEnabled = false
                uploadImage()
            }
        } else if (optionName == "video") {
            
            print("User ne jo video select kia hai usko bhejna hai.")
            
            if let url = videoUrl {
               
                if (selectedImages.count == 0) {
                    
                    print("Image upload nahi hogi")
                    btnPostMomentOutlet.isUserInteractionEnabled = true
                    self.view.isUserInteractionEnabled = true
                    hideLoader()
                    showAlert(title: "ERROR!", message: "Select atleast one image/video to upload", viewController: self)
                    
                } else {
                    btnPostMomentOutlet.isUserInteractionEnabled = false
                    self.view.isUserInteractionEnabled = false
                    uploadVideo(videoURL: url)
                }
            } else {
                print("The video URL is nil.")
                self.view.isUserInteractionEnabled = true
                btnPostMomentOutlet.isUserInteractionEnabled = true
                
            }
            
        }
        
    }

}

// MARK: - EXTENSION FOR USING COLLECTION VIEW DELEGATES AND METHODS TO SET AND SHOW DATA IN IT

extension PostMomentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostMomentImageCollectionViewCell", for: indexPath) as! PostMomentImageCollectionViewCell
        cell.imgView.image = selectedImages[indexPath.item]
        cell.btnDeleteImageOutlet.tag = indexPath.row
        
        cell.delegate = self
        return cell
        
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if count == 3 {
            if indexPath.item < 2 {
             
                let width = collectionView.frame.size.width / 2
                let height = collectionView.frame.size.height / 2
                return CGSize(width: width, height: height)
            } else {
             
                let width = collectionView.frame.size.width - 2
                let height = collectionView.frame.size.height / 2
                return CGSize(width: width, height: height)
            }
        } else if count == 4 {
            if indexPath.item < 2 {
            
                let width = collectionView.frame.size.width / 2
                let height = collectionView.frame.size.height / 2
                return CGSize(width: width, height: height)
            } else {
                
                let width = collectionView.frame.size.width / 2
                let height = collectionView.frame.size.height / 2
                return CGSize(width: width, height: height)
            }
        } else if count == 5 {
            if indexPath.item < 3 {
               
                let width = (collectionView.frame.size.width - 1 * 3 ) / 3
                let height = collectionView.frame.size.height / 2
                return CGSize(width: width, height: height)
            } else {
              
                let width = collectionView.frame.size.width / 2
                let height = collectionView.frame.size.height / 2
                return CGSize(width: width, height: height)
            }
            
        }  else if count == 6 {
            if indexPath.item < 3 {
            
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 2
                return CGSize(width: width, height: height)
            } else {
              
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 2
                return CGSize(width: width, height: height)
            }
        }  else if count == 7 {
            if indexPath.item < 3 {
            
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 3
                return CGSize(width: width, height: height)
            } else {
             
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 3
                return CGSize(width: width, height: height)
            }
        }  else if count == 8 {
            if indexPath.item < 3 {
               
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 3
                return CGSize(width: width, height: height)
            } else {
               
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 3
                return CGSize(width: width, height: height)
            }
            
        }   else if count == 9 {
            if indexPath.item < 9 {
             
                let width = collectionView.frame.size.width / 3
                let height = collectionView.frame.size.height / 3
                return CGSize(width: width, height: height)
            }
        } else {
            // For other counts, apply your existing logic
            let width = (Int(collectionView.frame.size.width) - 1 * count) / count // Adjust the cell width as needed
            let height = Int(collectionView.frame.size.height)  // Adjust the cell height as needed
            return CGSize(width: width, height: height)
        }
        
        return CGSize.zero
    }
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

      print("The indexPath ofSelected image is: \(indexPath.row)")
      
  }
    
    func selectedImageIndex(index: Int) {
        
        print("The deleted selected index is: \(index)")
        
        guard index < selectedImages.count else {
                print("Index out of bounds or selected image not found.")
                return
            }
        
            selectedImages.remove(at: index)
            collectionView.reloadData()
        
    }
    
    
}

// MARK: - EXTESNION FOR USING FUNCTION TO UPLOAD VIDEO TO THE BACKEND

extension PostMomentViewController {
       
    func uploadVideo(videoURL: URL) {
        
        let parameters: [String: Any] = [
            "type": 2,
            "profile_id": UserDefaults.standard.string(forKey: "UserProfileId") ?? "",//UserDefaults.standard.string(forKey: "userId") ?? "",
            "name": UserDefaults.standard.string(forKey: "UserName") ?? "",//"I am a singer"
            "message": txtViewMessage.text ?? ""
            
        ]
//            "profile_pic": "",
//            "gift_type": "",
//            "gift_url": "",
//            "gift_sound": "",
//            "gift_amount": "",
//            "gift_img_type": "",
//            "gift_img": "",
//            "sender_name": "",
//            "sender_id": "",
//            "sender_pic": "",
//            "gift_count": "",
//            "sender_userLevel": 0,
//            "sender_gender": ""
//            
//        ]
        
        print("The parameters we are sending is \(parameters)")
        
        // Define the headers within the multipartFormData closure
        AF.upload(
            multipartFormData: { multipartFormData in
                // Append the video file to the request
                multipartFormData.append(videoURL, withName: "moment_video[]", fileName: "video.mov", mimeType: "video/quicktime")
                
                // Append parameters from the dictionary
                for (key, value) in parameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: AllUrls.getUrl.uploadMoment,
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
                                        self.view.isUserInteractionEnabled = true
                                        self.btnPostMomentOutlet.isUserInteractionEnabled = true
                                        self.hideLoader()
                                        self.showAlertwithButtonAction(title: "SUCCESS !", message: "Successfully Uploaded", viewController: self)
                                        self.returnToHomePage()
                                    } else {
                                        self.view.isUserInteractionEnabled = true
                                        self.btnPostMomentOutlet.isUserInteractionEnabled = true
                                        self.hideLoader()
                                        self.showAlert(title: "ERROR !", message: jsonResponse["error"] as? String ??  "Something went wrong! Please try again", viewController: self)
                                        
                                    }
                                    
                                } else {
                                    print("No 'success' key in JSON response")
                                    self.hideLoader()
                                    self.btnPostMomentOutlet.isUserInteractionEnabled = true
                                    self.view.isUserInteractionEnabled = true
                                    
                                }
                            } else {
                                print("Failed to parse JSON response")
                                self.hideLoader()
                                self.btnPostMomentOutlet.isUserInteractionEnabled = true
                                self.view.isUserInteractionEnabled = true
                                
                            }
                        } else {
                            print("Upload successful. No response data received.")
                            self.hideLoader()
                            self.btnPostMomentOutlet.isUserInteractionEnabled = true
                            self.view.isUserInteractionEnabled = true
                            
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                        self.hideLoader()
                        self.btnPostMomentOutlet.isUserInteractionEnabled = true
                        self.view.isUserInteractionEnabled = true
                        
                    }
                    
                } else {
                    print("Upload successful. No response data received.")
                    self.hideLoader()
                    self.btnPostMomentOutlet.isUserInteractionEnabled = true
                    self.view.isUserInteractionEnabled = true
                    
                }
                
            case .failure(let error):
                // Handle the failure case
                print("Upload failed: \(error)")
                self.hideLoader()
                self.btnPostMomentOutlet.isUserInteractionEnabled = true
                self.view.isUserInteractionEnabled = true
                
            }
        }
    }
}

// MARK: - EXTENSIOM FOR UPLOADING MOMENT IMAGES TO THE BACKEND

extension PostMomentViewController {
    
    private func uploadImage() {
        
        let parameters: [String: Any] = [
            "type": 1,
            "profile_id": UserDefaults.standard.string(forKey: "UserProfileId") ?? "",//UserDefaults.standard.string(forKey: "userId") ?? "",
            "name": UserDefaults.standard.string(forKey: "UserName") ?? "",//"I am a singer"
            "message": txtViewMessage.text ?? ""
            
        ]
        
        print("The parameters for sending images are: \(parameters)")

        ApiWrapper.sharedManager().uploadImagesToServer(images: selectedImages, url: AllUrls.getUrl.uploadMoment, parameters: parameters) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let dictionary):

                print(dictionary)
                print(dictionary["data"])

                let a = dictionary["data"] as? [String: Any]
                print(a)
                btnPostMomentOutlet.isUserInteractionEnabled = true
                view.isUserInteractionEnabled = true
                hideLoader()
                showAlertwithButtonAction(title: "SUCCESS !", message: "Uploaded Successfully", viewController: self)
              returnToHomePage()
            case .failure(let error):

                view.isUserInteractionEnabled = true
                btnPostMomentOutlet.isUserInteractionEnabled = true
                hideLoader()
                showAlert(title: "ERROR !", message: "This image cannot be uploaded. Please select another image", viewController: self)
                print(error)
            }
        }
    }
    
}

// MARK: - EXTESNION FOR USING TEXTFIELD DELEGATES ADN METHODS

extension PostMomentViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder() // Hide the keyboard
            return false
        }
        return true
    }
}


// TO CHECK THE VIDEO TYPE OF THE SELECTED VIDEO
//   if #available(iOS 14.0, *) {
  //            let mimeType = getMimeType(forFileAt: videoUrl!)
  //            print("the video type is: \(mimeType)")
  //
  //        } else {
  //            // Fallback on earlier versions
  //        }
       
//    @available(iOS 14.0, *)
//    func getMimeType(forFileAt url: URL) -> String {
//        guard let fileType = UTType(filenameExtension: url.pathExtension) else {
//            return "application/octet-stream"
//        }
//        let mimeType = fileType.preferredMIMEType ?? "application/octet-stream"
//        return mimeType
//    }
//


//    func textViewDidBeginEditing(_ textView: UITextView) {
//           if textView.textColor == UIColor.black {
//               textView.text = nil
//               textView.textColor = UIColor.black // Change text color when editing
//           }
//       }
//
//       func textViewDidEndEditing(_ textView: UITextView) {
//           if textView.text.isEmpty {
//               textView.text = "Say Something..."
//               textView.textColor = UIColor.black
//           }
//       }
//
//    func textViewDidChange(_ textView: UITextView) {
//            if textView.text.isEmpty {
//               print("Khali hai")
//            } else {
//                print(textView.text)
//            }
//        }
    

