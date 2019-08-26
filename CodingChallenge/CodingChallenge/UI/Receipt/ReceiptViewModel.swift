//
//  ReceiptViewModel.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

final class ReceiptViewModel: ListingViewModelProtocol {
    var listingItems: Bindable<[ListingItemViewModel]> = Bindable([])
    var statusDescription: Bindable<(String, Bool)?> = Bindable(nil)
    private let cartItemRepository: CartDataProtocol = CartRepository()
    private var listing: [ListingItemViewModel] = [] {
        didSet {
            listingItems.value = listing
            statusDescription.value = ("", true)
        }
    }
}

extension ReceiptViewModel {

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
                let cartItems = cartItems,
                cartItems.count > 0
                else {
                    self?.statusDescription.value = ("No Item in cart", true)
                    return
            }
            this.listing = this.getViewModelListing(from: cartItems)
        }
    }

    func getTotalSaleTax() -> Double {

        var totalSaleTax = 0.0
        listing.forEach { item in
            totalSaleTax += (item.saleTaxPrice ?? 0) + (item.importedTaxPrice ?? 0)
        }
        return totalSaleTax
    }

    func getTotalPrice() -> Double {

        var totalPrice = 0.0
        listing.forEach { item in
            let price = (item.price ?? 0) + (item.saleTaxPrice ?? 0) + (item.importedTaxPrice ?? 0)
            totalPrice += Double(item.quantity) * price
        }
        return totalPrice
    }

    func purchaseSussessUpdate() {
        cartItemRepository.removeAllItems()
    }
}
