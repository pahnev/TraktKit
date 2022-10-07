//
//  Movies.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 02/08/2018.
//

import Foundation

public enum Movies {
    case aliases(movieId: Int)
    case boxOffice
    case comments(movieId: Int, sort: String, pageNumber: Int, resultsPerPage: Int)
    case currentlyWatching(movieId: Int)
    case details(movieId: Int, infoLevel: InfoLevel)
    case lists(movieId: Int, type: String, sort: String, pageNumber: Int, resultsPerPage: Int)
    case mostAnticipated(pageNumber: Int, resultsPerPage: Int)
    case mostCollected(pageNumber: Int, timePeriod: String, resultsPerPage: Int)
    case mostPlayed(pageNumber: Int, timePeriod: String, resultsPerPage: Int)
    case mostWatched(pageNumber: Int, timePeriod: String, resultsPerPage: Int)
    case people(movieId: Int)
    case popular(pageNumber: Int, resultsPerPage: Int)
    case ratings(movieId: Int)
    case recentlyUpdated(pageNumber: Int, startDate: String, resultsPerPage: Int)
    case related(movieId: Int, pageNumber: Int, resultsPerPage: Int)
    case releases(movieId: Int, country: String)
    case stats(movieId: Int)
    case translations(movieId: Int, language: String)
    case trending(pageNumber: Int, resultsPerPage: Int, infoLevel: InfoLevel)
}

extension Movies: Endpoint {
    var httpMethod: HTTPMethod {
        return .GET
    }

    var httpBody: Data? {
        return nil
    }

    var requestHeaders: [String: String] {
        return [:]
    }

    var url: URL {
        let movies = baseURL.appendingPathComponent("movies")
        switch self {
        case .aliases(let movieId):
            return movies.appendingPathComponent("\(movieId)/aliases")
        case .boxOffice:
            return movies.appendingPathComponent("boxoffice")
        case .comments(let movieId, let sort, let pageNumber, let resultsPerPage):
            return movies.appendingPathComponent("\(movieId)/comments/\(sort)")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .currentlyWatching(let movieId):
            return movies.appendingPathComponent("\(movieId)/watching")
        case .details(let movieId, let infoLevel):
            return movies.appendingPathComponent(movieId.description)
                .appendingQueryItem(URLQueryItem(name: "extended", value: infoLevel.rawValue))
        case .lists(let movieId, let type, let sort, let pageNumber, let resultsPerPage):
            return movies.appendingPathComponent("\(movieId)/lists/\(type)/\(sort)")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .mostAnticipated(let pageNumber, let resultsPerPage):
            return movies.appendingPathComponent("anticipated")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .mostCollected(let pageNumber, let timePeriod, let resultsPerPage):
            return movies.appendingPathComponent("collected/\(timePeriod)")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .mostPlayed(let pageNumber, let timePeriod, let resultsPerPage):
            return movies.appendingPathComponent("played/\(timePeriod)")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .mostWatched(let pageNumber, let timePeriod, let resultsPerPage):
            return movies.appendingPathComponent("watched/\(timePeriod)")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .people(let movieId):
            return movies.appendingPathComponent("\(movieId)/people")
        case .popular(let pageNumber, let resultsPerPage):
            return movies.appendingPathComponent("popular")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .ratings(let movieId):
            return movies.appendingPathComponent("\(movieId)/ratings")
        case .recentlyUpdated(let pageNumber, let startDate, let resultsPerPage):
            return movies.appendingPathComponent("updates/\(startDate)")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .related(let movieId, let pageNumber, let resultsPerPage):
            return movies.appendingPathComponent("\(movieId)/related")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
        case .releases(let movieId, let country):
            return movies.appendingPathComponent("\(movieId)/releases/\(country)")
        case .stats(let movieId):
            return movies.appendingPathComponent("\(movieId)/stats")
        case .translations(let movieId, let language):
            return movies.appendingPathComponent("\(movieId)/translations/\(language)")
        case .trending(let pageNumber, let resultsPerPage, let infoLevel):
            return movies.appendingPathComponent("trending")
                .appendingPagination(Pagination(page: pageNumber, limit: resultsPerPage))
                .appendingInfo(infoLevel)
        }
    }
}
