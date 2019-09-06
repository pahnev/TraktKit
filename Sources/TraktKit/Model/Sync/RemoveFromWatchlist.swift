//
//  RemoveFromWatchlist.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct RemoveFromWatchlist: CodableEquatable {
    let deleted: Deleted
    let notFound: AddToWatchlist.NotFound

    public struct Deleted: CodableEquatable {
        let movies: Int
        let shows: Int
        let seasons: Int
        let episodes: Int
    }
}
