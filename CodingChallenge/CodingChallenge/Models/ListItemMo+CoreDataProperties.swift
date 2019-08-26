//
//  ListItemMo+CoreDataProperties.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/24/19.
//  Copyright © 2019 Jandas. All rights reserved.
//
//

import Foundation
import CoreData

extension ListItemMo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItemMo> {
        return NSFetchRequest<ListItemMo>(entityName: "ListItemMo")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var price: Double
    @NSManaged public var isImported: Bool
    @NSManaged public var salesTax: Double

}
