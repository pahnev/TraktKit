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
    public var show: Show? = nil
    public var seasons: [TraktWatchedSeason]? = nil
    public var movie: Movie? = nil


}
