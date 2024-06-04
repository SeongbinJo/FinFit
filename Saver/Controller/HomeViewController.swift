//
//  ViewController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit

class HomeViewController: UIViewController {
    private var currentSpendingAmountLabel: UILabel = UILabel()
    private var addTransactionButton: UIButton = UIButton(type: .system)
    private var titleHStackView: UIStackView = UIStackView()
    
    private var yearMonthButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "yyyy년 M월"
        return label
    }()
    private var changeMonthButton: UIButton = UIButton(type: .system)
    
    private var weekDayOfStackView: UIStackView = UIStackView()
    private var calendarCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var calendarView: UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        CalendarManager.manager.configureCalendar()
        CalendarManager.manager.updateDays()
        CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
        
        setupTitleHStackView()
        setupchangeMonthButton()
        setupWeekDayOfStackView()
        setupCalendarView()
    }
    
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
        
        view.addSubview(titleHStackView)
        
        NSLayoutConstraint.activate([
            titleHStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleHStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleHStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    
    func setupchangeMonthButton() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePlacement = .trailing
        config.imagePadding = 5
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 20, weight: .light)
        config.attributedTitle = AttributedString(yearMonthButtonLabel.text ?? "정보없음", attributes: container)
        
        changeMonthButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        changeMonthButton.configuration = config
        changeMonthButton.translatesAutoresizingMaskIntoConstraints = false
        
        changeMonthButton.backgroundColor = .yellow
        
        view.addSubview(changeMonthButton)
        
        NSLayoutConstraint.activate([
            changeMonthButton.topAnchor.constraint(equalTo: titleHStackView.bottomAnchor, constant: 25),
            changeMonthButton.leadingAnchor.constraint(equalTo: titleHStackView.leadingAnchor),
        ])
    }
    
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
    
    func setupCalendarView() {
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: changeMonthButton.bottomAnchor, constant: 15),
            calendarView.leadingAnchor.constraint(equalTo: titleHStackView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: titleHStackView.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCollectionViewCell
        let days = CalendarManager.manager.getDays()
        cell.configureCell(day: days[indexPath.row])
        return cell
    }
    
    
}
