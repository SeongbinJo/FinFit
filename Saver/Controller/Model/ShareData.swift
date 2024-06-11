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
        saverEntries = []
    }
        
    //SwiftData 가져오기
    func loadSaverEntries(){
        dbController.fetchData { [weak self] (data, error) in
            if let data = data{
                self?.saverEntries = data
            }else{
                fatalError("error: \(error!.localizedDescription)")
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
