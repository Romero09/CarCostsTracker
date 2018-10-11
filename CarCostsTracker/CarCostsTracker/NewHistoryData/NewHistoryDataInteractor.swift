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
import RxSwift

// MARK: - NewHistoryDataInteractor Class
final class NewHistoryDataInteractor: Interactor {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
}

// MARK: - NewHistoryDataInteractor API
extension NewHistoryDataInteractor: NewHistoryDataInteractorApi {
    
    
    func deleteData(document id: String) {
        
        guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
            return print("Error user not Authorized")
        }
        
        db.collection(userUID).document(id).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document: \(id) successfully removed!")
                self.presenter.returnToHistory()
            }
        }
        
        // Create a reference to the file to delete
        let storageRef = storage.reference().child(userUID).child("\(id).jpg")
        
        // Delete the file
        storageRef.delete { error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // File deleted successfully
            }
        }
    }
    
    
    
    func storeData(type: String, price: Double, milage: Int, date: String, costDescription: String, image: Data?) {
        
        
        
        var ref: DocumentReference? = nil
        guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
            return print("Error user not Authorized")
        }
        ref = db.collection(userUID).addDocument(data: [
            "costType": type,
            "price": price,
            "milage": milage,
            "date": date,
            "description": costDescription
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.presenter.returnToHistory()
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        if let image = image {
            
            let storageRef = storage.reference().child(userUID).child("\(ref!.documentID).jpg")
            // Upload the file to the path "userID/documentID"
            // Create file metadata including the content type
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(image, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error adding document: \(error)")
                }
            }
        }
    }
    
    func updateData(document id: String, type: String, price: Double, milage: Int, date: String, costDescription: String, image: Data?){
        var ref: DocumentReference? = nil
        guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
            return print("Error user not Authorized")
        }
        
        ref = db.collection(userUID).document(id)
        ref?.updateData([
            "costType": type,
            "price": price,
            "milage": milage,
            "date": date,
            "description": costDescription
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.presenter.returnToHistory()
                print("Document \(id) successfully updated")
            }
        }
        
        if let image = image {
            
            let storageRef = storage.reference().child(userUID).child("\(ref!.documentID).jpg")
            // Upload the file to the path "userID/documentID"
            // Create file metadata including the content type
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(image, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error adding document: \(error)")
                }
            }
        }
    }
    
    func fetchImage(form documentID: String){
        guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
            return print("Error user not Authorized")
        }
        
         let storageRef = storage.reference().child(userUID).child("\(documentID).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
                self.presenter.failedToFetchImage(error: error)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.presenter.openAttachedImage(image: image!)
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
