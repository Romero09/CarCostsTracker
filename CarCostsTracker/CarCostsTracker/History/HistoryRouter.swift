//
//  HistoryRouter.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import RxCocoa
import RxSwift

// MARK: - HistoryRouter class
final class HistoryRouter: Router {
}

// MARK: - HistoryRouter API
extension HistoryRouter: HistoryRouterApi {
    
    
    func showCharts(data array: [HistoryDataModel]) {
        let module = AppModules.Charts.build()
        let chartsRouter = module.router as! ChartsRouterApi
        chartsRouter.show(from: _view, embedInNavController: false, setupData: array)
    }
    
    func showLogIn(){
        let module = AppModules.Login.build()
        let LogInRouter = module.router as! LoginRouterApi
        LogInRouter.showLogIn(from: _view)
    }
    
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
