//
// Created by Kirill Pahnev on 2019-02-12.
//

extension Trakt {

    /// Returns a `Movie` or `Episode` if the user is currently watching something.
    ///
    /// 🔒 OAuth Optional ✨ Extended Info
    ///
    /// - Parameters:
    ///   - userId: The slug of the user whose watching info should be fetched.
    ///   - infoLevel: The info level of the watching object, if any. Defaults to `.min`
    ///   - completion: The closure called on completion with a `Watching` object or `TraktError`. Returns Void if user is not watching anything.
    func getWatching(userId: String, infoLevel: InfoLevel = .min, completion: @escaping TraktResult<Watching?>) {
        let endpoint = Users.getWatching(userId: userId, infoLevel: infoLevel)
        authenticatedRequestAndParse(endpoint, completion: completion)
    }

    /// Returns stats about the movies, shows, and episodes a user has watched, collected, and rated.
    ///
    /// 🔒 OAuth Optional
    ///
    /// - Parameters:
    ///   - userId: The slug of the user whose watching info should be fetched.
    ///   - completion: The closure called on completion with a `UserStats` object or `TraktError`.
    func getStats(userId: String, completion: @escaping TraktResult<UserStats>) {
        let endpoint = Users.getStats(userId: userId)
        fetchObject(ofType: UserStats.self,
                    cacheConfig: endpoint,
                    endpoint: endpoint,
                    completion: completion)
    }
}
