//
//  HistoryDisplayData.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit

// MARK: - HistoryDisplayData class
final class HistoryDisplayData: DisplayData {
    
    let data = 1
    
}

struct HistoryCellData{
    let costType: CostType
    let costDate: String
    let mileage: String
    let description: String
    let price: String
    let documentID: String
    
    init(with history: HistoryDataModel) {
        description = history.costsDescription
        price = String(format:"%.2f$", history.costsPrice)
        costType = CostType(raw: history.costsType)
        costDate = history.date
        documentID = history.documentID
        mileage = String(history.mileage)+"km"
    }
}

enum CostType{
    case fuel
    case repair
    case other
    
    init(raw: String) {
        switch raw {
        case "Fuel":
            self = .fuel
        case "Repair":
            self = .repair
        default:
            self = .other
        }

    }
}

