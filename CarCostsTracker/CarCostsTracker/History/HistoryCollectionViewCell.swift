//
//  HistoryCollectionViewCell.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 02/10/2018.
//  Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var costsLogo: UIImageView!
    @IBOutlet weak var costsType: UILabel!
    @IBOutlet weak var milage: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detailedDescription: UILabel!
    
    
    func fillCellData(historyData: HistoryCellData){
        
        costsLogo.image = historyData.costImage
        costsType.text = historyData.costType
        milage.text = historyData.mileage
        date.text = historyData.costDate
        detailedDescription.text = historyData.description
        
    }
}
