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
        
        let dateTitle = UILabel()
        dateTitle.text = "거래 날짜"
        dateTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let dateSelector = UIStackView()
        // TODO: - 옆으로 넘기는 달력 추가
        
        stackView.addArrangedSubview(dateTitle)
        stackView.addArrangedSubview(dateSelector)
        
        return stackView
    }()
    
    private lazy var transactionDetailView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        
        let transactionDetailTitle = UILabel()
        transactionDetailTitle.text = "거래 내역"
        transactionDetailTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let transactionDetailTextField = UITextField()
        transactionDetailTextField.placeholder = "거래 내역을 입력해주세요."
        
        stackView.addArrangedSubview(transactionDetailTitle)
        stackView.addArrangedSubview(transactionDetailTextField)
        
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
        
        
        // MARK: - 뷰 위치 잡기
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        transactionDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            mainContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            mainContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
        ])
    }
    

    

}
