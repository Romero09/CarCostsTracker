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
    
}

struct HistoryCellData{
    let costType: CostType
    let costImage: UIImage
    let editImage: UIImage
    let costDate: String
    let mileage: String
    let description: String
}

enum CostType{
    case fuel
    case repair
    case other

}

