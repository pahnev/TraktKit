//
//  SyncEndpointTests.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 29/01/2019.
//

import Foundation
import XCTest

@testable import TraktKit

class SyncEndpointTests: TraktKitTestCase {
    let mockAuth = MockAuth()

    override func setUp() {
        super.setUp()
        trakt.authenticate(mockAuth)
    }

    func testGettingLastActivities() throws {
        stubHelper.stubWithLocalFile(Sync.lastActivities)

        let lastActivities = try awaitFor { trakt.getLastActivities(completion: $0) }.get()

        XCTAssertNotNil(lastActivities)
        expectCorrectDateFormattingFor(lastActivities.all)
    }

    private func expectCorrectDateFormattingFor(_ date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

        let expectedDate = formatter.date(from: "2019-01-30T10:10:12.000Z")

        XCTAssertEqual(expectedDate, date)
    }

    func testGetPlaybackProgress() throws {
        stubHelper.stubWithLocalFile(Sync.getPlaybackProgress(type: .all, limit: 0))

        let progress = try awaitFor { trakt.getPlaybackProgress(type: .all, limit: 0, completion: $0) }.get().type

        XCTAssertNotNil(progress)
    }

    func testPlaybackProgressURL() {
        let endpointWithoutLimit = Sync.getPlaybackProgress(type: .movies, limit: nil)
        XCTAssertEqual(endpointWithoutLimit.url.absoluteString, "https://api.trakt.tv/sync/playback/movies?limit=")

        let endpointWithLimit = Sync.getPlaybackProgress(type: .episodes, limit: 1)
        XCTAssertEqual(endpointWithLimit.url.absoluteString, "https://api.trakt.tv/sync/playback/episodes?limit=1")

        let endpointWithTypeAll = Sync.getPlaybackProgress(type: .all, limit: nil)
        XCTAssertEqual(endpointWithTypeAll.url.absoluteString, "https://api.trakt.tv/sync/playback/?limit=")
    }

    func testRemovePlaybackItem() throws {
        stubHelper.stubWithResponseCode(204, endpoint: Sync.removePlayback(1))

        var error: TraktError? = TraktError.emptyDataReceivedError

        error = try awaitFor { trakt.removePlaybackItemWith(PlaybackProgressId(1), completion: $0) }.error

        XCTAssertNil(error)

    }

    func testGetCollectionMovies() throws {
        stubHelper.stubWithLocalFile(Sync.getCollection(type: .movies, infoLevel: .min))

        let results = try awaitFor { trakt.getCollectedMovies(completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertNotNil(results.first?.collectedAt)
        XCTAssertNotNil(results.first?.updatedAt)
    }

    func testGetCollectedShows() throws {
        stubHelper.stubWithLocalFile(Sync.getCollection(type: .shows, infoLevel: .min))

        let results = try awaitFor { trakt.getCollectedShows(completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertNotNil(results.first?.lastCollectedAt)
        XCTAssertNotNil(results.first?.lastUpdatedAt)
    }

    func testAddingMovieToHistoryHasCorrectBody() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "ids":[],
        "movies":[{
        "ids":{
        "trakt":0
        }
        }],
        "shows":[],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "addToHistory_movie")

        let results = try awaitFor { trakt.addToHistory(movies: [0], completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertEqual(results.added.movies, 1)
    }

    func testAddingShowToHistoryHasCorrectBody() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "ids":[],
        "movies":[],
        "shows":[{
        "ids":{
        "trakt":0
        }
        }],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "addToHistory_show")

        let results = try awaitFor { trakt.addToHistory(shows: [0], completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertEqual(results.added.episodes, 1)
    }

    func testAddingEpisodeToHistoryHasCorrectBody() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "ids":[],
        "movies":[],
        "shows":[],
        "episodes":[{
        "ids":{
        "trakt":0
        }
        }]
        }
        """.withoutLinebreaks(), responseFile: "addToHistory_show")

        let results = try awaitFor { trakt.addToHistory(episodes: [0], completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertEqual(results.added.episodes, 1)
    }

    func testAddingMovieEpisodeAndShowToHistoryHasCorrectBody() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "ids":[],
        "movies":[{
        "ids":{
        "trakt":0
        }
        }],
        "shows":[{
        "ids":{
        "trakt":0
        }
        }],
        "episodes":[{
        "ids":{
        "trakt":0
        }
        }]
        }
        """.withoutLinebreaks(), responseFile: "addToHistoryAll_notFound")

        let results = try awaitFor { trakt.addToHistory(movies: [0], shows: [0], episodes: [0], completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertEqual(results.added.episodes, 0)
        XCTAssertEqual(results.added.movies, 0)
        XCTAssertEqual(results.notFound.movies.first?.ids.trakt.integerValue, 0)
        XCTAssertEqual(results.notFound.shows.first?.ids.trakt.integerValue, 0)
        XCTAssertEqual(results.notFound.episodes.first?.ids.trakt.integerValue, 0)
    }

    func testGetMovieHistory() throws {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .movies, pageNumber: 1)))

        let history = try awaitFor { trakt.getHistory(type: .movies, pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(history)
    }

    func testGetSpecificMovieHistory() throws {
        let movieId = 190430
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .movies, pageNumber: 1, traktId: movieId)))

        let history = try awaitFor { trakt.getHistory(type: .movies, pageNumber: 1, traktId: movieId, startDate: nil, endDate: nil, completion: $0) }.get().type

        XCTAssertNotNil(history)
        XCTAssertEqual(history.count, 1)
        XCTAssertNotNil(history.first?.movie)
    }

    func testGetEpisodeHistory() throws {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .episodes, pageNumber: 1)))

        let history = try awaitFor { trakt.getHistory(type: .episodes, pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(history)
    }

    func testGetSpecificEpisodeHistory() throws {
        let episodeId = 3335676
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .episodes, pageNumber: 1, traktId: episodeId)))

        let history = try awaitFor { trakt.getHistory(type: .episodes, pageNumber: 1, traktId: episodeId, completion: $0) }.get().type

        XCTAssertNotNil(history)
        XCTAssertEqual(history.count, 1)
        XCTAssertNotNil(history.first?.show)
        XCTAssertNotNil(history.first?.episode)
    }

    func testGetShowHistory() throws {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .shows, pageNumber: 1)))

        let history = try awaitFor { trakt.getHistory(type: .shows, pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(history)
    }

    func testGetSpecificShowHistory() throws {
        let showId = 119095
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .shows, pageNumber: 1, traktId: showId)))

        let history = try awaitFor { trakt.getHistory(type: .shows, pageNumber: 1, traktId: showId, completion: $0) }.get().type

        XCTAssertNotNil(history)
    }

    func testGetSeasonHistory() throws {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .seasons, pageNumber: 1)))

        let history = try awaitFor { trakt.getHistory(type: .seasons, pageNumber: 1, completion: $0) }.get().type

        XCTAssertNotNil(history)
    }

    func testGetSpecificSeasonHistory() throws {
        let seasonId = 100
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .seasons, pageNumber: 1, traktId: seasonId)))

        let history = try awaitFor { trakt.getHistory(type: .seasons, pageNumber: 1, traktId: seasonId, completion: $0) }.get().type

        XCTAssertNotNil(history)
    }

    func testAllGetHistoryParametersAreUsedForUrl() {
        let endpoint = Sync.getHistory(payload: HistoryPayload(type: .movies, pageNumber: 1, resultsPerPage: 2, traktId: 3, infoLevel: .full, startDate: "123", endDate: "456"))
        XCTAssertEqual(endpoint.url.absoluteString, "https://api.trakt.tv/sync/history/movies/3?page=1&limit=2&extended=full&start_at=123&end_at=456")
    }

    func testRemoveFromHistoryHasCorrectBody() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "ids":[],
        "movies":[{
        "ids":{
        "trakt":0
        }
        }],
        "shows":[],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "removeHistory_movie")

        let result = try awaitFor { trakt.removeFromHistory(movies: [0], completion: $0) }.get()

        XCTAssertNotNil(result)
        XCTAssertEqual(result.deleted.movies, 1)
    }

    func testRemoveFromHistoryNotFound() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "ids":[],
        "movies":[{
        "ids":{
        "trakt":0
        }
        }],
        "shows":[],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "removeHistory_notFound")

        let result = try awaitFor { trakt.removeFromHistory(movies: [0], completion: $0) }.get()

        XCTAssertNotNil(result)
        XCTAssertEqual(result.notFound.ids.count, 1)
    }

    func testGetWatchlist() throws {
        stubHelper.stubWithLocalFile(Sync.getWatchlist(type: .all, infoLevel: .min, pagination: Pagination(page: 1, limit: 1)))

        let results = try awaitFor { trakt.getWatchlist(page: 1, completion: $0) }.get()

        XCTAssertNotNil(results)
    }

    func testWatchlistURL() {
        let moviesEndpoint = Sync.getWatchlist(type: .movies, infoLevel: .min, pagination: Pagination(page: 1, limit: 1))
        XCTAssertEqual(moviesEndpoint.url.absoluteString, "https://api.trakt.tv/sync/watchlist/movies?extended=min&page=1&limit=1")
        let allTypesEndpoint = Sync.getWatchlist(type: .all, infoLevel: .metadata, pagination: Pagination(page: 1, limit: 1))
        XCTAssertEqual(allTypesEndpoint.url.absoluteString, "https://api.trakt.tv/sync/watchlist/?extended=metadata&page=1&limit=1")
    }

    func testAddToWatchlist() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "seasons":[],
        "movies":[{
        "ids":{
        "trakt":0
        }
        }],
        "shows":[],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "sync_watchlist_add")

        let results = try awaitFor { trakt.addToWatchlist(movies: [0], completion: $0) }.get()

        XCTAssertNotNil(results)
    }

    func testAddToWatchlistAlreadyExistsOrNotFound() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "seasons":[],
        "movies":[{
        "ids":{
        "trakt":0
        }
        }],
        "shows":[],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "sync_watchlist_add_notFound")

        let results = try awaitFor { trakt.addToWatchlist(movies: [0], completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertEqual(results.existing.movies, 1)
        XCTAssertEqual(results.notFound.episodes.count, 1)
    }

    func testRemoveFromWatchlistBodyIsCorrect() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "seasons":[],
        "movies":[{
        "ids":{
        "trakt":0
        }
        }],
        "shows":[],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "sync_watchlist_remove")

        let results = try awaitFor { trakt.removeFromWatchlist(movies: [0], completion: $0) }.get()

        XCTAssertNotNil(results)
    }

    func testGetRatingsIsReturned() throws {
        stubHelper.stubWithLocalFile(Sync.getRatings(type: .all, infoLevel: .min))

        let results = try awaitFor { trakt.getRatings(completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertEqual(results.first?.type, "movie")
    }

    func testGetRatingsURL() {
        let endpoint = Sync.getRatings(type: .all, infoLevel: .min)
        XCTAssertEqual(endpoint.url.absoluteString, "https://api.trakt.tv/sync/ratings/?extended=min")
        let moviesEndpoint = Sync.getRatings(type: .movies, infoLevel: .full)
        XCTAssertEqual(moviesEndpoint.url.absoluteString, "https://api.trakt.tv/sync/ratings/movies?extended=full")
    }

    func testAddingRating() throws {
        let movieId = 1
        let rating = 1
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "seasons":[],
        "movies":[{
        "ids":{
        "trakt":\(movieId)
        },
        "rating":\(rating)
        }],
        "shows":[],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "sync_watchlist_add")

        let results = try awaitFor { trakt.addRating(rating, to: .movie, withId: TraktId(movieId), ratedAt: nil, completion: $0) }.get()

        XCTAssertNotNil(results)
    }

    func testRemovingRatings() throws {
        try stubHelper.stubPOSTRequest(expectedBody: """
        {
        "seasons":[],
        "movies":[{
        "ids":{
        "trakt":1
        }
        }],
        "shows":[],
        "episodes":[]
        }
        """.withoutLinebreaks(), responseFile: "sync_watchlist_remove")

        let results = try awaitFor { trakt.removeRatingsFrom(movies: [1], completion: $0) }.get()

        XCTAssertNotNil(results)
    }

    func testGettingWatchedReturns() throws {
        stubHelper.stubWithLocalFile(Sync.getWatched(type: .movies, infoLevel: .min))
        let results = try awaitFor { trakt.getWatched(type: .movies, completion: $0) }.get()

        XCTAssertNotNil(results)
        XCTAssertEqual(results.first?.movie?.title, "Guardians of the Galaxy")
    }
}

extension Result {
    /// Returns the underlying Error object.
    var error: Failure? {
        if case .failure(let error) = self {
            return error
        }

        return nil
    }
}
