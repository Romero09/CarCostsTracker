//
//  HistoryInteractor.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import Firebase

// MARK: - HistoryInteractor Class
final class HistoryInteractor: Interactor {
    let db = Firestore.firestore()
}

// MARK: - HistoryInteractor API
extension HistoryInteractor: HistoryInteractorApi {
    
    func fetchFromDB(){
        
        var historyArray: Array<HistoryDataModel> = []
        
        guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
            return print("Error user not Authorized")
        }
        let costsRef = db.collection(userUID)
        
        costsRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var historyDataModel = HistoryDataModel()
                    historyDataModel.documentID = document.documentID
                    historyDataModel.date = (document.data()["date"] as? String)!
                    historyDataModel.costsPrice = (document.data()["price"] as? Double)!
                    historyDataModel.milage = (document.data()["milage"] as? Int)!
                    historyDataModel.costsType = (document.data()["costType"] as? String)!
                    historyDataModel.costsDescription = (document.data()["description"] as? String)!
                    
                    historyArray.append(historyDataModel)
                    print("\(document.documentID) => \(document.data())")
                }
            }
            
            self.presenter.transferData(history: historyArray)
            
        }
        
        
    }
}

// MARK: - Interactor Viper Components Api
private extension HistoryInteractor {
    var presenter: HistoryPresenterApi {
        return _presenter as! HistoryPresenterApi
    }
}

struct HistoryDataModel {
    var documentID: String = ""
    var date: String = ""
    var costsPrice: Double = 0.0
    var milage: Int = 0
    var costsType: String = ""
    var costsDescription: String = ""
}
