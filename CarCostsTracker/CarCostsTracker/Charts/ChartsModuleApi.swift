//
//  ChartsModuleApi.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 09/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit
import Charts

//MARK: - ChartsRouter API
protocol ChartsRouterApi: RouterProtocol {
    func showCharts(from view: UserInterface, data array: Array<HistoryDataModel>)
}

//MARK: - ChartsView API
protocol ChartsViewApi: UserInterfaceProtocol {
    var barChartView: BarChartView! {get set}
}

//MARK: - ChartsPresenter API
protocol ChartsPresenterApi: PresenterProtocol {
    func store(data: Array<HistoryDataModel>)
}

//MARK: - ChartsInteractor API
protocol ChartsInteractorApi: InteractorProtocol {
}
