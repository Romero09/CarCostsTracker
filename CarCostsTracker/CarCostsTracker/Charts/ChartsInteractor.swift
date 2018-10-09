//
//  ChartsInteractor.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 09/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - ChartsInteractor Class
final class ChartsInteractor: Interactor {
}

// MARK: - ChartsInteractor API
extension ChartsInteractor: ChartsInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension ChartsInteractor {
    var presenter: ChartsPresenterApi {
        return _presenter as! ChartsPresenterApi
    }
}
