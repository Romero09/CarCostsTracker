//
//  AttachedImageViewRouter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 11/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - AttachedImageViewRouter class
final class AttachedImageViewRouter: Router {
}

// MARK: - AttachedImageViewRouter API
extension AttachedImageViewRouter: AttachedImageViewRouterApi {
    
    func showImageView(from view: UserInterface, image data: UIImage) {
        self.show(from: view)
        presenter.setImageView(image: data)
    }
    
}

// MARK: - AttachedImageView Viper Components
private extension AttachedImageViewRouter {
    var presenter: AttachedImageViewPresenterApi {
        return _presenter as! AttachedImageViewPresenterApi
    }
}
