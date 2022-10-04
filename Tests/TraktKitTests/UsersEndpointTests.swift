//
// Created by Kirill Pahnev on 2019-02-12.
//

import Foundation
import Nimble
import XCTest
@testable import TraktKit

class UsersEndpointTests: XCTestCase {
    var trakt: Trakt!
    let stubHelper = StubHelper()

    override func setUp() {
        guard let trakt = try? Trakt(traktClient: MockClient()) else { preconditionFailure() }
        self.trakt = trakt
    }

    override func tearDown() {
        URLCache.shared.removeAllCachedResponses() // Something weird with `testWatchingReturnsNoData` test here, don't wanna deal with it now
        trakt.clearCaches()
        super.tearDown()
    }

    func testWatchingIsReturned() {
        stubHelper.stubWithLocalFile(Users.getWatching(userId: "test", infoLevel: .full))
        var result: Watching?
        trakt.getWatching(userId: "test") { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
    }

    func testWatchingReturnsNoData() {
        stubHelper.stubWithResponseCode(204, endpoint: Users.getWatching(userId: "test", infoLevel: .min))
        var error: TraktError!
        trakt.getWatching(userId: "test") { res in
            switch res {
            case .failure(let err):
                error = err
            case .success: fatalError()
            }
        }
        expect(error).toEventually(matchError(TraktError.emptyContent))
    }

    func testStatsIsReturned() {
        stubHelper.stubWithLocalFile(Users.getStats(userId: "test"))
        var result: UserStats?
        trakt?.getStats(userId: "test") { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
    }
}
