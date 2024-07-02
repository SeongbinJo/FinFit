//
//  CustomBarChartView.swift
//  Saver
//
//  Created by 이상민 on 6/28/24.
//

import UIKit
import DGCharts

final class CustomBarChartView: BarChartView, AxisValueFormatter{
    //MARK: - property
    private let colors: [UIColor] = [.incomeAmount, .primaryBlue80, .primaryBlue60, .primaryBlue40]
    var values: [Double] = [] //데이터 y값
    var labels: [String] = [] //하단 라벨들
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupChartView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupChartView()
    }
    
    //MARK: - 그래프 기본 설정
    private func setupChartView(){
        //공통 설정
        self.noDataText = "데이터가 존재하지 않습니다" //데이터가 없을 시 Text
        self.noDataTextAlignment = .center
        self.noDataFont = UIFont.saverSubTitleSemibold //데이터가 없을 시 textFont 설정
        self.noDataTextColor = .white //데이터가 없을 시 textColor
        self.layer.cornerRadius = 10
        self.isUserInteractionEnabled = false //사용자가 해당 view는 상호작요을 못하게 한다.
        self.minOffset = 0 //내부 여백 설정
        
        let xAxis = self.xAxis //chartView에 x축
        xAxis.drawGridLinesEnabled = false //x축 격자 제거
        xAxis.drawAxisLineEnabled = false //상단 x축 라인 제거
//        xAxis.drawLabelsEnabled = false //상단 x축 라벨 표시
//        xAxis.enabled = false //x축 하단 라벨 숨기기
        xAxis.labelPosition = .bottom //x축 라벨 위치를 하단으로 설정
        xAxis.granularity = 1 //x축 라벨의 최소 간격을 1로 설정
        xAxis.labelFont = .saverBody2Semibold
        xAxis.labelTextColor = .white
        xAxis.yOffset = 8.0 //그래프와 라벨의 사이의 간격
        xAxis.axisMinimum = -0.5
        xAxis.axisMaximum = 3.5 // 4개의 막대가 있는 것처럼 설정
        xAxis.valueFormatter = self
        
        //왼쪽 Y축 설정
        let leftAxis = self.leftAxis //chartView에 Y축 설정
        leftAxis.drawGridLinesEnabled = false //왼쪽 Y축 격자 제거
        leftAxis.drawAxisLineEnabled = false //왼쪽 Y축 라인 제거
        leftAxis.drawLabelsEnabled = false //왼쪽 Y축 라벨 제거
        
        //오른쪽 Y축 설정
        let rightAxis = self.rightAxis //chartView에 Y축 설정
        rightAxis.drawGridLinesEnabled = false //오른쪽 Y축 격자 제거
        rightAxis.drawAxisLineEnabled = false //오른쪽 Y축 라인 제거
        rightAxis.drawLabelsEnabled = false //오른쪽 Y축 라벨 제거
        
        setBarData(barChartView: self, barChartDataEntries: entryData(values: values))
    }
    
    //MARK: - 그래프 생성
    func setBarData(barChartView: BarChartView, barChartDataEntries: [BarChartDataEntry]) {
        if barChartDataEntries.isEmpty {
            barChartView.data = nil
        } else {
            var topLabels = [String]()
            
            if values.count > 4 { //데이터가 4개보다 많은 경우
                topLabels = barChartDataEntries.prefix(3).map { "\(String(format: "%.1f", $0.y * 100))%" }
                topLabels.append("\(String(format: "%.1f", barChartDataEntries.last!.y * 100))%")
            } else {
                topLabels = barChartDataEntries.map { "\(String(format: "%.1f", $0.y * 100))%" }
            }
            
            let barChartDataSet = BarChartDataSet(entries: barChartDataEntries, label: "사용금액")
            barChartDataSet.colors = colors
            let barChartData = BarChartData(dataSet: barChartDataSet)
            barChartData.barWidth = 0.6
            barChartView.data = barChartData
            
            let customRenderer = CustomRoundedBarChartRenderer(dataProvider: barChartView, animator: barChartView.chartAnimator, viewPortHandler: barChartView.viewPortHandler)
            customRenderer.topLabels = topLabels
            barChartView.renderer = customRenderer
            barChartView.animate(yAxisDuration: 0.7, easingOption: .easeInOutQuint)
        }
        barChartView.notifyDataSetChanged()
        barChartView.legend.enabled = false
    }
    
    //MARK: - 그래프 좌표생성
    func entryData(values: [Double]) -> [BarChartDataEntry] {
        var barDataEntries: [BarChartDataEntry] = []
        let count = values.count
        guard count > 0 else { return barDataEntries }
        
        var condensedData = [Double]()
        
        if values.count > 4 {
            condensedData.append(contentsOf: values[0...2])
            condensedData.append(values[3...values.count-1].reduce(0.0, +))
        } else {
            condensedData = values
        }
        
        let total = condensedData.reduce(0.0, +)
        for i in 0..<condensedData.count {
            let value = condensedData[i]
            let finalValue = value / total
            barDataEntries.append(BarChartDataEntry(x: Double(i), y: finalValue))
        }

        return barDataEntries
    }
    
    //MARK: - 데이터 변화에 따른 view업데이트
    func updateDate(values: [Double], labels: [String]){
        self.values = values
        self.labels = labels
        setBarData(barChartView: self, barChartDataEntries: entryData(values: values))
    }
    
    //MARK: - 하단 Label 지정
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if labels.count > 4{
            if Int(value) < 3{
                return labels[Int(value)]
            }else{
                return "기타"
            }
        }else{
            if Int(value) < labels.count{
                return labels[Int(value)]
            }else{
                return ""
            }
        }
    }
}

//MARK: - 막대그래프에 radius, topLabel 만들기 위해 render재정의
private final class CustomRoundedBarChartRenderer: BarChartRenderer {

    var topLabels: [String] = [] //상단 Label 문자
    var minBarHeight: CGFloat = 1.0 // 최소 바 높이
    let labelOffset: CGFloat = 8.0 // 라벨과 막대 사이의 간격
    let cornerRadius: CGFloat = 8.0 // 둥근 모서리 정도

    override func drawDataSet(context: CGContext, dataSet: BarChartDataSetProtocol, index: Int) {
        
        //막대 그래프 데이터를 가져옴
        guard let barData = dataProvider?.barData else { return }
        let trans = dataProvider?.getTransformer(forAxis: dataSet.axisDependency)

        let barWidthHalf = barData.barWidth / 2.0 //막대 그래프의 너비 절반
        let contentRect = context.boundingBoxOfClipPath //그릴 영역(그래프view 영역)의 크기를 가져옴

        //각 데이터 항목에 대한 그래프를 그림
        for i in 0 ..< min(Int(ceil(CGFloat(dataSet.entryCount) * animator.phaseX)), dataSet.entryCount) {
            guard let entry = dataSet.entryForIndex(i) as? BarChartDataEntry else { continue }
            let x = entry.x
            let y = entry.y

            //막대의 좌, 우, 상, 하 위치를 계산
            let left = CGFloat(x - barWidthHalf)
            let right = CGFloat(x + barWidthHalf)
            let top = CGFloat(y > minBarHeight ? y : minBarHeight)
            let bottom = 0.0

            //막대의 사각형 영역을 정의
            var barRect = CGRect(x: left, y: bottom, width: right - left, height: top - bottom)
            trans?.rectValueToPixel(&barRect)
            
            // 상단 Label 높이를 계산하여 막대 그래프 높이 조정
            let topLabelHeight: CGFloat = {
                if i < topLabels.count {
                    let topLabel = topLabels[i]
                    //attribute로 폰트에 따른 글자 높이 구하기
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.saverBody1Regurlar
                    ]
                    return topLabel.size(withAttributes: attributes).height
                }
                return 0
            }()

            // 상단 Label 간격을 확보한 총 사용할 수 있는 높이
            let totalAvailableHeight = contentRect.height - labelOffset - topLabelHeight
            //만약에 해당 그래프의 높이가 최소높이보다 작으면 최소높이로 지정
            let finalBarHeight = max(y * totalAvailableHeight, minBarHeight)

            // 막대 그래프의 시작 위치 계산
            let barStartY = contentRect.height - finalBarHeight// 막대 그래프의 시작 y 위치
            
            // 막대 그래프의 위치와 크기 설정
            barRect.origin.y = barStartY + finalBarHeight * (1.0 - animator.phaseY)
            barRect.size.height = finalBarHeight * animator.phaseY
            
            let bezierPath = UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius)
            context.addPath(bezierPath.cgPath)
            context.setFillColor(dataSet.color(atIndex: i).cgColor)
            context.fillPath()

            // 상단 텍스트 그리기
            if i < topLabels.count {
                let topLabel = topLabels[i]
                drawTopLabel(context: context, label: topLabel, barRect: barRect, topLabelHeight: topLabelHeight)
            }
        }
    }

    private func drawTopLabel(context: CGContext, label: String, barRect: CGRect, topLabelHeight: CGFloat) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.saverBody1Regurlar,
            .foregroundColor: UIColor.white
        ]

        let size = label.size(withAttributes: attributes)
        let x = barRect.midX - size.width / 2
        let y = barRect.origin.y - size.height - labelOffset // 막대 그래프 상단에 위치

        // 상단 라벨의 위치
        let adjustedY = y

        let textRect = CGRect(x: x, y: adjustedY, width: size.width, height: size.height)
        label.draw(in: textRect, withAttributes: attributes)
    }
}
