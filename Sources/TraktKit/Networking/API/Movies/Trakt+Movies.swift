//
//  Trakt+Movies.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 02/08/2018.
//

import Foundation

/// Represents the amount of data the backend should send in the response.
///
/// - min: For minimal info about the movie item. Typically all you need to match locally cached items and includes the title, year, and ids.
/// - full: For complete info of the movie item.

/// Represents the amount of data the backend should send in the response.
///
/// - min: For minimal info about the item. Typically all you need to match locally cached items and includes the title, year, and ids.
/// - full: For complete info of the item.
/// - metadata: For additional metadata info in collections. Has no effect in other endpoints.
public enum InfoLevel: String {
    case min, full, metadata
}

public enum TimePeriod: String {
    case daily
    case weekly
    case monthly
    case yearly
    case all
}

public enum CommentSort: String {
    case newest
    case oldest
    case likes
    case replies
    case highest
    case lowest
    case plays
}

public enum ListType: String {
    case all
    case personal
    case official
    case watchlists
    case recommendations
}

public enum ListSort: String {
    case popular
    case likes
    case comments
    case items
    case added
    case updated
}

public extension Trakt {
    struct MovieEndpoints {
        let trakt: Trakt

        func trending(pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel?, completion: @escaping PaginatedTraktResult<[TrendingMovie]>) {
            trakt.fetchPaginatedObject(ofType: [TrendingMovie].self,
                                       endpoint: Movies.trending(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                 infoLevel: infoLevel),
                                       completion: completion)
        }

        func popular(pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[Movie]>) {
            trakt.fetchPaginatedObject(ofType: [Movie].self,
                                       endpoint: Movies.popular(pagination: Pagination(page: pageNumber, limit: resultsPerPage)),
                                       completion: completion)
        }

        /// Returns the most recommended movies in the specified time.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page.
        ///   - timePeriod: The `TimePeriod` of the results. Defaults to `weekly`.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `RecommendedMovie` or `TraktError`.
        func recommended(pageNumber: Int, resultsPerPage: Int = 10, timePeriod: TimePeriod? = nil, infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[RecommendedMovie]>) {
            trakt.fetchPaginatedObject(ofType: [RecommendedMovie].self,
                                       endpoint: Movies.recommended(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                    timePeriod: timePeriod,
                                                                    infoLevel: infoLevel),
                                       completion: completion)
        }
        func mostPlayed(pageNumber: Int, resultsPerPage: Int = 10, timePeriod: TimePeriod? = nil, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
            trakt.fetchPaginatedObject(ofType: [MostMovie].self,
                                       endpoint: Movies.mostPlayed(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                   timePeriod: timePeriod),
                                       completion: completion)
        }

        func mostWatched(pageNumber: Int, resultsPerPage: Int = 10, timePeriod: TimePeriod? = nil, infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
            trakt.fetchPaginatedObject(ofType: [MostMovie].self,
                                       endpoint: Movies.mostWatched(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                    timePeriod: timePeriod,
                                                                    infoLevel: infoLevel),
                                       completion: completion)
        }

        func mostCollected(pageNumber: Int, resultsPerPage: Int = 10, timePeriod: TimePeriod? = nil, infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
            trakt.fetchPaginatedObject(ofType: [MostMovie].self,
                                       endpoint: Movies.mostCollected(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                      timePeriod: timePeriod,
                                                                      infoLevel: infoLevel),
                                       completion: completion)
        }

        /// Returns the most anticipated movies based on the number of lists a movie appears on.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[AnticipatedMovie]` or `TraktError`.
        func mostAnticipated(pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[AnticipatedMovie]>) {
            trakt.fetchPaginatedObject(ofType: [AnticipatedMovie].self,
                                       endpoint: Movies.mostAnticipated(pagination: Pagination(page: pageNumber
                                                                                               , limit: resultsPerPage),
                                                                        infoLevel: infoLevel),
                                       completion: completion)
        }

        /// Returns the top 10 grossing movies in the U.S. box office last weekend. Updated every Monday morning.
        ///
        /// - Parameter completion: The closure called on completion with list of Movies or TraktError
        func boxOffice(infoLevel: InfoLevel? = nil, completion: @escaping TraktResult<[BoxOfficeMovie]>) {
            trakt.fetchObject(ofType: [BoxOfficeMovie].self,
                              endpoint: Movies.boxOffice(infoLevel: infoLevel),
                              completion: completion)
        }

        func recentlyUpdated(pageNumber: Int, resultsPerPage: Int = 10, startDate: String = "", infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[UpdatedMoviesResponse]>) {
            trakt.fetchPaginatedObject(ofType: [UpdatedMoviesResponse].self,
                                       endpoint: Movies.recentlyUpdated(pagination: Pagination(page: pageNumber,
                                                                                               limit: resultsPerPage),
                                                                        startDate: startDate,
                                                                        infoLevel: infoLevel),
                                       completion: completion)
        }

        /// Returns all movie Trakt IDs updated since the specified UTC date and time.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - completion: Result of a `[Int]` or `TraktError`.
        func updatedIds(pageNumber: Int, resultsPerPage: Int = 10, startDate: Date, completion: @escaping PaginatedTraktResult<[Int]>) {
            trakt.fetchPaginatedObject(ofType: [Int].self,
                                       endpoint: Movies.updates(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                startDate: startDate),
                                       completion: completion)
        }

        func details(for movieId: Int, infoLevel: InfoLevel = .full, completion: @escaping TraktResult<Movie>) {
            trakt.fetchObject(ofType: Movie.self,
                              endpoint: Movies.details(movieId: movieId, infoLevel: infoLevel),
                              completion: completion)
        }

        func aliases(for movieId: Int, completion: @escaping TraktResult<[Alias]>) {
            trakt.fetchObject(ofType: [Alias].self, endpoint: Movies.aliases(movieId: movieId), completion: completion)
        }

        func releases(for movieId: Int, country: String, completion: @escaping TraktResult<[MovieRelease]>) {
            trakt.fetchObject(ofType: [MovieRelease].self,
                              endpoint: Movies.releases(movieId: movieId, country: country),
                              completion: completion)
        }

        /// Returns all translations for a movie, including language and translated values for title, tagline and overview.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - language: 2 character country code Example: us.
        ///   - completion: Result of a `[MovieTranslation]` or `TraktError`.
        func translations(for movieId: Int, language: String, completion: @escaping TraktResult<[MovieTranslation]>) {
            trakt.fetchObject(ofType: [MovieTranslation].self,
                              endpoint: Movies.translations(movieId: movieId,
                                                            language: language), completion: completion)
        }

        func comments(for movieId: Int, pageNumber: Int, resultsPerPage: Int = 10, sortBy: CommentSort? = nil, completion: @escaping TraktResult<[Comment]>) {
            trakt.fetchObject(ofType: [Comment].self,
                              endpoint: Movies.comments(movieId: movieId,
                                                        sort: sortBy,
                                                        pagination: Pagination(page: pageNumber, limit: resultsPerPage)),
                              completion: completion)
        }

        func lists(for movieId: Int, pageNumber: Int, resultsPerPage: Int = 10, type: ListType? = nil, sortBy: ListSort? = nil, completion: @escaping TraktResult<[List]>) {
            trakt.fetchObject(ofType: [List].self,
                              endpoint: Movies.lists(movieId: movieId,
                                                     type: type,
                                                     sort: sortBy,
                                                     pagination: Pagination(page: pageNumber, limit: resultsPerPage)),
                              completion: completion)
        }

        func people(for movieId: Int, infoLevel: InfoLevel? = nil, completion: @escaping TraktResult<CastAndCrew>) {
            trakt.fetchObject(ofType: CastAndCrew.self,
                              endpoint: Movies.people(movieId: movieId, infoLevel: infoLevel),
                              completion: completion)
        }

        func ratings(for movieId: Int, completion: @escaping TraktResult<RatingDistribution>) {
            trakt.fetchObject(ofType: RatingDistribution.self, endpoint: Movies.ratings(movieId: movieId), completion: completion)
        }

        func relatedMovies(for movieId: Int, pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel? = nil, completion: @escaping TraktResult<[Movie]>) {
            trakt.fetchObject(ofType: [Movie].self,
                              endpoint: Movies.related(movieId: movieId,
                                                       pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                      infoLevel: infoLevel),
                              completion: completion)
        }

        func stats(for movieId: Int, completion: @escaping TraktResult<Stats>) {
            trakt.fetchObject(ofType: Stats.self, endpoint: Movies.stats(movieId: movieId), completion: completion)
        }

        func usersWatching(_ movieId: Int, infoLevel: InfoLevel? = nil, completion: @escaping TraktResult<[User]>) {
            trakt.fetchObject(ofType: [User].self,
                              endpoint: Movies.currentlyWatching(movieId: movieId, infoLevel: infoLevel),
                              completion: completion)
        }
    }
}
