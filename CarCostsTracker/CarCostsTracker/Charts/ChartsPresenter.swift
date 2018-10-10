//
//  ChartsPresenter.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 09/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import Foundation
import Viperit
import Charts

// MARK: - ChartsPresenter Class
final class ChartsPresenter: Presenter {
    var chartsData: Array<HistoryDataModel> = []
    
    override func viewIsAboutToAppear() {
        barChartUpdate()
    }
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        formatter.zeroSymbol = ""
        
        return formatter
    }()

}

// MARK: - ChartsPresenter API
extension ChartsPresenter: ChartsPresenterApi {
    
    
    func store(data array: Array<HistoryDataModel>) {
        chartsData = array
    }
    
    func getMonthNumber(date timeStamp: String) -> Int {
        let timeStamp = TimeInterval(timeStamp)
        let newDate = Date(timeIntervalSince1970: timeStamp!)
        let calendar = Calendar.current
        return calendar.component(.month, from: newDate)
    }
    
    func barChartUpdate(){
        barChartSetUp()
        let chartDataArray = getDataForChart(data: chartsData)
        
        let yVals = (0..<chartDataArray.count).map { (i) -> BarChartDataEntry in
            
            let fuelValue = Double(chartDataArray[i].fuel)
            let repairValue = Double(chartDataArray[i].repair)
            let otherValue = Double(chartDataArray[i].other)
            
            return BarChartDataEntry(x: Double(chartDataArray[i].month)+0.5, yValues: [fuelValue, repairValue, otherValue])
        }
        
        let set = BarChartDataSet(values: yVals, label: "Expenses statistics per month")
        set.colors = [ChartColorTemplates.material()[0], ChartColorTemplates.material()[1], ChartColorTemplates.material()[2]]
        set.stackLabels = ["Fuel", "Repair", "Other"]
        set.valueFormatter = ChartValueFormatter(numberFormatter: formatter)
        set.valueFont = .systemFont(ofSize: 12, weight: .bold)
        let data = BarChartData(dataSet: set)
        
        view.barChartView.fitBars = true
        view.barChartView.data = data
    }
    
    func getDataForChart(data historyList: [HistoryDataModel]) -> [ChartData] {
        var chartDataArray: [ChartData] = []
        var chartData = ChartData()
        
        for i in 0 ..< historyList.count{
            
            let currentExpensesMonth = getMonthNumber(date: historyList[i].date)
            let currentExpensesTypes = historyList[i].costsType
            let currentExpensesPrice = historyList[i].costsPrice
            let currentExpensesTimeStamp = historyList[i].date
            
            if chartData.month == 0 {
                switch currentExpensesTypes{
                case CostType.fuel.name(): chartData.fuel += currentExpensesPrice
                case CostType.repair.name(): chartData.repair += currentExpensesPrice
                case CostType.other.name(): chartData.other += currentExpensesPrice
                default:
                    break
                }
                chartData.month = currentExpensesMonth
                chartData.timeStamp = currentExpensesTimeStamp
            }
            
            if i == historyList.count-1 {
                chartDataArray.append(chartData)
                chartData = ChartData()
                break
            }
            
            let nextExpensesMonth = getMonthNumber(date: historyList[i+1].date)
            let nextExpensesTypes = historyList[i+1].costsType
            let nextExpensesPrice = historyList[i+1].costsPrice
            
            if currentExpensesMonth == nextExpensesMonth {
                switch nextExpensesTypes{
                case CostType.fuel.name(): chartData.fuel += nextExpensesPrice
                case CostType.repair.name(): chartData.repair += nextExpensesPrice
                case CostType.other.name(): chartData.other += nextExpensesPrice
                default:
                    break
                }
            } else {
                chartDataArray.append(chartData)
                chartData = ChartData()
            }
        }
        return chartDataArray
    }
    
    func barChartSetUp(){
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        view.barChartView.chartDescription?.enabled = false
        
        view.barChartView.maxVisibleCount = 40
        view.barChartView.drawBarShadowEnabled = false
        view.barChartView.drawValueAboveBarEnabled = false
        view.barChartView.highlightFullBarEnabled = false
        
        let xAxis = view.barChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        xAxis.labelPosition = .top
        xAxis.labelFont = .systemFont(ofSize: 16, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 1
        
        let l = view.barChartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 4
        l.xEntrySpace = 6
        l.font = .systemFont(ofSize: 12, weight: .light)
    }
    
}

// MARK: - Charts Viper Components
private extension ChartsPresenter {
    var view: ChartsViewApi {
        return _view as! ChartsViewApi
    }
    var interactor: ChartsInteractorApi {
        return _interactor as! ChartsInteractorApi
    }
    var router: ChartsRouterApi {
        return _router as! ChartsRouterApi
    }
}

class ChartValueFormatter: NSObject, IValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?
    
    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        return numberFormatter.string(for: value)!
    }
}


struct ChartData{
    var timeStamp = ""
    var month: Int = 0
    var repair: Double = 0.0
    var fuel: Double = 0.0
    var other: Double = 0.0
}
