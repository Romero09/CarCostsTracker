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
    
    override func viewDidLoad() {
        self.title = "Charts"
        
    }
    
    //Locks view controller only to Landscape mode by this function. Implementation in AppDelegate
    @objc func landscapeOnly() -> Void {}
    
}

//MARK: - ChartsView API
extension ChartsView: ChartsViewApi {
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Sets default orientagion for this view to landscapeRight
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParent) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        
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
