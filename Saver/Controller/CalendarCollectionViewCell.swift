//
//  CalendarCollectionViewCell.swift
//  Saver
//
//  Created by 조성빈 on 6/4/24.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
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
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureCell(day: String) {
        numberOfDayLabel.text = day
        switch day {
        case "":
            amountOfDay.text = ""
        default:
            amountOfDay.text = "-"
        }
    
    }
}
