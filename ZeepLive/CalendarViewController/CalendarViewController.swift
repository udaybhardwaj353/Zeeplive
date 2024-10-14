//
//  CalendarViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 26/12/23.
//

import UIKit

protocol delegateCalendarViewController: AnyObject {

    func dobOfUser(date: String)
    
}

class CalendarViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewTopYearAndDate: UIView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewCalendar: UIView!
    @IBOutlet weak var btnCancelOutlet: UIButton!
    @IBOutlet weak var btnDoneOutlet: UIButton!
    
    var datePicker: UIDatePicker!
    lazy var dob = String()
    weak var delegate: delegateCalendarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        selectData(currentDate: Date())
        configureDatePicker()
        
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        print("Button Cancel Pressed")
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func btnDonePressed(_ sender: Any) {
    
        print("Button Done Pressed")
        delegate?.dobOfUser(date: dob)
        
        self.navigationController?.popViewController(animated: false)
        
    }
    
}

extension CalendarViewController {
    
    func configureDatePicker() {
    
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: viewCalendar.frame.width, height: viewCalendar.frame.height))
        datePicker.datePickerMode = .date
        let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.maximumDate = maxDate
        let minDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.minimumDate = minDate
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        viewCalendar.addSubview(datePicker)
        selectData(currentDate: maxDate!)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectData(currentDate: sender.date)
    }
    
    func selectData(currentDate: Date) {
        
        let year = Calendar.current.component(.year, from: currentDate)
        let month = Calendar.current.component(.month, from: currentDate)
        let day = Calendar.current.component(.day, from: currentDate)
        dob = String(format: "%d-%d-%d", day, month, year)
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let monthAbbreviation = monthFormatter.string(from: currentDate)
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE"
        let weekdayAbbreviation = weekdayFormatter.string(from: currentDate)
        
        lblYear.text = String(format: "%d", year)
        lblDate.text = weekdayAbbreviation + "," + monthAbbreviation + String(format: " %d", day)
        
    }
    
}
