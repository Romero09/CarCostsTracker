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
    let costType: String
    let costImage: UIImage
    let editImage: UIImage
    let costDate: String
    let mileage: String
    let description: String
}

enum Costs{
    case fuel
    case repair
    case other
    
    func costsName() -> String {
        switch self {
        case .fuel:
            return "Repair"
        case .repair:
            return "Repair"
        case .other:
            return "Other"
        }
    }
    
    func costsPicture() -> UIImage {
        switch self {
        case .fuel:
            return UIImage(named: "fuel_icon")!
        case .repair:
            return UIImage(named: "repair_icon")!
        case .other:
            return UIImage(named: "other_icon")!
        }
    }
}

