//
//  ChartsView.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 09/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit
import Charts

//MARK: ChartsView Class
final class ChartsView: UserInterface {
    
    @IBOutlet weak var barChartView: BarChartView!
    
}

//MARK: - ChartsView API
extension ChartsView: ChartsViewApi {
    
    override func viewDidLoad() {
        self.title = "Charts"
    }
    
}

// MARK: - ChartsView Viper Components API
private extension ChartsView {
    var presenter: ChartsPresenterApi {
        return _presenter as! ChartsPresenterApi
    }
    var displayData: ChartsDisplayData {
        return _displayData as! ChartsDisplayData
    }
}
