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
    
    @IBAction func costTypeSelectionButton(_ sender: Any) {
        showActionSheet()
    }
    
    @IBOutlet weak var costTypeButton: UIButton!
    
    @IBOutlet weak var costPriceTextField: UITextField!
    
    @IBOutlet weak var milageTextField: UITextField!
    
    @IBOutlet weak var costDescriptionTextView: UITextView!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func submitDataButton(_ sender: Any) {
        presenter.submitData()
    }
    @IBOutlet weak var submitDataButtonOutlet: UIButton!
    
    
    
    
    
    var selectedDate: Date?
    var datePicker: UIDatePicker?
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Add new data"
        costTypeButton.titleLabel?.text = "Select Cost Type"
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(NewHistoryDataView.dateChanged(datePicker:)), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewHistoryDataView.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
        
        
        costDescriptionTextView.delegate = self
        costDescriptionTextView.text = "Enter costs description..."
        costDescriptionTextView.textColor = UIColor.lightGray
        costDescriptionTextView.layer.borderWidth = 1
        costDescriptionTextView.layer.cornerRadius = 8
        costDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        if presenter.isEditMode(){
            DispatchQueue.main.async(execute: {
                self.title = "Edit data"
                self.submitDataButtonOutlet.setTitle("Save", for: UIControl.State())
                self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "delete_item.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.deleteFromDB)), animated: true)
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
                })
        } else {
            var selectedDate: Date = Date()
            dateTextField.text = DateFormatter.localizedString(from: selectedDate, dateStyle: .short, timeStyle: .short)
        }
    }
    
    @objc func deleteFromDB(){
        presenter.performDataDelete()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        selectedDate = datePicker.date
        guard let selectedDate = selectedDate else {
        return print("selectedDate was nil")
        }
        dateTextField.text = DateFormatter.localizedString(from: selectedDate, dateStyle: .short, timeStyle: .short)
        
//     to set time stamp
//        let stringTimeStamp = String(date.timeIntervalSince1970)
//     to convert from timestamp to date
//        let timeStamp = TimeInterval(stringTimeStamp)
//        let newDate = Date(timeIntervalSince1970: timeStamp)
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
            self.costTypeButton.setTitle("Repair", for: .normal)
            }
        
        let fuel = UIAlertAction(title: "Fuel", style: .default) {action in
            self.costTypeButton.setTitle("Fuel", for: .normal)
        }
        
        let other = UIAlertAction(title: "Other", style: .default) {action in
            self.costTypeButton.setTitle("Other", for: .normal)
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
    var getSelectedDate: Date? {
        return self.selectedDate
    }
    
    
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
