//
//  Trakt+Checkin.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 18/01/2019.
//

import Foundation

public extension Trakt {
    /// The type that represents different objects that can be sent to server to indicate that the user is currently watching it.
    ///
    /// - movie: A movie object, which has `TraktId`.
    /// - episode: An episode object, which has `TraktId`.
    enum CheckinType {
        case movie(Int), episode(Int)
    }

    /// Check into a movie or episode. This should be tied to a user action to manually indicate they are watching something. The item will display as watching on the site, then automatically switch to watched status once the duration has elapsed. A unique history id (64-bit integer) will be returned and can be used to reference this checkin directly.
    /// Note: If a checkin is already in progress, a 409 HTTP status code will returned. The response will contain an `expires_at` timestamp which is when the user can check in again.
    ///
    /// - Parameters:
    ///   - type: The type of the object checking in.
    ///   - completion: A closure that returns on completion either `Checkin` object or `TraktError`
    func checkin(type: CheckinType, completion: @escaping TraktResult<Checkin>) {
        assertLoggedInUser()

        struct CheckinEndpoint: Endpoint {
            let httpMethod: HTTPMethod = .POST
            let httpBody: Data?
            let requestHeaders: [String: String] = [:]
            let url: URL = baseURL.appendingPathComponent("checkin")

            init(body: Data) {
                httpBody = body
            }
        }

        authenticatedRequestAndParse(CheckinEndpoint(body: payloadForType(type)),
                                     completion: completion)
    }

    private func payloadForType(_ type: CheckinType) -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let payload: CheckinPayload
        switch type {
        case .movie(let id):
            payload = CheckinPayload(movie: .init(ids: .init(trakt: id)), episode: nil)
        case .episode(let id):
            payload = CheckinPayload(movie: nil, episode: .init(ids: .init(trakt: id)))
        }
        return try! encoder.encode(payload)
    }
}

private struct CheckinPayload {
    struct CheckinObject {
        struct ObjectId {
            let trakt: Int
        }

        let ids: ObjectId
    }

    let movie: CheckinObject?
    let episode: CheckinObject?
}

extension CheckinPayload.CheckinObject.ObjectId: Codable {}
extension CheckinPayload.CheckinObject: Codable {}
extension CheckinPayload: Codable {}
