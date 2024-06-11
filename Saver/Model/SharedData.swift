//
//  SharedData.swift
//  Saver
//
//  Created by 조성빈 on 6/10/24.
//

import Foundation

class ShareData{
    static let shared = ShareData()
    let dbController = DBController.shared
    
    private var saverEntries: [SaverModel]
    private var addTestEntries: [SaverModel]
    private var monthTransactionData: [SaverModel]
    
    private init(){
        saverEntries = [
            SaverModel(transactionName: "Groceries", spendingAmount: 5000, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 5, day: 30).date!, name: "Food"),
            SaverModel(transactionName: "Rent", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Housing"),
            SaverModel(transactionName: "Salary", spendingAmount: 2500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 13).date!, name: "Income"),
            SaverModel(transactionName: "Bonus", spendingAmount: 1000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 13).date!, name: "Income"),
            SaverModel(transactionName: "Utilities", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 11).date!, name: "Utilities"),
            SaverModel(transactionName: "Dining Out", spendingAmount: -75.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 11).date!, name: "Food"),
        ]
        addTestEntries = [
            SaverModel(transactionName: "Groceries", spendingAmount: 500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 11).date!, name: "Food"),
        ]
        monthTransactionData = []
//      dbController.insertData(data: saverEntries)
    }
    
    //SwiftData 가져오기
    func loadSaverEntries(){
        dbController.fetchData { [weak self] (data, error) in
            if let data = data{
                self?.saverEntries = data
            }
        }
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
    func totalAmountInMonth() -> Double {
        let totalAmount = self.monthTransactionData.reduce(0) { $0 + $1.spendingAmount }
        print(monthTransactionData.count)
        for i in self.monthTransactionData {
            print(i.spendingAmount)
        }
        return totalAmount
    }
    
    // 특정 날짜의 합계금액
    func totalAmountIndDay(day: Int) -> Double {
        let totalAmount = self.getTransactionListOfDay(day: day).reduce(0) { $0 + $1.spendingAmount }
        return totalAmount
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
    
    // DataController insert 테스트
    func insertTestEntries() {
        dbController.insertData(data: self.addTestEntries)
    }
}
