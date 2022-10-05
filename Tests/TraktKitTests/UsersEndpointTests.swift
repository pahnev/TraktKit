//
// Created by Kirill Pahnev on 2019-02-12.
//

import XCTest
@testable import TraktKit

class UsersEndpointTests: TraktKitTestCase {

    func testWatchingIsReturned() throws {
        stubHelper.stubWithLocalFile(Users.getWatching(userId: "test", infoLevel: .full))

        let result = try awaitFor { trakt.getWatching(userId: "test", completion: $0) }.get()

        XCTAssertNotNil(result)
    }

    func testWatchingReturnsNoData() throws {
        stubHelper.stubWithResponseCode(204, endpoint: Users.getWatching(userId: "test2", infoLevel: .min))

        let error = try awaitFor { trakt.getWatching(userId: "test2", completion: $0) }.error

        XCTAssertNotNil(error)
    }

    func testStatsIsReturned() throws {
        stubHelper.stubWithLocalFile(Users.getStats(userId: "test"))

        let result = try awaitFor { trakt.getStats(userId: "test", completion: $0) }.get()

        XCTAssertNotNil(result)
    }
}
