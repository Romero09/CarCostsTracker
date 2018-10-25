//
//  HistoryRouter.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - HistoryRouter class
final class HistoryRouter: Router {
}

// MARK: - HistoryRouter API
extension HistoryRouter: HistoryRouterApi {
    
    func showHistory(from view: UserInterface) {
        self.show(from: view)
    }
    
    func showNewHistoryData(){
        let module = AppModules.NewHistoryData.build()
        let newHistoryDataRouter = module.router as! NewHistoryDataRouterApi
        newHistoryDataRouter.showNewHistoryData(from: _view)
    }
    
    func showNewHistoryData(edit data: HistoryCellData){
        let module = AppModules.NewHistoryData.build()
        let newHistoryDataRouter = module.router as! NewHistoryDataRouterApi
        newHistoryDataRouter.showNewHistoryDataEdit(from: _view, edit: data)
    }
}

// MARK: - History Viper Components
private extension HistoryRouter {
    var presenter: HistoryPresenterApi {
        return _presenter as! HistoryPresenterApi
    }
}
