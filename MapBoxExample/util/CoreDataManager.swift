//
//  CoreDataManager.swift
//  MapBoxExample
//
//  Created by Jeff Day on 12/12/17.
//  Copyright © 2017 JDay Apps, LLC. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        let url = self.documentsDirectory.appendingPathComponent("DataModel")
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType,
                                    configurationName: nil,
                                    at: url,
                                    options: options)
        return psc
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "DataModel", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: url) else {
                fatalError("Unable to load CoreData model.")
        }
        
        return model
    }()
    
    private lazy var documentsDirectory: URL = {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to find documents directory.")
        }
        
        return docs
    }()
    
    
    
    
    // MARK: - Internal Functions
    
    func save() {
        DispatchQueue.main.async(execute: { () -> Void in
            do {
                try self.mainContext.save()
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                for detailedError in error.userInfo {
                    print("detailedError: \(detailedError)")
                }
            }
        })
    }
}
