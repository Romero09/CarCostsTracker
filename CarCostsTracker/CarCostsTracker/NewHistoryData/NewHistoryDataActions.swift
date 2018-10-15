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
    
    static func showDeleteAction() -> (UIAlertController, ControlEvent<Void>){
        let deleteActionView = UIAlertController(title: "Delete entry", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
        
        let (accept, observableDelete) = UIAlertAction.createAction(with: "Yes", style: .destructive)
        
        let eventDelete = ControlEvent<Void>(events: observableDelete)
        
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        deleteActionView.addAction(accept)
        deleteActionView.addAction(cancel)
        
        return (deleteActionView, eventDelete)
    }
    
    static func showSelectCostTypeActionSheet() -> (UIAlertController, AlertActions) {
        let actionSheet = UIAlertController(title: "Type of costs", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let (repair, repairEvents) = UIAlertAction.createAction(with: CostType.repair.name(), style: .default)
        
        let (fuel, fuelEvents) = UIAlertAction.createAction(with: CostType.fuel.name(), style: .default)
        
        let (other, otherEvents) = UIAlertAction.createAction(with: CostType.other.name(), style: .default)
        
        actionSheet.addAction(repair)
        actionSheet.addAction(fuel)
        actionSheet.addAction(other)
        actionSheet.addAction(cancel)

        //Creating alertActions as ControlEvents
        let actions = AlertActions(repair: repairEvents,
                                   fuel: fuelEvents,
                                   other: otherEvents)
        
        //Returning created UIAlertActionSheet and actions ControlEvents
        return (actionSheet, actions)
    }
    
    
    static func showImageNotFound() -> UIAlertController{
        let alert = UIAlertController(title: "No image found", message: "No image found for this entry, please attach image", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
    
    public struct AlertActions{
        public let repair: ControlEvent<Void>
        public let fuel: ControlEvent<Void>
        public let other: ControlEvent<Void>
        
        //Creating ControlEvents from Observables.
        public init(repair: Observable<Void>, fuel: Observable<Void>, other: Observable<Void>){
            self.repair = ControlEvent<Void>(events: repair)
            self.fuel = ControlEvent<Void>(events: fuel)
            self.other = ControlEvent<Void>(events: other)
        }
    }
}

//Extension to create custom alertactionsheet
extension UIAlertAction {
    static func createAction(with title: String, style: UIAlertAction.Style) -> (UIAlertAction, Observable<Void>) {
        //Creating observable as PublishSubject
        let eventObservableRelay = PublishSubject<Void>()
        let action = UIAlertAction(title: title, style: style, handler: {
            (_) in
            eventObservableRelay.onNext(()) //Adding void event to observable on button pressed to handle this event.
        })
        return (action, eventObservableRelay.asObservable()) //returning Action for ActionSheet and observable as tuple
    }
}
