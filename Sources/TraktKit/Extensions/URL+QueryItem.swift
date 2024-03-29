//
//  URL+QueryItem.swift
//  TMDBKit
//
//  Created by Kirill Pahnev on 01/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public extension URL {
    func appendingPathComponent(_ component: String?) -> URL {
        guard let component = component else { return self }
        return appendingPathComponent(component)
    }

    func appendingQueryItem(_ queryItem: URLQueryItem) -> URL {
        guard var urlComps = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            preconditionFailure("Invalid url \(self)")
        }

        let currentQueryItems = urlComps.queryItems ?? []
        urlComps.queryItems = currentQueryItems + [queryItem]

        return urlComps.url!
    }

    func appendingQueryItems(_ queryItems: [URLQueryItem]) -> URL {
        var url = self
        queryItems.forEach { url = url.appendingQueryItem($0) }
        return url
    }

    func appendingLimitQuery(limit: Int?) -> URL {
        return appendingQueryItem(URLQueryItem(name: "limit", value: String(limit)))
    }

    func appendingPagination(_ pagination: Pagination) -> URL {
        return appendingQueryItem(URLQueryItem(name: "page", value: String(pagination.page)))
            .appendingLimitQuery(limit: pagination.limit)
    }

    func appendingInfo(_ info: InfoLevel?) -> URL {
        guard let info = info else { return self }
        return appendingQueryItem(URLQueryItem(name: "extended", value: info.rawValue))
    }

    func appendingTimePeriod(_ timePeriod: TimePeriod?) -> URL {
        guard let timePeriod = timePeriod else { return self }
        return appendingPathComponent(timePeriod.rawValue)
    }
}
