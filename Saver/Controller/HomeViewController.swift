//
//  ViewController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit

class HomeViewController: UIViewController, CalendarPopUpViewControllerDelegate {
    static var dummyData: [SaverModel] = [
        SaverModel(transactionName: "Groceries", spendingAmount: -50.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Food"),
        SaverModel(transactionName: "Rent", spendingAmount: -1200.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Housing"),
        SaverModel(transactionName: "Salary", spendingAmount: 2500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Income"),
        SaverModel(transactionName: "Bonus", spendingAmount: 300.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 3).date!, name: "Income"),
        SaverModel(transactionName: "Utilities", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 3).date!, name: "Utilities"),
        SaverModel(transactionName: "Dining Out", spendingAmount: -75.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 4).date!, name: "Food"),
        SaverModel(transactionName: "Subscription", spendingAmount: -15.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 7).date!, name: "Entertainment"),
        SaverModel(transactionName: "Insurance", spendingAmount: -200.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 8).date!, name: "Insurance"),
        SaverModel(transactionName: "Car Payment", spendingAmount: -300.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 9).date!, name: "Transport"),
        SaverModel(transactionName: "Gym Membership", spendingAmount: -50.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Health"),
        SaverModel(transactionName: "Gift", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Other"),
        SaverModel(transactionName: "Freelance", spendingAmount: 500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Income"),
        SaverModel(transactionName: "Lottery", spendingAmount: 1000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 13).date!, name: "Income"),
        SaverModel(transactionName: "Books", spendingAmount: -30.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 15).date!, name: "Entertainment"),
        SaverModel(transactionName: "Medicine", spendingAmount: -25.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 15).date!, name: "Health"),
        SaverModel(transactionName: "Phone Bill", spendingAmount: -60.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 16).date!, name: "Utilities"),
        SaverModel(transactionName: "Internet Bill", spendingAmount: -40.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Utilities"),
        SaverModel(transactionName: "Concert Ticket", spendingAmount: -120.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Entertainment"),
        SaverModel(transactionName: "Bus Pass", spendingAmount: -70.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Transport"),
        SaverModel(transactionName: "Water Bill", spendingAmount: -30.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 20).date!, name: "Utilities")
    ]
    
    private var dateFormatter: DateFormatter = DateFormatter()
    
    private var scrollView: UIScrollView = UIScrollView()
    
    private var currentSpendingAmountLabel: UILabel = UILabel()
    private var addTransactionButton: UIButton = UIButton(type: .system)
    private var titleHStackView: UIStackView = UIStackView()
    
    private var yearMonthButtonLabel: UILabel = UILabel()
    private var changeMonthButton: UIButton = UIButton(type: .system)
    
    private var prevMonthButton: UIButton = UIButton(type: .system)
    private var nextMonthButton: UIButton = UIButton(type: .system)
    private var todayButton: UIButton = UIButton(type: .system)
    private var prevNextButtonStackView: UIStackView = UIStackView()
    
    private var weekDayOfStackView: UIStackView = UIStackView()
    private var calendarCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var calendarCollectionViewHeightConstraint: NSLayoutConstraint!
    private var todayString: String = ""
    private var isToday: Bool = false
    private var calendarView: UIView = UIView()
    
    private var currentDayTitle: UILabel = UILabel()
    private var transactionTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var transactionTableViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        dateFormatter.dateFormat = "yyyy년 M월"
        todayString = dateFormatter.string(from: Date())
        
        CalendarManager.manager.configureCalendar(date: Date())
        CalendarManager.manager.updateDays()
        CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
        checkToday()

        setupTitleHStackView()
        setupScrollView()
        setupchangeMonthButton()
        setupWeekDayOfStackView()
        setupCalendarView()
        setupPrevNextMonthStackView()
        setupTransactionTableView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 레이아웃이 완료된 후 높이 업데이트
        updateCollectionViewHeight()
        updateTableViewHeight()
    }
    
    func checkToday() {
        if self.yearMonthButtonLabel.text == self.todayString {
            self.isToday = true
        }else {
            self.isToday = false
        }
    }
    
    //MARK: - View 관련 Setup
    //MARK: - 스크롤 뷰
    func setupScrollView() {
//        scrollView.backgroundColor = .blue
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleHStackView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    //MARK: - 소비금액 타이틀 & 내역추가 버튼
    func setupTitleHStackView() {
        let currentSpendingAmountLabel = UILabel()
        let dummyTitleAmount = UILabel()
        dummyTitleAmount.text = "100,000,000"
        
        currentSpendingAmountLabel.text = "이번달 소비금액은\n\(dummyTitleAmount.text!)원 입니다."
        currentSpendingAmountLabel.font = UIFont.systemFont(ofSize: 24)
        currentSpendingAmountLabel.numberOfLines = 0
        currentSpendingAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        currentSpendingAmountLabel.backgroundColor = .red
        
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        addTransactionButton.setTitle("내역추가", for: .normal)
        addTransactionButton.configuration = config
        addTransactionButton.addAction(UIAction {_ in
            print("내역추가 버튼 클릭. (현재 테이블 뷰. 셀 관련 액션 테스트 중")
            HomeViewController.dummyData.removeLast()
            self.transactionTableView.reloadData()
        }, for: .touchUpInside)
        addTransactionButton.setContentHuggingPriority(.required, for: .horizontal)

        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        addTransactionButton.backgroundColor = .blue

        titleHStackView.axis = .horizontal
        titleHStackView.distribution = .fill
        titleHStackView.alignment = .top
        titleHStackView.addArrangedSubview(currentSpendingAmountLabel)
        titleHStackView.addArrangedSubview(addTransactionButton)
        titleHStackView.translatesAutoresizingMaskIntoConstraints = false
        titleHStackView.backgroundColor = .yellow
        
        view.addSubview(titleHStackView)
        
        NSLayoutConstraint.activate([
            titleHStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleHStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleHStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    //MARK: - ChangeMonthButton의 configuration
    func ConfigurationChangeMonthButton() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePlacement = .trailing
        config.imagePadding = 5
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 20, weight: .light)
        config.attributedTitle = AttributedString(yearMonthButtonLabel.text ?? "정보없음", attributes: container)
        
        changeMonthButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        changeMonthButton.configuration = config
    }
    
    //MARK: - changeMonthButton setup
    func setupchangeMonthButton() {
        ConfigurationChangeMonthButton()

        changeMonthButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            let calendarPopUpViewController = CalendarPopUpViewController(nibName: nil, bundle: nil)
            calendarPopUpViewController.delegate = self
            calendarPopUpViewController.modalPresentationStyle = .overFullScreen
            present(calendarPopUpViewController, animated: false)
        }, for: .touchUpInside)
        
        changeMonthButton.translatesAutoresizingMaskIntoConstraints = false
        
        changeMonthButton.backgroundColor = .yellow
        
        scrollView.addSubview(changeMonthButton)
        
        NSLayoutConstraint.activate([
            changeMonthButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            changeMonthButton.leadingAnchor.constraint(equalTo: titleHStackView.leadingAnchor),
        ])
    }
    
    //MARK: - PrevMonthButton/NextMonthButton StackView setup
    func setupPrevNextMonthStackView() {
        prevMonthButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        prevMonthButton.addAction(UIAction { _ in
            CalendarManager.manager.prevMonth()
            CalendarManager.manager.configureCalendar(date: CalendarManager.manager.calendarDate)
            CalendarManager.manager.updateDays()
            CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
            self.checkToday()
            // yearMonthButtonLabel로 버튼을 사용 -> config로 title을 지정해주었기 때문에 다시 지정해주어야함.
            self.ConfigurationChangeMonthButton()
            self.calendarCollectionView.reloadData()
        }, for: .touchUpInside)
        nextMonthButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextMonthButton.addAction(UIAction { _ in
            CalendarManager.manager.nextMonth()
            CalendarManager.manager.configureCalendar(date: CalendarManager.manager.calendarDate)
            CalendarManager.manager.updateDays()
            CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
            self.checkToday()
            self.ConfigurationChangeMonthButton()
            self.calendarCollectionView.reloadData()
        }, for: .touchUpInside)
        todayButton.setTitle("Today", for: .normal)
        todayButton.addAction(UIAction { _ in
            CalendarManager.manager.configureCalendar(date: Date())
            CalendarManager.manager.updateDays()
            CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
            self.checkToday()
            self.ConfigurationChangeMonthButton()
            self.calendarCollectionView.reloadData()
        }, for: .touchUpInside)
        
        prevNextButtonStackView.axis = .horizontal
        prevNextButtonStackView.alignment = .center
        prevNextButtonStackView.spacing = 20
        
        prevNextButtonStackView.addArrangedSubview(prevMonthButton)
        prevNextButtonStackView.addArrangedSubview(todayButton)
        prevNextButtonStackView.addArrangedSubview(nextMonthButton)
        
        prevNextButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(prevNextButtonStackView)
        
        NSLayoutConstraint.activate([
            prevNextButtonStackView.topAnchor.constraint(equalTo: changeMonthButton.topAnchor),
            prevNextButtonStackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor)
        ])
    }
    
    //MARK: - 일~토 요일 스택뷰
    func setupWeekDayOfStackView() {
        weekDayOfStackView.axis = .horizontal
        weekDayOfStackView.distribution = .fillEqually
        weekDayOfStackView.alignment = .center
        
        let weekOfDay: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        
        for day in weekOfDay {
            let weekLabel: UILabel = UILabel()
            weekLabel.text = day
            weekLabel.textAlignment = .center
            
            switch day {
            case "일":
                weekLabel.textColor = .red
            case "토":
                weekLabel.textColor = .blue
            default:
                weekLabel.textColor = .black
            }
            
            weekDayOfStackView.addArrangedSubview(weekLabel)
        }
        
        weekDayOfStackView.translatesAutoresizingMaskIntoConstraints = false
        
        weekDayOfStackView.backgroundColor = .green
        
        calendarView.addSubview(weekDayOfStackView)
        
        NSLayoutConstraint.activate([
            weekDayOfStackView.topAnchor.constraint(equalTo: calendarView.topAnchor),
            weekDayOfStackView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            weekDayOfStackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor)
        ])
    }
    
    //MARK: - 캘린더 뷰 setup
    func setupCalendarView() {

        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "CalendarCell")
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calendarCollectionView.backgroundColor = .lightGray
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.backgroundColor = .yellow
        calendarView.addSubview(calendarCollectionView)
        
        NSLayoutConstraint.activate([
            calendarCollectionView.topAnchor.constraint(equalTo: weekDayOfStackView.bottomAnchor, constant: 5),
            calendarCollectionView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            calendarCollectionView.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor),
        ])
        
        calendarCollectionViewHeightConstraint = calendarCollectionView.heightAnchor.constraint(equalToConstant: 0)
        calendarCollectionViewHeightConstraint.isActive = true
        
        scrollView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: changeMonthButton.bottomAnchor, constant: 15),
            calendarView.leadingAnchor.constraint(equalTo: titleHStackView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: titleHStackView.trailingAnchor),
        ])

    }
    
    //MARK: - 콜렉션 뷰 동적 높이 조절
    func updateCollectionViewHeight() {
        let numberOfItems = calendarCollectionView.numberOfItems(inSection: 0)
        let rows = ceil(Double(numberOfItems) / 7.0)
        let cellHeight = self.calendarView.frame.width / 7
        let newHeight = (CGFloat(rows) * cellHeight) + ((rows - 1) * 11)
        
        calendarCollectionViewHeightConstraint.constant = newHeight
    }
    
    //MARK: - 날짜별 Transaction 테이블 뷰
    func setupTransactionTableView() {
        self.dateFormatter.dateFormat = "d일 E요일"
        self.dateFormatter.locale = Locale(identifier: "ko-KR")
        currentDayTitle.text = self.dateFormatter.string(from: Date())
        currentDayTitle.backgroundColor = .brown
        currentDayTitle.translatesAutoresizingMaskIntoConstraints = false
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        transactionTableView.showsVerticalScrollIndicator = false
        transactionTableView.translatesAutoresizingMaskIntoConstraints = false
        
        transactionTableView.backgroundColor = .lightGray
        
        scrollView.addSubview(currentDayTitle)
        scrollView.addSubview(transactionTableView)
        
        NSLayoutConstraint.activate([
            currentDayTitle.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 15),
            currentDayTitle.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            
            transactionTableView.topAnchor.constraint(equalTo: currentDayTitle.bottomAnchor, constant: 10),
            transactionTableView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            transactionTableView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
//            transactionTableView.heightAnchor.constraint(equalToConstant: 100),
            transactionTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        transactionTableViewHeightConstraint = transactionTableView.heightAnchor.constraint(equalToConstant: 0)
        transactionTableViewHeightConstraint.isActive = true
    }
    
    //MARK: - 테이블 뷰 높이 동적 조절
    func updateTableViewHeight() {
        let numberOfRows = transactionTableView.numberOfRows(inSection: 0)
        let rowHeight = 80 // UITableView 델리겟의 row 높이와 맞춰줌
        let newHeight = CGFloat(numberOfRows * rowHeight)
        
        transactionTableViewHeightConstraint.constant = newHeight
    }
    
    //MARK: - 델리게이트 필수 메서드
    // CalendarPopUpViewControllerDelegate 필수 메서드
    func updateCalendar(date: Date) {
        CalendarManager.manager.configureCalendar(date: date)
        CalendarManager.manager.updateDays()
        CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
        self.checkToday()
        // yearMonthButtonLabel로 버튼을 사용 -> config로 title을 지정해주었기 때문에 다시 지정해주어야함.
        ConfigurationChangeMonthButton()
        
        calendarCollectionView.reloadData()
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero // 열 간의 간격을 0으로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calendarView.frame.width / 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let countOfCell = CalendarManager.manager.countOfDays()
        return countOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCollectionViewCell
        let days = CalendarManager.manager.getDays()
        self.dateFormatter.dateFormat = "yyyy년 M월 d일"
        let dateString = self.yearMonthButtonLabel.text! + " \(String(days[indexPath.row]))일"
        let date = self.dateFormatter.date(from: dateString) ?? Date()
        cell.configureCell(date: date, day: days[indexPath.row], isToday: self.isToday)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택한 셀 불러오기
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            if cell.numberOfDayLabel.text == "" {
                print("잘못된 날짜 선택입니다.")
            }else {
                let days = CalendarManager.manager.getDays()
                self.dateFormatter.dateFormat = "yyyy년 M월 d일"
                let dateString = self.yearMonthButtonLabel.text! + " \(String(days[indexPath.row]))일"
                let date = self.dateFormatter.date(from: dateString) ?? Date()
                let weekDayNumber = CalendarManager.manager.weekOfDay(date: date)
                var weekDayString = String(days[indexPath.row]) + "일"
                switch weekDayNumber {
                case 0:
                    weekDayString += " 일요일"
                case 1:
                    weekDayString += " 월요일"
                case 2:
                    weekDayString += " 화요일"
                case 3:
                    weekDayString += " 수요일"
                case 4:
                    weekDayString += " 목요일"
                case 5:
                    weekDayString += " 금요일"
                case 6:
                    weekDayString += " 토요일"
                default:
                    print("default: \(weekDayNumber)")
                }
                self.currentDayTitle.text = weekDayString
            }
        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if HomeViewController.dummyData.count > 0 {
            return HomeViewController.dummyData.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        if HomeViewController.dummyData.count > 0 {
            cell.configureCell(transaction: HomeViewController.dummyData[indexPath.row])
            return cell
        }else {
            cell.configureNilCell()
            return cell
        }
    }
    
    
}
