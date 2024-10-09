//
//  MomentSendGiftViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 08/04/24.
//

import UIKit

class MomentSendGiftViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewSendGift: UIView!
    @IBOutlet weak var btnSendGiftOutlet: UIButton!
    
    lazy var tapGesture = UITapGestureRecognizer()
    lazy var momentID: Int = 0
    lazy var recieverID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
       configureTapGesture()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTapGesture()
        print("View send gift par tap gesture hat gya hai.")
    }
    
    @IBAction func btnSendGiftPressed(_ sender: Any) {
        
        print("Button Send Gift To Support User In Moment Pressed.")
        momentSendGift()
      //  dismiss(animated: true, completion: nil)
        
    }
    
    func configureUI() {
    
        addGradient(to: btnSendGiftOutlet, width: btnSendGiftOutlet.frame.width, height: btnSendGiftOutlet.frame.height, cornerRadius: btnSendGiftOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        viewSendGift.layer.cornerRadius = 20
        view.backgroundColor = .black.withAlphaComponent(0.4)

    }
    
    func configureTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewSendGift)
       
        if let tappedView = viewSendGift.hitTest(location, with: nil), tappedView == viewSendGift {
            print("View Send Gift par tap hua hai")
        } else {
            print("View bottom par tap nahi hua hai")
            dismiss(animated: true, completion: nil)
        }

    }
    
    func removeTapGesture() {
        if tapGesture != nil {
            view.removeGestureRecognizer(tapGesture)
        }
    }
    
}

extension MomentSendGiftViewController {
    
    func momentSendGift() {
        
          let params = [
                
                "gift_price":190,
                "moment_id": momentID,
                "receiver_id": recieverID
                
            ] as [String : Any]
            
        
        print("The parameters we are sending for sending gift in moment is: \(params)")
        
        ApiWrapper.sharedManager().sendMomentGiftToHost(url: AllUrls.getUrl.sendGiftInMoment, parameters: params, completion: { [weak self] data in
            guard let self = self else { return }
            
            print(data)
            
            if let success = data["success"] as? Bool, success {
                print(data)
                   
                if let coin = data["result"] as? Int {
                    UserDefaults.standard.set(coin, forKey: "coins")
                }

                showAlert(title: "SUCCESS!", message: data["message"] as? String ?? "Your gift has been sent Successfully!", viewController: self)
                
            } else {
                
                showAlert(title: "ERROR !", message: data["error"] as? String ?? "Something Went Wrong!", viewController: self)
                
            }
           
            dismiss(animated: true, completion: nil)
           
        })
        
    }
    
}


//        if self.view.bounds.contains(location) {
//            print("View Send Gift par tap hua hai")
//
//        } else {
//
//            print("View bottom par tap nahi hua hai")
//            dismiss(animated: true, completion: nil)
//        }
