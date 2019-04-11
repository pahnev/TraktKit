//
// Created by Kirill Pahnev on 2019-02-12.
//

import Foundation
import Cache

extension Users: CacheConfigurable {
    static var allCases: [CacheConfigurable] {
        return [
            .getWatching(userId: "", infoLevel: .min),
            .getStats(userId: "")
            ] as [Users]
    }

    var name: String {
        switch self {
        case .getWatching:
            return "getWatching"
        case .getStats:
            return "stats"
        }
    }

    var key: String {
        switch self {
        case .getWatching(let params):
            return "\(name)_\(params.userId)_\(params.infoLevel.rawValue)"
        case .getStats(let userId):
            return "\(name)_\(userId)"
        }
    }

    var diskMaxSize: UInt {
        switch self {
        case .getWatching, .getStats:
            return 1
        }
    }

    var memoryMaxItemCount: UInt {
        switch self {
        case .getWatching, .getStats:
            return 1
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
