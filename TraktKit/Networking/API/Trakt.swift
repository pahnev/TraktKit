//
//  Trakt.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 29/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Paginated<Type: Codable> {
    public var type: Type
    public var pagination: PaginationData?
}

public typealias TraktResult<CachedObjectType: Codable> = (Result<CachedObjectType, TraktError>) -> Void
public typealias PaginatedTraktResult<CachedObjectType: Codable> = (Result<Paginated<CachedObjectType>, TraktError>) -> Void
public typealias RequestResult<T> = (Result<T, TraktError>) -> Void

public final class Trakt {
    private let traktClient: ClientProvider
    private let networkClient: NetworkClient
    var auth: Authenticator?

    public init(traktClient: ClientProvider) throws {
        self.traktClient = traktClient
        networkClient = NetworkClient(traktClient: traktClient)
    }

    public func authenticate(_ auth: Authenticator) {
        self.auth = auth
    }

    /// Constructs an URL to be used in the app to allow the user authenticate with Trakt.
    ///
    /// - Parameter redirectURI: The redirect URI configured in the app's URL types and the Trakt app dashboard.
    /// - Returns: Returns the OAuth URL that you can show to the user in your app.
    public func oAuthURL(redirectURI: String) -> URL {
        return Authentication.authorize(clientId: traktClient.clientId, redirectURI: redirectURI).url
    }

    /// A helper function to authenticate `Trakt` client with the received `callbackURL` after successful user login.
    ///
    /// - Parameters:
    ///   - callbackURL: The callback url received during the OAuth process.
    ///   - redirectURI: The redirect URI your app responds to.
    ///   - completion: A closure called when the authentication is finished. Returns either `TokenResponse` or `TraktError`.
    public func getToken(from callbackURL: URL, redirectURI: String, completion: @escaping TraktResult<TokenResponse>) {
        guard let secret = traktClient.secret else { return completion(.failure(TraktError.clientSecretMissing)) }

        let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)
        guard let authCode = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return completion(.failure(TraktError.oAuthCallbackCodeMissing))
        }

        let data = Authentication.TokenData(code: authCode,
                                            clientId: traktClient.clientId,
                                            clientSecret: secret,
                                            redirectUri: redirectURI,
                                            grantType: "authorization_code")
        authenticatedRequestAndParse(Authentication.getToken(data), completion: completion)
    }

    /// - Returns: Total byte size of all caches stored on disk by TraktKit
    public func cacheDiskStorageSize() -> Int {
        return networkClient.cacheDiskStorageSize()
    }

    /// Removes all cached data from memory and disk.
    public func clearCaches() {
        networkClient.clearCaches()
    }

    func assertLoggedInUser() {
        guard auth?.accessToken != nil else {
            preconditionFailure("This call requires user to be logged in. Make sure you are giving the token to your `Trakt` object after successful login.")
        }
    }
    
    /// Fetches the wanted object either from Cache if one is found, otherwise from the network. The successfull network request is then cached.
    ///
    /// - Parameters:
    ///   - ofType: The object that should be fetched. Has to conform to CodableEquatable.
    ///   - cacheConfig: The Cache configuration defining where to look for the object or cache in case it has to be fetched from network.
    ///   - endpoint: The API endpoint to fetch the object from.
    ///   - completion: The closure called when the fetch is finished. Returns either the object requested or TraktError if something failed.
    func fetchObject<CachedObjectType: Codable>(ofType: CachedObjectType.Type, cacheConfig: CacheConfigurable, endpoint: Endpoint, additionalHeaders: [String: String] = [:], completion: @escaping TraktResult<CachedObjectType>) {
        fetchObjectFromNetwork(ofType: CachedObjectType.self, cacheConfig: cacheConfig, endpoint: endpoint, additionalHeaders: additionalHeaders, currentCacheEntry: nil, completion: completion)
    }

    /// Performs authenticated request and returns either NetworkResult.SuccessValue on successful completion or TraktError if something failed.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to make the request to.
    ///   - additionalHeaders: Any additional header values that should be added to the request.
    ///   - completion: The closure called when the fetch is finished. Returns either NetworkResult.SuccessValue on successful completion or TraktError if something failed.
    func authenticatedRequest(for endpoint: Endpoint, additionalHeaders: [String: String] = [:], completion: @escaping RequestResult<NetworkResult.SuccessValue>) {
        networkClient.executeAuthenticatedRequest(for: endpoint, additionalHeaders: addAuthHeaderTo(additionalHeaders)) { result in
            switch result {
            case .error(let error):
                completion(.failure(TraktError.networkError(error)))
            case .success(let value):
                completion(.success(value))
            }
        }
    }

    func authenticatedRequestAndParse<Type: Codable>(_ endpoint: Endpoint, additionalHeaders: [String: String] = [:], completion: @escaping TraktResult<Type>) {
        networkClient.executeAuthenticatedRequest(for: endpoint, additionalHeaders: addAuthHeaderTo(additionalHeaders)) { result in
            switch result {
            case .error(let error):
                completion(.failure(TraktError.networkError(error)))
            case .success(let value):
                guard value.statusCode != 204 else { return completion(.failure(TraktError.emptyContent)) }

                do {
                    let parsedObject = try self.parseObject(ofType: Type.self, data: value.value)
                    completion(.success(parsedObject))
                } catch let error as TraktError {
                    return completion(.failure(error))
                } catch {
                    preconditionFailure("There should no other error thrown from parsing.")
                }
            }
        }
    }

    private func addAuthHeaderTo(_ headers: [String: String]) -> [String: String] {
        var copy = headers
        if let auth = auth {
            copy["Authorization"] = "Bearer \(auth.accessToken)"
        }
        return copy
    }
}

// MARK: - Private

private extension Trakt {
    // MARK: - Object handling

    func parseObject<CachedObjectType: Codable>(ofType: CachedObjectType.Type, data: Data) throws -> CachedObjectType {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(.iso8601Full)
            return try decoder.decode(CachedObjectType.self, from: data)
        } catch DecodingError.dataCorrupted(let context) {
            print("JSON parsing failed, data is corrupted. Context: \(context)")
            throw TraktError.decodingError(DecodingError.dataCorrupted(context))
        } catch DecodingError.keyNotFound(let codingKey, let context) {
            print("JSON parsing failed, key not found. CodingKey: '\(codingKey)'. Context: \(context)")
            throw TraktError.decodingError(DecodingError.keyNotFound(codingKey, context))
        } catch DecodingError.typeMismatch(let object, let context) {
            print("JSON parsing failed, type mismatch. Object: \(object). Context: \(context)")
            throw TraktError.decodingError(DecodingError.typeMismatch(object, context))
        } catch DecodingError.valueNotFound(let object, let context) {
            print("JSON parsing failed, value not found. Object: \(object). Context: \(context)")
            throw TraktError.decodingError(DecodingError.valueNotFound(object, context))
        }
    }

    func parseAndCache<CachedObjectType: Codable>(ofType: CachedObjectType.Type, cacheConfig: CacheConfigurable, value: NetworkResult.SuccessValue, completion: TraktResult<CachedObjectType>) {
        let parsedObject: CachedObjectType
        do {
            parsedObject = try self.parseObject(ofType: CachedObjectType.self, data: value.value)
            completion(.success(parsedObject))

        } catch let error as TraktError {
            return completion(.failure(error))
        } catch {
            preconditionFailure("There should no other error thrown from parsing.")
        }
    }

    func fetchObjectFromNetwork<CachedObjectType: Codable>(ofType: CachedObjectType.Type, cacheConfig: CacheConfigurable, endpoint: Endpoint, additionalHeaders: [String: String] = [:], currentCacheEntry: CacheEntry<CachedObjectType>?, completion: @escaping TraktResult<CachedObjectType>) {

        authenticatedRequest(for: endpoint, additionalHeaders: additionalHeaders, completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let value):
                self.parseAndCache(ofType: CachedObjectType.self, cacheConfig: cacheConfig, value: value, completion: completion)
            }
        })
    }

}

// MARK: - Pagination code

extension Trakt {
    func fetchPaginatedObject<CachedObjectType: Codable>(ofType: CachedObjectType.Type, cacheConfig: CacheConfigurable, endpoint: Endpoint, additionalHeaders: [String: String] = [:], completion: @escaping PaginatedTraktResult<CachedObjectType>) {
            return self.fetchPaginatedObjectFromNetwork(ofType: CachedObjectType.self,
                                                        cacheConfig: cacheConfig,
                                                        endpoint: endpoint,
                                                        additionalHeaders: additionalHeaders,
                                                        currentCacheEntry: nil,
                                                        completion: completion)
    }

    private func parseAndCachePaginated<CachedObjectType: Codable>(ofType: CachedObjectType.Type, cacheConfig: CacheConfigurable, value: NetworkResult.SuccessValue, completion: PaginatedTraktResult<CachedObjectType>) {
        let parsedObject: CachedObjectType
        do {
            guard let pagination = value.headers.pagination else { preconditionFailure("You should call parseAndCache() instead")}
            parsedObject = try self.parseObject(ofType: CachedObjectType.self, data: value.value)
            completion(.success(Paginated(type: parsedObject, pagination: pagination)))
        } catch let error as TraktError {
            return completion(.failure(error))
        } catch {
            preconditionFailure("There should no other error thrown from parsing.")
        }
    }

    private func fetchPaginatedObjectFromNetwork<CachedObjectType: Codable>(ofType: CachedObjectType.Type, cacheConfig: CacheConfigurable, endpoint: Endpoint, additionalHeaders: [String: String] = [:], currentCacheEntry: CacheEntry<CachedObjectType>?, completion: @escaping PaginatedTraktResult<CachedObjectType>) {
        authenticatedRequest(for: endpoint, additionalHeaders: additionalHeaders, completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let value):
                self.parseAndCachePaginated(ofType: CachedObjectType.self, cacheConfig: cacheConfig, value: value, completion: completion)
            }
        })
    }

}
