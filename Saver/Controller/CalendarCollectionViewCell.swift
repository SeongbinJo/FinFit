//
//  CalendarCollectionViewCell.swift
//  Saver
//
//  Created by 조성빈 on 6/4/24.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    private var dateFormatter: DateFormatter = DateFormatter()
    private var today: String = ""
    
    var numberOfDayLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.text = "0"
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberLabel
    }()
    
    lazy var amountOfDay: UILabel = {
        let amountLabel = UILabel()
        amountLabel.text = "1,000"
        amountLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        amountLabel.numberOfLines = 2
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        return amountLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        stackView.addArrangedSubview(numberOfDayLabel)
        stackView.addArrangedSubview(amountOfDay)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dateFormatter.dateFormat = "d"
        self.today = self.dateFormatter.string(from: Date())
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            stackView.heightAnchor.constraint(equalToConstant: contentView.frame.height)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .clear
        amountOfDay.textColor = .black
        amountOfDay.text = "-"
    }
    
    // day = 1~31 중 하나의 문자열
    // 'yyyy년 M월 d일'의 String or Date를 넘겨주고 configureCell에서
    // DataController로 필터링해서 데이터를 가져온 다음,
    // 해당 데이터들의 금액의 합을 구해서 amountOfDay에 String값으로 넣어준다!?
    
    // 델리겟 프로토콜을 선언하고 콜렉션 뷰의 셀이 초기화 될때,
    // DataController의 함수들을 HomeViewController(테이블 뷰 extension 내부)에 선언된 델리겟 필수 메서드 안에서 사용하고,
    // configureCell() 내부에서 delegate.method()로 함수 실행.
    // 그럼 의존성 낮출 수 있나..? 유지보수나 재사용성을 보면 델리게이트 패턴을 사용하는게 옳다 -소혜 강사님-
    func configureCell(date: Date, day: Int, isToday: Bool) {
        numberOfDayLabel.text = String(day)
        amountOfDayLabelColor(day: day)
        if isToday && String(day) == self.today {
            contentView.backgroundColor = .systemCyan
        }
        switch day {
        case 0:
            numberOfDayLabel.text = ""
            amountOfDay.text = ""
        default:
            amountOfDay.text = ShareData.shared.getTransactionListOfDay(day: day).count > 0 ? "\(ShareData.shared.totalAmountIndDay(day: day))원" : "-"
        }
    }
    
    func amountOfDayLabelColor(day: Int) {
        let amount = ShareData.shared.totalAmountIndDay(day: day)
        switch amount {
        case ..<0.0:
            amountOfDay.textColor = .red
        case 0.0:
            amountOfDay.textColor = .black
        default:
            amountOfDay.textColor = .blue
        }
    }
    
    //MARK: - 날짜별 spendingAmount 합계(더미데이터 전용)
    // 매개변수의 날짜를 필터링한 후, 내역이 존재하면 reduce로 합산
//    func totalAmountOfDayData(date: Date) -> String {
//        let filteredArray: [SaverModel] = HomeViewController.dummyData.filter { $0.transactionDate == date }
//
//        guard !filteredArray.isEmpty else { return "-" }
//        let result: Double = filteredArray.reduce(0) { $0 + $1.spendingAmount }
//        switch result {
//        case ..<0.0:
//            amountOfDay.textColor = .red
//        case 0.0:
//            amountOfDay.textColor = .black
//        default:
//            amountOfDay.textColor = .blue
//        }
//        return "\(result)원"
//    }
    
}
