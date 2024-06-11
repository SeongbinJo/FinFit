//
//  ShareData.swift
//  Saver
//
//  Created by 이상민 on 6/10/24.
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
    
    private init(){
        saverEntries = [
            SaverModel(transactionName: "Groceries", spendingAmount: 5000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 5, day: 30).date!, name: "Food"),
            SaverModel(transactionName: "Rent", spendingAmount: -1200.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Housing"),
            SaverModel(transactionName: "Salary", spendingAmount: 2500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Income"),
            SaverModel(transactionName: "Bonus", spendingAmount: 100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Income"),
            SaverModel(transactionName: "Utilities", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Utilities"),
            SaverModel(transactionName: "Dining Out", spendingAmount: -75.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Food"),
            SaverModel(transactionName: "Subscription", spendingAmount: -15.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Entertainment"),
            SaverModel(transactionName: "Insurance", spendingAmount: -200.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Insurance"),
            SaverModel(transactionName: "Car Payment", spendingAmount: -300.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 1).date!, name: "Transport"),
            SaverModel(transactionName: "Gym Membership", spendingAmount: -50.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Health"),
            SaverModel(transactionName: "Gift", spendingAmount: -500000000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Other"),
            SaverModel(transactionName: "Freelance", spendingAmount: 500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 10).date!, name: "Income"),
            SaverModel(transactionName: "Lottery", spendingAmount: 1000.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 11).date!, name: "Income"),
            SaverModel(transactionName: "Books", spendingAmount: -30.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 15).date!, name: "Entertainment"),
            SaverModel(transactionName: "Medicine", spendingAmount: -25.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 15).date!, name: "Health"),
            SaverModel(transactionName: "Phone Bill", spendingAmount: -60.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 16).date!, name: "Utilities"),
            SaverModel(transactionName: "Internet Bill", spendingAmount: -40.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Utilities"),
            SaverModel(transactionName: "Concert Ticket", spendingAmount: -120.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Entertainment"),
            SaverModel(transactionName: "Bus Pass", spendingAmount: -70.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 18).date!, name: "Transport"),
            SaverModel(transactionName: "Water Bill", spendingAmount: -30.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 6, day: 20).date!, name: "Utilities"),
            SaverModel(transactionName: "Groceries", spendingAmount: -50.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 1).date!, name: "Food"),
            SaverModel(transactionName: "Rent", spendingAmount: -1200.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 1).date!, name: "Housing"),
            SaverModel(transactionName: "Salary", spendingAmount: 2500.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 5, day: 1).date!, name: "Income"),
            SaverModel(transactionName: "Bonus", spendingAmount: 100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 7, day: 1).date!, name: "Income"),
            SaverModel(transactionName: "Utilities", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 12, day: 1).date!, name: "Utilities"),
            SaverModel(transactionName: "medical", spendingAmount: -100.0, transactionDate: DateComponents(calendar: Calendar.current, year: 2024, month: 4, day: 1).date!, name: "hospitial"),
        ]
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
    func getMonthSaverEntries(month: Int) -> [SaverModel]{
        saverEntries.filter{ data in
            let components = Calendar(identifier: .gregorian).dateComponents([.month], from: data.transactionDate)
            return components.month == month
        }
    }
}
