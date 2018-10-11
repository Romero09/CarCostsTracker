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
    
//    override func setupView(data: Any) {
//        guard let data = data as? HistoryDataModel {
//            
//        }
//    }
    
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
            
            return BarChartDataEntry(x: Double(chartDataArray[i].month)-0.5, yValues: [fuelValue, repairValue, otherValue])
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
    
    func toChartData(history data:HistoryDataModel) -> ChartData{
        var chartData = ChartData()
        chartData.month = getMonthNumber(date: data.date)
        chartData.timeStamp = data.date
        
        switch data.costsType{
        case CostType.fuel.name(): chartData.fuel += data.costsPrice
        case CostType.repair.name(): chartData.repair += data.costsPrice
        case CostType.other.name(): chartData.other += data.costsPrice
        default:
            break
        }
        return chartData
    }
    
    
    func getDataForChart(data historyList: [HistoryDataModel]) -> [ChartData] {

        let newChartData = historyList.map { toChartData(history: $0) }
            .reduce([], { (result, model: ChartData) -> [ChartData] in
                if let monthIndex = result.monthAtIndex(data: model) {
                    var existingEntry = result
                    existingEntry[monthIndex].other += model.other
                    existingEntry[monthIndex].fuel += model.fuel
                    existingEntry[monthIndex].repair += model.repair
                    
                    return existingEntry
                }
                var newEntry = result
                newEntry.append(model)
                return newEntry
            })
        return newChartData
    }
    
    
    func barChartSetUp(){
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        view.barChartView.chartDescription?.enabled = false
        
        view.barChartView.maxVisibleCount = 12
        view.barChartView.setVisibleXRangeMinimum(Double(12))
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
        xAxis.axisMinLabels = months.count
        xAxis.axisRange = Double(months.count)
        xAxis.labelCount = months.count
        
        let legend = view.barChartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.form = .square
        legend.formToTextSpace = 4
        legend.xEntrySpace = 6
        legend.font = .systemFont(ofSize: 12, weight: .light)
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

extension Array where Element == ChartData {
    func monthAtIndex(data: ChartData) -> Int?{
            return self.firstIndex(where: { (result: ChartData) -> Bool in
                result.month == data.month
            })
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


