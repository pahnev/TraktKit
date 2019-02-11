//
//  CacheConfig+Sync.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 29/08/2018.
//

import Foundation
import Cache

extension Sync: CacheConfigurable {
    static var allCases: [CacheConfigurable] {
        // TODO: Fix to have all cases
        let cases: [Sync] = [
            .lastActivities,
            .getPlaybackProgress(type: .movies, limit: 0),
            .getCollection(type: .movies, infoLevel: .min),
            .getHistory(payload: HistoryPayload(type: .movies, pageNumber: 1)),
            .getWatchlist(type: .movies, infoLevel: .min, pagination: Pagination(page: 1, limit: 1)),
            .getRatings(type: .all, infoLevel: .min)
        ]
        return cases
    }

    var name: String {
        switch self {
        case .lastActivities:
            return "lastActivities"
        case .getPlaybackProgress:
            return "playbackProgress"
        case .getCollection:
            return "getCollection"
        case .getHistory:
            return "getHistory"
        case .getRatings:
            return "getRatings"
        case .getWatchlist:
            return "getWatchlist"
        case .addToCollection,
             .removePlayback,
             .removeFromCollection,
             .addToHistory,
             .removeFromHistory,
             .addRatings,
             .removeRatings,
             .addToWatchlist,
             .removeFromWatchlist:
            preconditionFailure()
        }
    }

    var key: String {
        switch self {
        case .lastActivities:
            return name
        case .getPlaybackProgress(let params):
            return "\(name)_\(params.type.rawValue)"
        case .getCollection(let params):
            return "\(name)_\(params.type.rawValue)_\(params.infoLevel.rawValue)"
        case .getHistory(let payload):
            return "\(name)_\(payload.type.rawValue)_\(payload.pageNumber)"
        case .getRatings(let params):
            return "\(name)_\(params.type.rawValue)_\(params.infoLevel.rawValue)"
        case .getWatchlist(let params):
            return "\(name)_\(params.type.rawValue)_\(params.infoLevel.rawValue)_\(params.pagination.page)"
        case .addToCollection,
             .removeFromCollection,
             .addToHistory,
             .removeFromHistory,
             .addRatings,
             .removeRatings,
             .addToWatchlist,
             .removeFromWatchlist,
             .removePlayback:
            preconditionFailure()
        }
    }

    var diskMaxSize: UInt {
        let MB = UInt(1024 * 1024)

        switch self {
        case .lastActivities, .getPlaybackProgress:
            return MB
        case .getCollection, .getHistory, .getRatings, .getWatchlist:
            return MB * 50
        case .addToCollection,
             .removeFromCollection,
             .addToHistory,
             .removeFromHistory,
             .addRatings,
             .removeRatings,
             .addToWatchlist,
             .removeFromWatchlist,
             .removePlayback:
            preconditionFailure()
        }
    }

    var memoryMaxItemCount: UInt {
        switch self {
        case .lastActivities:
            return 1
        case .getCollection, .getHistory, .getRatings, .getWatchlist, .getPlaybackProgress:
            return 500
        case .addToCollection,
             .removeFromCollection,
             .addToHistory,
             .removeFromHistory,
             .addRatings,
             .removeRatings,
             .addToWatchlist,
             .removeFromWatchlist,
             .removePlayback:
            preconditionFailure()
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
        let storeDirectoryName = "tmdbkit-store"
        let dirSubPath = "/" + bundleIdentifier + "/" + storeDirectoryName

        guard let cacheBaseDirPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            preconditionFailure("No caches directory path in system")
        }

        return URL(fileURLWithPath: cacheBaseDirPath + dirSubPath)
    }
}
