//
//  HistoryCoreData.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 25..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit
import CoreData

class HistoryCoreData {
    //HistoryEntity
    private var historys: [HistoryEntity] = []
    
    private let entityName: String = "HistoryEntity"
    
    private let fetchLimit: Int = 10
    
    typealias SuccessHandler = (_ datas: [HistoryEntity]) -> Void
    
    static let shared = HistoryCoreData()
    
    init(){}
    
    /**
     날짜를 기준으로 최신순으로 검색어를 가져오는 함수
     - parameters:
     - success: 성공 block
     */
    func fetch(_ success: SuccessHandler) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchLimit = fetchLimit
        
        do {
            historys = try context.fetch(fetchRequest) as! [HistoryEntity]
            
            success(historys)
        } catch let error as NSError {
            DDLogDebug("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /**
     검색어를 앞에 부터 일치 되는 검색어만 가져오는 함수
     - parameters:
     - search: 검색어
     - success: 성공 block
     */
    func fetch(search: String, _ success: SuccessHandler) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "content BEGINSWITH %@", search)
        fetchRequest.fetchLimit = fetchLimit
        
        do {
            historys = try context.fetch(fetchRequest) as! [HistoryEntity]
            
            success(historys)
        } catch let error as NSError {
            DDLogDebug("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    /**
     검색어를 저장하는 함수
     - parameters:
     - content: 검색어
     - date: 날짜
     - returns: 성공여부
     */
    @discardableResult
    func save(withContent content: String, withDate date: Date) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        var isSuccess: Bool = false
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let history = NSManagedObject(entity: entity, insertInto: context) as! HistoryEntity
        
        history.setValue(content, forKeyPath: "content")
        history.setValue(date, forKeyPath: "date")
        
        do {
            try context.save()
            
            isSuccess = true
        } catch let error as NSError {
            DDLogDebug("Could not save. \(error), \(error.userInfo)")
        }
        
        return isSuccess
    }
    
    /**
     존재하는 검색어를 업데이트 함수
     - parameters:
     - content: 검색어
     - date: 날짜
     - returns: 성공여부
     */
    @discardableResult
    func update(withContent content: String, withDate date: Date) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        var isSuccess: Bool = false
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "content = %@", content)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                // In my case, I only updated the first item in results
                if let result = results?[0] {
                    result.setValue(content, forKey: "content")
                    result.setValue(date, forKey: "date")
                    
                    try context.save()
                    
                    isSuccess = true
                }
            }
        } catch let error as NSError {
            DDLogDebug("Could not save. \(error), \(error.userInfo)")
        }
        
        return isSuccess
    }
    
    /**
     존재하는 검색어가 있으면 업데이트, 아니면 저장하는 함수
     - parameters:
     - content: 검색어
     - date: 날짜
     - returns: 성공여부
     */
    @discardableResult
    func updateWithSave(withContent content: String, withDate date: Date) -> Bool {
        let isUpdated = self.update(withContent: content, withDate: date)
        if isUpdated == false {
            return self.save(withContent: content, withDate: date)
        }
        return isUpdated
    }
    
    /**
     검색어를 전체 삭제 하는 함수
     */
    func deleteAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
            try context.save()
        } catch let error as NSError {
            DDLogDebug("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
