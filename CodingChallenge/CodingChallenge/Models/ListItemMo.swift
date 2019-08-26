//
//  ListItemMo.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/24/19.
//  Copyright © 2019 Jandas. All rights reserved.
//
//
import Foundation
import CoreData

extension ListItemMo: ManagedObjectProtocol {
    func toEntity() -> ListingItem? {
        guard let identifier = identifier,
              let id = Int(identifier)
        else {
            return nil
        }
        return ListingItem(id: id,
                           name: name,
                           desc: desc,
                           salesTax: salesTax,
                           imported: isImported,
                           price: price)
    }
}

extension ListingItem: ManagedObjectConvertible {

    func manageObjectToDelete(in context: NSManagedObjectContext) -> ListItemMo? {
        guard let id = id else { return nil }
        return ListItemMo.single(with: String(id), from: context)
    }

    func toManagedObject(in context: NSManagedObjectContext) -> ListItemMo? {
        guard let id  = id else { return nil }
        let listItemMo = ListItemMo.getOrCreateSingle(with: String(id), from: context)
        listItemMo.name = name
        listItemMo.desc = desc
        listItemMo.price = price ?? 0
        listItemMo.isImported = imported ?? false
        listItemMo.salesTax = salesTax ?? 0
        return listItemMo
    }
}
