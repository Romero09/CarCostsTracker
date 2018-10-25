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

    @IBOutlet weak var detailedDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var costsLogoImageView: UIImageView!
    @IBOutlet weak var costsTypeLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    
    
    func fill(with data: HistoryCellData){
        
        costsLogoImageView.image = data.costType.image()
        costsTypeLabel.text = data.costType.name()
        mileageLabel.text = data.mileage
        let timeStamp = TimeInterval(data.costDate)
        let newDate = Date(timeIntervalSince1970: timeStamp!)
        dateLabel.text = DateFormatter.localizedString(from: newDate, dateStyle: .short, timeStyle: .short)
        price.text = data.price
        
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
