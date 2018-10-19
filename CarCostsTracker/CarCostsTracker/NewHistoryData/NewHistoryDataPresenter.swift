//
//  NewHistoryDataPresenter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import RxCocoa


// MARK: - NewHistoryDataPresenter Class
final class NewHistoryDataPresenter: Presenter {
    var historyDataToEdit: HistoryCellData? = nil
    var isEdtiMode: Bool = false
    
    override func setupView(data: Any) {
        historyDataToEdit = (data as? HistoryCellData)
        
    }
}


// MARK: - NewHistoryDataPresenter API
extension NewHistoryDataPresenter: NewHistoryDataPresenterApi {
    func isEditMode() -> Bool {
        if historyDataToEdit != nil {
            return true } else {
            return false
        }
    }
}


//MARK: - Connection with View
extension NewHistoryDataPresenter{
    
    func viewDidLoad(){
        bindActions()
        
        self.setupView(where: historyDataToEdit)
            .subscribe(onNext:  {
                (result) in
                if self.isEditMode(){
                    self.interactor.updateData(where: result)
                } else {
                    self.interactor.storeData(where: result)
                }
                print(result)
            }).disposed(by: view.disposeBag)

    }
    
    private func setupView(where historyDataToEdit: HistoryCellData?) -> Observable<Result>{
        
        
        let costDescription: Observable<String> = Observable.just(historyDataToEdit?.description ?? "Enter costs description...")
        let costPriceText: Observable<String> = Observable.just(String(historyDataToEdit?.price.dropLast() ?? ""))
        let milageText: Observable<String> = Observable.just(String(historyDataToEdit?.mileage.dropLast().dropLast() ?? "") )
        let dateString: Observable<String> = Observable.just(historyDataToEdit?.costDate ?? String(Date().timeIntervalSince1970))
        let costType: Observable<String> = Observable.just(historyDataToEdit?.costType.name() ?? "Select Cost Type")
        let documentId: Observable<String?> = Observable.just(historyDataToEdit?.documentID)
        
        let viewDate = view.datePickerResult.map({ (date) -> String in
                return String(date.timeIntervalSince1970)
        })
        
        let mergedDocumentId = documentId
        let mergedCostType = Observable.merge([view.selectedCostType, costType])
        let mergedPrice = Observable.merge([view.costPrice, costPriceText])
        let mergedMilage = Observable.merge([view.milage, milageText])
        let mergedDescription = Observable.merge([view.costDescription, costDescription])
        let mergedPickedImage = view.pickedImage
        let mergedDate = Observable.merge([viewDate, dateString])
        
        
        let result = Observable<Result>.combineLatest(mergedDocumentId, mergedDate, mergedCostType, mergedPrice, mergedMilage, mergedDescription, mergedPickedImage) { (documentId: String?, date: String, costType: String, costPrice: String, milage: String, costDescription: String, pickedImage: UIImage?) -> NewHistoryDataPresenter.Result in
            
            return Result(documentId: documentId , price: costPrice, mileage: milage, date: date, costType: costType, description: costDescription, image: pickedImage)
        }
        
        let priceValid: Observable<Bool> = mergedPrice.map { (text) -> Bool in
            text.count > 0
        }
        let mileageValid: Observable<Bool> = mergedMilage.map { (text) -> Bool in
            text.count > 0
        }
        let dateValid: Observable<Bool> = mergedDate.map { (text) -> Bool in
            text.count > 0
        }
        let costTypeValid: Observable<Bool> = view.selectedCostType.map { (label) -> Bool in
                return label != "Select Cost Type"
        }
        
        let everythingValid: Observable<Bool> = Observable.combineLatest(priceValid, mileageValid, dateValid, costTypeValid) { $0 && $1 && $2 && $3 }
        
        let displayDate = dateString.map { (dateStamp) -> String in
            let timeStamp = TimeInterval(dateStamp)
            let newDate = Date(timeIntervalSince1970: timeStamp!)
            return DateFormatter.localizedString(from: newDate, dateStyle: .short, timeStyle: .short)
        }
        
        //Updating dateText field with currently selected date.
        let datePickerResultString = view.datePickerResult.map { (date) -> String in
            DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        }
        view.updateDateTextLabel(where: datePickerResultString)
        
        let prefilDrivers = NewHistoryDataView.Datasource(price: costPriceText, milage: milageText, date: displayDate, description: costDescription, costType: costType, enableButton: everythingValid)
        view.bind(datasources: prefilDrivers)
        
        //first event from view.submitResults acts like a trigger, and result returns as Observable<Result>
        return view.submitResults
            .asObservable()
            .withLatestFrom(result)
    }
}


//MARK: - View Action Binding
extension NewHistoryDataPresenter{
    
    //Bind action listeners on buttons
    private func bindActions(){
        
        view.selectCostTypeMenu
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.showSelectCostTypeActionSheet()
            }).disposed(by: view.disposeBag)
        
        view.deleteEntry
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.showDeleteEntryActionAlert()
            }).disposed(by: view.disposeBag)
        
        view.attachImage
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.showSelectImageSourceActionSheet()
            }).disposed(by: view.disposeBag)
    }
}

//MARK: - View Action Alerts display and selection handling
extension NewHistoryDataPresenter{
    
    private func showSelectCostTypeActionSheet(){
        let (costTypeActionSheet, actionSheetEvents) =  NewHistoryDataActions
            .showSelectCostTypeActionSheet()
        
        actionSheetEvents.other
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.costTypeSelected(costType: CostType.other)
            }).disposed(by: view.disposeBag)
        
        actionSheetEvents.fuel
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                [unowned self]
                _ in
                self.costTypeSelected(costType: CostType.fuel)
            }).disposed(by: view.disposeBag)
        
        actionSheetEvents.repair
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                [unowned self]
                _ in
                self.costTypeSelected(costType: CostType.repair)
            }).disposed(by: view.disposeBag)
        
        view.displayAction(action: costTypeActionSheet)
    }
    
    private func showSelectImageSourceActionSheet(){
        let(actionSheet: imageSourceActionSheet, camera: cameraEvent, library: libraryEvent) = NewHistoryDataActions
            .showSelectImageSourceActionSheet()
        
        cameraEvent
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.view.openCamera()
            }).disposed(by: view.disposeBag)
        
        libraryEvent
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                [unowned self]
                _ in
                self.view.openLibrary()
            }).disposed(by: view.disposeBag)
        
        view.displayAction(action: imageSourceActionSheet)
    }
    
    func costTypeSelected(costType: CostType){
        view.updateCostTypeButtonLabel(costType: costType.name())
    }
    
    //Creates Action Alert, sends it to present in View and subscribes on action events.
    private func showDeleteEntryActionAlert(){
        let (deleteEntryActionAlert, actionAlertEvents) =  NewHistoryDataActions
            .showDeleteAction()
        
        actionAlertEvents
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
            _ in
            self.performDataDelete()
        }).disposed(by: view.disposeBag)
        
        view.displayAction(action: deleteEntryActionAlert)
    }
    
    private func showAlertOnError(){
        view.stopActivityIndicator()
        let imageNotFoundAlert: UIAlertController = NewHistoryDataActions.showImageNotFound()
        self.view.displayAction(action: imageNotFoundAlert)
    }
    
}

//MARK: - Connection with Interactor
extension NewHistoryDataPresenter{

    
    private func getTimeStamp(from date: Date?, defaultFrom cellData: HistoryCellData?) -> String {
        if let date = date {
            return String(date.timeIntervalSince1970)
        }
        else if let cellData = cellData {
            return cellData.costDate
        }
        return ""
    }
    
    
    private func performDataDelete(){
        guard let historyDataToEdit = self.historyDataToEdit else {
            return print("Error historyDataToEdit is nil")
        }
        interactor.deleteData(document: historyDataToEdit.documentID)
    }
    
    func getImageFromServer(){
        if let historyDataToEdit = historyDataToEdit {
            view.startActivityIndicator()
            interactor.fetchImage(form: historyDataToEdit.documentID)
                .subscribe(onNext: { (fetchedImage) in
                    self.openAttachedImage(image: fetchedImage)
                }, onError:{ _ in
                    self.showAlertOnError()
                }).disposed(by: view.disposeBag)
        }
    }
}


//MARK: - Connection with Router
extension NewHistoryDataPresenter{
    
    private func openAttachedImage(image data: UIImage) {
        router.showAttachedImageView(image: data)
        view.stopActivityIndicator()
    }
    
    func returnToHistory(){
        router.showHistory()
    }
    
    
    public struct Result{
        
        public let documentId: String?
        public let price: String
        public let mileage: String
        public let date: String
        public let costType: String
        public let description: String
        public let image: UIImage?
        
        init(documentId: String?, price: String, mileage: String, date: String, costType: String, description: String, image: UIImage? = nil){
            self.documentId = documentId
            self.price = price
            self.mileage = mileage
            self.date = date
            self.costType = costType
            self.description = description
            self.image = image
        }
    }
}


// MARK: - NewHistoryData Viper Components
private extension NewHistoryDataPresenter {
    var view: NewHistoryDataViewApi {
        return _view as! NewHistoryDataViewApi
    }
    var interactor: NewHistoryDataInteractorApi {
        return _interactor as! NewHistoryDataInteractorApi
    }
    var router: NewHistoryDataRouterApi {
        return _router as! NewHistoryDataRouterApi
    }
}

extension Reactive where Base == String? {
    func isEmpty() -> Observable<Bool> {
        guard let base = base else {
            return Observable.just(false)
        }
        return Observable.just(base.count > 0)
    }
}
