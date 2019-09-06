//
//  WatchedMovie.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct WatchedMovie: CodableEquatable {
    // Extended: Min
    public let plays: Int // Total number of plays
    public let lastWatchedAt: Date
    public let movie: Movie
}
