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
}

//MARK: - LoginView API
protocol LoginViewApi: UserInterfaceProtocol{
}

//MARK: - LoginPresenter API
protocol LoginPresenterApi: PresenterProtocol {
    func signInUser() -> UINavigationController?
}

//MARK: - LoginInteractor API
protocol LoginInteractorApi: InteractorProtocol {
}
