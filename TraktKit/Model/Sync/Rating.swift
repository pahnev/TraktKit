//
//  Rating.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct Rating: CodableEquatable {
    public var ratedAt: Date
    public var rating: Int
    
    public var movie: Movie?
    public var show: Show?
    public var season: Season?
    public var episode: Episode?    
}
