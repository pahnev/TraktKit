//
// Created by Kirill Pahnev on 2019-02-12.
//

import XCTest
import Foundation
import Nimble
@testable import TraktKit

class UsersEndpointTests: XCTestCase {

    var trakt: Trakt!
    let stubHelper = StubHelper()

    override func setUp() {
        guard let trakt = try? Trakt(traktClient: MockClient()) else { preconditionFailure() }
        self.trakt = trakt
    }

    override func tearDown() {
        trakt.clearCaches()
        super.tearDown()
    }

    func testWatchingIsReturned() {
        stubHelper.stubWithLocalFile(Users.getWatching(userId: "test", infoLevel: .full))
        var result: Watching?
        trakt.getWatching(userId: "test") { res in
            result = res.value ?? nil
        }
        expect(result).toEventuallyNot(beNil())
    }

    func testWatchingReturnsNoData() {
        stubHelper.stubWithResponseCode(204, endpoint: Users.getWatching(userId: "test", infoLevel: .min))
        var error: TraktError?
        trakt.getWatching(userId: "test") { res in
            error = res.error
        }
        expect(error).toEventually(matchError(TraktError.emptyContent))
    }
}
