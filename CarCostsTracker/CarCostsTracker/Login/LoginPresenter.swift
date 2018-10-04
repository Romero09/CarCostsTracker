//
//  LoginPresenter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import FirebaseAuth
import FirebaseUI

// MARK: - LoginPresenter Class
final class LoginPresenter: Presenter {
}

// MARK: - LoginPresenter API
extension LoginPresenter: LoginPresenterApi {
    
    func signInUser() -> UINavigationController? {
        guard let authUI = FUIAuth.defaultAuthUI() else{
            return nil
        }
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        authUI.providers = providers
        authUI.delegate = view as? FUIAuthDelegate
        return authUI.authViewController()
    }
    
    func switchToHistory() {
        router.showHistory()
    }
}


// MARK: - Login Viper Components
private extension LoginPresenter {
    var view: LoginViewApi {
        return _view as! LoginViewApi
    }
    var interactor: LoginInteractorApi {
        return _interactor as! LoginInteractorApi
    }
    var router: LoginRouterApi {
        return _router as! LoginRouterApi
    }
}
