//
//  AttachedImageViewInteractor.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 11/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - AttachedImageViewInteractor Class
final class AttachedImageViewInteractor: Interactor {
}

// MARK: - AttachedImageViewInteractor API
extension AttachedImageViewInteractor: AttachedImageViewInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension AttachedImageViewInteractor {
    var presenter: AttachedImageViewPresenterApi {
        return _presenter as! AttachedImageViewPresenterApi
    }
}
