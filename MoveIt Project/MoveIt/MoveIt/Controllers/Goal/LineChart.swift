//
//  LineChart.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/6/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import Charts

class LineChart: UIView {
    var goalDataEntries: [GoalDataEntry]? {
        didSet {
            chartView.data = generateData()
            chartView.xAxis.setLabelCount(goalDataEntries?.count ?? 5, force: true)
        }
    }
    
    let chartView: LineChartView = {
        let cv = LineChartView()
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        chartView.backgroundColor = .cloudWhite
        setupChartUI()
        addSubview(chartView)
        chartView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
    }
    
    func generateData() -> LineChartData {
        var entries = [ChartDataEntry]()
        goalDataEntries?.forEach({ (goalDataEntry) in
            let entry = ChartDataEntry(goalDataEntry: goalDataEntry)
            entries.append(entry)
        })
        let dataSet = LineChartDataSet(values: entries, label: "goal")
        setupDataSetUI(dataSet: dataSet)
        let data = LineChartData(dataSet: dataSet)
        return data
    }
    
    fileprivate func setupDataSetUI(dataSet: LineChartDataSet) {
        dataSet.circleColors = [.emeraldGreen]
        dataSet.circleRadius = 4
        dataSet.circleHoleRadius = 2
        dataSet.circleHoleColor = .lightGray
        dataSet.fill = Fill.fillWithColor(.emeraldGreen)
        dataSet.drawFilledEnabled = true
    }
    
    fileprivate func setupChartUI() {
        chartView.noDataText = "NO DATA..."
        chartView.noDataTextColor = .black
        chartView.noDataFont = UIFont.boldSystemFont(ofSize: 20)
        chartView.legend.enabled = false
        setupXAxis()
        setupYAxis()
    }
    
    fileprivate func setupXAxis() {
        let axis = chartView.xAxis
        axis.axisLineColor = .darkGray
        axis.axisLineWidth = 1
        axis.gridColor = .lightGray
        axis.drawGridLinesEnabled = true
        axis.gridLineCap = .round
        axis.gridLineWidth = 0.5
        setupXLabelFormat(axis: axis)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let axisFormatter = XAxisDateFormatter(dateFormatter: dateFormatter)
        axis.valueFormatter = axisFormatter
    }
    
    fileprivate func setupXLabelFormat(axis: XAxis) {
        axis.labelFont = UIFont.boldSystemFont(ofSize: 8)
        axis.labelPosition = .bottom
        axis.labelRotationAngle = -45
    }
    
    fileprivate func setupYAxis() {
        chartView.rightAxis.enabled = false
        let axis = chartView.leftAxis
        axis.enabled = true
        axis.axisLineColor = .darkGray
        axis.axisLineWidth = 1
        axis.gridColor = .lightGray
        axis.drawGridLinesEnabled = true
        axis.gridLineCap = .round
        axis.gridLineWidth = 0.5
        axis.granularity = 0.5
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1
        let axisFormatter = YAxisFormatter(numberFormatter: numberFormatter)
        axis.valueFormatter = axisFormatter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XAxisDateFormatter: NSObject, IAxisValueFormatter {
    var dateFormatter: DateFormatter?
    
    convenience init(dateFormatter: DateFormatter) {
        self.init()
        self.dateFormatter = dateFormatter
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = self.dateFormatter else { return "" }
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}

class YAxisFormatter: NSObject, IAxisValueFormatter {
    var numberFormatter: NumberFormatter?

    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let numberFormatter = self.numberFormatter else {
            return ""
        }
        return numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }

}
