//
//  ListingItemViewModel.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/25/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

struct ListingItemViewModel {

    public private(set) var item: ListingItem
    let id: Int?
    let name: String?
    let desc: String?
    let imported: Bool?
    let price: Double?
    var quantity: Int = 0

    init(with item: ListingItem, quantity: Int = 0) {
        self.item = item
        self.id = self.item.id
        self.name = self.item.name
        self.desc = self.item.desc
        self.imported = self.item.imported
        self.price = self.item.price
        self.quantity = quantity
    }

    var saleTaxPrice: Double? {
        return self.item.saleTaxPrice
    }

    var importedTaxPrice: Double? {
        return self.item.importedTaxPrice
    }
}
