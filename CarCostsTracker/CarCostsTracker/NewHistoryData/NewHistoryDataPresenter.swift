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
    var historyDataToEdit: HistoryCellData?
    
}

// MARK: - NewHistoryDataPresenter API
extension NewHistoryDataPresenter: NewHistoryDataPresenterApi {
    
    func isEditMode() -> Bool {
        if historyDataToEdit != nil {
            return true } else {
            return false
        }
    }
    
    func fillEditData(edit data: HistoryCellData){
        historyDataToEdit = data
    }
}



//MARK: - Connection with View
extension NewHistoryDataPresenter{
    
    func viewWillAppear(){
        bindActions()
        if isEditMode(){
            DispatchQueue.main.async(execute: {
                self.updateEditView()
            })
        }
    }
    
    func updateEditView(){
        if let historyDataToEdit = historyDataToEdit{
            view.costDescriptionTextView.text = historyDataToEdit.description
            view.costPriceTextField.text = String(historyDataToEdit.price.dropLast())
            view.milageTextField.text = String(historyDataToEdit.mileage.dropLast().dropLast())
            let timeStamp = TimeInterval(historyDataToEdit.costDate)
            let newDate = Date(timeIntervalSince1970: timeStamp!)
            view.dateTextField.text = DateFormatter.localizedString(from: newDate, dateStyle: .short, timeStyle: .short)
            view.costTypeButton.setTitle(historyDataToEdit.costType.name(), for: .normal)
        }
    }
    
    func failedToFetchImage(error message: Error) {
        view.stopActivityIndicaotr()
        let imageNotFoundAlert: UIAlertController = NewHistoryDataActions.showImageNotFound()
        view.showImageNotFound(alert: imageNotFoundAlert)
    }
    
}


//MARK: - View Action Binding
extension NewHistoryDataPresenter{
    
    func bindActions(){
    
    view.selectCostTypeMenu
    .asObservable()
    .observeOn(MainScheduler.asyncInstance)
    .subscribe(onNext: { [unowned self]
    () in
    self.showSelectCostTypeActionSheet()
    }).disposed(by: view.disposeBag)
        
    }
}

//MARK: - View Action Alerts
extension NewHistoryDataPresenter{
    
    func showSelectCostTypeActionSheet(){
        let (costTypeActionSheet, actionSheetEvents) =  NewHistoryDataActions
            .showSelectCostTypeActionSheet()
        
        actionSheetEvents.other
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                () in
                self.costTypeSelected(costType: CostType.other)
            }).disposed(by: view.disposeBag)
        
        actionSheetEvents.fuel
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                [unowned self]
                () in
                self.costTypeSelected(costType: CostType.fuel)
            }).disposed(by: view.disposeBag)
        
        actionSheetEvents.repair
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                [unowned self]
                () in
                self.costTypeSelected(costType: CostType.repair)
            }).disposed(by: view.disposeBag)
        
        view.displayAction(action: costTypeActionSheet)
    }
    
    func costTypeSelected(costType: CostType){
        view.updateCostTypeButtonLabel(costType: costType.name())
    }
    
    
}


//MARK: - Connection with Interactor
extension NewHistoryDataPresenter{
    
    func submitData() {
        let costType = view.costTypeButton.titleLabel?.text ?? ""
        let costPrice = Double(view.costPriceTextField.text ?? "") ?? 0.0
        let milage = Int(view.milageTextField.text ?? "") ?? 0
        let costDescription = view.costDescriptionTextView.text ?? ""
        let imagePicked = view.imagePicked?.jpegData(compressionQuality: 0.7)
        var date = ""
        
        if let tempDate = view.getSelectedDate {
            date = String(tempDate.timeIntervalSince1970)
        } else {
            date = historyDataToEdit?.costDate ?? ""
        }
        
        if isEditMode(){
            guard let historyDataToEdit = self.historyDataToEdit else {
                return print("Error historyDataToEdit is nil")
            }
            interactor.updateData(document: historyDataToEdit.documentID ,type: costType, price: costPrice, milage: milage, date: date, costDescription: costDescription, image: imagePicked)
        } else{
            interactor.storeData(type: costType, price: costPrice, milage: milage, date: date, costDescription: costDescription, image: imagePicked)
        }
    }
    
    func performDataDelete(){
        guard let historyDataToEdit = self.historyDataToEdit else {
            return print("Error historyDataToEdit is nil")
        }
        interactor.deleteData(document: historyDataToEdit.documentID)
    }
    
    func getImageFromServer(){
        if let historyDataToEdit = historyDataToEdit {
            view.startActivityIndicaotr()
            interactor.fetchImage(form: historyDataToEdit.documentID)
        }
    }
    
}


//MARK: - Connection with Router
extension NewHistoryDataPresenter{
    
    func openAttachedImage(image data: UIImage) {
        router.showAttachedImageView(image: data)
        view.stopActivityIndicaotr()
    }
    
    func returnToHistory(){
        router.showHistory()
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
