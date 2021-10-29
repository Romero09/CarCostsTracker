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
    
    private var isChartsOpened = false
    private var cellDelayCount = 0
    private var didMoveUp = false
    private var lastPoint: CGFloat = 0.0
    private var lastVelocity: CGFloat = 0.0
    private var isScrollByPointTracking = true
    
    //1.Creating observable as global value so it can be subscribed from anywhere.
    //So when we call historyData we will recive stream from historyDataPublisher asObservable
    var historyData: Observable<[HistoryDataModel]> {
        return historyDataPublisher
            .asObservable()
            //this func. allows us to recive one last event on subscriving to this observable
            .share(replay: 1)
    }
    //2.To do that we are using PublishSubject, so our observable is not nil.
    private let historyDataPublisher = PublishSubject<[HistoryDataModel]>()
    
    override func viewIsAboutToAppear() {
        isChartsOpened = false
    }
    
    override func viewHasLoaded(){
        
        view.startActivityIndicator()
        historyData.subscribe(onNext: { (element) in
            self.view.stopActivityIndicator()
        }, onError: { (Error) in
            print(Error)
        }).disposed(by: view.disposeBag)
        
        interactor.fetchHistoryData()
            //3. we binds data from interactor which comes as Observable to our historyDataPublisher
            .bind(to: historyDataPublisher)
            .disposed(by: view.disposeBag)
        
        view.setData(drivableData: historyData.map{ $0.map { HistoryCellData(with: $0) } })
        bindActions()
        
    }
}

// MARK: - HistoryPresenter API
extension HistoryPresenter: HistoryPresenterApi {
    
    //Action listeners on button that presented in view.
    private func bindActions() {
        view.selectedCell
            //Converting to observable, possible only with types that confirms it as: ControlEvent, ControlProperty, Variable, Driver
            .asObservable()
            //Setting observerOn Main thread duea to a work with interface
            .observeOn(MainScheduler.asyncInstance)
            //subscribing and handling events.
            .subscribe(onNext: { [unowned self]
                (data) in
                self.router.showNewHistoryData(edit: data)
                //putting a dispose bag
            }).disposed(by: view.disposeBag)
        
        view.createNewEntry
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                self.router.showNewHistoryData()
            }).disposed(by: view.disposeBag)
        
        view.performLogOut
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self]
                _ in
                sharedUserAuth.authorizedUser = nil
                self.router.showLogIn()
            }).disposed(by: view.disposeBag)
        
        //Combining two observebles. Combine is possible only when both have recived events. This calls when view.chowCharts observabel rescives an event from button click.
        //Returning latest loaded data from historyData Observable
        let combinedHistoryOnClick = Observable.combineLatest(view.showCharts, historyData) { (_, data: [HistoryDataModel]) -> [HistoryDataModel] in
            return data
        }
        //Subscribing on combined observable, on event calls router giving to him recived history data.
        combinedHistoryOnClick.subscribe(onNext: {
            (history) in
            self.view.addPulseAnimation().subscribe(onNext: { (succes) in
                if !self.isChartsOpened{
                    self.isChartsOpened = succes
                    self.router.showCharts(data: history)
                }
            }).disposed(by: self.view.disposeBag)
        }).disposed(by: view.disposeBag)
        
        view.costTableCellWillApear
            .asObservable()
            .subscribe(onNext: { (cell, at) in
                self.view.animateCollection(toAppear: cell as! HistoryCollectionViewCell, index: at, cellDelay: self.cellDelayCount, didMoveUp: self.didMoveUp)
                self.cellDelayCount += 1
            }).disposed(by: view.disposeBag)
        
        view.costTableDidScroll.asDriver()
            .asObservable()
            .subscribe(onNext: { _ in
                self.cellDelayCount = 0
                self.scrollViewMoveDirection()
            }).disposed(by: view.disposeBag)
        
        view.costTableBeginDragging
            .asObservable()
            .subscribe(onNext: { _ in
                self.isScrollByPointTracking = true
                self.lastPoint = 0
            }).disposed(by: view.disposeBag)
        
        view.costTableEndDragging
            .asObservable()
            .subscribe(onNext: { _ in
                self.isScrollByPointTracking = false
            }).disposed(by: view.disposeBag)
        
        view.tapedCell
            .asObservable()
            .subscribe(onNext: { (index) in
                if let cell = self.view.costTableView.cellForItem(at: index){
                    self.view.animateSelectedCell(for: cell, dismissAnimation: true)
                }
            }).disposed(by: view.disposeBag)
        
        view.highlightedCell
            .asDriver()
            .drive(onNext: { (index) in
                if let cell = self.view.costTableView.cellForItem(at: index){
                    self.view.animateSelectedCell(for: cell, dismissAnimation: false)
                }
            }).disposed(by: view.disposeBag)
        
        view.unhighlightedCell.asObservable().subscribe(onNext: { (index) in
            if let cell = self.view.costTableView.cellForItem(at: index){
                self.view.animateDeselectedCell(for: cell)
            }
        }).disposed(by: view.disposeBag)
        
    }
}

//MARK: - View scroll direction recognizer
extension HistoryPresenter {
    
    func scrollViewMoveDirection(){
        let newPoint = self.view.costTableView.panGestureRecognizer.translation(in: self.view.costTableView.superview).y
        if self.isScrollByPointTracking {
            if(newPoint > self.lastPoint)
            {
                self.didMoveUp = true
            }
            else if ( newPoint < self.lastPoint)
            {
                self.didMoveUp = false
            }
        } else {
            if (self.lastVelocity > self.view.costTableView.contentOffset.y) {
                self.didMoveUp = true
            } else if (self.lastVelocity < self.view.costTableView.contentOffset.y) {
                self.didMoveUp = false
            }
        }
        self.lastVelocity = self.view.costTableView.contentOffset.y;
        self.lastPoint = newPoint
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
