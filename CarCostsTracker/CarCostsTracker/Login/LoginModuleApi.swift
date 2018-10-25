//
//  LoginModuleApi.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit
import FirebaseUI

//MARK: - LoginRouter API
protocol LoginRouterApi: RouterProtocol {
    func showLogIn(from view: UserInterface)
    func showHistory()
}

//MARK: - LoginView API
protocol LoginViewApi: UserInterfaceProtocol{
}

//MARK: - LoginPresenter API
protocol LoginPresenterApi: PresenterProtocol {
    func signInUser() -> UINavigationController?
    func switchToHistory()
}

//MARK: - LoginInteractor API
protocol LoginInteractorApi: InteractorProtocol {
}
