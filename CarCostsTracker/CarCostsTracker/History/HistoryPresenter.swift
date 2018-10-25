//
//  HistoryPresenter.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - HistoryPresenter Class
final class HistoryPresenter: Presenter {
    
    var historyArray: Array<HistoryCellData> = []
}

// MARK: - HistoryPresenter API
extension HistoryPresenter: HistoryPresenterApi {
    
    func transferData(history data: Array<HistoryDataModel>) {

        historyArray = []
        
        for history in data {
            let costsDescription = history.costsDescription
            let costsPrice = String(format:"%.2f$", history.costsPrice)
            let costsType = history.costsType
            var costsTypeEnum: CostType = CostType.other
            
            switch costsType {
            case "Fuel":
                costsTypeEnum = CostType.fuel
            case "Repair":
                costsTypeEnum = CostType.repair
            case "Other":
                costsTypeEnum = CostType.other
            default:
                print("Error no such costs")
            }
            let date = history.date
            let documentID = history.documentID
            let milage = String(history.milage)+"km"
        
            let historyCellData = HistoryCellData(costType: costsTypeEnum, costDate: date, mileage: milage, description: costsDescription, price: costsPrice, documentID: documentID)
        
            self.historyArray.append(historyCellData)
        }
        view.reloadData()
    }
    
    func historyCellSelected(cell data: HistoryCellData){
        router.showNewHistoryData(edit: data)
    }
    
    func getData(){
        interactor.fetchFromDB()
    }
    
    func switchSwitchToNewHistoryData(){
        router.showNewHistoryData()
    }
    
}

// MARK: - History Viper Components
private extension HistoryPresenter {
    var view: HistoryViewApi {
        return _view as! HistoryViewApi
    }
    var interactor: HistoryInteractorApi {
        return _interactor as! HistoryInteractorApi
    }
    var router: HistoryRouterApi {
        return _router as! HistoryRouterApi
    }
}
