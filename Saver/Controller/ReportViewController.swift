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
//    let categories: [String] = ["카페", "음식점", "게임칩", "주차장", "쇼핑", "키보드", "냉장고", "컴퓨터", "모니터", "집"]
//    let priceData: [Double] = [5000, 8000, 30000, 1500, 40000, 130000, 700000, 2000000, 340000, 10000]
    
    var categories: [String: [SaverModel]] = [:]
    var priceData: [Double] = []
    
    //MARK: - 1. Stack(지출금액이름, 지출금액)
    //지출금액이름
    private lazy var spendingAmountNameLabel: UILabel = {
        let label = UILabel()
        label.text = "5월 지출 금액"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //지출금액
    private lazy var spendingAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "900,000원"
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
        view.noDataText = "데이터가 없습니다." //데이터가 없을 시 Text
        view.noDataFont = UIFont.systemFont(ofSize: 20) //데이터가 없을 시 textFont 설정
        view.noDataTextColor = .white //데이터가 없을 시 textColor
        view.backgroundColor = .darkGray //배경화면 색 설정
        view.isUserInteractionEnabled = false //사용자가 해당 view는 상호작요을 못하게 한다.
        
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
        setBarData(barChartView: view, barChartDataEntries: entryData(values: priceData)) //금액을 기준으로 그래프를 만들기 때문에 금액변수를 넘긴다.
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
    
    //MARK: - stackView를 담을 UIView
    private lazy var spendindUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spendingReportStackView)
        return view
    }()
    
    //MARK: - ScrollView(그래프 카테고리 Legend)
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
    
    //MARK: - 카테고리별 지출 내역 Table
    private lazy var categoryExpenditureTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
//        tableView.backgroundColor = .darkGray
//        tableView.separatorStyle = .none //언더라인 없애기
        //셀 만드는 거 - GOD성빈님(역시 에이스...)
        tableView.register(CategoryExpenditureTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    

    //MARK: - Methods
    //최소설정 함수
    private func setup(){
//        view.addSubview(spendingAmountNameLabel) //view에 지출금액이름 label 추가
//        view.addSubview(spendingAmountLabel) //view에 지출금액 label 추가
        
        //해당 달의 데이터만 가져오기
        self.categories = createDummyData().reduce(into: [String: [SaverModel]]()) { result, element in
            let filteredTransactions = element.value.filter { data in
                let components = Calendar.current.dateComponents([.month], from: data.transactionDate)
                return components.month == 6
            }
            result[element.key] = filteredTransactions
            
            // 각 카테고리별 값의 총합을 계산하여 priceData에 추가
            let total = filteredTransactions.reduce(0.0) { $0 + $1.spendingAmount }
                priceData.append(total)
        }
        print(categories)
        print(priceData)
        
        view.addSubview(spendindUIView)
        view.addSubview(legendScrollView)
        setupLegendScrollView(labels: categories.map{$0.key})
        view.addSubview(categoryExpenditureTableView)
        
        //오토레이아웃 설정
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            //MARK: - 상단 Report
            //stackView를 담는 UIView
            spendindUIView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            spendindUIView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            spendindUIView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            
            //StackView(지출금액이름, 지출금액)
            spendingAmountStackView.leadingAnchor.constraint(equalTo: spendindUIView.leadingAnchor, constant: 10),
            spendingAmountStackView.trailingAnchor.constraint(equalTo: spendindUIView.trailingAnchor, constant: -10),
            spendingAmountStackView.topAnchor.constraint(equalTo: spendindUIView.topAnchor, constant: 20),
            
            //StackView(StackView(지출금액이름, 지출금액), 그래프)
            spendingReportStackView.leadingAnchor.constraint(equalTo: spendindUIView.leadingAnchor, constant: 10),
            spendingReportStackView.trailingAnchor.constraint(equalTo: spendindUIView.trailingAnchor, constant: -10),
            spendingReportStackView.bottomAnchor.constraint(equalTo: spendindUIView.bottomAnchor, constant: -20),

            //지출금액이름
            spendingAmountNameLabel.leadingAnchor.constraint(equalTo: spendingAmountStackView.leadingAnchor, constant: 10),
            spendingAmountNameLabel.trailingAnchor.constraint(equalTo: spendingAmountStackView.trailingAnchor, constant: -10),
            

            //지출금액
            spendingAmountLabel.leadingAnchor.constraint(equalTo: spendingAmountStackView.leadingAnchor, constant: 10),
            spendingAmountLabel.trailingAnchor.constraint(equalTo: spendingAmountStackView.trailingAnchor, constant: -10),
            
            
            //지출 그래프
            spendingReport.leadingAnchor.constraint(equalTo: spendingReportStackView
                .leadingAnchor, constant: 10),
            spendingReport.trailingAnchor.constraint(equalTo: spendingReportStackView.trailingAnchor, constant: -10),
            spendingReport.widthAnchor.constraint(equalTo: spendingReportStackView.widthAnchor, constant: -20),
            spendingReport.heightAnchor.constraint(equalTo: spendingReportStackView.widthAnchor, multiplier: 0.5),
            
            //MARK: - 중간 카테고리 스크롤
            //legend 스크롤
            legendScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            legendScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            legendScrollView.topAnchor.constraint(equalTo: spendindUIView.bottomAnchor, constant: 10),
            legendScrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -20),
            legendScrollView.heightAnchor.constraint(equalToConstant: 30),
            
            //legend 스택
            legendStackView.leadingAnchor.constraint(equalTo: legendScrollView.leadingAnchor),
            legendStackView.trailingAnchor.constraint(equalTo: legendScrollView.trailingAnchor),
            legendStackView.topAnchor.constraint(equalTo: legendScrollView.topAnchor),
            legendStackView.bottomAnchor.constraint(equalTo: legendScrollView.bottomAnchor),
            legendStackView.heightAnchor.constraint(equalTo: legendScrollView.heightAnchor),

            //MARK: - 하단 카테고리별 지출내역 테이블뷰
            //카테고리별 지출 내역 Table
            categoryExpenditureTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            categoryExpenditureTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            categoryExpenditureTableView.topAnchor.constraint(equalTo: legendScrollView.bottomAnchor, constant: 10),
            categoryExpenditureTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ])
    }
    
    //그래프의 데이터를
    private func setBarData(barChartView: BarChartView, barChartDataEntries: [BarChartDataEntry]) {
        //BarChart데이터들을 만든다.
        let barChartdataSet = BarChartDataSet(entries: barChartDataEntries, label: "사용금액")
        //각 데이터마다 위의 값이 나타는데 제거 시켜준다.
        barChartdataSet.valueTextColor = .clear
        
        //위에서 만든 데이터들로 차트를 생성한다.
        let barChartData = BarChartData(dataSet: barChartdataSet)
        
        //차트뷰의 해당 데이터는 위에서만들 차트이다.
        barChartView.data = barChartData
        
        //Legend설정
        barChartView.legend.enabled = false
    }
    
    //차트데이터를 만드는데 필요한 개체(BarChartDataEntry 타입)를 만들어 주는 함수
    private func entryData(values: [Double]) -> [BarChartDataEntry] {
        var barDataEntries: [BarChartDataEntry] = []
        for i in 0 ..< values.count {
            //개체를 만들어서 리턴해야하는 개체 배열에 추가한다.
            barDataEntries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        return barDataEntries
    }

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
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Delegate
extension ReportViewController: UITableViewDataSource, UITableViewDelegate{
    
    //section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        let temp = categories["영화관"]!
        var dateArr = [String]()
        for o in temp{
            if !dateArr.contains(o.transactionDate.formatted(.dateTime.day())){
                dateArr.append(o.transactionDate.formatted(.dateTime.day()))
            }
        }
        return dateArr.count
    }
    
    //section Header 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    
    //Section Header설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "\(categories["영화관"]!.sorted(by: {$0.transactionDate < $1.transactionDate})[section].transactionDate.formatted(.dateTime.day()))일"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    //행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories["영화관"]!.count
    }
    
    //cell생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryExpenditureTableViewCell
        cell.configureCell(entry: categories["영화관"]![indexPath.row])
        return cell
    }
    
    //높이설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

//MARK: - 더미데이터 생성
extension ReportViewController{
    private func createDummyData() -> [String: [SaverModel]]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let categories = ["카페", "베이커리", "서점", "영화관", "레스토랑", "택시"]
        var dummyData: [String: [SaverModel]] = [:]
        
        for category in categories{
            var entries = [SaverModel]()
            for cnt in 1...30{
                let name = "\(category) 거래 \(cnt)"
                let amount = Double(arc4random_uniform(50000) + 1000) //1000 ~ 51000
                let randomDaysAgo = Int(arc4random_uniform(30))
                let date = Calendar.current.date(byAdding: .day, value: -randomDaysAgo, to: Date())! //오늘 기준으로 랜덤으로 일을 뺀 날짜를 저장
                entries.append(SaverModel(transactionName: name, spendingAmount: amount, transactionDate: date, name: category))
            }
            dummyData[category] = entries
        }
        
        return dummyData
    }
}
