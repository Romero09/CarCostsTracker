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
}

// MARK: - NewHistoryData Viper Components
private extension NewHistoryDataRouter {
    var presenter: NewHistoryDataPresenterApi {
        return _presenter as! NewHistoryDataPresenterApi
    }
}
