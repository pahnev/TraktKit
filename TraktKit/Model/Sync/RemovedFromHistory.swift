//
//  RemovedFromHistory.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 29/08/2018.
//

import Foundation

public struct RemovedFromHistory: CodableEquatable {
    public struct Deleted: CodableEquatable {
        let movies: Int
        let episodes: Int
    }
    public struct NotFound: CodableEquatable {
        public let movies: [TraktIdContainer]
        public let shows: [TraktIdContainer]
        public let episodes: [TraktIdContainer]
        public let ids: [Int]
    }

    let deleted: Deleted
    let notFound: RemovedFromHistory.NotFound
}
