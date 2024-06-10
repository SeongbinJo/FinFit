//
//  AddAmountViewController.swift
//  Saver
//
//  Created by 김혜림 on 6/4/24.
//

import UIKit

class AddAmountViewController: UIViewController {
    
    // MARK: - 변수
    let dbController = DBController.shared
    var testCategories: [String] = ["test1", "test2", "test3", "test4", "test5", "test6"]
    
    
    // MARK: - view(뷰 타이틀)
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "소비 내역 추가"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    //MARK: - view(거래날짜)
    // 거래 날짜 총괄
    private lazy var dateView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(dateViewTitle)
        stack.addArrangedSubview(dateViewDateSelect)
        
        return stack
    }()
    
    // 거래 날짜 타이틀
    private lazy var dateViewTitle: UILabel = {
        let label = UILabel()
        label.text = "거래 날짜"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // 거래 날짜 선택
    private lazy var dateViewDateSelect: UIDatePicker = {
        let date = UIDatePicker()
        date.locale = Locale(identifier: "ko_kr")
        date.datePickerMode = .date
        date.translatesAutoresizingMaskIntoConstraints = false
        
        return date
    }()
    
    
    // TODO: - view(거래 유형(수입/지출))
    
    
    // MARK: - view(거래명)
    // 거래명 총괄
    private lazy var transactionNameView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(transationNameViewTitle)
        stack.addArrangedSubview(transactionNameViewTextField)
        
        return stack
    }()
    
    // 거래명 타이틀
    private lazy var transationNameViewTitle: UILabel = {
        let label = UILabel()
        label.text = "거래 내역"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // 거래명 작성
    private lazy var transactionNameViewTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "거래 내역을 입력해주세요."
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    
    // MARK: - view(거래 금액)
    // 거래 금액 총괄
    private lazy var transactionAmountView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(transactionAmountViewTitle)
        stack.addArrangedSubview(transactionAmountViewTextField)
        
        return stack
    }()
    
    // 거래 금액 타이틀
    private lazy var transactionAmountViewTitle: UILabel = {
        let label = UILabel()
        label.text = "거래 금액"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // 거래 금액 입력창
    private lazy var transactionAmountViewTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "거래 금액을 입력해주세요."
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    
    // MARK: - view(카테고리 선택)
    // 카테고리 타이틀
    private lazy var transactionCategoryViewTitle: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // 카테고리 버튼
    private lazy var transactionCategoryButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        
        return stack
    }()
    
    // 스크롤
    private lazy var transactionCategoryScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(transactionCategoryButton)
        scroll.backgroundColor = .yellow
        
        return scroll
    }()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        // MARK: - viewDidLoad > 오토 레이아웃 허가
        titleView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        transactionNameView.translatesAutoresizingMaskIntoConstraints = false
        transactionAmountView.translatesAutoresizingMaskIntoConstraints = false
        transactionCategoryViewTitle.translatesAutoresizingMaskIntoConstraints = false
        transactionCategoryScroll.translatesAutoresizingMaskIntoConstraints = false
        transactionCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // MARK: - viewDidLoad > view 추가
        view.addSubview(titleView)
        view.addSubview(dateView)
        view.addSubview(transactionNameView)
        view.addSubview(transactionAmountView)
        view.addSubview(transactionCategoryViewTitle)
        view.addSubview(transactionCategoryScroll)
        categoryButtonCreated(labels: testCategories)
        
        
        // MARK: - viewDidLoad > 오토 레이아웃
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // MARK: - viewDidLoad > 오토 레이아웃 > titleView
            titleView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > dateView
            dateView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            dateView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionNameView
            transactionNameView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 40),
            transactionNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            transactionNameView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionAmountView
            transactionAmountView.topAnchor.constraint(equalTo: transactionNameView.bottomAnchor, constant: 40),
            transactionAmountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionAmountView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            transactionAmountView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionCategoryViewTitle
            transactionCategoryViewTitle.topAnchor.constraint(equalTo: transactionAmountView.bottomAnchor, constant: 40),
            transactionCategoryViewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionCategoryViewTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            transactionCategoryViewTitle.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionCategoryScroll
            transactionCategoryScroll.topAnchor.constraint(equalTo: transactionCategoryViewTitle.bottomAnchor, constant: 20),
            transactionCategoryScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionCategoryScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            transactionCategoryScroll.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            transactionCategoryScroll.heightAnchor.constraint(equalTo: transactionCategoryButton.heightAnchor, constant: 50),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionCategoryButton
            transactionCategoryButton.topAnchor.constraint(equalTo: transactionCategoryScroll.topAnchor), // 수정
            transactionCategoryButton.leadingAnchor.constraint(equalTo: transactionCategoryScroll.leadingAnchor), // 수정
            transactionCategoryButton.trailingAnchor.constraint(equalTo: transactionCategoryScroll.trailingAnchor), // 수정
            transactionCategoryButton.widthAnchor.constraint(equalTo: transactionCategoryScroll.widthAnchor),
            transactionCategoryButton.heightAnchor.constraint(equalTo: transactionCategoryScroll.heightAnchor)
        ])
    }
    
    
    // MARK: - 메소드
    // MARK: - 메소드(카테고리 버튼 생성)
    func categoryButtonCreated(labels: [String]) {
        for category in labels {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            
            let buttonWidth = button.intrinsicContentSize.width
            button.layer.frame = CGRect(x: 0, y: 0, width: buttonWidth + 20, height: 30)
        
            // 버튼 스타일
            var defaultConfig = UIButton.Configuration.filled()
            defaultConfig.baseBackgroundColor = .systemBlue
            defaultConfig.baseForegroundColor = .white
            defaultConfig.cornerStyle = .capsule
            defaultConfig.background.strokeWidth = 1
            defaultConfig.background.strokeColor = .black
            
            button.configuration = defaultConfig
            
            // 버튼 동작
            button.addAction(UIAction { _ in
                // TODO: - 기존 버튼 스타일 삭제하고 새 스타일 부여
            }, for: .touchUpInside)
            
            transactionCategoryButton.addArrangedSubview(button)
        }
        
    }
}
