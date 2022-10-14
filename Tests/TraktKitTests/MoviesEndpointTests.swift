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
        stubHelper.stubWithLocalFile(Movies.trending(pagination: .default, infoLevel: .min), info: .min)

        let movies = try awaitFor { trakt.movies.trending(pageNumber: 1, infoLevel: .min, completion: $0) }.get().type

        XCTAssertNotNil(movies)
        XCTAssertNotNil(movies.first?.movie)
    }

    func testReturnsFullTrendingMovies() throws {
        stubHelper.stubWithLocalFile(Movies.trending(pagination: .default, infoLevel: .full), info: .full)

        let movies = try awaitFor { trakt.movies.trending(pageNumber: 1, infoLevel: .full, completion: $0) }.get().type

        XCTAssertNotNil(movies)
        XCTAssertNotNil(movies.first?.movie.tagline)
    }

    func testReturnsPopularMovies() throws {
        stubHelper.stubWithLocalFile(Movies.popular(pagination: .default))

        let movies = try awaitFor { trakt.movies.popular(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsRecommendedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.recommended(pagination: .default, timePeriod: nil, infoLevel: nil))

        let movies = try awaitFor { trakt.movies.recommended(pageNumber: 1, completion: $0) }.get()

        XCTAssertNotNil(movies)

        let firstMovie = try XCTUnwrap(movies.type.first)
        XCTAssertEqual(firstMovie.userCount, 51)
    }

    func testReturnsMostPlayedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.mostPlayed(pagination: .default, timePeriod: nil))

        let movies = try awaitFor { trakt.movies.mostPlayed(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsMostWatchedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.mostWatched(pagination: .default, timePeriod: nil, infoLevel: nil))

        let movies = try awaitFor { trakt.movies.mostWatched(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsMostCollectedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.mostCollected(pagination: .default, timePeriod: nil, infoLevel: nil))

        let movies = try awaitFor { trakt.movies.mostCollected(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsMostAnticipatedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.mostAnticipated(pagination: .default, infoLevel: nil))

        let movies = try awaitFor { trakt.movies.mostAnticipated(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsBoxOfficeMovies() throws {
        stubHelper.stubWithLocalFile(Movies.boxOffice(infoLevel: nil))

        let movies = try awaitFor { trakt.movies.boxOffice(completion: $0) }.get()

        XCTAssertNotNil(movies)
    }

    func testReturnsRecentlyUpdatedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.recentlyUpdated(pagination: .default, startDate: "", infoLevel: nil))

        let movies = try awaitFor { trakt.movies.recentlyUpdated(pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(movies)
    }

    func testReturnsMinimalMovieDetails() throws {
        stubHelper.stubWithLocalFile(Movies.details(movieId: darkKnightId, infoLevel: .min), info: .min)

        let movie = try awaitFor { trakt.movies.details(for: darkKnightId, infoLevel: .min, completion: $0) }.get()

        XCTAssertNotNil(movie)
        XCTAssertNil(movie.tagline)
    }

    func testReturnsFullMovieDetails() throws {
        stubHelper.stubWithLocalFile(Movies.details(movieId: darkKnightId, infoLevel: .full), info: .full)

        let movie = try awaitFor { trakt.movies.details(for: darkKnightId, infoLevel: .full, completion: $0) }.get()

        XCTAssertNotNil(movie)
        XCTAssertNotNil(movie.tagline)
    }

    func testReturnsAliases() throws {
        stubHelper.stubWithLocalFile(Movies.aliases(movieId: darkKnightId))

        let aliases = try awaitFor { trakt.movies.aliases(for: darkKnightId, completion: $0) }.get()

        XCTAssertNotNil(aliases)
    }

    func testReturnsReleases() throws {
        stubHelper.stubWithLocalFile(Movies.releases(movieId: darkKnightId, country: ""))

        let releases = try awaitFor { trakt.movies.releases(for: darkKnightId, country: "", completion: $0) }.get()

        XCTAssertNotNil(releases)
    }

    func testReturnsComments() throws {
        stubHelper.stubWithLocalFile(Movies.comments(movieId: darkKnightId, sort: nil, pagination: .default))

        let comments = try awaitFor { trakt.movies.comments(for: darkKnightId, pageNumber: 1, completion: $0) }.get()

        XCTAssertNotNil(comments)
    }

    func testReturnsLists() throws {
        stubHelper.stubWithLocalFile(Movies.lists(movieId: darkKnightId, type: nil, sort: nil, pagination: .default))

        let lists = try awaitFor { trakt.movies.lists(for: darkKnightId, pageNumber: 1, completion: $0) }.get()

        XCTAssertNotNil(lists)
    }

    func testReturnsPeople() throws {
        stubHelper.stubWithLocalFile(Movies.people(movieId: darkKnightId, infoLevel: nil))

        let people = try awaitFor { trakt.movies.people(for: darkKnightId, completion: $0) }.get()

        XCTAssertNotNil(people)
    }

    func testReturnsRatings() throws {
        stubHelper.stubWithLocalFile(Movies.ratings(movieId: darkKnightId))

        let ratings = try awaitFor { trakt.movies.ratings(for: darkKnightId, completion: $0) }.get()

        XCTAssertNotNil(ratings)
    }

    func testReturnsRelatedMovies() throws {
        stubHelper.stubWithLocalFile(Movies.related(movieId: darkKnightId, pagination: .default, infoLevel: nil))

        let movies = try awaitFor { trakt.movies.relatedMovies(for: darkKnightId, pageNumber: 1, completion: $0) }.get()

        XCTAssertNotNil(movies)
    }

    func testReturnsStats() throws {
        stubHelper.stubWithLocalFile(Movies.stats(movieId: darkKnightId))

        let stats = try awaitFor { trakt.movies.stats(for: darkKnightId, completion: $0) }.get()

        XCTAssertNotNil(stats)
    }

    func testReturnsCurrentlyWatching() throws {
        stubHelper.stubWithLocalFile(Movies.currentlyWatching(movieId: deadPoolId, infoLevel: nil))

        let watching = try awaitFor { trakt.movies.usersWatching(deadPoolId, completion: $0) }.get()

        XCTAssertNotNil(watching)
    }
}
