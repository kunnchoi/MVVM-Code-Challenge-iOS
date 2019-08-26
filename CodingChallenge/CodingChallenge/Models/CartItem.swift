//
//  CartItem.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

struct CartItem: Codable {

    let listItem: ListingItem
    var quantity: Int

}

struct CartItems: Codable {

    let cartItems: [CartItem]

}
