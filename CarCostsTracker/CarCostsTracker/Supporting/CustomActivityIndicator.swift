//
//  CustomActivityIndicator.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 12/10/2018.
//  Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import UIKit


class CustomActivityIndicator: UIView{
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    init(){
        let frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.addSubview(actInd)

        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.hidesWhenStopped = true
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: self.frame.size.width / 2,
                                y: self.frame.size.height / 2);
        actInd.startAnimating()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


