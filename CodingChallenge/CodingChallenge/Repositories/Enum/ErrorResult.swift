//
//  ErrorResult.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

import Foundation

// Error enum
enum ErrorResult: Error {
    case dbUnavailable
    case wrongDataFormat
    case invalidData
}

extension ErrorResult: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dbUnavailable:
            return NSLocalizedString("Could not read data from DB", comment: "")
        case .wrongDataFormat:
            return NSLocalizedString("Could not digest the fetched data.", comment: "")
        case .invalidData:
            return NSLocalizedString("Unable to parse data", comment: "")
        }
    }
}
