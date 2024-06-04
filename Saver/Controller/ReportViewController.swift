//
//  GoalAmountViewController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit

class ReportViewController: UIViewController {
    
    //MARK: - 지출금액이름
    private lazy var spendingAmountNameLabel: UILabel = {
        let label = UILabel()
        label.text = "5월 지출 금액"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 지출금액
    private lazy var spendingAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "900,000원"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 지출금액이름. 지출금액, 그래프를 담는 stackView
    private lazy var spendingAmountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spendingAmountNameLabel, spendingAmountLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .darkGray
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup(){
//        view.addSubview(spendingAmountNameLabel) //view에 지출금액이름 label 추가
//        view.addSubview(spendingAmountLabel) //view에 지출금액 label 추가
        view.addSubview(spendingAmountStackView)
        
        //오토레이아웃 설정
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            //지출금액이름. 지출금액, 그래프를 담는 stackView
            spendingAmountStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            spendingAmountStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            spendingAmountStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),

            //지출금액이름
            spendingAmountNameLabel.leadingAnchor.constraint(equalTo: spendingAmountStackView.leadingAnchor, constant: 20),
            spendingAmountNameLabel.trailingAnchor.constraint(equalTo: spendingAmountStackView.trailingAnchor, constant: -20),
            spendingAmountNameLabel.topAnchor.constraint(equalTo: spendingAmountStackView.topAnchor, constant: 30),

            
//            //지출금액
            spendingAmountLabel.leadingAnchor.constraint(equalTo: spendingAmountStackView.leadingAnchor, constant: 20),
            spendingAmountLabel.trailingAnchor.constraint(equalTo: spendingAmountStackView.trailingAnchor, constant: -20),
            
        ])
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
