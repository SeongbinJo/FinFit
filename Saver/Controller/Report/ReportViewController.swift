//
//  GoalAmountViewController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit
import DGCharts //그래프를 그리기 위한 라이브러리

class ReportViewController: UIViewController {
    //MARK: - property
    //그래프 작성을 위한 임시 데이터
    private var fetchData = [SaverModel]()
    private var myData: [String: Category] = [:]
    private var selectedCategory: String?
    private var currentMonth = Calendar.current.component(.month, from: Date())
    private var month = Calendar.current.component(.month, from: Date())
        
    //MARK: - 1. Stack(지출금액이름, 지출금액)
    //지출금액이름
    private lazy var spendingAmountNameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(month)월 지출 금액"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //지출금액
    private lazy var spendingAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(myData.map{ $0.value.totalAmount }.reduce(0, +))원"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //지출금액이름, 지출금액을 담는 Stack
    private lazy var spendingAmountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spendingAmountNameLabel, spendingAmountLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - 2. Stack(stack(지출금액이름, 지출금액), 그래프)
    //지출금액 그래프
    private lazy var spendingReport: BarChartView = {
        let view = BarChartView()
        view.noDataText = "데이터가 존재하지 않습니다" //데이터가 없을 시 Text
        view.noDataTextAlignment = .center
        view.noDataFont = UIFont.systemFont(ofSize: 20) //데이터가 없을 시 textFont 설정
        view.noDataTextColor = .white //데이터가 없을 시 textColor
        
        view.backgroundColor = .darkGray //배경화면 색 설정
        view.isUserInteractionEnabled = false //사용자가 해당 view는 상호작요을 못하게 한다.
        view.minOffset = 0 //내부 여백 설정
        
        //x축 설정
        let xAxis = view.xAxis //charView에 x축
        xAxis.drawGridLinesEnabled = false //x축 격자 제거
        xAxis.drawAxisLineEnabled = false //상단 x축 라인 제거
        xAxis.drawLabelsEnabled = false //상단 x축 라벨 표시
        
        //왼쪽 Y축 설정
        let leftAxis = view.leftAxis //charView에 Y축 설정
        leftAxis.drawGridLinesEnabled = false //왼쪽 Y축 격자 제거
        leftAxis.drawAxisLineEnabled = false //왼쪽 Y축 라인 제거
        leftAxis.drawLabelsEnabled = false //왼쪽 Y축 라벨 제거
        
        //오른쪽 Y축 설정
        let rightAxis = view.rightAxis //charView에 Y축 설정
        rightAxis.drawGridLinesEnabled = false //오른쪽 Y축 격자 제거
        rightAxis.drawAxisLineEnabled = false //오른쪽 Y축 라인 제거
        rightAxis.drawLabelsEnabled = false //오른쪽 Y축 라벨 제거
        
        //그래프를 그려주는 함수 실행
        setBarData(barChartView: view, barChartDataEntries: entryData(values: myData.map{ $0.value.totalAmount })) //금액을 기준으로 그래프를 만들기 때문에 금액변수를 넘긴다.
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //그래프와 stack(지출금액이름, 지출금액)을 담는 Stack
    private lazy var spendingReportStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spendingAmountStackView, spendingReport])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = .darkGray
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
    private lazy var spendindUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(beforeMonthButton)
        view.addSubview(spendingReportStackView)
        view.addSubview(afterMonthButton)
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
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .none //insetline 없애기
        //셀 만드는 거 - GOD성빈님(역시 에이스...)
        tableView.register(CategoryExpenditureTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    //MARK: - 6. 모든 View들을 담을 StackView
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spendindUIView, legendScrollView, categoryExpenditureTableView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    //MARK: - Life Cycle
    
    //view처음 로드될 때
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ShareData.shared.loadSaverEntries()
        fetchData = ShareData.shared.getMonthSaverEntries(month: month)
        setup()
    }
    
    //MARK: - Methods
    //최초설정 함수
    private func setup(){
        categoryFilterSaverEntries()
        //불러온 데이터가 하나라도 존재하면 그 중 첫 번째 키를 selectedCategory에 저장한다.
        self.selectedCategory = myData.first?.key
        
        view.addSubview(mainStackView)
        setupLegendScrollView(labels: myData.map{$0.key})
        
        //오토레이아웃 설정
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            //MARK: - 모든 View를 담는 ScrollView
            //            mainScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            //            mainScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            //            mainScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            //            mainScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            //            mainStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -20),
            
            //            //MARK: - 상단 Report
            //stackView를 담는 UIView
            spendindUIView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            spendindUIView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            spendindUIView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            spendindUIView.bottomAnchor.constraint(equalTo: spendingReportStackView.bottomAnchor, constant: 20),
            
            //StackView(StackView(지출금액이름, 지출금액), 그래프)
            spendingReportStackView.leadingAnchor.constraint(equalTo: spendindUIView.leadingAnchor, constant: 20),
            spendingReportStackView.trailingAnchor.constraint(equalTo: spendindUIView.trailingAnchor, constant: -20),
            spendingReportStackView.topAnchor.constraint(equalTo: spendindUIView.topAnchor, constant: 20),
            
            //StackView(지출금액이름, 지출금액)
            spendingAmountStackView.leadingAnchor.constraint(equalTo: spendingReportStackView.leadingAnchor),
            spendingAmountStackView.trailingAnchor.constraint(equalTo: spendingReportStackView.trailingAnchor),
            //
            //지출금액이름
            spendingAmountNameLabel.leadingAnchor.constraint(equalTo: spendingAmountStackView.leadingAnchor),
            spendingAmountNameLabel.trailingAnchor.constraint(equalTo: spendingAmountStackView.trailingAnchor),
            //
            //지출금액
            spendingAmountLabel.leadingAnchor.constraint(equalTo: spendingAmountStackView.leadingAnchor),
            spendingAmountLabel.trailingAnchor.constraint(equalTo: spendingAmountStackView.trailingAnchor),
            
            //지출 그래프
            spendingReport.leadingAnchor.constraint(equalTo: spendingReportStackView
                .leadingAnchor),
            spendingReport.trailingAnchor.constraint(equalTo: spendingReportStackView.trailingAnchor),
            spendingReport.heightAnchor.constraint(equalTo: spendingReportStackView.widthAnchor, multiplier: 0.5),
            
            //왼쪽 화살표
            beforeMonthButton.leadingAnchor.constraint(equalTo: spendindUIView.leadingAnchor),
            beforeMonthButton.trailingAnchor.constraint(equalTo: spendingReport.leadingAnchor),
            beforeMonthButton.centerXAnchor.constraint(equalTo: beforeMonthButton.centerXAnchor),
            beforeMonthButton.centerYAnchor.constraint(equalTo: spendindUIView.centerYAnchor),
            
            //오른쪽 화살표
            afterMonthButton.leadingAnchor.constraint(equalTo: spendingReportStackView.trailingAnchor),
            afterMonthButton.trailingAnchor.constraint(equalTo: spendindUIView.trailingAnchor),
            afterMonthButton.centerXAnchor.constraint(equalTo: afterMonthButton.centerXAnchor),
            afterMonthButton.centerYAnchor.constraint(equalTo: spendindUIView.centerYAnchor),
            
            //MARK: - 중간 카테고리 스크롤
            //legend 스크롤
            legendScrollView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            legendScrollView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            legendScrollView.heightAnchor.constraint(equalToConstant: 30),
            
            //            //legend 스택
            legendStackView.leadingAnchor.constraint(equalTo: legendScrollView.leadingAnchor),
            legendStackView.trailingAnchor.constraint(equalTo: legendScrollView.trailingAnchor),
            legendStackView.topAnchor.constraint(equalTo: legendScrollView.topAnchor),
            legendStackView.bottomAnchor.constraint(equalTo: legendScrollView.bottomAnchor),
            legendStackView.heightAnchor.constraint(equalTo: legendScrollView.heightAnchor),
            
            //MARK: - 하단 카테고리별 지출내역 테이블뷰
            //카테고리별 지출 내역 Table
            categoryExpenditureTableView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            categoryExpenditureTableView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            categoryExpenditureTableView.topAnchor.constraint(equalTo: legendScrollView.bottomAnchor, constant: 10),
            categoryExpenditureTableView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
        ])
    }
    
    //MARK: - 그래프 생성
    //그래프의 데이터를
    private func setBarData(barChartView: BarChartView, barChartDataEntries: [BarChartDataEntry]) {
        if barChartDataEntries.isEmpty{
            barChartView.data = nil
        }else{
            //BarChart데이터들을 만든다.
            let barChartdataSet = BarChartDataSet(entries: barChartDataEntries, label: "사용금액")
            //각 데이터마다 위의 값이 나타는데 제거 시켜준다.
            barChartdataSet.valueTextColor = .clear
            
            //위에서 만든 데이터들로 차트를 생성한다.
            let barChartData = BarChartData(dataSet: barChartdataSet)
            
            barChartData.barWidth = 0.5
            
            //차트뷰의 해당 데이터는 위에서만들 차트이다.
            barChartView.data = barChartData
        }
        barChartView.notifyDataSetChanged()
        
        //Legend설정
        barChartView.legend.enabled = false
    }
    
    //차트데이터를 만드는데 필요한 개체(BarChartDataEntry 타입)를 만들어 주는 함수
    private func entryData(values: [Double]) -> [BarChartDataEntry] {
        var barDataEntries: [BarChartDataEntry] = []
        let count = values.count
        guard count > 0 else { return barDataEntries }
        
        let maxValue = values.max()!
        
        for i in 0..<max(10, count) {
            if i < count {
                let value = values[i]
                let logScaledValue = log10(value) / log10(maxValue)
                let finalValue = logScaledValue > 0 ? logScaledValue : value
                barDataEntries.append(BarChartDataEntry(x: Double(i), y: finalValue))
            } else {
                // 빈 데이터를 채워 넣음
                barDataEntries.append(BarChartDataEntry(x: Double(i), y: 0))
            }
        }
        return barDataEntries
    }
    
    //MARK: - LegendScrol생성
    //그래프의 legend를 스크롤로 생성하는 함수
    private func setupLegendScrollView(labels: [String]){
        for label in labels{
            //모양
            let capsuleView = UIView()
            capsuleView.backgroundColor = .systemPink
            capsuleView.layer.cornerRadius = 15
            capsuleView.layer.masksToBounds = true
            capsuleView.translatesAutoresizingMaskIntoConstraints = false
            
            //텍스트
            let labelView = UILabel()
            labelView.text = label
            labelView.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            labelView.textAlignment = .center
            labelView.textColor = .white
            labelView.translatesAutoresizingMaskIntoConstraints = false
            
            capsuleView.addSubview(labelView)
            legendStackView.addArrangedSubview(capsuleView)
            
            NSLayoutConstraint.activate([
                //캡슐뷰
                capsuleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
                
                //라벨뷰
                labelView.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 8),
                labelView.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -8),
                labelView.topAnchor.constraint(equalTo: capsuleView.topAnchor),
                labelView.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor)
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
        selectedCategory = selectedView.accessibilityIdentifier
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
    
    //달을 변경했을 때 뷰를 업데이트하는 함수
    func reloadViewUpdate(){
        categoryFilterSaverEntries()
        setBarData(barChartView: spendingReport, barChartDataEntries: entryData(values: myData.map{$0.value.totalAmount}))
        legendStackView.subviews.forEach{ $0.removeFromSuperview() }
        if myData.isEmpty{
            selectedCategory = nil
            legendScrollView.removeFromSuperview()
            categoryExpenditureTableView.removeFromSuperview()
        }else{
            selectedCategory = myData.first?.key
            setupLegendScrollView(labels: myData.map{$0.key})
            mainStackView.addArrangedSubview(legendScrollView)
            mainStackView.addArrangedSubview(categoryExpenditureTableView)
            categoryExpenditureTableView.reloadData()
        }
        
        spendingAmountNameLabel.text = "\(month)월 지출 금액"
        spendingAmountLabel.text = "\(abs(myData.map{ $0.value.totalAmount }.reduce(0, +)))원"
    }
    
    //MARK: - 필요한 데이터로 변환 및 생성
    //카테고리 별 분류 함수
    func categoryFilterSaverEntries(){
        myData = [:]
        for data in fetchData{
            if data.spendingAmount < 0{
                if myData[data.name] == nil {
                    myData[data.name] = Category(totalAmount: 0, dailyDatas: [])
                }
                
                var category = myData[data.name]!
                
                
                category.totalAmount -= data.spendingAmount
                
                
                if let index = category.dailyDatas.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: data.transactionDate) }) {
                    category.dailyDatas[index].totalAmount += data.spendingAmount
                    category.dailyDatas[index].saverModels.append(data)
                } else {
                    let newDailyData = DailyData(date: data.transactionDate, totalAmount: data.spendingAmount, saverModels: [data])
                    category.dailyDatas.append(newDailyData)
                }
                
                myData[data.name] = category
            }
        }
    }
    
    //MARK: - CustomCell로 데이터 넘겨주기
    //CustomCell에 넘겨주기 위한 데이터 가져오는 함수
    func getSaverEntries(index: Int) -> [SaverModel]{
        return myData[self.selectedCategory!]!.dailyDatas[index].saverModels
    }
}

//MARK: - Delegate
//UITableView
extension ReportViewController: UITableViewDataSource, UITableViewDelegate{
    //MARK: - row, cell 설정
    //행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedCategory = self.selectedCategory else { return 0 }
        if let selectedCategoryData = myData[selectedCategory]{
            return selectedCategoryData.dailyDatas.count
        }
        return 0
    }
    
    //cell생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryExpenditureTableViewCell
        guard let selectedCategory = self.selectedCategory else { return cell }
        cell.configureCell(entry: myData[selectedCategory]!.dailyDatas[indexPath.row])
        return cell
    }
    
    //셀이 선택됬을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let saverEntries = self.getSaverEntries(index: indexPath.row)
        let detailCateogryTransactionViewController = DetailCategoryTransactionAmoutViewController(saverEntries: saverEntries)
        present(detailCateogryTransactionViewController, animated: true)
    }
    
    //높이설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
