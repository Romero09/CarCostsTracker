//
//  NewHistoryDataView.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit

//MARK: NewHistoryDataView Class
final class NewHistoryDataView: UserInterface, UITextViewDelegate {
    
    @IBAction func costTypeSelection(_ sender: Any) {
        showActionSheet()
    }
    
    @IBOutlet weak var costType: UIButton!
    
    @IBOutlet weak var costPrice: UITextField!
    
    @IBOutlet weak var milage: UITextField!
    
    @IBOutlet weak var costDescription: UITextView!
    
    @IBOutlet weak var date: UITextField!
    
    @IBAction func submitData(_ sender: Any) {
        presenter.submitData()
    }
    
    var datePicker: UIDatePicker?
    
    
    
    override func viewDidLoad() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(NewHistoryDataView.dateChanged(datePicker:)), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewHistoryDataView.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        date.inputView = datePicker
        
        costDescription.delegate = self
        costDescription.text = "Enter costs description..."
        costDescription.textColor = UIColor.lightGray
        costDescription.layer.borderWidth = 1
        costDescription.layer.cornerRadius = 8
        costDescription.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        date.text = dateFormatter.string(from:datePicker.date)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter costs description..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func showActionSheet(){
        let actionSheet = UIAlertController(title: "Type of costs", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        let repair = UIAlertAction(title: "Repair", style: .default) {action in
            self.costType.titleLabel?.text = "Repair"
            }
        
        let fuel = UIAlertAction(title: "Fuel", style: .default) {action in
            self.costType.titleLabel?.text = "Fuel"
        }
        
        let other = UIAlertAction(title: "Other", style: .default) {action in
            self.costType.titleLabel?.text = "Other"
        }
        
        actionSheet.addAction(repair)
        actionSheet.addAction(fuel)
        actionSheet.addAction(other)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - NewHistoryDataView API
extension NewHistoryDataView: NewHistoryDataViewApi {
}

// MARK: - NewHistoryDataView Viper Components API
private extension NewHistoryDataView {
    var presenter: NewHistoryDataPresenterApi {
        return _presenter as! NewHistoryDataPresenterApi
    }
    var displayData: NewHistoryDataDisplayData {
        return _displayData as! NewHistoryDataDisplayData
    }
}
