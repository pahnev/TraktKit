//
//  AddedToHistory.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 29/08/2018.
//

import Foundation

public struct TraktIdContainer: CodableEquatable {
    public struct Id: CodableEquatable {
        public let trakt: TraktId
    }
    public let ids: Id
}

public struct NotFound: CodableEquatable {
    public let movies: [TraktIdContainer]
    public let shows: [TraktIdContainer]
    public let episodes: [TraktIdContainer]
}

public struct AddedToHistory: CodableEquatable {
    public struct Added: CodableEquatable {
        public let movies: Int
        public let episodes: Int
    }

    /// Returns the information about successfully added objects.
    public let added: Added

    /// The objects that were attempted to be added, but not found will be returned as `NotFound`.
    public let notFound: NotFound
}
