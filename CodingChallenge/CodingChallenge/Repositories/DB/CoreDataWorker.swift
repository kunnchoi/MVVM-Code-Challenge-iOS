//
//  CoreDataWorker.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataWorkerProtocol {
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate?,
         sortDescriptors: [NSSortDescriptor]?,
         fetchLimit: Int?,
         completion: @escaping (Result<[Entity], Error>) -> Void)
    func upsert<Entity: ManagedObjectConvertible>
        (entities: [Entity],
         completion: @escaping (Error?) -> Void)
    func getEntity<Entity: ManagedObjectConvertible>
        (identifier: String,
         completion: @escaping (Result<Entity?, Error>) -> Void)
}

extension CoreDataWorkerProtocol {
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate? = nil,
         sortDescriptors: [NSSortDescriptor]? = nil,
         fetchLimit: Int? = nil,
         completion: @escaping (Result<[Entity], Error>) -> Void) {
        get(with: predicate,
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            completion: completion)
    }
}

enum CoreDataWorkerError: Error {
    case cannotFetch(String)
    case cannotSave(Error)
}

class CoreDataWorker: CoreDataWorkerProtocol {
    let coreData: CoreDataServiceProtocol
    init(coreData: CoreDataServiceProtocol = CoreDataService.shared) {
        self.coreData = coreData
    }
    
    func get<Entity: ManagedObjectConvertible>
        (with predicate: NSPredicate?,
         sortDescriptors: [NSSortDescriptor]?,
         fetchLimit: Int?,
         completion: @escaping (Result<[Entity], Error>) -> Void) {
        coreData.performForegroundTask { context in
            do {
                let fetchRequest = Entity.ManagedObject.fetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                if let fetchLimit = fetchLimit {
                    fetchRequest.fetchLimit = fetchLimit
                }
                let results = try context.fetch(fetchRequest) as? [Entity.ManagedObject]
                let items: [Entity] = results?.compactMap { $0.toEntity() as? Entity } ?? []
                completion(.success(whisper: items))
            } catch {
                let fetchError = CoreDataWorkerError.cannotFetch("Cannot fetch error: \(error))")
                completion(.failure(fetchError))
            }
        }
    }
    
    func getEntity<Entity: ManagedObjectConvertible>(identifier: String, completion: @escaping (Result<Entity?, Error>) -> Void) {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        coreData.performForegroundTask { context in
            do {
                let fetchRequest = Entity.ManagedObject.fetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.fetchLimit = 1
                let results = try context.fetch(fetchRequest) as? [Entity.ManagedObject]
                let items: [Entity] = results?.compactMap { $0.toEntity() as? Entity } ?? []
                completion(.success(whisper: items.first ?? nil))
            } catch {
                let fetchError = CoreDataWorkerError.cannotFetch("Cannot fetch error: \(error))")
                completion(.failure(fetchError))
            }
        }
    }
    
    func upsert<Entity: ManagedObjectConvertible>
        (entities: [Entity],
         completion: @escaping (Error?) -> Void) {
        coreData.performBackgroundTask { context in
            _ = entities.compactMap({ (entity) -> Entity.ManagedObject? in
                return entity.toManagedObject(in: context)
            })
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(CoreDataWorkerError.cannotSave(error))
            }
        }
    }
    
    func delete<Entity: ManagedObjectConvertible>(entity: Entity, completion: @escaping (Error?) -> Void) {
        coreData.performBackgroundTask { context in
            if let moObj = entity.manageObjectToDelete(in: context) {
                context.delete(moObj)
                do {
                    try context.save()
                    completion(nil)
                } catch {
                    completion(CoreDataWorkerError.cannotSave(error))
                }
            }
        }
    }
    
    func deleteAllRecords<Entity: NSManagedObject>(entityName: Entity.Type, completion: @escaping (Error?) -> Void) {
        // Create Fetch Request
        let fetchRequest = Entity.fetchRequest()
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coreData.backgroundContext.execute(batchDeleteRequest)
            completion(nil)
        } catch {
            completion(CoreDataWorkerError.cannotSave(error))
        }
    }
}
