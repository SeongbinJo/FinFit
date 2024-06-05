//
//  ViewController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit

class HomeViewController: UIViewController, CalendarPopUpViewControllerDelegate {
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
    private var calendarView: UIView = UIView()
    
    private var currentDayTitle: UILabel = UILabel()
    private var transactionTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        CalendarManager.manager.configureCalendar(date: Date())
        CalendarManager.manager.updateDays()
        CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)

        setupScrollView()
        setupTitleHStackView()
        setupchangeMonthButton()
        setupWeekDayOfStackView()
        setupCalendarView()
        setupPrevNextMonthStackView()
        setupTransactionTableView()

    }
    
    //MARK: - View 관련 Setup
    //MARK: - 스크롤 뷰
    func setupScrollView() {
        scrollView.backgroundColor = .blue

        scrollView.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
            print("hi")
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
        
        scrollView.addSubview(titleHStackView)
        
        NSLayoutConstraint.activate([
            titleHStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleHStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            titleHStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
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
            changeMonthButton.topAnchor.constraint(equalTo: titleHStackView.bottomAnchor, constant: 25),
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
            // yearMonthButtonLabel로 버튼을 사용 -> config로 title을 지정해주었기 때문에 다시 지정해주어야함.
            self.ConfigurationChangeMonthButton()
            self.calendarCollectionView.reloadData()
        }, for: .touchUpInside)
        todayButton.setTitle("Today", for: .normal)
        todayButton.addAction(UIAction { _ in
            CalendarManager.manager.configureCalendar(date: Date())
            CalendarManager.manager.updateDays()
            CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
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
            calendarCollectionView.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor)
        ])
        
        scrollView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: changeMonthButton.bottomAnchor, constant: 15),
            calendarView.leadingAnchor.constraint(equalTo: titleHStackView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: titleHStackView.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    //MARK: - 날짜별 Transaction 테이블 뷰
    func setupTransactionTableView() {
        currentDayTitle.text = "dd일 요일"
        currentDayTitle.backgroundColor = .brown
        currentDayTitle.translatesAutoresizingMaskIntoConstraints = false
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        transactionTableView.translatesAutoresizingMaskIntoConstraints = false
        
        transactionTableView.backgroundColor = .lightGray
        
        view.addSubview(currentDayTitle)
        view.addSubview(transactionTableView)
        
        NSLayoutConstraint.activate([
            currentDayTitle.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 15),
            currentDayTitle.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            currentDayTitle.heightAnchor.constraint(equalToConstant: 400)
            
        ])
    }
    
    //MARK: - 기능 메서드
    // CalendarPopUpViewControllerDelegate 필수 메서드
    func updateCalendar(date: Date) {
        print("요기요기 : \(date)")
        CalendarManager.manager.configureCalendar(date: date)
        CalendarManager.manager.updateDays()
        CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
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
        return CGSize(width: width, height: width * 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CalendarManager.manager.countOfDays()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCollectionViewCell
        let days = CalendarManager.manager.getDays()
        cell.configureCell(day: days[indexPath.row])
        return cell
    }
    
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        return cell
    }
    
    
}
