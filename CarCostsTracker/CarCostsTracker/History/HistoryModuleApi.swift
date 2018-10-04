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
    func showHistory(from view: UserInterface)
    func showNewHistoryData()
}

//MARK: - HistoryView API
protocol HistoryViewApi: UserInterfaceProtocol {
    func reloadData()
}

//MARK: - HistoryPresenter API
protocol HistoryPresenterApi: PresenterProtocol {
    var historyArray: Array<HistoryCellData> {get}
    func getData()
    func switchSwitchToNewHistoryData()
    func transferData(history data: Array<HistoryDataModel>)
}

//MARK: - HistoryInteractor API
protocol HistoryInteractorApi: InteractorProtocol {
    func fetchFromDB()
}
