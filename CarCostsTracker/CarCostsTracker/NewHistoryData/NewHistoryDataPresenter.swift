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
    
    private func updateEditView(){
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
        
        view.submitResults
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.submitData()
            }).disposed(by: view.disposeBag)
        
        view.deleteEntry
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.showDeleteEntryActionAlert()
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
        view.stopActivityIndicaotr()
        let imageNotFoundAlert: UIAlertController = NewHistoryDataActions.showImageNotFound()
        self.view.displayAction(action: imageNotFoundAlert)
    }
    
}


//MARK: - Connection with Interactor
extension NewHistoryDataPresenter{
    
    private func submitData() {
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
    
    private func performDataDelete(){
        guard let historyDataToEdit = self.historyDataToEdit else {
            return print("Error historyDataToEdit is nil")
        }
        interactor.deleteData(document: historyDataToEdit.documentID)
    }
    
    func getImageFromServer(){
        if let historyDataToEdit = historyDataToEdit {
            view.startActivityIndicaotr()
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
