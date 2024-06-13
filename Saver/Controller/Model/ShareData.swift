//
//  ShareData.swift
//  Saver
//
//  Created by 이상민 on 6/10/24.
//

import Foundation



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
    
    
}
