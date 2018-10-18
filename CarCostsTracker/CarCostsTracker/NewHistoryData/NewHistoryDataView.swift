//
//  NewHistoryDataView.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit
import RxCocoa
import RxSwift

//MARK: NewHistoryDataView Class
final class NewHistoryDataView: UserInterface {
    private weak var acitivityIndicationView: UIView?
    
    @IBOutlet weak var costTypeButton: UIButton!
    
    @IBOutlet weak var costPriceTextField: UITextField!
    
    @IBOutlet weak var milageTextField: UITextField!
    
    @IBOutlet weak var costDescriptionTextView: UITextView!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func openImageButton(_ sender: Any) {
        presenter.getImageFromServer()
    }
    
    @IBOutlet weak var openImageButtonOutlet: UIButton!
    
    @IBOutlet weak var deleteEntryButton: UIBarButtonItem!
    
    @IBOutlet weak var attachImageButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var costTypeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var milageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    private let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItem.Style.plain, target: self, action: nil)
    private var datePicker: UIDatePicker = UIDatePicker()
    private let activityIndicator = CustomActivityIndicator()
    private var bag = DisposeBag()
    private var imagePicked: BehaviorSubject<UIImage?> = BehaviorSubject(value: nil)

    
}


//MARK: Lifecycle
extension NewHistoryDataView{
    
    override func viewDidLoad() {
        setUpCostDescriptionTextView()
        setUpDatePicker()
        textFieldLabelsSetUp()
        presenter.viewDidLoad()
        
        if presenter.isEditMode(){
            prepareViewEditMode()
        } else {
            prepareViewAddItemMode()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewHistoryDataView.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
}



//MARK: View set up
extension NewHistoryDataView{
    
    func textFieldLabelsSetUp(){
        let asterix = NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        let costsTypeAttriburedString = NSMutableAttributedString(string: "Costs Type")
        let priceAttriburedString = NSMutableAttributedString(string: "Price")
        let milageAttriburedString = NSMutableAttributedString(string: "Milage")
        let dateAttriburedString = NSMutableAttributedString(string: "Date")
        costsTypeAttriburedString.append(asterix)
        priceAttriburedString.append(asterix)
        milageAttriburedString.append(asterix)
        dateAttriburedString.append(asterix)
        costTypeLabel.attributedText = costsTypeAttriburedString
        priceLabel.attributedText = priceAttriburedString
        milageLabel.attributedText = milageAttriburedString
        dateLabel.attributedText = dateAttriburedString
    }
    
    func setUpCostDescriptionTextView(){
        costDescriptionTextView.delegate = self
        costDescriptionTextView.textColor = UIColor.lightGray
        costDescriptionTextView.layer.borderWidth = 1
        costDescriptionTextView.layer.cornerRadius = 8
        costDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setUpDatePicker(){
        datePicker.datePickerMode = .dateAndTime
        dateTextField.inputView = datePicker
    }
    
    func prepareViewEditMode(){
        self.title = "Edit data"
        self.openImageButtonOutlet.isHidden = false
        self.navigationItem.setRightBarButton(self.submitButton, animated: true)
        self.submitButton.title = "Save"
    }
    
    func prepareViewAddItemMode(){
        self.openImageButtonOutlet.isHidden = true
        self.title = "Add new data"
        self.costTypeButton.titleLabel?.text = "Select Cost Type"
        submitButton.isEnabled = false
        self.navigationItem.setRightBarButton(self.submitButton, animated: true)
        if let deleteEntryButtonIndex = toolBar.items?.lastIndex(of: deleteEntryButton){
        self.toolBar.items?.remove(at: deleteEntryButtonIndex)
        }
    }
}


//MARK: - TextView Delegates
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
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    var selectCostTypeMenu : ControlEvent<Void> {
        return costTypeButton.rx.tap
    }
    
    var submitResults : ControlEvent<Void>{
        return submitButton.rx.tap
    }
    
    var deleteEntry: ControlEvent<Void> {
        return deleteEntryButton.rx.tap
    }
    
    var attachImage: ControlEvent<Void>{
        return attachImageButton.rx.tap
    }
    
}


//MARK: - View updates and modal present
extension NewHistoryDataView{
    
    func updateDateTextLabel(where date: Observable<String>){
        date.asDriver(onErrorJustReturn: "")
            .drive(dateTextField.rx.text)
            .disposed(by: bag)
    }
    
    func startActivityIndicator(){
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.view.isUserInteractionEnabled = false
    }
    
    func stopActivityIndicator(){
        activityIndicator.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
    func displayAction(action view: UIViewController) {
        present(view, animated: true, completion: nil)
    }
    
    func updateCostTypeButtonLabel(costType text: String){
        DispatchQueue.main.async(execute: {
            self.costTypeButton.setTitle(text, for: .selected)
            self.costTypeButton.setTitle(text, for: .normal)
        })
    }
    
}


//MARK: - Camera and Library control
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
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imagePicked.onNext(selectedImage)
        dismiss(animated:true, completion: nil)
    }
}



//MARK: - NewHistoryDataView API
extension NewHistoryDataView: NewHistoryDataViewApi {
    
    var pickedImage: Observable<UIImage?> {
        return imagePicked.asObservable()
    }
    
    var datePickerResult: Observable<Date>{
       let date = datePicker.rx.date
        return date.asObservable()
    }
    
    var selectedCostType: Observable<String?> {
        return costTypeButton.rx.observe(String.self, "titleLabel.text").asObservable()
    }
    
    var costPrice: Observable<String?> {
        return costPriceTextField.rx.text.asObservable()
    }

    var milage: Observable<String?> {
        return milageTextField.rx.text.asObservable()
    }

    var costDescription: Observable<String?> {
        return costDescriptionTextView.rx.text.asObservable()
    }

    var disposeBag: DisposeBag {
        return bag
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

extension NewHistoryDataView {
    
    func bind(datasources: Datasource) {

        datasources.pricePrefill
            .asDriver(onErrorJustReturn: "")
            .drive(costPriceTextField.rx.text)
            .disposed(by: bag)
        
        datasources.mileagePrefill
            .asDriver(onErrorJustReturn: "")
            .drive(milageTextField.rx.text)
            .disposed(by: bag)
        
        datasources.datePrefill
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: {
                (date) in
                self.dateTextField.text = date
            })
            .disposed(by: bag)
        
        datasources.descriptionPrefill
            .asDriver(onErrorJustReturn: "")
            .drive(costDescriptionTextView.rx.text)
            .disposed(by: bag)
        
        datasources.costTypePrefill
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { (costType) in
                self.costTypeButton.setTitle(costType, for: .normal)
        }).disposed(by: bag)
        
        datasources.buttonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(submitButton.rx.isEnabled)
            .disposed(by: bag)
        
    }
    
    public struct Datasource {
        public let pricePrefill: Observable<String?>
        public let mileagePrefill: Observable<String?>
        public let datePrefill: Observable<String?>
        public let descriptionPrefill: Observable<String?>
        public let costTypePrefill: Observable<String?>
        public let buttonEnabled: Observable<Bool>
        
        init(price: Observable<String?>,
             milage: Observable<String?>,
             date: Observable<String?>,
             description: Observable<String?>,
             costType: Observable<String?>,
             enableButton: Observable<Bool>) {
            
            pricePrefill = price
            mileagePrefill = milage
            datePrefill = date
            descriptionPrefill = description
            costTypePrefill = costType
            buttonEnabled = enableButton
        }
    }

}
