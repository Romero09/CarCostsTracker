//
//  NewHistoryDataModuleApi.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Viperit
import RxCocoa
import RxSwift

//MARK: - NewHistoryDataRouter API
protocol NewHistoryDataRouterApi: RouterProtocol {
    func showNewHistoryData(from view: UserInterface)
    func showNewHistoryDataEdit(from view: UserInterface, edit data: HistoryCellData)
    func showHistory()
    func showAttachedImageView(image data: UIImage)
    func showImagePicker(picker: UIImagePickerController, image: Observable<UIImage>)
}

//MARK: - NewHistoryDataView API
protocol NewHistoryDataViewApi: UserInterfaceProtocol {
    var selectCostTypeMenu: ControlEvent<Void> { get }
    var submitResults: ControlEvent<Void> { get }
    var deleteEntry: ControlEvent<Void> { get }
    var attachImage: ControlEvent<Void> { get }
    var imgaeTapAction: ControlEvent<UITapGestureRecognizer> { get }
    var disposeBag: DisposeBag { get }
    var getPreviewImageView: UIImageView { get }
    
    var selectedCostType: Observable<String> { get }
    var costPrice: Observable<String> { get }
    var milage: Observable<String> { get }
    var costDescription: Observable<String> { get }
    var datePickerResult: Observable<Date> { get }
    
    func bind(datasources: NewHistoryDataView.Datasource)
    func updateDateTextLabel(where date: Observable<String>)
    func startActivityIndicator()
    func stopActivityIndicator()
    func stopPreviewActivityIndicator()
    func displayAction(action view: UIViewController)
    func updateCostTypeButtonLabel(costType text: String)
    func displayNoImageFound()
    func displayImagePreview()
    
}

//MARK: - NewHistoryDataPresenter API
protocol NewHistoryDataPresenterApi: PresenterProtocol {
    func getImageFromServer()
    func isEditMode()->Bool
    func returnToHistory()
    func viewDidLoad()
    var disposeBag: DisposeBag { get } //DisposeBag from view
}

//MARK: - NewHistoryDataInteractor API
protocol NewHistoryDataInteractorApi: InteractorProtocol {
    func deleteData(document id: String)
    func storeData(where result: NewHistoryDataPresenter.Result)
    func updateData(where result: NewHistoryDataPresenter.Result)
    func fetchImage(from documentID: String) -> Observable<UIImage>
    func fetchThumbNailImage(from documentID: String?) -> Observable<UIImage>
}
