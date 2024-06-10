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
    var testCategories: [String] = []
    
    
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
    // 카테고리 버튼
    private lazy var transactionCategoryView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .yellow
        
        return stack
    }()
    
    // 스크롤
    private lazy var testScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(transactionCategoryView)
        
        return scroll
    }()
    
    // 카테고리 타이틀
    private lazy var transactionCategoryViewTitle: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .blue
        
        return label
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
        transactionCategoryView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // MARK: - viewDidLoad > view 추가
        view.addSubview(titleView)
        view.addSubview(dateView)
        view.addSubview(transactionNameView)
        view.addSubview(transactionAmountView)
        categoryButtonCreated(labels: testCategories.map{$0})
        view.addSubview(transactionCategoryView)
        
        
        // MARK: - viewDidLoad > 오토 레이아웃
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // MARK: - viewDidLoad > 오토 레이아웃 > titleView
            titleView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > dateView
            dateView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 40),
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionNameView
            transactionNameView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 40),
            transactionNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionAmountView
            transactionAmountView.topAnchor.constraint(equalTo: transactionNameView.bottomAnchor, constant: 40),
            transactionAmountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionAmountView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionCategoryView
            transactionCategoryView.topAnchor.constraint(equalTo: transactionAmountView.bottomAnchor, constant: 40),
            transactionCategoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionCategoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }
    
    
    // MARK: - 메소드
    // MARK: - 메소드(카테고리 버튼 생성)
    func categoryButtonCreated(labels: [String]) {
        for category in labels {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            
            // 버튼 사이즈
            let buttonSize = button.intrinsicContentSize
            let buttonWidth = buttonSize.width
            let buttonHeight = buttonSize.height
            //button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        
            // 버튼 스타일
            var defaultConfig = UIButton.Configuration.filled()
            defaultConfig.baseBackgroundColor = .systemBlue
            defaultConfig.baseForegroundColor = .white
            defaultConfig.cornerStyle = .capsule
            defaultConfig.buttonSize = .medium
            
            button.configuration = defaultConfig
            
            // 버튼 동작
            button.addAction(UIAction { _ in
                // TODO: - 기존 버튼 스타일 삭제하고 새 스타일 부여
            }, for: .touchUpInside)
            
            transactionCategoryView.addArrangedSubview(button)
        }
        
    }
}
