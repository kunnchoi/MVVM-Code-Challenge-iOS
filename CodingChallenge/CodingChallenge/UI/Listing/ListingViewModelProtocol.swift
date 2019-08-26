//
//  ListingViewModelProtocol.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

protocol ListingViewModelProtocol {

    // Variables
    var listingItems: Bindable<[ListingItemViewModel]> { get set }

    // Methods
    func increaseItemQuantity(for indexPath: IndexPath?)

}

extension ListingViewModelProtocol {

    func increaseItemQuantity(for indexPath: IndexPath?) {}
}
