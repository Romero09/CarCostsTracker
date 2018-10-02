//
//  HistoryInteractor.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - HistoryInteractor Class
final class HistoryInteractor: Interactor {
}

// MARK: - HistoryInteractor API
extension HistoryInteractor: HistoryInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension HistoryInteractor {
    var presenter: HistoryPresenterApi {
        return _presenter as! HistoryPresenterApi
    }
}
