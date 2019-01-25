//
//  Authentication.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 29/08/2018.
//

import Foundation

enum Authentication: Endpoint {
    struct TokenData: CodableEquatable {
        let code: String
        let clientId: String
        let clientSecret: String
        let redirectUri: String
        let grantType: String
    }
    case authorize(clientId: String, redirectURI: String)
    case getToken(TokenData)

    var httpMethod: HTTPMethod {
        switch self {
        case .authorize:
            return .GET
        case .getToken:
            return .POST
        }
    }

    var httpBody: Data? {
        switch self {
        case .authorize:
            return nil
        case .getToken(let params):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try! encoder.encode(params)
        }
    }

    var requestHeaders: [String : String] {
        switch self {
        case .authorize, .getToken:
            return [:]
        }
    }

    var url: URL {
        switch self {
        case .authorize(let params):
            return baseURL
                .appendingPathComponent("oauth/authorize")
                .appendingQueryItem(URLQueryItem(name: "response_type", value: "code"))
                .appendingQueryItem(URLQueryItem(name: "client_id", value: params.clientId))
                .appendingQueryItem(URLQueryItem(name: "redirect_uri", value: params.redirectURI))
        case .getToken:
            return baseURL.appendingPathComponent("oauth/token")
        }
    }

}
