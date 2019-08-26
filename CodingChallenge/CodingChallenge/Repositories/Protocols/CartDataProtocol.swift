//
//  CartDataProtocol.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

// Cart Data Protocol
protocol CartDataProtocol {
    func fetchCartItem(itemId: String, completion: @escaping (CartItem?) -> Void)
    func fetchAllCartItems(completion: @escaping ([CartItem]?) -> Void)
    func updateCartItem(listingItem: ListingItem?, quantity: Int?)
    func increaseQuantityFor(listingItem: ListingItem?)
    func decreaseQuantityFor(listingItem: ListingItem?)
    func updateCartItem(cartItem: CartItem?)
    func deleteCartItem(cartItem: CartItem?)
    func removeAllItems()
}
