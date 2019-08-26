//
//  ListingRepository.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/21/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

typealias GetListingResult = Result<[ListingItem], ErrorResult>
typealias GetListingCompletion = (_ result: GetListingResult) -> Void

// MARK: - Listing Repository
class ListingRepository: ListingDataProtocol {

    static func fetchListingFromDB(completion: @escaping GetListingCompletion) {
        fetchListingFromMockJson(completion: completion)
    }

    static func fetchListingFromServer(completion: @escaping GetListingCompletion) {
        // Do nothing 
    }

    static func fetchListingFromMockJson(completion: @escaping GetListingCompletion) {

        guard let url = Bundle.main.url(forResource: "MockJSON", withExtension: "json")
        else {
            completion(.failure(.invalidData))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let listing = try decoder.decode(Listing.self, from: data)
            guard let listingItems = listing.listingItems
            else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(whisper: listingItems))
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
            completion(.failure(.invalidData))
            return
        }
    }
}
