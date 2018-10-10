//
//  HistoryCollectionViewCell.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 02/10/2018.
//  Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit

//protocol HistoryCellDelegate {
//    func selectedCell(post: Posts)
//}

class HistoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var costsLogo: UIImageView!
    @IBOutlet weak var costsType: UILabel!
    @IBOutlet weak var milage: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detailedDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    func fillCellData(historyData: HistoryCellData){
        costsLogo.image = historyData.costType.image()
        costsType.text = historyData.costType.name()
        milage.text = historyData.mileage
        let timeStamp = TimeInterval(historyData.costDate)
        let newDate = Date(timeIntervalSince1970: timeStamp!)
        date.text = DateFormatter.localizedString(from: newDate, dateStyle: .short, timeStyle: .short)
        price.text = historyData.price
        
    }
}

extension CostType {
    func name() -> String {
        switch self {
        case .fuel:
            return "Fuel"
        case .repair:
            return "Repair"
        case .other:
            return "Other"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .fuel:
            return UIImage(imageLiteralResourceName: "fuel_icon")		
        case .repair:
            return UIImage(imageLiteralResourceName: "repair_icon")
        case .other:
            return UIImage(imageLiteralResourceName: "other_icon")
        }
    }

}
