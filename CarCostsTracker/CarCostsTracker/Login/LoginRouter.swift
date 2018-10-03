//
//  LoginRouter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - LoginRouter class
final class LoginRouter: Router {
}

// MARK: - LoginRouter API
extension LoginRouter: LoginRouterApi {
}

// MARK: - Login Viper Components
private extension LoginRouter {
    var presenter: LoginPresenterApi {
        return _presenter as! LoginPresenterApi
    }
}
