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
    
    @IBOutlet weak var chartsButtonOutlet: UIButton!
    
    @IBAction func chartsButton(_ sender: Any) {
        presenter.switchToCharts()
    }
    

    
}

//MARK: - HistoryView API
extension HistoryView: HistoryViewApi {
    
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
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "add_item.png"), style: UIBarButtonItem.Style.done, target: self, action: #selector(callSwitchToNewHistoryData)), animated: true)
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(callLogOut)), animated: true)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        
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
        presenter.switchToNewHistoryData()
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
