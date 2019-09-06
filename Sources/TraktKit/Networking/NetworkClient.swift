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
        let statusCode: Int
    }

    case success(SuccessValue)
    case error(Error)
}

final class NetworkClient {
    private let traktClient: ClientProvider
    private let httpLogger: HTTPLogger
    private let urlSession: URLSession
    private let cache: URLCache

    init(traktClient: ClientProvider, cache: URLCache = URLCache.shared) {
        self.traktClient = traktClient
        self.cache = cache
        httpLogger = HTTPLogger()

        cache.diskCapacity = 100 * 1024 * 1024
        cache.memoryCapacity = 100 * 1024 * 1024

        let urlConfiguration = URLSessionConfiguration.default
        urlConfiguration.urlCache = nil
        urlConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlConfiguration.httpAdditionalHeaders = ["trakt-api-key": traktClient.clientId,
                                                  "trakt-api-version": "2",
                                                  "Content-type": "application/json"]
        urlSession = URLSession(configuration: urlConfiguration)
    }

    func cacheDiskStorageSize() -> Int {
        return cache.currentDiskUsage
    }

    func clearCaches() {
        cache.removeAllCachedResponses()
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

        if let cachedResponse = cache.cachedResponse(for: request), let httpResponse = cachedResponse.response as? HTTPURLResponse {
            return completion(.success(NetworkResult.SuccessValue(value: cachedResponse.data,
                                                                  headers: HTTPResponseHeaders(httpResponse.allHeaderFields),
                                                                  statusCode: httpResponse.statusCode)))
        }

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

                self.cache.storeCachedResponse(CachedURLResponse(response: httpResponse, data: data), for: request)
                return completion(.success(NetworkResult.SuccessValue(value: data,
                                                                      headers: HTTPResponseHeaders(httpResponse.allHeaderFields),
                                                                      statusCode: httpResponse.statusCode)))
            }
        }

        task.resume()
    }
}
