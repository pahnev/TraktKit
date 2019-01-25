//
//  SearchResult.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct SearchResult: CodableEquatable {
    public let type: String // Can be movie, show, episode, person, list
    public let score: Double?
    
    public let movie: Movie?
    public let show: Show?
    public let episode: Episode?
    public let person: Person?
    public let list: List?
}
