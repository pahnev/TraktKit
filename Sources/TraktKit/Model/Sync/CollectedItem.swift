//
//  CollectedItem.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct CollectedMovie: CodableEquatable {
    /// Indicates when users have collected the item.
    public let collectedAt: Date

    /// Indicates when the underlying `Movie` item was updated. Cache this timestamp locally and only re-process the movie if you see a newer timestamp
    public let updatedAt: Date

    public let movie: Movie?
    public let metadata: Metadata?
}

public struct CollectedShow: CodableEquatable {
    public struct Season: CodableEquatable {
        public struct Episode: CodableEquatable {

            public let number: Int
            public let collectedAt: Date
        }

        /// Season number
        public let number: Int
        public let episodes: [Episode]
    }

    /// Indicates when users have last collected some item of this `Show`.
    public let lastCollectedAt: Date

    /// Indicates when the underlying `Show` item was last updated. Cache this timestamp locally and only re-process the movie if you see a newer timestamp
    public let lastUpdatedAt: Date

    public let show: Show?
    public let seasons: [CollectedShow.Season]
    public let metadata: Metadata?
}

public struct Metadata: CodableEquatable {
    public let mediaType: String
    public let resolution: String
    public let audio: String
    public let audioChannels: String
}
