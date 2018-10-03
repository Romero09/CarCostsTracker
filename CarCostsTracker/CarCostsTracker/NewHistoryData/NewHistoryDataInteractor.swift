//
//  NewHistoryDataInteractor.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import Firebase

// MARK: - NewHistoryDataInteractor Class
final class NewHistoryDataInteractor: Interactor {
    
    let db = Firestore.firestore()
}

// MARK: - NewHistoryDataInteractor API
extension NewHistoryDataInteractor: NewHistoryDataInteractorApi {
    
    
    func storeData(type: String, price: Double, milage: Int, date: String, costDescription: String) {
        
        var ref: DocumentReference? = nil
        ref = db.collection("userName").addDocument(data: [
            "costType": type,
            "price": price,
            "milage": milage,
            "date": date,
            "description": costDescription
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
}

// MARK: - Interactor Viper Components Api
private extension NewHistoryDataInteractor {
    var presenter: NewHistoryDataPresenterApi {
        return _presenter as! NewHistoryDataPresenterApi
    }
}
