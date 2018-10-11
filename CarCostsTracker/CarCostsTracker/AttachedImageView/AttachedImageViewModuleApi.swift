//
//  AttachedImageViewModuleApi.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 11/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit

//MARK: - AttachedImageViewRouter API
protocol AttachedImageViewRouterApi: RouterProtocol {
    func showImageView(from: UserInterface, image data: UIImage)
}

//MARK: - AttachedImageViewView API
protocol AttachedImageViewViewApi: UserInterfaceProtocol {
    var attchedImageView: UIImageView! {get set}
}

//MARK: - AttachedImageViewPresenter API
protocol AttachedImageViewPresenterApi: PresenterProtocol {
    func setImageView(image data: UIImage)
}

//MARK: - AttachedImageViewInteractor API
protocol AttachedImageViewInteractorApi: InteractorProtocol {
}
