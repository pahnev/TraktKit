//
// Created by Kirill Pahnev on 2019-02-12.
//

extension Trakt {

    /// Returns a `Movie` or `Episode` if the user is currently watching something.
    ///
    /// - Parameters:
    ///   - userId: The slug of the user whose watching info should be fetched.
    ///   - infoLevel: The info level of the watching object, if any. Defaults to `.min`
    ///   - completion: The closure called on completion with a `Watching` object or `TraktError`. Returns Void if user is not watching anything.
    func getWatching(userId: String, infoLevel: InfoLevel = .min, completion: @escaping TraktResult<Watching>) {
        // TODO: Handle empty data case.
        let endpoint = Users.getWatching(userId: userId, infoLevel: infoLevel)
        fetchObject(ofType: Watching.self,
                cacheConfig: endpoint,
                endpoint: endpoint,
                completion: completion)
    }
}
