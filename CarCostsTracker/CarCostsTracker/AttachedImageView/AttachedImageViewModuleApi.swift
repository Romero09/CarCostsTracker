//
//  AttachedImageViewModuleApi.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 11/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit
import RxSwift
import RxCocoa

//MARK: - AttachedImageViewRouter API
protocol AttachedImageViewRouterApi: RouterProtocol {
    func showImageView(from: UserInterface, image data: UIImage)
    
}

//MARK: - AttachedImageViewView API
protocol AttachedImageViewViewApi: UserInterfaceProtocol {
    var attchedImageView: UIImageView! {get set}
    var shareImage: ControlEvent<Void> { get }
    var disposeBag: DisposeBag { get }
    func presentActivity(activity: UIViewController)
}

//MARK: - AttachedImageViewPresenter API
protocol AttachedImageViewPresenterApi: PresenterProtocol {
}

//MARK: - AttachedImageViewInteractor API
protocol AttachedImageViewInteractorApi: InteractorProtocol {
}
