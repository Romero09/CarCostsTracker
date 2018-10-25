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
    
    func showLogIn(from view: UserInterface){
        self.show(from: view)
    }
    
    func showHistory() {
        let module = AppModules.History.build()
        let historyRouter =  module.router as! HistoryRouterApi
        historyRouter.showHistory(from: _view)
    }
}

// MARK: - Login Viper Components
private extension LoginRouter {
    var presenter: LoginPresenterApi {
        return _presenter as! LoginPresenterApi
    }
}
