//
//  ListItem.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct ListItem: CodableEquatable {
    public let rank: Int
    public let listedAt: Date
    public let type: String
    public var show: Show? = nil
    public var season: Season? = nil
    public var episode: Episode? = nil
    public var movie: Movie? = nil
    public var person: Person? = nil
}
