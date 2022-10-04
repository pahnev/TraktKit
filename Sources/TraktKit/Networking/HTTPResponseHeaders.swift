//
//  HTTPResponseHeaders.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 29/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct PaginationData: CodableEquatable {
    public let itemCount: Int
    public let limit: Int
    public let currentPage: Int
    public let totalPages: Int
}

struct HTTPResponseHeaders {
    let etag: String?
    let maxAge: TimeInterval?
    let pagination: PaginationData?

    /*
     All possible cache response directives:
     Source: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control

     Cache-Control: must-revalidate
     Cache-Control: no-cache
     Cache-Control: no-store
     Cache-Control: no-transform
     Cache-Control: public
     Cache-Control: private
     Cache-Control: proxy-revalidate
     Cache-Control: max-age=<seconds>
     Cache-Control: s-maxage=<seconds>

     Note that directives may also be combined, e.g.
     Cache-Control: no-cache, no-store, must-revalidate

     Currently we support only max-age=<seconds>
     */
    private static func parseMaxAge(from cacheControlHeader: String?) -> TimeInterval? {
        guard let cacheControl = cacheControlHeader else { return nil }

        // Including explicit types to help Swift typechecker to perform faster
        let cacheControlDirectives: [String] = cacheControl.lowercased().split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let maxAgeDirective: String? = cacheControlDirectives.filter { $0.starts(with: "max-age") }.first
        let maxAgeKeyValue: [String.SubSequence]? = maxAgeDirective.map { $0.split(separator: "=") }

        guard let keyValuePair = maxAgeKeyValue, keyValuePair.count == 2, let maxAge = TimeInterval(keyValuePair[1]) else { return nil }

        return maxAge
    }

    init(_ headers: [AnyHashable: Any]) {
        let stringHeaders = headers as? [String: String]

        etag = stringHeaders?["Etag"]
        maxAge = HTTPResponseHeaders.parseMaxAge(from: stringHeaders?["Cache-Control"])

        guard let itemCount = stringHeaders?["x-pagination-item-count"]?.asInt,
              let limit = stringHeaders?["x-pagination-limit"]?.asInt,
              let currentPage = stringHeaders?["x-pagination-page"]?.asInt,
              let totalPages = stringHeaders?["x-pagination-page-count"]?.asInt else {
            pagination = nil
            return
        }
        pagination = PaginationData(itemCount: itemCount, limit: limit, currentPage: currentPage, totalPages: totalPages)
    }
}
