//
//  AmountEntry.swift
//  Saver
//
//  Created by 김혜림 on 6/8/24.
//

import UIKit

class TransactionEntry: NSObject, Codable {
    // MARK: - 저장할 정보, 정보 저장소
    let date: Date // 거래일
    let transactionName: String // 거래명
    let amount: Int // 거래금액
    let category: String // 거래 카테고리
    
    init?(date: Date, transactionName: String, amount: Int, category: String) {
        if transactionName.isEmpty || amount < 0 || category.isEmpty {
            return nil
        }
        
        self.date = date
        self.transactionName = transactionName
        self.amount = amount
        self.category = category
    }
    
    // MARK: - Codable
    //: 데이터 저장하고 불러오고(인코딩-저장하고, 디코딩-불러오고)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(date, forKey: .date)
        try container.encode(transactionName, forKey: .transactionName)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
    }
}
