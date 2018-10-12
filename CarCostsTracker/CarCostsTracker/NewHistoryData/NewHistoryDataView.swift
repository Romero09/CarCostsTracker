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
final class NewHistoryDataView: UserInterface {
    private weak var acitivityIndicationView: UIView?
    
    @IBAction func costTypeSelectionButton(_ sender: Any) {
        showSelectCostTypeActionSheet()
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
    
    @IBAction func libraryButton(_ sender: Any) {
        openLibrary()
    }
    @IBAction func cameraButton(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func openImageButton(_ sender: Any) {
        presenter.getImageFromServer()
    }
    
    @IBOutlet weak var openImageButtonOutlet: UIButton!
    
    var imagePicked: UIImage?
    var selectedDate: Date?
    var datePicker: UIDatePicker?
    private let activityIndicator = CustomActivityIndicator()
}


//MARK: Lifecycle
extension NewHistoryDataView{
    
    override func viewDidLoad() {
        costDescriptionTextView.delegate = self
        costDescriptionTextView.text = "Enter costs description..."
        costDescriptionTextView.textColor = UIColor.lightGray
        costDescriptionTextView.layer.borderWidth = 1
        costDescriptionTextView.layer.cornerRadius = 8
        costDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        openImageButtonOutlet.isHidden = true
        self.title = "Add new data"
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(NewHistoryDataView.dateChanged(datePicker:)), for: .valueChanged)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewHistoryDataView.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
        
        presenter.viewWillAppear()
        
        if presenter.isEditMode(){
            DispatchQueue.main.async(execute: {
                self.title = "Edit data"
                self.openImageButtonOutlet.isHidden = false
                self.submitDataButtonOutlet.setTitle("Save", for: UIControl.State())
                self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "delete_item.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.showDeleteAction)), animated: true)
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
                })
        } else {
            costTypeButton.titleLabel?.text = "Select Cost Type"
            selectedDate = Date()
            dateTextField.text = DateFormatter.localizedString(from: selectedDate!, dateStyle: .short, timeStyle: .short)
        }
    }
}

extension NewHistoryDataView: UITextViewDelegate {
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
}

//MARK: Actions bindings
extension NewHistoryDataView {
    
    func startActivityIndicaotr(){
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.view.isUserInteractionEnabled = false
    }
    
    func stopActivityIndicaotr(){
        activityIndicator.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
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
        
    }
    
    func showSelectCostTypeActionSheet(){
        let actionSheet = UIAlertController(title: "Type of costs", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        let repair = UIAlertAction(title: "Repair", style: .default) {action in
            self.updateCostTypeButtonLabel(text: "Repair")
            }
        
        let fuel = UIAlertAction(title: "Fuel", style: .default) {action in
           self.updateCostTypeButtonLabel(text: "Fuel")
        }
        
        let other = UIAlertAction(title: "Other", style: .default) {action in
            self.updateCostTypeButtonLabel(text: "Other")
        }
        
        actionSheet.addAction(repair)
        actionSheet.addAction(fuel)
        actionSheet.addAction(other)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func updateCostTypeButtonLabel(text: String){
        DispatchQueue.main.async(execute: {
            self.costTypeButton.setTitle(text, for: .selected)
        self.costTypeButton.setTitle(text, for: .normal)
        })
    }
    
    @objc func showDeleteAction(){
        let deleteAction = UIAlertController(title: "Delete entry", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Yes", style: .destructive) { action in
            self.presenter.performDataDelete()
        }
        
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        deleteAction.addAction(accept)
        deleteAction.addAction(cancel)
        
        present(deleteAction, animated: true, completion: nil)
    }
}

//MARK: Camera and Library control
extension NewHistoryDataView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imagePicked = selectedImage
        dismiss(animated:true, completion: nil)
    }
}



//MARK: - NewHistoryDataView API
extension NewHistoryDataView: NewHistoryDataViewApi {
    
    var newHistoryDataView: NewHistoryDataView {
        return self
    }
    
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
