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
    
    func isEditMode() -> Bool {
        if historyDataToEdit != nil {
            return true } else {
                return false
        }
    }
    
    
    func updateEditView(){
        if let historyDataToEdit = historyDataToEdit{
            view.costDescription.text = historyDataToEdit.description
            view.costPrice.text = String(historyDataToEdit.price.dropLast())
            view.milage.text = String(historyDataToEdit.mileage.dropLast().dropLast())
            view.date.text = historyDataToEdit.costDate
            view.costType.setTitle(historyDataToEdit.costType.name(), for: .normal)
            view.date.text = historyDataToEdit.costDate
        }
    }
    
    func submitData() {
        let costType = view.costType.titleLabel?.text ?? ""
        let costPrice = Double(view.costPrice.text ?? "") ?? 0.0
        let milage = Int(view.milage.text ?? "") ?? 0
        let date = view.date.text ?? ""
        let costDescription = view.costDescription.text ?? ""
        
        interactor.storeData(type: costType, price: costPrice, milage: milage, date: date, costDescription: costDescription)
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
