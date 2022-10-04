//
//  StubHelper.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 06/08/2018.
//

import Foundation
import OHHTTPStubsCore
import OHHTTPStubsSwift
import XCTest
@testable import TraktKit

class StubHelper {
    private let fixtureCache: [String: URL]

    static let defaultPaginationHeaders = [
        "x-pagination-item-count": "1",
        "x-pagination-limit": "2",
        "x-pagination-page": "3",
        "x-pagination-page-count": "4"
    ]

    func fixtureFor(_ endpoint: Endpoint, info: InfoLevel? = nil, headers: [String: Any] = defaultPaginationHeaders) -> OHHTTPStubsResponse {
        print("---- Stubbing URL path: \(endpoint.url.path) with local file ----")
        var fileName = endpoint.url.path.dropFirst().replacingOccurrences(of: "/", with: "_")
        if let info = info {
            fileName.append("_\(info.rawValue)")
        }

        let file = fixtureCache["\(fileName).json"]
        return OHHTTPStubsResponse(data: try! Data(contentsOf: file!), statusCode: 200, headers: headers)
    }

    func stubWithResponseCode(_ code: Int, endpoint: Endpoint) {
        stub(condition: isPath(endpoint.url.path), response: { _ in
            let stubData = "".data(using: .utf8)
            return OHHTTPStubsResponse(data: stubData!, statusCode: Int32(code), headers: nil)
        })
    }

    func stubWithLocalFile(_ endpoint: Endpoint, info: InfoLevel? = nil, headers: [String: Any] = defaultPaginationHeaders) {
        stub(condition: isPath(endpoint.url.path)) { _ in
            self.fixtureFor(endpoint, info: info, headers: headers)
        }
    }

    func stubPOSTRequest(expectedBody: String, responseFile: String) {
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            let body = String(data: request.ohhttpStubs_httpBody!, encoding: String.Encoding.utf8)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(body, expectedBody)
            return true
        }) { _ -> OHHTTPStubsResponse in
            let file = self.fixtureCache["\(responseFile).json"]
            return OHHTTPStubsResponse(data: try! Data(contentsOf: file!), statusCode: 200, headers: nil)
        }
    }

    init() {
        var cache: [String: URL] = [:] // Save all local files in this cache
        let baseURL = StubHelper.urlForRestServicesTestsDir()

        guard let enumerator = FileManager.default.enumerator(at: baseURL,
                                                              includingPropertiesForKeys: [.nameKey],
                                                              options: [.skipsHiddenFiles, .skipsPackageDescendants],
                                                              errorHandler: nil) else {
            fatalError("Could not enumerate \(baseURL)")
        }

        for case let url as URL in enumerator where url.isFileURL {
            cache[url.lastPathComponent] = url
        }
        fixtureCache = cache
    }

    static func urlForRestServicesTestsDir() -> URL {
        let currentFileURL = URL(fileURLWithPath: "\(#file)", isDirectory: false)
        return currentFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
