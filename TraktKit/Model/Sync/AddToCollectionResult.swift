//
//  AddToCollectionResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct AddToCollectionResult: CodableEquatable {
    let added: Added
    let updated: Added
    let existing: Added
//    let notFound: NotFound

    public struct Added: CodableEquatable {
        let movies: Int
        let episodes: Int
    }
    
    public struct NotFound: CodableEquatable {
        let movies: [ID]
        let shows: [ID]
        let seasons: [ID]
        let episodes: [ID]
    }
}
