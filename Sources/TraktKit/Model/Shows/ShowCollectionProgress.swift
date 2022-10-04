//
//  ShowCollectionProgress.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct ShowCollectionProgress: CodableEquatable {
    public let aired: Int
    public let completed: Int
    public let lastCollectedAt: Date
    public let seasons: [CollectedSeason]
    public let hiddenSeasons: [Season]
    public let nextEpisode: Episode?

    public struct CollectedSeason: CodableEquatable {
        let number: Int
        let aired: Int
        let completed: Int
        let episodes: [CollectedEpisode]
    }

    public struct CollectedEpisode: CodableEquatable {
        let number: Int
        let completed: Bool
        let collectedAt: Date?
    }
}
