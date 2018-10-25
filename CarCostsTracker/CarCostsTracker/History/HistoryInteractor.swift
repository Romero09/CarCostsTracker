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
import RxSwift

extension String: Error {}

// MARK: - HistoryInteractor Class
final class HistoryInteractor: Interactor {
    let db = Firestore.firestore()
}

// MARK: - HistoryInteractor API
extension HistoryInteractor: HistoryInteractorApi {
    
    public func fetchHistoryData() -> Observable<[HistoryDataModel]> {
        return self.fetch()
            .map { try $0.toHistoryDataModel() }
    }
    
    private func fetch() -> Observable<[QueryDocumentSnapshot]> {
        return Observable.create() { [unowned self]
            (observer) -> Disposable in
            guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
                observer.onError("User unauthorized")
                return Disposables.create()
            }
            let costsRef = self.db.collection(userUID)
            
            costsRef.order(by: "date", descending: true).getDocuments() { (querySnapshot, error) in
                if let documents = querySnapshot?.documents {
                    observer.onNext(documents)
                    observer.onCompleted()
                }
                else{
                    if let error = error {
                        observer.onError(error)
                    }
                    else {
                        observer.onError("Unknows error, nil documents")
                    }
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension HistoryInteractor {
    var presenter: HistoryPresenterApi {
        return _presenter as! HistoryPresenterApi
    }
}

public struct HistoryDataModel {
    public let  documentID: String
    public let date: String
    public let costsPrice: Double
    public let mileage: Int
    public let costsType: String
    public let costsDescription: String
    
    init(with document: QueryDocumentSnapshot) throws {
        documentID = document.documentID
        guard let date = document.data()["date"] as? String,
              let costsPrice = document.data()["price"] as? Double,
              let mileage = document.data()["milage"] as? Int,
              let costsType = document.data()["costType"] as? String,
              let costsDescription = document.data()["description"] as? String else {
                throw "Failed to unwrap data from document documentID: \(documentID)"
        }
        self.date = date
        self.costsPrice = costsPrice
        self.mileage = mileage
        self.costsType = costsType
        self.costsDescription = costsDescription
    }
}

extension Array where Element == QueryDocumentSnapshot {
    func toHistoryDataModel() throws -> [HistoryDataModel] {
        return try self.map{  try HistoryDataModel(with: $0) }
    }
}
