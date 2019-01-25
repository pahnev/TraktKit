//
//  CollectedItem.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct CollectedItem: CodableEquatable {
    
    public var lastCollectedAt: Date
    
    public var movie: Movie?
    public var show: Show?
    public var seasons: [CollectedSeason]?
    
    enum CodingKeys: String, CodingKey {
        case lastCollectedAt = "last_collected_at" // Can be last_collected_at / collected_at though
        case movieLastCollectAt = "collected_at"
        case movie
        case show
        case seasons
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        movie = try container.decodeIfPresent(Movie.self, forKey: .movie)
        show = try container.decodeIfPresent(Show.self, forKey: .show)
        seasons = try container.decodeIfPresent([CollectedSeason].self, forKey: .seasons)

        do {
            self.lastCollectedAt = try container.decode(Date.self, forKey: .lastCollectedAt)
        } catch {
            self.lastCollectedAt = try container.decode(Date.self, forKey: .movieLastCollectAt)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if movie != nil {
            try container.encode(lastCollectedAt, forKey: .movieLastCollectAt)
        } else {
            try container.encode(lastCollectedAt, forKey: .lastCollectedAt)
        }
        try container.encodeIfPresent(movie, forKey: .movie)
        try container.encodeIfPresent(show, forKey: .show)
        try container.encodeIfPresent(seasons, forKey: .seasons)
    }
}

public struct CollectedSeason: CodableEquatable {
    
    /// Season number
    public var number: Int
    public var episodes: [CollectedEpisode]
}

public struct CollectedEpisode: CodableEquatable {
    
    public var number: Int
    public var collectedAt: Date    
}
