//
//  ListingItem.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

struct ListingItem: Codable {

    let id: Int?
    let name: String?
    let desc: String?
    let salesTax: Double?
    let importTax: Double? = 5
    let imported: Bool?
    let price: Double?

    var saleTaxPrice: Double? {
        guard let salesTax = self.salesTax,
              let price = self.price
        else { return nil }
        return (price * (salesTax / 100)).round(nearest: 0.05)
    }

    var importedTaxPrice: Double? {
        guard self.imported == true,
              let importTax = self.importTax,
              let price = self.price
        else { return nil }
        return (price * (importTax / 100)).round(nearest: 0.05)
    }

}

struct Listing: Codable {

    let listingItems: [ListingItem]?

}
