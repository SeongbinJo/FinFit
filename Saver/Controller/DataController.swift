//
//  DataController.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//  Created by Minyoung Yoo

import Foundation
import SwiftData

class DBController {
    //set type of datamodel here...
    typealias DataModelType = SaverModel //별칭! SaverModel타입을 DataModelType으로 사용한다.
    
    static var shared = DBController() //싱글톤 패턴으로 인스턴스 생성
    var container: ModelContainer? //바탕화면, 옵셔널로 선언
    var context: ModelContext? //폴더, 옵셔널로 선언
    
    init() {
        do{
            //container 생성자 -> 컨테이너 만들건데 형식은 DataModelType인 나 자신의 형식으로 만들어줘!
            //try사용 이유 ModelContainer는 에러가 발생할 수 있는 throws로 선언되었기때문에
            self.container = try ModelContainer(for: DataModelType.self)
            
            //만약에 컨테이너 생성이 정상적으로 되었다면
            if let container = self.container {
                //context 생성자
                //conext를 만들건데 나는 container안에 포함되게 만들어줘
                self.context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    
    //insert data
    //데이터 등록
    func insertData(data: DataModelType) { //추가할 데이터를 매개변수로 받는다
        //변수에 저장을 하고
        let dataToBeInserted = data
        //데이터를 저장할 폴더가 존재하는지 확인
        if let context = self.context {
            //폴더(context)안에 넘겨받은 파일(data)을 넣는다.
            context.insert(dataToBeInserted)
        }
    }
    
    //fetch data
    //데이터 불러오기
    //이 함수가 끝나면 @escaping 클로저를 실행할거야
    func fetchData(completion: @escaping ([DataModelType]?, Error?) -> ()) {
        //SwiftData기본 문법 -> 보여줄 데이터 목록 선정 및 정렬할 형태를 저장한다.
        let descriptor = FetchDescriptor<DataModelType>( //내가 변형할 형태의 기준은 DataModelType야
            //원하는 목록으로 filter(분류)한다.
//            predicate: #Predicate { $0.title != nil } //need this when filtering 조건
            sortBy: [ //정령 방식
                //transactionDate를 기준으로 냐람처순으로 정렬시켜라
                .init(\.transactionDate, order: .reverse) //reverse 최신것 부터(내림차순), forward 오래된 것 부터(오름차순)
            ]
        )
        
        //파일들을 가져올 폴더가 있는지 확인
        if let context = self.context {
            do {
                //try 사용이유 fetch시 오류를 내뱉을 수 있는 throws로 선언되었기 때문에
                let data = try context.fetch(descriptor) //위에 정한 규칙에 맞는 데이터를 불러와라
                completion(data, nil) //완료 후 completion실행 하기위한 매개변수 넘겨준다. -> 응답 매개변수 data: [DataModelType]?, nil: Error?
            } catch {
                completion(nil, error) //실패 후 completion실행하 기위한 매개변수 넘겨준다.-> 응답 매개변수 nil: [DataModelType]?m error: Error?
            }
            
            /**
             예시
             //넘겨받은 후 closure문으로 데이터 및 오류 처리
             fetchData { (data, error) in
                print(data)
             }
             **/
        }
    }
    
    //update data
    //데이터 수정하기
    //model: 수정 당할놈(맞는 놈), data: 수정할 놈(때리는 놈)
    func updateData(model: SaverModel, data: SaverModel) {
        //replace updating logic here...
        let dataToBeUpdated = model //수정 당할놈 프로퍼티에 저장
        //수정 당할놈의 데이터를 수정할 데이터로 바꾼다.
        dataToBeUpdated.transactionName = data.transactionName
        dataToBeUpdated.spendingAmount = data.spendingAmount
        dataToBeUpdated.transactionDate = data.transactionDate
        dataToBeUpdated.name = data.name
    }
    
    //delete data
    //데이터 삭제
    func deleteData(model: DataModelType) { //삭제할 데이터를 매개변수로 받는다
        //변수에 저장을 하고
        let dataToBeDeleted = model
        //데이터를 식제할 폴더가 존재하는지 확인
        if let context = self.context {
            //폴더(context)안에 넘겨받은 파일(model)을 삭제한다.
            context.delete(dataToBeDeleted)
        }
    }
}

