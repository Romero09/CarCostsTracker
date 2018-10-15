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
        setUpCostDescriptionTextView()
        setUpDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewHistoryDataView.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        presenter.viewWillAppear()
        
        if presenter.isEditMode(){
            prepareViewInEditMode()
        } else {
            prepareViewAddItemMode()
        }
    }
}



//MARK: View set up
extension NewHistoryDataView{
    
    func setUpCostDescriptionTextView(){
        costDescriptionTextView.delegate = self
        costDescriptionTextView.text = "Enter costs description..."
        costDescriptionTextView.textColor = UIColor.lightGray
        costDescriptionTextView.layer.borderWidth = 1
        costDescriptionTextView.layer.cornerRadius = 8
        costDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setUpDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(NewHistoryDataView.dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    func prepareViewInEditMode(){
        DispatchQueue.main.async(execute: {
            self.title = "Edit data"
            self.openImageButtonOutlet.isHidden = false
            self.submitDataButtonOutlet.setTitle("Save", for: UIControl.State())
            self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "delete_item.png"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.showDeleteAction)), animated: true)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        })
    }
    
    func prepareViewAddItemMode(){
        DispatchQueue.main.async(execute: {
            self.openImageButtonOutlet.isHidden = true
            self.title = "Add new data"
            self.costTypeButton.titleLabel?.text = "Select Cost Type"
            self.selectedDate = Date()
            self.dateTextField.text = DateFormatter.localizedString(from: self.selectedDate!, dateStyle: .short, timeStyle: .short)
        })
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
extension NewHistoryDataView{
    
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
    
    func updateCostTypeButtonLabel(text: String){
        DispatchQueue.main.async(execute: {
            self.costTypeButton.setTitle(text, for: .selected)
            self.costTypeButton.setTitle(text, for: .normal)
        })
    }
    
    func showSelectCostTypeActionSheet(){
        let selectCostTypeAction =  NewHistoryDataActions
            .showSelectCostTypeActionSheet(view: self, actions: [UIAlertAction(title: "Cancle", style: .cancel, handler: nil),
                                                                 UIAlertAction(title: CostType.repair.name(), style: .default) {_ in
                                                                    self.updateCostTypeButtonLabel(text: CostType.repair.name()) },
                                                                 UIAlertAction(title: CostType.fuel.name(), style: .default) {_ in
                                                                    self.updateCostTypeButtonLabel(text: CostType.fuel.name())},
                                                                 UIAlertAction(title: CostType.other.name(), style: .default) {_ in
                                                                    self.updateCostTypeButtonLabel(text: CostType.other.name())}])
        present(selectCostTypeAction, animated: true, completion: nil)
    }
    
    func showImageNotFound(alert controller: UIAlertController){
        present(controller, animated: true, completion: nil)
    }
    
    @objc func showDeleteAction(){
        let deleteAction =  NewHistoryDataActions.showDeleteAction(presenter: presenter)
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
