//
//  WatchedProgress.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

/// Watched progress. Shows/Progress/Watched
public struct ShowWatchedProgress: CodableEquatable {
    // Extended: Min
    /// Number of episodes that have aired
    public let aired: Int
    /// Number of episodes that have been watched
    public let completed: Int
    /// When the last episode was watched
    public let lastWatchedAt: Date?
    public let seasons: [SeasonWatchedProgress]
    public let nextEpisode: Episode?
}

public struct SeasonWatchedProgress: CodableEquatable {
    // Extended: Min
    /// Season number
    public let number: Int
    /// Number of episodes that have aired
    public let aired: Int
    /// Number of episodes that have been watched
    public let completed: Int
    public let episodes: [EpisodeWatchedProgress]
}

public struct EpisodeWatchedProgress: CodableEquatable {
    // Extended: Min
    /// Season number
    public let number: Int
    /// Has this episode been watched
    public let completed: Bool
    /// When the last episode was watched
    public let lastWatchedAt: Date?
}
