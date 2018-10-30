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
import RxCocoa

// MARK: - NewHistoryDataInteractor Class
final class NewHistoryDataInteractor: Interactor {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
}

// MARK: - NewHistoryDataInteractor API
extension NewHistoryDataInteractor: NewHistoryDataInteractorApi {
    
}


//MARK: - Data delete form storage functions
extension NewHistoryDataInteractor{
    
    func deleteData(document id: String) {
        guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
            fatalError("Error user not Authorized")
        }
        db.collection(userUID).document(id).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document: \(id) successfully removed!")
                self.presenter.returnToHistory()
            }
        }
        
        let normalImageRef = storage.reference().child(userUID).child("\(id).jpg")
        normalImageRef.delete { error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // File deleted successfully
            }
        }
        
        let thumbnailImageRef = storage.reference().child(userUID).child("\(id)Thumbnail.jpg")
        thumbnailImageRef.delete { error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // File deleted successfully
            }
        }
    }
}


//MARK: - Fetching data functions
extension NewHistoryDataInteractor{
    
    func fetchImage(from documentID: String) -> Observable<UIImage>{
        return Observable.create() { [unowned self]
            (observer) -> Disposable in
            guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
                observer.onError("User unautohrized")
                return Disposables.create()
            }
            let storageRef = self.storage.reference().child(userUID).child("\(documentID).jpg")
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)!
                    observer.onNext(image)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchThumbNailImage(from documentID: String?) -> Observable<UIImage>{
        return Observable.create() { [unowned self]
            (observer) -> Disposable in
            guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
                observer.onError("User unautohrized")
                return Disposables.create()
            }
            guard let documentID = documentID else {
                observer.onError("Document ID was nil")
                return Disposables.create()
            }
            let storageRef = self.storage.reference().child(userUID).child("\(documentID)Thumbnail.jpg")
            // Download in memory with a maximum allowed size of 10MB (10 * 1024 * 1024 bytes)
            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)!
                    observer.onNext(image)
                }
            }
            return Disposables.create()
        }
    }
}


//MARK: - Store data functions
extension NewHistoryDataInteractor{
    
    func storeData(where result: NewHistoryDataPresenter.Result) {
        
        var ref: DocumentReference? = nil
        guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
            fatalError("Error user not Authorized")
        }
        
        let type = result.costType
        let price = Double(result.price)
        let milage = Int(result.mileage)
        let date = result.date
        let costDescription = result.description
        
        ref = db.collection(userUID).addDocument(data: [
            "costType": type,
            "price": price!,
            "milage": milage!,
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
        
        if let image = result.image, let ref = ref {
            storeImage(where: image, document: ref, user: userUID)
        }
    }
    
    func updateData(where result: NewHistoryDataPresenter.Result){
        var ref: DocumentReference? = nil
        guard  let userUID = sharedUserAuth.authorizedUser?.currentUser?.uid else{
            fatalError("Error user not Authorized")
        }
        
        let type = result.costType
        let price = Double(result.price)
        let milage = Int(result.mileage)
        let date = result.date
        let costDescription = result.description
        
        ref = db.collection(userUID).document(result.documentId!)
        ref?.updateData([
            "costType": type,
            "price": price!,
            "milage": milage!,
            "date": date,
            "description": costDescription
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.presenter.returnToHistory()
                print("Document \(result.documentId!) successfully updated")
            }
        }
        
        if let image = result.image, let ref = ref {
            storeImage(where: image, document: ref, user: userUID)
        }
    }
    
    func storeImage(where image: UIImage, document ref: DocumentReference, user userUID: String){
        let normalImage = image.jpegData(compressionQuality: 0.7)
        
        let imageStandartStorage = storage.reference().child(userUID).child("\(ref.documentID).jpg")
        // Upload the file to the path "userID/documentID"
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageStandartStorage.putData(normalImage!, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error adding document: \(error)")
            }
        }
        
        let imageThumbnailStorage = storage.reference().child(userUID).child("\(ref.documentID)Thumbnail.jpg")
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let resizedImage = resizeImage(image: image, targetSize: CGSize.init(width: imageWidth/6, height: imageHeight/6))
        let compressedImage = resizedImage.jpegData(compressionQuality: 0.01)
        
        imageThumbnailStorage.putData(compressedImage!, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error adding document: \(error)")
            }
        }
    }
}


//MARK: - Resize image helper functions
extension NewHistoryDataInteractor{
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


// MARK: - Interactor Viper Components Api
private extension NewHistoryDataInteractor {
    var presenter: NewHistoryDataPresenterApi {
        return _presenter as! NewHistoryDataPresenterApi
    }
}
