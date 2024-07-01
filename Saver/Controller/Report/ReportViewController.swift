//
//  GoalAmountViewController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit
import DGCharts //그래프를 그리기 위한 라이브러리

class ReportViewController: UIViewController, AxisValueFormatter {
    //MARK: - property
    //그래프 작성을 위한 임시 데이터
    private var fetchData = [SaverModel]()
    private var myData: [(String, Category)] = []
    private var selectedCategory: String?
    private var currentMonth = Calendar.current.component(.month, from: Date())
    private var month = Calendar.current.component(.month, from: Date())
    private let mainLR: CGFloat = 24
    private let viewPadding: CGFloat = 20
    private let colors: [UIColor] = [.incomeAmount, .primaryBlue80, .primaryBlue60, .primaryBlue40]
    
    //MARK: - 1. Stack(지출금액이름, 지출금액)
    //지출금액이름
    private lazy var spendingAmountNameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(month)월 지출 금액"
        label.font = UIFont.saverSubTitleSemibold
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //지출금액
    private lazy var spendingAmountLabel: UILabel = {
        let label = CustomUILabel()
        label.text = "\(ShareData.shared.formatNumber(myData.map{$0.1.totalAmount}.reduce(0, +)))원"
        label.font = UIFont.saverTitleBold
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 2. Stack(stack(지출금액이름, 지출금액), 그래프)
    //지출금액 그래프
    private lazy var spendingReport: CustomBarChartView = {
        let view = CustomBarChartView()
        //그래프를 그려주는 함수 실행
        view.xAxis.valueFormatter = self // X축 레이블 설정
        setBarData(barChartView: view, barChartDataEntries: entryData(values: myData.map{ $0.1.totalAmount })) //금액을 기준으로 그래프를 만들기 때문에 금액변수를 넘긴다.
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //그래프와 지출금액이름, 지출금액을 담는 Stack
    private lazy var spendingTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spendingAmountNameLabel, spendingAmountLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var spendingReportStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spendingTitleStackView, spendingReport])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //왼쪽 버튼
    private lazy var beforeMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(updateData(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //오른쪽 버튼
    private lazy var afterMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(updateData(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - 3. stackView를 담을 UIView
    private lazy var spendingUIStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [beforeMonthButton, spendingReportStackView, afterMonthButton])
        view.axis = .horizontal
        view.backgroundColor = .neutral80
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - 4. ScrollView(그래프 카테고리 Legend)
    //legend를 담을 StackView
    private lazy var legendStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //ScrollView(그래프 카테고리 Legend)
    private lazy var legendScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(legendStackView)
        return scrollView
    }()
    
    //MARK: - 5. 카테고리별 지출 내역 Table
    private lazy var categoryExpenditureTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .saverBackground
        tableView.separatorStyle = .none //insetline 없애기
        //셀 만드는 거 - GOD성빈님(역시 에이스...)
        tableView.register(CategoryExpenditureTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        ShareData.shared.loadSaverEntries()
        fetchData = ShareData.shared.getMonthSaverEntries(month: month)
        setup()
    }
    
    //MARK: - Life Cycle
    //view처음 로드될 때
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methods
    //최초설정 함수
    private func setup(){
        categoryFilterSaverEntries()
        //불러온 데이터가 하나라도 존재하면 그 중 첫 번째 키를 selectedCategory에 저장한다.
        self.selectedCategory = myData.first?.0
        view.backgroundColor = .saverBackground
        view.addSubview(spendingUIStackView)
            addViewWithConstraints([legendScrollView, categoryExpenditureTableView], to: view)
            setupLegendScrollView(labels: myData.map{$0.0})
            setBarData(barChartView: spendingReport, barChartDataEntries: entryData(values: myData.map{ $0.1.totalAmount }))
            spendingAmountLabel.text = "\(ShareData.shared.formatNumber(myData.map{$0.1.totalAmount}.reduce(0, +)))원"
            categoryExpenditureTableView.reloadData()
        
        //오토레이아웃 설정
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //MARK: - 상단 Report
            //stackView를 담는 UIView
            spendingUIStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            spendingUIStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            spendingUIStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
            spendingUIStackView.heightAnchor.constraint(equalToConstant: 350),
            
            //StackView(StackView(지출금액이름, 지출금액), 그래프)
            spendingReportStackView.leadingAnchor.constraint(equalTo: spendingUIStackView.leadingAnchor, constant: viewPadding),
            spendingReportStackView.trailingAnchor.constraint(equalTo: spendingUIStackView.trailingAnchor, constant: -viewPadding),
            spendingReportStackView.topAnchor.constraint(equalTo: spendingUIStackView.topAnchor, constant: viewPadding),
            
            spendingTitleStackView.leadingAnchor.constraint(equalTo: spendingReportStackView.leadingAnchor),
            spendingTitleStackView.trailingAnchor.constraint(equalTo: spendingReportStackView.trailingAnchor),
            spendingTitleStackView.topAnchor.constraint(equalTo: spendingReportStackView.topAnchor),
            
            //지출금액이름
            spendingAmountNameLabel.leadingAnchor.constraint(equalTo: spendingTitleStackView.leadingAnchor),
            spendingAmountNameLabel.trailingAnchor.constraint(equalTo: spendingTitleStackView.trailingAnchor),
            spendingAmountNameLabel.topAnchor.constraint(equalTo: spendingTitleStackView.topAnchor),
            
            //지출금액
            spendingAmountLabel.leadingAnchor.constraint(equalTo: spendingTitleStackView.leadingAnchor),
            spendingAmountLabel.trailingAnchor.constraint(equalTo: spendingTitleStackView.trailingAnchor),
            
            //지출 그래프
            spendingReport.leadingAnchor.constraint(equalTo: spendingReportStackView
                .leadingAnchor),
            spendingReport.trailingAnchor.constraint(equalTo: spendingReportStackView.trailingAnchor),
            
            //왼쪽 화살표
            beforeMonthButton.leadingAnchor.constraint(equalTo: spendingUIStackView.leadingAnchor),
            beforeMonthButton.trailingAnchor.constraint(equalTo: spendingReport.leadingAnchor),
            beforeMonthButton.centerXAnchor.constraint(equalTo: beforeMonthButton.centerXAnchor),
            beforeMonthButton.centerYAnchor.constraint(equalTo: spendingUIStackView.centerYAnchor),
            
            //오른쪽 화살표
            afterMonthButton.leadingAnchor.constraint(equalTo: spendingReportStackView.trailingAnchor),
            afterMonthButton.trailingAnchor.constraint(equalTo: spendingUIStackView.trailingAnchor),
            afterMonthButton.centerXAnchor.constraint(equalTo: afterMonthButton.centerXAnchor),
            afterMonthButton.centerYAnchor.constraint(equalTo: spendingUIStackView.centerYAnchor),
        ])
    }
    
    //MARK: - 그래프 생성
    private func setBarData(barChartView: BarChartView, barChartDataEntries: [BarChartDataEntry]) {
        if barChartDataEntries.isEmpty {
            barChartView.data = nil
        } else {
            var topLabels = [String]()
            let total = myData.map { $0.1.totalAmount }.reduce(0.0, +)
            
            if myData.count > 4 {
                topLabels = myData.prefix(3).map { "\(String(format: "%.1f", ($0.1.totalAmount / total) * 100))%" }
                let remainingData = myData.dropFirst(3).map { $0.1.totalAmount }.reduce(0, +)
                topLabels.append("\(String(format: "%.1f", (remainingData / total) * 100))%")
            } else {
                topLabels = myData.map { "\(String(format: "%.1f", ($0.1.totalAmount / total) * 100))%" }
            }
            
            let barChartDataSet = BarChartDataSet(entries: barChartDataEntries, label: "사용금액")
            barChartDataSet.colors = self.colors
            let barChartData = BarChartData(dataSet: barChartDataSet)
            barChartData.barWidth = 0.6
            barChartView.data = barChartData

            
            let customRenderer = CustomRoundedBarChartRenderer(dataProvider: barChartView, animator: barChartView.chartAnimator, viewPortHandler: barChartView.viewPortHandler)
            customRenderer.topLabels = topLabels
            barChartView.renderer = customRenderer
            barChartView.animate(yAxisDuration: 0.7, easingOption: .easeInOutQuad)
        }
        barChartView.notifyDataSetChanged()
        barChartView.legend.enabled = false
    }
    
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        if myData.count > 4{
            if Int(value) < 3{
                return myData[Int(value) % myData.count].0
            }else{
                return "기타"
            }
        }else{
            if Int(value) < myData.count{
                return myData[Int(value) % myData.count].0
            }else{
                return ""
            }
        }
    }
    
    
    private func entryData(values: [Double]) -> [BarChartDataEntry] {
        var barDataEntries: [BarChartDataEntry] = []
        let count = values.count
        guard count > 0 else { return barDataEntries }
        
        var condensedData = [Double]()
        
        if values.count > 4 {
            condensedData += values[0...2]
            condensedData.append(values[3...values.count-1].reduce(0.0, +))
        } else {
            condensedData = values
            condensedData += [Double](repeating: 0.0, count: 4-values.count)
        }
        
        let total = condensedData.reduce(0.0, +)
        for i in 0..<4 {
            let value = condensedData[i]
            let finalValue = value / total
            barDataEntries.append(BarChartDataEntry(x: Double(i), y: finalValue))
        }
        
        return barDataEntries
    }
    
    
    
    
    //MARK: - LegendScrol생성
    //그래프의 legend를 스크롤로 생성하는 함수
    private func setupLegendScrollView(labels: [String]){
        legendStackView.subviews.forEach{ $0.removeFromSuperview() }
        for label in labels{
            //모양
            let capsuleView = UIView()
            capsuleView.backgroundColor = .systemPink
            capsuleView.layer.cornerRadius = 20
            capsuleView.layer.masksToBounds = true
            capsuleView.translatesAutoresizingMaskIntoConstraints = false
            capsuleView.backgroundColor = .neutral80
            if label == selectedCategory{
                capsuleView.backgroundColor = .incomeAmount
            }
            
            //텍스트
            let labelView = UILabel()
            labelView.text = label
            labelView.font = .saverBody1Regurlar
            labelView.textAlignment = .center
            labelView.textColor = .white
            labelView.translatesAutoresizingMaskIntoConstraints = false
            
            capsuleView.addSubview(labelView)
            legendStackView.addArrangedSubview(capsuleView)
            
            NSLayoutConstraint.activate([
                //라벨뷰
                labelView.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 20),
                labelView.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -20),
                labelView.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 10),
                labelView.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -10)
            ])
            
            //각 legend 항목에 대한 TapGesture 추가
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(legendTapped(_:)))
            capsuleView.addGestureRecognizer(tapGesture)
            capsuleView.accessibilityIdentifier = label
            capsuleView.isUserInteractionEnabled = true
        }
    }
    
    //legend를 Tap했을 때 발생하는 액션함수
    @objc func legendTapped(_ getsture: UITapGestureRecognizer){
        guard let selectedView = getsture.view else { return }
        
        //이전의 선택되었던 카테고리의 색상을 원래대로 되돌림
        if let selectedCategory = selectedCategory, let previousSelectedView = legendStackView.arrangedSubviews.first(where: { $0.accessibilityIdentifier == selectedCategory }) {
            previousSelectedView.backgroundColor = .neutral80
        }
        selectedCategory = selectedView.accessibilityIdentifier
        
        //클릭된 카테고리의 색상을 변경
        selectedView.backgroundColor = .incomeAmount
        
        categoryExpenditureTableView.reloadData()
    }
    
    //MARK: - 월 변경
    //월 변경 함수
    @objc func updateData(sender: UIButton){
        if sender == beforeMonthButton{
            if month > 1{
                month -= 1
                fetchData = ShareData.shared.getMonthSaverEntries(month: month)
                reloadViewUpdate()
            }
        }else if sender == afterMonthButton{
            if month < currentMonth{
                month += 1
                fetchData = ShareData.shared.getMonthSaverEntries(month: month)
                reloadViewUpdate()
            }
        }
    }
    
    // 뷰를 추가하고 제약조건을 설정하는 함수
    func addViewWithConstraints(_ view: [UIView], to superview: UIView) {
        superview.addSubview(view[0])
        superview.addSubview(view[1])
        
        let safeArea = superview.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //MARK: - 중간 카테고리 스크롤
            //legend 스크롤
            view[0].leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            view[0].trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
            view[0].topAnchor.constraint(equalTo: spendingUIStackView.bottomAnchor, constant: 40),
            view[0].heightAnchor.constraint(equalTo: legendStackView.heightAnchor),
            
            //legend 스택
            legendStackView.leadingAnchor.constraint(equalTo: legendScrollView.leadingAnchor),
            legendStackView.trailingAnchor.constraint(equalTo: legendScrollView.trailingAnchor),
            legendStackView.topAnchor.constraint(equalTo: legendScrollView.topAnchor),
            legendStackView.bottomAnchor.constraint(equalTo: legendScrollView.bottomAnchor),
            
            //MARK: - 하단 카테고리별 지출내역 테이블뷰
            //카테고리별 지출 내역 Table
            view[1].leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: mainLR),
            view[1].trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -mainLR),
            view[1].topAnchor.constraint(equalTo: legendScrollView.bottomAnchor, constant: viewPadding),
            view[1].bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    //달을 변경했을 때 뷰를 업데이트하는 함수
    func reloadViewUpdate(){
        categoryFilterSaverEntries()
        setBarData(barChartView: spendingReport, barChartDataEntries: entryData(values: myData.map{$0.1.totalAmount}))
        legendStackView.subviews.forEach{ $0.removeFromSuperview() }
        if myData.isEmpty{
            selectedCategory = nil
            legendScrollView.removeFromSuperview()
            categoryExpenditureTableView.removeFromSuperview()
        }else{
            selectedCategory = myData.first?.0
            setupLegendScrollView(labels: myData.map{$0.0})
            addViewWithConstraints([legendScrollView, categoryExpenditureTableView], to: view)
            categoryExpenditureTableView.reloadData()
        }
        
        spendingAmountNameLabel.text = "\(month)월 지출 금액"
        spendingAmountLabel.text = "\(ShareData.shared.formatNumber(myData.map{$0.1.totalAmount}.reduce(0, +)))원"
    }
    
    //MARK: - 필요한 데이터로 변환 및 생성
    //카테고리 별 분류 함수
    func categoryFilterSaverEntries(){
        myData = []
        for data in fetchData {
            if data.spendingAmount < 0 {
                if let index = myData.firstIndex(where: { $0.0 == data.name }) {
                    var category = myData[index].1
                    category.totalAmount -= data.spendingAmount
                    
                    if let index = category.dailyDatas.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: data.transactionDate) }) {
                        category.dailyDatas[index].totalAmount += data.spendingAmount
                        category.dailyDatas[index].saverModels.append(data)
                    } else {
                        let newDailyData = DailyData(date: data.transactionDate, totalAmount: data.spendingAmount, saverModels: [data])
                        category.dailyDatas.append(newDailyData)
                    }
                    
                    myData[index] = (data.name, category)
                } else {
                    var category = Category(totalAmount: 0, dailyDatas: [])
                    category.totalAmount -= data.spendingAmount
                    let newDailyData = DailyData(date: data.transactionDate, totalAmount: data.spendingAmount, saverModels: [data])
                    category.dailyDatas.append(newDailyData)
                    myData.append((data.name, category))
                }
            }
        }
        // 정렬
        myData.sort { $0.1.totalAmount > $1.1.totalAmount }
        for index in 0..<myData.count {
            var category = myData[index].1
            category.dailyDatas.sort { $0.date < $1.date }
            myData[index] = (myData[index].0, category)
        }
    }
    
    //MARK: - CustomCell로 데이터 넘겨주기
    //CustomCell에 넘겨주기 위한 데이터 가져오는 함수
    func getSaverEntries(index: Int) -> [SaverModel] {
        guard let selectedCategory = self.selectedCategory,
              let categoryIndex = myData.firstIndex(where: { $0.0 == selectedCategory }),
              index < myData[categoryIndex].1.dailyDatas.count else {
            return []
        }
        
        return myData[categoryIndex].1.dailyDatas[index].saverModels
    }
}

//MARK: - Delegate
//UITableView
extension ReportViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - sections설정
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let selectedCategory = self.selectedCategory,
              let categoryIndex = myData.firstIndex(where: { $0.0 == selectedCategory }) else {
            return 0
        }
        
        return myData[categoryIndex].1.dailyDatas.count
    }
    
    //MARK: - row, cell 설정
    //섹션의 포함되는 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    //cell생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryExpenditureTableViewCell
        cell.selectionStyle = .none
        
        guard let selectedCategory = self.selectedCategory,
              let categoryIndex = myData.firstIndex(where: { $0.0 == selectedCategory }) else {
            return cell
        }
        
        let dailyDatas = myData[categoryIndex].1.dailyDatas
        guard indexPath.section < dailyDatas.count else {
            return cell
        }
        
        let entry = dailyDatas[indexPath.section]
        cell.configureCell(entry: entry)
        return cell
    }
    
    //섹션하단에 넣을 뷰 높이 지정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == (tableView.numberOfSections - 1) ? 0.0 : 20.0 //마지막 셀의 하단 제거
    }
    
    //섹션하단에 넣을 뷰
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear //투명한 배경
        return footerView
    }
    
    //셀이 선택됬을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let saverEntries = self.getSaverEntries(index: indexPath.section)
        let detailCateogryTransactionViewController = DetailCategoryTransactionAmoutViewController(saverEntries: saverEntries)
        //sheet시 얼마나 커지게 할지 .fullscreen의 경우 끝까지 올람감, automatic safeArea?정도 올라감
        detailCateogryTransactionViewController.modalPresentationStyle = .automatic
        //sheet올리거나 때릴 때 순서 medium: 중간, large: 끝까지
        detailCateogryTransactionViewController.sheetPresentationController?.detents = [.medium(), .large()]
        //sheet 상위 중앙에 sheet를 알 수 있는 선 생성
        detailCateogryTransactionViewController.sheetPresentationController?.prefersGrabberVisible = true
        detailCateogryTransactionViewController.sheetPresentationController?.preferredCornerRadius = 10
        //안에 프로퍼티로 변할때 애니메이션 추가
        detailCateogryTransactionViewController.sheetPresentationController?.animateChanges {
            sheetPresentationController?.selectedDetentIdentifier = .medium
        }
        present(detailCateogryTransactionViewController, animated: true)
    }
}

//MARK: - 막대그래프에 radius, topLabel 만들기 위해 render재정의
class CustomRoundedBarChartRenderer: BarChartRenderer {

    var topLabels: [String] = [] //상단 Label 문자
    var minBarHeight: CGFloat = 8.0 // 최소 바 높이
    let labelOffset: CGFloat = 8.0 // 라벨과 막대 사이의 간격
    let cornerRadius: CGFloat = 10.0 // 둥근 모서리 정도

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
            
            if y == 0 { continue } // 데이터가 없으면 건너뜀

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

        // 상단 라벨이 차트 뷰 상단에 닿지 않도록 조정
        let adjustedY = y

        let textRect = CGRect(x: x, y: adjustedY, width: size.width, height: size.height)
        label.draw(in: textRect, withAttributes: attributes)
    }
}
