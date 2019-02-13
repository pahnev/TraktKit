//
//return "//

//  TraktKit
//
//  Created by Kirill Pahnev on 01/08/2018.
//

import Cache
import Foundation

extension Movies: CacheConfigurable {
    static let allCases: [CacheConfigurable] = {
        var allCases: [Movies] = []
        switch Movies.aliases(movieId: 0) {
        case .aliases: allCases.append(.aliases(movieId: 0))
            fallthrough
        case .boxOffice: allCases.append(.boxOffice)
            fallthrough
        case .comments: allCases.append(.comments(movieId: 0, sort: "", pageNumber: 0, resultsPerPage: 0))
            fallthrough
        case .currentlyWatching: allCases.append(.currentlyWatching(movieId: 0))
            fallthrough
        case .details: allCases.append(.details(movieId: 0, infoLevel: .min))
            fallthrough
        case .lists: allCases.append(.lists(movieId: 0, type: "", sort: "", pageNumber: 0, resultsPerPage: 0))
            fallthrough
        case .mostAnticipated: allCases.append(.mostAnticipated(pageNumber: 0, resultsPerPage: 0))
            fallthrough
        case .mostCollected: allCases.append(.mostCollected(pageNumber: 0, timePeriod: "", resultsPerPage: 0))
            fallthrough
        case .mostPlayed: allCases.append(.mostPlayed(pageNumber: 0, timePeriod: "", resultsPerPage: 0))
            fallthrough
        case .mostWatched: allCases.append(.mostWatched(pageNumber: 0, timePeriod: "", resultsPerPage: 0))
            fallthrough
        case .people: allCases.append(.people(movieId: 0))
            fallthrough
        case .popular: allCases.append(.popular(pageNumber: 0, resultsPerPage: 0))
            fallthrough
        case .ratings: allCases.append(.ratings(movieId: 0))
            fallthrough
        case .recentlyUpdated: allCases.append(.recentlyUpdated(pageNumber: 0, startDate: "", resultsPerPage: 0))
            fallthrough
        case .related: allCases.append(.related(movieId: 0, pageNumber: 0, resultsPerPage: 0))
            fallthrough
        case .releases: allCases.append(.releases(movieId: 0, country: ""))
            fallthrough
        case .stats: allCases.append(.stats(movieId: 0))
            fallthrough
        case .translations: allCases.append(.translations(movieId: 0, language: ""))
            fallthrough
        case .trending: allCases.append(.trending(pageNumber: 0, resultsPerPage: 0, infoLevel: .min))
        }
        return allCases
    }()

    var name: String {
        switch self {
        case .aliases: return "aliases"
        case .boxOffice: return "boxOffice"
        case .comments: return "comments"
        case .currentlyWatching: return "currentlyWatching"
        case .details: return ".details"
        case .lists: return "lists"
        case .mostAnticipated: return "mostAnticipated"
        case .mostCollected: return "mostCollected"
        case .mostPlayed: return "mostPlayed"
        case .mostWatched: return "mostWatched"
        case .people: return ".people"
        case .popular: return ".popular"
        case .ratings: return ".ratings"
        case .recentlyUpdated: return "recentlyUpdated"
        case .related: return ".related"
        case .releases: return ".releases"
        case .stats: return ".stats"
        case .translations: return ".translations"
        case .trending: return ".trending"
        }
    }

    var key: String {
        switch self {
        case .aliases(let movieId):
            return "\(name)_\(movieId)"
        case .boxOffice:
            return name
        case .comments(let params):
            return "\(name)_\(params.movieId)_\(params.sort)_\(params.pageNumber)"
        case .currentlyWatching(let movieId):
            return "\(name)_\(movieId)"
        case .details(let movieId):
            return "\(name)_\(movieId)"
        case .lists(let params):
            return "\(name)_\(params.movieId)_\(params.type))_\(params.sort)_\(params.pageNumber)"
        case .mostAnticipated(let pageNumber):
            return "\(name)_\(pageNumber)"
        case .mostCollected(let params):
            return "\(name)_\(params.pageNumber)_\(params.timePeriod)"
        case .mostPlayed(let params):
            return "\(name)_\(params.pageNumber)_\(params.timePeriod)"
        case .mostWatched(let params):
            return "\(name)_\(params.pageNumber)_\(params.timePeriod)"
        case .people(let movieId):
            return "\(name)_\(movieId)"
        case .popular(let pageNumber):
            return "\(name)_\(pageNumber)"
        case .ratings(let movieId):
            return "\(name)_\(movieId)"
        case .recentlyUpdated(let params):
            return "\(name)_\(params.startDate)_\(params.pageNumber)"
        case .related(let params):
            return "\(name)_\(params.movieId)_\(params.pageNumber)"
        case .releases(let params):
            return "\(name)_\(params.movieId)_\(params.country)"
        case .stats(let movieId):
            return "\(name)_\(movieId)"
        case .translations(let params):
            return "\(name)_\(params.movieId)_\(params.language)"
        case .trending(let pageNumber):
            return "\(name)_\(pageNumber)"
        }
    }

    var diskMaxSize: UInt {
        let MB = UInt(1024 * 1024)
        switch self {
        case .aliases,
             .comments,
             .currentlyWatching,
             .details,
             .lists,
             .people,
             .translations,
             .ratings,
             .related,
             .releases,
             .stats:
            return MB * 50
        case .boxOffice:
            return MB
        case .mostAnticipated, .mostCollected, .mostPlayed, .mostWatched, .popular, .recentlyUpdated, .trending:
            return MB * 5
        }
    }

    var memoryMaxItemCount: UInt {
        switch self {
        case .aliases,
             .comments,
             .currentlyWatching,
             .details,
             .lists,
             .people,
             .translations,
             .ratings,
             .related,
             .releases,
             .stats:
            return 500
        case .boxOffice:
            return 1
        case .mostAnticipated, .mostCollected, .mostPlayed, .mostWatched, .popular, .recentlyUpdated, .trending:
            return 50
        }
    }

    func createCache() throws -> Storage {
        let diskConfig = DiskConfig(name: name,
                                    expiry: .never,
                                    maxSize: diskMaxSize,
                                    directory: cacheDirectoryURL(),
                                    protectionType: nil)

        let memoryConfig = MemoryConfig(expiry: .never,
                                        countLimit: memoryMaxItemCount,
                                        totalCostLimit: memoryMaxItemCount)

        return try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)

    }

    var diskStorageSize: Int {
        let url = cacheDirectoryURL().appendingPathComponent(name)
        guard let files = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.fileSizeKey]) else {
            print("Couldn't list files in \(url)")
            return 0
        }

        let totalSize = files.reduce(0) { previousSize, fileURL -> Int in
            let resourceValues: URLResourceValues? = try? fileURL.resourceValues(forKeys: [.fileSizeKey])
            let size = resourceValues?.fileSize ?? 0
            return previousSize + size
        }
        return totalSize
    }

    private func cacheDirectoryURL() -> URL {
        final class InternalClassForBundleLoader {}
        guard let bundleIdentifier = Bundle(for: InternalClassForBundleLoader.self).bundleIdentifier else { preconditionFailure("Missing bundleIdentifier") }
        let storeDirectoryName = "traktkit-store"
        let dirSubPath = "/" + bundleIdentifier + "/" + storeDirectoryName

        guard let cacheBaseDirPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            preconditionFailure("No caches directory path in system")
        }

        return URL(fileURLWithPath: cacheBaseDirPath + dirSubPath)
    }
}
