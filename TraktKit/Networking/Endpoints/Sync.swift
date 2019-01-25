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

enum Sync: Endpoint {
    struct Payload: CodableEquatable {
        // TODO: Should this also take TMDB ids, if the data is coming from there, but syncing to Trakt?
        let movies: [TraktIdContainer]
        let shows: [TraktIdContainer]
        let episodes: [TraktIdContainer]

        /// Specific item ids. Used to remove items from history.
        let ids: [HistoryItemId]
    }

    case lastActivities
    case getPlaybackProgress(type: WatchedType, limit: Int?)
    case removePlayback(PlaybackProgressId)

    case getCollection(type: ContentType)
    case addToCollection(Payload)
    case removeFromCollection(Payload)

    case getHistory(payload: HistoryPayload)
    case addToHistory(Payload)
    case removeFromHistory(Payload)

    case getRatings(type: ContentType)
    case addRatings(Payload)
    case removeRatings(Payload)

    case getWatchlist(type: ContentType)
    case addToWatchlist(Payload)
    case removeFromWatchlist(Payload)

    var httpMethod: HTTPMethod {
        switch self {
        case .lastActivities, .getPlaybackProgress, .getCollection, .getHistory, .getRatings, .getWatchlist:
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
        case .lastActivities, .getPlaybackProgress, .getCollection, .getHistory, .getRatings, .getWatchlist:
            return nil
        case .removePlayback(let params):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try! encoder.encode(params)
        case .addToCollection(let params),
             .removeFromCollection(let params),
             .addToHistory(let params),
             .removeFromHistory(let params),
             .addRatings(let params),
             .removeRatings(let params),
             .addToWatchlist(let params),
             .removeFromWatchlist(let params):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try! encoder.encode(params)
        }
    }

    var requestHeaders: [String : String] {
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
             .removeFromWatchlist:
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
        case .getCollection(let contentType):
            return sync.appendingPathComponent("collection/\(contentType.rawValue)")
        case .addToCollection:
            return sync.appendingPathComponent("collection")
        case .removeFromCollection:
            return sync.appendingPathComponent("collection/remove")
        case .getHistory(let payload):
            return sync
                .appendingPathComponent("history/\(payload.type.rawValue)/\(String(payload.traktId))")
                .appendingQueryItems(payload.asQueryItems)
        case .addToHistory:
            return sync.appendingPathComponent("history")
        case .removeFromHistory:
            return sync.appendingPathComponent("history/remove")
        case .getRatings(let type):
            return sync.appendingPathComponent("\(type.rawValue)/rating")
        case .addRatings(_):
            return sync.appendingPathComponent("rating")
        case .removeRatings(_):
            return sync.appendingPathComponent("rating/remove")
        case .getWatchlist(let type):
            return sync.appendingPathComponent("watchlist/\(type.rawValue)")
        case .addToWatchlist(_):
            return sync.appendingPathComponent("watchlist")
        case .removeFromWatchlist(_):
            return sync.appendingPathComponent("watchlist")
        }
    }
}

struct HistoryPayload {
    let type: ContentType
    let pageNumber: PageNumber
    let resultsPerPage: Int?
    let traktId: Int?
    let infoLevel: MovieInfo?
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
         infoLevel: MovieInfo = .min,
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
