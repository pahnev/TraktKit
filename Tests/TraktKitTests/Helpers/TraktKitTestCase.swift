//
//  TraktKitTestCase.swift
//
//
//  Created by Pahnev, Kirill on 4.10.2022.
//

import XCTest
@testable import TraktKit

class TraktKitTestCase: XCTestCase {
    var stubHelper: StubHelper!
    var trakt: Trakt!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self] + (config.protocolClasses ?? [])
        let urlSession = URLSession(configuration: config)

        let trakt = Trakt(traktClient: MockClient(),
                          networkClient: NetworkClient(traktClient: MockClient(), urlSession: urlSession))
        self.trakt = trakt
        stubHelper = StubHelper()
    }

    override func tearDown() {
        super.tearDown()
        MockURLProtocol.requestHandler = nil
        trakt.clearCaches()
    }
}

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
