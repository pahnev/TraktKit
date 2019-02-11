//
//  Rating.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Rating: CodableEquatable {
    public let ratedAt: Date
    public let rating: Int
    public let type: String // TODO: What types? Add type safety.
    
    public let movie: Movie?
    public let show: Show?
    public let season: Season?
    public let episode: Episode?
}
