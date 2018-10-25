//
//  LoginInteractor.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - LoginInteractor Class
final class LoginInteractor: Interactor {
}

// MARK: - LoginInteractor API
extension LoginInteractor: LoginInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension LoginInteractor {
    var presenter: LoginPresenterApi {
        return _presenter as! LoginPresenterApi
    }
}
