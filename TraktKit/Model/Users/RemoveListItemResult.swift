//
//  RemoveListItemResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct RemoveListItemResult: CodableEquatable {
    let deleted: Added
//    let notFound: NotFound

    public struct Added: CodableEquatable {
        let movies: Int
        let shows: Int
        let seasons: Int
        let episodes: Int
        let people: Int
    }
    
    public struct NotFound: CodableEquatable {
        let movies: [ID]
        let shows: [ID]
        let seasons: [ID]
        let episodes: [ID]
        let people: [ID]
    }
    
}
