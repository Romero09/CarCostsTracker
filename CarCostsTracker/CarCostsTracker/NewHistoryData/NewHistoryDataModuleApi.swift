//
//  NewHistoryDataModuleApi.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit
import RxCocoa
import RxSwift

//MARK: - NewHistoryDataRouter API
protocol NewHistoryDataRouterApi: RouterProtocol {
    func showNewHistoryData(from view: UserInterface)
    func showNewHistoryDataEdit(from view: UserInterface, edit data: HistoryCellData)
    func showHistory()
    func showAttachedImageView(image data: UIImage)
}

//MARK: - NewHistoryDataView API
protocol NewHistoryDataViewApi: UserInterfaceProtocol {
    var selectCostTypeMenu: ControlEvent<Void> { get }
    var submitResults: ControlEvent<Void> { get }
    var deleteEntry: ControlEvent<Void> { get }
    var disposeBag: DisposeBag { get }
    
    var getSelectedDate: Date? {get}
    var costTypeButton: UIButton! {get}
    var costPriceTextField: UITextField! {get}
    var milageTextField: UITextField! {get}
    var dateTextField: UITextField! {get set}
    var costDescriptionTextView: UITextView! {get}
    var imagePicked: UIImage? {get}
    
    func startActivityIndicaotr()
    func stopActivityIndicaotr()
    func displayAction(action view: UIAlertController)
    func updateCostTypeButtonLabel(costType text: String)
    
}

//MARK: - NewHistoryDataPresenter API
protocol NewHistoryDataPresenterApi: PresenterProtocol {
    func viewWillAppear()
    func getImageFromServer()
    func isEditMode()->Bool
    func fillEditData(edit data: HistoryCellData)
    func returnToHistory()
}

//MARK: - NewHistoryDataInteractor API
protocol NewHistoryDataInteractorApi: InteractorProtocol {
    func deleteData(document id: String)
    func storeData(type: String, price: Double, milage: Int, date: String, costDescription: String, image: Data?)
    func updateData(document id: String, type: String, price: Double, milage: Int, date: String, costDescription: String, image: Data?)
    func fetchImage(form documentID: String) -> Observable<UIImage>
}
