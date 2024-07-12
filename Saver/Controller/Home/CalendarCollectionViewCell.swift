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
    
//    private lazy var amountOfDay: UILabel = {
//        let amountLabel = UILabel()
//        amountLabel.text = "1,000"
//        amountLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
//        amountLabel.numberOfLines = 1
//        amountLabel.translatesAutoresizingMaskIntoConstraints = false
//        return amountLabel
//    }()
    
    private var revenueLabel: UILabel = {
        let label = UILabel()
        label.text = "revenue"
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.numberOfLines = 1
        
        return label
    }()
    
    private var expenditureLabel: UILabel = {
        let label = UILabel()
        label.text = "expenditure"
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.numberOfLines = 1
        
        return label
    }()

    
    private lazy var amountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(revenueLabel)
        stackView.addArrangedSubview(expenditureLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        stackView.addArrangedSubview(numberOfDayLabel)
        stackView.addArrangedSubview(amountStackView)
        
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
        
        revenueLabel.text = "-"
        amountStackView.addArrangedSubview(expenditureLabel)
        expenditureLabel.text = ""
        
        contentView.layer.borderWidth = 0
    }
    
    func configureCell(date: Date, day: Int, isToday: Bool) {
        numberOfDayLabel.text = String(day)
        numberOfDayLabel.textColor = .neutral20
        revenueLabel.textColor = .incomeAmount
        expenditureLabel.textColor = .spendingAmount
//        amountOfDayLabelColor(day: day)
        if isToday && String(day) == self.today {
            contentView.backgroundColor = .neutral60
        }
        switch day {
        case 0:
            numberOfDayLabel.text = ""
            revenueLabel.text = ""
            expenditureLabel.text = ""
//            amountOfDay.text = ""
            print("hi")
        default:
            if ShareData.shared.getTransactionListOfDay(day: day).count > 0 {
                let revenue = ShareData.shared.totalAmountIndDay(day: day).revenueAmount
                let expenditure = ShareData.shared.totalAmountIndDay(day: day).expenditureAmount
                revenueLabel.text = revenue == "0" ? "" :  "+\(ShareData.shared.totalAmountIndDay(day: day).revenueAmount)"
                expenditureLabel.text = expenditure == "0" ? "" : ShareData.shared.totalAmountIndDay(day: day).expenditureAmount
            } else {
                revenueLabel.text = "-"
//                expenditureLabel.text = ""
                expenditureLabel.removeFromSuperview()
            }
        }
    }
    
//    func amountOfDayLabelColor(day: Int) {
//        let amount = ShareData.shared.totalAmountIndDay(day: day).revenueAmount
//        switch amount.first {
//        case "-":
//            amountOfDay.textColor = .spendingAmount
//        case "0":
//            amountOfDay.textColor = .neutral20
//        default:
//            amountOfDay.textColor = .incomeAmount
//        }
//    }
}
