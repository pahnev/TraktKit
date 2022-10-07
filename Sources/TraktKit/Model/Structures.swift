//
//  Structures.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

// MARK: - TV & Movies

public struct ID: CodableEquatable {
    public let trakt: Int
    public let slug: String
    public let tvdb: Int?
    public let imdb: String?
    public let tmdb: Int?
    public let tvrage: Int?
}

public struct SeasonId: CodableEquatable {
    public let trakt: Int
    public let tvdb: Int?
    public let tmdb: Int?
    public let tvrage: Int?
}

public struct EpisodeId: CodableEquatable {
    public let trakt: Int
    public let tvdb: Int?
    public let imdb: String?
    public let tmdb: Int?
    public let tvrage: Int?
}

public struct ListId: CodableEquatable {
    public let trakt: Int
    public let slug: String
}

// MARK: - Stats

public struct Stats: CodableEquatable {
    public let watchers: Int
    public let plays: Int
    public let collectors: Int
    public let collectedEpisodes: Int?
    public let comments: Int
    public let lists: Int
    public let votes: Int
}

// MARK: - Last Activities

public struct LastActivities: CodableEquatable {
    public let all: Date
    public let movies: LastActivityMovies
    public let episodes: LastActivityEpisodes
    public let shows: LastActivityShows
    public let seasons: LastActivitySeasons
    public let comments: LastActivityComments
    public let lists: LastActivityLists
}

public struct LastActivityMovies: CodableEquatable {
    public let watchedAt: Date
    public let collectedAt: Date
    public let ratedAt: Date
    public let watchlistedAt: Date
    public let commentedAt: Date
    public let pausedAt: Date
    public let hiddenAt: Date
}

public struct LastActivityEpisodes: CodableEquatable {
    public let watchedAt: Date
    public let collectedAt: Date
    public let ratedAt: Date
    public let watchlistedAt: Date
    public let commentedAt: Date
    public let pausedAt: Date
}

public struct LastActivityShows: CodableEquatable {
    public let ratedAt: Date
    public let watchlistedAt: Date
    public let commentedAt: Date
}

public struct LastActivitySeasons: CodableEquatable {
    public let ratedAt: Date
    public let watchlistedAt: Date
    public let commentedAt: Date
}

public struct LastActivityComments: CodableEquatable {
    public let likedAt: Date
}

public struct LastActivityLists: CodableEquatable {
    public let likedAt: Date
    public let updatedAt: Date
    public let commentedAt: Date
}
