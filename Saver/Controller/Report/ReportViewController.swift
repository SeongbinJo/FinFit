//
//  GoalAmountViewController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit
import DGCharts //그래프를 그리기 위한 라이브러리

class ReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: - property
    //그래프 작성을 위한 임시 데이터
    private var fetchData = [SaverModel]()
    private var myData: [(String, Category)] = []
    private var selectedCategory: String?
    private var currentMonth = Calendar.current.component(.month, from: Date())
    private var month = Calendar.current.component(.month, from: Date())
    private let mainLR: CGFloat = 24
    private let viewPadding: CGFloat = 20
    
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
        view.values = myData.map{ $0.1.totalAmount } //데이터의 크기
        view.labels = myData.map{ $0.0} //데이터 상단 라벨
        // X축 레이블 설정
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
        spendingReport.updateDate(values: myData.map{ $0.1.totalAmount }, labels: myData.map{ $0.0 })
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
        spendingReport.updateDate(values: myData.map{ $0.1.totalAmount }, labels: myData.map{ $0.0 })
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
extension ReportViewController{
    
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
