//
//  SharedData.swift
//  Saver
//
//  Created by 조성빈 on 6/10/24.
//

import Foundation

typealias DataEntryType = [String: Category]

struct Category{
    var totalAmount: Double = 0
    var dailyDatas: [DailyData] = []
}

struct DailyData{
    var date: Date
    var totalAmount: Double = 0
    var saverModels: [SaverModel] = []
}

class ShareData{
    static let shared = ShareData()
    let dbController = DBController.shared
    
    private var saverEntries: [SaverModel]
    
    private var monthTransactionData: [SaverModel]

    private var categoriesList: [String]
    
    private init(){
        saverEntries = []
        monthTransactionData = []
        categoriesList = []
    }
    
    //SwiftData 가져오기
    func loadSaverEntries(){
        dbController.fetchData { [weak self] (data, error) in
            if let data = data{
                self?.saverEntries = data
            }
        }
    }
    
    func getSaverEntries() -> [SaverModel] {
        return self.saverEntries
    }
    
    //MARK: - 데이터들 중 카테고리만을 Set으로 가져오기
    func getCategories() -> [String] {
        self.categoriesList.removeAll()
        var result: Set<String> = []
        saverEntries.forEach { entry in
            result.insert(entry.name)
        }
        
        return self.categoriesList
    }
    
    //특정 달 data만 분류하기
    func getYearMonthTransactionData(year: Int, month: Int) {
        loadSaverEntries()
        self.monthTransactionData.removeAll()
        let result = saverEntries.filter { data in
            let components = Calendar(identifier: .gregorian).dateComponents([.year, .month], from: data.transactionDate)
            return components.year == year && components.month == month
        }
        self.monthTransactionData = result
        print("이번달 내역들 : \(self.monthTransactionData)")
    }
    
    //특정 달 data만 분류하기 -report-
    func getMonthSaverEntries(month: Int) -> [SaverModel] {
        saverEntries.filter{ data in
            let components = Calendar(identifier: .gregorian).dateComponents([.month], from: data.transactionDate)
            return components.month == month
        }
    }
    
    // yearMonthData에서 day를 매개변수로 받아서 해당 날짜의 내역들을 리턴하는 메서드
    func getTransactionListOfDay(day: Int) -> [SaverModel] {
        let transactionList = self.monthTransactionData.filter { data in
            let components = Calendar(identifier: .gregorian).dateComponents([.day], from: data.transactionDate)
            return components.day == day
        }
        return transactionList
    }
    
    func getAllEntries() -> [SaverModel] {
        return self.saverEntries
    }
    
    func getYearMonthData() -> [SaverModel] {
        return self.monthTransactionData
    }
    
    // 특정 달의 합계금액
    func totalAmountInMonth() -> String {
        let totalAmount = self.monthTransactionData.reduce(0) { $0 + $1.spendingAmount }
        let amountString = self.formatNumber(totalAmount)
        return amountString
    }
    
    // 특정 날짜의 합계금액
//    func totalAmountIndDay(day: Int) -> String {
//        let totalAmount = self.getTransactionListOfDay(day: day).reduce(0) { $0 + $1.spendingAmount }
//        let amountString: String = self.formatNumber(totalAmount)
//        return amountString
//    }
    
    func totalAmountIndDay(day: Int) -> (revenueAmount: String, expenditureAmount: String, totalAmount: String) {
        let (revenueAmount, expenditureAmount) = self.getTransactionListOfDay(day: day).reduce((0, 0)) { (result, transaction) in
            var (revenueAmount, expenditureAmount) = result
            if transaction.spendingAmount < 0 {
                expenditureAmount += transaction.spendingAmount
            } else {
                revenueAmount += transaction.spendingAmount
            }
            return (revenueAmount, expenditureAmount)
        }

        let revenueString: String = self.formatNumber(revenueAmount)
        let expenditureString: String = self.formatNumber(expenditureAmount)
        let totalString: String = self.formatNumber(revenueAmount + expenditureAmount)

        return (revenueString, expenditureString, totalString)
    }
    
    // DataController에서 데이터를 삭제했을 때
    func removeData(transaction: SaverModel) {
        print("삭제 전")
        print("yearMonthData \(self.monthTransactionData)")

        if let number1 = self.monthTransactionData.firstIndex(of: transaction) {
            self.monthTransactionData.remove(at: number1)
        }
        print("삭제 후")
        print("yearMonthData \(self.monthTransactionData)")

        dbController.deleteData(model: transaction)
    }
    

    func formatNumber(_ value: Double, maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maximumFractionDigits
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
