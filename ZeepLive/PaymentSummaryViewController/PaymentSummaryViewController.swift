//
//  PaymentSummaryViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 26/03/24.
//

import UIKit

protocol delegatePaymentSummaryViewController: AnyObject {
    
    func okPressed(isPressed:Bool)
    
}

class PaymentSummaryViewController: UIViewController {

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblAmountYouGet: UILabel!
    @IBOutlet weak var viewWithdrawDetails: UIView!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTransactionFees: UILabel!
    @IBOutlet weak var btnOKOutlet: UIButton!
    @IBOutlet weak var viewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var btnCloseOutlet: UIButton!
    
    var tapGesture = UITapGestureRecognizer()
    lazy var accountNumber = String()
    lazy var amount = Int()
    lazy var transactionFees = Int()
    lazy var totalAmount: String? = ""
    weak var delegate: delegatePaymentSummaryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTapGesture()
        loadData()
        
    }
    
    @IBAction func btnOKPressed(_ sender: Any) {
        
        print("Button OK Pressed.")
        delegate?.okPressed(isPressed: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnClosePressed(_ sender: Any) {
        print("Button Close Pressed.")
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension PaymentSummaryViewController {
    
    func configureUI() {
        
        viewBottom.backgroundColor = .white
        viewBottom.layer.cornerRadius = 34
        viewBottom.layer.shadowRadius = 1
        viewBottom.layer.shadowOpacity = 0.5
        viewBottom.layer.shadowColor = UIColor.black.cgColor
        viewBottom.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewBottom.layer.borderWidth = 0.5
        viewBottom.layer.borderColor = UIColor.lightGray.cgColor
        viewBottom.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewBottom.layer.masksToBounds = true // Ensure that the masked corners are displayed correctly

        
        viewWithdrawDetails.backgroundColor = GlobalClass.sharedInstance.setGapColour()
      //  btnSubmitOtpOutlet.layer.cornerRadius = btnSubmitOtpOutlet.frame.height / 2
        addGradient(to: btnOKOutlet, width: btnOKOutlet.frame.width, height: btnOKOutlet.frame.height, cornerRadius: btnOKOutlet.frame.height / 2, startColor: GlobalClass.sharedInstance.backButtonColor(), endColor: GlobalClass.sharedInstance.buttonEnableSecondColour())
        
    }
    
    func configureTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func loadData() {
    
//        let a = Int(totalAmount)
//        print(a)
        
        if let amountInrString = totalAmount {
            // Convert the string to a double first
            if let amountInrDouble = Double(amountInrString) {
                // Convert the double to an integer (rounding if needed)
                let amountInrInt = Int(amountInrDouble)//Int(amountInrDouble.rounded())
                print("Amount INR as Integer: \(amountInrInt)")
                amount = amountInrInt
            } else {
                print("Error: Failed to convert 'amountInr' to a valid number.")
            }
        } else {
            print("Error: 'amountInr' is nil or missing.")
        }
        
        amount = amount - transactionFees
        print("Now the amount left is: \(amount)")
        
        lblAmountYouGet.text = "₹" + " " + (totalAmount ?? "0")
        lblAccountNumber.text = accountNumber
        lblAmount.text = "₹" + " " + String(amount)
        lblTransactionFees.text = String(transactionFees)
        
    }
    
}

extension PaymentSummaryViewController {
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: viewBottom)
       
        if self.view.bounds.contains(location) {
            print("View bottom par tap hua hai")
            
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
