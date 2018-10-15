//
//  NewHistoryDataActions.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 12/10/2018.
//  Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

internal class NewHistoryDataActions{
    
    static func showDeleteAction(presenter: NewHistoryDataPresenterApi) -> UIAlertController{
        let deleteAction = UIAlertController(title: "Delete entry", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Yes", style: .destructive) { action in
            presenter.performDataDelete()
        }
        
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        deleteAction.addAction(accept)
        deleteAction.addAction(cancel)
        
        return deleteAction
    }
    
    static func showSelectCostTypeActionSheet(view: NewHistoryDataView, actions: [UIAlertAction]) -> UIAlertController {
        let actionSheet = UIAlertController(title: "Type of costs", message: nil, preferredStyle: .actionSheet)
        
        actions.forEach {
            (action) in
            actionSheet.addAction(action)
        }

        return actionSheet
    }
    
    static func showImageNotFound() -> UIAlertController{
        let alert = UIAlertController(title: "No image found", message: "No image found for this entry, please attach image", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
    
    public struct AlertActions{
        public let actions: [UIAlertAction]
        public let event: ControlEvent<UIAlertAction>
    }
}
