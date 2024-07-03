//
//  CategoryExpenditureTableViewCell.swift
//  Saver
//
//  Created by 이상민 on 6/5/24.
//

import UIKit

class CategoryExpenditureTableViewCell: UITableViewCell {
    
    //MARK: - Stack(카테고리별 거래명, 거래금액)
    //지출 날짜
    private lazy var categoryTransactionDateLabel: UILabel = {
        let label = UILabel()
        label.font = .saverBody1Regurlar
        label.textColor = .neutral20
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //지출 금액
    private lazy var categoryTransactionAmountLabel: CustomUILabel = {
        let label = CustomUILabel()
        label.font = .saverSubTitleSemibold
        label.textColor = .spendingAmount
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //카테고리명
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .saverBody2Regurlar
        label.textColor = .neutral20
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Satck(지출 금액, 카테고리)
    private lazy var categorySpendingStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [categoryTransactionAmountLabel, categoryLabel])
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //Stack(날짜, 지출 금액, 카테고리)
    private lazy var categoryTransactionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryTransactionDateLabel, categorySpendingStack])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .saverBackground
        contentView.addSubview(categoryTransactionStackView)
        
        NSLayoutConstraint.activate([
            
            //stack(날짜, 거래금액, 거래명)
            categoryTransactionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryTransactionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryTransactionStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryTransactionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
//            Stack(거래 금액, 거래명)
            categorySpendingStack.leadingAnchor.constraint(equalTo: categoryTransactionStackView.leadingAnchor),
            categorySpendingStack.trailingAnchor.constraint(equalTo: categoryTransactionStackView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implementd")
    }
    
    //MARK: - configureCell
    func configureCell(entry: DailyData){
        let foramtter = DateFormatter()
        foramtter.dateFormat = "M월 d일 (E)"
        foramtter.locale = Locale(identifier: "ko_KR")
        
        categoryTransactionDateLabel.text = "\(foramtter.string(from: entry.date))"
        categoryTransactionAmountLabel.text = "\(ShareData.shared.formatNumber(Double(entry.totalAmount)))원"
        categoryLabel.text = entry.saverModels.first?.name
    }
}
