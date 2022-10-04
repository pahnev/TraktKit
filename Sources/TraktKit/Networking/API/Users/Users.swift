//
// Created by Kirill Pahnev on 2019-02-12.
//

import Foundation

public enum Users: Endpoint {
    case getWatching(userId: String, infoLevel: InfoLevel)
    case getStats(userId: String)

    var httpMethod: HTTPMethod {
        switch self {
        case .getWatching, .getStats:
            return .GET
        }
    }

    var httpBody: Data? {
        switch self {
        case .getWatching, .getStats:
            return nil
        }
    }

    var requestHeaders: [String: String] {
        switch self {
        case .getWatching, .getStats:
            return [:]
        }
    }

    var url: URL {
        let users = baseURL.appendingPathComponent("users")
        switch self {
        case .getWatching(let params):
            return users.appendingPathComponent("\(params.userId)/watching")
        case .getStats(let userId):
            return users.appendingPathComponent("\(userId)/stats")
        }
    }
}
