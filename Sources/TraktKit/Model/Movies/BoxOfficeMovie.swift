//
//  BoxOfficeMovie.swift
//  TraktKit
//
//  Created by Kirill Pahnev on 27/07/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

public struct BoxOfficeMovie: CodableEquatable {
    // Extended: Min
    public let revenue: Int
    public let movie: Movie
}
