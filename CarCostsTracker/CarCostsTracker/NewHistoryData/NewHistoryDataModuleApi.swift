//
//  NewHistoryDataModuleApi.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit

//MARK: - NewHistoryDataRouter API
protocol NewHistoryDataRouterApi: RouterProtocol {
    func showNewHistoryData(from view: UserInterface)
    func showNewHistoryDataEdit(from view: UserInterface, edit data: HistoryCellData)
    func showHistory()
}

//MARK: - NewHistoryDataView API
protocol NewHistoryDataViewApi: UserInterfaceProtocol {
    var getSelectedDate: Date? {get}
    var costTypeButton: UIButton! {get}
    var costPriceTextField: UITextField! {get}
    var milageTextField: UITextField! {get}
    var dateTextField: UITextField! {get set}
    var costDescriptionTextView: UITextView! {get}
}

//MARK: - NewHistoryDataPresenter API
protocol NewHistoryDataPresenterApi: PresenterProtocol {
    func updateEditView()
    func isEditMode()->Bool
    func submitData()
    func fillEditData(edit data: HistoryCellData)
    func performDataDelete()
    func returnToHistory()
}

//MARK: - NewHistoryDataInteractor API
protocol NewHistoryDataInteractorApi: InteractorProtocol {
    func deleteData(document id: String)
    func storeData(type: String, price: Double, milage: Int, date: String, costDescription: String)
    func updateData(document id: String, type: String, price: Double, milage: Int, date: String, costDescription: String)
}
