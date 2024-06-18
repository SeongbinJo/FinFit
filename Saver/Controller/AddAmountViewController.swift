//
//  AddAmountViewController.swift
//  Saver
//
//  Created by 김혜림 on 6/4/24.
//

import UIKit
import Combine

class AddAmountViewModel: ObservableObject {
    @Published var transactionName: String = ""
    @Published var transactionAmount: String = ""
    @Published var transactionCategory: String = ""
    
    @Published var isValid: Bool = false
    
    private lazy var isTransactionNameEmptyPublisher: AnyPublisher<Bool, Never> = {
        $transactionName.map(\.isEmpty).eraseToAnyPublisher()
    }()
    
    private lazy var isTransactionAmountEmptyPublisher: AnyPublisher<Bool, Never> = {
        $transactionAmount.map(\.isEmpty).eraseToAnyPublisher()
    }()
    
    private lazy var isTransactionCateogryEmptyPublisher: AnyPublisher<Bool, Never> = {
        $transactionCategory.map(\.isEmpty).eraseToAnyPublisher()
    }()
    
    private lazy var isTextFieldValidPublisher: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest3(isTransactionNameEmptyPublisher, isTransactionAmountEmptyPublisher, isTransactionCateogryEmptyPublisher)
            .map {
                return !$0 && !$1 && !$2 }
            .eraseToAnyPublisher()
    }()
    
    init() {
        isTextFieldValidPublisher.assign(to: &$isValid)
    }
}

class AddAmountViewController: UIViewController {
    private let viewModel: AddAmountViewModel = AddAmountViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    weak var delegate: TransactionTableViewButtonDelegate?
    
    // 키보드 관련 탭 제스처
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
    
    //MARK: - 저장되어있는 내역의 수정 버튼을 눌러 들어온 경우
    var transaction: SaverModel?
    
    // MARK: - 변수
    let dbController = DBController.shared
    var testCategories: [String] = ["test1", "test2", "test3", "test4", "test5", "test6"]
    var selectCategoryName: String?
    
    // 지출/수익 세그먼트컨트롤 인덱스 -> 0: 지출, 1: 수익
    var segueIndex: Int?
    
    
    // MARK: - view(뷰 타이틀)
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "거래 내역 추가"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
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
        label.textColor = .neutral5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // 거래 날짜 선택
    private lazy var dateViewDateSelect: UIDatePicker = {
        let date = UIDatePicker()
        date.locale = Locale(identifier: "ko_kr")
        date.datePickerMode = .date
        date.date = transaction?.transactionDate ?? Date()
        date.translatesAutoresizingMaskIntoConstraints = false
        
        return date
    }()
    
    
    // MARK: - view(거래 유형(수입/지출))
    // 지출/수익 총괄
    private lazy var segueStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(segueLabel)
        stack.addArrangedSubview(segueButton)
        
        return stack
    }()
    
    // 지출/수익 라벨
    private var segueLabel: UILabel = {
        let label = UILabel()
        label.text = "거래 타입"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .neutral5
        return label
    }()
    
    // 거래 금액 지출/수익 스위치
    private lazy var segueButton: UISegmentedControl = {
        let button = UISegmentedControl(items: ["지출", "수익"])
        if let transaction = self.transaction, String(transaction.spendingAmount).first != "-" {
            button.selectedSegmentIndex = 1
            self.segueIndex = 1
        }else {
            button.selectedSegmentIndex = 0
            self.segueIndex = 0
        }
        button.addAction(UIAction { [weak self] _ in
            self?.segueIndex = button.selectedSegmentIndex
        }, for: .valueChanged)
        return button
    }()
    
    
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
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // 거래명 작성
    private lazy var transactionNameViewTextField: UITextField = {
        let field = UITextField()
        let placeholderText = "거래 내역을 입력해주세요."
        field.placeholder = placeholderText
        field.text = transaction?.transactionName ?? ""
        field.addAction(UIAction { [weak self] _ in
            self?.viewModel.transactionName = field.text ?? ""
        }, for: .editingChanged)
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .neutral5
        
        // 텍스트필드 디자인
        field.backgroundColor = .neutral80
        field.borderStyle = .roundedRect
        field.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.neutral40])
        
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
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    // 거래 금액 입력창
    private lazy var transactionAmountViewTextField: UITextField = {
        let field = UITextField()
        let placeholderText = "거래 금액을 입력해주세요."
        field.placeholder = placeholderText
        field.delegate = self
        field.addAction(UIAction { [weak self] _ in
            self?.viewModel.transactionAmount = field.text ?? ""
        }, for: .editingChanged)
        if let spendingAmount = transaction?.spendingAmount {
            field.text = String(abs(spendingAmount))
        } else {
            field.text = ""
        }
        
        // 텍스트필드 디자인
        field.backgroundColor = .neutral80
        field.borderStyle = .roundedRect
        field.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.neutral40])
        
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
        label.textColor = .white
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
        
        view.backgroundColor = .saverBackground
        
        view.addGestureRecognizer(tapGesture)
        
        // save 버튼
        let barButtonSystemItem: UIBarButtonItem.SystemItem = (transaction != nil) ? .done : .save
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: barButtonSystemItem,
                                                             target: self,
                                                             action: #selector(save))
        
        viewModel.$isValid
            .sink { isValid in
                self.navigationItem.rightBarButtonItem?.isEnabled = isValid
            }
            .store(in: &cancellables)
        
        // MARK: - viewDidLoad > 오토 레이아웃 허가
        titleView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        transactionNameView.translatesAutoresizingMaskIntoConstraints = false
        transactionAmountView.translatesAutoresizingMaskIntoConstraints = false
        transactionCategoryViewTitle.translatesAutoresizingMaskIntoConstraints = false
        transactionCategoryScroll.translatesAutoresizingMaskIntoConstraints = false
        transactionCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        segueStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // MARK: - viewDidLoad > view 추가
        view.addSubview(titleView)
        view.addSubview(dateView)
        view.addSubview(segueStackView)
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
            
            // MARK: - viewDidLoad > 오토 레이아웃 > segueStackView
            segueStackView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 30),
            segueStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            segueStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // 버튼 사이즈
            segueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            segueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            transactionAmountViewTextField.heightAnchor.constraint(equalToConstant: 45),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > transactionNameView
            transactionNameView.topAnchor.constraint(equalTo: segueStackView.bottomAnchor, constant: 40),
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
            transactionCategoryButton.heightAnchor.constraint(equalTo: transactionCategoryScroll.heightAnchor),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > 텍스트 필드 사이즈
            // MARK: - viewDidLoad > 오토 레이아웃 > 텍스트 필드 사이즈 > transactionNameViewTextField
            transactionNameViewTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionNameViewTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            transactionNameViewTextField.heightAnchor.constraint(equalToConstant: 45),
            
            // MARK: - viewDidLoad > 오토 레이아웃 > 텍스트 필드 사이즈 > transactionAmountViewTextField
            transactionAmountViewTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            transactionAmountViewTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            transactionAmountViewTextField.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    @objc func tapHandler(_ sender: UIView) {
        transactionNameViewTextField.resignFirstResponder()
        transactionAmountViewTextField.resignFirstResponder()
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
        categoryAddConfig.baseBackgroundColor = .neutral80
        categoryAddConfig.baseForegroundColor = .incomeAmount
        categoryAddConfig.background.strokeColor = .incomeAmount
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
            defaultConfig.baseBackgroundColor = .neutral80
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
                    btn.configuration?.baseBackgroundColor = .neutral80
                    btn.configuration?.baseForegroundColor = .white
                }
                // 모든 버튼 색상 초기화 후 선택된 버튼만 색상 변경
                button.configuration?.baseBackgroundColor = .incomeAmount
                button.configuration?.baseForegroundColor = .white
                
                // 선택된 버튼 이름 저장
                self.selectCategoryName = ""
                self.selectCategoryName = button.titleLabel?.text
                self.viewModel.transactionCategory = self.selectCategoryName ?? ""
            }, for: .touchUpInside)
            
        }
        
    }
    
    @objc func save() {
        // 사용자가 작성한 내역(newTransaction)
        if self.segueIndex == 0 { // 지출/수익 구분
            self.transactionAmountViewTextField.text = "-" + (self.transactionAmountViewTextField.text ?? "")
        }
        let transaction: SaverModel = SaverModel(transactionName: self.transactionNameViewTextField.text ?? "", spendingAmount: Double(self.transactionAmountViewTextField.text ?? "0") ?? 0, transactionDate: self.dateViewDateSelect.date, name: self.selectCategoryName ?? "")
        
        // 델리게이트 패턴으로 save/edit
        if self.transaction != nil {
            self.delegate?.editTransactionInAddView(oldTransactoin: self.transaction!, newTransaction: transaction)
        }else {
            self.delegate?.saveTransactionInAddView(transaction: transaction)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
}

extension AddAmountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.transactionAmountViewTextField {
            // 숫자만 포함된 문자열인지 확인
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
