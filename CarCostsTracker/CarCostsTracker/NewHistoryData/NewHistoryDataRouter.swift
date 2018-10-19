//
//  NewHistoryDataRouter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import UIKit
import RxCocoa
import RxSwift

// MARK: - NewHistoryDataRouter class
final class NewHistoryDataRouter: Router {
}

// MARK: - NewHistoryDataRouter API
extension NewHistoryDataRouter: NewHistoryDataRouterApi {
    
    func showImagePicker(picker: UIImagePickerController, image: Observable<UIImage>) {
        _view.present(picker, animated: true, completion: nil)
        image.subscribe(onCompleted: {
            picker.dismiss(animated: true, completion: nil)
        }).disposed(by: presenter.disposeBag)

    }
    
    
    func showAttachedImageView(image data: UIImage) {
        let module = AppModules.AttachedImageView.build()
        let attachedImageViewRouter = module.router as! AttachedImageViewRouterApi
        attachedImageViewRouter.showImageView(from: _view, image: data)
    }
    
    func showNewHistoryData(from view: UserInterface){
        self.show(from: view)
    }
    
    func showNewHistoryDataEdit(from view: UserInterface, edit data: HistoryCellData){
        self.show(from: view)
        
        presenter.setupView(data: data)
    }
    
    func showHistory(){
        let module = AppModules.History.build()
        let historyRouter = module.router as! HistoryRouterApi
        historyRouter.showHistory(from: _view)
    }
}

// MARK: - NewHistoryData Viper Components
private extension NewHistoryDataRouter {
    var presenter: NewHistoryDataPresenterApi {
        return _presenter as! NewHistoryDataPresenterApi
    }
}
