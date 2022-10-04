//
//  Season.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Season: CodableEquatable {
    // Extended: Min
    public let number: Int
    public let ids: SeasonId

    // Extended: Full
    public let rating: Double?
    public let votes: Int?
    public let episodeCount: Int?
    public let airedEpisodes: Int?
    public let title: String?
    public let overview: String?
    public let firstAired: Date?

    // Extended: Episodes
    public let episodes: [Episode]?
}
