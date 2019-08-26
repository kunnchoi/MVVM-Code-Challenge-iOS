//
//  Result.swift
//  CodingChallenge
//
//  Created by Andrew Choi on 8/22/19.
//  Copyright © 2019 Jandas. All rights reserved.
//

// DB Result enum
enum Result<T, U: Error> {
    case success(whisper: T)
    case failure(U)
}
