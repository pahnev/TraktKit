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

public extension Trakt {
    struct MovieEndpoints {
        let trakt: Trakt

        func getTrendingMovies(pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel = .min, completion: @escaping PaginatedTraktResult<[TrendingMovie]>) {
            trakt.fetchPaginatedObject(ofType: [TrendingMovie].self,
                                       endpoint: Movies.trending(pageNumber: pageNumber, resultsPerPage: resultsPerPage, infoLevel: infoLevel),
                                       completion: completion)
        }

        func getPopularMovies(pageNumber: Int, resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[Movie]>) {
            trakt.fetchPaginatedObject(ofType: [Movie].self,
                                       endpoint: Movies.popular(pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                                       completion: completion)
        }

        func getMostPlayedMovies(pageNumber: Int, timePeriod: String = "", resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
            trakt.fetchPaginatedObject(ofType: [MostMovie].self,
                                       endpoint: Movies.mostPlayed(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                                       completion: completion)
        }

        func getMostWatchedMovies(pageNumber: Int, timePeriod: String = "", resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
            trakt.fetchPaginatedObject(ofType: [MostMovie].self,
                                       endpoint: Movies.mostWatched(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                                       completion: completion)
        }

        func getMostCollectedMovies(pageNumber: Int, timePeriod: String = "", resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
            trakt.fetchPaginatedObject(ofType: [MostMovie].self,
                                       endpoint: Movies.mostCollected(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                                       completion: completion)
        }

        /// Returns the top 10 grossing movies in the U.S. box office last weekend. Updated every Monday morning.
        ///
        /// - Parameter completion: The closure called on completion with list of Movies or TraktError
        func getBoxOffice(completion: @escaping TraktResult<[BoxOfficeMovie]>) {
            trakt.fetchObject(ofType: [BoxOfficeMovie].self, endpoint: Movies.boxOffice, completion: completion)
        }

        func getRecentlyUpdatedMovies(pageNumber: Int, startDate: String = "", resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[UpdatedMoviesResponse]>) {
            trakt.fetchPaginatedObject(ofType: [UpdatedMoviesResponse].self,
                                       endpoint: Movies.recentlyUpdated(pageNumber: pageNumber, startDate: startDate, resultsPerPage: resultsPerPage),
                                       completion: completion)
        }

        func getMovieDetails(for movieId: Int, infoLevel: InfoLevel = .full, completion: @escaping TraktResult<Movie>) {
            trakt.fetchObject(ofType: Movie.self,
                              endpoint: Movies.details(movieId: movieId, infoLevel: infoLevel),
                              completion: completion)
        }

        func getAliases(for movieId: Int, completion: @escaping TraktResult<[Alias]>) {
            trakt.fetchObject(ofType: [Alias].self, endpoint: Movies.aliases(movieId: movieId), completion: completion)
        }

        func getReleases(for movieId: Int, country: String, completion: @escaping TraktResult<[MovieRelease]>) {
            trakt.fetchObject(ofType: [MovieRelease].self,
                              endpoint: Movies.releases(movieId: movieId, country: country),
                              completion: completion)
        }

        func getComments(for movieId: Int, pageNumber: Int, resultsPerPage: Int = 10, sort: String, completion: @escaping TraktResult<[Comment]>) {
            trakt.fetchObject(ofType: [Comment].self,
                              endpoint: Movies.comments(movieId: movieId, sort: sort, pageNumber: pageNumber, resultsPerPage: resultsPerPage), completion: completion)
        }

        func getLists(for movieId: Int, type: String, sortBy: String, pageNumber: Int, resultsPerPage: Int = 10, completion: @escaping TraktResult<[List]>) {
            trakt.fetchObject(ofType: [List].self,
                              endpoint: Movies.lists(movieId: movieId, type: type, sort: sortBy, pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                              completion: completion)
        }

        func getPeople(for movieId: Int, completion: @escaping TraktResult<CastAndCrew>) {
            trakt.fetchObject(ofType: CastAndCrew.self, endpoint: Movies.people(movieId: movieId), completion: completion)
        }

        func getRatings(for movieId: Int, completion: @escaping TraktResult<RatingDistribution>) {
            trakt.fetchObject(ofType: RatingDistribution.self, endpoint: Movies.ratings(movieId: movieId), completion: completion)
        }

        func getRelatedMovies(for movieId: Int, pageNumber: Int, resultsPerPage: Int = 10, completion: @escaping TraktResult<[Movie]>) {
            trakt.fetchObject(ofType: [Movie].self,
                              endpoint: Movies.related(movieId: movieId, pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                              completion: completion)
        }

        func getStats(for movieId: Int, completion: @escaping TraktResult<Stats>) {
            trakt.fetchObject(ofType: Stats.self, endpoint: Movies.stats(movieId: movieId), completion: completion)
        }

        func getCurrentlyWatching(for movieId: Int, completion: @escaping TraktResult<[User]>) {
            trakt.fetchObject(ofType: [User].self, endpoint: Movies.currentlyWatching(movieId: movieId), completion: completion)
        }
    }
}
