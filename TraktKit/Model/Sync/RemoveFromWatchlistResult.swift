//
//  RemoveFromWatchlistResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct RemoveFromWatchlistResult: CodableEquatable {
    let deleted: Deleted
//    let notFound: NotFound

    public struct Deleted: CodableEquatable {
        let movies: Int
        let shows: Int
        let seasons: Int
        let episodes: Int
    }
    
    public struct NotFound: CodableEquatable {
        let movies: [ID]
        let shows: [ID]
        let seasons: [ID]
        let episodes: [ID]
    }
}
