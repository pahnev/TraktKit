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

    func getTrendingMovies(pageNumber: Int, resultsPerPage: Int = 10, infoLevel: InfoLevel = .min, completion: @escaping PaginatedTraktResult<[TrendingMovie]>) {
        fetchPaginatedObject(ofType: [TrendingMovie].self,
                    cacheConfig: Movies.trending(pageNumber: pageNumber, resultsPerPage: resultsPerPage, infoLevel: infoLevel),
                    endpoint: Movies.trending(pageNumber: pageNumber, resultsPerPage: resultsPerPage, infoLevel: infoLevel),
                    completion: completion)
    }

    func getPopularMovies(pageNumber: Int, resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[Movie]>) {
        fetchPaginatedObject(ofType: [Movie].self,
                    cacheConfig: Movies.popular(pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                    endpoint: Movies.popular(pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                    completion: completion)
    }

    func getMostPlayedMovies(pageNumber: Int, timePeriod: String = "", resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
        fetchPaginatedObject(ofType: [MostMovie].self,
                    cacheConfig: Movies.mostPlayed(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                    endpoint: Movies.mostPlayed(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                    completion: completion)

    }

    func getMostWatchedMovies(pageNumber: Int, timePeriod: String = "", resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
        fetchPaginatedObject(ofType: [MostMovie].self,
                    cacheConfig: Movies.mostWatched(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                    endpoint: Movies.mostWatched(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                    completion: completion)

    }

    func getMostCollectedMovies(pageNumber: Int, timePeriod: String = "", resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[MostMovie]>) {
        fetchPaginatedObject(ofType: [MostMovie].self,
                    cacheConfig: Movies.mostCollected(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                    endpoint: Movies.mostCollected(pageNumber: pageNumber, timePeriod: timePeriod, resultsPerPage: resultsPerPage),
                    completion: completion)
    }

    /// Returns the top 10 grossing movies in the U.S. box office last weekend. Updated every Monday morning.
    ///
    /// - Parameter completion: The closure callend on completion with list of Movies or TraktError
    func getBoxOffice(completion: @escaping TraktResult<[BoxOfficeMovie]>) {
        fetchObject(ofType: [BoxOfficeMovie].self, cacheConfig: Movies.boxOffice, endpoint: Movies.boxOffice, completion: completion)
    }

    func getRecentlyUpdatedMovies(pageNumber: Int, startDate: String = "", resultsPerPage: Int = 10, completion: @escaping PaginatedTraktResult<[UpdatedMoviesResponse]>) {
        fetchPaginatedObject(ofType: [UpdatedMoviesResponse].self,
                    cacheConfig: Movies.recentlyUpdated(pageNumber: pageNumber, startDate: startDate, resultsPerPage: resultsPerPage),
                    endpoint: Movies.recentlyUpdated(pageNumber: pageNumber, startDate: startDate, resultsPerPage: resultsPerPage),
                    completion: completion)
    }

    func getMovieDetails(for movieId: TraktId, infoLevel: InfoLevel = .full, completion: @escaping TraktResult<Movie>) {
        fetchObject(ofType: Movie.self,
                    cacheConfig: Movies.details(movieId: movieId, infoLevel: infoLevel),
                    endpoint: Movies.details(movieId: movieId, infoLevel: infoLevel),
                    completion: completion)
    }

    func getAliases(for movieId: TraktId, completion: @escaping TraktResult<[Alias]>) {
        fetchObject(ofType: [Alias].self, cacheConfig: Movies.aliases(movieId: movieId), endpoint: Movies.aliases(movieId: movieId), completion: completion)
    }

    func getReleases(for movieId: TraktId, country: String, completion: @escaping TraktResult<[MovieRelease]>) {
        fetchObject(ofType: [MovieRelease].self,
                    cacheConfig: Movies.releases(movieId: movieId, country: country),
                    endpoint: Movies.releases(movieId: movieId, country: country),
                    completion: completion)
    }

    func getComments(for movieId: TraktId, pageNumber: Int, resultsPerPage: Int = 10, sort: String, completion: @escaping TraktResult<[Comment]>) {
        fetchObject(ofType: [Comment].self,
                    cacheConfig: Movies.comments(movieId: movieId, sort: sort, pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                    endpoint: Movies.comments(movieId: movieId, sort: sort, pageNumber: pageNumber, resultsPerPage: resultsPerPage), completion: completion)
    }

    func getLists(for movieId: TraktId, type: String, sortBy: String, pageNumber: Int, resultsPerPage: Int = 10, completion: @escaping TraktResult<[List]>) {
        fetchObject(ofType: [List].self,
                    cacheConfig: Movies.lists(movieId: movieId, type: type, sort: sortBy, pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                    endpoint: Movies.lists(movieId: movieId, type: type, sort: sortBy, pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                    completion: completion)
    }

    func getPeople(for movieId: TraktId, completion: @escaping TraktResult<CastAndCrew>) {
        fetchObject(ofType: CastAndCrew.self, cacheConfig: Movies.people(movieId: movieId), endpoint: Movies.people(movieId: movieId), completion: completion)
    }

    func getRatings(for movieId: TraktId, completion: @escaping TraktResult<RatingDistribution>) {
        fetchObject(ofType: RatingDistribution.self, cacheConfig: Movies.ratings(movieId: movieId), endpoint: Movies.ratings(movieId: movieId), completion: completion)
    }

    func getRelatedMovies(for movieId: TraktId, pageNumber: Int, resultsPerPage: Int = 10, completion: @escaping TraktResult<[Movie]>) {
        fetchObject(ofType: [Movie].self,
                    cacheConfig: Movies.related(movieId: movieId, pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                    endpoint: Movies.related(movieId: movieId, pageNumber: pageNumber, resultsPerPage: resultsPerPage),
                    completion: completion)
    }

    func getStats(for movieId: TraktId, completion: @escaping TraktResult<Stats>) {
        fetchObject(ofType: Stats.self, cacheConfig: Movies.stats(movieId: movieId), endpoint: Movies.stats(movieId: movieId), completion: completion)
    }

    func getCurrentlyWatching(for movieId: TraktId, completion: @escaping TraktResult<[User]>) {
        fetchObject(ofType: [User].self, cacheConfig: Movies.currentlyWatching(movieId: movieId), endpoint: Movies.currentlyWatching(movieId: movieId), completion: completion)
    }
}
