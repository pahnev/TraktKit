//
//  MoviesEndpointTests.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 14/02/2019.
//

import XCTest
@testable import TraktKit

class MoviesEndpointTests: TraktKitTestCase {
    let darkKnightId = 120
    let deadPoolId = 190430

    func testReturnsMinimalTrendingMovies() throws {
        stubHelper.stubWithLocalFile(Movies.trending(pageNumber: 1, resultsPerPage: 10, infoLevel: .min), info: .min)

        let movies = try awaitFor { trakt.movies.getTrendingMovies(pageNumber: 1, infoLevel: .min, completion: $0) }.get().type

        XCTAssertNotNil(movies)
        XCTAssertNotNil(movies.first?.movie)
    }

    func testReturnsFullTrendingMovies() throws {
        stubHelper.stubWithLocalFile(Movies.trending(pageNumber: 1, resultsPerPage: 10, infoLevel: .full), info: .full)

        let movies = try awaitFor { trakt.movies.getTrendingMovies(pageNumber: 1, infoLevel: .full, completion: $0) }.get().type

        XCTAssertNotNil(movies)
        XCTAssertNotNil(movies.first?.movie.tagline)
    }

    func testReturnsPopularMovies() throws {
        stubHelper.stubWithLocalFile(Movies.popular(pageNumber: 1, resultsPerPage: 10))

        let movies = try awaitFor { trakt.movies.getPopularMovies(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsMostPlayedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.mostPlayed(pageNumber: 1, timePeriod: "", resultsPerPage: 10))

        let movies = try awaitFor { trakt.movies.getMostPlayedMovies(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsMostWatchedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.mostWatched(pageNumber: 1, timePeriod: "", resultsPerPage: 10))

        let movies = try awaitFor { trakt.movies.getMostWatchedMovies(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsMostCollectedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.mostCollected(pageNumber: 1, timePeriod: "", resultsPerPage: 10))

        let movies = try awaitFor { trakt.movies.getMostCollectedMovies(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsBoxOfficeMovies() throws {
        stubHelper.stubWithLocalFile(Movies.boxOffice)

        let movies = try awaitFor { trakt.movies.getBoxOffice(completion: $0) }.get()

        XCTAssertNotNil(movies)
    }

    func testReturnsRecentlyUpdatedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.recentlyUpdated(pageNumber: 1, startDate: "", resultsPerPage: 10))

        let movies = try awaitFor { trakt.movies.getRecentlyUpdatedMovies(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsMinimalMovieDetails() throws {
        stubHelper.stubWithLocalFile(Movies.details(movieId: darkKnightId, infoLevel: .min), info: .min)

        let movie = try awaitFor { trakt.movies.getMovieDetails(for: darkKnightId, infoLevel: .min, completion: $0) }.get()

        XCTAssertNotNil(movie)
        XCTAssertNil(movie.tagline)
    }

    func testReturnsFullMovieDetails() throws {
        stubHelper.stubWithLocalFile(Movies.details(movieId: darkKnightId, infoLevel: .full), info: .full)

        let movie = try awaitFor { trakt.movies.getMovieDetails(for: darkKnightId, infoLevel: .full, completion: $0) }.get()

        XCTAssertNotNil(movie)
        XCTAssertNotNil(movie.tagline)
    }

    func testReturnsAliases() throws {
        stubHelper.stubWithLocalFile(Movies.aliases(movieId: darkKnightId))

        let aliases = try awaitFor { trakt.movies.getAliases(for: darkKnightId, completion: $0) }.get()

        XCTAssertNotNil(aliases)
    }

    func testReturnsReleases() throws {
        stubHelper.stubWithLocalFile(Movies.releases(movieId: darkKnightId, country: ""))

        let releases = try awaitFor { trakt.movies.getReleases(for: darkKnightId, country: "", completion: $0) }.get()

        XCTAssertNotNil(releases)
    }

    func testReturnsComments() throws {
        stubHelper.stubWithLocalFile(Movies.comments(movieId: darkKnightId, sort: "", pageNumber: 1, resultsPerPage: 10))

        let comments = try awaitFor { trakt.movies.getComments(for: darkKnightId, pageNumber: 1, sort: "", completion: $0) }.get()

        XCTAssertNotNil(comments)
    }

    func testReturnsLists() throws {
        stubHelper.stubWithLocalFile(Movies.lists(movieId: darkKnightId, type: "", sort: "", pageNumber: 1, resultsPerPage: 10))

        let lists = try awaitFor { trakt.movies.getLists(for: darkKnightId, type: "", sortBy: "", pageNumber: 1, completion: $0) }.get()

        XCTAssertNotNil(lists)
    }

    func testReturnsPeople() throws {
        stubHelper.stubWithLocalFile(Movies.people(movieId: darkKnightId))

        let people = try awaitFor { trakt.movies.getPeople(for: darkKnightId, completion: $0) }.get()

        XCTAssertNotNil(people)
    }

    func testReturnsRatings() throws {
        stubHelper.stubWithLocalFile(Movies.ratings(movieId: darkKnightId))

        let ratings = try awaitFor { trakt.movies.getRatings(for: darkKnightId, completion: $0) }.get()

        XCTAssertNotNil(ratings)
    }

    func testReturnsRelatedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.related(movieId: darkKnightId, pageNumber: 1, resultsPerPage: 10))

        let movies = try awaitFor { trakt.movies.getRelatedMovies(for: darkKnightId, pageNumber: 1, completion: $0) }.get()

        XCTAssertNotNil(movies)
    }

    func testReturnsStats() throws {
        stubHelper.stubWithLocalFile(Movies.stats(movieId: darkKnightId))

        let stats = try awaitFor { trakt.movies.getStats(for: darkKnightId, completion: $0) }.get()

        XCTAssertNotNil(stats)
    }

    func testReturnsCurrentlyWatching() throws {
        stubHelper.stubWithLocalFile(Movies.currentlyWatching(movieId: deadPoolId))

        let watching = try awaitFor { trakt.movies.getCurrentlyWatching(for: deadPoolId, completion: $0) }.get()

        XCTAssertNotNil(watching)
    }
}
