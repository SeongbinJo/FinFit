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
        amountLabel.text = "1,400,000"
        amountLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        
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
        self.dateFormatter.dateFormat = "yyyy년 M월 d일"
        self.today = self.dateFormatter.string(from: Date())
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureCell(day: String, dateString: String) {
        numberOfDayLabel.text = day
//        if dateString == self.today {
//            contentView.backgroundColor = .red
//        }
        switch day {
        case "":
            amountOfDay.text = ""
        default:
            amountOfDay.text = "-"
        }
    
    }
}
