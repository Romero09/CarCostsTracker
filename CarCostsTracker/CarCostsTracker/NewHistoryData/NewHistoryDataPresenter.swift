//
//  NewHistoryDataPresenter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewHistoryDataPresenter Class
final class NewHistoryDataPresenter: Presenter {
    var historyDataToEdit: HistoryCellData?
    
    override func viewHasLoaded(){
        if isEditMode(){
            DispatchQueue.main.async(execute: {
                self.updateEditView()
            })
        }
    }
}

// MARK: - NewHistoryDataPresenter API
extension NewHistoryDataPresenter: NewHistoryDataPresenterApi {
    
    func returnToHistory(){
        router.showHistory()
    }
    
    func isEditMode() -> Bool {
        if historyDataToEdit != nil {
            return true } else {
                return false
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
    
    func submitData() {
        let costType = view.costTypeButton.titleLabel?.text ?? ""
        let costPrice = Double(view.costPriceTextField.text ?? "") ?? 0.0
        let milage = Int(view.milageTextField.text ?? "") ?? 0
        let costDescription = view.costDescriptionTextView.text ?? ""
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
            interactor.updateData(document: historyDataToEdit.documentID ,type: costType, price: costPrice, milage: milage, date: date, costDescription: costDescription)
        } else{
        interactor.storeData(type: costType, price: costPrice, milage: milage, date: date, costDescription: costDescription)
        }
    }
    
    func performDataDelete(){
        guard let historyDataToEdit = self.historyDataToEdit else {
           return print("Error historyDataToEdit is nil")
        }
        interactor.deleteData(document: historyDataToEdit.documentID)
    }
    
    func fillEditData(edit data: HistoryCellData){
        historyDataToEdit = data
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
