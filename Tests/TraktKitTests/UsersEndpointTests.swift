//
// Created by Kirill Pahnev on 2019-02-12.
//

import Foundation
import Nimble
import XCTest
@testable import TraktKit

class UsersEndpointTests: TraktKitTestCase {

    func testWatchingIsReturned() {
        stubHelper.stubWithLocalFile(Users.getWatching(userId: "test", infoLevel: .full))
        var result: Watching?
        trakt.getWatching(userId: "test") { res in
            result = try! res.get()
        }
        expect(result).toEventuallyNot(beNil())
    }

    func testWatchingReturnsNoData() {
        stubHelper.stubWithResponseCode(204, endpoint: Users.getWatching(userId: "test2", infoLevel: .min))
        var error: TraktError!
        trakt.getWatching(userId: "test2") { res in
            switch res {
            case .failure(let err):
                error = err
            case .success(let object):
                print(object as Any)
                XCTFail("Expected failure result not success.")
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
