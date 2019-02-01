//
//  Trakt+Sync.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 28/08/2018.
//

import Foundation

public enum ContentType: String, CodableEquatable {
    case movies
    case shows
    case seasons
    case episodes
    case all = ""
}

extension Trakt {

    /// This method is a useful first step in the syncing process. We recommended caching these dates locally, then you can compare to know exactly what data has changed recently. This can greatly optimize your syncs so you don't pull down a ton of data only to see nothing has actually changed.
    ///
    /// 🔒 OAuth Required
    ///
    /// - Parameter completion: The closure called on completion with `LastActivities`or `TraktError`.
    public func getLastActivities(completion: @escaping TraktResult<LastActivities>) {
        assertLoggedInUser()

        fetchObject(ofType: LastActivities.self, cacheConfig: Sync.lastActivities, endpoint: Sync.lastActivities, completion: completion)
    }

    /// Whenever a scrobble is paused, the playback progress is saved. Use this progress to sync up playback across different media centers or apps. For example, you can start watching a movie in a media center, stop it, then resume on your tablet from the same spot. Each item will have the progress percentage between 0 and 100.
    ///
    /// 🔒 OAuth Required
    ///
    /// - Parameters:
    ///   - type: You can pass specific type to only get those items.
    ///   - limit: Limit the amount of items returned. By default all results will be returned.
    ///   - completion: The closure called on completion with a list of `PlaybackProgress` items or `TraktError`.
    public func getPlaybackProgress(type: WatchedType = .all, limit: Int, completion: @escaping TraktResult<[PlaybackProgress]>) {
        assertLoggedInUser()

        fetchObject(ofType: [PlaybackProgress].self,
                    cacheConfig: Sync.getPlaybackProgress(type: type, limit: limit),
                    endpoint: Sync.getPlaybackProgress(type: type, limit: limit),
                    completion: completion)
    }

    /// Remove a playback item from a user's playback progress list. A 404 will be returned if the `id` is invalid.
    ///
    /// 🔒 OAuth Required
    ///
    /// - Parameter id: The id of the `PlaybackProgress` item to be removed.
    public func removePlaybackItemWith(_ id: PlaybackProgressId, completion: @escaping RequestResult<Void>) {
        assertLoggedInUser()

        authenticatedRequest(for: Sync.removePlayback(id), completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                completion(.success(()))
            }
        })
    }

    /// Get all `Movie` items in user's collection. A collected item indicates availability to watch digitally or on physical media.
    /// Using `InfoLevel.metadata` will include `Metadata` for each item.
    ///
    /// 🔒 OAuth Required
    ///
    /// - Parameters:
    ///   - infoLevel: The info level of the items.
    ///   - completion: The closure called on completion with a list of `CollectedMovie` items or `TraktError`.
    public func getCollectedMovies(infoLevel: InfoLevel = .min, completion: @escaping TraktResult<[CollectedMovie]>) {
        assertLoggedInUser()

        fetchObject(ofType: [CollectedMovie].self,
                    cacheConfig: Sync.getCollection(type: .movies, infoLevel: infoLevel),
                    endpoint: Sync.getCollection(type: .movies, infoLevel: infoLevel),
                    completion: completion)
    }

    /// Get all `Show` items in user's collection. A collected item indicates availability to watch digitally or on physical media.
    /// Using `InfoLevel.metadata` will include `Metadata` for each item.
    ///
    /// 🔒 OAuth Required
    ///
    /// - Parameters:
    ///   - infoLevel: The info level of the items.
    ///   - completion: The closure called on completion with a list of `CollectedShow` items or `TraktError`.
    public func getCollectedShows(infoLevel: InfoLevel = .min, completion: @escaping TraktResult<[CollectedShow]>) {
        assertLoggedInUser()

        fetchObject(ofType: [CollectedShow].self,
                    cacheConfig: Sync.getCollection(type: .shows, infoLevel: infoLevel),
                    endpoint: Sync.getCollection(type: .shows, infoLevel: infoLevel),
                    completion: completion)
    }

    func addToCollection() {
        // TODO:
    }
    func removeFromCollection() {
        // TODO:
    }

    func getWatched() {
        // TODO:
    }

    /// Returns movies and episodes that a user has watched, sorted by most recent.
    /// You can optionally limit the type to movies or episodes.
    /// The `id` in each `HistoryItem` uniquely identifies the event and can be used to remove individual events by using the `removeFromHistory` method.
    ///
    /// 🔒 OAuth Required 📄 Pagination ✨ Extended Info
    public func getHistory(type: ContentType,
                           pageNumber: PageNumber,
                           resultsPerPage: Int = 10,
                           traktId: Int? = nil,
                           infoLevel: InfoLevel = .min,
                           startDate: String? = nil,
                           endDate: String? = nil,
                           completion: @escaping TraktResult<[HistoryItem]>) {
        assertLoggedInUser()

        let payload = HistoryPayload(type: type, pageNumber: pageNumber, resultsPerPage: resultsPerPage, traktId: traktId, infoLevel: infoLevel, startDate: startDate, endDate: endDate)

        fetchObject(ofType: [HistoryItem].self,
                    cacheConfig: Sync.getHistory(payload: payload),
                    endpoint: Sync.getHistory(payload: payload),
                    completion: completion)
    }

    public func addToHistory(movies: [TraktId] = [], shows: [TraktId] = [], episodes: [TraktId] = [], completion: @escaping TraktResult<AddedToHistory>) {
        assertLoggedInUser()

        let data = syncPayload(movies: movies, shows: shows, episodes: episodes, items: [])
        authenticatedRequestAndParse(Sync.addToHistory(data), completion: completion)
    }

    public func removeFromHistory(movies: [TraktId] = [], shows: [TraktId] = [], episodes: [TraktId] = [], items: [HistoryItemId] = [], completion: @escaping TraktResult<RemovedFromHistory>) {
        assertLoggedInUser()

        let data = syncPayload(movies: movies, shows: shows, episodes: episodes, items: items)
        authenticatedRequestAndParse(Sync.removeFromHistory(data), completion: completion)
    }

    func getRatings() {
        // TODO:
    }

    func addRatings() {
        // TODO:
    }

    func removeRatings() {
        // TODO:
    }

    /// Returns all items in a user's watchlist. By default returns items of all types.
    /// All list items are sorted by ascending `ListItem.rank`.
    ///
    /// 🔒 OAuth Required 📄 Pagination Optional ✨ Extended Info
    ///
    /// - Parameters:
    ///   - type: The specifi type of the items. Defaults to `all`.
    ///   - infoLevel: The info level of the items. Defaults to `min`.
    ///   - page: The page of the results.
    ///   - resultsPerPage: The amount of results per page should be returned. Defaults to 10 results.
    ///   - completion: The closure called on completion with a list of `ListItem`s or `TraktError`.
    public func getWatchlist(type: ContentType = .all, infoLevel: InfoLevel = .min, page: Int, resultsPerPage: Int = 10, completion: @escaping TraktResult<[ListItem]>) {
        assertLoggedInUser()
        let getWatchlist = Sync.getWatchlist(type: type, infoLevel: infoLevel, pagination: Pagination(page: page, limit: resultsPerPage))
        fetchObject(ofType: [ListItem].self,
                    cacheConfig: getWatchlist,
                    endpoint: getWatchlist,
                    completion: completion)
    }

    public func addToWatchlist() {
        // TODO:
    }

    public func removeFromWatchlist() {
        // TODO:
    }

}

// MARK: - Private

private extension Trakt {
    private func syncPayload(movies: [TraktId], shows: [TraktId], episodes: [TraktId], items: [HistoryItemId]) -> Sync.Payload {
        func containers(from ids: [TraktId]) -> [TraktIdContainer] {
            return ids
                .map { TraktIdContainer.Id(trakt: $0) }
                .map { TraktIdContainer(ids: $0) }
        }
        return Sync.Payload(movies: containers(from: movies), shows: containers(from: shows), episodes: containers(from: episodes), ids: items)
    }
}
