//
//  Movies.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 02/08/2018.
//

import Foundation

public enum Movies {
    case aliases(movieId: TraktId)
    case boxOffice
    case comments(movieId: TraktId, sort: String, pageNumber: Int, resultsPerPage: Int)
    case currentlyWatching(movieId: TraktId)
    case details(movieId: TraktId, infoLevel: MovieInfo)
    case lists(movieId: TraktId, type: String, sort: String, pageNumber: Int, resultsPerPage: Int)
    case mostAnticipated(pageNumber: Int, resultsPerPage: Int)
    case mostCollected(pageNumber: Int, timePeriod: String, resultsPerPage: Int)
    case mostPlayed(pageNumber: Int, timePeriod: String, resultsPerPage: Int)
    case mostWatched(pageNumber: Int, timePeriod: String, resultsPerPage: Int)
    case people(movieId: TraktId)
    case popular(pageNumber: Int, resultsPerPage: Int)
    case ratings(movieId: TraktId)
    case recentlyUpdated(pageNumber: Int, startDate: String, resultsPerPage: Int)
    case related(movieId: TraktId, pageNumber: Int, resultsPerPage: Int)
    case releases(movieId: TraktId, country: String)
    case stats(movieId: TraktId)
    case translations(movieId: TraktId, language: String)
    case trending(pageNumber: Int, resultsPerPage: Int, infoLevel: MovieInfo)
}

extension Movies: Endpoint {
    var httpMethod: HTTPMethod {
        return .GET
    }

    var httpBody: Data? {
        return nil
    }

    var requestHeaders: [String : String] {
        return [:]
    }

    var url: URL {
        let movies = baseURL.appendingPathComponent("movies")
        switch self {
        case .aliases(let movieId):
            return movies.appendingPathComponent("\(movieId)/aliases")
        case .boxOffice:
            return movies.appendingPathComponent("boxoffice")
        case .comments(let params):
            return movies.appendingPathComponent("\(params.movieId)/comments/\(params.sort)")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .currentlyWatching(let movieId):
            return movies.appendingPathComponent("\(movieId)/watching")
        case .details(let params):
            return movies.appendingPathComponent(params.movieId.description)
                .appendingQueryItem(URLQueryItem(name: "extended", value: params.infoLevel.rawValue))
        case .lists(let params):
            return movies.appendingPathComponent("\(params.movieId)/lists/\(params.type)/\(params.sort)")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .mostAnticipated(let params):
            return movies.appendingPathComponent("anticipated")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .mostCollected(let params):
            return movies.appendingPathComponent("collected/\(params.timePeriod)")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .mostPlayed(let params):
            return movies.appendingPathComponent("played/\(params.timePeriod)")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .mostWatched(let params):
            return movies.appendingPathComponent("watched/\(params.timePeriod)")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .people(let movieId):
            return movies.appendingPathComponent("\(movieId)/people")
        case .popular(let params):
            return movies.appendingPathComponent("popular")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .ratings(let movieId):
            return movies.appendingPathComponent("\(movieId)/ratings")
        case .recentlyUpdated(let params):
            return movies.appendingPathComponent("updates/\(params.startDate)")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .related(let params):
            return movies.appendingPathComponent("\(params.movieId)/related")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
        case .releases(let movieId, let country):
            return movies.appendingPathComponent("\(movieId)/releases/\(country)")
        case .stats(let movieId):
            return movies.appendingPathComponent("\(movieId)/stats")
        case .translations(let movieId, let language):
            return movies.appendingPathComponent("\(movieId)/translations/\(language)")
        case .trending(let params):
            return movies.appendingPathComponent("trending")
                .appendingPagination(Pagination(page: params.pageNumber, limit: params.resultsPerPage))
                .appendingInfo(params.infoLevel)
        }
    }

}
