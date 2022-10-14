//
//  Movies.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 02/08/2018.
//

import Foundation

public enum Movies {
    case aliases(movieId: Int)
    case boxOffice(infoLevel: InfoLevel?)
    case comments(movieId: Int, sort: CommentSort?, pagination: Pagination)
    case currentlyWatching(movieId: Int, infoLevel: InfoLevel?)
    case details(movieId: Int, infoLevel: InfoLevel?)
    case lists(movieId: Int, type: ListType?, sort: ListSort?, pagination: Pagination)
    case mostAnticipated(pagination: Pagination)
    case mostCollected(pagination: Pagination, timePeriod: TimePeriod?, infoLevel: InfoLevel?)
    case mostPlayed(pagination: Pagination, timePeriod: TimePeriod?)
    case mostWatched(pagination: Pagination, timePeriod: TimePeriod?, infoLevel: InfoLevel?)
    case people(movieId: Int, infoLevel: InfoLevel?)
    case popular(pagination: Pagination)
    case ratings(movieId: Int)
    case recentlyUpdated(pagination: Pagination, startDate: String, infoLevel: InfoLevel?)
    case recommended(pagination: Pagination, timePeriod: TimePeriod?, infoLevel: InfoLevel?)
    case related(movieId: Int, pagination: Pagination, infoLevel: InfoLevel?)
    case releases(movieId: Int, country: String)
    case stats(movieId: Int)
    case translations(movieId: Int, language: String)
    case trending(pagination: Pagination, infoLevel: InfoLevel?)
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
        case .boxOffice(let infoLevel):
            return movies.appendingPathComponent("boxoffice")
                .appendingInfo(infoLevel)
        case .comments(let movieId, let sort, let pagination):
            return movies.appendingPathComponent("\(movieId)/comments")
                .appendingPathComponent(sort?.rawValue)
                .appendingPagination(pagination)
        case .currentlyWatching(let movieId, let infoLevel):
            return movies.appendingPathComponent("\(movieId)/watching")
                .appendingInfo(infoLevel)
        case .details(let movieId, let infoLevel):
            return movies.appendingPathComponent(movieId.description)
                .appendingInfo(infoLevel)
        case .lists(let movieId, let type, let sort, let pagination):
            return movies.appendingPathComponent("\(movieId)/lists")
                .appendingPathComponent(type?.rawValue)
                .appendingPathComponent(sort?.rawValue)
                .appendingPagination(pagination)
        case .mostAnticipated(let pagination):
            return movies.appendingPathComponent("anticipated")
                .appendingPagination(pagination)
        case .mostCollected(let pagination, let timePeriod, let infoLevel):
            return movies.appendingPathComponent("collected")
                .appendingTimePeriod(timePeriod)
                .appendingPagination(pagination)
                .appendingInfo(infoLevel)
        case .mostPlayed(let pagination, let timePeriod):
            return movies.appendingPathComponent("played")
                .appendingTimePeriod(timePeriod)
                .appendingPagination(pagination)
        case .mostWatched(let pagination, let timePeriod, let infoLevel):
            return movies.appendingPathComponent("watched")
                .appendingTimePeriod(timePeriod)
                .appendingPagination(pagination)
                .appendingInfo(infoLevel)
        case .people(let movieId, let infoLevel):
            return movies.appendingPathComponent("\(movieId)/people")
                .appendingInfo(infoLevel)
        case .popular(let pagination):
            return movies.appendingPathComponent("popular")
                .appendingPagination(pagination)
        case .ratings(let movieId):
            return movies.appendingPathComponent("\(movieId)/ratings")
        case .recentlyUpdated(let pagination, let startDate, let infoLevel):
            return movies.appendingPathComponent("updates/\(startDate)")
                .appendingPagination(pagination)
                .appendingInfo(infoLevel)
        case .recommended(let pagination, let timePeriod, let infoLevel):
            return movies
                .appendingPathComponent("recommended")
                .appendingTimePeriod(timePeriod)
                .appendingPagination(pagination)
                .appendingInfo(infoLevel)
        case .related(let movieId, let pagination, let infoLevel):
            return movies.appendingPathComponent("\(movieId)/related")
                .appendingPagination(pagination)
                .appendingInfo(infoLevel)
        case .releases(let movieId, let country):
            return movies.appendingPathComponent("\(movieId)/releases/\(country)")
        case .stats(let movieId):
            return movies.appendingPathComponent("\(movieId)/stats")
        case .translations(let movieId, let language):
            return movies.appendingPathComponent("\(movieId)/translations/\(language)")
        case .trending(let pagination, let infoLevel):
            return movies.appendingPathComponent("trending")
                .appendingPagination(pagination)
                .appendingInfo(infoLevel)
        }
    }
}
