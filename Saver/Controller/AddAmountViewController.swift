//
//  AddAmountViewController.swift
//  Saver
//
//  Created by 김혜림 on 6/4/24.
//

import UIKit

class AddAmountViewController: UIViewController {
    
    //MARK: - 저장되어있는 내역의 수정 버튼을 눌러 들어온 경우
    var transaction: SaverModel?
    
    // MARK: - 변수
    let dbController = DBController.shared
    var testCategories: [String] = ["test1", "test2", "test3", "test4", "test5", "test6"]
    var selectCategoryName: String?
    
    
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
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    // 스크롤
    private lazy var transactionCategoryScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(transactionCategoryButton)
        
        return scroll
    }()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // TODO: - 정보 다 입력하기 전에 버튼 비활성화 되도록
        // TODO: - 채우지 않은 항목 있으면 경고창 뜨도록
        // save 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(save))
        
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
            transactionCategoryScroll.topAnchor.constraint(equalTo: transactionCategoryViewTitle.bottomAnchor, constant: 16),
            transactionCategoryScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            transactionCategoryScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            transactionCategoryScroll.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            transactionCategoryScroll.heightAnchor.constraint(equalToConstant: 40),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionCategoryButton
            transactionCategoryButton.topAnchor.constraint(equalTo: transactionCategoryScroll.topAnchor),
            transactionCategoryButton.leadingAnchor.constraint(equalTo: transactionCategoryScroll.leadingAnchor, constant: 24),
            transactionCategoryButton.trailingAnchor.constraint(equalTo: transactionCategoryScroll.trailingAnchor),
            transactionCategoryButton.bottomAnchor.constraint(equalTo: transactionCategoryScroll.bottomAnchor),
            transactionCategoryButton.heightAnchor.constraint(equalTo: transactionCategoryScroll.heightAnchor)
        ])
    }
    
    
    // MARK: - 메소드
    // MARK: - 메소드 > 카테고리 버튼 생성
    func categoryButtonCreated(labels: [String]) {
        // MARK: - 메소드 > 카테고리 버튼 생성 > 카테고리 추가 버튼 생성
        // TODO: - 중복 버튼 추가 안되도록
        // 카테고리 추가 버튼 생성
        let categoryAddButton = UIButton(type: .system)
        categoryAddButton.setTitle("추가", for: .normal)
        
        // 카테고리 추가 버튼 스타일
        var categoryAddConfig = UIButton.Configuration.filled()
        categoryAddConfig.baseBackgroundColor = .white
        categoryAddConfig.baseForegroundColor = .systemCyan
        categoryAddConfig.background.strokeColor = .systemBlue
        categoryAddConfig.background.strokeWidth = 1
        categoryAddConfig.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        categoryAddConfig.cornerStyle = .capsule
        categoryAddConfig.buttonSize = .medium
        
        categoryAddButton.configuration = categoryAddConfig
        
        // 추가 버튼 동작
        categoryAddButton.addAction(UIAction { _ in
            // 알림창 생성
            let categoryAddAlert = UIAlertController(title: "카테고리 추가", message: "새로 추가할 카테고리를 입력해주세요.", preferredStyle: .alert)
            
            // 입력창 추가
            categoryAddAlert.addTextField { textField in
                textField.placeholder = "추가할 카테고리 이름"
            }
            
            // 입력창 취소
            let categoryAddCancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            // 카테고리 추가
            let categoryAddSave = UIAlertAction(title: "추가", style: .default) { save in
                // 입력된 값 변수에 담기
                if let alertTextField = categoryAddAlert.textFields?.first,
                   let newCategory = alertTextField.text {
                    // 배열에 값 추가
                    self.testCategories.append(newCategory)
                    
                    // 기존 버튼 삭제
                    self.transactionCategoryButton.arrangedSubviews.forEach { $0.removeFromSuperview() }
                    
                    // 버튼 리로드
                    self.categoryButtonCreated(labels: self.testCategories)
                }
            }
            
            // 취소/추가 버튼 입력창에 추가하기
            categoryAddAlert.addAction(categoryAddCancle)
            categoryAddAlert.addAction(categoryAddSave)
            
            self.present(categoryAddAlert, animated: true, completion: nil)
        }, for: .touchUpInside)
        
        
        transactionCategoryButton.addArrangedSubview(categoryAddButton)
        
        // MARK: - 메소드 > 카테고리 버튼 생성 > 카테고리 버튼 생성
        var buttons: [UIButton] = [] // 버튼 배열 생성, 아래 for-in으로 생성된 버튼을 담을 배열
        
        // 카테고리 버튼 생성
        for category in labels {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
        
            // 버튼 스타일
            var defaultConfig = UIButton.Configuration.filled()
            defaultConfig.baseBackgroundColor = .systemBlue
            defaultConfig.baseForegroundColor = .white
            defaultConfig.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
            defaultConfig.cornerStyle = .capsule
            defaultConfig.buttonSize = .medium
            
            button.configuration = defaultConfig
            
            transactionCategoryButton.addArrangedSubview(button)
            buttons.append(button)
            
            // 버튼 동작
            button.addAction(UIAction { _ in
                // 모든 버튼 색상 초기화
                for btn in buttons {
                    btn.configuration?.baseBackgroundColor = .systemBlue
                    btn.configuration?.baseForegroundColor = .white
                }
                // 모든 버튼 색상 초기화 후 선택된 버튼만 색상 변경
                button.configuration?.baseBackgroundColor = .systemRed
                button.configuration?.baseForegroundColor = .white
                
                // 선택된 버튼 이름 저장
                self.selectCategoryName = ""
                self.selectCategoryName = button.titleLabel?.text
            }, for: .touchUpInside)
            
        }
        
    }
    
    @objc func save() {
        guard let transactionName = transactionNameViewTextField.text, // 거래명 담을 변수
              let spendingAmountTextField = transactionAmountViewTextField.text // 거래금액 담을 변수
        /*나중에 카테고리 받아온걸로 변경 let transactionCategory = transactionCategory*/ else {
            return
        }
        
        // 데이터 유형 불일치 해결 위해 추가
        // 카테고리 변환하는 코드 추가 필요
        guard let spendingAmount = Double(spendingAmountTextField) else { // text로 받아온 값의 데이터 유형 변경
            return
        }
        
        guard let transactionDate = dateView.subviews.compactMap({ $0 as? UIDatePicker }).first?.date else {
            return
        }
        
        let addTransaction = [SaverModel(transactionName: transactionName, // 거래명
                                        spendingAmount: spendingAmount, // 거래금액
                                        transactionDate: transactionDate, // 거래날짜
                                        name: selectCategoryName ?? "") // 카테고리
                              ]
        
        DBController.shared.insertData(data: addTransaction)
        dismiss(animated: true)
//        print(addTransaction.transactionName)
//        print(addTransaction.spendingAmount)
//        print(addTransaction.transactionDate)
//        print(addTransaction.name)
    }
    
    // TODO: - 키보드 올라오면 텍스트 입력창 올라가도록 하기
    // TODO: - 화면 아무곳이나 터치하면 키보드 내려가게 하기
}
