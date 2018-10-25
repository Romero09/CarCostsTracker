//
//  HistoryPresenter.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - HistoryPresenter Class
final class HistoryPresenter: Presenter {
    
    var historyArray: Array<HistoryCellData> = []
    var historyDataModel: Array<HistoryDataModel> = []
    
    override func viewIsAboutToAppear() {
        historyArray = []
        view.reloadData()
    }
}

// MARK: - HistoryPresenter API
extension HistoryPresenter: HistoryPresenterApi {
    
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
    
    
    func switchToCharts() {
        router.showCharts(data: historyDataModel)
    }
    
    
    func performLogOut() {
        if sharedUserAuth.authorizedUser?.currentUser != nil{
            sharedUserAuth.authorizedUser = nil
        }
        
        router.showLogIn()
    }
    
    func transferData(history data: Array<HistoryDataModel>) {
        
        historyDataModel = data
        historyArray = []
        
        for history in data {
            let costsDescription = history.costsDescription
            let costsPrice = String(format:"%.2f$", history.costsPrice)
            let costsType = history.costsType
            var costsTypeEnum: CostType = CostType.other
            
            switch costsType {
            case "Fuel":
                costsTypeEnum = CostType.fuel
            case "Repair":
                costsTypeEnum = CostType.repair
            case "Other":
                costsTypeEnum = CostType.other
            default:
                print("Error no such costs")
            }
            let date = history.date
            let documentID = history.documentID
            let milage = String(history.milage)+"km"
        
            let historyCellData = HistoryCellData(costType: costsTypeEnum, costDate: date, mileage: milage, description: costsDescription, price: costsPrice, documentID: documentID)
        
            self.historyArray.append(historyCellData)
        }
        view.reloadData()
    }
    
    func historyCellSelected(cell data: HistoryCellData){
        router.showNewHistoryData(edit: data)
    }
    
    func getData(){
        interactor.fetchFromDB()
    }
    
    func switchToNewHistoryData(){
        router.showNewHistoryData()
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
