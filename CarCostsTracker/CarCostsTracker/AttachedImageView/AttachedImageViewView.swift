//
//  AttachedImageViewView.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 11/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit

//MARK: AttachedImageViewView Class
final class AttachedImageViewView: UserInterface {
    @IBOutlet weak var attchedImageView: UIImageView!
    
}

//MARK: - AttachedImageViewView API
extension AttachedImageViewView: AttachedImageViewViewApi {
    
}

// MARK: - AttachedImageViewView Viper Components API
private extension AttachedImageViewView {
    var presenter: AttachedImageViewPresenterApi {
        return _presenter as! AttachedImageViewPresenterApi
    }
    var displayData: AttachedImageViewDisplayData {
        return _displayData as! AttachedImageViewDisplayData
    }
}
