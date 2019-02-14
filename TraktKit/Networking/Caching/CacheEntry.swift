//
//  CacheEntry.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 29/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

/** Generic struct which represents a cache entry.
 Cache entry consists of:
 - Value
 - Optional metadata
 */
struct CacheEntry<ValueType: Codable>: Codable {
    var value: ValueType
    let etag: String?
    let expirationDate: Date?
    let pagination: PaginationData?

    init(value: ValueType, maxAge: TimeInterval?, etag: String?, pagination: PaginationData?) {
        self.value = value
        self.etag = etag
        self.expirationDate = Date.withTimeIntervalSinceNow(maxAge)
        self.pagination = pagination
    }

    mutating func setValue(_ value: ValueType) {
        self.value = value
    }
}

private extension Date {
    static func withTimeIntervalSinceNow(_ timeInterval: TimeInterval?) -> Date? {
        guard let timeInterval = timeInterval else { return nil }
        return Date().addingTimeInterval(timeInterval)
    }
}
