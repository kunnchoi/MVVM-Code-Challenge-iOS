//
//  ListingViewModel.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

final class ListingViewModel: ListingViewModelProtocol {
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
        let item = listing[index]
        cartItemRepository.increaseQuantityFor(listingItem: item.item)
    }
}

extension ListingViewModel {

    private func getViewModelListing(from list: [ListingItem]) -> [ListingItemViewModel] {

        var viewModelListing: [ListingItemViewModel] = []
        list.forEach { item in
            let viewModel = ListingItemViewModel(with: item)
            viewModelListing.append(viewModel)
        }
        return viewModelListing
    }

    func fetchListingFromMockJson() {
        ListingRepository.fetchListingFromMockJson(completion: { [weak self] (response) in
            switch response {
            // Handle the failure
            case .failure(let error):
                self?.statusDescription.value = (error.errorDescription, true) as? (String, Bool)
            // Handle success
            case .success(let list):
                self?.listing = self?.getViewModelListing(from: list) ?? []
            }
        })
    }
}
