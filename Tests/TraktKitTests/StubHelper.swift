//
//  StubHelper.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 06/08/2018.
//

import Foundation
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

    func fixtureFor(_ endpoint: Endpoint, info: InfoLevel? = nil, headers: [String: Any] = defaultPaginationHeaders) throws -> Data {
        print("---- Stubbing URL path: \(endpoint.url.path) with local file ----")
        var fileName = endpoint.url.path.dropFirst().replacingOccurrences(of: "/", with: "_")
        if let info = info {
            fileName.append("_\(info.rawValue)")
        }

        let file = try XCTUnwrap(fixtureCache["\(fileName).json"])
        return try XCTUnwrap(Data(contentsOf: file))
    }

    func stubWithResponseCode(_ code: Int, endpoint: Endpoint) {
        MockURLProtocol.requestHandler = { _ in
            let stubData = "".data(using: .utf8)!
            return (HTTPURLResponse(url: endpoint.url, statusCode: code, httpVersion: nil, headerFields: nil)!, stubData)
        }
    }

    func stubWithLocalFile(_ endpoint: Endpoint, info: InfoLevel? = nil, headers: [String: String] = defaultPaginationHeaders) {
        MockURLProtocol.requestHandler = { _ in
            let data = try self.fixtureFor(endpoint, info: info, headers: headers)
            return (HTTPURLResponse(url: endpoint.url, statusCode: 200, httpVersion: nil, headerFields: headers)!, data)
        }
    }

    func stubPOSTRequest(expectedBody: String, responseFile: String) throws {
        MockURLProtocol.requestHandler = { request in
            let bodyStream = try XCTUnwrap(request.httpBodyStream)
            let bodyData = try XCTUnwrap(Data(reading: bodyStream))
            let body = String(data: bodyData, encoding: .utf8)

            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(body, expectedBody)

            let file = try XCTUnwrap(self.fixtureCache["\(responseFile).json"])
            let responseData = try XCTUnwrap(Data(contentsOf: file))

            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, responseData)
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

// Thanks: https://stackoverflow.com/a/42561021/2143387
extension Data {
    init(reading input: InputStream) throws {
        self.init()
        input.open()
        defer {
            input.close()
        }

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
        }
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read < 0 {
                //Stream error occurred
                throw input.streamError!
            } else if read == 0 {
                //EOF
                break
            }
            append(buffer, count: read)
        }
    }
}
