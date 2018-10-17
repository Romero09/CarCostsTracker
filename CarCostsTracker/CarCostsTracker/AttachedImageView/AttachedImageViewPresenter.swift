//
//  AttachedImageViewPresenter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 11/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import RxCocoa

// MARK: - AttachedImageViewPresenter Class
final class AttachedImageViewPresenter: Presenter {
    
    var atachedImage: UIImage?
    
    override func setupView(data: Any) {
        atachedImage = (data as! UIImage)
        bindActions()
    }
    
    override func viewHasLoaded() {
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
    
    func bindActions(){
        view.shareImage
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.shareWithImage()
            }).disposed(by: view.disposeBag)
    }
    
    func shareWithImage(){
        guard let atachedImage = atachedImage else {
            fatalError("No image presented")
        }
        let activityVC = UIActivityViewController(activityItems: [atachedImage], applicationActivities: nil)
        view.presentActivity(activity: activityVC)
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
