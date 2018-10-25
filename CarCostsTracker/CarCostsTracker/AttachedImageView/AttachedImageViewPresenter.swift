//
//  AttachedImageViewPresenter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 11/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - AttachedImageViewPresenter Class
final class AttachedImageViewPresenter: Presenter {
    
    var atachedImage: UIImage?
    
    override func viewIsAboutToAppear() {
        if let atachedImage = atachedImage{
        updateImageView(image: atachedImage)
        }
    }

}

// MARK: - AttachedImageViewPresenter API
extension AttachedImageViewPresenter: AttachedImageViewPresenterApi {

    func updateImageView(image data: UIImage){
        view.attchedImageView.contentMode = UIView.ContentMode.scaleAspectFit
        view.attchedImageView.image = data
    }
    
    func setImageView(image data: UIImage) {
        atachedImage = data
    }
    
}

// MARK: - AttachedImageView Viper Components
private extension AttachedImageViewPresenter {
    var view: AttachedImageViewViewApi {
        return _view as! AttachedImageViewViewApi
    }
    var interactor: AttachedImageViewInteractorApi {
        return _interactor as! AttachedImageViewInteractorApi
    }
    var router: AttachedImageViewRouterApi {
        return _router as! AttachedImageViewRouterApi
    }
}
