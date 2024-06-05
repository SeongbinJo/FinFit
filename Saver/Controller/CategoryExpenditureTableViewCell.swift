//
//  CategoryExpenditureTableViewCell.swift
//  Saver
//
//  Created by 이상민 on 6/5/24.
//

import UIKit

class CategoryExpenditureTableViewCell: UITableViewCell {
    
    //MARK: - Stack(카테고리별 거래명, 거래금액)
    //거래금액
    private lazy var categoryTransactionAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "+19000원"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //거래명
    private lazy var categoryTransactionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "000에게 받음"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Stack(카테고리별 거래명, 금액)
    private lazy var categoryTransactionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryTransactionAmountLabel, categoryTransactionNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(categoryTransactionStackView)
        
        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            //stack(거래금액, 거래명)
            categoryTransactionStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            categoryTransactionStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            categoryTransactionStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implementd")
    }
    
    //MARK: - configureCell
    func configureCell(entry: SaverModel){
        categoryTransactionAmountLabel.text = "\(Int(entry.spendingAmount))원"
        categoryTransactionNameLabel.text = entry.transactionName
    }
}
