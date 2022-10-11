//
//  TraktKitTests.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 31/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import XCTest

@testable import TraktKit

class TraktKitTests: TraktKitTestCase {
    let darkKnightId = 120
    let deadPoolId = 190430

    func testReturnsPaginationInfoForPaginatedEndpoint() throws {
        let responseHeaders = [
            "x-pagination-item-count": "1",
            "x-pagination-limit": "2",
            "x-pagination-page": "3",
            "x-pagination-page-count": "4"
        ]
        stubHelper.stubWithLocalFile(Movies.trending(pageNumber: 1, resultsPerPage: 10, infoLevel: .min), info: .min, headers: responseHeaders)

        let pagination = try awaitFor { trakt.movies.getTrendingMovies(pageNumber: 1, infoLevel: .min, completion: $0) }.get().pagination

        XCTAssertNotNil(pagination)
        XCTAssertEqual(pagination?.itemCount, 1)
        XCTAssertEqual(pagination?.limit, 2)
        XCTAssertEqual(pagination?.currentPage, 3)
        XCTAssertEqual(pagination?.totalPages, 4)
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
        let firstResponse = try awaitFor { trakt.movies.getTrendingMovies(pageNumber: 1, infoLevel: .min, completion: $0) }.get().type

        XCTAssertEqual(firstResponse.first?.movie.title, "Deadpool 2")

        // Second request should not
        let secondResponse = try awaitFor { trakt.movies.getTrendingMovies(pageNumber: 1, infoLevel: .min, completion: $0) }.get().type

        XCTAssertEqual(secondResponse.first?.movie.title, "Deadpool 2")

        XCTAssertEqual(requestCount, 1, "Expected second request to be fetched from cache and not hit the server")
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
