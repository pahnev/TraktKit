//
//  MoviesEndpointTests.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 14/02/2019.
//

import Nimble
import OHHTTPStubsCore
import OHHTTPStubsSwift
import XCTest

@testable import TraktKit

class MoviesEndpointTests: TraktKitTestCase {
    let darkKnightId = TraktId(120)
    let deadPoolId = TraktId(190430)

    func testReturnsMinimalTrendingMovies() {
        stubHelper.stubWithLocalFile(Movies.trending(pageNumber: 1, resultsPerPage: 10, infoLevel: .min), info: .min)

        var movies: [TrendingMovie]?
        trakt.getTrendingMovies(pageNumber: 1, infoLevel: .min) { result in
            movies = try! result.get().type
        }
        expect(movies).toEventuallyNot(beNil())
        expect(movies?.first?.movie.rating).toEventually(beNil())
    }

    func testReturnsFullTrendingMovies() {
        stubHelper.stubWithLocalFile(Movies.trending(pageNumber: 1, resultsPerPage: 10, infoLevel: .full), info: .full)

        var movies: [TrendingMovie]?
        trakt.getTrendingMovies(pageNumber: 1, infoLevel: .full) { result in
            movies = try! result.get().type
        }
        expect(movies).toEventuallyNot(beNil())
        expect(movies?.first?.movie.tagline).toEventuallyNot(beNil())
    }

    func testReturnsPopularMovies() {
        stubHelper.stubWithLocalFile(Movies.popular(pageNumber: 1, resultsPerPage: 10))

        var movies: [Movie]?
        trakt.getPopularMovies(pageNumber: 1) { result in
            movies = try! result.get().type
        }
        expect(movies).toEventuallyNot(beNil())
    }

    func testReturnsMostPlayedMovies() {
        stubHelper.stubWithLocalFile(Movies.mostPlayed(pageNumber: 1, timePeriod: "", resultsPerPage: 10))

        var movies: [MostMovie]?
        trakt.getMostPlayedMovies(pageNumber: 1) { result in
            movies = try! result.get().type
        }
        expect(movies).toEventuallyNot(beNil())
    }

    func testReturnsMostWatchedMovies() {
        stubHelper.stubWithLocalFile(Movies.mostWatched(pageNumber: 1, timePeriod: "", resultsPerPage: 10))

        var movies: [MostMovie]?
        trakt.getMostWatchedMovies(pageNumber: 1) { result in
            movies = try! result.get().type
        }
        expect(movies).toEventuallyNot(beNil())
    }

    func testReturnsMostCollectedMovies() {
        stubHelper.stubWithLocalFile(Movies.mostCollected(pageNumber: 1, timePeriod: "", resultsPerPage: 10))

        var movies: [MostMovie]?
        trakt.getMostCollectedMovies(pageNumber: 1) { result in
            movies = try! result.get().type
        }
        expect(movies).toEventuallyNot(beNil())
    }

    func testReturnsBoxOfficeMovies() {
        stubHelper.stubWithLocalFile(Movies.boxOffice)

        var movies: [BoxOfficeMovie]?
        trakt.getBoxOffice { result in
            movies = try! result.get()
        }
        expect(movies).toEventuallyNot(beNil())
    }

    func testReturnsRecentlyUpdatedMovies() {
        stubHelper.stubWithLocalFile(Movies.recentlyUpdated(pageNumber: 1, startDate: "", resultsPerPage: 10))

        var movies: [UpdatedMoviesResponse]?
        trakt.getRecentlyUpdatedMovies(pageNumber: 1) { result in
            movies = try! result.get().type
        }
        expect(movies).toEventuallyNot(beNil())
    }

    func testReturnsMinimalMovieDetails() {
        stubHelper.stubWithLocalFile(Movies.details(movieId: darkKnightId, infoLevel: .min), info: .min)

        var movie: Movie?
        trakt.getMovieDetails(for: darkKnightId, infoLevel: .min) { result in
            movie = try! result.get()
        }
        expect(movie).toEventuallyNot(beNil())
        expect(movie?.tagline).toEventually(beNil())
    }

    func testReturnsFullMovieDetails() {
        stubHelper.stubWithLocalFile(Movies.details(movieId: darkKnightId, infoLevel: .full), info: .full)

        var movie: Movie?
        trakt.getMovieDetails(for: darkKnightId, infoLevel: .full) { result in
            movie = try! result.get()
        }
        expect(movie).toEventuallyNot(beNil())
        expect(movie?.tagline).toEventuallyNot(beNil())
    }

    func testReturnsAliases() {
        stubHelper.stubWithLocalFile(Movies.aliases(movieId: darkKnightId))

        var aliases: [Alias]?
        trakt.getAliases(for: darkKnightId) { result in
            aliases = try! result.get()
        }
        expect(aliases).toEventuallyNot(beNil())
    }

    func testReturnsReleases() {
        stubHelper.stubWithLocalFile(Movies.releases(movieId: darkKnightId, country: ""))

        var releases: [MovieRelease]?
        trakt.getReleases(for: darkKnightId, country: "") { result in
            releases = try! result.get()
        }
        expect(releases).toEventuallyNot(beNil())
    }

    func testReturnsComments() {
        stubHelper.stubWithLocalFile(Movies.comments(movieId: darkKnightId, sort: "", pageNumber: 1, resultsPerPage: 10))

        var comments: [Comment]?
        trakt.getComments(for: darkKnightId, pageNumber: 1, sort: "") { result in
            comments = try! result.get()
        }
        expect(comments).toEventuallyNot(beNil())
    }

    func testReturnsLists() {
        stubHelper.stubWithLocalFile(Movies.lists(movieId: darkKnightId, type: "", sort: "", pageNumber: 1, resultsPerPage: 10))

        var lists: [List]?
        trakt.getLists(for: darkKnightId, type: "", sortBy: "", pageNumber: 1) { result in
            lists = try! result.get()
        }
        expect(lists).toEventuallyNot(beNil())
    }

    func testReturnsPeople() {
        stubHelper.stubWithLocalFile(Movies.people(movieId: darkKnightId))

        var people: CastAndCrew?
        trakt.getPeople(for: darkKnightId) { result in
            people = try! result.get()
        }
        expect(people).toEventuallyNot(beNil())
    }

    func testReturnsRatings() {
        stubHelper.stubWithLocalFile(Movies.ratings(movieId: darkKnightId))

        var people: RatingDistribution?
        trakt.getRatings(for: darkKnightId) { result in
            people = try! result.get()
        }
        expect(people).toEventuallyNot(beNil())
    }

    func testReturnsRelatedMovies() {
        stubHelper.stubWithLocalFile(Movies.related(movieId: darkKnightId, pageNumber: 1, resultsPerPage: 10))

        var movies: [Movie]?
        trakt.getRelatedMovies(for: darkKnightId, pageNumber: 1) { result in
            movies = try! result.get()
        }
        expect(movies).toEventuallyNot(beNil())
    }

    func testReturnsStats() {
        stubHelper.stubWithLocalFile(Movies.stats(movieId: darkKnightId))

        var stats: Stats?
        trakt?.getStats(for: darkKnightId) { result in
            stats = try! result.get()
        }
        expect(stats).toEventuallyNot(beNil())
    }

    func testRetunrsCurrentlyWatching() {
        stubHelper.stubWithLocalFile(Movies.currentlyWatching(movieId: deadPoolId))

        var watching: [User]?
        trakt.getCurrentlyWatching(for: deadPoolId) { result in
            watching = try! result.get()
        }
        expect(watching).toEventuallyNot(beNil())
    }
}
