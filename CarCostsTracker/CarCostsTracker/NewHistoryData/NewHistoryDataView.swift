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
    private var selectedDate: Date?
    private var datePicker: UIDatePicker?
    private let activityIndicator = CustomActivityIndicator()
    private var bag = DisposeBag()
    var imagePicked: UIImage?
    
    private let prefillDriversPrice = PublishSubject<String?>()
    private let prefillDriversMileage = PublishSubject<String?>()
    private let prefillDriversDate = PublishSubject<String?>()
    
}


//MARK: Lifecycle
extension NewHistoryDataView{
    
    override func viewDidLoad() {
        setUpCostDescriptionTextView()
        setUpDatePicker()
        textFieldLabelsSetUp()
        presenter.viewDidLoad()
        inputFieldBinding()
        
        if presenter.isEditMode(){
            prepareViewEditMode()
        } else {
            prepareViewAddItemMode()
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewHistoryDataView.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        presenter.viewWillAppear()
        
    }
}



//MARK: View set up
extension NewHistoryDataView{
    
    func inputFieldBinding(){
        
        let priceValid: Observable<Bool> = Observable.of((costPriceTextField.rx.text).asObservable(), prefillDriversPrice.asObservable()).merge().map { (text) -> Bool in
            text!.count > 0
        }
        
        let milageValid: Observable<Bool> = Observable.of((milageTextField.rx.text).asObservable(), prefillDriversMileage.asObservable()).merge().map { (text) -> Bool in
            text!.count > 0
        }
        
        let dateValid: Observable<Bool> = Observable.of((dateTextField.rx.text).asObservable(), prefillDriversDate.asObservable()).merge().map { (text) -> Bool in
            text!.count > 0
        }
        
        let costType: Observable<Bool> = costTypeButton.rx.observe(String.self, "titleLabel.text").map { (label) -> Bool in
            if let label = label {
                return label != "Select Cost Type"
            }
            return false
        }
        
        let everythingValid: Observable<Bool>
            = Observable.combineLatest(priceValid, milageValid, dateValid, costType) { $0 && $1 && $2 && $3 }
        
        everythingValid.bind(to: submitButton.rx.isEnabled).disposed(by: bag)
        
    }
    
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
        self.selectedDate = Date()
        self.dateTextField.text = DateFormatter.localizedString(from: self.selectedDate!, dateStyle: .short, timeStyle: .short)
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
    
    @objc func dateChanged(datePicker: UIDatePicker){
        selectedDate = datePicker.date
        guard let selectedDate = selectedDate else {
            return print("Selected Date was nil")
        }
        dateTextField.text = DateFormatter.localizedString(from: selectedDate, dateStyle: .short, timeStyle: .short)
        
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
    
    var viewInstance: (NewHistoryDataViewApi & UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        return self
    }
    
}


//MARK: - View updates and modal present
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
        imagePicked = selectedImage
        dismiss(animated:true, completion: nil)
    }
}



//MARK: - NewHistoryDataView API
extension NewHistoryDataView: NewHistoryDataViewApi {
    
    var disposeBag: DisposeBag {
        return bag
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

extension NewHistoryDataView {
    
    func bind(datasources: PrefillDrivers) {
        
        datasources.pricePrefill
            .bind(to: prefillDriversPrice)
            .disposed(by: bag)
        
        datasources.pricePrefill
            .asDriver(onErrorJustReturn: "")
            .drive(costPriceTextField.rx.text)
            .disposed(by: bag)
        
        datasources.mileagePrefill
            .bind(to: prefillDriversMileage)
            .disposed(by: bag)
        
        datasources.mileagePrefill
            .asDriver(onErrorJustReturn: "")
            .drive(milageTextField.rx.text)
            .disposed(by: bag)
        
        datasources.datePrefill
            .bind(to: prefillDriversDate)
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
    }
}

public struct PrefillDrivers {
    public let pricePrefill: Observable<String>
    public let mileagePrefill: Observable<String>
    public let datePrefill: Observable<String>
    public let descriptionPrefill: Observable<String>
    public let costTypePrefill: Observable<String>

    
    init(price: String, milage: String, date: String, description: String, costType: String) {
        pricePrefill = Observable.create( {
            (observer) -> Disposable in
            observer.onNext(price)
            return Disposables.create()
        })
        
        mileagePrefill = Observable.create( {
            (observer) -> Disposable in
            observer.onNext(milage)
            return Disposables.create()
        })
        
        datePrefill = Observable.create( {
            (observer) -> Disposable in
            observer.onNext(date)
            return Disposables.create()
        })
        
        descriptionPrefill = Observable.create( {
            (observer) -> Disposable in
            observer.onNext(description)
            return Disposables.create()
        })
        
        costTypePrefill = Observable.create( {
            (observer) -> Disposable in
            observer.onNext(costType)
            return Disposables.create()
        })
    }
}
