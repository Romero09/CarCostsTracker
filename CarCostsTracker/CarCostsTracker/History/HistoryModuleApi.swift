//
//  HistoryModuleApi.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit
import RxCocoa
import RxSwift

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
    var disposeBag: DisposeBag { get }
    var selectedCell: ControlEvent<HistoryCellData> { get }
    var createNewEntry: ControlEvent<Void> { get }
    func setData(drivableData: Observable<[HistoryCellData]>)
}

//MARK: - HistoryPresenter API
protocol HistoryPresenterApi: PresenterProtocol {
}

//MARK: - HistoryInteractor API
protocol HistoryInteractorApi: InteractorProtocol {
    func fetchHistoryData() -> Observable<[HistoryDataModel]>
}
