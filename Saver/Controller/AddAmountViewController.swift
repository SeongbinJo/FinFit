//
//  AddAmountViewController.swift
//  Saver
//
//  Created by 김혜림 on 6/4/24.
//

import UIKit

class CustomButton: UIButton {
    var extraPadding: CGFloat = 20

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + extraPadding, height: size.height + 10)
    }
}

class AddAmountViewController: UIViewController {
    let dbController = DBController.shared
    
    // MARK: - 뷰
    private lazy var mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 40
        
        return stackView
    }()
    
    // TODO: - 지출/수입 버튼 추가
    
    private lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.text = "소비 내역 추가"
        titleView.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        return titleView
    }()
    
    private lazy var dateView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 20
        
        let title = UILabel()
        title.text = "거래 날짜"
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let dateSelector = UIDatePicker()
        dateSelector.datePickerMode = .date
        dateSelector.locale = Locale(identifier: "ko_kr")
        dateSelector.preferredDatePickerStyle = .wheels
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(dateSelector)
        
        return stackView
    }()
    
    private lazy var transactionName: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        
        let tiitle = UILabel()
        tiitle.text = "거래 내역"
        tiitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let textField = UITextField()
        textField.placeholder = "거래 내역을 입력해주세요."
        
        stackView.addArrangedSubview(tiitle)
        stackView.addArrangedSubview(textField)
        
        return stackView
    }()
    
    private lazy var transactionAmount: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        
        let title = UILabel()
        title.text = "거래 금액"
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let textField = UITextField()
        textField.placeholder = "거래 금액을 입려해주세요."
        textField.keyboardType = .numberPad
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(textField)
        
        return stackView
    }()
    
    // TODO: - 실제 카테고리 받아오기
    var testCategories: [String] = ["test1", "test2", "test3"]
    
    private lazy var transactionCategory: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        
        let title = UILabel()
        title.text = "거래 카테고리"
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // 버튼 가로 정렬을 위한 뷰
        let buttonView = UIStackView()
        buttonView.axis = .horizontal
        buttonView.alignment = .fill
        buttonView.distribution = .fillEqually
        buttonView.spacing = 10
        
        // 버튼 생성 함수
        func categoryButtonCreated() {
            for category in testCategories {
                let button = CustomButton(type: .system)
                button.setTitle(category, for: .normal)
                
                // 버튼 사이즈
                let buttonSize = button.intrinsicContentSize
                let buttonWidth = buttonSize.width + 40
                let buttonHeight = buttonSize.height + 10
                button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
                
                // 버튼 스타일
                var defaultConfig = UIButton.Configuration.filled()
                defaultConfig.baseBackgroundColor = .systemBlue
                defaultConfig.baseForegroundColor = .white
                defaultConfig.cornerStyle = .capsule
                
                button.configuration = defaultConfig
                
                // 버튼 동작
                button.addAction(UIAction { _ in
                    // TODO: - 기존 버튼 스타일 삭제하고 새 스타일 부여
                }, for: .touchUpInside)
                
                buttonView.addArrangedSubview(button)
            }
        }
        
        // 카테고리 추가 버튼
        let categoryAddButton = UIButton(type: .system)
        categoryAddButton.setTitle("추가", for: .normal)
        
        // 카테고리 추가 버튼 사이즈
        let buttonSize = categoryAddButton.intrinsicContentSize
        let buttonWidth = buttonSize.width + 40
        let buttonHeight = buttonSize.height + 10
        categoryAddButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        
        // 카테고리 추가 버튼 스타일
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .systemBlue
        config.background.strokeWidth = 1
        config.background.strokeColor = .systemBlue
        config.cornerStyle = .capsule
        
        categoryAddButton.configuration = config
        
        // 카테고리 추가 버튼 동작
        categoryAddButton.addAction(UIAction { _ in
            let alertController = UIAlertController(title: "카테고리 추가", message: "새로 추가할 카테고리 이름을 입력해주세요.", preferredStyle: .alert)
            // 입력창 추가
            alertController.addTextField { textField in
                textField.placeholder = "추가할 카테고리 이름"
            }
            // 입력창 취소
            let alertCancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            // 입력창 저장
            let addCategorySave = UIAlertAction(title: "추가", style: .default) { [self] action in
                // 텍스트 필드에 입력된 값 변수에 담기
                if let textField = alertController.textFields?.first, let newCategory = textField.text {
                    self.testCategories.append(newCategory)
                    
                    // 기존 버튼 삭제
                    buttonView.subviews.forEach { $0.removeFromSuperview() }
                    
                    // 버튼 다시 생성
                    buttonView.addArrangedSubview(categoryAddButton)
                    categoryButtonCreated()
                }
            }
            
            // 취소 저장 버튼 입력창에 붙이기
            alertController.addAction(alertCancle)
            alertController.addAction(addCategorySave)
            
            // 버튼 누르면 입력창 띄우기
            // keyWindow 안 쓰는 방법 찾아보기
            if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }, for: .touchUpInside)
        
        // 버튼 생성
        buttonView.addArrangedSubview(categoryAddButton)
        categoryButtonCreated()
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(buttonView)
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(save))
        
        // 버튼 모양 화살표로 바꾸고 싶음
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancel))
        
        
        // MARK: - 뷰 붙이기
        view.addSubview(self.mainContainer)
        
        mainContainer.addArrangedSubview(titleView)
        mainContainer.addArrangedSubview(dateView)
        mainContainer.addArrangedSubview(transactionName)
        mainContainer.addArrangedSubview(transactionAmount)
        mainContainer.addArrangedSubview(transactionCategory)
        
        
        // MARK: - 뷰 위치 잡기
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        transactionName.translatesAutoresizingMaskIntoConstraints = false
        transactionAmount.translatesAutoresizingMaskIntoConstraints = false
        transactionCategory.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            mainContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            mainContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
        ])
    }
    
    
    // MARK: - 메소드
    // TODO: - 해당 메소드 정상 작동하는지 확인
    @objc func save() {
        guard let transactionNameTextField = transactionName.subviews.compactMap({ $0 as? UITextField }).first,
              let spendingAmountTextField = transactionAmount.subviews.compactMap({ $0 as? UITextField }).first
        /*나중에 카테고리 받아온걸로 변경 let transactionCategory = transactionCategory*/ else {
            return
        }
        
        // 데이터 유형 불일치 해결 위해 추가
        // 카테고리 변환하는 코드 추가 필요
        guard let transactionName = transactionNameTextField.text,
              let spendingAmountText = spendingAmountTextField.text,
              let spendingAmount = Double(spendingAmountText) else {
            return
        }
        
        guard let transactionDate = dateView.subviews.compactMap({ $0 as? UIDatePicker }).first?.date else {
            return
        }
        
        let addTransaction = SaverModel(transactionName: transactionName, // 거래명
                                        spendingAmount: spendingAmount, // 거래금액
                                        transactionDate: transactionDate, // 거래날짜
                                        name: "") // 카테고리
        
        DBController.shared.insertData(data: addTransaction)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // TODO: - 시간나면: 키보드 올라가면 화면 올라가는 메소드(봐서 겹치면)
    // TODO: - 시간나면: 아무 곳이나 탭하면 키보드 내려가는 메소드

}
