//
//  FreeTargetSubmitDetailsTableViewCell.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 27/09/23.
//

import UIKit
import DropDown

protocol delegateFreeTargetSubmitDetailsTableViewCell: AnyObject {
    
    func uploadVideo(isPressed:Bool, Name:String, ID:String, talent:String)
    
}

class FreeTargetSubmitDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var txtfldUserName: UITextField!
    @IBOutlet weak var txtfldUserID: UITextField!
    @IBOutlet weak var viewSelectTalent: UIControl!
    @IBOutlet weak var lblTalent: UILabel!
    @IBOutlet weak var viewUploadVideoOutlet: UIControl!
    
    lazy var dropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDown
        ]
    }()
    
    weak var delegate: delegateFreeTargetSubmitDetailsTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialiseUI()
        customizeDropDown()
        setupDropDown()
        
    }

    private func initialiseUI() {
        
        viewSelectTalent.layer.cornerRadius = 10
        viewSelectTalent.layer.borderWidth = 0.7
        viewSelectTalent.layer.borderColor = UIColor.lightGray.cgColor
        
        viewUploadVideoOutlet.layer.cornerRadius = 10
        viewUploadVideoOutlet.layer.borderWidth = 0.7
        viewUploadVideoOutlet.layer.borderColor = UIColor.lightGray.cgColor
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
        
    }
    
    func setupDropDown() {
           dropDown.anchorView = viewSelectTalent
           dropDown.dataSource = ["I am Singer", "I am Dancer", "I am Star", "I am Actor"]

           dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
              
               print(index)
               print(item)
               lblTalent.text = item
           }
       }
    
    private func customizeDropDown() {
        let appearance = DropDown.appearance()
        appearance.cellHeight = 40
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = #colorLiteral(red: 0.2523537278, green: 0.7503452897, blue: 0.9989678264, alpha: 0.3048821075)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.2
        appearance.textColor = .black
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                appearance.textFont = .systemFont(ofSize: 12)
            default:
                appearance.textFont = .systemFont(ofSize: 17)
            }
            if #available(iOS 11.0, *) {
                appearance.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
            }
            
            dropDown = DropDown()
            dropDown.dismissMode = .onTap
            dropDown.direction = .bottom
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewSelectTalentPressed(_ sender: Any) {
        
        print("View Select Talent Pressed")
        dropDown.show()
        
    }
    
    @IBAction func viewUploadVideoPressed(_ sender: Any) {
        
        print("View Upload Video Pressed")
        delegate?.uploadVideo(isPressed: true, Name: txtfldUserName.text ?? "", ID: txtfldUserID.text ?? "", talent: lblTalent.text ?? "I am a Singer")
        
    }
    
}
