//
//  CartItemMo+CoreDataProperties.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/24/19.
//  Copyright © 2019 Jandas. All rights reserved.
//
//

import Foundation
import CoreData

extension CartItemMo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItemMo> {
        return NSFetchRequest<CartItemMo>(entityName: "CartItemMo")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var listItem: ListItemMo?

}
