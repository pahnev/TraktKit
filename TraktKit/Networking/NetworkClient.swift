//
//  NetworkClient.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 01/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

enum NetworkResult {
    struct SuccessValue {
        let value: Data
        let headers: HTTPResponseHeaders

        init(_ value: Data, headers: HTTPResponseHeaders) {
            self.value = value
            self.headers = headers
        }
    }

    case success(SuccessValue)
    case error(Error)
}

final class NetworkClient {
    private let traktClient: ClientProvider
    private let httpLogger: HTTPLogger
    private let urlSession: URLSession

    init(traktClient: ClientProvider) {
        self.traktClient = traktClient
        httpLogger = HTTPLogger()

        let urlConfiguration = URLSessionConfiguration.default
        urlConfiguration.urlCache = nil
        urlConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlConfiguration.httpAdditionalHeaders = ["trakt-api-key": traktClient.clientId,
                                                  "trakt-api-version": "2",
                                                  "Content-type": "application/json"]
        urlSession = URLSession(configuration: urlConfiguration)
    }

    func executeAuthenticatedRequest(for endpoint: Endpoint, additionalHeaders: [String: String] = [:], completion: @escaping (NetworkResult) -> Void) {
        let request = authenticatedRequest(endpoint, additionalHeaders: additionalHeaders)

        startRequest(request, completion: completion)
    }

}

private extension NetworkClient {
    func authenticatedRequest(_ endpoint: Endpoint, additionalHeaders: [String: String]) -> URLRequest {
        var request = URLRequest(url: endpoint.url)

        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoint.requestHeaders
        additionalHeaders.forEach { key, value in request.addValue(value, forHTTPHeaderField: key)}

        if let httpBody = endpoint.httpBody {
            request.httpBody = httpBody
        }

        return request
    }

    func startRequest(_ request: URLRequest, completion: @escaping (NetworkResult) -> Void) {
        let reqId = httpLogger.logStart(request)

        let task = urlSession.dataTask(with: request) { data, response, httpRequestError in
            self.httpLogger.logComplete(with: reqId, data: data, response: response, error: httpRequestError)

            DispatchQueue.main.async {
                if let httpRequestError = httpRequestError {
                    return completion(.error(TraktError.networkError(httpRequestError)))
                }

                guard let data = data else {
                    return completion(.error(TraktError.emptyDataReceivedError))
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    return completion(.error(TraktError.nonHttpResponseError))
                }

                guard 200 ..< 300 ~= httpResponse.statusCode else {
                    return completion(.error(TraktError.httpError(httpResponse.statusCode)))
                }

                return completion(.success(NetworkResult.SuccessValue(data, headers: HTTPResponseHeaders(httpResponse.allHeaderFields))))
            }
        }

        task.resume()
    }
}
