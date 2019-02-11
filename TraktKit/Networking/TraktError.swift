//
//  TraktError.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 30/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public enum TraktError: Error, LocalizedError {
    case networkError(Error) /// Network error during HTTP request was received
    case emptyDataReceivedError /// Data in URLResponse was nil
    case httpError(Int) /// Non-OK HTTP status code was received (outside range of 200-299)
    case nonHttpResponseError /// Non-HTTP response was received
    case decodingError(DecodingError) /// JSON decoding error
    case cacheSavingError(Error) // Error during saving an object to cache.
    case clientSecretMissing
    case oAuthCallbackCodeMissing

    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .emptyDataReceivedError:
            return "Empty data received from server"
        case .httpError(let httpCode):
            return "HTTP error: \(httpCode)"
        case .nonHttpResponseError:
            return "Non-HTTP response received"
        case .decodingError(let error):
            return "JSON decoding error: \(error.localizedDescription)"
        case .cacheSavingError(let error):
            return "Cache saving error: \(error.localizedDescription)"
        case .clientSecretMissing:
            return "Client secret is required for the action"
        case .oAuthCallbackCodeMissing:
            return "Callback URL did not have the authorization code in it"
        }
    }
}
