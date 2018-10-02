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
}

// MARK: - History Viper Components
private extension HistoryRouter {
    var presenter: HistoryPresenterApi {
        return _presenter as! HistoryPresenterApi
    }
}
