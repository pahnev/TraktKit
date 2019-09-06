//
//  RemoveFromCollectionResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct RemoveFromCollectionResult: CodableEquatable {
    public let deleted: deleted
//    public let notFound: NotFound

    public struct deleted: CodableEquatable {
        let movies: Int
        let episodes: Int
    }
    
    public struct NotFound: CodableEquatable {
        let movies: [ID]
        let shows: [ID]
        let seasons: [ID]
        let episodes: [ID]
    }
}
