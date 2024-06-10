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
    private var yearMonthData: [SaverModel]
    private var yearMonthDayData: [SaverModel]
    
    private init(){
        saverEntries = [
            SaverModel(transactionName: "Groceries", spendingAmount: 5000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 5, day: 30).date!, name: "Food"),
            SaverModel(transactionName: "Rent", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Housing"),
            SaverModel(transactionName: "Salary", spendingAmount: 2500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 13).date!, name: "Income"),
            SaverModel(transactionName: "Bonus", spendingAmount: 1000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 13).date!, name: "Income"),
            SaverModel(transactionName: "Utilities", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Utilities"),
            SaverModel(transactionName: "Dining Out", spendingAmount: -75.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Food"),
//            SaverModel(transactionName: "Subscription", spendingAmount: -15.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Entertainment"),
//            SaverModel(transactionName: "Insurance", spendingAmount: -200.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Insurance"),
//            SaverModel(transactionName: "Car Payment", spendingAmount: -300.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Transport"),
//            SaverModel(transactionName: "Gym Membership", spendingAmount: -50.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Health"),
//            SaverModel(transactionName: "Gift", spendingAmount: -5000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Other"),
//            SaverModel(transactionName: "Freelance", spendingAmount: 500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Income"),
//            SaverModel(transactionName: "Lottery", spendingAmount: 1000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 11).date!, name: "Income"),
//            SaverModel(transactionName: "Books", spendingAmount: -30.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 15).date!, name: "Entertainment"),
//            SaverModel(transactionName: "Medicine", spendingAmount: -25.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 15).date!, name: "Health"),
//            SaverModel(transactionName: "Phone Bill", spendingAmount: -60.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 16).date!, name: "Utilities"),
//            SaverModel(transactionName: "Internet Bill", spendingAmount: -40.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Utilities"),
//            SaverModel(transactionName: "Concert Ticket", spendingAmount: -120.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Entertainment"),
//            SaverModel(transactionName: "Bus Pass", spendingAmount: -70.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Transport"),
//            SaverModel(transactionName: "Water Bill", spendingAmount: -30.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 20).date!, name: "Utilities"),
//            SaverModel(transactionName: "Groceries", spendingAmount: -50.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 1).date!, name: "Food"),
//            SaverModel(transactionName: "Rent", spendingAmount: -1200.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 1).date!, name: "Housing"),
//            SaverModel(transactionName: "Salary", spendingAmount: 2500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 5, day: 1).date!, name: "Income"),
//            SaverModel(transactionName: "Bonus", spendingAmount: 100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 1).date!, name: "Income"),
//            SaverModel(transactionName: "Utilities", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 12, day: 1).date!, name: "Utilities"),
        ]
        yearMonthData = []
        yearMonthDayData = []
//        dbController.insertData(data: saverEntries)
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
    func getYearMonthSaverEntries(year: Int, month: Int) {
        self.yearMonthData.removeAll()
        let result = saverEntries.filter { data in
            let components = Calendar(identifier: .gregorian).dateComponents([.year, .month], from: data.transactionDate)
            return components.year == year && components.month == month
        }
        self.yearMonthData = result
    }
    
    //특정 달의 날짜 data 분류
    func getYearMonthDaySaverEntries(year: Int, month: Int, day: Int) {
        self.yearMonthDayData.removeAll()
        let result = saverEntries.filter { data in
            let components = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: data.transactionDate)
            return components.year == year && components.month == month && components.day == day
        }
        self.yearMonthDayData = result
    }
    
    func getAllEntries() -> [SaverModel] {
        return self.saverEntries
    }
    
    func getYearMonthData() -> [SaverModel] {
        return self.yearMonthData
    }
    
    func getYearMonthDayData() -> [SaverModel] {
        return self.yearMonthDayData
    }
    
    // 특정 달의 합계금액
    func totalAmountInMonth() -> Double {
        let totalAmount = self.yearMonthData.reduce(0) { $0 + $1.spendingAmount }
        print(yearMonthData.count)
        for i in self.yearMonthData {
            print(i.spendingAmount)
        }
        return totalAmount
    }
    
    // 특정 날짜의 합계금액
    func totalAmountIndDay() -> Double {
        let totalAmount = self.yearMonthDayData.reduce(0) { $0 + $1.spendingAmount }
        return totalAmount
    }
    
    // DataController에서 데이터를 삭제했을 때
    func removeData(transaction: SaverModel) {
        self.yearMonthData
    }
}
