//
//  WatchedItem.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct WatchedItem: CodableEquatable {
    public struct TraktWatchedSeason: CodableEquatable {
        public struct TraktWatchedEpisode: CodableEquatable {
            public let number: Int
            public let plays: Int
            public let lastWatchedAt: Date
        }

        public let number: Int
        public let episodes: [TraktWatchedEpisode]?
    }

    public let plays: Int
    public let lastWatchedAt: Date
    public let lastUpdatedAt: Date
    public let show: Show?
    public let seasons: [TraktWatchedSeason]?
    public let movie: Movie?
}
