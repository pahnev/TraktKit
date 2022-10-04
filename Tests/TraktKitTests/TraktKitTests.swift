//
//  TraktKitTests.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 31/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Nimble
import OHHTTPStubsCore
import OHHTTPStubsSwift
import XCTest

@testable import TraktKit

class TraktKitTests: TraktKitTestCase {
    let darkKnightId = TraktId(120)
    let deadPoolId = TraktId(190430)

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

    func testCacheIsUsedOnSecondFetch() throws {
        var requestCount = 0

        // Listen to requests "server" gets
        MockURLProtocol.requestHandler = { request in
            requestCount += 1
            let responseHeaders = [
                "Cache-Control": "max-age=60",
                "x-pagination-item-count": "1",
                "x-pagination-limit": "2",
                "x-pagination-page": "3",
                "x-pagination-page-count": "4"
            ]
            let data = try self.stubHelper.fixtureFor(Movies.trending(pageNumber: 1, resultsPerPage: 10, infoLevel: .min),
                                              info: .min,
                                              headers: responseHeaders)

            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: responseHeaders)!, data)

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
