//
//  ViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 13/04/23.
//

import UIKit
import AVKit
import GoogleSignIn
import AuthenticationServices
import Security
import CommonCrypto
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class ViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnConnectWithGoogleOutlet: UIButton!
    @IBOutlet weak var btnSignInWithAppleOutlet: UIButton!
    @IBOutlet weak var btnLoginWithPhoneNumber: UIButton!
    @IBOutlet weak var btnPolicyAcceptedOutlet: UIButton!
    @IBOutlet weak var btnLoginWithUserIdOutlet: UIButton!
    @IBOutlet weak var btnTermsAndConditionsOutlet: UIButton!
    @IBOutlet weak var btnPrivacyPolicyOutlet: UIButton!
    
   weak var player = AVPlayer()
    var isPolicySelectedButtonPressed = false
    var userId = String()
    var userName = String()
    var playerLayer = AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.set("eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOTBmOWIyYmQ0MWIzNzY4MzY1MDk1YmJiMmQxNjc4NmUxODBiNjY4NGRkMzA3N2RiZDRjMmU2MmJjZTM4M2QyMGI5YWQxZmQ0MTU3YjIzYTQiLCJpYXQiOjE2OTUyNzM1MDUsIm5iZiI6MTY5NTI3MzUwNSwiZXhwIjoxNzI2ODk1OTA1LCJzdWIiOiIzNDUyNzk1NiIsInNjb3BlcyI6W119.W_KNTO8RrCAkjH9VpYzv3R-94ixSzIW82ii_PbtpbzlTve4S3haumKFk_kUQIGFV0zyxGR1A9QejpkspgKyDm1TqYfeUJcfEH5TJzmJIwjzgTTuboGFJ5vyIMoh2CjdihfwH9QWuL3y6hYKXzv_owC2o9dXpzmixJfI-_PGG6MiRCak8hmpZriq_EBfoOf5e99lZ_3MciLzcNeFv7RjNxKMCtuVJ0fni5B1jDfExL9UDP8NmWjDDPuJOZJ7wAOqTfWnch8boBVK2fUUnspTKFhfuRXQtJ9lAKHlZeeQIjJ5HobKucp2mCCG8WNaizkzm9eJ7d6KI_v9dZqfpV6CjovH-jqp64z6UdMumjCkjvaGO8Ub3GBPVTg3bypXFKQv863sObYny3i2n3oNpwLG8H_z_pr1dcnJHG7Lq82P7IlnbuD77WnRd8DC6ZAoTd0POmtJETex6OVJ8YUJMLCF0aYZkP-YvcPbagozcHTkRZUgqWm5KblKuXBfr2VmxfZmoFKPQzY4g_BXUl2Kp3Wv0yZqS3vLMxn3QIqZSXAPKFtOc41kytSchF2yMQ8WZ7_DV_MhylqMVjVZNJT27ybR5mBtf92oYXBEZuzVZmO2xdXrqTkV5KtDe9ncb_FG1os1_EXI2jKQTgXyqH8788iHAvepTDwLIw6Y1PQgrHG-3xQ8", forKey: "token")
        
        checkForhashKey()
        self.navigationController?.navigationBar.isHidden = true
        
        btnConnectWithGoogleOutlet.layer.cornerRadius = 20
        btnSignInWithAppleOutlet.layer.cornerRadius = 20
        playVideo()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.appMovedToBackground()
        }
        
        notificationCenter.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.appBecomeActive()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
        
        self.playerLayer.removeFromSuperlayer()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        
    }

    deinit {
        print("deinit yhn call hua hai")
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        
    }
// MARK: - BUTTONS ACTION AND FUNCTIONS
    
    @IBAction func btnTermsAndConditionsPressed(_ sender: Any) {
        print("Button Terms and conditions pressed")
        openWebView(withURL: "https://sites.google.com/view/zeeplive/terms")
        
    }
    
    @IBAction func btnPrivacyPolicyPressed(_ sender: Any) {
        print("Button Privacy Policy Pressed")
        openWebView(withURL: "https://sites.google.com/view/zeeplive/privacy")
        
    }
    
    func checkForhashKey() {
        
        //       let z = UUID().uuidString
        //        print(z)
        //
        //        let dollarSign = "\u{24}"        // $,  Unicode scalar U+0024
        //        let blackHeart = "\u{2665}"
        //        print(dollarSign)
        //        print(blackHeart)
       let a = UserDefaults.standard.string(forKey: "hashKey")
        print(a)
        
        if (a) == "" || (a) == nil {
            
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                print(uuid)
                
                UserDefaults.standard.set(uuid, forKey: "deviceId")
                print(UserDefaults.standard.string(forKey: "deviceId"))
                
                //   let a = String(z.reversed())
                
                let a = String(uuid.reversed())
                print(a)
                let md5Data = MD5(string:a)
                let md5Base64 = md5Data.base64EncodedString()
                print("md5Base64: \(md5Base64)")
                UserDefaults.standard.set(md5Base64, forKey: "hashKey")
                print(UserDefaults.standard.string(forKey: "hashKey"))
                
            }
        }  else {
            print("hashkey pehle se hi generated hai . usko hi use karna hai")
            print(UserDefaults.standard.string(forKey: "hashKey"))
        }
        
    }
    // MARK: - FUNCTION TO CONVERT STRING INTO HEX5 STRING FOR THE GENERATION OF HASHKEY TO SEND
    
    func MD5(string: String) -> Data {
            let length = Int(CC_MD5_DIGEST_LENGTH)
            let messageData = string.data(using:.utf8)!
            var digestData = Data(count: length)

            _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }
            return digestData
        }
    
//    func openWebView(withURL url: String) {
//           if let webViewVC = storyboard?.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController {
//               webViewVC.url = url
//               self.navigationController?.pushViewController(webViewVC, animated: true)
//           }
//       }
    
    
 // MARK: - NOTIFICATION OBSERVER FUNCTIONS TO KNOW IF THE APP IS IN BACKGROUND STATE OR IS IN ACTIVE STATE
    
    func appMovedToBackground() {
        print("App moved to background!")
        player?.pause()
//        let notificationCenter1 = NotificationCenter.default
//           notificationCenter1.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func appBecomeActive() {
        print("App phir se active ho gya")
        player?.play()
        
    }
    
// MARK: - FUNCTION TO CALL FOR GOOGLE LOGIN AND GET USER INFORMATION ONCE USER IS LOGGED IN
    
    func handleSignInButton() {

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "Alert !", message: NSLocalizedString("\(error!.localizedDescription)", comment: ""), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
              
                self.present(alert, animated: true, completion: nil)
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
        
        }
    }

    // MARK: - BUTTONS ACTIONS AND WORKING

 // MARK: - BUTTON GOOGLE LOGIN ACTION AND WORKING
    
    @IBAction func btnConnectWithGooglePressed(_ sender: Any) {
        if (isPolicySelectedButtonPressed == false) {
        
            let alert = UIAlertController(title: "Alert !", message: NSLocalizedString("Please agree to our terms and conditions below !", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
          
            self.present(alert, animated: true, completion: nil)
        } else {
           handleSignInButton()
        }
    }
 // MARK: - BUTTON APPLE LOGIN ACTION AND WORKING
    
    @IBAction func btnSignInWithApplePressed(_ sender: Any) {
        
        if (isPolicySelectedButtonPressed == false) {
            print("apple login ke lie aagey nahi badhega")
            
            showAlert(title: "Alert !", message: "Please agree to our terms and conditions below !", viewController: self)
            
//            let alert = UIAlertController(title: "Alert !", message: NSLocalizedString("Please agree to our terms and conditions below !", comment: ""), preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
//
//            self.present(alert, animated: true, completion: nil)
            
        } else {
          
            if #available(iOS 13.0, *) {
                didTapSignIn()
            } else {
               print("ios version 13 se kam hai")
            }
            
        }
        
    }

// MARK: - BUTTON LOGIN FROM PHONE NUMBER ACTION AND WORKING
    
    @IBAction func btnLoginWithPhoneNumberPressed(_ sender: Any) {
      
        if (isPolicySelectedButtonPressed == false) {
            
            showAlert(title: "Alert !", message: "Please agree to our terms and conditions below !", viewController: self)
            
//            let alert = UIAlertController(title: "Alert !", message: NSLocalizedString("Please agree to our terms and conditions below !", comment: ""), preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
//
//            self.present(alert, animated: true, completion: nil)
            
        } else {
           
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberViewController") as! PhoneNumberViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }

    // MARK: - BUTTON LOGIN WITH USER ID ACTION AND WORKING
    
    @IBAction func btnLoginWithUserIdPressed(_ sender: Any) {
        print("Button Login With User Id Pressed")

        if (isPolicySelectedButtonPressed == false) {
            
            showAlert(title: "Alert !", message: "Please agree to our terms and conditions below !", viewController: self)
            
//            let alert = UIAlertController(title: "Alert !", message: NSLocalizedString("Please agree to our terms and conditions below !", comment: ""), preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
//
//            self.present(alert, animated: true, completion: nil)
            
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
        }
    }
// MARK: - BUTTON POLICY ACCEPTED ACTIONS AND WORKING
    
    @IBAction func btnPolicyAcceptedPressed(_ sender: Any) {
        print("Button Policy Accepted Pressed")
       
        if isPolicySelectedButtonPressed
        {
              isPolicySelectedButtonPressed = false
            btnPolicyAcceptedOutlet.setImage(UIImage(named:  "BlankCircle"), for: .normal)
          
        }
        else{
              isPolicySelectedButtonPressed = true
            btnPolicyAcceptedOutlet.setImage(UIImage(named:  "FilledCircle"), for: .normal)
        
        }
    }
    
// MARK: - FUNCTION TO PLAY VIDEO IN THE BACKGROUND ON THE VIEW CONTROLLER
    
    func playVideo() {
        guard let videoURL = Bundle.main.url(forResource: "Video", withExtension: "mp4") else {
            print("Video file not found")
            return
        }

        player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.viewMain.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.viewMain.layer.addSublayer(playerLayer)

        player?.play()

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { [weak self] notification in
            self?.playerDidFinishTillEnd(note: notification as NSNotification)
           }
        
    }

//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
//    }
    
// MARK: - NOTIFICATION CENTER TO KNOW THAT VIDEO HAS PLAYED TILL THE END
    
     func playerDidFinishTillEnd(note: NSNotification) {
        
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
    }
    
}

@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
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
                
                UserDefaults.standard.set(firstName, forKey: "appleName")
                UserDefaults.standard.set(lastName, forKey: "appleLastName")
                UserDefaults.standard.set(email, forKey: "appleEmail")
                
                print(UserDefaults.standard.string(forKey: "appleName"))
                print(UserDefaults.standard.string(forKey: "appleLastName"))
                print(UserDefaults.standard.string(forKey: "appleEmail"))
                
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
                
//                UserDefaults.standard.set("Logged In From Apple", forKey: "appleName")
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyTabBarViewController") as! MyTabBarViewController
//
//                self.navigationController?.pushViewController(nextViewController, animated: true)
//                let alert = UIAlertController(title: "SUCCESS !", message: NSLocalizedString("\(firstName!)\(lastName) ka swagat hai zeeplive main !", comment: ""), preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
//              
//                self.present(alert, animated: true, completion: nil)
                
                break
                
            default:
                break
            }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

// MARK: - EXTENSION FOR API CALLING AND GETTING DATA

extension ViewController {
    
    func userRegistration() {
        
        let params = [
            "login_type": "google",
            "device_id":GlobalClass.sharedInstance.MYUUID ?? "",//(UserDefaults.standard.string(forKey: "deviceId") ?? ""),
            "myhaskey":"mONE1zjRK0b8dphfXZ1OKQ==",//(UserDefaults.standard.string(forKey: "hashKey") ?? ""),
            "username":userId,
            "name": userName
            
        ] as [String : Any]
        
        ApiWrapper.sharedManager().userRegistration(url:AllUrls.getUrl.callForUserRegistration ,parameters: params, completion: {(data) in
            
            if (data["success"] as? Bool == true) {
                print(data)
                
                let a = data as? [String:Any]
                
                let b = a?["result"] as? [String:Any]
                print(b)
                
                UserDefaults.standard.set(b?["token"] as? String , forKey: "token")
                UserDefaults.standard.set(b?["name"] as? String ?? "No Name", forKey: "UserName")
                UserDefaults.standard.set(b?["profile_id"] as! Int, forKey: "UserProfileId")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//                nextViewController.userName = b?["name"] as? String ?? "No Name"
//                nextViewController.userId = String(b?["profile_id"] as! Int)
                
                self.navigationController?.pushViewController(nextViewController, animated: true)

            }
            else {
            
                self.showAlert(title: "ERROR !", message: "You Cannot Login in the ZeepLive. Please Contact Admin!", viewController: self)
                
//                let alertController = UIAlertController(title: "ERROR!", message: "You Cannot Login in the ZeepLive. Please Contact Admin!", preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in
//                })
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
                
            }
        })
       
    }
}
