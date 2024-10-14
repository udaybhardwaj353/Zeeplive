//
//  NewViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 21/12/23.
//

import UIKit
import AVFoundation
import GoogleSignIn
import AuthenticationServices

class NewViewController: UIViewController {

    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var btnLoginWithAppleIDOutlet: UIButton!
    @IBOutlet weak var viewMoreLoginOptions: UIView!
    @IBOutlet weak var viewLeftLine: UIView!
    @IBOutlet weak var viewRightLine: UIView!
    @IBOutlet weak var stackViewLoginOptions: UIStackView!
    @IBOutlet weak var btnLoginWithGoogleOutlet: UIButton!
   // @IBOutlet weak var btnLoginWithFacebookOutlet: UIButton!
    @IBOutlet weak var btnLoginWithUserIDOutlet: UIButton!
    @IBOutlet weak var btnLoginWithPhoneNumberOutlet: UIButton!
    @IBOutlet weak var stackViewOptionNames: UIStackView!
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var btnAcceptPolicyOutlet: UIButton!
    @IBOutlet weak var btnPrivacyPolicyOutlet: UIButton!
    @IBOutlet weak var btnTermsAndConditionOutlet: UIButton!
    
    weak var player = AVPlayer()
    lazy var isPolicySelectedButtonPressed = false
    lazy var playerLayer = AVPlayerLayer()
    lazy var checkRegistrationModel = registrationResult()
    
   lazy var profilePic = String()
    lazy var userEmail = String()
    lazy var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        registerNotification()
        playVideo()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
        enableAllButtons()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
        
        self.playerLayer.removeFromSuperlayer()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        
    }
    
    func disableAllButtons() {
    
        btnLoginWithAppleIDOutlet.isUserInteractionEnabled = false
        btnLoginWithGoogleOutlet.isUserInteractionEnabled = false
        btnLoginWithUserIDOutlet.isUserInteractionEnabled = false
        btnLoginWithPhoneNumberOutlet.isUserInteractionEnabled = false
        
    }
    
    func enableAllButtons() {
        
        btnLoginWithAppleIDOutlet.isUserInteractionEnabled = true
        btnLoginWithGoogleOutlet.isUserInteractionEnabled = true
        btnLoginWithUserIDOutlet.isUserInteractionEnabled = true
        btnLoginWithPhoneNumberOutlet.isUserInteractionEnabled = true
        
    }
    
    @IBAction func btnLoginWithApplePressed(_ sender: Any) {
       
        print(" Button Login with apple id Pressed")
        if (isPolicySelectedButtonPressed == false) {
            print("apple login ke lie aagey nahi badhega")
            
            showAlert(title: "Alert !", message: "Please agree to our terms and conditions below !", viewController: self)
            
        } else {
          
            if #available(iOS 13.0, *) {
                didTapSignIn()
                disableAllButtons()
            } else {
               print("ios version 13 se kam hai")
                enableAllButtons()
            }
        }
        
    }
    
    @IBAction func btnLoginWithGooglePressed(_ sender: Any) {
        
        print("Button Login with Google id Pressed")
        if (isPolicySelectedButtonPressed == false) {
        
            let alert = UIAlertController(title: "Alert !", message: NSLocalizedString("Please agree to our terms and conditions below !", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
          
            self.present(alert, animated: true, completion: nil)
        } else {
           handleSignInButton()
            disableAllButtons()
            
        }
        
    }
    
//    @IBAction func btnLoginWithFacebookPressed(_ sender: Any) {
//        
//        print("Button Login with Facebook id Pressed")
//        
//    }
    @IBAction func btnLoginWithUserIDPressed(_ sender: Any) {
        
        print("Button Login With User Id Pressed")
        print("Button Login With User Id Pressed")

        if (isPolicySelectedButtonPressed == false) {
            
            showAlert(title: "Alert !", message: "Please agree to our terms and conditions below !", viewController: self)
            
        } else {
            guard let navigationController = self.navigationController else { return }
            var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
            let temp = navigationArray.last
            navigationArray.removeAll()
            navigationArray.append(temp!) //To remove all previous UIViewController except the last one

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationArray.append(nextViewController) // Add the new view controller to the array
            self.navigationController?.setViewControllers(navigationArray, animated: true)
            disableAllButtons()
            
        }
        
    }
    
    @IBAction func btnLoginWithPhoneNumberPressed(_ sender: Any) {
        
        print("Login with Phone Number Pressed")
        if (isPolicySelectedButtonPressed == false) {
            
            showAlert(title: "Alert !", message: "Please agree to our terms and conditions below !", viewController: self)
            
        } else {
           
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberViewController") as! PhoneNumberViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            disableAllButtons()
            
        }
        
    }
    
    @IBAction func btnAcceptPolicyPressed(_ sender: Any) {
        
        print("Button accept policy pressed")
        print("The ispolicy selected is: \(isPolicySelectedButtonPressed)")
        if isPolicySelectedButtonPressed
        {
            
            isPolicySelectedButtonPressed = false
          btnAcceptPolicyOutlet.setImage(UIImage(named:  "BlankCircle"), for: .normal)
          
        }
        else{
            isPolicySelectedButtonPressed = true
          btnAcceptPolicyOutlet.setImage(UIImage(named:  "FilledCircle"), for: .normal)
            
           
        }
        
    }
    
    @IBAction func btnPrivacyPolicyPressed(_ sender: Any) {
        
        print("Button open Privacy Policy Pressed")
        openWebView(withURL: "https://sites.google.com/view/zeeplive/privacy")
        
    }
    
    @IBAction func btnTermsAndConditionsPressed(_ sender: Any) {
        
        print("Button Terms And Conditions Pressed.")
        openWebView(withURL: "https://sites.google.com/view/zeeplive/terms")
        
    }
    
    deinit {
        print("deinit yhn call hua hai")
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        
    }
    
}

extension NewViewController {
    
    private func configureUI() {
        
        self.navigationController?.navigationBar.isHidden = true
        
       
        viewGradient(view: viewLeftLine)
        viewGradientRight(view: viewRightLine)
        
        btnLoginWithAppleIDOutlet.layer.cornerRadius = 25
        isPolicySelectedButtonPressed = false
        btnAcceptPolicyOutlet.setImage(UIImage(named:  "BlankCircle"), for: .normal)
        // Example usage:
        addLineBelowButton(button: btnPrivacyPolicyOutlet, lineColor: UIColor.white, lineSpacing: 2, lineHeight: 1.5)
        addLineBelowButton(button: btnTermsAndConditionOutlet , lineColor: UIColor.white, lineSpacing: 2, lineHeight: 1.5)
        
    }
    
    private func registerNotification() {
    
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.appMovedToBackground()
        }
        
        notificationCenter.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.appBecomeActive()
        }
        
    }
    
    func appMovedToBackground() {
        print("App moved to background!")
        player?.pause()
    }

    func appBecomeActive() {
        print("App phir se active ho gya")
        player?.play()
    }
    
    // MARK: - FUNCTION TO PLAY VIDEO IN THE BACKGROUND ON THE VIEW CONTROLLER
        
        func playVideo() {
            guard let videoURL = Bundle.main.url(forResource: "Trail_01", withExtension: "mp4") else {
                print("Video file not found")
                return
            }

            player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            self.viewVideo.layer.addSublayer(playerLayer)

            player?.play()

            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { [weak self] notification in
                self?.playerDidFinishTillEnd(note: notification as NSNotification)
               }
        }
        
         func playerDidFinishTillEnd(note: NSNotification) {
            
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    
}

// EXTENSION FOR HANDLING GOOGLE SIGN IN AND GETTING IT'S CREDENTIALS

extension NewViewController {
    
    func handleSignInButton() {

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard let self = self else {
                // Handle the case where self is nil
                return
            }
            
            guard error == nil else {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "Alert !", message: NSLocalizedString("\(error!.localizedDescription)", comment: ""), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
              
                self.present(alert, animated: true, completion: nil)
                enableAllButtons()
                return
            }
            guard let signInResult = signInResult else { return }

            let user = signInResult.user

            let emailAddress = user.profile?.email

            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName
            
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            print(user.userID) // ye user id hmain backend mai bhejni hai google se login ke time par
            print(user.idToken)
            print(emailAddress)
            print(fullName)
            print(givenName)
            print(familyName)
            print(profilePicUrl)
            
            profilePic = profilePicUrl?.absoluteString ?? ""
            userEmail = emailAddress ?? ""
            
            checkForUserRegistration(username: fullName ?? "", userid: user.userID ?? "",loginType: "google")
        }
    }

}

// EXTENSION FOR HANDLING APPLE SIGN IN AND GETTING IT'S CREDENTIALS

@available(iOS 13.0, *)
extension NewViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func didTapSignIn() {
        UserDefaults.standard.set(nil, forKey: "name")
        
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName,.email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
       
       
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
        let a = error.localizedDescription
        print(a)
        let alertController = UIAlertController(title: "ERROR !", message: a ?? "" , preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        enableAllButtons()
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print(authorization)
        
            switch authorization.credential {
            case let credentials as ASAuthorizationAppleIDCredential:
                let firstName = credentials.fullName?.givenName
                let lastName = credentials.fullName?.familyName
                let email = credentials.email
                let a = credentials.identityToken! //.base64EncodedString()
                print(a)
                let c = String(decoding: a, as: UTF8.self)
                print(c)
                let b = credentials.user
                print(b)
                print(firstName)
                print(lastName)
                print(email)
                
                userEmail = email ?? ""
                
                // Assuming firstName and lastName are optional strings
                let fullName: String

                if let firstName = firstName, let lastName = lastName {
                    fullName = firstName + " " + lastName
                } else if let firstName = firstName {
                    fullName = firstName
                } else if let lastName = lastName {
                    fullName = lastName
                } else {
                    fullName = "" // Or any default value you prefer
                }

                
                print("The user email from apple is: \(email)")
                UserDefaults.standard.set(firstName, forKey: "appleName")
                UserDefaults.standard.set(lastName, forKey: "appleLastName")
                UserDefaults.standard.set(email, forKey: "appleEmail")
                
                print(UserDefaults.standard.string(forKey: "appleName"))
                print(UserDefaults.standard.string(forKey: "appleLastName"))
                print(UserDefaults.standard.string(forKey: "appleEmail"))
                
                checkForUserRegistration(username: fullName, userid: b, loginType: "apple")
                let attributes: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: firstName,
                    kSecValueData as String: email,
                ]

                // Add user
                if SecItemAdd(attributes as CFDictionary, nil) == noErr {
                    print("User saved successfully in the keychain")
                    UserDefaults.standard.set(firstName, forKey: "appleName")
                    UserDefaults.standard.set(lastName, forKey: "appleLastName")
                    UserDefaults.standard.set(email, forKey: "appleEmail")
                } else {
                    print("Something went wrong trying to save the user in the keychain")
                }
                
                break
                
            default:
                break
            }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

// MARK: - EXTENSION FOR API CALLING AND CHECKING IF USER IS ALREADY REGISTERED OR NOT

extension NewViewController {
    
    func checkForUserRegistration(username:String, userid:String, loginType:String = "google") {
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
            // Handle the case when 'uniquedeviceid' is nil
            return
        }
        
        let hashkey = GlobalClass.sharedInstance.bundleId?.data(using: .utf8)?.sha256.lowercased()
        
        let params = [
            
            "name": username,
            "login_type": loginType,
            "username": userid,
            "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
            "device_id": GlobalClass.sharedInstance.MYUUID ?? "",
            "unique_device_id": uniqueId
            
        ] as [String : Any]
        
        print("The params we are sending in for checking user registration is: \(params)")
        
        ApiWrapper.sharedManager().checkUserRegistration(url: AllUrls.getUrl.checkUserRegistration, parameters: params, completion: { [weak self] data, value in
            guard let self = self else { return }
            
            
            print(data)
            print(value)
            print(value["success"] as? Bool)
            print(value["already_registered"] as? Bool)
            
            checkRegistrationModel = data ?? checkRegistrationModel
            print("The model data for check registration is : \(checkRegistrationModel)")
            
            if (value["success"] as? Bool == true) {
                
                enableAllButtons()
                
                print(checkRegistrationModel.token)
                
                UserDefaults.standard.set(checkRegistrationModel.token, forKey: "token")
                UserDefaults.standard.set(checkRegistrationModel.name ?? "No Name", forKey: "UserName")
                UserDefaults.standard.set(checkRegistrationModel.profileID, forKey: "UserProfileId")
                UserDefaults.standard.set(checkRegistrationModel.userCity, forKey: "location")
                
                guard let navigationController = self.navigationController else { return }
                var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
                let temp = navigationArray.last
                navigationArray.removeAll()
                navigationArray.append(temp!) //To remove all previous UIViewController except the last one
                self.navigationController?.viewControllers = navigationArray
                
                if (value["already_registered"] as? Bool) == true {
                    
                    print("Phir isse home page par bhej do")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    navigationController.pushViewController(nextViewController, animated: true)
                    
                } else {
                     
                    if (loginType == "apple") {
                        print("Apple ke case main random string generate krni hai. aur  registration ke liye bhej dena hai.")
                        
                        if (username == "") || (username.count == 0) {
                            let name = generateRandomString(length: 10)
                            print(name)
                            
                            registerUser(userID: userid, userName: name, emailID: userEmail)
                        } else {
                            
                            registerUser(userID: userid, userName: username, emailID: userEmail)
                        }
                    } else {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BasicInformationViewController") as! BasicInformationViewController
                        nextViewController.userName = username
                        nextViewController.userID = userid
                        
                        if (loginType == "google") {
                            nextViewController.imageURL = profilePic
                            nextViewController.emailID = userEmail
                            nextViewController.loginType = "google"
                        } else {
                            nextViewController.emailID = userEmail
                            nextViewController.loginType = "apple"
                        }
                        navigationController.pushViewController(nextViewController, animated: true)
                        print("Nahi to isko user registraion wale page par bhej do")
                    }
                }
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//                navigationController.pushViewController(nextViewController, animated: true)
                

            } else {
          
                let a = value["error"] as? String
           
                showAlert(title: "ERROR!", message: a ?? "Something went wrong. Please try again!", viewController: self)
                enableAllButtons()
                
                }
        })
       
    }
    
    func registerUser(userID:String,userName:String,emailID:String) {
        
        guard let uniqueId = UserDefaults.standard.string(forKey: "uniquedeviceid") else {
                // Handle the case when 'uniquedeviceid' is nil
                return
            }
        
        let url = URL(string: "https://zeep.live/api/deviceregistration")!
        let parameters: [String: Any] = [
            "login_type": "apple",
                "device_id": GlobalClass.sharedInstance.MYUUID!,
                "myhaskey": "/dGr/7cUOEQ2nhPIF176za7y5Rg=",
                "username": userID,
                "name": userName,
                "agency_id": "",
                "dob": "20-01-2000",
                "gender": "male",
                "unique_device_id": uniqueId,
                "email": emailID,
                "mobile":"",
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
                    
                    showAlert(title: "ERROR !", message: b?["error"] as? String ?? "Something Went Wrong !", viewController: self)
                    
                }
                    
                    
            case .failure(let error):

                enableAllButtons()
                
                showAlert(title: "ERROR !", message: "Something Went Wrong !", viewController: self)
                print(error)
            }
        }
    }
    
}
