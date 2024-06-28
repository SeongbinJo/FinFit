//
//  CustomBarChartView.swift
//  Saver
//
//  Created by 이상민 on 6/28/24.
//

import UIKit
import DGCharts

class CustomBarChartView: BarChartView{

    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupChartView(){
        //공통 설정
        self.noDataText = "데이터가 존재하지 않습니다" //데이터가 없을 시 Text
           self.noDataTextAlignment = .center
           self.noDataFont = UIFont.saverSubTitleSemibold //데이터가 없을 시 textFont 설정
           self.noDataTextColor = .white //데이터가 없을 시 textColor
           self.layer.cornerRadius = 10
       
           self.isUserInteractionEnabled = false //사용자가 해당 view는 상호작요을 못하게 한다.
           self.minOffset = 0 //내부 여백 설정
        
           //x축 설정
           let xAxis = self.xAxis //chartView에 x축
           xAxis.drawGridLinesEnabled = false //x축 격자 제거
           xAxis.drawAxisLineEnabled = false //상단 x축 라인 제거
           xAxis.drawLabelsEnabled = false //상단 x축 라벨 표시
           //        xAxis.enabled = false //x축 하단 라벨 숨기기
           xAxis.labelPosition = .bottom //x축 라벨 위치를 하단으로 설정
           xAxis.granularity = 1 //x축 라벨의 최소 간격을 1로 설정
           xAxis.labelFont = .saverBody2Semibold
           xAxis.labelTextColor = .white
           //        xAxis.yOffset = -8.0 //그래프와 라벨의 사이의 간격
       
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
    }
}
