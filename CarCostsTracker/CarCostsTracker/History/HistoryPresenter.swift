//
//  HistoryPresenter.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import RxCocoa

// MARK: - HistoryPresenter Class
final class HistoryPresenter: Presenter {
    
    override func viewHasLoaded(){
        view.setData(drivableData: interactor.fetchHistoryData().map{ $0.map { HistoryCellData(with: $0) } })
        bindActions()
    }
}

// MARK: - HistoryPresenter API
extension HistoryPresenter: HistoryPresenterApi {
    private func bindActions() {
        view.selectedCell
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                (data) in
            self.router.showNewHistoryData(edit: data)
        }).disposed(by: view.disposeBag)
        
        view.createNewEntry
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                () in
                self.router.showNewHistoryData()
            }).disposed(by: view.disposeBag)
    }
}

// MARK: - History Viper Components
private extension HistoryPresenter {
    var view: HistoryViewApi {
        return _view as! HistoryViewApi
    }
    var interactor: HistoryInteractorApi {
        return _interactor as! HistoryInteractorApi
    }
    var router: HistoryRouterApi {
        return _router as! HistoryRouterApi
    }
}
