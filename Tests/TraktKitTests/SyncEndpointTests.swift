//
//  SyncEndpointTests.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 29/01/2019.
//

import Foundation
import Nimble
import XCTest

@testable import TraktKit

class SyncEndpointTests: TraktKitTestCase {
    let mockAuth = MockAuth()

    override func setUp() {
        super.setUp()
        trakt.authenticate(mockAuth)
    }

    func testGettingLastActivities() {
        stubHelper.stubWithLocalFile(Sync.lastActivities)

        var lastActivities: LastActivities?
        trakt.getLastActivities { res in
            lastActivities = try! res.get()
        }
        expect(lastActivities).toEventuallyNot(beNil())
        expectCorrectDateFormattingFor(lastActivities!.all)
    }

    private func expectCorrectDateFormattingFor(_ date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

        let expectedDate = formatter.date(from: "2019-01-30T10:10:12.000Z")

        XCTAssertEqual(expectedDate, date)
    }

    func testGetPlaybackProgress() {
        stubHelper.stubWithLocalFile(Sync.getPlaybackProgress(type: .all, limit: 0))

        var progress: [PlaybackProgress]?
        trakt.getPlaybackProgress(type: .all, limit: 0) { res in
            progress = try! res.get().type
        }
        expect(progress).toEventuallyNot(beNil())
    }

    func testPlaybackProgressURL() {
        let endpointWithoutLimit = Sync.getPlaybackProgress(type: .movies, limit: nil)
        XCTAssertEqual(endpointWithoutLimit.url.absoluteString, "https://api.trakt.tv/sync/playback/movies?limit=")

        let endpointWithLimit = Sync.getPlaybackProgress(type: .episodes, limit: 1)
        XCTAssertEqual(endpointWithLimit.url.absoluteString, "https://api.trakt.tv/sync/playback/episodes?limit=1")

        let endpointWithTypeAll = Sync.getPlaybackProgress(type: .all, limit: nil)
        XCTAssertEqual(endpointWithTypeAll.url.absoluteString, "https://api.trakt.tv/sync/playback/?limit=")
    }

    func testRemovePlaybackItem() {
        stubHelper.stubWithResponseCode(204, endpoint: Sync.removePlayback(1))

        var error: TraktError? = TraktError.emptyDataReceivedError
        trakt.removePlaybackItemWith(PlaybackProgressId(1)) { res in
            switch res {
            case .failure(let err):
                error = err
            case .success:
                error = nil
            }
        }
        expect(error).toEventually(beNil())
    }

    func testGetCollectionMovies() {
        stubHelper.stubWithLocalFile(Sync.getCollection(type: .movies, infoLevel: .min))

        var results: [CollectedMovie]?
        trakt.getCollectedMovies { res in
            results = try! res.get()
        }
        expect(results).toEventuallyNot(beNil())
        expect(results?.first?.collectedAt).toEventuallyNot(beNil())
        expect(results?.first?.updatedAt).toEventuallyNot(beNil())
    }

    func testGetCollectedShows() {
        stubHelper.stubWithLocalFile(Sync.getCollection(type: .shows, infoLevel: .min))

        var results: [CollectedShow]?
        trakt.getCollectedShows { res in
            results = try! res.get()
        }
        expect(results).toEventuallyNot(beNil())
        expect(results?.first?.lastCollectedAt).toEventuallyNot(beNil())
        expect(results?.first?.lastUpdatedAt).toEventuallyNot(beNil())
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

        var result: AddedToHistory?
        trakt.addToHistory(movies: [0]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.added.movies).toEventually(be(1))
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

        var result: AddedToHistory?
        trakt.addToHistory(shows: [0]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.added.episodes).toEventually(be(1))
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

        var result: AddedToHistory?
        trakt.addToHistory(episodes: [0]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.added.episodes).toEventually(be(1))
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

        var result: AddedToHistory?
        trakt.addToHistory(movies: [0], shows: [0], episodes: [0]) { res in
            result = try! res.get()
        }

        expect(result).toEventuallyNot(beNil())
        expect(result?.added.episodes).toEventually(be(0))
        expect(result?.added.movies).toEventually(be(0))
        expect(result?.notFound.movies.first?.ids.trakt.integerValue).toEventually(be(0))
        expect(result?.notFound.shows.first?.ids.trakt.integerValue).toEventually(be(0))
        expect(result?.notFound.episodes.first?.ids.trakt.integerValue).toEventually(be(0))
    }

    func testGetMovieHistory() {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .movies, pageNumber: 1)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .movies, pageNumber: 1) { res in
            history = try! res.get().type
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSpecificMovieHistory() {
        let movieId = 190430
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .movies, pageNumber: 1, traktId: movieId)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .movies, pageNumber: 1, traktId: movieId, startDate: nil, endDate: nil) { res in
            history = try! res.get().type
        }

        expect(history).toEventuallyNot(beNil())
        expect(history?.count).toEventually(be(1))
        expect(history?.first?.movie).toEventuallyNot(beNil())
    }

    func testGetEpisodeHistory() {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .episodes, pageNumber: 1)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .episodes, pageNumber: 1) { res in
            history = try! res.get().type
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSpecificEpisodeHistory() {
        let episodeId = 3335676
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .episodes, pageNumber: 1, traktId: episodeId)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .episodes, pageNumber: 1, traktId: episodeId) { res in
            history = try! res.get().type
        }
        expect(history).toEventuallyNot(beNil())
        expect(history?.count).toEventually(be(1))
        expect(history?.first?.show).toEventuallyNot(beNil())
        expect(history?.first?.episode).toEventuallyNot(beNil())
    }

    func testGetShowHistory() {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .shows, pageNumber: 1)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .shows, pageNumber: 1) { res in
            history = try! res.get().type
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSpecificShowHistory() {
        let showId = 119095
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .shows, pageNumber: 1, traktId: showId)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .shows, pageNumber: 1, traktId: showId) { res in
            history = try! res.get().type
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSeasonHistory() {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .seasons, pageNumber: 1)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .seasons, pageNumber: 1) { res in
            history = try! res.get().type
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSpecificSeasonHistory() {
        let seasonId = 100
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .seasons, pageNumber: 1, traktId: seasonId)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .seasons, pageNumber: 1, traktId: seasonId) { res in
            history = try! res.get().type
        }
        expect(history).toEventuallyNot(beNil())
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

        var result: RemovedFromHistory?
        trakt.removeFromHistory(movies: [0]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.deleted.movies).toEventually(be(1))
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

        var result: RemovedFromHistory?
        trakt.removeFromHistory(movies: [0]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.notFound.ids.count).toEventually(be(1))
    }

    func testGetWatchlist() {
        stubHelper.stubWithLocalFile(Sync.getWatchlist(type: .all, infoLevel: .min, pagination: Pagination(page: 1, limit: 1)))
        var results: [ListItem]?
        trakt.getWatchlist(page: 1) { res in
            results = try! res.get().type
        }
        expect(results).toEventuallyNot(beNil())
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

        var result: AddToWatchlist?
        trakt.addToWatchlist(movies: [0]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
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

        var result: AddToWatchlist?
        trakt.addToWatchlist(movies: [0]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.existing.movies).to(be(1))
        expect(result?.notFound.episodes.count).to(be(1))
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

        var result: RemoveFromWatchlist?
        trakt.removeFromWatchlist(movies: [0]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
    }

    func testGetRatingsIsReturned() {
        stubHelper.stubWithLocalFile(Sync.getRatings(type: .all, infoLevel: .min))

        var result: [Rating]?
        trakt.getRatings { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.first?.type).to(be("movie"))
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

        var result: AddedToHistory?
        trakt.addRating(rating, to: .movie, withId: TraktId(movieId), ratedAt: nil) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
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

        var result: RemoveFromWatchlist?
        trakt.removeRatingsFrom(movies: [1]) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
    }

    func testGettingWatchedReturns() {
        stubHelper.stubWithLocalFile(Sync.getWatched(type: .movies, infoLevel: .min))
        var result: [WatchedItem]?
        trakt.getWatched(type: .movies) { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.first?.movie?.title).toEventually(match("Guardians of the Galaxy"))
    }
}
