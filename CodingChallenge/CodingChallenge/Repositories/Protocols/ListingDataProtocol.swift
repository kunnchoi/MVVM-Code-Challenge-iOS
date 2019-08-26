//
//  ListingDataProtocol.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

// Listing Data Protocol
protocol ListingDataProtocol {
    static func fetchListingFromDB(completion: @escaping GetListingCompletion)
    static func fetchListingFromMockJson(completion: @escaping GetListingCompletion)
    static func fetchListingFromServer(completion: @escaping GetListingCompletion)
}
