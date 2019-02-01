//
//  StubHelper.swift
//  TraktKitTests
//
//  Created by Kirill Pahnev on 06/08/2018.
//

import Foundation
import OHHTTPStubs
import XCTest
@testable import TraktKit

class StubHelper {
    func stubWithResponseCode(_ code: Int, endpoint: Endpoint) {
        stub(condition: isPath(endpoint.url.path), response: { _ in
            let stubData = "".data(using: .utf8)
            return OHHTTPStubsResponse(data: stubData!, statusCode: Int32(code), headers: nil)
        })
    }
    
    func stubWithLocalFile(_ endpoint: Endpoint, info: MovieInfo? = nil) {
        print("---- Stubbing URL path: \(endpoint.url.path) with local file ----")
        var fileName = endpoint.url.path.dropFirst().replacingOccurrences(of: "/", with: "_")
        if let info = info {
            fileName.append("_\(info.rawValue)")
        }

        stub(condition: isPath(endpoint.url.path)) { _ in
            let stubPath = OHPathForFile("\(fileName).json", type(of: self))!
            return fixture(filePath: stubPath, status: 200, headers: nil)
        }
    }

    func stubPOSTRequest(expectedBody: String, responseFile: String) {
        OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
            let body = String(data: request.ohhttpStubs_httpBody!, encoding: String.Encoding.utf8)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(body, expectedBody)
            return true
        }) { request -> OHHTTPStubsResponse in
            let stubPath = OHPathForFile("\(responseFile).json", type(of: self))!
            return fixture(filePath: stubPath, status: 200, headers: nil)
        }
    }
}
