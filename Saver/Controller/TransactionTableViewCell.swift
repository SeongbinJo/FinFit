//
//  TransactionTableViewCell.swift
//  Saver
//
//  Created by 조성빈 on 6/6/24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    private var transactionAmount: UILabel = UILabel()
    
    private var transactionCategory: UILabel = UILabel()
    private var transactionName: UILabel = UILabel()
    
    private var editMenuButton: UIButton = UIButton(type: .system)
    
    private var categoryNameHStackView: UIStackView = UIStackView()
    private var labelVStackView: UIStackView = UIStackView()
    private var transactionHStackView: UIStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCategoryNameHStackView()
        setupLabelVStackView()
        setupTransactionHStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCategoryNameHStackView() {
        transactionCategory.text = "[테스트 카테고리]"
        transactionName.text = "테스트 내역 1"
        
        categoryNameHStackView.axis = .horizontal
        categoryNameHStackView.distribution = .equalSpacing
        categoryNameHStackView.alignment = .center
        
        categoryNameHStackView.addArrangedSubview(transactionCategory)
        categoryNameHStackView.addArrangedSubview(transactionName)
    }
    
    func setupLabelVStackView() {
        transactionAmount.text = "+1,000,000 원"
        
        labelVStackView.axis = .vertical
        labelVStackView.distribution = .equalSpacing
        labelVStackView.alignment = .leading
        
        labelVStackView.addArrangedSubview(transactionAmount)
        labelVStackView.addArrangedSubview(categoryNameHStackView)
    }
    
    func setupTransactionHStackView() {
        editMenuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        transactionHStackView.axis = .horizontal
        transactionHStackView.distribution = .fill
        transactionHStackView.alignment = .center
        
        transactionHStackView.addArrangedSubview(labelVStackView)
        transactionHStackView.addArrangedSubview(editMenuButton)
        
        transactionHStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(transactionHStackView)
        
        NSLayoutConstraint.activate([
            transactionHStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            transactionHStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            transactionHStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    //MARK: - SwiftData가 정상 적용되었을 경우 사용할 Cell 초기화 메서드
//    func configureCell(transaction: SaverModel) {
//        let amount = transaction.spendingAmount
//        switch amount {
//        case ..<0:
//            transactionAmount.text = "-\(amount) 원"
//        case 1..<Double.infinity:
//            transactionAmount.text = "+\(amount) 원"
//        default:
//            transactionAmount.text = "0 원"
//        }
//        
//        transactionCategory.text = transaction.name
//        transactionName.text = transaction.transactionName
//    }
    
    //MARK: - 테이블 뷰 셀 표현 테스트용 메서드
    func configureCell() {
        let amount = 1500.0
        switch amount {
        case ..<0:
            transactionAmount.text = "-\(amount) 원"
        case 1..<Double.infinity:
            transactionAmount.text = "+\(amount) 원"
        default:
            transactionAmount.text = "0 원"
        }
        
        transactionCategory.text = "식비"
        transactionName.text = "포켓몬 빵"
    }
}
