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
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 거래내용
    private lazy var transactionNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - 금액 표시
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Stackview(날짜표시, 금액표시, 거래내용)(
    private lazy var categoryItemStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabl, transactionNameLabel, amountLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(categoryItemStackView)
        
        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
//            categoryItemStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            categoryItemStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            categoryItemStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            categoryItemStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            dateLabl.leadingAnchor.constraint(equalTo: categoryItemStackView.leadingAnchor),
            dateLabl.trailingAnchor.constraint(equalTo: categoryItemStackView.trailingAnchor),
            
            transactionNameLabel.leadingAnchor.constraint(equalTo: categoryItemStackView.leadingAnchor),
            transactionNameLabel.trailingAnchor.constraint(equalTo: categoryItemStackView.trailingAnchor),
            
            amountLabel.leadingAnchor.constraint(equalTo: categoryItemStackView.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: categoryItemStackView.trailingAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implementd")
    }
    
    //MARK: - configureCell
    func configureCell(entry: SaverModel){
        let foramtter = DateFormatter()
        foramtter.dateFormat = "yyyy-MM-dd (E)"
        foramtter.locale = Locale(identifier: "ko_KR")
        
        dateLabl.text = "\(foramtter.string(from: entry.transactionDate))"
        transactionNameLabel.text = entry.transactionName
        amountLabel.text = "\(Int(entry.spendingAmount))원"
        amountLabel.applySmallSuffixFontStyle()
    }

}
