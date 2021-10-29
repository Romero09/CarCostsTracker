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
import RxOptional

//MARK: NewHistoryDataView Class outlets
final class NewHistoryDataView: UserInterface {
    
    private weak var acitivityIndicationView: UIView?
    
    @IBOutlet weak var costTypeButton: UIButton!
    
    @IBOutlet weak var costPriceTextField: UITextField!
    
    @IBOutlet weak var milageTextField: UITextField!
    
    @IBOutlet weak var costDescriptionTextView: UITextView!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var deleteEntryButton: UIBarButtonItem!
    
    @IBOutlet weak var attachImageButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var costTypeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var milageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var noImageLabel: UILabel!
    
    
    private let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItem.Style.plain, target: self, action: nil)
    private var datePicker: UIDatePicker = UIDatePicker()
    private let activityIndicator = CustomActivityIndicator()
    private let previewActivityIndicator = UIActivityIndicatorView()
    private var bag = DisposeBag()
    
}


//MARK: Module Lifecycle
extension NewHistoryDataView{
    
    override func viewDidLoad() {
        setUpCostDescriptionTextView()
        setUpDatePicker()
        textFieldLabelsSetUp()
        previewActivityIndicatorSetUp()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewHistoryDataView.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        noImageLabel.isHidden = true
    }
}



//MARK: View set up
extension NewHistoryDataView{
    
    func previewActivityIndicatorSetUp(){
        previewActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        previewActivityIndicator.center = CGPoint(x: self.previewImageView.center.x,
                                                  y: self.previewImageView.center.y + 20.0)
        previewActivityIndicator.clipsToBounds = true
        previewActivityIndicator.hidesWhenStopped = true
        previewActivityIndicator.style = UIActivityIndicatorView.Style.gray
        previewActivityIndicator.startAnimating()
        self.view.addSubview(previewActivityIndicator)
    }
    
    func textFieldLabelsSetUp(){
        let asterix = NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        let costsTypeAttriburedString = NSMutableAttributedString(string: "Costs Type")
        let priceAttriburedString = NSMutableAttributedString(string: "Price")
        let milageAttriburedString = NSMutableAttributedString(string: "Mileage")
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
        previewImageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.title = "Edit data"
        self.navigationItem.setRightBarButton(self.submitButton, animated: true)
        self.submitButton.title = "Save"
    }
    
    func prepareViewAddItemMode(){
        previewImageView.contentMode = UIView.ContentMode.scaleAspectFit
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
    
    var imgaeTapAction: ControlEvent<UITapGestureRecognizer> {
        let tapGesture = UITapGestureRecognizer()
        previewImageView.addGestureRecognizer(tapGesture)
        return tapGesture.rx.event
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
    
    func stopPreviewActivityIndicator(){
        previewActivityIndicator.removeFromSuperview()
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
    
    func displayNoImageFound(){
        previewImageView.isHidden = true
        noImageLabel.isHidden = false
    }
    
    func displayImagePreview(){
        previewImageView.isHidden = false
        noImageLabel.isHidden = true
    }
    
}

//MARK: - NewHistoryDataView API
extension NewHistoryDataView: NewHistoryDataViewApi {
    
    var getPreviewImageView: UIImageView {
        return self.previewImageView
    }
    
    var dateText: Observable<String>{
        let dateResult = dateTextField.rx.text
        let dateResultFiltered = dateResult.filterNil()
        return dateResultFiltered
    }
    
    var datePickerResult: Observable<Date>{
       let date = datePicker.rx.date
        return date.asObservable()
    }
    
    var selectedCostType: Observable<String> {
        return costTypeButton.rx.observe(String.self, "titleLabel.text").asObservable().filterNil()
    }
    
    var costPrice: Observable<String> {
        return costPriceTextField.rx.text.asObservable().filterNil()
    }

    var milage: Observable<String> {
        return milageTextField.rx.text.asObservable().filterNil()
    }

    var costDescription: Observable<String> {
        return costDescriptionTextView.rx.text.asObservable().filterNil()
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

//MARK: - Binding data to display in View.
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
        
        datasources.imagePreview
            .asDriver(onErrorJustReturn: UIImage())
            .drive(previewImageView.rx.image)
            .disposed(by: bag)
        
    }
    
    public struct Datasource {
        public let pricePrefill: Observable<String>
        public let mileagePrefill: Observable<String>
        public let datePrefill: Observable<String>
        public let descriptionPrefill: Observable<String>
        public let costTypePrefill: Observable<String>
        public let buttonEnabled: Observable<Bool>
        public let imagePreview: Observable<UIImage>
        
        init(price: Observable<String>,
             milage: Observable<String>,
             date: Observable<String>,
             description: Observable<String>,
             costType: Observable<String>,
             enableButton: Observable<Bool>,
             image: Observable<UIImage>) {
            
            pricePrefill = price
            mileagePrefill = milage
            datePrefill = date
            descriptionPrefill = description
            costTypePrefill = costType
            buttonEnabled = enableButton
            imagePreview = image
        }
    }
    
}



