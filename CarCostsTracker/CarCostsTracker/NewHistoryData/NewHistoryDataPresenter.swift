//
//  NewHistoryDataPresenter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewHistoryDataPresenter Class
final class NewHistoryDataPresenter: Presenter {
    var historyDataToEdit: HistoryCellData?
    
    override func viewHasLoaded() {
        super.viewIsAboutToAppear()
        if isEditMode(){
            DispatchQueue.main.async(execute: {
                self.updateEditView()
            })
        }
    }
}

// MARK: - NewHistoryDataPresenter API
extension NewHistoryDataPresenter: NewHistoryDataPresenterApi {
    
    
    func failedToFetchImage(error message: Error) {
        dismissActivityIndicator(uiView: view.newHistoryDataView.view)
        let alert = UIAlertController(title: "No image found", message: "No image found for this entry, please attach image", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        view.newHistoryDataView.present(alert, animated: true, completion: nil)
    }
    
    
    
    func openAttachedImage(image data: UIImage) {
        router.showAttachedImageView(image: data)
        dismissActivityIndicator(uiView: view.newHistoryDataView.view)
    }
    
    
    func returnToHistory(){
        router.showHistory()
    }
    
    func isEditMode() -> Bool {
        if historyDataToEdit != nil {
            return true } else {
            return false
        }
    }
    
    
    func updateEditView(){
        if let historyDataToEdit = historyDataToEdit{
            view.costDescriptionTextView.text = historyDataToEdit.description
            view.costPriceTextField.text = String(historyDataToEdit.price.dropLast())
            view.milageTextField.text = String(historyDataToEdit.mileage.dropLast().dropLast())
            let timeStamp = TimeInterval(historyDataToEdit.costDate)
            let newDate = Date(timeIntervalSince1970: timeStamp!)
            view.dateTextField.text = DateFormatter.localizedString(from: newDate, dateStyle: .short, timeStyle: .short)
            view.costTypeButton.setTitle(historyDataToEdit.costType.name(), for: .normal)
        }
    }
    
    func submitData() {
        let costType = view.costTypeButton.titleLabel?.text ?? ""
        let costPrice = Double(view.costPriceTextField.text ?? "") ?? 0.0
        let milage = Int(view.milageTextField.text ?? "") ?? 0
        let costDescription = view.costDescriptionTextView.text ?? ""
        let imagePicked = view.imagePicked?.jpegData(compressionQuality: 0.7)
        var date = ""
        
        if let tempDate = view.getSelectedDate {
            date = String(tempDate.timeIntervalSince1970)
        } else {
            date = historyDataToEdit?.costDate ?? ""
        }
        
        if isEditMode(){
            guard let historyDataToEdit = self.historyDataToEdit else {
                return print("Error historyDataToEdit is nil")
            }
            interactor.updateData(document: historyDataToEdit.documentID ,type: costType, price: costPrice, milage: milage, date: date, costDescription: costDescription, image: imagePicked)
        } else{
            interactor.storeData(type: costType, price: costPrice, milage: milage, date: date, costDescription: costDescription, image: imagePicked)
        }
    }
    
    func performDataDelete(){
        guard let historyDataToEdit = self.historyDataToEdit else {
            return print("Error historyDataToEdit is nil")
        }
        interactor.deleteData(document: historyDataToEdit.documentID)
    }
    
    func getImageFromServer(){
        if let historyDataToEdit = historyDataToEdit {
            showActivityIndicator(uiView: view.newHistoryDataView.view)
        interactor.fetchImage(form: historyDataToEdit.documentID)
        }
    }
    
    func fillEditData(edit data: HistoryCellData){
        historyDataToEdit = data
    }
    
    
    func showActivityIndicator(uiView: UIView) {
        DispatchQueue.main.async(execute: {
            let container: UIView = UIView()
            container.frame = uiView.frame
            container.center = uiView.center
            container.tag = 100
            
            let loadingView: UIView = UIView()
            loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            loadingView.center = uiView.center
            loadingView.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            actInd.hidesWhenStopped = true
            actInd.style =
                UIActivityIndicatorView.Style.whiteLarge
            actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                    y: loadingView.frame.size.height / 2);
            loadingView.addSubview(actInd)
            container.addSubview(loadingView)
            uiView.addSubview(container)
            actInd.startAnimating()
            
        })
    }
    
    func dismissActivityIndicator(uiView: UIView){
        DispatchQueue.main.async(execute: {
            if let viewWithTag = uiView.viewWithTag(100){
                viewWithTag.removeFromSuperview()
            }
        })
    }
}

// MARK: - NewHistoryData Viper Components
private extension NewHistoryDataPresenter {
    var view: NewHistoryDataViewApi {
        return _view as! NewHistoryDataViewApi
    }
    var interactor: NewHistoryDataInteractorApi {
        return _interactor as! NewHistoryDataInteractorApi
    }
    var router: NewHistoryDataRouterApi {
        return _router as! NewHistoryDataRouterApi
    }
}
