//
//  HistoryModuleApi.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit

//MARK: - HistoryRouter API
protocol HistoryRouterApi: RouterProtocol {
    func showCharts(data array: Array<HistoryDataModel>)
    func showLogIn()
    func showHistory(from view: UserInterface)
    func showNewHistoryData()
    func showNewHistoryData(edit data: HistoryCellData)
}

//MARK: - HistoryView API
protocol HistoryViewApi: UserInterfaceProtocol {
    func reloadData()
}

//MARK: - HistoryPresenter API
protocol HistoryPresenterApi: PresenterProtocol {
    func showActivityIndicator(uiView: UIView)
    func dismissActivityIndicator(uiView: UIView)
    var historyArray: Array<HistoryCellData> {get}
    func performLogOut()
    func getData()
    func switchToNewHistoryData()
    func transferData(history data: Array<HistoryDataModel>)
    func historyCellSelected(cell data: HistoryCellData)
    func switchToCharts()
}

//MARK: - HistoryInteractor API
protocol HistoryInteractorApi: InteractorProtocol {
    func fetchFromDB()
}
