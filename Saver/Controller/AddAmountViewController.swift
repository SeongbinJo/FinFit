//
//  AddAmountViewController.swift
//  Saver
//
//  Created by 김혜림 on 6/4/24.
//

import UIKit

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
    
    private lazy var transactionDetailView: UIStackView = {
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
    
    private lazy var transactionCategory: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        
        let title = UILabel()
        title.text = "거래 카테고리"
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // TODO: - 카테고리 목록 만들기(어디서 어떻게 받아오지..?)
        
        stackView.addArrangedSubview(title)
        
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
                                                           action: #selector(cancle))
        
        
        // MARK: - 뷰 붙이기
        view.addSubview(self.mainContainer)
        
        mainContainer.addArrangedSubview(titleView)
        mainContainer.addArrangedSubview(dateView)
        mainContainer.addArrangedSubview(transactionDetailView)
        mainContainer.addArrangedSubview(transactionAmount)
        mainContainer.addArrangedSubview(transactionCategory)
        
        
        // MARK: - 뷰 위치 잡기
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        transactionDetailView.translatesAutoresizingMaskIntoConstraints = false
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
    // TODO: - 거래 내역 저장 메소드
    @objc func save() {
        guard let title = titleView.text, !title.isEmpty else {
            return
        }
    }
    
    @objc func cancle() {
        dismiss(animated: true)
    }
    
    // TODO: - 시간나면: 키보드 올라가면 화면 올라가는 메소드(봐서 겹치면)
    // TODO: - 시간나면: 아무 곳이나 탭하면 키보드 내려가는 메소드

}
