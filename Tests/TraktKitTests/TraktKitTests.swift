//
//  TraktKitTests.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 31/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import XCTest
import Nimble
import OHHTTPStubsSwift
import OHHTTPStubsCore

@testable import TraktKit

class TraktKitTests: XCTestCase {

    var trakt: Trakt!
    let stubHelper = StubHelper()

    let darkKnightId = TraktId(120)
    let deadPoolId = TraktId(190430)

    override func setUp() {
        guard let trakt = try? Trakt(traktClient: MockClient()) else { preconditionFailure() }
        self.trakt = trakt
    }

    override func tearDown() {
        trakt.clearCaches()
        super.tearDown()
    }

    func testReturnsPaginationInfoForPaginatedEndpoint() {
        let responseHeaders = [
            "x-pagination-item-count": "1",
            "x-pagination-limit": "2",
            "x-pagination-page": "3",
            "x-pagination-page-count": "4"
        ]
        stubHelper.stubWithLocalFile(Movies.trending(pageNumber: 1, resultsPerPage: 10, infoLevel: .min), info: .min, headers: responseHeaders)
        var pagination: PaginationData?
        trakt.getTrendingMovies(pageNumber: 1, infoLevel: .min) { result in
            pagination = try! result.get().pagination
        }
        expect(pagination).toEventuallyNot(beNil())
        expect(pagination?.itemCount).to(be(1))
        expect(pagination?.limit).to(be(2))
        expect(pagination?.currentPage).to(be(3))
        expect(pagination?.totalPages).to(be(4))
    }

    func testCacheIsUsedOnSecondFetch() {
        var requestCount = 0

        // Listen to requests "server" gets
        stub(condition: isMethodGET()) { _ in
            requestCount += 1
            let responseHeaders = [
                "Cache-Control": "max-age=60",
                "x-pagination-item-count": "1",
                "x-pagination-limit": "2",
                "x-pagination-page": "3",
                "x-pagination-page-count": "4",
                ]

            return self.stubHelper.fixtureFor(Movies.trending(pageNumber: 1, resultsPerPage: 10, infoLevel: .min),
                                              info: .min,
                                              headers: responseHeaders)
        }

        // First request should be received by the "server"
        var firstResponse: [TrendingMovie]?
        trakt.getTrendingMovies(pageNumber: 1, infoLevel: .min) { result in
            firstResponse = try! result.get().type
        }
        expect(firstResponse?.first?.movie.title).toEventually(match("Deadpool 2"))

        // Second request should not
        var secondResponse: [TrendingMovie]?
        trakt.getTrendingMovies(pageNumber: 1, infoLevel: .min) { result in
            secondResponse = try! result.get().type
        }
        expect(secondResponse?.first?.movie.title).toEventually(match("Deadpool 2"))

        expect(requestCount).toEventually(be(1))
    }

    func testHTTPResponseHeadersCacheControl() {
        XCTAssertNil(HTTPResponseHeaders(["Cache-Control": "no-cache"]).maxAge)
        XCTAssertNil(HTTPResponseHeaders(["Cache-Control": "no-cache, no-store, must-revalidate"]).maxAge)
        XCTAssertEqual(HTTPResponseHeaders(["Cache-Control": "max-age=0"]).maxAge, 0)
        XCTAssertEqual(HTTPResponseHeaders(["Cache-Control": "max-age=60"]).maxAge, 60)
        XCTAssertEqual(HTTPResponseHeaders(["Cache-Control": "max-age=-1"]).maxAge, -1)
        XCTAssertEqual(HTTPResponseHeaders(["Cache-Control": "max-age=60, no-cache, no-store, must-revalidate"]).maxAge, 60)
        XCTAssertEqual(HTTPResponseHeaders(["Cache-Control": "no-cache, max-age=60, no-store, must-revalidate"]).maxAge, 60)
        XCTAssertEqual(HTTPResponseHeaders(["Cache-Control": "no-cache, no-store, must-revalidate, max-age=60"]).maxAge, 60)
        XCTAssertEqual(HTTPResponseHeaders(["Cache-Control": "no-cache, no-store,   max-age=60      , must-revalidate,  "]).maxAge, 60)
    }

}
