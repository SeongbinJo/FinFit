//
//  GoalAmountViewController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit
import DGCharts //그래프를 그리기 위한 라이브러리

class ReportViewController: UIViewController {
    
    //MARK: - 1. Stack(지출금액이름, 지출금액)
    //지출금액이름
    private lazy var spendingAmountNameLabel: UILabel = {
        let label = UILabel()
        label.text = "5월 지출 금액"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //지출금액
    private lazy var spendingAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "900,000원"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //지출금액이름, 지출금액을 담는 Stack
    private lazy var spendingAmountStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [spendingAmountNameLabel, spendingAmountLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - 2. Stack(stack(지출금액이름, 지출금액), 그래프)
    //지출금액 그래프
    private lazy var spendingReport: BarChartView = {
       let view = BarChartView()
        view.noDataText = "데이터가 없습니다." //데이터가 없을 시 Text
        view.noDataFont = UIFont.systemFont(ofSize: 20) //데이터가 없을 시 textFont 설정
        view.noDataTextColor = .white //데이터가 없을 시 textColor
        view.backgroundColor = .darkGray //배경화면 색 설정
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //그래프와 stack(지출금액이름, 지출금액)을 담는 Stack
    private lazy var spendingReportStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [spendingAmountStackView, spendingReport])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = .darkGray
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - stackView를 담을 UIView
    private lazy var spendindUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spendingReportStackView)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup(){
//        view.addSubview(spendingAmountNameLabel) //view에 지출금액이름 label 추가
//        view.addSubview(spendingAmountLabel) //view에 지출금액 label 추가
        view.addSubview(spendindUIView)
        
        //오토레이아웃 설정
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            //stackView를 담는 UIView
            spendindUIView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            spendindUIView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            spendindUIView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            
            //StackView(지출금액이름, 지출금액)
            spendingAmountStackView.leadingAnchor.constraint(equalTo: spendindUIView.leadingAnchor, constant: 10),
            spendingAmountStackView.trailingAnchor.constraint(equalTo: spendindUIView.trailingAnchor, constant: -10),
            spendingAmountStackView.topAnchor.constraint(equalTo: spendindUIView.topAnchor, constant: 20),
            
            //StackView(StackView(지출금액이름, 지출금액), 그래프)
            spendingReportStackView.leadingAnchor.constraint(equalTo: spendindUIView.leadingAnchor, constant: 10),
            spendingReportStackView.trailingAnchor.constraint(equalTo: spendindUIView.trailingAnchor, constant: -10),
            spendingReportStackView.bottomAnchor.constraint(equalTo: spendindUIView.bottomAnchor, constant: -20),

            //지출금액이름
            spendingAmountNameLabel.leadingAnchor.constraint(equalTo: spendingAmountStackView.leadingAnchor, constant: 10),
            spendingAmountNameLabel.trailingAnchor.constraint(equalTo: spendingAmountStackView.trailingAnchor, constant: -10),
            

            //지출금액
            spendingAmountLabel.leadingAnchor.constraint(equalTo: spendingAmountStackView.leadingAnchor, constant: 10),
            spendingAmountLabel.trailingAnchor.constraint(equalTo: spendingAmountStackView.trailingAnchor, constant: -10),
            
            
            //지출 그래프
            spendingReport.leadingAnchor.constraint(equalTo: spendingReportStackView
                .leadingAnchor, constant: 10),
            spendingReport.trailingAnchor.constraint(equalTo: spendingReportStackView.trailingAnchor, constant: -10),
            spendingReport.widthAnchor.constraint(equalTo: spendingReportStackView.widthAnchor, constant: -20),
            spendingReport.heightAnchor.constraint(equalTo: spendingReportStackView.widthAnchor, multiplier: 0.6),
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
