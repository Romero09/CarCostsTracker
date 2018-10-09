//
//  ChartsRouter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 09/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - ChartsRouter class
final class ChartsRouter: Router {
}

// MARK: - ChartsRouter API
extension ChartsRouter: ChartsRouterApi {
    
    func showCharts(from view: UserInterface, data array: Array<HistoryDataModel>){
        presenter.store(data: array)
        self.show(from: view)
    }
}

// MARK: - Charts Viper Components
private extension ChartsRouter {
    var presenter: ChartsPresenterApi {
        return _presenter as! ChartsPresenterApi
    }
}
