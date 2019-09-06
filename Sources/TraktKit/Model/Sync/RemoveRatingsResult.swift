//
//  RemoveRatingsResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct RemoveRatingsResult: CodableEquatable {
    public let deleted: Deleted
//    public let notFound: NotFound

    public struct Deleted: CodableEquatable {
        public let movies: Int
        public let shows: Int
        public let seasons: Int
        public let episodes: Int
    }
    
    public struct NotFound: CodableEquatable {
        public let movies: [ID]
        public let shows: [ID]
        public let seasons: [ID]
        public let episodes: [ID]
    }    
}
