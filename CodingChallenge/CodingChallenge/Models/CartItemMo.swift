//
//  CartItemMo.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation
import CoreData

extension CartItemMo: ManagedObjectProtocol {
    func toEntity() -> CartItem? {
        guard let listItem = listItem?.toEntity() else {return nil}
        return CartItem(listItem: listItem, quantity: Int(quantity))
    }
}

extension CartItem: ManagedObjectConvertible {

    func manageObjectToDelete(in context: NSManagedObjectContext) -> CartItemMo? {
        guard let id = self.listItem.id else { return nil}
        return CartItemMo.single(with: String(id), from: context)
    }

    func toManagedObject(in context: NSManagedObjectContext) -> CartItemMo? {
        guard let id = self.listItem.id else { return nil }
        let cartMo = CartItemMo.getOrCreateSingle(with: String(id), from: context)
        cartMo.listItem = listItem.toManagedObject(in: context)
        cartMo.quantity = Int16(quantity)
        return cartMo
    }
}
