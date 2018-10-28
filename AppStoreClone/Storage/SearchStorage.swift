//
//  SearchStorage.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 25..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class SearchStorage {

    /**
     Search API 검색어로 부터 조회 함수
     - parameters:
     - searchText: 검색어
     - success: 성공 block
     - failure: 실패 block
     */
    static func requestSearchList(searchText: String, _ success: @escaping (_ datas: [SearchResultModel]) -> Void, _ failure: @escaping (_ error: Error) -> Void) {
        var parameters: HTTPParameters = [
            "country" : "kr",
            "media" : "software",
            "limit" : 50
        ]
        parameters["term"] = searchText
        
        HTTPManager.shared.requestJSON(URL(string: URLMain.SearchURL), httpMethod: .GET, parameters: parameters, { (data) in
            do {
                let model = try JSONDecoder().decode(SearchModel.self, from: data)

                guard let results = model.results else {
                    return
                }
                
                let filteredResult = results.filter({ (model) -> Bool in
                    return model.bundleId != nil && (model.bundleId?.isEmpty ?? false == false)
                })
                
                success(filteredResult)
            } catch let error as NSError {
                DDLogDebug("Response result error: \(error)")
            }
        }) { (error) in
            failure(error)
        }
    }
    
    /**
     Search API bundleId로 부터 조회 함수
     - parameters:
     - bundleId: bundleId
     - success: 성공 block
     - failure: 실패 block
     */
    static func requestSearchLookup(bundleId: String, _ success: @escaping (_ datas: [SearchResultModel]) -> Void, _ failure: @escaping (_ error: Error) -> Void) {
        var parameters: HTTPParameters = [
            "country" : "kr",
            "media" : "software"
        ]
        parameters["bundleId"] = bundleId
        
        HTTPManager.shared.requestJSON(URL(string: URLMain.LookupURL), httpMethod: .GET, parameters: parameters, { (data) in
            do {
                let model = try JSONDecoder().decode(SearchModel.self, from: data)
                
                guard let results = model.results else {
                    return
                }
                
                success(results)
            } catch let error as NSError {
                DDLogDebug("Response result error: \(error)")
            }
        }) { (error) in
            failure(error)
        }
    }
    
}
