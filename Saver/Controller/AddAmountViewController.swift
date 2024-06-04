//
//  AddAmountViewController.swift
//  Saver
//
//  Created by 김혜림 on 6/4/24.
//

import UIKit

class AddAmountViewController: UIViewController {
    
    // MARK: - 뷰
    private lazy var mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 40
        
        return stackView
    }()
    
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
        
        let dateSelector = UIStackView()
        // TODO: - 옆으로 넘기는 달력 추가
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(dateSelector)
        
        return stackView
    }()
    
    private lazy var transactionDetailView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 18
        
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
        stackView.spacing = 18
        
        let title = UILabel()
        title.text = "거래 금액"
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let textField = UITextField()
        textField.placeholder = "거래 금액을 입려해주세요."
        
        // TODO: - 숫자 키보드만 나오도록
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(textField)
        
        return stackView
    }()
    
    private lazy var transactionCategory: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 18
        
        let title = UILabel()
        title.text = "거래 카테고리"
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // TODO: - 카테고리 목록 만들기
        
        stackView.addArrangedSubview(title)
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: .none)
        // TODO: - 뒤로가기 추가 필요(dismis..?)
        
        
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

}
