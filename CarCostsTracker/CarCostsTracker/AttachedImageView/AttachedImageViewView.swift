//
//  AttachedImageViewView.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 11/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: AttachedImageViewView Class
final class AttachedImageViewView: UserInterface {
    @IBOutlet weak var attchedImageView: UIImageView!
    private let shareImageButton = UIBarButtonItem(image: UIImage(named: "share_icon.png"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
    let bag = DisposeBag()
}

//MARK: - AttachedImageViewView API
extension AttachedImageViewView: AttachedImageViewViewApi {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setRightBarButton(self.shareImageButton, animated: true)
    }
    
    var shareImage: ControlEvent<Void> {
        return shareImageButton.rx.tap
    }
    
    var disposeBag: DisposeBag {
        return bag
    }
    
    func presentActivity(activity: UIViewController){
        present(activity, animated: true, completion: nil)
    }

}

// MARK: - AttachedImageViewView Viper Components API
private extension AttachedImageViewView {
    var presenter: AttachedImageViewPresenterApi {
        return _presenter as! AttachedImageViewPresenterApi
    }
    var displayData: AttachedImageViewDisplayData {
        return _displayData as! AttachedImageViewDisplayData
    }
}
