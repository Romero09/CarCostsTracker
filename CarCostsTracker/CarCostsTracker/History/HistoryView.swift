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

//MARK: HistoryView Class
final class HistoryView: UserInterface {
    @IBOutlet weak var costTable: UICollectionView!
    
    var historyArray: Array<HistoryCellData> = []
    
    
}

//MARK: - HistoryView API
extension HistoryView: HistoryViewApi {

    override func viewDidLoad() {
        self.title = "History"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(callSwitchToNewHistoryData)), animated: true)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(callLogOut)), animated: true)
        
        costTable.delegate = self
        costTable.allowsSelection = true
        super.viewDidLoad()
        presenter.getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        presenter.getData()
    }
    
    @objc func callLogOut(){
        presenter.performLogOut()
    }
    
    @objc func callSwitchToNewHistoryData(){
        presenter.switchSwitchToNewHistoryData()
    }
}

extension HistoryView: UICollectionViewDataSource, UICollectionViewDelegate{	
    
    func reloadData(){
        costTable.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.historyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hisotryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCollectionViewCell
        
        hisotryCell.fillCellData(historyData: presenter.historyArray[indexPath.row])
        hisotryCell.isSelected = true
        return hisotryCell
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let historyData = presenter.historyArray[indexPath.row]
        presenter.historyCellSelected(cell: historyData)

    
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
