//
//  HistoryView.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit
import Firebase
import RxSwift
import RxCocoa

//MARK: HistoryView Class
final class HistoryView: UserInterface {
    @IBOutlet private var costTable: UICollectionView!
    
    @IBOutlet private var chartsButtonOutlet: UIButton!
    
    @IBAction func chartsButton(_ sender: Any) {}

    private let bag = DisposeBag()
    
    private let addItemButton = UIBarButtonItem(image: UIImage(named: "add_item.png"), style: .done, target: nil, action: nil)
    
    private let logOutButton = UIBarButtonItem(title: "Log out", style: .plain, target: nil, action: nil)
    
}

//MARK: - HistoryView API
extension HistoryView: HistoryViewApi {
    var disposeBag: DisposeBag {
        return bag
    }
    
    var selectedCell: ControlEvent<HistoryCellData> {
        return costTable.rx.modelSelected(HistoryCellData.self)
    }
    
    var createNewEntry: ControlEvent<Void> {
        return addItemButton.rx.tap
    }
    
    var performLogOut: ControlEvent<Void>{
        return logOutButton.rx.tap
    }
    
    var showCharts: ControlEvent<Void> {
        return chartsButtonOutlet.rx.tap
    }
    
    func setData(drivableData: Observable<[HistoryCellData]>) {
        drivableData.asDriver(onErrorJustReturn: [])
            .debug("Data driver")
            .drive(costTable.rx.items(cellIdentifier: "historyCell", cellType: HistoryCollectionViewCell.self)) {
                (_, data: HistoryCellData, cell) in
                cell.fillCellData(historyData: data)
            }.disposed(by: bag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Sets default orientagion for this view to portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    override func viewDidLoad() {
        chartsButtonOutlet.layer.cornerRadius = chartsButtonOutlet.frame.width/2
        chartsButtonOutlet.layer.borderWidth = 2.0
        chartsButtonOutlet.layer.borderColor = self.view.tintColor.cgColor
        chartsButtonOutlet.backgroundColor = UIColor.white

        self.title = "History"
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        self.navigationItem.setRightBarButton(addItemButton, animated: true)
        
        self.navigationItem.setLeftBarButton(logOutButton, animated: true)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        super.viewDidLoad()
    }
    
}

// MARK: - HistoryView Viper Components API
private extension HistoryView {
    var presenter: HistoryPresenterApi {
        return _presenter as! HistoryPresenterApi
    }
    var displayData: HistoryDisplayData {
        return _displayData as! HistoryDisplayData
    }
}
