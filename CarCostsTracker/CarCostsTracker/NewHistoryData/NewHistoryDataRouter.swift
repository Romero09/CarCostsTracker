//
//  NewHistoryDataRouter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewHistoryDataRouter class
final class NewHistoryDataRouter: Router {
}

// MARK: - NewHistoryDataRouter API
extension NewHistoryDataRouter: NewHistoryDataRouterApi {
    func showNewHistoryData(from view: UserInterface){
        self.show(from: view)
    }
    
    func showNewHistoryDataEdit(from view: UserInterface, edit data: HistoryCellData){
        presenter.fillEditData(edit: data)
        self.show(from: view)
    }
}

// MARK: - NewHistoryData Viper Components
private extension NewHistoryDataRouter {
    var presenter: NewHistoryDataPresenterApi {
        return _presenter as! NewHistoryDataPresenterApi
    }
}
