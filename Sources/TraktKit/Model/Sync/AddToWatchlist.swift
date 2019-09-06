//
//  AddToWatchlist.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct AddToWatchlist: CodableEquatable {
    public struct Added: CodableEquatable {
        public let movies: Int
        public let episodes: Int
        public let shows: Int
        public let seasons: Int
    }

    public struct NotFound: CodableEquatable {
        public let movies: [TraktIdContainer]
        public let shows: [TraktIdContainer]
        public let seasons: [TraktIdContainer]
        public let episodes: [TraktIdContainer]
    }

    public let added: Added
    public let existing: Added
    public let notFound: AddToWatchlist.NotFound
}
