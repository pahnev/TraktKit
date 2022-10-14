//
//  Trakt+Movies.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 02/08/2018.
//

import Foundation

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

        /// Returns all movies being watched right now. Movies with the most users are returned first.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - infoLevel: The `InfoLevel` of the results.
        ///   - completion: Result of a `[TrendingMovie]` or `TraktError`.
        func trending(pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel?, completion: @escaping PaginatedTraktResult<[TrendingMovie]>) {
            trakt.fetchPaginatedObject(ofType: [TrendingMovie].self,
                                       endpoint: Movies.trending(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                 infoLevel: infoLevel),
                                       completion: completion)
        }

        /// Returns the most popular movies. Popularity is calculated using the rating percentage and the number of ratings.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - infoLevel: The `InfoLevel` of the results.
        ///   - completion: Result of a `[Movie]` or `TraktError`.
        func popular(pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[Movie]>) {
            trakt.fetchPaginatedObject(ofType: [Movie].self,
                                       endpoint: Movies.popular(pagination: Pagination(page: pageNumber, limit: resultsPerPage)),
                                       completion: completion)
        }

        /// Returns the most recommended movies in the specified time.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - timePeriod: The `TimePeriod` of the results. Defaults to `weekly`.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[RecommendedMovie]` or `TraktError`.
        func recommended(pageNumber: Int, resultsPerPage: Int = 10, timePeriod: TimePeriod? = nil, infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[RecommendedMovie]>) {
            trakt.fetchPaginatedObject(ofType: [RecommendedMovie].self,
                                       endpoint: Movies.recommended(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                    timePeriod: timePeriod,
                                                                    infoLevel: infoLevel),
                                       completion: completion)
        }

        /// Returns the most played (a single user can watch multiple times) movies in the specified time
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - timePeriod: The `TimePeriod` of the results. Defaults to `weekly`.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[MostMovie]` or `TraktError`.
        func mostPlayed(pageNumber: Int, resultsPerPage: Int = 10, timePeriod: TimePeriod? = nil, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
            trakt.fetchPaginatedObject(ofType: [MostMovie].self,
                                       endpoint: Movies.mostPlayed(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                   timePeriod: timePeriod),
                                       completion: completion)
        }

        /// Returns the most watched (unique users) movies in the specified time.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - timePeriod: The `TimePeriod` of the results. Defaults to `weekly`.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[MostMovie]` or `TraktError`.
        func mostWatched(pageNumber: Int, resultsPerPage: Int = 10, timePeriod: TimePeriod? = nil, infoLevel: InfoLevel? = nil, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
            trakt.fetchPaginatedObject(ofType: [MostMovie].self,
                                       endpoint: Movies.mostWatched(pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                                    timePeriod: timePeriod,
                                                                    infoLevel: infoLevel),
                                       completion: completion)
        }

        /// Returns the most collected (unique users) movies in the specified time.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - timePeriod: The `TimePeriod` of the results. Defaults to `weekly`.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[MostMovie]` or `TraktError`.
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
        /// - Parameters:
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[BoxOfficeMovie]` or `TraktError`.
        func boxOffice(infoLevel: InfoLevel? = nil, completion: @escaping TraktResult<[BoxOfficeMovie]>) {
            trakt.fetchObject(ofType: [BoxOfficeMovie].self,
                              endpoint: Movies.boxOffice(infoLevel: infoLevel),
                              completion: completion)
        }

        /// Returns all movies updated since the specified UTC date and time.
        ///
        /// - Parameters:
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - startDate: The startDate is only accurate to the hour, for caching purposes. Can only be a maximum of 30 days in the past
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[UpdatedMoviesResponse]` or `TraktError`.
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

        /// Returns a single movie's details.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.full`.
        ///   - completion: Result of a `Movie` or `TraktError`.
        func details(for movieId: Int, infoLevel: InfoLevel = .full, completion: @escaping TraktResult<Movie>) {
            trakt.fetchObject(ofType: Movie.self,
                              endpoint: Movies.details(movieId: movieId, infoLevel: infoLevel),
                              completion: completion)
        }

        /// Returns all title aliases for a movie. Includes country where name is different.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - completion: Result of a `[Alias]` or `TraktError`.
        func aliases(for movieId: Int, completion: @escaping TraktResult<[Alias]>) {
            trakt.fetchObject(ofType: [Alias].self, endpoint: Movies.aliases(movieId: movieId), completion: completion)
        }

        /// Returns all releases for a movie including country, certification, release date, release type, and note.
        /// The release type can be set to unknown, premiere, limited, theatrical, digital, physical, or tv.
        /// The note might have optional info such as the film festival name for a premiere release or Blu-ray specs for a physical release.
        /// We pull this info from TMDB.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - country: 2 character country code Example: us.
        ///   - completion: Result of a `[MovieRelease]` or `TraktError`.
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

        /// Returns all top level comments for a movie.
        /// By default, the `.newest` comments are returned first.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - sortBy: How to sort the results.
        ///   - completion: Result of a `[Comment]` or `TraktError`.
        func comments(for movieId: Int, pageNumber: Int, resultsPerPage: Int = 10, sortBy: CommentSort? = nil, completion: @escaping TraktResult<[Comment]>) {
            trakt.fetchObject(ofType: [Comment].self,
                              endpoint: Movies.comments(movieId: movieId,
                                                        sort: sortBy,
                                                        pagination: Pagination(page: pageNumber, limit: resultsPerPage)),
                              completion: completion)
        }

        /// Returns all lists that contain this movie.
        /// By default, `ListType.personal` lists are returned sorted by the most `ListSort.popular`
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - type: Filter for a specific list type.
        ///   - sort: How to sort the results.
        ///   - completion: Result of a `[List]` or `TraktError`.
        func lists(for movieId: Int, pageNumber: Int, resultsPerPage: Int = 10, type: ListType? = nil, sortBy: ListSort? = nil, completion: @escaping TraktResult<[List]>) {
            trakt.fetchObject(ofType: [List].self,
                              endpoint: Movies.lists(movieId: movieId,
                                                     type: type,
                                                     sort: sortBy,
                                                     pagination: Pagination(page: pageNumber, limit: resultsPerPage)),
                              completion: completion)
        }

        /// Returns all cast and crew for a movie.
        /// Each cast member will have a characters array and a standard person object
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.full`.
        ///   - completion: Result of a `CastAndCrew` or `TraktError`.
        func people(for movieId: Int, infoLevel: InfoLevel? = nil, completion: @escaping TraktResult<CastAndCrew>) {
            trakt.fetchObject(ofType: CastAndCrew.self,
                              endpoint: Movies.people(movieId: movieId, infoLevel: infoLevel),
                              completion: completion)
        }

        /// Returns rating (between 0 and 10) and distribution for a movie.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - completion: Result of a `RatingDistribution` or `TraktError`.
        func ratings(for movieId: Int, completion: @escaping TraktResult<RatingDistribution>) {
            trakt.fetchObject(ofType: RatingDistribution.self, endpoint: Movies.ratings(movieId: movieId), completion: completion)
        }

        /// Returns related and similar movies.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - pageNumber: Number of page of results to be returned.
        ///   - resultsPerPage: Number of results to return per page. Defaults to 10.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[Movie]` or `TraktError`.
        func relatedMovies(for movieId: Int, pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel? = nil, completion: @escaping TraktResult<[Movie]>) {
            trakt.fetchObject(ofType: [Movie].self,
                              endpoint: Movies.related(movieId: movieId,
                                                       pagination: Pagination(page: pageNumber, limit: resultsPerPage),
                                                      infoLevel: infoLevel),
                              completion: completion)
        }

        /// Returns lots of movie stats.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - completion: Result of a `Stats` or `TraktError`.
        func stats(for movieId: Int, completion: @escaping TraktResult<Stats>) {
            trakt.fetchObject(ofType: Stats.self, endpoint: Movies.stats(movieId: movieId), completion: completion)
        }

        /// Returns all users watching this movie right now.
        ///
        /// - Parameters:
        ///   - movieId: The id of the movie. Either `ID.trakt`, `ID.slug`, or `ID.imdb`.
        ///   - infoLevel: The `InfoLevel` of the results. Defaults to `.min`.
        ///   - completion: Result of a `[User]` or `TraktError`.
        func usersWatching(_ movieId: Int, infoLevel: InfoLevel? = nil, completion: @escaping TraktResult<[User]>) {
            trakt.fetchObject(ofType: [User].self,
                              endpoint: Movies.currentlyWatching(movieId: movieId, infoLevel: infoLevel),
                              completion: completion)
        }
    }
}
