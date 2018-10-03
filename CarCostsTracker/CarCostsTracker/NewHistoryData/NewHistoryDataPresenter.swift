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
}

// MARK: - NewHistoryDataPresenter API
extension NewHistoryDataPresenter: NewHistoryDataPresenterApi {
    
    func submitData() {
        let costType = view.costType.titleLabel?.text ?? ""
        let costPrice = Double(view.costPrice.text ?? "") ?? 0.0
        let milage = Int(view.milage.text ?? "") ?? 0
        let date = view.date.text ?? ""
        let costDescription = view.costDescription.text ?? ""
        
        interactor.storeData(type: costType, price: costPrice, milage: milage, date: date, costDescription: costDescription)
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
