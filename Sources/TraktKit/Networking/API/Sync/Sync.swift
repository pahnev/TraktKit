//
//  Sync.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 28/08/2018.
//

import Foundation
public enum WatchedType: String {
    case movies
    case episodes
    case all = ""
}

public enum CollectableType: String {
    case movies, shows
}

enum Sync: Endpoint {
    struct Payload: CodableEquatable {
        // TODO: Should this also take TMDB ids, if the data is coming from there, but syncing to Trakt?
        let movies: [TraktIdContainer]
        let shows: [TraktIdContainer]
        let episodes: [TraktIdContainer]

        /// Specific item ids. Used to remove items from history.
        let ids: [HistoryItemId]
    }

    struct CollectablePayload: CodableEquatable {
        let movies: [TraktIdContainer]
        let shows: [TraktIdContainer]
        let episodes: [TraktIdContainer]

        let seasons: [TraktIdContainer]
    }

    struct RateablePayload: CodableEquatable {
        struct Rateable: CodableEquatable {
            let rating: Int
            let ratedAt: Date?
            let ids: TraktIdContainer.Id
        }

        let movies: [Rateable]
        let shows: [Rateable]
        let episodes: [Rateable]
        let seasons: [Rateable]
    }

    case lastActivities
    case getPlaybackProgress(type: WatchedType, limit: Int?)
    case removePlayback(PlaybackProgressId)

    case getCollection(type: CollectableType, infoLevel: InfoLevel)
    case addToCollection(Payload)
    case removeFromCollection(Payload)

    case getWatched(type: CollectableType, infoLevel: InfoLevel)

    case getHistory(payload: HistoryPayload)
    case addToHistory(Payload)
    case removeFromHistory(Payload)

    case getRatings(type: ContentType, infoLevel: InfoLevel)
    case addRatings(RateablePayload)
    case removeRatings(CollectablePayload)

    case getWatchlist(type: ContentType, infoLevel: InfoLevel, pagination: Pagination)
    case addToWatchlist(CollectablePayload)
    case removeFromWatchlist(CollectablePayload)

    var httpMethod: HTTPMethod {
        switch self {
        case .lastActivities, .getPlaybackProgress, .getCollection, .getHistory, .getRatings, .getWatchlist, .getWatched:
            return .GET
        case .addToCollection,
             .removeFromCollection,
             .addToHistory,
             .removeFromHistory,
             .addRatings,
             .removeRatings,
             .addToWatchlist,
             .removeFromWatchlist:
            return .POST
        case .removePlayback:
            return .DELETE
        }
    }

    var httpBody: Data? {
        switch self {
        case .lastActivities, .getPlaybackProgress, .removePlayback, .getCollection, .getHistory, .getRatings, .getWatchlist, .getWatched:
            return nil
        case .addToCollection(let params),
             .removeFromCollection(let params),
             .addToHistory(let params),
             .removeFromHistory(let params):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try! encoder.encode(params)
        case .addToWatchlist(let payload),
             .removeFromWatchlist(let payload),
             .removeRatings(let payload):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try! encoder.encode(payload)
        case .addRatings(let payload):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try! encoder.encode(payload)
        }
    }

    var requestHeaders: [String: String] {
        switch self {
        case .lastActivities,
             .getPlaybackProgress,
             .removePlayback,
             .getCollection,
             .addToCollection,
             .removeFromCollection,
             .getHistory,
             .addToHistory,
             .removeFromHistory,
             .getRatings,
             .addRatings,
             .removeRatings,
             .getWatchlist,
             .addToWatchlist,
             .removeFromWatchlist,
             .getWatched:
            return [:]
        }
    }

    var url: URL {
        let sync = baseURL.appendingPathComponent("sync")
        switch self {
        case .lastActivities:
            return sync.appendingPathComponent("last_activities")
        case .getPlaybackProgress(let params):
            return sync
                .appendingPathComponent("playback/\(params.type.rawValue)")
                .appendingLimitQuery(limit: params.limit)
        case .removePlayback(let id):
            return sync.appendingPathComponent("playback/\(String(id.integerValue))")
        case .getCollection(let params):
            return sync
                .appendingPathComponent("collection/\(params.type.rawValue)")
                .appendingInfo(params.infoLevel)
        case .addToCollection:
            return sync.appendingPathComponent("collection")
        case .removeFromCollection:
            return sync.appendingPathComponent("collection/remove")
        case .getWatched(let params):
            return sync
                .appendingPathComponent("watched/\(params.type.rawValue)")
                .appendingInfo(params.infoLevel)
        case .getHistory(let payload):
            return sync
                .appendingPathComponent("history/\(payload.type.rawValue)/\(String(payload.traktId))")
                .appendingQueryItems(payload.asQueryItems)
        case .addToHistory:
            return sync.appendingPathComponent("history")
        case .removeFromHistory:
            return sync.appendingPathComponent("history/remove")
        case .getRatings(let params):
            return sync.appendingPathComponent("ratings/\(params.type.rawValue)")
                .appendingInfo(params.infoLevel)
        case .addRatings:
            return sync.appendingPathComponent("ratings")
        case .removeRatings:
            return sync.appendingPathComponent("ratings/remove")
        case .getWatchlist(let params):
            return sync.appendingPathComponent("watchlist/\(params.type.rawValue)")
                .appendingInfo(params.infoLevel)
                .appendingPagination(params.pagination)
        case .addToWatchlist:
            return sync.appendingPathComponent("watchlist")
        case .removeFromWatchlist:
            return sync.appendingPathComponent("watchlist")
        }
    }
}

struct HistoryPayload {
    let type: ContentType
    let pageNumber: PageNumber
    let resultsPerPage: Int?
    let traktId: Int?
    let infoLevel: InfoLevel?
    // TODO: These should be dates
    let startDate: String?
    let endDate: String?

    var asQueryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "page", value: String(pageNumber)))
        if let results = resultsPerPage {
            items.append(URLQueryItem(name: "limit", value: String(results)))
        }
        if let infoLevel = infoLevel, infoLevel == .full {
            items.append(URLQueryItem(name: "extended", value: infoLevel.rawValue))
        }
        if let startDate = startDate {
            items.append(URLQueryItem(name: "start_at", value: startDate))
        }
        if let endDate = endDate {
            items.append(URLQueryItem(name: "end_at", value: endDate))
        }

        return items
    }
}

extension HistoryPayload {
    init(type: ContentType,
         pageNumber: PageNumber,
         resultsPerPage: Int = 10,
         traktId: Int? = nil,
         infoLevel: InfoLevel = .min,
         startDate: String? = nil,
         endDate: String? = nil) {
        self.type = type
        self.pageNumber = pageNumber
        self.resultsPerPage = resultsPerPage
        self.traktId = traktId
        self.infoLevel = infoLevel
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension Sync.CollectablePayload {
    init(syncPayload: Sync.Payload, seasons: [TraktIdContainer]) {
        movies = syncPayload.movies
        shows = syncPayload.shows
        episodes = syncPayload.episodes
        self.seasons = seasons
    }
}
