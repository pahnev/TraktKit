//
//  SyncEndpointTests.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 29/01/2019.
//

import XCTest
import Foundation
import Nimble
import OHHTTPStubs
@testable import TraktKit

class SyncEndpointTests: XCTestCase {

    var trakt: Trakt!
    let stubHelper = StubHelper()
    let mockAuth = MockAuth()

    override func setUp() {
        guard let trakt = try? Trakt(traktClient: MockClient()) else { preconditionFailure() }
        self.trakt = trakt
        trakt.authenticate(mockAuth)
    }

    override func tearDown() {
        trakt.clearCaches()
        super.tearDown()
    }

    func testGettingLastActivities() {
        stubHelper.stubWithLocalFile(Sync.lastActivities)

        var lastActivities: LastActivities?
        trakt.getLastActivities { res in
            lastActivities = res.value
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
            progress = res.value
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
            error = res.error
        }
        expect(error).toEventually(beNil())
    }

    func testAddingMovieToHistoryHasCorrectBody() {
        stubHelper.stubPOSTRequest(expectedBody: """
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
            result = res.value
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.added.movies).toEventually(be(1))
    }

    func testAddingShowToHistoryHasCorrectBody() {
        stubHelper.stubPOSTRequest(expectedBody: """
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
            result = res.value
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.added.episodes).toEventually(be(1))
    }

    func testAddingEpisodeToHistoryHasCorrectBody() {
        stubHelper.stubPOSTRequest(expectedBody: """
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
            result = res.value
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.added.episodes).toEventually(be(1))
    }

    func testAddingMovieEpisodeAndShowToHistoryHasCorrectBody() {
        stubHelper.stubPOSTRequest(expectedBody: """
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
            result = res.value
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
            history = res.value
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSpecificMovieHistory() {
        let movieId = 190430
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .movies, pageNumber: 1, traktId: movieId)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .movies, pageNumber: 1, traktId: movieId, startDate: nil, endDate: nil) { res in
            history = res.value
        }

        expect(history).toEventuallyNot(beNil())
        expect(history?.count).toEventually(be(1))
        expect(history?.first?.movie).toEventuallyNot(beNil())
    }

    func testGetEpisodeHistory() {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .episodes, pageNumber: 1)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .episodes, pageNumber: 1) { res in
            history = res.value
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSpecificEpisodeHistory() {
        let episodeId = 3335676
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .episodes, pageNumber: 1, traktId: episodeId)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .episodes, pageNumber: 1, traktId: episodeId) { res in
            history = res.value
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
            history = res.value
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSpecificShowHistory() {
        let showId = 119095
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .shows, pageNumber: 1, traktId: showId)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .shows, pageNumber: 1, traktId: showId) { res in
            history = res.value
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSeasonHistory() {
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .seasons, pageNumber: 1)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .seasons, pageNumber: 1) { res in
            history = res.value
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testGetSpecificSeasonHistory() {
        let seasonId = 100
        stubHelper.stubWithLocalFile(Sync.getHistory(payload: HistoryPayload(type: .seasons, pageNumber: 1, traktId: seasonId)))

        var history: [HistoryItem]?
        trakt.getHistory(type: .seasons, pageNumber: 1, traktId: seasonId) { res in
            history = res.value
        }
        expect(history).toEventuallyNot(beNil())
    }

    func testAllGetHistoryParametersAreUsedForUrl() {
        let endpoint = Sync.getHistory(payload: HistoryPayload(type: .movies, pageNumber: 1, resultsPerPage: 2, traktId: 3, infoLevel: .full, startDate: "123", endDate: "456"))
        XCTAssertEqual(endpoint.url.absoluteString, "https://api.trakt.tv/sync/history/movies/3?page=1&limit=2&extended=full&start_at=123&end_at=456")
    }

    func testRemoveFromHistoryHasCorrectBody() {
        stubHelper.stubPOSTRequest(expectedBody: """
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
            result = res.value
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.deleted.movies).toEventually(be(1))
    }

    func testRemoveFromHistoryNotFound() {
        stubHelper.stubPOSTRequest(expectedBody: """
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
            result = res.value
        }
        expect(result).toEventuallyNot(beNil())
        expect(result?.notFound.ids.count).toEventually(be(1))
    }

}
