//
//  CoreDataStack.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import CoreData

protocol CoreDataServiceProtocol: class {
    var errorHandler: (Error) -> Void {get set}
    var persistentContainer: NSPersistentContainer {get}
    var viewContext: NSManagedObjectContext {get}
    var backgroundContext: NSManagedObjectContext {get}
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

final class CoreDataService: CoreDataServiceProtocol {

    static let shared = CoreDataService()
    var errorHandler: (Error) -> Void = {_ in }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CodingChallenge")
        container.loadPersistentStores(completionHandler: { [weak self](_, error) in
            if let error = error {
                NSLog("CoreData error \(error), \(String(describing: error._userInfo))")
                self?.errorHandler(error)
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        let context: NSManagedObjectContext = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
}
