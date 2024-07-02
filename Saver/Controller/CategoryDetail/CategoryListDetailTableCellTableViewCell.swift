//
//  CategoryListDetailTableCellTableViewCell.swift
//  Saver
//
//  Created by 이상민 on 6/10/24.
//

import UIKit

class CategoryListDetailTableCellTableViewCell: UITableViewCell {    
    //MARK: - 날짜 표시
    private lazy var dateLabl: UILabel = {
        let label = UILabel()
        label.font = .saverBody1Regurlar
        label.textColor = .neutral20
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 금액 표시
    private lazy var amountLabel: UILabel = {
        let label = CustomUILabel()
        label.font = .saverSubTitleSemibold
        label.textColor = .spendingAmount
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 거래내용
    private lazy var transactionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .saverBody2Regurlar
        label.textColor = .neutral20
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryinfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [amountLabel, transactionNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Stackview(날짜표시, 금액표시, 거래내용)(
    private lazy var categoryItemStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabl, categoryinfoStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .saverBackground
        contentView.addSubview(categoryItemStackView)
//        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
//            categoryItemStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            categoryItemStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categoryItemStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
//            categoryItemStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryItemStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            categoryItemStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dateLabl.leadingAnchor.constraint(equalTo: categoryItemStackView.leadingAnchor),
            dateLabl.trailingAnchor.constraint(equalTo: categoryItemStackView.trailingAnchor),
            dateLabl.topAnchor.constraint(equalTo: categoryItemStackView.topAnchor),
            
            
            amountLabel.leadingAnchor.constraint(equalTo: categoryItemStackView.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: categoryItemStackView.trailingAnchor),
            amountLabel.topAnchor.constraint(equalTo: dateLabl.bottomAnchor, constant: 20),
            
            transactionNameLabel.leadingAnchor.constraint(equalTo: categoryItemStackView.leadingAnchor),
            transactionNameLabel.trailingAnchor.constraint(equalTo: categoryItemStackView.trailingAnchor),
            transactionNameLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 5)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implementd")
    }
    
    //MARK: - configureCell
    func configureCell(entry: SaverModel){
        let foramtter = DateFormatter()
        foramtter.dateFormat = "M월 d일 (E)"
        foramtter.locale = Locale(identifier: "ko_KR")
        
        dateLabl.text = "\(foramtter.string(from: entry.transactionDate))"
        transactionNameLabel.text = entry.transactionName
        amountLabel.text = "\(ShareData.shared.formatNumber(Double(entry.spendingAmount)))원"
    }

}
