//
//  TransactionTableViewCell.swift
//  Saver
//
//  Created by 조성빈 on 6/6/24.
//

import UIKit


protocol TransactionTableViewButtonDelegate: NSObject {
    func deleteTransaction(transaction: SaverModel) -> ()
    func editTransaction(transaction: SaverModel) -> ()
    
    func saveTransactionInAddView(transaction: SaverModel) -> ()
    func editTransactionInAddView(oldTransactoin: SaverModel, newTransaction: SaverModel) -> ()
}

class TransactionTableViewCell: UITableViewCell {
    //MARK: - Delegate
    weak var delegate: TransactionTableViewButtonDelegate?
    
    private var transaction: SaverModel?
    
    //MARK: - 리스트 셀
    private var transactionAmount: UILabel = UILabel()
    
    private var transactionCategory: UILabel = UILabel()
    private var transactionName: UILabel = UILabel()
    
    private var editMenuButton: UIButton = UIButton(type: .system)
    
    private var categoryNameHStackView: UIStackView = UIStackView()
    private var labelVStackView: UIStackView = UIStackView()
    private var transactionHStackView: UIStackView = UIStackView()
    
    //MARK: - 리스트 없을 경우의 셀 표현
    private var nilLabel: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCategoryNameHStackView()
        setupLabelVStackView()
        setupTransactionHStackView()
        
        setupNilLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        // 셀 재사용시 이전 셀의 잔재가 있을경우 여기서 초기화 시켜준다!
        nilLabel.text = ""
        editMenuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    //MARK: - 리스트 셀
    func setupCategoryNameHStackView() {
        transactionCategory.text = "[테스트 카테고리]"
        transactionName.text = "테스트 내역 1"
        
        categoryNameHStackView.axis = .horizontal
        categoryNameHStackView.distribution = .equalSpacing
        categoryNameHStackView.spacing = 10
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
        let editMenu: UIAction = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { action in
            self.delegate?.editTransaction(transaction: self.transaction ?? SaverModel(transactionName: "nil", spendingAmount: 0.0, transactionDate: Date(), name: "nil"))
            print("수정 클릭")
        }
        let removeMenu: UIAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            self.delegate?.deleteTransaction(transaction: self.transaction ?? SaverModel(transactionName: "nil", spendingAmount: 0.0, transactionDate: Date(), name: "nil"))
            print("삭제 클릭")
        }
        let menu: UIMenu = UIMenu(options: .displayInline, children: [editMenu, removeMenu])
        editMenuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        editMenuButton.menu = menu
        editMenuButton.showsMenuAsPrimaryAction = true
        
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
    
    //MARK: - SwiftData가 정상 적용되었을 경우 사용할 Cell 초기화 메서드(현재 더미데이터 사용)
    func configureCell(transaction: SaverModel) {
        let amount = transaction.spendingAmount
        let amountString = ShareData.shared.formatNumber(amount)
        switch amount {
        case ..<0:
            transactionAmount.text = "\(amountString) 원"
//            transactionAmount.textColor = .red
        case 1..<Double.infinity:
            transactionAmount.text = "+\(amountString) 원"
//            transactionAmount.textColor = .blue
        default:
            transactionAmount.text = "0 원"
        }
        
        transactionCategory.text = transaction.name != "" ? "[\(transaction.name)]" : "[Empty]"
        transactionName.text = transaction.transactionName
        
        self.transaction = transaction
    }
    
    
    
    //MARK: - 리스트 내역 없을경우의 셀 setup
    func setupNilLabel() {
        nilLabel.text = ""
        nilLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nilLabel)
        NSLayoutConstraint.activate([
            nilLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nilLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configureNilCell() {
        transactionName.text = ""
        transactionAmount.text = ""
        transactionCategory.text = ""
        editMenuButton.setImage(nil, for: .normal)
        nilLabel.text = "내역이 존재하지 않습니다."
    }
    
    //MARK: - 테이블 뷰 셀 표현 테스트용 메서드
//    func configureCell() {
//        let amount = 1500.0
//        switch amount {
//        case ..<0:
//            transactionAmount.text = "-\(amount) 원"
//        case 1..<Double.infinity:
//            transactionAmount.text = "+\(amount) 원"
//        default:
//            transactionAmount.text = "0 원"
//        }
//        
//        transactionCategory.text = "[식비]"
//        transactionName.text = "포켓몬 빵"
//    }
}
