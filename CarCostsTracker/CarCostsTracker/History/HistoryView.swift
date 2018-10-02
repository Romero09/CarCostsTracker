//
//  HistoryView.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit

//MARK: HistoryView Class
final class HistoryView: UserInterface {
    @IBOutlet weak var costTable: UICollectionView!
}

//MARK: - HistoryView API
extension HistoryView: HistoryViewApi, UICollectionViewDelegate {
    
    override func viewDidLoad() {
        costTable.delegate = self
        super.viewDidLoad()
    }
}

extension HistoryView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hisotryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath)
        
        return hisotryCell
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
