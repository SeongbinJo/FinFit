//
//  DataController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//  Created

import Foundation
import SwiftData

class DBController {
    //set type of datamodel here...
    typealias DataModelType = SaverModel
    
    static var shared = DBController()
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            self.container = try ModelContainer(for: DataModelType.self)
            if let container = self.container {
                self.context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    
    //insert data
    //데이터 등록
    func insertData(data: DataModelType) {
        let dataToBeInserted = data
        if let context = self.context {
            context.insert(dataToBeInserted)
        }
    }
    
    //fetch data
    //데이터 불러오기
    func fetchData(completion: @escaping ([DataModelType]?, Error?) -> ()) {
        let descriptor = FetchDescriptor<DataModelType>(
//            predicate: #Predicate { $0.title != nil } //need this when filtering
            sortBy: [
                .init(\.transactionDate, order: .reverse) //reverse 최신것 부터, forward 오래된 것 부터
            ]
        )
        if let context = self.context {
            do {
                let data = try context.fetch(descriptor)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    //update data
    //데이터 수정하기
    //model: 수정 당할놈(맞는 놈), data: 수정할 놈(때리는 놈)
    func updateData(model: SaverModel, data: SaverModel) {
        //replace updating logic here...
        let dataToBeUpdated = model
        dataToBeUpdated.transactionName = data.transactionName
        dataToBeUpdated.spendingAmount = data.spendingAmount
        dataToBeUpdated.transactionDate = data.transactionDate
        dataToBeUpdated.name = data.name
    }
    
    //delete data
    //데이터 삭제
    func deleteData(model: DataModelType) {
        let dataToBeDeleted = model
        if let context = self.context {
            context.delete(dataToBeDeleted)
        }
    }
}
