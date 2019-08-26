//
//  CartViewModel.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

protocol CartViewModelProtocol: ListingViewModelProtocol {

    func decreaseItemQuantity(for indexPath: IndexPath?) -> Bool
}

extension CartViewModelProtocol {

    func decreaseItemQuantity(for indexPath: IndexPath?) -> Bool {
        return false
    }
}

final class CartViewModel: CartViewModelProtocol {

    var listingItems: Bindable<[ListingItemViewModel]> = Bindable([])
    var statusDescription: Bindable<(String, Bool)?> = Bindable(nil)
    private let cartItemRepository: CartDataProtocol = CartRepository()
    private var listing: [ListingItemViewModel] = [] {

        didSet {
            listingItems.value = listing
            statusDescription.value = ("", true)
        }
    }

    func increaseItemQuantity(for indexPath: IndexPath?) {
        guard let indexPath = indexPath
        else { return }
        let index = indexPath.row
        var item = listing[index]
        item.quantity += 1
        listing[index] = item
        cartItemRepository.updateCartItem(listingItem: item.item, quantity: item.quantity)
    }

    func decreaseItemQuantity(for indexPath: IndexPath?) -> Bool {
        var cartEmpty = false
        guard let indexPath = indexPath
        else {
            return cartEmpty
        }
        let index = indexPath.row
        var item = listing[index]
        if item.quantity > 0 {
            item.quantity -= 1
            listing[index] = item
            cartEmpty = false
            if item.quantity == 0 {
                listing.remove(at: index)
                cartEmpty = true
            }
        }
        let cartItem = CartItem(listItem: item.item, quantity: item.quantity)
        cartItemRepository.updateCartItem(cartItem: cartItem)
        return cartEmpty
    }
}

extension CartViewModel {

    private func getViewModelListing(from list: [CartItem]) -> [ListingItemViewModel] {

        var viewModelListing: [ListingItemViewModel] = []
        list.forEach { item in
            let viewModel = ListingItemViewModel(with: item.listItem, quantity: item.quantity)
            viewModelListing.append(viewModel)
        }
        return viewModelListing
    }

    func fetchListingFromDB() {
        cartItemRepository.fetchAllCartItems { [weak self] (cartItems) in

            guard let this = self,
                  let cartItems = cartItems
            else {
                self?.statusDescription.value = ("No Item in cart", true)
                return
            }
            this.listing = this.getViewModelListing(from: cartItems)
        }
    }
}
