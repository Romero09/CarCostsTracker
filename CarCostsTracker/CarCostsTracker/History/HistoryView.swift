//
//  HistoryView.swift
//  CarCostsTracker
//
//  Created by Karshigabekov, Ilyas on 01/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit
import Firebase
import RxSwift
import RxCocoa

//MARK: HistoryView Class
final class HistoryView: UserInterface {
    
    @IBOutlet private var costTable: UICollectionView!
    
    @IBOutlet private var chartsButton: UIButton!
    
    private var activityIndicator = CustomActivityIndicator()
    
    private let bag = DisposeBag()
    
    private let addItemButton = UIBarButtonItem(image: UIImage(named: "add_item.png"), style: .done, target: nil, action: nil)
    
    private let logOutButton = UIBarButtonItem(title: "Log out", style: .plain, target: nil, action: nil)
    
}

//MARK: - HistoryView API
extension HistoryView: HistoryViewApi {
    
    func startActivityIndicator() {
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.view.isUserInteractionEnabled = false
    }
    
    func stopActivityIndicator() {
        activityIndicator.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
        
    }
    
    //Disposebag of this view, bag will be disposed when view will be cleared from memory
    var disposeBag: DisposeBag {
        return bag
    }
    
    //Control events on which we can subscribe and use as observable on click events.
    var selectedCell: ControlEvent<HistoryCellData> {
        return costTable.rx.modelSelected(HistoryCellData.self)
    }
    
    var createNewEntry: ControlEvent<Void> {
        return addItemButton.rx.tap
    }
    
    var performLogOut: ControlEvent<Void>{
        return logOutButton.rx.tap
    }
    
    var showCharts: ControlEvent<Void> {
        return chartsButton.rx.tap
    }
    
    var costTableView: UICollectionView {
        return costTable
    }
    
    //Setting data to a view cell, reciving Observable<[HistoryCellData]
    func setData(drivableData: Observable<[HistoryCellData]>) {
        drivableData.asDriver(onErrorJustReturn: [])
            //.debug("Data driver") // used for debug purpose
            //.drive is same as subscrive bud for drivers that works with UI. Read doc for detailed info about rx.items
            .drive(costTable.rx.items(cellIdentifier: "historyCell", cellType: HistoryCollectionViewCell.self)) {
                (number, data: HistoryCellData, cell) in
                cell.fill(with: data)
            }.disposed(by: bag)
    }
}

//MARK: View LifeCycle
extension HistoryView {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Sets default orientagion for this view to portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpChartsButton()
        setUpNavigationBar()
        setUpTableInsets(to: self.view.frame.size)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setUpTableInsets(to: size)
    }
    
}

//MARK: View design
extension HistoryView {
    
    func setUpTableInsets(to frame: CGSize){
        
        let frameWidth = frame.width
        let collectionViewWidth = (self.costTable.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        var insets: CGFloat = (frameWidth - (collectionViewWidth)) * 0.5
        
        while (insets * 2) > collectionViewWidth {
            insets -= collectionViewWidth * 0.5
        }
        if insets <= 0 {
            insets = 0
        }
        for constraint in costTable.superview!.constraints {
            if constraint.firstAttribute == .trailing {
                constraint.constant = insets
            }
            if constraint.firstAttribute == .leading {
                constraint.constant = insets
            }
        }
        updateViewConstraints()
    }
    
    func setUpChartsButton(){
        chartsButton.layer.cornerRadius = chartsButton.frame.width/2
        chartsButton.layer.borderWidth = 2.0
        chartsButton.layer.borderColor = self.view.tintColor.cgColor
        chartsButton.backgroundColor = UIColor.white
    }
    
    func setUpNavigationBar(){
        self.title = "History"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.setRightBarButton(addItemButton, animated: true)
        self.navigationItem.setLeftBarButton(logOutButton, animated: true)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
    }
    
    
    var tapedCell: ControlEvent<IndexPath>{
        return costTable.rx.itemSelected
    }
    
    
    var highlightedCell: ControlEvent<IndexPath>{
        return costTable.rx.itemHighlighted
    }
    
    var unhighlightedCell: ControlEvent<IndexPath>{
        return costTable.rx.itemUnhighlighted
    }
    
    var costTableCellWillApear: ControlEvent<(cell:UICollectionViewCell, at:IndexPath)>{
        return costTable.rx.willDisplayCell
    }
    
    var costTableDidScroll: ControlEvent<Void>{
        return costTable.rx.didScroll
    }
    
    var costTableBeginDragging: ControlEvent<Void>{
        return costTable.rx.willBeginDragging
    }
    
    
    var costTableEndDragging: ControlEvent<Bool>{
        return costTable.rx.didEndDragging
    }
    
}


//MARK: - Animations
extension HistoryView{
    
    func animateSelectedCell(for cell: UICollectionViewCell, dismissAnimation: Bool){
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            cell.layer.cornerRadius = 12
        }, completion: { _ in
            if dismissAnimation {
                self.animateDeselectedCell(for: cell)
            }
        })
    }
    
    func animateDeselectedCell(for cell: UICollectionViewCell){
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            cell.backgroundColor = nil
            cell.layer.cornerRadius = 0
        })
    }
    
    func animateCollection(toAppear cell: UICollectionViewCell, index at: IndexPath, cellDelay: Int, didMoveUp: Bool){
        
        let tableViewHeight = self.costTable.frame.height
        
        if didMoveUp {
            cell.transform = CGAffineTransform(translationX: 0, y: -tableViewHeight)
        } else {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        UIView.animate(withDuration: 0.75, delay: Double(cellDelay) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    func addPulseAnimation() -> Observable<Bool>{
        let pulse = Pulsing(numberOfPulses: 1, componentRadius: chartsButton.layer.cornerRadius, radius: chartsButton.layer.cornerRadius+20, position: chartsButton.center, duration: 0.5)
        pulse.backgroundColor = self.view.tintColor.cgColor
        
        self.view.layer.insertSublayer(pulse, below: self.chartsButton.layer)
        
        return pulse.isCompleted
    }
    
}

// MARK: - HistoryView Viper Components API
private extension HistoryView {
    var presenter: HistoryPresenterApi {
        return _presenter as! HistoryPresenterApi
    }
    var displayData: HistoryDisplayData {
        return _displayData as! HistoryDisplayData
    }
}
