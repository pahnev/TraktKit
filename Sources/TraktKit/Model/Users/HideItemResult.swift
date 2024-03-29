//
//  HideItemResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct HideItemResult: CodableEquatable {
    let added: Added
//    let notFound: NotFound

    public struct Added: CodableEquatable {
        let movies: Int
        let shows: Int
        let seasons: Int
    }

    public struct NotFound: CodableEquatable {
        let movies: [ID]
        let shows: [ID]
        let seasons: [ID]

        public init(from decoder: Decoder) throws {
            movies = []
            shows = []
            seasons = []
        }
    }
}
