import Foundation
import SwiftData

//MARK: - Model
//@Model
class SaverModel: Identifiable{
    var id: UUID = UUID() //티도 안나게 쪼~~~~~~~끔 빠름!(컴파일 시 -> 타입추론시간 절약)
    
    //MARK: - 거래명, 소비(-)/수입(+)/공짜 금액, 거래날짜
    var transactionName: String
    var spendingAmount: Double //달러 일 수도 있음
    var transactionDate: Date
    
    //MARK: - 카테고리
    var name: String
    
    init(transactionName: String, spendingAmount: Double, transactionDate: Date, name: String) {
        self.transactionName = transactionName
        self.spendingAmount = spendingAmount
        self.transactionDate = transactionDate
        self.name = name
    }
}
