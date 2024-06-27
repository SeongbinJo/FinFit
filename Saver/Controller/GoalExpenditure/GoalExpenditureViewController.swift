//
//  GoalExpenditureViewController.swift
//  Saver
//
//  Created by 조성빈 on 6/26/24.
//

import UIKit

class GoalExpenditureViewController: UIViewController {
    
    // 스크롤 뷰
    private var scrollView: UIScrollView = UIScrollView()
    private var viewInScrollView: UIStackView = UIStackView()
    
    // 세그먼트 버튼
    private var segmentButton: UISegmentedControl = UISegmentedControl()
    
    // 상단 라벨, 추가버튼
    private var goalCountLabel: UILabel = UILabel()
    private var goalLabel: UILabel = UILabel()
    private var addButton: UIButton = UIButton(type: .system)
    private var goalBoxStackView: UIStackView = UIStackView()
    
    // 구분선
    private var dividingLine: UIView = UIView()
    
    // 리포트, 드롭다운 버튼 스택뷰
    private var goalExpenditureTitleLabel: UILabel = UILabel()
    private var dropDownButton: UIButton = UIButton()
    private var goalExpenditureTitleStackView: UIStackView = UIStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupSegmentButton()
        setupGoalBoxStackView()
        setupDividingLine()
        setupGoalExpenditureTitleStackView()
    }
    
    //MARK: - 최상단 스크롤뷰 setup
    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        viewInScrollView.axis = .vertical
        viewInScrollView.alignment = .center
        viewInScrollView.distribution = .fillEqually
        viewInScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(viewInScrollView)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            viewInScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            viewInScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewInScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            viewInScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            viewInScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            viewInScrollView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    //MARK: - 세그먼트 버튼 setup
    func setupSegmentButton() {
        segmentButton = UISegmentedControl(items: ["지출 목표", "고정 지출"])
        segmentButton.selectedSegmentIndex = 0 // '지출 목표'로 초기화
        segmentButton.addAction(UIAction { [weak self] _ in
            print(self?.segmentButton.selectedSegmentIndex)
        }, for: .valueChanged)
        segmentButton.translatesAutoresizingMaskIntoConstraints = false
        
        viewInScrollView.addSubview(segmentButton)
        
        NSLayoutConstraint.activate([
            segmentButton.topAnchor.constraint(equalTo: viewInScrollView.topAnchor),
            segmentButton.leadingAnchor.constraint(equalTo: viewInScrollView.leadingAnchor, constant: 24),
            segmentButton.trailingAnchor.constraint(equalTo: viewInScrollView.trailingAnchor, constant: -24),
            segmentButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    //MARK: - Goal Text Box setup
    func setupGoalBoxStackView() {
        goalCountLabel.text = "n개"
        goalCountLabel.textColor = .red
        goalLabel.text = "현재 \(goalCountLabel.text ?? "")의 지출 목표가\n설정되어 있습니다."
        goalLabel.font = .systemFont(ofSize: 25)
        goalLabel.numberOfLines = 0
        goalLabel.backgroundColor = .red
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.image = UIImage(systemName: "plus")
        addButton.configuration = buttonConfig
        addButton.addAction(UIAction { [weak self] _ in
            print("addbutton action")
        }, for: .touchUpInside)
        
        goalBoxStackView.axis = .horizontal
        goalBoxStackView.alignment = .top
        goalBoxStackView.distribution = .fill
        goalBoxStackView.backgroundColor = .yellow
        goalBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        
        goalBoxStackView.addArrangedSubview(goalLabel)
        goalBoxStackView.addArrangedSubview(addButton)
        
        viewInScrollView.addSubview(goalBoxStackView)
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 35),
            addButton.heightAnchor.constraint(equalToConstant: 35),
            
            goalBoxStackView.topAnchor.constraint(equalTo: segmentButton.bottomAnchor, constant: 40),
            goalBoxStackView.leadingAnchor.constraint(equalTo: segmentButton.leadingAnchor),
            goalBoxStackView.trailingAnchor.constraint(equalTo: segmentButton.trailingAnchor),
        ])
    }
    
    //MARK: - 구분선 setup
    func setupDividingLine() {
        dividingLine.backgroundColor = .gray
        dividingLine.translatesAutoresizingMaskIntoConstraints = false
        
        viewInScrollView.addSubview(dividingLine)
        
        NSLayoutConstraint.activate([
            dividingLine.topAnchor.constraint(equalTo: goalBoxStackView.bottomAnchor, constant: 30),
            dividingLine.leadingAnchor.constraint(equalTo: viewInScrollView.leadingAnchor),
            dividingLine.trailingAnchor.constraint(equalTo: viewInScrollView.trailingAnchor),
            dividingLine.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    //MARK: - 구분선 아래 '지출목표 리포트 + 드롭다운 버튼' setup
    func setupGoalExpenditureTitleStackView() {
        goalExpenditureTitleLabel.text = "지출 목표 리포트"
        
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .trailing
        config.attributedTitle = AttributedString("이름순")
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        dropDownButton.configuration = config
        dropDownButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        dropDownButton.backgroundColor = .green
        
        goalExpenditureTitleStackView.axis = .horizontal
        goalExpenditureTitleStackView.distribution = .equalSpacing
        goalExpenditureTitleStackView.alignment = .center
        goalExpenditureTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        goalExpenditureTitleStackView.addArrangedSubview(goalExpenditureTitleLabel)
        goalExpenditureTitleStackView .addArrangedSubview(dropDownButton)
        goalExpenditureTitleStackView.backgroundColor = .yellow
        
        viewInScrollView.addSubview(goalExpenditureTitleStackView)
        
        NSLayoutConstraint.activate([
            goalExpenditureTitleStackView.topAnchor.constraint(equalTo: dividingLine.bottomAnchor, constant: 30),
            goalExpenditureTitleStackView.leadingAnchor.constraint(equalTo: goalBoxStackView.leadingAnchor),
            goalExpenditureTitleStackView.trailingAnchor.constraint(equalTo: goalBoxStackView.trailingAnchor)
        ])
    }
    
}
